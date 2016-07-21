From: tom.ty89@gmail.com
Subject: [PATCH resend 1/5] libata-scsi: minor cleanup in ata_mselect_*()
Date: Fri, 22 Jul 2016 02:41:50 +0800
Message-ID: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de
Cc: sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

1. Removed a repeated bit masking in ata_mselect_control()
2. Moved `wce`/`d_sense` assignment below the page validity checks
3. Added/Removed empty lines where appropriate

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2bdb5da..eb5e8ff 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3618,7 +3618,6 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 	 * The first two bytes of def_cache_mpage are a header, so offsets
 	 * in mpage are off by 2 compared to buf.  Same for len.
 	 */
-
 	if (len != CACHE_MPAGE_LEN - 2) {
 		if (len < CACHE_MPAGE_LEN - 2)
 			*fp = len;
@@ -3627,8 +3626,6 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 		return -EINVAL;
 	}
 
-	wce = buf[0] & (1 << 2);
-
 	/*
 	 * Check that read-only bits are not modified.
 	 */
@@ -3642,6 +3639,8 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 		}
 	}
 
+	wce = buf[0] & (1 << 2);
+
 	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
 	tf->protocol = ATA_PROT_NODATA;
 	tf->nsect = 0;
@@ -3674,7 +3673,6 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	 * The first two bytes of def_control_mpage are a header, so offsets
 	 * in mpage are off by 2 compared to buf.  Same for len.
 	 */
-
 	if (len != CONTROL_MPAGE_LEN - 2) {
 		if (len < CONTROL_MPAGE_LEN - 2)
 			*fp = len;
@@ -3683,8 +3681,6 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 		return -EINVAL;
 	}
 
-	d_sense = buf[0] & (1 << 2);
-
 	/*
 	 * Check that read-only bits are not modified.
 	 */
@@ -3697,7 +3693,10 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 			return -EINVAL;
 		}
 	}
-	if (d_sense & (1 << 2))
+
+	d_sense = buf[0] & (1 << 2);
+
+	if (d_sense)
 		dev->flags |= ATA_DFLAG_D_SENSE;
 	else
 		dev->flags &= ~ATA_DFLAG_D_SENSE;
-- 
2.9.0

