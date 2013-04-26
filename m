From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 2/9] zfcp: cleanup port sysfs attribute usage
Date: Fri, 26 Apr 2013 16:13:48 +0200
Message-ID: <1366985635-38270-3-git-send-email-maier@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:33728 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3DZOOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 10:14:23 -0400
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 26 Apr 2013 15:09:03 +0100
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
 drivers/s390/scsi/zfcp_aux.c   |    7 +------
 drivers/s390/scsi/zfcp_ccw.c   |    2 +-
 drivers/s390/scsi/zfcp_ext.h   |    2 +-
 drivers/s390/scsi/zfcp_fc.c    |    2 +-
 drivers/s390/scsi/zfcp_sysfs.c |   12 ++++++------
 5 files changed, 10 insertions(+), 15 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -530,6 +530,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	port->wwpn = wwpn;
 	port->rport_task = RPORT_NONE;
 	port->dev.parent = &adapter->ccw_device->dev;
+	port->dev.groups = zfcp_port_attr_groups;
 	port->dev.release = zfcp_port_release;
 
 	if (dev_set_name(&port->dev, "0x%016llx", (unsigned long long)wwpn)) {
@@ -543,10 +544,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 		goto err_out;
 	}
 
-	if (sysfs_create_group(&port->dev.kobj,
-			       &zfcp_sysfs_port_attrs))
-		goto err_out_put;
-
 	write_lock_irq(&adapter->port_list_lock);
 	list_add_tail(&port->list, &adapter->port_list);
 	write_unlock_irq(&adapter->port_list_lock);
@@ -555,8 +552,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	return port;
 
-err_out_put:
-	device_unregister(&port->dev);
 err_out:
 	zfcp_ccw_adapter_put(adapter);
 	return ERR_PTR(retval);
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -132,7 +132,7 @@ static void zfcp_ccw_remove(struct ccw_d
 		zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list)
-		zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
+		device_unregister(&port->dev);
 
 	zfcp_adapter_unregister(adapter);
 }
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -160,7 +160,7 @@ extern void zfcp_scsi_dif_sense_error(st
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
 extern struct attribute_group zfcp_sysfs_adapter_attrs;
-extern struct attribute_group zfcp_sysfs_port_attrs;
+extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -668,7 +668,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 
 	list_for_each_entry_safe(port, tmp, &remove_lh, list) {
 		zfcp_erp_port_shutdown(port, 0, "fcegpf2");
-		zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
+		device_unregister(&port->dev);
 	}
 
 	return ret;
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -268,7 +268,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	put_device(&port->dev);
 
 	zfcp_erp_port_shutdown(port, 0, "syprs_1");
-	zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
+	device_unregister(&port->dev);
  out:
 	zfcp_ccw_adapter_put(adapter);
 	return retval ? retval : (ssize_t) count;
@@ -340,13 +340,13 @@ static struct attribute *zfcp_port_attrs
 	&dev_attr_port_access_denied.attr,
 	NULL
 };
-
-/**
- * zfcp_sysfs_port_attrs - sysfs attributes for all other ports
- */
-struct attribute_group zfcp_sysfs_port_attrs = {
+static struct attribute_group zfcp_port_attr_group = {
 	.attrs = zfcp_port_attrs,
 };
+const struct attribute_group *zfcp_port_attr_groups[] = {
+	&zfcp_port_attr_group,
+	NULL,
+};
 
 static struct attribute *zfcp_unit_attrs[] = {
 	&dev_attr_unit_failed.attr,

