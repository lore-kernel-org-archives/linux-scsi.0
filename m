From: James.Smart@Emulex.Com
Subject: RE: [PATCH] updated: suspending I/Os to a device
Date: Thu, 19 Aug 2004 13:24:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02D85A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49644 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266835AbUHSRYs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 13:24:48 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

James,

Thanks for looking through this.

After considering Christoph's comments, looking at the patch, followed
by your review, we came to the conclusion that the LLDD should manage the timer:

  - Saves a lot of timers. Rather than a timer per lun, the LLDD, which
    will already have timer(s) running can best decide if there's 1 for
    the link, 1 per target, or 1 per device. This is a potential 
    1000+ vs 1 difference.

  - Cleaner, smaller implementation - that more closely mirrors
    scsi_block_requests().

  - Removes the duplicate sysfs attributes for the timer. There is likely
    always going to be 1 or more in the LLDD or transport. This removes
    the per-scsi device attribute that would have to be there too.

  - Your patch assumed the LLDD had already moved the device to a failed
    state by the time the timer had failed. May not have been the case.

The one con:
  Depends on well-behaved LLDD's to not leave the device blocked indefinitely.
  But this is no different from scsi_block_requests().


Additionally, this patch has the following differences:
  - Renamed the functions to xxx_block/unblock. The terms suspend/resume
    seem to be used in too many other places/ways. Also, it parallels
    what we're modeling - block_requests() functionality but on a device
    level.

  - Adds a parameter to unblock indicating whether the device has failed
    or not. If failed, transition is immediately to CANCEL. This should
    allow faster failure, without all the calls to the LLDD, and should
    lessen the number of error messages to the console. Our testing
    beat on the console pretty well, and our config was still rather small.

  - Removed the indirection through scsi_priv.h. This modification is not
    FC centric - so the hiding behind the transport functions seems odd.
    Leaving it would facilitate the same indirection through the other
    transports (USB, iSCSI, etc). I did leave the fc transport parameter though.    
    and all the transport additions will have to be
      

-- James S



Signed-off-by: James Smart <james.smart@emulex.com>


diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi.c changed_kernel_2_6_7/drivers/scsi/scsi.c
--- clean_kernel_2_6_7/drivers/scsi/scsi.c	2004-07-19 13:04:44.000000000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi.c	2004-08-18 15:26:09.000000000 -0400
@@ -512,6 +512,18 @@
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
+
+	/* Check to see if the scsi lld put this device into suspend. */
+	if (unlikely(cmd->device->sdev_state == SDEV_BLOCKED)) {
+		/* in SDEV_BLOCKED, the command is just put back on the device
+		 * queue.  The block state has already blocked the queue so
+		 * future requests should not occur until the device 
+		 * transitions out of the suspend state.
+		 */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		goto out;
+	}
+
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_lib.c changed_kernel_2_6_7/drivers/scsi/scsi_lib.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-07-19 13:04:44.000000000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_lib.c	2004-08-20 03:12:20.000000000 -0400
@@ -1581,6 +1581,7 @@
 		case SDEV_CREATED:
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCKED:;
 			break;
 		default:
 			goto illegal;
@@ -1608,11 +1609,22 @@
 		}
 		break;
 
+	case SDEV_BLOCKED:
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
+		case SDEV_BLOCKED:
 			break;
 		default:
 			goto illegal;
@@ -1691,3 +1703,91 @@
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
+
+/**
+ * scsi_device_block - internal function to put a device
+ *		temporarily into the SDEV_BLOCK state
+ * @sdev:	device to block
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
+ *	the device with scsi_device_continue or device_suspend_tmo fires.
+ *	This routine assumes no locks are held upon entry.
+ **/
+int
+scsi_device_block(struct scsi_device *sdev)
+{
+	request_queue_t *q = sdev->request_queue;
+	int err;
+	unsigned long flags;
+
+	err = scsi_device_set_state(sdev, SDEV_BLOCKED);
+	if (err)
+		return -EINVAL;
+
+	/* 
+	 * The device has transitioned to SDEV_BLOCK.  Stop the
+	 * block layer from calling the midlayer with this device's
+	 * request queue.  
+	 */
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_block);
+
+/**
+ * scsi_device_unblock - resume a device after a block request.
+ * @sdev:	device to resume
+ * @device_failure:  Zero if device functioning or 1 if not.
+ *
+ * Called by scsi lld's or the midlayer to restart the device queue
+ * for the previously blocked scsi device.  Called from interrupt or
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
+scsi_device_unblock(struct scsi_device *sdev, uint device_failure)
+{
+	request_queue_t *q = sdev->request_queue; 
+	int err;
+	unsigned long flags;
+
+	if (!device_failure) {
+		err = scsi_device_set_state (sdev, SDEV_RUNNING);
+	} else {
+		err = scsi_device_cancel(sdev, 0);
+	}
+	if (err)
+		return -EINVAL;
+
+	/* 
+	 * The device has transitioned either to SDEV_CANCEL or
+	 * SDEV_RUNNING.  Goose the device queue to drain all
+	 * outstanding commands.
+	 */
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_unblock);
+
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_syms.c changed_kernel_2_6_7/drivers/scsi/scsi_syms.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_syms.c	2004-07-19 13:04:44.000000000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_syms.c	2004-08-18 15:15:58.000000000 -0400
@@ -86,7 +86,8 @@
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
 EXPORT_SYMBOL(scsi_device_cancel);
-
+EXPORT_SYMBOL(scsi_device_block);
+EXPORT_SYMBOL(scsi_device_unblock);
 EXPORT_SYMBOL(__scsi_mode_sense);
 EXPORT_SYMBOL(scsi_mode_sense);
 
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-07-19 13:04:43.000000000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_sysfs.c	2004-08-16 12:57:40.000000000 -0400
@@ -29,6 +29,7 @@
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_BLOCKED,	"blocked" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
diff -uNr clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c
--- clean_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	2004-07-19 13:04:47.000000000 -0400
+++ changed_kernel_2_6_7/drivers/scsi/scsi_transport_fc.c	2004-08-18 15:16:55.000000000 -0400
@@ -28,7 +28,7 @@
 
 static void transport_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
 				 * attributes */
 
@@ -66,6 +66,7 @@
 	fc_node_name(sdev) = -1;
 	fc_port_name(sdev) = -1;
 	fc_port_id(sdev) = -1;
+	fc_nodevice_tmo(sdev) = -1;
 
 	return 0;
 }
@@ -125,6 +126,7 @@
 fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
 fc_transport_rd_attr(port_id, "0x%06x\n");
+fc_transport_rw_attr(nodevice_tmo, "%d\n");
 
 #define SETUP_ATTRIBUTE_RD(field)				\
 	i->private_attrs[count] = class_device_attr_##field;	\
@@ -165,6 +167,7 @@
 	SETUP_ATTRIBUTE_RD(port_id);
 	SETUP_ATTRIBUTE_RD(port_name);
 	SETUP_ATTRIBUTE_RD(node_name);
+	SETUP_ATTRIBUTE_RW(nodevice_tmo);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_device.h changed_kernel_2_6_7/include/scsi/scsi_device.h
--- clean_kernel_2_6_7/include/scsi/scsi_device.h	2004-07-19 13:05:49.000000000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_device.h	2004-08-18 15:06:06.000000000 -0400
@@ -30,6 +30,9 @@
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_BLOCKED,		/* Device blocked by scsi lld.  No scsi 
+				 * commands from user and midlayer should be issued
+				 * to the scsi lld. */
 };
 
 struct scsi_device {
@@ -133,7 +136,8 @@
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
-
+extern int scsi_device_block(struct scsi_device *);
+extern int scsi_device_unblock(struct scsi_device *, uint);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
diff -uNr clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h
--- clean_kernel_2_6_7/include/scsi/scsi_transport_fc.h	2004-07-19 13:05:49.000000000 -0400
+++ changed_kernel_2_6_7/include/scsi/scsi_transport_fc.h	2004-08-18 14:01:09.000000000 -0400
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
