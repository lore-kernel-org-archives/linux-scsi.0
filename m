From: James.Smart@Emulex.Com
Subject: [PATCH] updated: suspending I/Os to a device
Date: Tue, 10 Aug 2004 16:35:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F154@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:12464 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267722AbUHJUfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 16:35:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i7AKZ6gI022134
	for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2004 13:35:06 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is an updated mid-layer patch for adding a Suspend state to scsi devices. Changes were minor.

As mentioned, the goal is to insulate against temporary device disappearances that may occur due to cable pulls, switch reboots, etc. The design wants to suspend all i/o to a device, similar to the notion of scsi_block_requests - but at a device level, not a host level. As not all devices will support it - it's up to the LLDD to set a recovery template as part of slave_alloc. The template is used later when the LLDD requests to move into/outof the suspend state via the new routines scsi_device_suspend() and scsi_device_continue(). To ensure this is not an infinite condition, when a device is suspended, a timeout is started. The length of the timeout is set to the recovery value initialized by the LLDD, as it's likely driver and transport related. If the timer expires, the device is placed in the cancelled state.

Thanks...

-- James S



Signed-off-by: James Smart <james.smart@emulex.com>


diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi.c changed_kernel_2_6_7/drivers/scsi/scsi.c
--- clean_kernel_2_6_7/drivers/scsi/scsi.c	2004-07-19 13:04:44.898201000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi.c	2004-08-04 11:57:16.665960000 -0400
@@ -512,6 +512,19 @@
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
+
+	/* Check to see if the scsi lld put this device into suspend. */
+	if (unlikely(cmd->device->sdev_state == SDEV_SUSPEND)) {
+		/* in SDEV_SUSPEND, the command is just put back on the device
+		 * queue.  The suspend state has already blocked the queue so
+		 * future requests should not occur until the device 
+		 * transitions out of the suspend state.
+		 */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		SCSI_LOG_MLQUEUE(3, printk("queuecommand : request rejected\n"));
+		goto out;
+	}
+
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
@@ -1088,8 +1101,8 @@
 
 /**
  * scsi_device_cancel - cancel outstanding IO to this device
- * @sdev:	pointer to struct scsi_device
- * @data:	pointer to cancel value.
+ * @sdev:	Pointer to struct scsi_device
+ * @recovery:	Boolean instructing function to recover device or not.
  *
  **/
 int scsi_device_cancel(struct scsi_device *sdev, int recovery)
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_error.c changed_kernel_2_6_7/drivers/scsi/scsi_error.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_error.c	2004-07-23 15:46:15.061800000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_error.c	2004-08-10 14:58:29.246640000 -0400
@@ -24,6 +24,7 @@
 #include <linux/blkdev.h>
 #include <linux/smp_lock.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_transport.h>
 
 #include "scsi.h"
 #include "hosts.h"
@@ -155,6 +156,79 @@
 }
 
 /**
+ * scsi_add_sdev_timer - Start a timer for a scsi device that
+ *			 has been suspened by the scsi lld.
+ * @scmd:	scsi device to start timing.
+ * @timeout:	amount of time this device has to recover.
+ * @complete:	timeout function to call if timer isn't cancelled.
+ *
+ * Notes:
+ *	The scsi device is given a limited amount of time to
+ *	call scsi_device_continue and cancel this timer.  If the
+ *	scsi lld does not call in time, the device transitions 
+ *	to the cancel state.
+ *
+ * Returns:
+ *	None.
+ **/
+void scsi_add_sdev_timer(struct scsi_device *sdev, int timeout,
+			 void (*complete)(struct scsi_device *))
+{
+	/*
+	 * If the clock was already running for this command, then
+	 * first delete the timer.  The timer handling code gets rather
+	 * confused if we don't do this.
+	 */
+	if (sdev->device_recovert) {
+		if (sdev->device_recovert->eh_nodev_timeout.function)
+			del_timer(&sdev->device_recovert->eh_nodev_timeout);
+
+		sdev->device_recovert->eh_nodev_timeout.data = (unsigned long) sdev;
+		sdev->device_recovert->eh_nodev_timeout.expires = jiffies + timeout;
+		sdev->device_recovert->eh_nodev_timeout.function = (void (*)(unsigned long)) complete;
+
+		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: sdev: %p, time:"
+			" %d, (%p)\n", __FUNCTION__, sdev, timeout, complete));
+
+		add_timer(&sdev->device_recovert->eh_nodev_timeout);
+	}
+}
+
+/**
+ * scsi_delete_sdev_timer - Cancel timer for a given scsi device that was
+ *			    previously suspended.
+ *
+ * @sdev:	Scsi device on which to cancel the timer.
+ *
+ * Notes:
+ *	The scsi device is guaranteed to have recovered if this call
+ *	executes.  However, the scsi device could have recovered too
+ *	late and this routine needs to detect this scenerio.
+ *
+ * Return value:
+ *	0 if the timer function has already started to run.
+ *	1 if the timer was successfully detached.
+ *
+ **/
+int scsi_delete_sdev_timer(struct scsi_device *sdev)
+{
+	int rtn = -EACCES;
+
+	if (sdev->device_recovert) {
+		rtn = del_timer(&sdev->device_recovert->eh_nodev_timeout);
+
+		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: sdev: %p,"
+			" rtn: %d\n", __FUNCTION__, sdev, rtn));
+
+		sdev->device_recovert->eh_nodev_timeout.data = (unsigned long)NULL;
+		sdev->device_recovert->eh_nodev_timeout.function = NULL;
+	}
+
+	return rtn;
+}
+
+
+/**
  * scsi_times_out - Timeout function for normal scsi commands.
  * @scmd:	Cmd that is timing out.
  *
@@ -174,6 +248,24 @@
 }
 
 /**
+ * scsi_timeout_suspended_sdev - Timeout handler for suspended scsi devices
+ *				 that fail to recover in the alloted time.
+ * @sdev:	scsi device that failed to reappear in the alloted time.
+ **/
+void scsi_timeout_suspended_sdev(struct scsi_device *sdev)
+{
+	int rtn;
+
+	/* Cancel all IO to this device and do not attempt recovery. */
+	rtn = scsi_device_cancel(sdev, 0);
+	if (rtn) {
+		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
+					  rtn));
+	}
+}
+
+
+/**
  * scsi_block_when_processing_errors - Prevent cmds from being queued.
  * @sdev:	Device on which we are performing recovery.
  *
@@ -1196,6 +1288,7 @@
 	return;
 }
 
+
 /**
  * scsi_sleep_done - timer function for scsi_sleep
  * @sem:	semphore to signal
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_lib.c changed_kernel_2_6_7/drivers/scsi/scsi_lib.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-07-19 13:04:44.873200000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-08-06 15:29:15.911920000 -0400
@@ -18,8 +18,8 @@
 
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 #include "scsi.h"
-
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
@@ -59,6 +59,7 @@
 #undef SP
 
 
+
 /*
  * Function:    scsi_insert_special_req()
  *
@@ -1581,6 +1582,12 @@
 		case SDEV_CREATED:
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
+		case SDEV_SUSPEND:
+			printk(KERN_WARNING "scsi_device_set_state: transitioning"
+				"to SDEV_RUNNING from current state %d"
+				"on host %d channel %d id %d lun %d\n", oldstate,
+				sdev->host->host_no, sdev->channel, sdev->id, 
+				sdev->lun);
 			break;
 		default:
 			goto illegal;
@@ -1608,11 +1615,32 @@
 		}
 		break;
 
+	case SDEV_SUSPEND:
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_RUNNING:
+			printk(KERN_WARNING "scsi_device_set_state: transitioning"
+				"to SDEV_SUSPEND from current state %d"
+				"on host %d channel %d id %d lun %d\n", oldstate,
+				sdev->host->host_no, sdev->channel, sdev->id, 
+				sdev->lun);
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
 	case SDEV_CANCEL:
 		switch (oldstate) {
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
+		case SDEV_SUSPEND:
+			printk(KERN_WARNING "scsi_device_set_state: transitioning to"
+				"SDEV_CANCEL from current state %d on host %d "
+				"channel %d id %d lun %d\n", oldstate, 
+				sdev->host->host_no, sdev->channel, sdev->id, 
+				sdev->lun);
 			break;
 		default:
 			goto illegal;
@@ -1627,7 +1655,6 @@
 			goto illegal;
 		}
 		break;
-
 	}
 	sdev->sdev_state = state;
 	return 0;
@@ -1691,3 +1718,134 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+/**
+ * Function:	scsi_device_suspend()
+ *
+ * Purpose:	Suspend request made by scsi lld's to temporarily stop all
+ *		scsi commands on the specified device.  Called from interrupt
+ *		or normal process context.
+ *
+ * Arguments:	sdev:	scsi device to suspend
+ *
+ * Returns:	 0	if successful 
+ *		-1	if error
+ *		  
+ *
+ * Notes:       
+ *	This routine transitions the device to the SDEV_SUSPEND state
+ *	(which must be a legal transition).  When the device is in this
+ *	state, all commands are deferred until the scsi lld reenables
+ *	the device with scsi_device_continue or device_suspend_tmo fires.
+ *	This routine assumes no locks are held upon entry.
+ **/
+int
+scsi_device_suspend(struct scsi_device *sdev)
+{
+	request_queue_t *q = sdev->request_queue;
+	unsigned long flags;
+	int  nodev_timeout = 0;
+
+	/* Before setting the new device state, make sure the host managing this
+	 * device has a recovery attribute for the suspend timeout.
+	 */
+	if (sdev->device_recovert) {
+		if (sdev->device_recovert->nodev_timeout < 1) {
+			printk(KERN_WARNING "scsi_device_suspend: nodev_timeout"
+				"value invalid on host %d channel %d id %d" 
+				"lun %d nodev_timeout=%d\n",
+				sdev->host->host_no, sdev->channel, sdev->id, 
+				sdev->lun, sdev->device_recovert->nodev_timeout);
+		return -1;
+		}
+
+		nodev_timeout = sdev->device_recovert->nodev_timeout;
+	} else {
+		printk(KERN_WARNING "scsi_device_suspend: host %d channel %d"
+			"id %d lun %d has no recovery data available.\n",
+			sdev->host->host_no, sdev->channel, sdev->id, 
+			sdev->lun);
+		return -1;
+	}
+
+	if (scsi_device_set_state(sdev, SDEV_SUSPEND) != 0) {
+		printk(KERN_WARNING "scsi_device_suspend: state set to suspend failed"
+			"on host %d channel %d id %d lun %d state=%d\n",
+			sdev->host->host_no, sdev->channel, sdev->id, sdev->lun,
+			sdev->sdev_state);
+		return -1;
+	}
+
+	/* 
+	 * The device has transitioned to SDEV_SUSPEND.  Stop the
+	 * block layer from calling the midlayer with this device's
+	 * request queue.  
+	 */
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/*
+	 * Start timing the suspend.  The scsi lld is only allowed to suspend for
+	 * the nodev_timeout value in seconds. 
+	 */
+	scsi_add_sdev_timer(sdev, nodev_timeout, scsi_timeout_suspended_sdev);
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_suspend);
+
+/**
+ * Function:	scsi_device_continue()
+ *
+ * Purpose:	Called by scsi lld's or the midlayer to restart the device queue
+ *		for the previously suspended scsi device.  Called from
+ *		interrupt or normal process context.
+ *
+ * Arguments:	sdev:	scsi device to restart
+ *
+ * Returns:	 0	if successful 
+ *		-1	if error
+ *		  
+ *
+ * Notes:       
+ *	This routine transitions the device to the SDEV_RUNNING state
+ *	(which must be a legal transition) allowing the midlayer to
+ *	goose the queue for this device.  This routine assumes no locks
+ *	are held upon entry.
+ **/
+int
+scsi_device_continue(struct scsi_device *sdev)
+{
+	request_queue_t *q = sdev->request_queue; 
+	int err;
+	unsigned long flags;
+	
+	/* Stop the scsi device timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction.
+	 */
+	err = scsi_delete_sdev_timer(sdev);
+	if (!err) {
+		printk(KERN_WARNING "scsi_device_continue: no device timeout on" 
+			"host %d channel %d id %d lun %d state %d\n",
+			sdev->host->host_no, sdev->channel, sdev->id, sdev->lun,
+			sdev->sdev_state);
+	} 
+
+	/* Try to transition the scsi device to SDEV_RUNNING
+	 * and goose the device queue if successful.  
+	 */
+	err = scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (err) {
+		printk(KERN_WARNING "scsi_device_continue: state set to running"
+			"failed on host %d channel %d id %d lun %d state=%d\n",
+			sdev->host->host_no, sdev->channel, sdev->id, sdev->lun,
+			sdev->sdev_state);
+		return err;
+	}
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_continue);
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_priv.h changed_kernel_2_6_7/drivers/scsi/scsi_priv.h
--- clean_kernel_2_6_7/drivers/scsi/scsi_priv.h	2004-07-19 13:04:45.468202000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_priv.h	2004-07-30 17:32:15.779440000 -0400
@@ -100,6 +100,7 @@
 
 /* scsi_error.c */
 extern void scsi_times_out(struct scsi_cmnd *cmd);
+extern void scsi_timeout_suspended_sdev(struct scsi_device *sdev);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
@@ -116,6 +117,7 @@
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+extern int scsi_get_transport_info(void);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_syms.c changed_kernel_2_6_7/drivers/scsi/scsi_syms.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_syms.c	2004-07-19 13:04:44.842200000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_syms.c	2004-07-27 12:56:37.106600000 -0400
@@ -86,6 +86,8 @@
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_device_cancel);
+EXPORT_SYMBOL(scsi_device_suspend);
+EXPORT_SYMBOL(scsi_device_continue);
 
 EXPORT_SYMBOL(__scsi_mode_sense);
 EXPORT_SYMBOL(scsi_mode_sense);
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-07-19 13:04:43.644200000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-08-05 09:41:49.706920000 -0400
@@ -29,6 +29,7 @@
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_SUSPEND,	"suspend" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	2004-07-19 13:04:47.270200000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	2004-07-29 12:39:05.466520000 -0400
@@ -28,7 +28,7 @@
 
 static void transport_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
 				 * attributes */
 
@@ -61,11 +61,14 @@
 
 static int fc_setup_transport_attrs(struct scsi_device *sdev)
 {
-	/* I'm not sure what values are invalid.  We should pick some invalid
-	 * values for the defaults */
+	/*
+	 * I'm not sure what values are invalid.  We should pick some invalid
+	 * values for the defaults.
+	 */
 	fc_node_name(sdev) = -1;
 	fc_port_name(sdev) = -1;
 	fc_port_id(sdev) = -1;
+	fc_nodevice_tmo(sdev) = -1;
 
 	return 0;
 }
@@ -125,6 +128,7 @@
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
+fc_transport_rw_attr(nodevice_tmo, "%d\n");
 
 #define SETUP_ATTRIBUTE_RD(field)				\
 	i->private_attrs[count] = class_device_attr_##field;	\
@@ -165,6 +169,7 @@
 	SETUP_ATTRIBUTE_RD(port_id);
 	SETUP_ATTRIBUTE_RD(port_name);
 	SETUP_ATTRIBUTE_RD(node_name);
+	SETUP_ATTRIBUTE_RW(nodevice_tmo);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_device.h changed_kernel_2_6_7/include/scsi/scsi_device.h
--- clean_kernel_2_6_7/include/scsi/scsi_device.h	2004-07-19 13:05:49.284200000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_device.h	2004-08-04 13:36:20.854920000 -0400
@@ -30,6 +30,9 @@
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_SUSPEND,		/* Device suspended by scsi lld.  No block 
+				 * commands from user and midlayer should be issued
+				 * to the scsi lld. */
 };
 
 struct scsi_device {
@@ -99,17 +102,16 @@
 				 * this device */
 	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
 				     * because we did a bus reset. */
-	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
-	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned use_10_for_rw:1;	/* first try 10-byte read / write */
+	unsigned use_10_for_ms:1;	/* first try 10-byte mode sense/select */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
-	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
+	unsigned use_192_bytes_for_3f:1;/* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
-	unsigned allow_restart:1; /* issue START_UNIT in error handler */
+	unsigned allow_restart:1;	/* issue START_UNIT in error handler */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
-
-	unsigned int max_device_blocked; /* what device_blocked counts down from  */
+	unsigned int max_device_blocked;   /* what device_blocked counts down from */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	int timeout;
@@ -118,10 +120,11 @@
 	struct class_device	sdev_classdev;
 
 	struct class_device	transport_classdev;
-
+	struct device_recover_template	*device_recovert; /* Device recovery template. */
 	enum scsi_device_state sdev_state;
 	unsigned long		transport_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
+
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
 #define	class_to_sdev(d)	\
@@ -133,7 +136,8 @@
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
-
+int scsi_device_suspend(struct scsi_device *);
+int scsi_device_continue(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_eh.h changed_kernel_2_6_7/include/scsi/scsi_eh.h
--- clean_kernel_2_6_7/include/scsi/scsi_eh.h	2004-07-19 13:05:49.340200000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_eh.h	2004-07-27 12:54:27.578603000 -0400
@@ -4,6 +4,11 @@
 extern void scsi_add_timer(struct scsi_cmnd *, int,
 			   void (*)(struct scsi_cmnd *));
 extern int scsi_delete_timer(struct scsi_cmnd *);
+
+extern void scsi_add_sdev_timer(struct scsi_device *, int,
+				void (*complete)(struct scsi_device *));
+extern int scsi_delete_sdev_timer(struct scsi_device *sdev);
+
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h
--- clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h	2004-07-19 13:05:49.377200000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h	2004-07-29 12:39:58.053520000 -0400
@@ -26,6 +26,7 @@
 
 struct fc_transport_attrs {
 	int port_id;
+	int nodevice_tmo;
 	uint64_t node_name;
 	uint64_t port_name;
 };
@@ -34,12 +35,16 @@
 #define fc_port_id(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_id)
 #define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->node_name)
 #define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_name)
+#define fc_nodevice_tmo(x) (((struct fc_transport_attrs *)&(x)->transport_data)->nodevice_tmo)
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void 	(*get_port_id)(struct scsi_device *);
 	void	(*get_node_name)(struct scsi_device *);
 	void	(*get_port_name)(struct scsi_device *);
+	void    (*get_nodevice_tmo)(struct scsi_device *);
+	void	(*set_nodevice_tmo)(struct scsi_device *, uint32_t);
+
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
@@ -47,6 +52,7 @@
 	unsigned long	show_port_id:1;
 	unsigned long	show_node_name:1;
 	unsigned long	show_port_name:1;
+	unsigned long   show_nodevice_tmo:1;
 	/* Private Attributes */
 };
 
@@ -54,3 +60,4 @@
 void fc_release_transport(struct scsi_transport_template *);
 
 #endif /* SCSI_TRANSPORT_FC_H */
+
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_transport.h changed_kernel_2_6_7/include/scsi/scsi_transport.h
--- clean_kernel_2_6_7/include/scsi/scsi_transport.h	2004-07-19 13:05:49.363200000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_transport.h	2004-08-05 10:20:04.110923000 -0400
@@ -38,4 +38,22 @@
 	int	size;
 };
 
+/* device_recover_template:  
+ *	Scsi llds that want to take advantage of the suspend/continue device
+ *	feature allocate an instance of this data type during slave alloc.
+ *	The scsi lld sets the nodev_timeout value during slave_configure and
+ *	frees this resource in slave_destroy.
+ *
+ *	This feature is optional to scsi llds.  The midlayer detects the
+ *	presence or absence of this feature by a scsi lld by checking the
+ *	device_recovert pointer in the scsi_device instance. 
+ */
+struct device_recover_template {
+	/* Device recovery template. */
+	unsigned int nodev_timeout;		/* Device suspend timeout value
+						 * in seconds. */
+	struct timer_list eh_nodev_timeout;	/* Used to timeout the suspend 
+						 * state. */
+};
+
 #endif /* SCSI_TRANSPORT_H */
diff -uNr clean_kernel_2_6_7/Makefile changed_kernel_2_6_7/Makefile
--- clean_kernel_2_6_7/Makefile	2004-07-19 13:03:26.385200000 -0400
+++ changed_kernel_2_6_7/Makefile	2004-07-19 15:17:14.137200000 -0400
@@ -1,8 +1,8 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 7
-EXTRAVERSION =
-NAME=Zonked Quokka
+EXTRAVERSION = -pae1.358.4.3smp
+NAME=pae
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
