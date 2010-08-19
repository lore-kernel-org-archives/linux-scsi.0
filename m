From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/6] sd: Update thin provisioning support
Date: Thu, 19 Aug 2010 11:49:01 -0400
Message-ID: <1282232941-9910-7-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Add support for the Thin Provisioning VPD page and use the TPU and TPWS
bits to switch between UNMAP and WRITE SAME(16) for discards.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   40 +++++++++++++++++++++++++++++++++++-----
 drivers/scsi/sd.h |    2 ++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8802e48..7d6a61c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1991,14 +1991,19 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		lba_count = get_unaligned_be32(&buffer[20]);
 		desc_count = get_unaligned_be32(&buffer[24]);
 
-		if (lba_count) {
+		if (sdkp->tpu && desc_count && lba_count)
+			sdkp->unmap = 1;
+		else if (!sdkp->tpws) {
+			sd_printk(KERN_ERR, sdkp, "Thin provisioning is "  \
+				  "enabled but neither TPU, nor TPWS are " \
+				  "set. Disabling discard!\n");
+			goto out;
+		}
+
+		if (lba_count)
 			q->limits.max_discard_sectors =
 				lba_count * sector_sz >> 9;
 
-			if (desc_count)
-				sdkp->unmap = 1;
-		}
-
 		granularity = get_unaligned_be32(&buffer[28]);
 
 		if (granularity)
@@ -2039,6 +2044,30 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
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
@@ -2090,6 +2119,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_capacity(sdkp, buffer);
 
 		if (sd_try_extended_inquiry(sdp)) {
+			sd_read_thin_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 43d3caf..9646062 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -62,6 +62,8 @@ struct scsi_disk {
 	unsigned	first_scan : 1;
 	unsigned	thin_provisioning : 1;
 	unsigned	unmap : 1;
+	unsigned	tpws : 1;
+	unsigned	tpu : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
-- 
1.7.2.1

