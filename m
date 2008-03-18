From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/8] use default attributes for scsi_host
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.8059A159167@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYCRNcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


This patch removes the unused sysfs attibute overwriting logic for
the scsi host attibutes, and plugs them into the driver core default
attribute creation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_priv.h  |    1 +
 drivers/scsi/scsi_sysfs.c |   84 ++++++++++++--------------------------------
 3 files changed, 25 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 577e604..f20894b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -393,6 +393,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_dev.class = &shost_class;
 	snprintf(shost->shost_dev.bus_id, BUS_ID_SIZE, "host%d",
 		 shost->host_no);
+	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
 
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3f34e93..b33e725 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -121,6 +121,7 @@ extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
+extern struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 15928f3..7d744e0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -251,21 +251,30 @@ shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
-static struct device_attribute *scsi_sysfs_shost_attrs[] = {
-	&dev_attr_unique_id,
-	&dev_attr_host_busy,
-	&dev_attr_cmd_per_lun,
-	&dev_attr_can_queue,
-	&dev_attr_sg_tablesize,
-	&dev_attr_unchecked_isa_dma,
-	&dev_attr_proc_name,
-	&dev_attr_scan,
-	&dev_attr_hstate,
-	&dev_attr_supported_mode,
-	&dev_attr_active_mode,
+static struct attribute *scsi_sysfs_shost_attrs[] = {
+	&dev_attr_unique_id.attr,
+	&dev_attr_host_busy.attr,
+	&dev_attr_cmd_per_lun.attr,
+	&dev_attr_can_queue.attr,
+	&dev_attr_sg_tablesize.attr,
+	&dev_attr_unchecked_isa_dma.attr,
+	&dev_attr_proc_name.attr,
+	&dev_attr_scan.attr,
+	&dev_attr_hstate.attr,
+	&dev_attr_supported_mode.attr,
+	&dev_attr_active_mode.attr,
 	NULL
 };
 
+struct attribute_group scsi_shost_attr_group = {
+	.attrs =	scsi_sysfs_shost_attrs,
+};
+
+struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
+	&scsi_shost_attr_group,
+ 	NULL
+};
+
 static void scsi_device_cls_release(struct device *class_dev)
 {
 	struct scsi_device *sdev;
@@ -990,44 +999,6 @@ int scsi_register_interface(struct class_interface *intf)
 }
 EXPORT_SYMBOL(scsi_register_interface);
 
-
-static struct device_attribute *class_attr_overridden(
-		struct device_attribute **attrs,
-		struct device_attribute *attr)
-{
-	int i;
-
-	if (!attrs)
-		return NULL;
-	for (i = 0; attrs[i]; i++)
-		if (!strcmp(attrs[i]->attr.name, attr->attr.name))
-			return attrs[i];
-	return NULL;
-}
-
-static int class_attr_add(struct device *classdev,
-		struct device_attribute *attr)
-{
-	struct device_attribute *base_attr;
-
-	/*
-	 * Spare the caller from having to copy things it's not interested in.
-	 */
-	base_attr = class_attr_overridden(scsi_sysfs_shost_attrs, attr);
-	if (base_attr) {
-		/* extend permissions */
-		attr->attr.mode |= base_attr->attr.mode;
-
-		/* override null show/store with default */
-		if (!attr->show)
-			attr->show = base_attr->show;
-		if (!attr->store)
-			attr->store = base_attr->store;
-	}
-
-	return device_create_file(classdev, attr);
-}
-
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
@@ -1037,20 +1008,11 @@ int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
 	int error, i;
 
+	/* add host specific attributes */
 	if (shost->hostt->shost_attrs) {
 		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
-			error = class_attr_add(&shost->shost_dev,
-					shost->hostt->shost_attrs[i]);
-			if (error)
-				return error;
-		}
-	}
-
-	for (i = 0; scsi_sysfs_shost_attrs[i]; i++) {
-		if (!class_attr_overridden(shost->hostt->shost_attrs,
-					scsi_sysfs_shost_attrs[i])) {
 			error = device_create_file(&shost->shost_dev,
-					scsi_sysfs_shost_attrs[i]);
+					shost->hostt->shost_attrs[i]);
 			if (error)
 				return error;
 		}
-- 
1.5.2.4

