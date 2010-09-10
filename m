From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Update thin provisioning support
Date: Fri, 10 Sep 2010 01:22:07 -0400
Message-ID: <yq1zkvqqikg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:19657 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0IJFWw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:22:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org


Add support for the Thin Provisioning VPD page and use the TPU and TPWS
bits to switch between UNMAP and WRITE SAME(16) for discards.  If no TP
VPD page is present we fall back to old scheme where the max descriptor
count combined with the max lba count are used trigger UNMAP.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2714bec..2325173 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2039,14 +2039,24 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		lba_count = get_unaligned_be32(&buffer[20]);
 		desc_count = get_unaligned_be32(&buffer[24]);
 
-		if (lba_count) {
-			q->limits.max_discard_sectors =
-				lba_count * sector_sz >> 9;
-
-			if (desc_count)
+		if (lba_count && desc_count) {
+			if (sdkp->tpvpd && !sdkp->tpu)
+				sdkp->unmap = 0;
+			else
 				sdkp->unmap = 1;
 		}
 
+		if (sdkp->tpvpd && !sdkp->tpu && !sdkp->tpws) {
+			sd_printk(KERN_ERR, sdkp, "Thin provisioning is " \
+				  "enabled but neither TPU, nor TPWS are " \
+				  "set. Disabling discard!\n");
+			goto out;
+		}
+
+		if (lba_count)
+			q->limits.max_discard_sectors =
+				lba_count * sector_sz >> 9;
+
 		granularity = get_unaligned_be32(&buffer[28]);
 
 		if (granularity)
@@ -2087,6 +2097,31 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+/**
+ * sd_read_thin_provisioning - Query thin provisioning VPD page
+ * @disk: disk to query
+ */
+static void sd_read_thin_provisioning(struct scsi_disk *sdkp)
+{
+	unsigned char *buffer;
+	const int vpd_len = 8;
+
+	if (sdkp->thin_provisioning == 0)
+		return;
+
+	buffer = kmalloc(vpd_len, GFP_KERNEL);
+
+	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
+		goto out;
+
+	sdkp->tpvpd = 1;
+	sdkp->tpu   = (buffer[5] >> 7) & 1;	/* UNMAP */
+	sdkp->tpws  = (buffer[5] >> 6) & 1;	/* WRITE SAME(16) with UNMAP */
+
+ out:
+	kfree(buffer);
+}
+
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
 	/*
@@ -2138,6 +2173,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_capacity(sdkp, buffer);
 
 		if (sd_try_extended_inquiry(sdp)) {
+			sd_read_thin_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f81a930..f0322de 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -62,6 +62,9 @@ struct scsi_disk {
 	unsigned	first_scan : 1;
 	unsigned	thin_provisioning : 1;
 	unsigned	unmap : 1;
+	unsigned	tpws : 1;
+	unsigned	tpu : 1;
+	unsigned	tpvpd : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 


