From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_lib_dma.c :  fix bug with dma maps on nested scsi
 objects - (2nd try)
Date: Tue, 3 Nov 2009 19:45:26 -0500
Message-ID: <1257295546.5965.7.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37350 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZKDApx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 19:45:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, james.bottomley@suse.de
Cc: andrew.vasquez@qlogic.com, sfr@canb.auug.org.au

I had reminded James B of a patch for an issue with the scsi subsystem
not properly finding the parent device for dma operations when we had
nested scsi_hosts..
http://marc.info/?l=linux-scsi&m=125372757108048&w=2

The patch was picked up, and integrated into linux-next, which started
to see issues, and which James B cut an additional patch to deal with
traversing too much of the tree (stopping when dev->parent == NULL)..
The http://marc.info/?l=linux-scsi&m=125414973520985&w=2

The real issue was the traversal of a node that had "dev->type == NULL".
Turns out standard PCI endpoint and bridge/domain objects have NULL types
too - so every traversal went all the way to the root of the tree.

The attached patch, cut against scsi-misc-2.6 - replaces both of the
patches above. Rather than making any assumptions about dev->type values,
it now explicitly matches dev->type structures to known scsi or transport
objects, and only traverses them if they are recognized. To get around
symbol dependencies, and to allow transports as modules to come and go,
a registration interface was put in place to register transport objects
with the routine that does the matching.  The FC transport was converted
to use a device_type structure for its objects (note: perhaps other
transports should consider the same ?)

Please apply this patch as soon as possible.  At the current time,
NPIV vport dma operation is severely broken.

Thanks

-- james s




 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/hosts.c             |   72 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c          |    2 -
 drivers/scsi/scsi_lib_dma.c      |    7 ++-
 drivers/scsi/scsi_priv.h         |    2 +
 drivers/scsi/scsi_transport_fc.c |   48 +++++++++++++++++++++++---
 include/scsi/scsi_host.h         |   17 +++++++++
 6 files changed, 141 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/hosts.c	2009-11-02 17:44:44.000000000 -0500
@@ -40,6 +40,9 @@
 #include "scsi_logging.h"
 
 
+static DEFINE_SPINLOCK(transport_devs_lock);
+static struct list_head transport_devs;
+
 static atomic_t scsi_host_next_hn;	/* host_no for next new host */
 
 
@@ -504,6 +507,7 @@ EXPORT_SYMBOL(scsi_host_put);
 
 int scsi_init_hosts(void)
 {
+	INIT_LIST_HEAD(&transport_devs);
 	return class_register(&shost_class);
 }
 
@@ -560,3 +564,71 @@ void scsi_flush_work(struct Scsi_Host *s
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+
+struct scsi_transport_dev {
+	struct list_head devs_list;
+	struct device_type *type;
+};
+
+/**
+ * scsi_reg_transport_dev_type - Register transport object device type that is
+ *                        to be ignored when searching for the first
+ *                        non-scsi object in the object tree.
+ * @dev_type:	Pointer to a "struct device_type" structure
+ */
+int scsi_reg_transport_dev_type(struct device_type *dev_type)
+{
+	struct scsi_transport_dev *dtype;
+	unsigned long flags;
+
+	dtype = kzalloc(sizeof(struct scsi_transport_dev), GFP_KERNEL);
+	if (!dtype)
+		return 1;
+	dtype->type = dev_type;
+	spin_lock_irqsave(&transport_devs_lock, flags);
+	list_add_tail(&dtype->devs_list, &transport_devs);
+	spin_unlock_irqrestore(&transport_devs_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reg_transport_dev_type);
+
+/**
+ * scsi_unreg_transport_dev_type - De-register a transport object device type
+ * @dev_type:	Pointer to a "struct device_type" structure
+ */
+void scsi_unreg_transport_dev_type(struct device_type *dev_type)
+{
+	struct scsi_transport_dev *dtype;
+	unsigned long flags;
+
+	spin_lock_irqsave(&transport_devs_lock, flags);
+	list_for_each_entry(dtype, &transport_devs, devs_list) {
+		if (dtype->type == dev_type) {
+			list_del(&dtype->devs_list);
+			kfree(dtype);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&transport_devs_lock, flags);
+}
+EXPORT_SYMBOL_GPL(scsi_unreg_transport_dev_type);
+
+int scsi_is_transport_device(const struct device *dev)
+{
+	struct scsi_transport_dev *dtype;
+	unsigned long flags;
+
+	spin_lock_irqsave(&transport_devs_lock, flags);
+	list_for_each_entry(dtype, &transport_devs, devs_list) {
+		if (dtype->type == dev->type) {
+			spin_unlock_irqrestore(&transport_devs_lock, flags);
+			return 1;
+		}
+	}
+	spin_unlock_irqrestore(&transport_devs_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(scsi_is_transport_device);
+
+
diff -upNr a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/scsi_lib.c	2009-11-01 09:21:46.000000000 -0500
@@ -1611,7 +1611,7 @@ struct request_queue *__scsi_alloc_queue
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev = shost->shost_gendev.parent;
+	struct device *dev = dev_to_nonscsi_dev(shost->shost_gendev.parent);
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
diff -upNr a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/scsi_lib_dma.c	2009-11-01 09:21:46.000000000 -0500
@@ -23,7 +23,8 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 	int nseg = 0;
 
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
 
 		nseg = dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 				  cmd->sc_data_direction);
@@ -41,10 +42,12 @@ EXPORT_SYMBOL(scsi_dma_map);
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
 	if (scsi_sg_count(cmd)) {
-		struct device *dev = cmd->device->host->shost_gendev.parent;
+		struct device *dev = dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
 
 		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 			     cmd->sc_data_direction);
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+
diff -upNr a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/scsi_priv.h	2009-11-01 10:23:08.000000000 -0500
@@ -23,6 +23,8 @@ struct scsi_nl_hdr;
 /* hosts.c */
 extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
+extern int scsi_reg_transport_dev_type(struct device_type *dev_type);
+extern void scsi_unreg_transport_dev_type(struct device_type *dev_type);
 
 /* scsi.c */
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2009-10-26 12:58:17.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2009-11-01 10:58:35.000000000 -0500
@@ -48,6 +48,8 @@ static int fc_bsg_hostadd(struct Scsi_Ho
 static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
 static void fc_bsg_remove(struct request_queue *);
 static void fc_bsg_goose_queue(struct fc_rport *);
+static int fc_transport_reg_devtypes(void);
+static void fc_transport_unreg_devtypes(void);
 
 /*
  * Redefine so that we can have same named attributes in the
@@ -643,6 +645,9 @@ static __init int fc_transport_init(void
 
 	atomic_set(&fc_event_seq, 0);
 
+	error = fc_transport_reg_devtypes();
+	if (error)
+		return error;
 	error = transport_class_register(&fc_host_class);
 	if (error)
 		return error;
@@ -661,6 +666,7 @@ static void __exit fc_transport_exit(voi
 	transport_class_unregister(&fc_rport_class);
 	transport_class_unregister(&fc_host_class);
 	transport_class_unregister(&fc_vport_class);
+	fc_transport_unreg_devtypes();
 }
 
 /*
@@ -1854,9 +1860,14 @@ static void fc_rport_dev_release(struct 
 	kfree(rport);
 }
 
+static struct device_type fc_rport_dev_type = {
+	.name =		"fc_rport",
+	.release =	fc_rport_dev_release,
+};
+
 int scsi_is_fc_rport(const struct device *dev)
 {
-	return dev->release == fc_rport_dev_release;
+	return dev->type == &fc_rport_dev_type;
 }
 EXPORT_SYMBOL(scsi_is_fc_rport);
 
@@ -1887,9 +1898,14 @@ static void fc_vport_dev_release(struct 
 	kfree(vport);
 }
 
+static struct device_type fc_vport_dev_type = {
+	.name =		"fc_vport",
+	.release =	fc_vport_dev_release,
+};
+
 int scsi_is_fc_vport(const struct device *dev)
 {
-	return dev->release == fc_vport_dev_release;
+	return dev->type == &fc_vport_dev_type;
 }
 EXPORT_SYMBOL(scsi_is_fc_vport);
 
@@ -1915,6 +1931,30 @@ static int fc_vport_match(struct attribu
 
 
 /**
+ * fc_transport_reg_devtypes - Registers topology device types that need
+ *                             to be skipped when traversing the topology
+ *                             tree to find the first non-scsi object which
+ *                             is then used for DMA masks, etc.
+ */
+static int fc_transport_reg_devtypes(void)
+{
+	if (scsi_reg_transport_dev_type(&fc_vport_dev_type))
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * fc_transport_unreg_devtypes - De-registers topology device types that need
+ *                             to be skipped when traversing the topology
+ *                             tree.
+ */
+static void fc_transport_unreg_devtypes(void)
+{
+	scsi_unreg_transport_dev_type(&fc_vport_dev_type);
+}
+
+
+/**
  * fc_timed_out - FC Transport I/O timeout intercept handler
  * @scmd:	The SCSI command which timed out
  *
@@ -2510,7 +2550,7 @@ fc_rport_create(struct Scsi_Host *shost,
 	dev = &rport->dev;
 	device_initialize(dev);			/* takes self reference */
 	dev->parent = get_device(&shost->shost_gendev); /* parent reference */
-	dev->release = fc_rport_dev_release;
+	dev->type = &fc_rport_dev_type;
 	dev_set_name(dev, "rport-%d:%d-%d",
 		     shost->host_no, channel, rport->number);
 	transport_setup_device(dev);
@@ -3214,7 +3254,7 @@ fc_vport_setup(struct Scsi_Host *shost, 
 	dev = &vport->dev;
 	device_initialize(dev);			/* takes self reference */
 	dev->parent = get_device(pdev);		/* takes parent reference */
-	dev->release = fc_vport_dev_release;
+	dev->type = &fc_vport_dev_type;
 	dev_set_name(dev, "vport-%d:%d-%d",
 		     shost->host_no, channel, vport->number);
 	transport_setup_device(dev);
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2009-10-30 10:31:52.000000000 -0400
+++ b/include/scsi/scsi_host.h	2009-11-01 09:36:25.000000000 -0500
@@ -703,7 +703,12 @@ static inline void *shost_priv(struct Sc
 }
 
 int scsi_is_host_device(const struct device *);
+int scsi_is_transport_device(const struct device *);
 
+/*
+ * walks object list backward, to find the first shost object.
+ * Skips over transport objects that may not be stargets, etc
+ */
 static inline struct Scsi_Host *dev_to_shost(struct device *dev)
 {
 	while (!scsi_is_host_device(dev)) {
@@ -714,6 +719,18 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
 
+/*
+ * walks object list backward, to find the first non-scsi object
+ * Skips over transport objects that may be vports, shosts under vports, etc 
+ */
+static inline struct device *dev_to_nonscsi_dev(struct device *dev)
+{
+	while (dev->parent &&
+		(scsi_is_host_device(dev) || scsi_is_transport_device(dev)))
+		dev = dev->parent;
+	return dev;
+}
+
 static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 {
 	return shost->shost_state == SHOST_RECOVERY ||


