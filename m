From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 2/3] zfcp: bring back unit sysfs attributes for automatic LUN scan
Date: Thu, 13 Nov 2014 14:59:47 +0100
Message-ID: <1415887188-40233-3-git-send-email-maier@linux.vnet.ibm.com>
References: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49023 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaKMOAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 09:00:32 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 13 Nov 2014 14:00:31 -0000
In-Reply-To: <1415887188-40233-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

Through sysfs attributes, zfcp unit objects
provide a trigger for manual LUN recovery
and export information for problem determination.

With commit
f8210e34887e1feb977a9b6b8caa086855af40c9
"[SCSI] zfcp: Allow midlayer to scan for LUNs when running in NPIV mode"
and when attaching SCSI devices through this new optional method,
no more zfcp unit objects are allocated for such SCSI devices.
Hence, the above-mentioned trigger and information were missing.

The information and context is located in SCSI transport device data since
b62a8d9b45b971a67a0f8413338c230e3117dff5
"[SCSI] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit"
57c237731b92fadc7d44824276313ec330b1989b
"[SCSI] zfcp: Add zfcp private struct as SCSI device driver data"
Hence, introduce the trigger and the information unconditionally
for all SCSI devices attached through zfcp.

We prefix the attribute names with 'zfcp_' to prevent collisions and
to avoid mix-ups such as with the common 'state' attribute.

Since some of the new attribute views do not need zfcp_port
in the ZFCP_DEFINE_SCSI_ATTR helper macro, remove zfcp_port
to avoid compiler warnings on unused variable.
It's easy to open code the conversion from zfcp_scsi_dev to zfcp_port
for the two already existing attributes hba_id and wwpn.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_sysfs.c | 52 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 6b66412..a488c09 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -437,16 +437,15 @@ static ssize_t zfcp_sysfs_scsi_##_name##_show(struct device *dev,	\
 {                                                                        \
 	struct scsi_device *sdev = to_scsi_device(dev);			 \
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);		 \
-	struct zfcp_port *port = zfcp_sdev->port;			 \
 									 \
 	return sprintf(buf, _format, _value);                            \
 }                                                                        \
 static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, NULL);
 
 ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
-		      dev_name(&port->adapter->ccw_device->dev));
+		      dev_name(&zfcp_sdev->port->adapter->ccw_device->dev));
 ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n",
-		      (unsigned long long) port->wwpn);
+		      (unsigned long long) zfcp_sdev->port->wwpn);
 
 static ssize_t zfcp_sysfs_scsi_fcp_lun_show(struct device *dev,
 					    struct device_attribute *attr,
@@ -458,6 +457,49 @@ static ssize_t zfcp_sysfs_scsi_fcp_lun_show(struct device *dev,
 }
 static DEVICE_ATTR(fcp_lun, S_IRUGO, zfcp_sysfs_scsi_fcp_lun_show, NULL);
 
+ZFCP_DEFINE_SCSI_ATTR(zfcp_access_denied, "%d\n",
+		      (atomic_read(&zfcp_sdev->status) &
+		       ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
+
+static ssize_t zfcp_sysfs_scsi_zfcp_failed_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned int status = atomic_read(&sdev_to_zfcp(sdev)->status);
+	unsigned int failed = status & ZFCP_STATUS_COMMON_ERP_FAILED ? 1 : 0;
+
+	return sprintf(buf, "%d\n", failed);
+}
+
+static ssize_t zfcp_sysfs_scsi_zfcp_failed_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) || val != 0)
+		return -EINVAL;
+
+	zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
+	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
+			    "syufai3");
+	zfcp_erp_wait(sdev_to_zfcp(sdev)->port->adapter);
+
+	return count;
+}
+static DEVICE_ATTR(zfcp_failed, S_IWUSR | S_IRUGO,
+		   zfcp_sysfs_scsi_zfcp_failed_show,
+		   zfcp_sysfs_scsi_zfcp_failed_store);
+
+ZFCP_DEFINE_SCSI_ATTR(zfcp_in_recovery, "%d\n",
+		      (atomic_read(&zfcp_sdev->status) &
+		       ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
+
+ZFCP_DEFINE_SCSI_ATTR(zfcp_status, "0x%08x\n",
+		      atomic_read(&zfcp_sdev->status));
+
 struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
 	&dev_attr_fcp_lun,
 	&dev_attr_wwpn,
@@ -465,6 +507,10 @@ struct device_attribute *zfcp_sysfs_sdev_attrs[] = {
 	&dev_attr_read_latency,
 	&dev_attr_write_latency,
 	&dev_attr_cmd_latency,
+	&dev_attr_zfcp_access_denied,
+	&dev_attr_zfcp_failed,
+	&dev_attr_zfcp_in_recovery,
+	&dev_attr_zfcp_status,
 	NULL
 };
 
-- 
1.8.5.5

