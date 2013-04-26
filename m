From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 3/9] zfcp: cleanup unit sysfs attribute usage
Date: Fri, 26 Apr 2013 16:13:49 +0200
Message-ID: <1366985635-38270-4-git-send-email-maier@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:58634 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3DZORI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 10:17:08 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 26 Apr 2013 15:13:18 +0100
In-Reply-To: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

Let the driver core handle device attribute creation and removal. This
will simplify the code and eliminates races between attribute
availability and userspace notification via uevents.

Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c   |    2 +-
 drivers/s390/scsi/zfcp_ext.h   |    2 +-
 drivers/s390/scsi/zfcp_sysfs.c |    7 +++++--
 drivers/s390/scsi/zfcp_unit.c  |    9 ++-------
 4 files changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -129,7 +129,7 @@ static void zfcp_ccw_remove(struct ccw_d
 	zfcp_ccw_adapter_put(adapter); /* put from zfcp_ccw_adapter_by_cdev */
 
 	list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
-		zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
+		device_unregister(&unit->dev);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list)
 		device_unregister(&port->dev);
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -158,7 +158,7 @@ extern void zfcp_scsi_set_prot(struct zf
 extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
 
 /* zfcp_sysfs.c */
-extern struct attribute_group zfcp_sysfs_unit_attrs;
+extern const struct attribute_group *zfcp_unit_attr_groups[];
 extern struct attribute_group zfcp_sysfs_adapter_attrs;
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -357,10 +357,13 @@ static struct attribute *zfcp_unit_attrs
 	&dev_attr_unit_access_readonly.attr,
 	NULL
 };
-
-struct attribute_group zfcp_sysfs_unit_attrs = {
+static struct attribute_group zfcp_unit_attr_group = {
 	.attrs = zfcp_unit_attrs,
 };
+const struct attribute_group *zfcp_unit_attr_groups[] = {
+	&zfcp_unit_attr_group,
+	NULL,
+};
 
 #define ZFCP_DEFINE_LATENCY_ATTR(_name) 				\
 static ssize_t								\
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -145,6 +145,7 @@ int zfcp_unit_add(struct zfcp_port *port
 	unit->fcp_lun = fcp_lun;
 	unit->dev.parent = &port->dev;
 	unit->dev.release = zfcp_unit_release;
+	unit->dev.groups = zfcp_unit_attr_groups;
 	INIT_WORK(&unit->scsi_work, zfcp_unit_scsi_scan_work);
 
 	if (dev_set_name(&unit->dev, "0x%016llx",
@@ -160,12 +161,6 @@ int zfcp_unit_add(struct zfcp_port *port
 		goto out;
 	}
 
-	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs)) {
-		device_unregister(&unit->dev);
-		retval = -EINVAL;
-		goto out;
-	}
-
 	atomic_inc(&port->units); /* under zfcp_sysfs_port_units_mutex ! */
 
 	write_lock_irq(&port->unit_list_lock);
@@ -254,7 +249,7 @@ int zfcp_unit_remove(struct zfcp_port *p
 
 	put_device(&unit->dev);
 
-	zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
+	device_unregister(&unit->dev);
 
 	return 0;
 }

