From: brking@us.ibm.com
Subject: [PATCH 09/15] ipr: Remove tcq_enable device attribute
Date: Mon, 21 Feb 2005 15:09:23 -0600
Message-ID: <200502212109.j1LL9NR9002217@d01av02.pok.ibm.com>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:6078 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262126AbVBUVJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:24 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9Oec025044
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:24 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9O0H183692
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:24 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9Oto002231
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove driver specific tcq_enable attribute now that change_queue_type
API has made it redundant.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   76 ------------------------
 1 files changed, 76 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_delete_tcq_enable_attr drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_delete_tcq_enable_attr	2005-02-21 13:15:35.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:15:35.000000000 -0600
@@ -2729,81 +2729,6 @@ static int ipr_change_queue_type(struct 
 }
 
 /**
- * ipr_show_tcq_enable - Show if the device is enabled for tcqing
- * @dev:	device struct
- * @buf:	buffer
- *
- * Return value:
- * 	number of bytes printed to buffer
- **/
-static ssize_t ipr_show_tcq_enable(struct device *dev, char *buf)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags = 0;
-	ssize_t len = -ENXIO;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res)
-		len = snprintf(buf, PAGE_SIZE, "%d\n", res->tcq_active);
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return len;
-}
-
-/**
- * ipr_store_tcq_enable - Change the device's TCQing state
- * @dev:	device struct
- * @buf:	buffer
- *
- * Return value:
- * 	number of bytes printed to buffer
- **/
-static ssize_t ipr_store_tcq_enable(struct device *dev,
-				    const char *buf, size_t count)
-{
-	struct scsi_device *sdev = to_scsi_device(dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)sdev->host->hostdata;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags = 0;
-	int tcq_active = simple_strtoul(buf, NULL, 10);
-	ssize_t len = -ENXIO;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-
-	if (res) {
-		if (ipr_is_gscsi(res) && sdev->tagged_supported) {
-			if (tcq_active) {
-				res->tcq_active = 1;
-				scsi_activate_tcq(sdev, res->qdepth);
-			} else {
-				res->tcq_active = 0;
-				scsi_deactivate_tcq(sdev, res->qdepth);
-			}
-
-			len = strlen(buf);
-		} else if (tcq_active) {
-			len = -EINVAL;
-		}
-	}
-
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return len;
-}
-
-static struct device_attribute ipr_tcqing_attr = {
-	.attr = {
-		.name = 	"tcq_enable",
-		.mode =		S_IRUSR | S_IWUSR,
-	},
-	.store = ipr_store_tcq_enable,
-	.show = ipr_show_tcq_enable
-};
-
-/**
  * ipr_show_adapter_handle - Show the adapter's resource handle for this device
  * @dev:	device struct
  * @buf:	buffer
@@ -2836,7 +2761,6 @@ static struct device_attribute ipr_adapt
 };
 
 static struct device_attribute *ipr_dev_attrs[] = {
-	&ipr_tcqing_attr,
 	&ipr_adapter_handle_attr,
 	NULL,
 };
_
