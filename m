From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/12] zfcp: Remove ZFCP_SYSFS_FAILED macro and implement fcp_lun_show without macro
Date: Wed, 08 Sep 2010 14:39:53 +0200
Message-ID: <20100908124353.134401810@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:44864 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab0IHMnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:55 -0400
Content-Disposition: inline; filename=703-zfcp-sysfs-macro.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

These sysfs attributes will require different functions. Implement
them without using macros, so that the open coded functions can be
changed later.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_sysfs.c |  121 ++++++++++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 44 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:27.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:27.000000000 +0200
@@ -82,49 +82,73 @@ ZFCP_DEFINE_ATTR(zfcp_unit, unit, access
 		 (atomic_read(&unit->status) &
 		  ZFCP_STATUS_UNIT_READONLY) != 0);
 
-#define ZFCP_SYSFS_FAILED(_feat_def, _feat, _adapter, _mod_id, _reopen_id)     \
-static ssize_t zfcp_sysfs_##_feat##_failed_show(struct device *dev,	       \
-						struct device_attribute *attr, \
-						char *buf)		       \
-{									       \
-	struct _feat_def *_feat = container_of(dev, struct _feat_def, dev);    \
-									       \
-	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_ERP_FAILED)       \
-		return sprintf(buf, "1\n");				       \
-	else								       \
-		return sprintf(buf, "0\n");				       \
-}									       \
-static ssize_t zfcp_sysfs_##_feat##_failed_store(struct device *dev,	       \
-						 struct device_attribute *attr,\
-						 const char *buf, size_t count)\
-{									       \
-	struct _feat_def *_feat = container_of(dev, struct _feat_def, dev);    \
-	unsigned long val;						       \
-	int retval = 0;							       \
-									       \
-	if (!(_feat && get_device(&_feat->dev)))			       \
-		return -EBUSY;						       \
-									       \
-	if (strict_strtoul(buf, 0, &val) || val != 0) {			       \
-		retval = -EINVAL;					       \
-		goto out;						       \
-	}								       \
-									       \
-	zfcp_erp_modify_##_feat##_status(_feat, _mod_id, NULL,		       \
-					 ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);\
-	zfcp_erp_##_feat##_reopen(_feat, ZFCP_STATUS_COMMON_ERP_FAILED,	       \
-				  _reopen_id, NULL);			       \
-	zfcp_erp_wait(_adapter);					       \
-out:									       \
-	put_device(&_feat->dev);					       \
-	return retval ? retval : (ssize_t) count;			       \
-}									       \
-static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
-		     zfcp_sysfs_##_feat##_failed_show,			       \
-		     zfcp_sysfs_##_feat##_failed_store);
+static ssize_t zfcp_sysfs_port_failed_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
+
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		return sprintf(buf, "1\n");
+
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t zfcp_sysfs_port_failed_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) || val != 0)
+		return -EINVAL;
+
+	zfcp_erp_modify_port_status(port, "sypfai1", NULL,
+				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, "sypfai2",
+			     NULL);
+	zfcp_erp_wait(port->adapter);
+
+	return count;
+}
+static ZFCP_DEV_ATTR(port, failed, S_IWUSR | S_IRUGO,
+		     zfcp_sysfs_port_failed_show,
+		     zfcp_sysfs_port_failed_store);
+
+static ssize_t zfcp_sysfs_unit_failed_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
 
-ZFCP_SYSFS_FAILED(zfcp_port, port, port->adapter, "sypfai1", "sypfai2");
-ZFCP_SYSFS_FAILED(zfcp_unit, unit, unit->port->adapter, "syufai1", "syufai2");
+	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		return sprintf(buf, "1\n");
+
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t zfcp_sysfs_unit_failed_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) || val != 0)
+		return -EINVAL;
+
+	zfcp_erp_modify_unit_status(unit, "syufai1", NULL,
+				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED,
+			     "syufai2", NULL);
+	zfcp_erp_wait(unit->port->adapter);
+
+	return count;
+}
+static ZFCP_DEV_ATTR(unit, failed, S_IWUSR | S_IRUGO,
+		     zfcp_sysfs_unit_failed_show,
+		     zfcp_sysfs_unit_failed_store);
 
 static ssize_t zfcp_sysfs_adapter_failed_show(struct device *dev,
 					      struct device_attribute *attr,
@@ -394,8 +418,17 @@ ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
 		      dev_name(&unit->port->adapter->ccw_device->dev));
 ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n",
 		      (unsigned long long) unit->port->wwpn);
-ZFCP_DEFINE_SCSI_ATTR(fcp_lun, "0x%016llx\n",
-		      (unsigned long long) unit->fcp_lun);
+
+static ssize_t zfcp_sysfs_scsi_fcp_lun_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct zfcp_unit *unit = sdev->hostdata;
+
+	return sprintf(buf, "0x%016llx\n", (unsigned long long) unit->fcp_lun);
+}
+static DEVICE_ATTR(fcp_lun, S_IRUGO, zfcp_sysfs_scsi_fcp_lun_show, NULL);
 
 struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
 	&dev_attr_fcp_lun,

