From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v4 2/3] Rework the code for caching Vital Product Data (VPD)
Date: Tue, 29 Aug 2017 08:50:12 -0700
Message-ID: <20170829155013.11124-3-bart.vanassche@wdc.com>
References: <20170829155013.11124-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20997 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbdH2Pvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 11:51:41 -0400
In-Reply-To: <20170829155013.11124-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

Introduce the scsi_get_vpd_buf() and scsi_update_vpd_page()
functions. The only functional change in this patch is that if
updating page 0x80 fails that it is attempted to update page 0x83.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane M Seymour <shane.seymour@hpe.com>
---
 drivers/scsi/scsi.c | 144 ++++++++++++++++++++++++----------------------------
 1 file changed, 66 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d38c6d463b8..f3f4926a3e77 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -411,6 +411,63 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
+/**
+ * scsi_get_vpd_buf - Get Vital Product Data from a SCSI device
+ * @sdev: The device to ask
+ * @page: Which Vital Product Data to return
+ * @len: Upon success, the VPD length will be stored in *@len.
+ *
+ * Returns %NULL upon failure.
+ */
+static unsigned char *scsi_get_vpd_buf(struct scsi_device *sdev, u8 page,
+				       int *len)
+{
+	unsigned char *vpd_buf;
+	int vpd_len = SCSI_VPD_PG_LEN, result;
+
+retry_pg:
+	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
+	if (!vpd_buf)
+		return NULL;
+
+	result = scsi_vpd_inquiry(sdev, vpd_buf, page, vpd_len);
+	if (result < 0) {
+		kfree(vpd_buf);
+		return NULL;
+	}
+	if (result > vpd_len) {
+		vpd_len = result;
+		kfree(vpd_buf);
+		goto retry_pg;
+	}
+
+	*len = result;
+
+	return vpd_buf;
+}
+
+static void scsi_update_vpd_page(struct scsi_device *sdev, u8 page,
+				 unsigned char __rcu **sdev_vpd_buf,
+				 int *sdev_vpd_len)
+{
+	unsigned char *vpd_buf;
+	int len;
+
+	vpd_buf = scsi_get_vpd_buf(sdev, page, &len);
+	if (!vpd_buf)
+		return;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	rcu_swap_protected(*sdev_vpd_buf, vpd_buf,
+			   lockdep_is_held(&sdev->inquiry_mutex));
+	*sdev_vpd_len = len;
+	mutex_unlock(&sdev->inquiry_mutex);
+
+	synchronize_rcu();
+
+	kfree(vpd_buf);
+}
+
 /**
  * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
  * @sdev: The device to ask
@@ -422,95 +479,26 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
  */
 void scsi_attach_vpd(struct scsi_device *sdev)
 {
-	int result, i;
-	int vpd_len = SCSI_VPD_PG_LEN;
-	int pg80_supported = 0;
-	int pg83_supported = 0;
-	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
+	int i, vpd_len;
+	unsigned char *vpd_buf;
 
 	if (!scsi_device_supports_vpd(sdev))
 		return;
 
-retry_pg0:
-	vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
-	if (!vpd_buf)
-		return;
-
 	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
-	if (result < 0) {
-		kfree(vpd_buf);
+	vpd_buf = scsi_get_vpd_buf(sdev, 0, &vpd_len);
+	if (!vpd_buf)
 		return;
-	}
-	if (result > vpd_len) {
-		vpd_len = result;
-		kfree(vpd_buf);
-		goto retry_pg0;
-	}
 
-	for (i = 4; i < result; i++) {
+	for (i = 4; i < vpd_len; i++) {
 		if (vpd_buf[i] == 0x80)
-			pg80_supported = 1;
+			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80,
+					     &sdev->vpd_pg80_len);
 		if (vpd_buf[i] == 0x83)
-			pg83_supported = 1;
+			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83,
+					     &sdev->vpd_pg83_len);
 	}
 	kfree(vpd_buf);
-	vpd_len = SCSI_VPD_PG_LEN;
-
-	if (pg80_supported) {
-retry_pg80:
-		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
-		if (!vpd_buf)
-			return;
-
-		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
-		if (result < 0) {
-			kfree(vpd_buf);
-			return;
-		}
-		if (result > vpd_len) {
-			vpd_len = result;
-			kfree(vpd_buf);
-			goto retry_pg80;
-		}
-		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg80;
-		sdev->vpd_pg80_len = result;
-		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
-		mutex_unlock(&sdev->inquiry_mutex);
-		synchronize_rcu();
-		if (orig_vpd_buf) {
-			kfree(orig_vpd_buf);
-			orig_vpd_buf = NULL;
-		}
-		vpd_len = SCSI_VPD_PG_LEN;
-	}
-
-	if (pg83_supported) {
-retry_pg83:
-		vpd_buf = kmalloc(vpd_len, GFP_KERNEL);
-		if (!vpd_buf)
-			return;
-
-		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
-		if (result < 0) {
-			kfree(vpd_buf);
-			return;
-		}
-		if (result > vpd_len) {
-			vpd_len = result;
-			kfree(vpd_buf);
-			goto retry_pg83;
-		}
-		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg83;
-		sdev->vpd_pg83_len = result;
-		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
-		mutex_unlock(&sdev->inquiry_mutex);
-		synchronize_rcu();
-		if (orig_vpd_buf)
-			kfree(orig_vpd_buf);
-	}
 }
 
 /**
-- 
2.14.1
