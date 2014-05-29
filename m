From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Wed, 28 May 2014 23:28:48 -0400
Message-ID: <1401334128-15499-15-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaE2D3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:30 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

A set of flags introduced in the block layer enable better control over
how protection information is handled. These flags are useful for both
error injection and data recovery purposes. Checking can be enabled and
disabled for controller and disk, and the guard tag format is now a
per-I/O property.

Update sd_protect_op to communicate the relevant information to the
low-level device driver via a set of flags in scsi_cmnd.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c        | 56 ++++++++++++++++++++++++++++++++++++------------
 drivers/scsi/sd.h        |  4 ++--
 drivers/scsi/sd_dif.c    | 55 +++++++++++++++++++++--------------------------
 include/scsi/scsi_cmnd.h | 29 ++++++++++++++++++++++++-
 4 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 96af195224f2..cd01dd8bed52 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -592,10 +592,11 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
-static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
+static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
+					   unsigned int dix, unsigned int dif)
 {
+	struct bio_integrity_payload *bip = bio_integrity(scmd->request->bio);
 	unsigned int prot_op = SCSI_PROT_NORMAL;
-	unsigned int dix = scsi_prot_sg_count(scmd);
 
 	if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
 		if (dif && dix)
@@ -613,8 +614,37 @@ static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
 			prot_op = SCSI_PROT_WRITE_STRIP;
 	}
 
-	scsi_set_prot_op(scmd, prot_op);
+	/* Let HBA know which protection type is used so it knows which
+	 * fields to check.
+	 */
 	scsi_set_prot_type(scmd, dif);
+	scsi_set_prot_op(scmd, prot_op);
+
+	if (dix && bip_get_flag(bip, BIP_IP_CHECKSUM))
+		scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
+
+	if (dif != SD_DIF_TYPE3_PROTECTION)
+		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
+
+	if (prot_op != SCSI_PROT_WRITE_INSERT &&
+	    prot_op != SCSI_PROT_READ_INSERT &&
+	    !bip_get_flag(bip, BIP_CTRL_NOCHECK)) {
+		scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
+
+		if (dif != SD_DIF_TYPE3_PROTECTION)
+			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
+	}
+
+	if (dif) {
+		scmd->prot_flags |= SCSI_PROT_TRANSFER_PI;
+
+		if (bip_get_flag(bip, BIP_DISK_NOCHECK))
+			return 3 << 5; /* Transmit but do not check PI */
+		else
+			return 1 << 5; /* Transmit and check PI */
+	}
+
+	return 0;
 }
 
 static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
@@ -867,7 +897,8 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t block = blk_rq_pos(rq);
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
-	int ret, host_dif;
+	unsigned int dif, dix;
+	int ret;
 	unsigned char protect;
 
 	/*
@@ -994,7 +1025,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 
 		if (blk_integrity_rq(rq))
-			sd_dif_prepare(rq, block, sdp->sector_size);
+			sd_dif_prepare(SCpnt);
 
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
@@ -1010,14 +1041,15 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 					"writing" : "reading", this_count,
 					blk_rq_sectors(rq)));
 
-	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
-	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
-	if (host_dif)
-		protect = 1 << 5;
+	dix = scsi_prot_sg_count(SCpnt);
+	dif = scsi_host_dif_capable(SCpnt->device->host, sdkp->protection_type);
+
+	if (dif || dix)
+		protect = sd_setup_protect_cmnd(SCpnt, dix, dif);
 	else
 		protect = 0;
 
-	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
+	if (protect && sdkp->protection_type == SD_DIF_TYPE2_PROTECTION) {
 		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
 
 		if (unlikely(SCpnt->cmnd == NULL)) {
@@ -1105,10 +1137,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	}
 	SCpnt->sdb.length = this_count * sdp->sector_size;
 
-	/* If DIF or DIX is enabled, tell HBA how to handle request */
-	if (host_dif || scsi_prot_sg_count(SCpnt))
-		sd_prot_op(SCpnt, host_dif);
-
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
 	 * host adapter, it's safe to assume that we can at least transfer
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 620871efbf0a..4c6ed26b3613 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -175,7 +175,7 @@ struct sd_dif_tuple {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_config_host(struct scsi_disk *);
-extern void sd_dif_prepare(struct request *rq, sector_t, unsigned int);
+extern void sd_dif_prepare(struct scsi_cmnd *scmd);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
@@ -183,7 +183,7 @@ extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 static inline void sd_dif_config_host(struct scsi_disk *disk)
 {
 }
-static inline int sd_dif_prepare(struct request *rq, sector_t s, unsigned int a)
+static inline int sd_dif_prepare(struct scsi_cmnd *scmd)
 {
 	return 0;
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index d7109fff327d..bcc6d952e725 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -138,23 +138,22 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
  *
  * Type 3 does not have a reference tag so no remapping is required.
  */
-void sd_dif_prepare(struct request *rq, sector_t hw_sector,
-		    unsigned int sector_sz)
+void sd_dif_prepare(struct scsi_cmnd *scmd)
 {
-	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	const int tuple_sz = sizeof(struct t10_pi_tuple);
 	struct bio *bio;
 	struct scsi_disk *sdkp;
-	struct sd_dif_tuple *sdt;
+	struct t10_pi_tuple *pi;
 	u32 phys, virt;
 
-	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
+	sdkp = scsi_disk(scmd->request->rq_disk);
 
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
 		return;
 
-	phys = hw_sector & 0xffffffff;
+	phys = scsi_prot_ref_tag(scmd);
 
-	__rq_for_each_bio(bio, rq) {
+	__rq_for_each_bio(bio, scmd->request) {
 		struct bio_integrity_payload *bip = bio_integrity(bio);
 		struct bio_vec iv;
 		struct bvec_iter iter;
@@ -167,19 +166,18 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			sdt = kmap_atomic(iv.bv_page)
-				+ iv.bv_offset;
+			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
 
-			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
-				if (be32_to_cpu(sdt->ref_tag) == virt)
-					sdt->ref_tag = cpu_to_be32(phys);
+				if (be32_to_cpu(pi->ref_tag) == virt)
+					pi->ref_tag = cpu_to_be32(phys);
 
 				virt++;
 				phys++;
 			}
 
-			kunmap_atomic(sdt);
+			kunmap_atomic(pi);
 		}
 
 		bip_set_flag(bip, BIP_MAPPED_INTEGRITY);
@@ -192,11 +190,11 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
  */
 void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 {
-	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	const int tuple_sz = sizeof(struct t10_pi_tuple);
 	struct scsi_disk *sdkp;
 	struct bio *bio;
-	struct sd_dif_tuple *sdt;
-	unsigned int j, sectors, sector_sz;
+	struct t10_pi_tuple *pi;
+	unsigned int j, intervals;
 	u32 phys, virt;
 
 	sdkp = scsi_disk(scmd->request->rq_disk);
@@ -204,12 +202,8 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION || good_bytes == 0)
 		return;
 
-	sector_sz = scmd->device->sector_size;
-	sectors = good_bytes / sector_sz;
-
-	phys = blk_rq_pos(scmd->request) & 0xffffffff;
-	if (sector_sz == 4096)
-		phys >>= 3;
+	intervals = good_bytes / scmd->device->sector_size;
+	phys = scsi_prot_ref_tag(scmd);
 
 	__rq_for_each_bio(bio, scmd->request) {
 		struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -219,25 +213,24 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			sdt = kmap_atomic(iv.bv_page)
-				+ iv.bv_offset;
+			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
 
-			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
-				if (sectors == 0) {
-					kunmap_atomic(sdt);
+				if (intervals == 0) {
+					kunmap_atomic(pi);
 					return;
 				}
 
-				if (be32_to_cpu(sdt->ref_tag) == phys)
-					sdt->ref_tag = cpu_to_be32(virt);
+				if (be32_to_cpu(pi->ref_tag) == phys)
+					pi->ref_tag = cpu_to_be32(virt);
 
 				virt++;
 				phys++;
-				sectors--;
+				intervals--;
 			}
 
-			kunmap_atomic(sdt);
+			kunmap_atomic(pi);
 		}
 	}
 }
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index dd7c998221b3..efa4e8da3ec0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -9,9 +9,10 @@
 #include <linux/scatterlist.h>
 
 struct Scsi_Host;
-struct scsi_device;
 struct scsi_driver;
 
+#include <scsi/scsi_device.h>
+
 /*
  * MAX_COMMAND_SIZE is:
  * The longest fixed-length SCSI CDB as per the SCSI standard.
@@ -80,6 +81,7 @@ struct scsi_cmnd {
 
 	unsigned char prot_op;
 	unsigned char prot_type;
+	unsigned char prot_flags;
 
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
@@ -245,6 +247,20 @@ static inline unsigned char scsi_get_prot_op(struct scsi_cmnd *scmd)
 	return scmd->prot_op;
 }
 
+enum scsi_prot_flags {
+	SCSI_PROT_TRANSFER_PI		= 1 << 0,
+	SCSI_PROT_GUARD_CHECK		= 1 << 1,
+	SCSI_PROT_REF_CHECK		= 1 << 2,
+	SCSI_PROT_REF_INCREMENT		= 1 << 3,
+	SCSI_PROT_IP_CHECKSUM		= 1 << 4,
+};
+
+static inline unsigned int scsi_prot_flagged(struct scsi_cmnd *scmd,
+					     enum scsi_prot_flags flag)
+{
+	return scmd->prot_flags & flag;
+}
+
 /*
  * The controller usually does not know anything about the target it
  * is communicating with.  However, when DIX is enabled the controller
@@ -273,6 +289,17 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
+{
+	return scmd->device->sector_size;
+}
+
+static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request) >>
+		(ilog2(scsi_prot_interval(scmd)) - 9) & 0xffffffff;
+}
+
 static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)
 {
 	return cmd->prot_sdb ? cmd->prot_sdb->table.nents : 0;
-- 
1.9.0

