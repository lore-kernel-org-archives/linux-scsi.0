From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] sd: Avoid remapping bad reference tags
Date: Mon, 20 Feb 2012 20:20:43 -0500
Message-ID: <1329787245-1899-2-git-send-email-martin.petersen@oracle.com>
References: <1329787245-1899-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43261 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2BUBU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 20:20:57 -0500
In-Reply-To: <1329787245-1899-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

It does not make sense to translate ref tags with unexpected values.
Instead we simply ignore them and let the upper layers catch the
problem. Ref tags that contain the expected value are still remapped.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c     |    5 ++---
 drivers/scsi/sd.h     |    2 +-
 drivers/scsi/sd_dif.c |   25 ++++++-------------------
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd17cf8..77822b9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -803,9 +803,8 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 
-		if (blk_integrity_rq(rq) &&
-		    sd_dif_prepare(rq, block, sdp->sector_size) == -EIO)
-			goto out;
+		if (blk_integrity_rq(rq))
+			sd_dif_prepare(rq, block, sdp->sector_size);
 
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..47c52a6 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -156,7 +156,7 @@ struct sd_dif_tuple {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_config_host(struct scsi_disk *);
-extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
+extern void sd_dif_prepare(struct request *rq, sector_t, unsigned int);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 0cb39ff..1c47fa4 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -366,7 +366,8 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
  *
  * Type 3 does not have a reference tag so no remapping is required.
  */
-int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_sz)
+void sd_dif_prepare(struct request *rq, sector_t hw_sector,
+		    unsigned int sector_sz)
 {
 	const int tuple_sz = sizeof(struct sd_dif_tuple);
 	struct bio *bio;
@@ -378,7 +379,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
 
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
-		return 0;
+		return;
 
 	phys = hw_sector & 0xffffffff;
 
@@ -397,10 +398,9 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
 
-				if (be32_to_cpu(sdt->ref_tag) != virt)
-					goto error;
+				if (be32_to_cpu(sdt->ref_tag) == virt)
+					sdt->ref_tag = cpu_to_be32(phys);
 
-				sdt->ref_tag = cpu_to_be32(phys);
 				virt++;
 				phys++;
 			}
@@ -410,16 +410,6 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 
 		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
 	}
-
-	return 0;
-
-error:
-	kunmap_atomic(sdt, KM_USER0);
-	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u, app %4x\n",
-		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
-		  be16_to_cpu(sdt->app_tag));
-
-	return -EILSEQ;
 }
 
 /*
@@ -463,10 +453,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 					return;
 				}
 
-				if (be32_to_cpu(sdt->ref_tag) != phys &&
-				    sdt->app_tag != 0xffff)
-					sdt->ref_tag = 0xffffffff; /* Bad ref */
-				else
+				if (be32_to_cpu(sdt->ref_tag) == phys)
 					sdt->ref_tag = cpu_to_be32(virt);
 
 				virt++;
-- 
1.7.8.3.21.gab8a7

