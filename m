From: tom.ty89@gmail.com
Subject: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Thu, 11 Aug 2016 16:26:39 +0800
Message-ID: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: tj@kernel.org, shaun.tancheff@seagate.com, shaun@tancheff.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Currently we advertise Maximum Write Same Length based on the
maximum number of sectors that one-block TRIM payload can cover.
The field are used to derived discard_max_bytes and
write_same_max_bytes limits in the block layer, which currently can
at max be 0xffffffff (32-bit).

However, with a AF 4Kn drive, the derived limits would be 65535 *
64 * 4096 = 0x3fffc0000 (34-bit). Therefore, we now devide
ATA_MAX_TRIM_RNUM with (logical sector size / 512), so that the
derived limits will not overflow.

The limits are now also consistent among drives with different
logical sector sizes. (Although that may or may not be what we
want ultimately when the SCSI / block layer allows larger
representation in the future.)

Although 4Kn ATA SSDs may not be a thing on the market yet, this
patch is necessary for forthcoming SCT Write Same translation
support, which could be available on traditional HDDs where 4Kn is
already a thing. Also it should not change the current behavior on
drives with 512-byte logical sectors.

Note: this patch is not about AF 512e drives.
Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index be9c76c..dcadcaf 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2295,6 +2295,7 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 {
 	u16 min_io_sectors;
+	u32 sector_size;
 
 	rbuf[1] = 0xb0;
 	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
@@ -2309,17 +2310,27 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	min_io_sectors = 1 << ata_id_log2_per_physical_sector(args->id);
 	put_unaligned_be16(min_io_sectors, &rbuf[6]);
 
-	/*
-	 * Optimal unmap granularity.
-	 *
-	 * The ATA spec doesn't even know about a granularity or alignment
-	 * for the TRIM command.  We can leave away most of the unmap related
-	 * VPD page entries, but we have specifify a granularity to signal
-	 * that we support some form of unmap - in thise case via WRITE SAME
-	 * with the unmap bit set.
-	 */
+	sector_size = ata_id_logical_sector_size(args->id);
 	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM, &rbuf[36]);
+		/*
+		 * Maximum write same length.
+		 *
+		 * Avoid overflow in discard_max_bytes and write_same_max_bytes
+		 * with AF 4Kn drives. Also make them consistent among drives
+		 * with different logical sector sizes.
+		 */
+		put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM /
+				   (sector_size / 512), &rbuf[36]);
+
+		/*
+		 * Optimal unmap granularity.
+		 *
+		 * The ATA spec doesn't even know about a granularity or alignment
+		 * for the TRIM command.  We can leave away most of the unmap related
+		 * VPD page entries, but we have specifify a granularity to signal
+		 * that we support some form of unmap - in thise case via WRITE SAME
+		 * with the unmap bit set.
+		 */
 		put_unaligned_be32(1, &rbuf[28]);
 	}
 
-- 
2.9.2

