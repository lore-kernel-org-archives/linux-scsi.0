From: James.Smart@Emulex.Com
Subject: [PATCH] [Update #2] suspending I/Os to a device
Date: Thu, 30 Sep 2004 16:57:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C086618@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46557 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S269518AbUI3U6Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 16:58:25 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org
Cc: hch@infradead.org, andmike@us.ibm.com, James.Bottomley@SteelEye.com, mort@wildopensource.com, andrew.vasquez@qlogic.com

Folks,

Here is the suspend i/o patch, updated to run with host and target attributes for obtaining the timeout values. As a matter of course - this adds host and target attribute use to the FC transport.

This patch depends on the bitkeeper scsi-target-2.6 tree.

-- James S


diff -uNr scsi-target-2.6/drivers/s390/scsi/zfcp_scsi.c scsi-target-2.6.patch/drivers/s390/scsi/zfcp_scsi.c
--- scsi-target-2.6/drivers/s390/scsi/zfcp_scsi.c	2004-09-12 19:36:58.000000000 -0400
+++ scsi-target-2.6.patch/drivers/s390/scsi/zfcp_scsi.c	2004-09-30 10:46:45.000000000 -0400
@@ -844,7 +844,7 @@
 	struct zfcp_unit *unit;
 
 	unit = (struct zfcp_unit *) sdev->hostdata;
-	fc_port_id(sdev) = unit->port->d_id;
+	fc_sdev_port_id(sdev) = unit->port->d_id;
 }
 
 static void
@@ -853,7 +853,7 @@
 	struct zfcp_unit *unit;
 
 	unit = (struct zfcp_unit *) sdev->hostdata;
-	fc_port_name(sdev) = unit->port->wwpn;
+	fc_sdev_port_name(sdev) = unit->port->wwpn;
 }
 
 static void
@@ -862,16 +862,16 @@
 	struct zfcp_unit *unit;
 
 	unit = (struct zfcp_unit *) sdev->hostdata;
-	fc_node_name(sdev) = unit->port->wwnn;
+	fc_sdev_node_name(sdev) = unit->port->wwnn;
 }
 
 struct fc_function_template zfcp_transport_functions = {
-	.get_port_id = zfcp_get_port_id,
-	.get_port_name = zfcp_get_port_name,
-	.get_node_name = zfcp_get_node_name,
-	.show_port_id = 1,
-	.show_port_name = 1,
-	.show_node_name = 1,
+	.get_sdev_port_id = zfcp_get_port_id,
+	.get_sdev_port_name = zfcp_get_port_name,
+	.get_sdev_node_name = zfcp_get_node_name,
+	.show_sdev_port_id = 1,
+	.show_sdev_port_name = 1,
+	.show_sdev_node_name = 1,
 };
 
 /**
diff -uNr scsi-target-2.6/drivers/scsi/qla2xxx/qla_os.c scsi-target-2.6.patch/drivers/scsi/qla2xxx/qla_os.c
--- scsi-target-2.6/drivers/scsi/qla2xxx/qla_os.c	2004-09-12 19:37:26.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/qla2xxx/qla_os.c	2004-09-30 10:46:45.000000000 -0400
@@ -4460,13 +4460,13 @@
 
 	list_for_each_entry(fc, &ha->fcports, list) {
 		if (fc->os_target_id == sdev->id) {
-			fc_port_id(sdev) = fc->d_id.b.domain << 16 |
+			fc_sdev_port_id(sdev) = fc->d_id.b.domain << 16 |
 				fc->d_id.b.area << 8 | 
 				fc->d_id.b.al_pa;
 			return;
 		}
 	}
-	fc_port_id(sdev) = -1;
+	fc_sdev_port_id(sdev) = -1;
 }
 
 static void
@@ -4477,12 +4477,12 @@
 
 	list_for_each_entry(fc, &ha->fcports, list) {
 		if (fc->os_target_id == sdev->id) {
-			fc_port_name(sdev) =
+			fc_sdev_port_name(sdev) =
 				__be64_to_cpu(*(uint64_t *)fc->port_name);
 			return;
 		}
 	}
-	fc_port_name(sdev) = -1;
+	fc_sdev_port_name(sdev) = -1;
 }
 
 static void
@@ -4493,21 +4493,21 @@
 
 	list_for_each_entry(fc, &ha->fcports, list) {
 		if (fc->os_target_id == sdev->id) {
-			fc_node_name(sdev) =
+			fc_sdev_node_name(sdev) =
 				__be64_to_cpu(*(uint64_t *)fc->node_name);
 			return;
 		}
 	}
-	fc_node_name(sdev) = -1;
+	fc_sdev_node_name(sdev) = -1;
 }
 
 static struct fc_function_template qla2xxx_transport_functions = {
-	.get_port_id = qla2xxx_get_port_id,
-	.show_port_id = 1,
-	.get_port_name = qla2xxx_get_port_name,
-	.show_port_name = 1,
-	.get_node_name = qla2xxx_get_node_name,
-	.show_node_name = 1,
+	.get_sdev_port_id = qla2xxx_get_port_id,
+	.show_sdev_port_id = 1,
+	.get_sdev_port_name = qla2xxx_get_port_name,
+	.show_sdev_port_name = 1,
+	.get_sdev_node_name = qla2xxx_get_node_name,
+	.show_sdev_node_name = 1,
 };
 
 /**
diff -uNr scsi-target-2.6/drivers/scsi/scsi.c scsi-target-2.6.patch/drivers/scsi/scsi.c
--- scsi-target-2.6/drivers/scsi/scsi.c	2004-09-12 19:37:17.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi.c	2004-09-30 10:46:45.000000000 -0400
@@ -518,6 +518,26 @@
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
+
+	/* Check to see if the scsi lld put this device into state SDEV_BLOCK. */
+	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK)) {
+		/* 
+		 * in SDEV_BLOCK, the command is just put back on the device
+		 * queue.  The suspend state has already blocked the queue so
+		 * future requests should not occur until the device 
+		 * transitions out of the suspend state.
+		 */
+		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+
+		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
+
+		/*
+		 * NOTE: rtn is still zero here because we don't need the
+		 * queue to be plugged on return (it's already stopped)
+		 */
+		goto out;
+	}
+
 	/* Assign a unique nonzero serial_number. */
 	/* XXX(hch): this is racy */
 	if (++serial_number == 0)
@@ -1103,8 +1123,8 @@
 
 /**
  * scsi_device_cancel - cancel outstanding IO to this device
- * @sdev:	pointer to struct scsi_device
- * @data:	pointer to cancel value.
+ * @sdev:	Pointer to struct scsi_device
+ * @recovery:	Boolean instructing function to recover device or not.
  *
  **/
 int scsi_device_cancel(struct scsi_device *sdev, int recovery)
diff -uNr scsi-target-2.6/drivers/scsi/scsi_lib.c scsi-target-2.6.patch/drivers/scsi/scsi_lib.c
--- scsi-target-2.6/drivers/scsi/scsi_lib.c	2004-09-12 19:37:17.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_lib.c	2004-09-30 10:46:45.000000000 -0400
@@ -1642,6 +1642,7 @@
 		case SDEV_CREATED:
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -1669,11 +1670,22 @@
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
@@ -1779,3 +1791,84 @@
 	device_for_each_child(&starget->dev, NULL, device_resume_fn);
 }
 EXPORT_SYMBOL(scsi_target_resume);
+
+/**
+ * scsi_internal_device_block - internal function to put a device
+ *				temporarily into the SDEV_BLOCK state
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
+ *	the device with scsi_device_unblock or device_block_tmo fires.
+ *	This routine assumes the host_lock is held on entry.
+ **/
+int
+scsi_internal_device_block(struct scsi_device *sdev)
+{
+	request_queue_t *q = sdev->request_queue;
+	unsigned long flags;
+	int err = 0;
+
+	err = scsi_device_set_state(sdev, SDEV_BLOCK);
+	if (err)
+		return err;
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
+EXPORT_SYMBOL_GPL(scsi_internal_device_block);
+ 
+/**
+ * scsi_internal_device_unblock - resume a device after a block request
+ * @sdev:	device to resume
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
+ *	goose the queue for this device.  This routine assumes the 
+ *	host_lock is held upon entry.
+ **/
+int
+scsi_internal_device_unblock(struct scsi_device *sdev)
+{
+	request_queue_t *q = sdev->request_queue; 
+	int err;
+	unsigned long flags;
+	
+	/* 
+	 * Try to transition the scsi device to SDEV_RUNNING
+	 * and goose the device queue if successful.  
+	 */
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
+EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
diff -uNr scsi-target-2.6/drivers/scsi/scsi_priv.h scsi-target-2.6.patch/drivers/scsi/scsi_priv.h
--- scsi-target-2.6/drivers/scsi/scsi_priv.h	2004-09-12 19:37:18.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_priv.h	2004-09-30 10:46:45.000000000 -0400
@@ -153,4 +153,13 @@
 extern struct class sdev_class;
 extern struct bus_type scsi_bus_type;
 
+/* 
+ * internal scsi timeout functions: for use by mid-layer and transport
+ * classes.
+ */
+
+#define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	(HZ*60)
+extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_unblock(struct scsi_device *sdev);
+
 #endif /* _SCSI_PRIV_H */
diff -uNr scsi-target-2.6/drivers/scsi/scsi_sysfs.c scsi-target-2.6.patch/drivers/scsi/scsi_sysfs.c
--- scsi-target-2.6/drivers/scsi/scsi_sysfs.c	2004-09-27 12:40:09.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_sysfs.c	2004-09-30 10:46:52.000000000 -0400
@@ -30,6 +30,7 @@
 	{ SDEV_DEL, "deleted" },
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
+	{ SDEV_BLOCK,	"blocked" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
@@ -779,6 +780,7 @@
 		class_device_initialize(&starget->transport_classdev);
 		starget->transport_classdev.dev = &starget->dev;
 		starget->transport_classdev.class = shost->transportt->target_class;
+		starget->shost = shost;
 		snprintf(starget->transport_classdev.class_id, BUS_ID_SIZE,
 			 "target%d:%d:%d",
 			 shost->host_no, sdev->channel, sdev->id);
diff -uNr scsi-target-2.6/drivers/scsi/scsi_transport_fc.c scsi-target-2.6.patch/drivers/scsi/scsi_transport_fc.c
--- scsi-target-2.6/drivers/scsi/scsi_transport_fc.c	2004-09-12 19:37:18.000000000 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_transport_fc.c	2004-09-30 10:46:45.000000000 -0400
@@ -23,14 +23,19 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
+#include "scsi_priv.h"
 
 #define FC_PRINTK(x, l, f, a...)	printk(l "scsi(%d:%d:%d:%d): " f, (x)->host->host_no, (x)->channel, (x)->id, (x)->lun , ##a)
 
 static void transport_class_release(struct class_device *class_dev);
+static void starget_class_release(struct class_device *class_dev);
+static void host_class_release(struct class_device *class_dev);
 
-#define FC_NUM_ATTRS 	3	/* increase this if you add attributes */
+#define FC_NUM_ATTRS 	4	/* increase this if you add attributes */
 #define FC_OTHER_ATTRS 	0	/* increase this if you add "always on"
 				 * attributes */
+#define FC_STARGET_NUM_ATTRS	1
+#define FC_HOST_NUM_ATTRS	1
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -40,6 +45,12 @@
 	/* The array of null terminated pointers to attributes
 	 * needed by scsi_sysfs.c */
 	struct class_device_attribute *attrs[FC_NUM_ATTRS + FC_OTHER_ATTRS + 1];
+
+	struct class_device_attribute private_starget_attrs[FC_STARGET_NUM_ATTRS];
+	struct class_device_attribute *starget_attrs[FC_STARGET_NUM_ATTRS + 1];
+
+	struct class_device_attribute private_host_attrs[FC_HOST_NUM_ATTRS];
+	struct class_device_attribute *host_attrs[FC_HOST_NUM_ATTRS + 1];
 };
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
@@ -49,24 +60,71 @@
 	.release = transport_class_release,
 };
 
+struct class fc_starget_class = {
+	.name = "fc_target",
+	.release = starget_class_release,
+};
+
+struct class fc_host_class = {
+	.name = "fc_host",
+	.release = host_class_release,
+};
+
 static __init int fc_transport_init(void)
 {
+	int error = class_register(&fc_host_class);
+	if (error)
+		return error;
+	error = class_register(&fc_starget_class);
+	if (error) {
+		return error;
+	}
 	return class_register(&fc_transport_class);
 }
 
 static void __exit fc_transport_exit(void)
 {
 	class_unregister(&fc_transport_class);
+	class_unregister(&fc_starget_class);
+	class_unregister(&fc_host_class);
 }
 
-static int fc_setup_transport_attrs(struct scsi_device *sdev)
+static int fc_setup_sdev_transport_attrs(struct scsi_device *sdev)
 {
-	/* I'm not sure what values are invalid.  We should pick some invalid
-	 * values for the defaults */
-	fc_node_name(sdev) = -1;
-	fc_port_name(sdev) = -1;
-	fc_port_id(sdev) = -1;
+	/* 
+	 * Set default values easily detected by the midlayer as
+	 * failure cases.  The scsi lldd is responsible for initializing
+	 * all transport attributes to valid values per device.
+	 */
+	fc_sdev_node_name(sdev) = -1;
+	fc_sdev_port_name(sdev) = -1;
+	fc_sdev_port_id(sdev) = -1;
+	fc_sdev_dev_loss_tmo(sdev) = -1;
+	init_timer(&fc_sdev_dev_loss_timer(sdev));
+	return 0;
+}
 
+static int fc_setup_starget_transport_attrs(struct scsi_target *starget)
+{
+	/* 
+	 * Set default values easily detected by the midlayer as
+	 * failure cases.  The scsi lldd is responsible for initializing
+	 * all transport attributes to valid values per target.
+	 */
+	fc_starget_dev_loss_tmo(starget) = -1;
+	init_timer(&fc_starget_dev_loss_timer(starget));
+	return 0;
+}
+
+static int fc_setup_host_transport_attrs(struct Scsi_Host *shost)
+{
+	/* 
+	 * Set default values easily detected by the midlayer as
+	 * failure cases.  The scsi lldd is responsible for initializing
+	 * all transport attributes to valid values per host.
+	 */
+	fc_host_link_down_tmo(shost) = -1;
+	init_timer(&fc_host_link_down_timer(shost));
 	return 0;
 }
 
@@ -76,23 +134,40 @@
 	put_device(&sdev->sdev_gendev);
 }
 
-#define fc_transport_show_function(field, format_string, cast)		\
-									\
+static void starget_class_release(struct class_device *class_dev)
+{
+	struct scsi_target *starget = transport_class_to_starget(class_dev);
+	put_device(&starget->dev);
+}
+
+static void host_class_release(struct class_device *class_dev)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(class_dev);
+	put_device(&shost->shost_gendev);
+}
+
+
+
+/*
+ * Sdev Attribute Management
+ */
+
+#define fc_sdev_show_function(field, format_string, cast)		\
 static ssize_t								\
-show_fc_transport_##field (struct class_device *cdev, char *buf)	\
+show_fc_sdev_##field (struct class_device *cdev, char *buf)		\
 {									\
 	struct scsi_device *sdev = transport_class_to_sdev(cdev);	\
-	struct fc_transport_attrs *tp;					\
+	struct fc_sdev_attrs *tp;					\
 	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
-	tp = (struct fc_transport_attrs *)&sdev->sdev_data;		\
-	if (i->f->get_##field)						\
-		i->f->get_##field(sdev);				\
+	tp = (struct fc_sdev_attrs *)&sdev->sdev_data;			\
+	if (i->f->get_sdev_##field)					\
+		i->f->get_sdev_##field(sdev);				\
 	return snprintf(buf, 20, format_string, cast tp->field);	\
 }
 
-#define fc_transport_store_function(field, format_string)		\
+#define fc_sdev_store_function(field, format_string)			\
 static ssize_t								\
-store_fc_transport_##field(struct class_device *cdev, const char *buf,	\
+store_fc_sdev_##field(struct class_device *cdev, const char *buf,	\
 			   size_t count)				\
 {									\
 	int val;							\
@@ -100,50 +175,195 @@
 	struct fc_internal *i = to_fc_internal(sdev->host->transportt);	\
 									\
 	val = simple_strtoul(buf, NULL, 0);				\
-	i->f->set_##field(sdev, val);					\
+	i->f->set_sdev_##field(sdev, val);				\
+	return count;							\
+}
+
+#define fc_sdev_rd_attr(field, format_string)				\
+	fc_sdev_show_function(field, format_string, )			\
+static CLASS_DEVICE_ATTR(sdev_##field, S_IRUGO,				\
+			 show_fc_sdev_##field, NULL)
+
+#define fc_sdev_rd_attr_cast(field, format_string, cast)		\
+	fc_sdev_show_function(field, format_string, (cast))		\
+static CLASS_DEVICE_ATTR(sdev_##field, S_IRUGO,				\
+			  show_fc_sdev_##field, NULL)
+
+#define fc_sdev_rw_attr(field, format_string)				\
+	fc_sdev_show_function(field, format_string, )			\
+	fc_sdev_store_function(field, format_string)			\
+static CLASS_DEVICE_ATTR(sdev_##field, S_IRUGO | S_IWUSR,		\
+			show_fc_sdev_##field,				\
+			store_fc_sdev_##field)
+
+#define SETUP_SDEV_ATTRIBUTE_RD(field)					\
+	i->private_attrs[count] = class_device_attr_sdev_##field;	\
+	i->private_attrs[count].attr.mode = S_IRUGO;			\
+	i->private_attrs[count].store = NULL;				\
+	i->attrs[count] = &i->private_attrs[count];			\
+	if (i->f->show_sdev_##field)					\
+		count++
+
+#define SETUP_SDEV_ATTRIBUTE_RW(field)					\
+	i->private_attrs[count] = class_device_attr_sdev_##field;	\
+	if (!i->f->set_sdev_##field) {					\
+		i->private_attrs[count].attr.mode = S_IRUGO;		\
+		i->private_attrs[count].store = NULL;			\
+	}								\
+	i->attrs[count] = &i->private_attrs[count];			\
+	if (i->f->show_sdev_##field)					\
+		count++
+
+/* The FC Tranport Sdev Attributes: */
+fc_sdev_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
+fc_sdev_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
+fc_sdev_rd_attr(port_id, "0x%06x\n");
+fc_sdev_rw_attr(dev_loss_tmo, "%d\n");
+
+
+/*
+ * Remote Port Attribute Management
+ */
+
+#define fc_starget_show_function(field, format_string, cast)		\
+static ssize_t								\
+show_fc_starget_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = starget->shost;			\
+	struct fc_starget_attrs *tp;					\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	tp = (struct fc_starget_attrs *)&starget->starget_data;		\
+	if (i->f->get_starget_##field)					\
+		i->f->get_starget_##field(starget);			\
+	return snprintf(buf, 20, format_string, cast tp->field);	\
+}
+
+#define fc_starget_store_function(field, format_string)			\
+static ssize_t								\
+store_fc_starget_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = starget->shost;			\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_starget_##field(starget, val);			\
+	return count;							\
+}
+
+#define fc_starget_rd_attr(field, format_string)			\
+	fc_starget_show_function(field, format_string, )		\
+static CLASS_DEVICE_ATTR(starget_##field, S_IRUGO,			\
+			 show_fc_starget_##field, NULL)
+
+#define fc_starget_rd_attr_cast(field, format_string, cast)		\
+	fc_starget_show_function(field, format_string, (cast))		\
+static CLASS_DEVICE_ATTR(starget_##field, S_IRUGO,			\
+			  show_fc_starget_##field, NULL)
+
+#define fc_starget_rw_attr(field, format_string)			\
+	fc_starget_show_function(field, format_string, )		\
+	fc_starget_store_function(field, format_string)			\
+static CLASS_DEVICE_ATTR(starget_##field, S_IRUGO | S_IWUSR,		\
+			show_fc_starget_##field,			\
+			store_fc_starget_##field)
+
+#define SETUP_STARGET_ATTRIBUTE_RD(field)				\
+	i->private_starget_attrs[count] = class_device_attr_starget_##field;\
+	i->private_starget_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_starget_attrs[count].store = NULL;			\
+	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	if (i->f->show_starget_##field)					\
+		count++
+
+#define SETUP_STARGET_ATTRIBUTE_RW(field)				\
+	i->private_starget_attrs[count] = class_device_attr_starget_##field;\
+	if (!i->f->set_starget_##field) {				\
+		i->private_starget_attrs[count].attr.mode = S_IRUGO;	\
+		i->private_starget_attrs[count].store = NULL;		\
+	}								\
+	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	if (i->f->show_starget_##field)					\
+		count++
+
+/* The FC Tranport Remote Port (Target) Attributes: */
+fc_starget_rw_attr(dev_loss_tmo, "%d\n");
+
+
+/*
+ * Host Attribute Management
+ */
+
+#define fc_host_show_function(field, format_string, cast)		\
+static ssize_t								\
+show_fc_host_##field (struct class_device *cdev, char *buf)		\
+{									\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct fc_host_attrs *tp;					\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+	tp = (struct fc_host_attrs *)&shost->shost_data;		\
+	if (i->f->get_host_##field)					\
+		i->f->get_host_##field(shost);				\
+	return snprintf(buf, 20, format_string, cast tp->field);	\
+}
+
+#define fc_host_store_function(field, format_string)			\
+static ssize_t								\
+store_fc_host_##field(struct class_device *cdev, const char *buf,	\
+			   size_t count)				\
+{									\
+	int val;							\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct fc_internal *i = to_fc_internal(shost->transportt);	\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->f->set_host_##field(shost, val);				\
 	return count;							\
 }
 
-#define fc_transport_rd_attr(field, format_string)			\
-	fc_transport_show_function(field, format_string, )		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO,				\
-			 show_fc_transport_##field, NULL)
-
-#define fc_transport_rd_attr_cast(field, format_string, cast)		\
-	fc_transport_show_function(field, format_string, (cast))	\
-static CLASS_DEVICE_ATTR( field, S_IRUGO,				\
-			  show_fc_transport_##field, NULL)
-
-#define fc_transport_rw_attr(field, format_string)			\
-	fc_transport_show_function(field, format_string, )		\
-	fc_transport_store_function(field, format_string)		\
-static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
-			show_fc_transport_##field,			\
-			store_fc_transport_##field)
-
-/* the FiberChannel Tranport Attributes: */
-fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
-fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
-fc_transport_rd_attr(port_id, "0x%06x\n");
-
-#define SETUP_ATTRIBUTE_RD(field)				\
-	i->private_attrs[count] = class_device_attr_##field;	\
-	i->private_attrs[count].attr.mode = S_IRUGO;		\
-	i->private_attrs[count].store = NULL;			\
-	i->attrs[count] = &i->private_attrs[count];		\
-	if (i->f->show_##field)					\
-		count++
-
-#define SETUP_ATTRIBUTE_RW(field)				\
-	i->private_attrs[count] = class_device_attr_##field;	\
-	if (!i->f->set_##field) {				\
-		i->private_attrs[count].attr.mode = S_IRUGO;	\
-		i->private_attrs[count].store = NULL;		\
-	}							\
-	i->attrs[count] = &i->private_attrs[count];		\
-	if (i->f->show_##field)					\
+#define fc_host_rd_attr(field, format_string)				\
+	fc_host_show_function(field, format_string, )			\
+static CLASS_DEVICE_ATTR(host_##field, S_IRUGO,				\
+			 show_fc_host_##field, NULL)
+
+#define fc_host_rd_attr_cast(field, format_string, cast)		\
+	fc_host_show_function(field, format_string, (cast))		\
+static CLASS_DEVICE_ATTR(host_##field, S_IRUGO,				\
+			  show_fc_host_##field, NULL)
+
+#define fc_host_rw_attr(field, format_string)				\
+	fc_host_show_function(field, format_string, )			\
+	fc_host_store_function(field, format_string)			\
+static CLASS_DEVICE_ATTR(host_##field, S_IRUGO | S_IWUSR,		\
+			show_fc_host_##field,				\
+			store_fc_host_##field)
+
+#define SETUP_HOST_ATTRIBUTE_RD(field)					\
+	i->private_host_attrs[count] = class_device_attr_host_##field;	\
+	i->private_host_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_host_attrs[count].store = NULL;			\
+	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	if (i->f->show_host_##field)					\
 		count++
 
+#define SETUP_HOST_ATTRIBUTE_RW(field)					\
+	i->private_host_attrs[count] = class_device_attr_host_##field;	\
+	if (!i->f->set_host_##field) {					\
+		i->private_host_attrs[count].attr.mode = S_IRUGO;	\
+		i->private_host_attrs[count].store = NULL;		\
+	}								\
+	i->host_attrs[count] = &i->private_host_attrs[count];		\
+	if (i->f->show_host_##field)					\
+		count++
+
+/* The FC Tranport Host Attributes: */
+fc_host_rw_attr(link_down_tmo, "%d\n");
+
+
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -158,13 +378,28 @@
 
 	i->t.device_attrs = &i->attrs[0];
 	i->t.device_class = &fc_transport_class;
-	i->t.device_setup = &fc_setup_transport_attrs;
-	i->t.device_size = sizeof(struct fc_transport_attrs);
+	i->t.device_setup = &fc_setup_sdev_transport_attrs;
+	i->t.device_size = sizeof(struct fc_sdev_attrs);
+
+	i->t.target_attrs = &i->starget_attrs[0];
+	i->t.target_class = &fc_starget_class;
+	i->t.target_setup = &fc_setup_starget_transport_attrs;
+	i->t.target_size = sizeof(struct fc_starget_attrs);
+
+	i->t.host_attrs = &i->host_attrs[0];
+	i->t.host_class = &fc_host_class;
+	i->t.host_setup = &fc_setup_host_transport_attrs;
+	i->t.host_size = sizeof(struct fc_host_attrs);
 	i->f = ft;
 
-	SETUP_ATTRIBUTE_RD(port_id);
-	SETUP_ATTRIBUTE_RD(port_name);
-	SETUP_ATTRIBUTE_RD(node_name);
+	
+	/*
+	 * setup sdev attributes
+	 */
+	SETUP_SDEV_ATTRIBUTE_RD(port_id);
+	SETUP_SDEV_ATTRIBUTE_RD(port_name);
+	SETUP_SDEV_ATTRIBUTE_RD(node_name);
+	SETUP_SDEV_ATTRIBUTE_RW(dev_loss_tmo);
 
 	BUG_ON(count > FC_NUM_ATTRS);
 
@@ -172,6 +407,31 @@
 
 	i->attrs[count] = NULL;
 
+
+	/*
+	 * setup remote port (target) attributes
+	 */
+	count=0;
+	SETUP_STARGET_ATTRIBUTE_RW(dev_loss_tmo);
+
+	BUG_ON(count > FC_STARGET_NUM_ATTRS);
+
+	/* Setup the always-on attributes here */
+
+	i->starget_attrs[count] = NULL;
+
+
+	/* setup host attributes */
+	count=0;
+	SETUP_HOST_ATTRIBUTE_RW(link_down_tmo);
+
+	BUG_ON(count > FC_HOST_NUM_ATTRS);
+
+	/* Setup the always-on attributes here */
+
+	i->host_attrs[count] = NULL;
+
+
 	return &i->t;
 }
 EXPORT_SYMBOL(fc_attach_transport);
@@ -185,6 +445,277 @@
 EXPORT_SYMBOL(fc_release_transport);
 
 
+
+/**
+ * fc_timeout_blocked_sdev - Timeout handler for blocked scsi devices
+ *			 that fail to recover in the alloted time.      
+ * @data:	scsi device that failed to reappear in the alloted time.
+ **/
+static void fc_timeout_blocked_sdev(unsigned long data)
+{
+	struct scsi_device *sdev = (struct scsi_device *)data;
+
+	dev_printk(KERN_ERR, &sdev->sdev_gendev, 
+		"blocked device time out: device resuming\n");
+
+	/* 
+	 * set the device going again ... if the scsi device hasn't been
+	 * resumed this will probably result in I/O errors if the host still
+	 * isn't ready.
+	 */
+	scsi_internal_device_unblock(sdev);
+}
+
+/**
+ * fc_device_block - temporarily block a scsi device.
+ * @sdev:	scsi device to block.
+ *
+ * scsi lld's with a FC transport call the fc_device_block function to 
+ * temporarily stop all scsi commands to the device specified.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	The timeout and timer attributes are extracted from the fc transport
+ *	attributes associated with the scsi device.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int
+fc_device_block(struct scsi_device *sdev)
+{
+	int timeout = fc_sdev_dev_loss_tmo(sdev);
+	struct timer_list *timer = &fc_sdev_dev_loss_timer(sdev);
+
+	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	scsi_internal_device_block(sdev);
+
+	/* The scsi lld blocks this device for the timeout period only. */
+	timer->data = (unsigned long)sdev;
+	timer->expires = jiffies + timeout * HZ;
+	timer->function = fc_timeout_blocked_sdev;
+	add_timer(timer);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_device_block);
+
+/**
+ * fc_device_unblock - unblock a scsi device following a fc_device_block 
+ *			request.
+ * @sdev:	device managed by target providing target id.
+ *
+ * scsi lld's with a FC transport call this routine to unblock a scsi device
+ * following a fc_device_block request.  The unblock causes IO to resume to the
+ * scsi lld.  Called from interrupt or normal process context.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+void
+fc_device_unblock(struct scsi_device *sdev)
+{
+	/* 
+	 * Stop the scsi device timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction.
+	 */
+	del_timer_sync(&fc_sdev_dev_loss_timer(sdev));
+	scsi_internal_device_unblock(sdev);
+}
+EXPORT_SYMBOL(fc_device_unblock);
+
+/**
+ * fc_timeout_blocked_tgt - Timeout handler for blocked scsi targets
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi target that failed to reappear in the alloted time.
+ **/
+static void fc_timeout_blocked_tgt(unsigned long data)
+{
+	struct scsi_target *starget = (struct scsi_target *)data;
+	struct scsi_device *sdev;
+
+	dev_printk(KERN_ERR, &starget->dev, 
+		"blocked target time out: target resuming\n");
+
+	shost_for_each_device(sdev, starget->shost) {
+		if (sdev->id == starget->id) {
+			/* 
+			 * set the device going again ... if the scsi lld didn't
+			 * unblock this device, then IO errors will probably
+			 * result if the host still isn't ready.
+			 */
+			scsi_internal_device_unblock(sdev);
+		}
+	}
+}
+
+/**
+ * fc_target_block - block a target by temporarily putting all its scsi devices
+ *		into the SDEV_BLOCK state.
+ * @starget:	scsi target managed by this fc scsi lldd.
+ *
+ * scsi lldd's with a FC transport call this routine to temporarily stop all
+ * scsi commands to all devices managed by this scsi target.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	The timeout and timer types are extracted from the fc transport 
+ *	attributes from the caller's target pointer.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int
+fc_target_block(struct scsi_target *starget)
+{
+	struct scsi_device *sdev;
+	int timeout = fc_starget_dev_loss_tmo(starget);
+	struct timer_list *timer = &fc_starget_dev_loss_timer(starget);
+
+	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	shost_for_each_device(sdev, starget->shost) {
+		if (sdev->id == starget->id)
+			scsi_internal_device_block(sdev);
+	}
+
+	/* The scsi lld blocks this target for the timeout period only. */
+	timer->data = (unsigned long)starget;
+	timer->expires = jiffies + timeout * HZ;
+	timer->function = fc_timeout_blocked_tgt;
+	add_timer(timer);
+
+	return 0;
+}
+EXPORT_SYMBOL(fc_target_block);
+
+/**
+ * fc_target_unblock - unblock a target following a fc_target_block request.
+ * @starget:	scsi target managed by this fc scsi lldd.	
+ *
+ * scsi lld's with a FC transport call this routine to restart IO to all 
+ * devices associated with the caller's scsi target following a fc_target_block
+ * request.  Called from interrupt or normal process context.
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+void
+fc_target_unblock(struct scsi_target *starget)
+{
+	struct scsi_device *sdev;
+
+	/* 
+	 * Stop the target timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. 
+	 */
+	del_timer_sync(&fc_starget_dev_loss_timer(starget));
+
+	shost_for_each_device(sdev, starget->shost) {
+		if (sdev->id == starget->id)
+			scsi_internal_device_unblock(sdev);
+	}
+}
+EXPORT_SYMBOL(fc_target_unblock);
+
+/**
+ * fc_timeout_blocked_host - Timeout handler for blocked scsi hosts
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi host that failed to recover its devices in the alloted
+ *		time.
+ **/
+static void fc_timeout_blocked_host(unsigned long data)
+{
+	struct Scsi_Host *shost = (struct Scsi_Host *)data;
+	struct scsi_device *sdev;
+
+	dev_printk(KERN_ERR, &shost->shost_gendev, 
+		"blocked host time out: host resuming\n");
+
+	shost_for_each_device(sdev, shost) {
+		/* 
+		 * set the device going again ... if the scsi lld didn't
+		 * unblock this device, then IO errors will probably
+		 * result if the host still isn't ready.
+		 */
+		scsi_internal_device_unblock(sdev);
+	}
+}
+
+/**
+ * fc_host_block - block all scsi devices managed by the calling host temporarily 
+ *		by putting each device in the SDEV_BLOCK state.
+ * @shost:	scsi host pointer that contains all scsi device siblings.
+ *
+ * scsi lld's with a FC transport call this routine to temporarily stop all
+ * scsi commands to all devices managed by this host.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:
+ *	The timeout and timer types are extracted from the fc transport 
+ *	attributes from the caller's host pointer.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int
+fc_host_block(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	int timeout = fc_host_link_down_tmo(shost);
+	struct timer_list *timer = &fc_host_link_down_timer(shost);
+
+	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	shost_for_each_device(sdev, shost) {
+		scsi_internal_device_block(sdev);
+	}
+
+	/* The scsi lld blocks this host for the timeout period only. */
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
+ *
+ * scsi lld's with a FC transport call this routine to restart IO to all scsi
+ * devices managed by the specified scsi host following an fc_host_block 
+ * request.  Called from interrupt or normal process context.
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+void
+fc_host_unblock(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	/* 
+	 * Stop the host timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction.
+	 */
+	del_timer_sync(&fc_host_link_down_timer(shost));
+	shost_for_each_device(sdev, shost) {
+		scsi_internal_device_unblock(sdev);
+	}
+}
+EXPORT_SYMBOL(fc_host_unblock);
+
 MODULE_AUTHOR("Martin Hicks");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
diff -uNr scsi-target-2.6/include/scsi/scsi_device.h scsi-target-2.6.patch/include/scsi/scsi_device.h
--- scsi-target-2.6/include/scsi/scsi_device.h	2004-09-27 12:40:09.000000000 -0400
+++ scsi-target-2.6.patch/include/scsi/scsi_device.h	2004-09-30 10:46:45.000000000 -0400
@@ -30,6 +30,9 @@
 				 * originate in the mid-layer) */
 	SDEV_OFFLINE,		/* Device offlined (by error handling or
 				 * user request */
+	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
+				 * commands from user or midlayer should be issued
+				 * to the scsi lld. */
 };
 
 struct scsi_device {
@@ -136,6 +139,7 @@
  */
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
+	struct Scsi_Host	*shost;
 	struct device		dev;
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
diff -uNr scsi-target-2.6/include/scsi/scsi_transport_fc.h scsi-target-2.6.patch/include/scsi/scsi_transport_fc.h
--- scsi-target-2.6/include/scsi/scsi_transport_fc.h	2004-09-12 19:38:48.000000000 -0400
+++ scsi-target-2.6.patch/include/scsi/scsi_transport_fc.h	2004-09-30 10:46:45.000000000 -0400
@@ -24,33 +24,86 @@
 
 struct scsi_transport_template;
 
-struct fc_transport_attrs {
+struct fc_sdev_attrs {
 	int port_id;
 	uint64_t node_name;
 	uint64_t port_name;
+	uint32_t dev_loss_tmo;	/* Device loss timeout in seconds. */
+	struct timer_list dev_loss_timer;
 };
 
 /* accessor functions */
-#define fc_port_id(x)	(((struct fc_transport_attrs *)&(x)->sdev_data)->port_id)
-#define fc_node_name(x)	(((struct fc_transport_attrs *)&(x)->sdev_data)->node_name)
-#define fc_port_name(x)	(((struct fc_transport_attrs *)&(x)->sdev_data)->port_name)
+#define fc_sdev_port_id(x) \
+	(((struct fc_sdev_attrs *)&(x)->sdev_data)->port_id)
+#define fc_sdev_node_name(x) \
+	(((struct fc_sdev_attrs *)&(x)->sdev_data)->node_name)
+#define fc_sdev_port_name(x)	\
+	(((struct fc_sdev_attrs *)&(x)->sdev_data)->port_name)
+#define fc_sdev_dev_loss_tmo(x) \
+	(((struct fc_sdev_attrs *)&(x)->sdev_data)->dev_loss_tmo)
+#define fc_sdev_dev_loss_timer(x) \
+	(((struct fc_sdev_attrs *)&(x)->sdev_data)->dev_loss_timer)
+
+struct fc_starget_attrs {	/* aka fc_target_attrs */
+	uint32_t dev_loss_tmo;	/* Remote Port loss timeout in seconds. */
+	struct timer_list dev_loss_timer;
+};
+
+#define fc_starget_dev_loss_tmo(x) \
+	(((struct fc_starget_attrs *)&(x)->starget_data)->dev_loss_tmo)
+#define fc_starget_dev_loss_timer(x) \
+	(((struct fc_starget_attrs *)&(x)->starget_data)->dev_loss_timer)
+
+struct fc_host_attrs {
+	uint32_t link_down_tmo;	/* Link Down timeout in seconds. */
+	struct timer_list link_down_timer;
+};
+
+#define fc_host_link_down_tmo(x) \
+	(((struct fc_host_attrs *)&(x)->shost_data)->link_down_tmo)
+#define fc_host_link_down_timer(x) \
+	(((struct fc_host_attrs *)&(x)->shost_data)->link_down_timer)
+
 
 /* The functions by which the transport class and the driver communicate */
 struct fc_function_template {
-	void 	(*get_port_id)(struct scsi_device *);
-	void	(*get_node_name)(struct scsi_device *);
-	void	(*get_port_name)(struct scsi_device *);
-	/* The driver sets these to tell the transport class it
+	void 	(*get_sdev_port_id)(struct scsi_device *);
+	void	(*get_sdev_node_name)(struct scsi_device *);
+	void	(*get_sdev_port_name)(struct scsi_device *);
+	void    (*get_sdev_dev_loss_tmo)(struct scsi_device *);
+	void	(*set_sdev_dev_loss_tmo)(struct scsi_device *, uint32_t);
+
+	void    (*get_starget_dev_loss_tmo)(struct scsi_target *);
+	void	(*set_starget_dev_loss_tmo)(struct scsi_target *, uint32_t);
+
+	void    (*get_host_link_down_tmo)(struct Scsi_Host *);
+	void	(*set_host_link_down_tmo)(struct Scsi_Host *, uint32_t);
+
+	/* 
+	 * The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport
-	 * class */
-	unsigned long	show_port_id:1;
-	unsigned long	show_node_name:1;
-	unsigned long	show_port_name:1;
+	 * class 
+	 */
+	unsigned long	show_sdev_port_id:1;
+	unsigned long	show_sdev_node_name:1;
+	unsigned long	show_sdev_port_name:1;
+	unsigned long   show_sdev_dev_loss_tmo:1;
+
+	unsigned long   show_starget_dev_loss_tmo:1;
+
+	unsigned long   show_host_link_down_tmo:1;
+
 	/* Private Attributes */
 };
 
 struct scsi_transport_template *fc_attach_transport(struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
+int fc_device_block(struct scsi_device *sdev);
+void fc_device_unblock(struct scsi_device *sdev);
+int fc_target_block(struct scsi_target *starget);
+void fc_target_unblock(struct scsi_target *starget);
+int fc_host_block(struct Scsi_Host *shost);
+void fc_host_unblock(struct Scsi_Host *shost);
 
 #endif /* SCSI_TRANSPORT_FC_H */
