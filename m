From: James.Smart@Emulex.Com
Subject: [PATCH] updated: suspending I/Os to a device
Date: Wed, 1 Sep 2004 15:30:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F19C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23433 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267394AbUIATaV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:30:21 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, James.Bottomley@SteelEye.com

Here's the updated patch based on further discussion on the list:

This patch:

- Adds a new sdev state - SDEV_BLOCKED.
- Adds new internal sdev routines to block, unblock, and to unblock on timeout
- Adds a new fc transport attribute for the sdev - dev_loss_tmo
- Adds fc transport routines to block/unblock at the sdev, target, and host levels. Timer will be started at whatever level invoked. Timeout value gleaned from the attribute on the sdev, or 1st sdev on the target/host.

-- James






Signed-off-by: James Smart <james.smart@emulex.com>


diff -uNr clean_kernel_2.6.7/drivers/scsi/scsi.c patched_kernel_2.6.7/drivers/scsi/scsi.c
--- clean_kernel_2.6.7/drivers/scsi/scsi.c	2004-07-19 13:04:44.000000000 -0400
+++ patched_kernel_2.6.7/drivers/scsi/scsi.c	2004-09-02 10:23:22.000000000 -0400
@@ -512,6 +512,21 @@
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
+
+	/* Check to see if the scsi lld put this device into blocked state. */
+	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK)) {
+		/* in SDEV_BLOCK, the command is just put back on the device
+		 * queue.  The suspend state has already blocked the queue so
+		 * future requests should not occur until the device 
+		 * transitions out of the suspend state.
+		 */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		SCSI_LOG_MLQUEUE(3, printk("queuecommand : request to blocked device requeued\n"));
+		/* NOTE: rtn is still zero here because we don't need the
+		 * queue to be plugged on return (it's already stopped) */
+		goto out;
+	}
+
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
@@ -1088,8 +1103,8 @@
 
 /**
  * scsi_device_cancel - cancel outstanding IO to this device
- * @sdev:	pointer to struct scsi_device
- * @data:	pointer to cancel value.
+ * @sdev:	Pointer to struct scsi_device
+ * @recovery:	Boolean instructing function to recover device or not.
  *
  **/
 int scsi_device_cancel(struct scsi_device *sdev, int recovery)
diff -uNr clean_kernel_2.6.7/drivers/scsi/scsi_lib.c patched_kernel_2.6.7/drivers/scsi/scsi_lib.c
--- clean_kernel_2.6.7/drivers/scsi/scsi_lib.c	2004-07-19 13:04:44.000000000 -0400
+++ patched_kernel_2.6.7/drivers/scsi/scsi_lib.c	2004-09-01 13:43:39.000000000 -0400
@@ -1581,6 +1581,7 @@
 		case SDEV_CREATED:
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -1608,11 +1609,22 @@
 		}
 		break;
 
+	case SDEV_BLOCK:
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
+		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -1691,3 +1703,121 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+/**
+ * scsi_timeout_blocked_sdev - Timeout handler for blocked scsi devices
+ *				 that fail to recover in the alloted time.
+ * @data:	scsi device that failed to reappear in the alloted time.
+ **/
+static void scsi_timeout_blocked_sdev(unsigned long data)
+{
+	struct scsi_device *sdev = (struct scsi_device *)data;
+
+	dev_printk(KERN_ERR, &sdev->sdev_gendev, 
+		"blocked device time out: device resuming\n");
+
+	/* set the device going again ... if we haven't been resumed
+	 * this will probably result in I/O errors if the host still
+	 * isn't ready */
+	scsi_internal_device_unblock(sdev, NULL);
+}
+
+/**
+ * scsi_internal_device_block - internal function to put a device
+ *				temporarily into the SDEV_BLOCK state
+ * @sdev:	device to block
+ * @timer:	pointer to a timer to use for the resume timeout (may be NULL).
+ * @timeout:	timeout in HZ
+ *
+ * Block request made by scsi lld's to temporarily stop all
+ * scsi commands on the specified device.  Called from interrupt
+ * or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	This routine transitions the device to the SDEV_BLOCK state
+ *	(which must be a legal transition).  When the device is in this
+ *	state, all commands are deferred until the scsi lld reenables
+ *	the device with scsi_device_unblock or device_block_tmo fires.
+ *	This routine assumes no locks are held upon entry.
+ **/
+int
+scsi_internal_device_block(struct scsi_device *sdev,
+			     struct timer_list *timer, int timeout)
+{
+	request_queue_t *q = sdev->request_queue;
+	unsigned long flags;
+
+	if (timer) {
+		if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+			return -EINVAL;
+	}
+
+	if (scsi_device_set_state(sdev, SDEV_BLOCK) != 0)
+		return -EINVAL;
+
+	/* The device has transitioned to SDEV_BLOCK.  Stop the
+	 * block layer from calling the midlayer with this device's
+	 * request queue. */
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	/* The scsi lld is only allowed to block the device for the specified
+	 * timeout. */
+	if (timer) {
+		init_timer(timer);
+		timer->data = (unsigned long)sdev;
+		timer->expires = jiffies + timeout;
+		timer->function = scsi_timeout_blocked_sdev;
+		add_timer(timer);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_internal_device_block);
+
+/**
+ * scsi_internal_device_unblock - resume a device after a block request
+ * @sdev:	device to resume
+ * @timer:	pointer to block timer (may be NULL)
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
+scsi_internal_device_unblock(struct scsi_device *sdev,
+			     struct timer_list *timer)
+{
+	request_queue_t *q = sdev->request_queue; 
+	int err;
+	unsigned long flags;
+	
+	/* Stop the scsi device timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. */
+	if (timer)
+		del_timer_sync(timer);
+
+	/* Try to transition the scsi device to SDEV_RUNNING
+	 * and goose the device queue if successful.  */
+	err = scsi_device_set_state(sdev, SDEV_RUNNING);
+	if (err)
+		return err;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_internal_device_unblock);
diff -uNr clean_kernel_2.6.7/drivers/scsi/scsi_priv.h patched_kernel_2.6.7/drivers/scsi/scsi_priv.h
--- clean_kernel_2.6.7/drivers/scsi/scsi_priv.h	2004-07-19 13:04:45.000000000 -0400
+++ patched_kernel_2.6.7/drivers/scsi/scsi_priv.h	2004-08-31 11:10:37.000000000 -0400
@@ -160,4 +160,13 @@
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
+/* internal scsi timeout functions: for use by mid-layer and transport
+ * classes */
+
+#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	(HZ*60)
+extern int scsi_internal_device_block(struct scsi_device *sdev,
+					struct timer_list *timer, int timeout);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev,
+					struct timer_list *timer);
+
 #endif /* _SCSI_PRIV_H */
diff -uNr clean_kernel_2.6.7/drivers/scsi/scsi_sysfs.c patched_kernel_2.6.7/drivers/scsi/scsi_sysfs.c
--- clean_kernel_2.6.7/drivers/scsi/scsi_sysfs.c	2004-07-19 13:04:43.000000000 -0400
+++ patched_kernel_2.6.7/drivers/scsi/scsi_sysfs.c	2004-09-02 10:31:31.000000000 -0400
@@ -29,6 +29,7 @@
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_BLOCK,	"blocked" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
diff -uNr clean_kernel_2.6.7/drivers/scsi/scsi_transport_fc.c patched_kernel_2.6.7/drivers/scsi/scsi_transport_fc.c
--- clean_kernel_2.6.7/drivers/scsi/scsi_transport_fc.c	2004-07-19 13:04:47.000000000 -0400
+++ patched_kernel_2.6.7/drivers/scsi/scsi_transport_fc.c	2004-09-02 11:07:12.000000000 -0400
@@ -23,12 +23,13 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
+#include "scsi_priv.h"
 
 #define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
 
 static void transport_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
 				 * attributes */
 
@@ -66,6 +67,7 @@
 	fc_node_name(sdev) = -1;
 	fc_port_name(sdev) = -1;
 	fc_port_id(sdev) = -1;
+	fc_dev_loss_tmo(sdev) = -1;
 
 	return 0;
 }
@@ -125,6 +127,7 @@
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
+fc_transport_rw_attr(dev_loss_tmo, "%d\n");
 
 #define SETUP_ATTRIBUTE_RD(field)				\
 	i->private_attrs[count] = class_device_attr_##field;	\
@@ -165,6 +168,7 @@
 	SETUP_ATTRIBUTE_RD(port_id);
 	SETUP_ATTRIBUTE_RD(port_name);
 	SETUP_ATTRIBUTE_RD(node_name);
+	SETUP_ATTRIBUTE_RW(dev_loss_tmo);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
@@ -185,6 +189,292 @@
 EXPORT_SYMBOL(fc_release_transport);
 
 
+int fc_device_block(struct scsi_device *sdev, struct timer_list *timer)
+{
+	return scsi_internal_device_block(sdev, timer, (fc_dev_loss_tmo(sdev) * HZ));
+}
+EXPORT_SYMBOL(fc_device_block);
+
+int fc_device_unblock(struct scsi_device *sdev, struct timer_list *timer)
+{
+	return scsi_internal_device_unblock(sdev, timer);
+}
+EXPORT_SYMBOL(fc_device_unblock);
+
+/**
+ * fc_timeout_blocked_tgt - Timeout handler for blocked scsi targets
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi device managed by the target that failed to reappear
+ *		in the alloted time.
+ **/
+static void fc_timeout_blocked_tgt(unsigned long data)
+{
+	struct scsi_device *tgt_sdev = (struct scsi_device *)data;
+	struct Scsi_Host *shost = tgt_sdev->host;
+	struct scsi_device *sdev;
+
+	dev_printk(KERN_ERR, &tgt_sdev->sdev_gendev, 
+		"blocked target time out: target resuming\n");
+
+	__shost_for_each_device(sdev, shost) {
+		if (sdev->id == tgt_sdev->id) {
+			/* set the device going again ... if the scsi lld didn't
+			 * unblock this device, then IO errors will probably
+			 * result if the host still isn't ready */
+			scsi_internal_device_unblock(sdev, NULL);
+		}
+	}
+}
+
+/**
+ * fc_timeout_blocked_host - Timeout handler for blocked scsi hosts
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi host originating the block that failed to recover its
+ *		devices in the alloted time.
+ **/
+static void fc_timeout_blocked_host(unsigned long data)
+{
+	struct Scsi_Host *shost = (struct scsi_host *)data;
+	struct scsi_device *sdev;
+
+	dev_printk(KERN_ERR, &shost->shost_gendev, 
+		"blocked host time out: host resuming\n");
+
+	__shost_for_each_device(sdev, shost) {
+		/* set the device going again ... if the scsi lld didn't
+		 * unblock this device, then IO errors will probably
+		 * result if the host still isn't ready */
+		scsi_internal_device_unblock(sdev, NULL);
+	}
+}
+
+/**
+ * fc_target_block - Fibre Channel Transport function to put a target
+ *		temporarily into the SDEV_BLOCK state.
+ * @sdev:	device managed by target providing target id.
+ * @timer:	pointer to a timer to use for the target timeout.
+ *		the timer is initialized and managed by the midlayer.
+ *		This timer may not be NULL.
+ *
+ * Target block request made by scsi lld's to temporarily stop all
+ * scsi commands to all devices managed by this target id.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	This routine requires the caller to pass a timer pointer
+ *	for the timeout mechanism.  The caller is responsible for
+ *	all memory management of the timer pointer.  The timeout
+ *	value is extracted from the fc transport attributes for
+ *	the first scsi device found with the correct target id.
+ *	Although this routine depends on the scsi_internal_device_block
+ *	routine to handle device state transitions, the timer
+ *	control is handled in this module.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int fc_target_block(struct scsi_device *sdev, struct timer_list *timer)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *tmp_sdev = NULL;
+	int tgt_cnt = 0, err = 0, timeout = fc_dev_loss_tmo(sdev);
+
+	if (!timer)
+		return -EINVAL;
+
+	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+			return -EINVAL;
+
+	__shost_for_each_device(tmp_sdev, shost) {
+		if (tmp_sdev->id == sdev->id) {
+			err = scsi_internal_device_block(tmp_sdev, NULL, 0);
+			if (err)
+				return err;
+			else
+				tgt_cnt++;
+		}
+	}
+
+	if (!tgt_cnt) {
+		/* This condition should never be true, however, if so, just
+		 * fail the block request. */
+		dev_printk(KERN_ERR, &sdev->sdev_gendev, 
+			"Host %d has no devices matching target id %d\n",
+			shost->host_no, sdev->id);
+		return -EINVAL;
+	}
+
+
+	/* The scsi lld is only allowed to block this target for the timeout. */
+	init_timer(timer);
+	timer->data = (unsigned long)sdev;
+	timer->expires = jiffies + (timeout * HZ);
+	timer->function = fc_timeout_blocked_tgt;
+	add_timer(timer);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_target_block);
+
+/**
+ * fc_target_unblock - unblock a target following a fc_target_block request.
+ * @sdev:	device managed by target providing target id.
+ * @timer:	timer pointer previously passed to fc_target_block.  This
+ *		timer may not be NULL.
+ *
+ * Called by scsi lld's to restart all devices associated with a particular
+ * target id following a fc_target_block request.  The scsi lld makes this
+ * call to unblock each device queue and restart IO.  Called from interrupt
+ * or normal process context.
+ *
+ * Returns zero if successful or error if not.
+ *
+ * Notes:       
+ *	This routine requires the caller to pass the timer pointer used 
+ *	in the previous fc_target_block call back to this routine.  This 
+ *	routine assumes no locks are held on entry.
+ **/
+int fc_target_unblock(struct scsi_device *sdev, struct timer_list *timer)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *tmp_sdev;
+	int err = 0;
+
+	/* Stop the target timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. */
+	if (!timer)
+		return -EINVAL;
+
+	del_timer_sync(timer);
+
+	/* Block each device matching the caller's target id. */
+	__shost_for_each_device(tmp_sdev, shost) {
+		if (tmp_sdev->id == sdev->id) {
+			err = scsi_internal_device_unblock(tmp_sdev, NULL);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_target_unblock);
+
+/**
+ * fc_host_block - Fibre Channel Transport function to put all devices
+ *		managed by the calling host temporarily into the SDEV_BLOCK
+ *		state.
+ * @shost:	scsi host pointer that contains all scsi device siblings.
+ * @timer:	pointer to a timer to use for the host timeout.
+ *		the timer is initialized and managed by the midlayer.
+ *
+ * Host block request made by scsi lld's to temporarily stop all
+ * scsi commands to all devices managed by this host.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	This routine requires the caller to pass a timer pointer
+ *	for the timeout mechanism.  The caller is responsible for
+ *	all memory management of the timer pointer.  The timeout
+ *	value is extracted from the fc transport attributes for
+ *	the first scsi device found on the specified scsi host.
+ *	Although this routine depends on the scsi_internal_device_block
+ *	routine to handle device state transitions, the timer
+ *	control is handled in this module.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int fc_host_block(struct Scsi_Host *shost, struct timer_list *timer)
+{
+	struct scsi_device *sdev, *tmp_sdev = NULL;
+	int err = 0, timeout = -1;
+
+	if (!timer)
+		return -EINVAL;
+
+	/* Find the first device and validate the timeout value.  All devices
+	 * managed by this host are timed using the transport 
+	 * dev_loss_tmo timeout. */
+	__shost_for_each_device(sdev, shost) {
+		tmp_sdev = sdev;
+		timeout = fc_dev_loss_tmo(sdev);
+		if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT) {
+			return -EINVAL;
+		} else {
+			break;
+		}
+	}
+	
+	if (!tmp_sdev) {
+		/* This condition should never be true, however, if so, just
+		 * fail the block request. */
+		dev_printk(KERN_ERR, &sdev->sdev_gendev, 
+			"Host %d has no attached devices!  Block failed.\n",
+			shost->host_no);
+		return -EINVAL;
+	}
+
+	__shost_for_each_device(sdev, shost) {
+		err = scsi_internal_device_block(sdev, NULL, 0);
+		if (err)
+			return err;
+	}
+
+	/* The scsi lld is only allowed to block this host for the timeout. */
+	init_timer(timer);
+	timer->data = (unsigned long)shost;
+	timer->expires = jiffies + timeout * HZ;
+	timer->function = fc_timeout_blocked_host;
+	add_timer(timer);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_host_block);
+
+/**
+ * fc_host_unblock - unblock all devices managed by this host following a 
+ *		fc_host_block request.
+ * @shost:	scsi host containing all scsi device siblings to unblock.
+ * @timer:	timer pointer previously passed to fc_host_block.  This
+ *		timer may not be NULL.
+ *
+ * Called by scsi lld's to restart all scsi devices managed by the specified
+ * scsi host follwoing an fc_host_block request.  The scsi lld makes this
+ * call to unblock each device queue and restart IO.  Called from interrupt
+ * or normal process context.
+ *
+ * Returns zero if successful or error if not.
+ *
+ * Notes:       
+ *	This routine requires the caller to pass the timer pointer used 
+ *	in the previous fc_host_block call back to this routine.  This 
+ *	routine assumes no locks are held on entry.
+ **/
+int fc_host_unblock(struct Scsi_Host *shost, struct timer_list *timer)
+{
+	struct scsi_device *sdev;
+	int err = 0;
+	
+	/* Stop the host timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. */
+	if (!timer)
+		return -EINVAL;
+
+	del_timer_sync(timer);
+
+	__shost_for_each_device(sdev, shost) {
+		err = scsi_internal_device_unblock(sdev, NULL);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_host_unblock);
+
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
diff -uNr clean_kernel_2.6.7/include/scsi/scsi_device.h patched_kernel_2.6.7/include/scsi/scsi_device.h
--- clean_kernel_2.6.7/include/scsi/scsi_device.h	2004-07-19 13:05:49.000000000 -0400
+++ patched_kernel_2.6.7/include/scsi/scsi_device.h	2004-09-01 11:37:12.000000000 -0400
@@ -30,6 +30,9 @@
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
+				 * commands from user or midlayer should be issued
+				 * to the scsi lld. */
 };
 
 struct scsi_device {
diff -uNr clean_kernel_2.6.7/include/scsi/scsi_transport_fc.h patched_kernel_2.6.7/include/scsi/scsi_transport_fc.h
--- clean_kernel_2.6.7/include/scsi/scsi_transport_fc.h	2004-07-19 13:05:49.000000000 -0400
+++ patched_kernel_2.6.7/include/scsi/scsi_transport_fc.h	2004-09-01 11:23:58.000000000 -0400
@@ -26,6 +26,7 @@
 
 struct fc_transport_attrs {
 	int port_id;
+	int dev_loss_tmo;	/* Device loss timeout value in seconds. */
 	uint64_t node_name;
 	uint64_t port_name;
 };
@@ -34,12 +35,16 @@
 #define fc_port_id(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_id)
 #define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->node_name)
 #define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->transport_data)->port_name)
+#define fc_dev_loss_tmo(x) (((struct fc_transport_attrs *)&(x)->transport_data)->dev_loss_tmo)
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
 	void 	(*get_port_id)(struct scsi_device *);
 	void	(*get_node_name)(struct scsi_device *);
 	void	(*get_port_name)(struct scsi_device *);
+	void    (*get_dev_loss_tmo)(struct scsi_device *);
+	void	(*set_dev_loss_tmo)(struct scsi_device *, uint32_t);
+
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
@@ -47,10 +52,16 @@
 	unsigned long	show_port_id:1;
 	unsigned long	show_node_name:1;
 	unsigned long	show_port_name:1;
+	unsigned long   show_dev_loss_tmo:1;
 	/* Private Attributes */
 };
 
 struct scsi_transport_template *fc_attach_transport(struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
+int fc_target_block(struct scsi_device *sdev, struct timer_list *timer);
+int fc_target_unblock(struct scsi_device *sdev, struct timer_list *timer);
+int fc_host_block(struct Scsi_Host *shost, struct timer_list *timer);
+int fc_host_unblock(struct Scsi_Host *shost, struct timer_list *timer);
 
 #endif /* SCSI_TRANSPORT_FC_H */
+
