From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 3/3] use default attributes for scsi_host
Date: Thu, 20 Sep 2007 13:48:14 +0200
Message-ID: <20070920114814.4824F3110BD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXITLsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 07:48:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: kay.sievers@vrfy.org, linux-scsi@vger.kernel.org

This patch removes the unused sysfs attribute overwriting logic for
most of the attributes, and plugs them into the driver core default
attribute creation.
 
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 hosts.c      |    1 
 scsi_priv.h  |    1 
 scsi_sysfs.c |   88 +++++++++++++++++++----------------------------------------
 3 files changed, 31 insertions(+), 59 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -387,7 +387,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_classdev.class = &shost_class;
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
+	shost->shost_classdev.groups = scsi_sysfs_shost_attr_groups;
 
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -117,7 +117,8 @@ extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
+extern struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -200,16 +200,24 @@ shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
-static struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
-	&class_device_attr_unique_id,
-	&class_device_attr_host_busy,
-	&class_device_attr_cmd_per_lun,
-	&class_device_attr_can_queue,
-	&class_device_attr_sg_tablesize,
-	&class_device_attr_unchecked_isa_dma,
-	&class_device_attr_proc_name,
-	&class_device_attr_scan,
-	&class_device_attr_state,
+static struct attribute *scsi_shost_attrs[] = {
+	&class_device_attr_unique_id.attr,
+	&class_device_attr_host_busy.attr,
+	&class_device_attr_cmd_per_lun.attr,
+	&class_device_attr_can_queue.attr,
+	&class_device_attr_sg_tablesize.attr,
+	&class_device_attr_unchecked_isa_dma.attr,
+	&class_device_attr_proc_name.attr,
+	&class_device_attr_scan.attr,
+	NULL
+};
+
+struct attribute_group scsi_shost_attr_group = {
+	.attrs =	scsi_shost_attrs,
+};
+
+struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
+	&scsi_shost_attr_group,
 	NULL
 };
 
@@ -867,44 +875,6 @@ int scsi_register_interface(struct class_interface *intf)
 }
 EXPORT_SYMBOL(scsi_register_interface);
 
-
-static struct class_device_attribute *class_attr_overridden(
-		struct class_device_attribute **attrs,
-		struct class_device_attribute *attr)
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
-static int class_attr_add(struct class_device *classdev,
-		struct class_device_attribute *attr)
-{
-	struct class_device_attribute *base_attr;
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
-	return class_device_create_file(classdev, attr);
-}
-
 /**
  * scsi_sysfs_add_host - add scsi host to subsystem
  * @shost:     scsi host struct to add to subsystem
@@ -912,25 +882,25 @@ static int class_attr_add(struct class_device *classdev,
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
-	int error, i;
+	int error, i, state_overridden = 0;
 
+	/* add host specific attributes */
 	if (shost->hostt->shost_attrs) {
 		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
-			error = class_attr_add(&shost->shost_classdev,
+			/* Some FC driver define their own 'state' attribute */
+			if (!strcmp(shost->hostt->shost_attrs[i]->attr.name,"state"))
+				state_overridden = 1;
+			error = class_device_create_file(&shost->shost_classdev,
 					shost->hostt->shost_attrs[i]);
 			if (error)
 				return error;
 		}
 	}
-
-	for (i = 0; scsi_sysfs_shost_attrs[i]; i++) {
-		if (!class_attr_overridden(shost->hostt->shost_attrs,
-					scsi_sysfs_shost_attrs[i])) {
-			error = class_device_create_file(&shost->shost_classdev,
-					scsi_sysfs_shost_attrs[i]);
-			if (error)
-				return error;
-		}
+	if (!state_overridden) {
+		error = class_device_create_file(&shost->shost_classdev,
+						 &class_device_attr_state);
+		if (error)
+			return error;
 	}
 
 	transport_register_device(&shost->shost_gendev);
