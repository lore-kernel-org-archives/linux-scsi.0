From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/22] zfcp: Access ports and units with container_of in sysfs code
Date: Tue, 24 Nov 2009 16:54:02 +0100
Message-ID: <20091124160136.818312000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:59806 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=704-zfcp-container-of.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When accessing port and unit attributes, use container_of instead of
dev_get_drvdata. This eliminates some code checker warnings about
aliased access of data structures.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    2 --
 drivers/s390/scsi/zfcp_sysfs.c |   15 ++++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-11-23 09:59:39.000000000 +0100
@@ -319,7 +319,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 		kfree(unit);
 		goto err_out;
 	}
-	dev_set_drvdata(&unit->sysfs_device, unit);
 	retval = -EINVAL;
 
 	/* mark unit unusable as long as sysfs registration is not complete */
@@ -688,7 +687,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 		kfree(port);
 		goto err_out;
 	}
-	dev_set_drvdata(&port->sysfs_device, port);
 	retval = -EINVAL;
 
 	if (device_register(&port->sysfs_device)) {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2009-11-23 09:59:39.000000000 +0100
@@ -19,7 +19,8 @@ static ssize_t zfcp_sysfs_##_feat##_##_n
 						   struct device_attribute *at,\
 						   char *buf)		       \
 {									       \
-	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
+					       sysfs_device);		       \
 									       \
 	return sprintf(buf, _format, _value);				       \
 }									       \
@@ -86,7 +87,8 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 						struct device_attribute *attr, \
 						char *buf)		       \
 {									       \
-	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
+					       sysfs_device);		       \
 									       \
 	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_ERP_FAILED)       \
 		return sprintf(buf, "1\n");				       \
@@ -97,7 +99,8 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 						 struct device_attribute *attr,\
 						 const char *buf, size_t count)\
 {									       \
-	struct _feat_def *_feat = dev_get_drvdata(dev);			       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
+					       sysfs_device);		       \
 	unsigned long val;						       \
 	int retval = 0;							       \
 									       \
@@ -274,7 +277,8 @@ static ssize_t zfcp_sysfs_unit_add_store
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct zfcp_port *port = dev_get_drvdata(dev);
+	struct zfcp_port *port = container_of(dev, struct zfcp_port,
+					      sysfs_device);
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = -EINVAL;
@@ -305,7 +309,8 @@ static ssize_t zfcp_sysfs_unit_remove_st
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
-	struct zfcp_port *port = dev_get_drvdata(dev);
+	struct zfcp_port *port = container_of(dev, struct zfcp_port,
+					      sysfs_device);
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = 0;

