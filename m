From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: 17 Aug 2004 00:39:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092717604.1730.921.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02F154@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31164 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268095AbUHQEkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 00:40:07 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F154@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-08-10 at 16:35, James.Smart@Emulex.Com wrote:
> Here is an updated mid-layer patch for adding a Suspend state to scsi devices. Changes were minor.
> 
> As mentioned, the goal is to insulate against temporary device disappearances that may occur due to cable pulls, switch reboots, etc. The design wants to suspend all i/o to a device, similar to the notion of scsi_block_requests - but at a device level, not a host level. As not all devices will support it - it's up to the LLDD to set a recovery template as part of slave_alloc. The template is used later when the LLDD requests to move into/outof the suspend state via the new routines scsi_device_suspend() and scsi_device_continue(). To ensure this is not an infinite condition, when a device is suspended, a timeout is started. The length of the timeout is set to the recovery value initialized by the LLDD, as it's likely driver and transport related. If the timer expires, the device is placed in the cancelled state.

OK, I looked it over.

The first thing that struck me is that you didn't use consistent comment
styles (mixture of old scsi and new docbook), and where you used the old
was actually in the middle of a section that had been converted to the
new docbook ones...

There's also this:

 extern int scsi_device_cancel(struct scsi_device *, int);
-
+int scsi_device_suspend(struct scsi_device *);
+int scsi_device_continue(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);

If the rest of the .h file uses extern in front of its function
prototypes, then the added functions should too.

Anyway I found it rather complex for what it was trying to do.  How does
the attached look instead.  It makes the exported functions scsi private
(i.e. inaccessible to anything not including scsi_priv.h) and hopefully
makes FC LLDs indirect via the correct fc_ functions.

It also does away with all the extra timeout template stuff.

I've compiled this, but not tested it on anything.

James

===== drivers/scsi/scsi.c 1.145 vs edited =====
--- 1.145/drivers/scsi/scsi.c	2004-06-19 09:38:34 -05:00
+++ edited/drivers/scsi/scsi.c	2004-08-16 22:17:44 -05:00
@@ -518,6 +518,21 @@
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
+		SCSI_LOG_MLQUEUE(3, printk("queuecommand : request to suspended device requeued\n"));
+		/* NOTE: rtn is still zero here because we don't need the
+		 * queue to be plugged on return (it's already stopped) */
+		goto out;
+	}
+
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
@@ -1100,8 +1115,8 @@
 
 /**
  * scsi_device_cancel - cancel outstanding IO to this device
- * @sdev:	pointer to struct scsi_device
- * @data:	pointer to cancel value.
+ * @sdev:	Pointer to struct scsi_device
+ * @recovery:	Boolean instructing function to recover device or not.
  *
  **/
 int scsi_device_cancel(struct scsi_device *sdev, int recovery)
===== drivers/scsi/scsi_lib.c 1.129 vs edited =====
--- 1.129/drivers/scsi/scsi_lib.c	2004-06-19 09:40:25 -05:00
+++ edited/drivers/scsi/scsi_lib.c	2004-08-16 23:30:54 -05:00
@@ -1584,6 +1584,7 @@
 		case SDEV_CREATED:
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
+		case SDEV_SUSPEND:
 			break;
 		default:
 			goto illegal;
@@ -1611,11 +1612,22 @@
 		}
 		break;
 
+	case SDEV_SUSPEND:
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_RUNNING:
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
 			break;
 		default:
 			goto illegal;
@@ -1630,7 +1642,6 @@
 			goto illegal;
 		}
 		break;
-
 	}
 	sdev->sdev_state = state;
 	return 0;
@@ -1694,3 +1705,121 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+/**
+ * scsi_timeout_suspended_sdev - Timeout handler for suspended scsi devices
+ *				 that fail to recover in the alloted time.
+ * @data:	scsi device that failed to reappear in the alloted time.
+ **/
+static void scsi_timeout_suspended_sdev(unsigned long data)
+{
+	struct scsi_device *sdev = (struct scsi_device *)data;
+
+	dev_printk(KERN_ERR, &sdev->sdev_gendev, "suspend timed out: device resuming\n");
+
+	/* set the device going again ... if we haven't been resumed
+	 * this will probably result in I/O errors if the host still
+	 * isn't ready */
+	scsi_internal_device_continue(sdev, NULL);
+}
+
+
+/**
+ * scsi_internal_device_suspend - internal function to put a device
+ *				  temporarily into the SDEV_SUSPEND state
+ * @sdev:	device to suspend
+ * @timer:	pointer to a timer to use for the resume timeout
+ * @timeout:	timeout in HZ
+ *
+ * Suspend request made by scsi lld's to temporarily stop all
+ * scsi commands on the specified device.  Called from interrupt
+ * or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	This routine transitions the device to the SDEV_SUSPEND state
+ *	(which must be a legal transition).  When the device is in this
+ *	state, all commands are deferred until the scsi lld reenables
+ *	the device with scsi_device_continue or device_suspend_tmo fires.
+ *	This routine assumes no locks are held upon entry.
+ **/
+int
+scsi_internal_device_suspend(struct scsi_device *sdev,
+			     struct timer_list *timer, int timeout)
+{
+	request_queue_t *q = sdev->request_queue;
+	unsigned long flags;
+
+	if (timeout < 0 || timeout > SCSI_DEVICE_SUSPEND_MAX_TIMEOUT)
+		return -EINVAL;
+
+	if (scsi_device_set_state(sdev, SDEV_SUSPEND) != 0)
+		return -EINVAL;
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
+	 * Start timing the suspend.  The scsi lld is only allowed to
+	 * suspend for the timeout.
+	 */
+	init_timer(timer);
+	timer->data = (unsigned long)sdev;
+	timer->expires = jiffies + timeout;
+	timer->function = scsi_timeout_suspended_sdev;
+	add_timer(timer);
+	return 0;
+}
+EXPORT_SYMBOL(scsi_internal_device_suspend);
+
+/**
+ * scsi_device_continue - resume a device after a suspend
+ * @sdev:	device to resume
+ * @timer:	pointer to suspend timer (may be NULL)
+ *
+ * Called by scsi lld's or the midlayer to restart the device queue
+ * for the previously suspended scsi device.  Called from interrupt or
+ * normal process context.
+ *
+ * Returns zero if successful or error if not.
+ *
+ * Notes:       
+ *	This routine transitions the device to the SDEV_RUNNING state
+ *	(which must be a legal transition) allowing the midlayer to
+ *	goose the queue for this device.  This routine assumes no locks
+ *	are held upon entry.
+ **/
+int
+scsi_internal_device_continue(struct scsi_device *sdev,
+			      struct timer_list *timer)
+{
+	request_queue_t *q = sdev->request_queue; 
+	int err;
+	unsigned long flags;
+	
+	/* Stop the scsi device timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction.
+	 */
+	if (timer)
+		del_timer_sync(timer);
+
+	/* Try to transition the scsi device to SDEV_RUNNING
+	 * and goose the device queue if successful.  
+	 */
+	if ((err = scsi_device_set_state(sdev, SDEV_RUNNING)))
+		return err;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_internal_device_continue);
===== drivers/scsi/scsi_priv.h 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi_priv.h	2004-06-16 10:45:44 -05:00
+++ edited/drivers/scsi/scsi_priv.h	2004-08-16 23:03:09 -05:00
@@ -161,4 +161,13 @@
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
+/* internal scsi timeout functions: for use by mid-layer and transport
+ * classes */
+
+#define SCSI_DEVICE_SUSPEND_MAX_TIMEOUT	(HZ*10)
+extern int scsi_internal_device_suspend(struct scsi_device *sdev,
+					struct timer_list *timer, int timeout);
+extern int scsi_internal_device_continue(struct scsi_device *sdev,
+					 struct timer_list *timer);
+
 #endif /* _SCSI_PRIV_H */
===== drivers/scsi/scsi_sysfs.c 1.52 vs edited =====
--- 1.52/drivers/scsi/scsi_sysfs.c	2004-07-28 22:59:10 -05:00
+++ edited/drivers/scsi/scsi_sysfs.c	2004-08-16 22:05:04 -05:00
@@ -30,6 +30,7 @@
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_SUSPEND,	"suspend" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
===== drivers/scsi/scsi_transport_fc.c 1.3 vs edited =====
--- 1.3/drivers/scsi/scsi_transport_fc.c	2004-03-29 03:19:12 -06:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2004-08-16 23:32:50 -05:00
@@ -24,11 +24,13 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include "scsi_priv.h"
+
 #define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
 
 static void transport_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
 				 * attributes */
 
@@ -61,11 +63,14 @@
 
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
@@ -125,6 +130,7 @@
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
+fc_transport_rw_attr(nodevice_tmo, "%d\n");
 
 #define SETUP_ATTRIBUTE_RD(field)				\
 	i->private_attrs[count] = class_device_attr_##field;	\
@@ -165,6 +171,7 @@
 	SETUP_ATTRIBUTE_RD(port_id);
 	SETUP_ATTRIBUTE_RD(port_name);
 	SETUP_ATTRIBUTE_RD(node_name);
+	SETUP_ATTRIBUTE_RW(nodevice_tmo);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
@@ -183,6 +190,19 @@
 	kfree(i);
 }
 EXPORT_SYMBOL(fc_release_transport);
+
+int fc_device_suspend(struct scsi_device *sdev)
+{
+	return scsi_internal_device_suspend(sdev, &fc_suspend_timer(sdev),
+					    fc_nodevice_tmo(sdev));
+}
+EXPORT_SYMBOL(fc_device_suspend);
+
+int fc_device_continue(struct scsi_device *sdev)
+{
+	return scsi_internal_device_continue(sdev, &fc_suspend_timer(sdev));
+}
+EXPORT_SYMBOL(fc_device_continue);
 

 MODULE_AUTHOR("Martin Hicks");
===== include/scsi/scsi_device.h 1.19 vs edited =====
--- 1.19/include/scsi/scsi_device.h	2004-07-07 11:24:13 -05:00
+++ edited/include/scsi/scsi_device.h	2004-08-16 23:01:28 -05:00
@@ -30,6 +30,9 @@
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_SUSPEND,		/* Device suspended by scsi lld.  No block 
+				 * commands from user and midlayer should be issued
+				 * to the scsi lld. */
 };
 
 struct scsi_device {
===== include/scsi/scsi_transport_fc.h 1.2 vs edited =====
--- 1.2/include/scsi/scsi_transport_fc.h	2004-03-22 04:33:42 -06:00
+++ edited/include/scsi/scsi_transport_fc.h	2004-08-16 23:32:33 -05:00
@@ -26,20 +26,28 @@
 
 struct fc_transport_attrs {
 	int port_id;
+	int nodevice_tmo;
 	uint64_t node_name;
 	uint64_t port_name;
+	struct timer_list suspend_timer;
 };
 
 /* accessor functions */
 #define fc_port_id(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_id)
 #define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->node_name)
 #define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_name)
+#define fc_nodevice_tmo(x) (((struct fc_transport_attrs *)&(x)->transport_data)->nodevice_tmo)
+#define fc_suspend_timer(x) (((struct fc_transport_attrs *)&(x)->transport_data)->suspend_timer)
+
 
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
@@ -47,6 +55,7 @@
 	unsigned long	show_port_id:1;
 	unsigned long	show_node_name:1;
 	unsigned long	show_port_name:1;
+	unsigned long   show_nodevice_tmo:1;
 	/* Private Attributes */
 };
 

