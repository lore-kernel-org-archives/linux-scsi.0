From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 19:04:00 +0100
Message-ID: <20060113180400.GA3509@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42717 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422763AbWAMSEN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:04:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, Eric.Moore@lsil.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

When James Smart fixed the issue of the userspace scan atributes
crashing the system with the FC transport class he added a patch to
let the transport class check if the parent is valid for a given
transport class.

When adding support for the integrated raid of fusion sas devices
we ran into a problem with that, as it didn't allow adding virtual
raid volumes without the transport class knowing about it.

So this patch adds a user_scan attribute instead, that takes over from
scsi_scan_host_selected if the transport class sets it and thus lets
the transport class control the user-initiated scanning.  As this
plugs the hole about user-initiated scanning the target_parent hook
goes away and we rely on callers of the scanning routines to do
something sensible.

For SAS this meant I had to switch from a spinlock to a mutex to
synchronize the topology linked lists, in FC they were completely
unsynchronized which seems wrong.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_priv.h	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_priv.h	2006-01-13 18:26:17.000000000 +0100
@@ -26,12 +26,6 @@
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
 
-/*
- * Special value for scanning to specify scanning or rescanning of all
- * possible channels, (target) ids, or luns on a given shost.
- */
-#define SCAN_WILD_CARD	~0
-
 /* hosts.c */
 extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2006-01-13 18:26:17.000000000 +0100
@@ -334,19 +334,6 @@
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 
-	/*
-	 * Obtain the real parent from the transport. The transport
-	 * is allowed to fail (no error) if there is nothing at that
-	 * target id.
-	 */
-	if (shost->transportt->target_parent) {
-		spin_lock_irqsave(shost->host_lock, flags);
-		parent = shost->transportt->target_parent(shost, channel, id);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		if (!parent)
-			return NULL;
-	}
-
 	starget = kmalloc(size, GFP_KERNEL);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
@@ -1283,8 +1270,9 @@
 	struct scsi_device *sdev;
 	struct device *parent = &shost->shost_gendev;
 	int res;
-	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
+	struct scsi_target *starget;
 
+	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-01-13 18:00:25.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-13 18:52:45.000000000 +0100
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -62,7 +63,7 @@
 
 struct sas_host_attrs {
 	struct list_head rphy_list;
-	spinlock_t lock;
+	struct mutex lock;
 	u32 next_target_id;
 };
 #define to_sas_host_attrs(host)	((struct sas_host_attrs *)(host)->shost_data)
@@ -165,7 +166,7 @@
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
-	spin_lock_init(&sas_host->lock);
+	mutex_init(&sas_host->lock);
 	sas_host->next_target_id = 0;
 	return 0;
 }
@@ -626,7 +627,7 @@
 	transport_add_device(&rphy->dev);
 	transport_configure_device(&rphy->dev);
 
-	spin_lock(&sas_host->lock);
+	mutex_lock(&sas_host->lock);
 	list_add_tail(&rphy->list, &sas_host->rphy_list);
 	if (identify->device_type == SAS_END_DEVICE &&
 	    (identify->target_port_protocols &
@@ -634,7 +635,7 @@
 		rphy->scsi_target_id = sas_host->next_target_id++;
 	else
 		rphy->scsi_target_id = -1;
-	spin_unlock(&sas_host->lock);
+	mutex_unlock(&sas_host->lock);
 
 	if (rphy->scsi_target_id != -1) {
 		scsi_scan_target(&rphy->dev, parent->number,
@@ -661,9 +662,9 @@
 	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent->parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
-	spin_lock(&sas_host->lock);
+	mutex_lock(&sas_host->lock);
 	list_del(&rphy->list);
-	spin_unlock(&sas_host->lock);
+	mutex_unlock(&sas_host->lock);
 
 	transport_destroy_device(&rphy->dev);
 	put_device(rphy->dev.parent);
@@ -703,9 +704,9 @@
 	device_del(dev);
 	transport_destroy_device(dev);
 
-	spin_lock(&sas_host->lock);
+	mutex_lock(&sas_host->lock);
 	list_del(&rphy->list);
-	spin_unlock(&sas_host->lock);
+	mutex_unlock(&sas_host->lock);
 
 	parent->rphy = NULL;
 
@@ -731,23 +732,28 @@
  * SCSI scan helper
  */
 
-static struct device *sas_target_parent(struct Scsi_Host *shost,
-					int channel, uint id)
+static int sas_user_scan(struct Scsi_Host *shost, uint channel,
+		uint id, uint lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
-	struct device *dev = NULL;
 
-	spin_lock(&sas_host->lock);
+	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
 		struct sas_phy *parent = dev_to_phy(rphy->dev.parent);
-		if (parent->number == channel &&
-		    rphy->scsi_target_id == id)
-			dev = &rphy->dev;
+
+		if (rphy->scsi_target_id == -1)
+			continue;
+
+		if ((channel == SCAN_WILD_CARD || channel == parent->number) &&
+		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+			scsi_scan_target(&rphy->dev, parent->number,
+					 rphy->scsi_target_id, lun, 1);
+		}
 	}
-	spin_unlock(&sas_host->lock);
+	mutex_unlock(&sas_host->lock);
 
-	return dev;
+	return 0;
 }
 
 
@@ -792,7 +798,7 @@
 		return NULL;
 	memset(i, 0, sizeof(struct sas_internal));
 
-	i->t.target_parent = sas_target_parent;
+	i->t.user_scan = sas_user_scan;
 
 	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
 	i->t.host_attrs.ac.class = &sas_host_class.class;
Index: scsi-misc-2.6/include/scsi/scsi.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi.h	2006-01-13 17:56:02.000000000 +0100
+++ scsi-misc-2.6/include/scsi/scsi.h	2006-01-13 18:26:17.000000000 +0100
@@ -32,6 +32,12 @@
 extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 
 /*
+ * Special value for scanning to specify scanning or rescanning of all
+ * possible channels, (target) ids, or luns on a given shost.
+ */
+#define SCAN_WILD_CARD	~0
+
+/*
  *      SCSI opcodes
  */
 
Index: scsi-misc-2.6/include/scsi/scsi_transport.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_transport.h	2006-01-13 17:56:02.000000000 +0100
+++ scsi-misc-2.6/include/scsi/scsi_transport.h	2006-01-13 18:26:17.000000000 +0100
@@ -30,12 +30,9 @@
 	struct transport_container device_attrs;
 
 	/*
-	 * If set, call target_parent prior to allocating a scsi_target,
-	 * so we get the appropriate parent for the target. This function
-	 * is required for transports like FC and iSCSI that do not put the
-	 * scsi_target under scsi_host.
+	 * If set, called from sysfs and legacy procfs rescanning code.
 	 */
-	struct device *(*target_parent)(struct Scsi_Host *, int, uint);
+	int (*user_scan)(struct Scsi_Host *, uint, uint, uint);
 
 	/* The size of the specific transport attribute structure (a
 	 * space of this size will be left at the end of the
Index: scsi-misc-2.6/drivers/scsi/scsi_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_proc.c	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_proc.c	2006-01-13 18:26:17.000000000 +0100
@@ -31,6 +31,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -200,7 +201,10 @@
 	if (IS_ERR(shost))
 		return PTR_ERR(shost);
 
-	error = scsi_scan_host_selected(shost, channel, id, lun, 1);
+	if (shost->transportt->user_scan)
+		error = shost->transportt->user_scan(shost, channel, id, lun);
+	else
+		error = scsi_scan_host_selected(shost, channel, id, lun, 1);
 	scsi_host_put(shost);
 	return error;
 }
Index: scsi-misc-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_sysfs.c	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_sysfs.c	2006-01-13 18:26:17.000000000 +0100
@@ -106,7 +106,10 @@
 		return -EINVAL;
 	if (check_set(&lun, s3))
 		return -EINVAL;
-	res = scsi_scan_host_selected(shost, channel, id, lun, 1);
+	if (shost->transportt->user_scan)
+		res = shost->transportt->user_scan(shost, channel, id, lun);
+	else
+		res = scsi_scan_host_selected(shost, channel, id, lun, 1);
 	return res;
 }
 
Index: scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_fc.c	2006-01-13 17:55:57.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c	2006-01-13 18:26:17.000000000 +0100
@@ -1090,17 +1090,23 @@
 /*
  * Must be called with shost->host_lock held
  */
-static struct device *fc_target_parent(struct Scsi_Host *shost,
-					int channel, uint id)
+static int fc_user_scan(struct Scsi_Host *shost, uint channel,
+		uint id, uint lun)
 {
 	struct fc_rport *rport;
 
-	list_for_each_entry(rport, &fc_host_rports(shost), peers)
-		if ((rport->channel == channel) &&
-		    (rport->scsi_target_id == id))
-			return &rport->dev;
+	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
+		if (rport->scsi_target_id == -1)
+			continue;
 
-	return NULL;
+		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
+		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
+			scsi_scan_target(&rport->dev, rport->channel,
+					 rport->scsi_target_id, lun, 1);
+		}
+	}
+
+	return 0;
 }
 
 struct scsi_transport_template *
@@ -1139,7 +1145,7 @@
 	/* Transport uses the shost workq for scsi scanning */
 	i->t.create_work_queue = 1;
 
-	i->t.target_parent = fc_target_parent;
+	i->t.user_scan = fc_user_scan;
 	
 	/*
 	 * Setup SCSI Target Attributes.
