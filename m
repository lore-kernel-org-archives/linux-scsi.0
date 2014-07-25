From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Fri, 25 Jul 2014 16:34:29 -0400
Message-ID: <1406320469-29352-15-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935135AbaGYUdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:53 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXquU030986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:53 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXpai014914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:52 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXpEh020597
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:51 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
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
 drivers/scsi/sd.c        | 73 ++++++++++++++++++++++++++++--------------------
 drivers/scsi/sd.h        | 66 +++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sd_dif.c    | 23 ++++++---------
 include/scsi/scsi_cmnd.h | 36 +++++++++++++++++-------
 4 files changed, 142 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3663e38ba4df..f068a22ef680 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -610,29 +610,44 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
-static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
-{
-	unsigned int prot_op = SCSI_PROT_NORMAL;
-	unsigned int dix = scsi_prot_sg_count(scmd);
-
-	if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
-		if (dif && dix)
-			prot_op = SCSI_PROT_READ_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_READ_STRIP;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_READ_INSERT;
-	} else {
-		if (dif && dix)
-			prot_op = SCSI_PROT_WRITE_PASS;
-		else if (dif && !dix)
-			prot_op = SCSI_PROT_WRITE_INSERT;
-		else if (!dif && dix)
-			prot_op = SCSI_PROT_WRITE_STRIP;
+
+
+static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
+					   unsigned int dix, unsigned int dif)
+{
+	struct bio_integrity_payload *bip = bio_integrity(scmd->request->bio);
+	unsigned int prot_op = sd_prot_op(rq_data_dir(scmd->request), dix, dif);
+	unsigned int protect = 0;
+
+	if (dix) {				/* DIX Type 0, 1, 2, 3 */
+		if (bip->bip_flags & BIP_IP_CHECKSUM)
+			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
+
+		if ((bip->bip_flags & BIP_CTRL_NOCHECK) == 0)
+			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
+	}
+
+	if (dif != SD_DIF_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
+		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
+
+		if ((bip && bip->bip_flags & BIP_CTRL_NOCHECK) == 0)
+			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
+	}
+
+	if (dif) {				/* DIX/DIF Type 1, 2, 3 */
+		scmd->prot_flags |= SCSI_PROT_TRANSFER_PI;
+
+		if (bip && bip->bip_flags & BIP_DISK_NOCHECK)
+			protect = 3 << 5;	/* Disable target PI checking */
+		else
+			protect = 1 << 5;	/* Enable target PI checking */
 	}
 
 	scsi_set_prot_op(scmd, prot_op);
 	scsi_set_prot_type(scmd, dif);
+	scmd->prot_flags &= sd_prot_flag_mask(prot_op);
+
+	return protect;
 }
 
 static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
@@ -893,7 +908,8 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	sector_t block = blk_rq_pos(rq);
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
-	int ret, host_dif;
+	unsigned int dif, dix;
+	int ret;
 	unsigned char protect;
 
 	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
@@ -998,7 +1014,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		SCpnt->cmnd[0] = WRITE_6;
 
 		if (blk_integrity_rq(rq))
-			sd_dif_prepare(rq, block, sdp->sector_size);
+			sd_dif_prepare(SCpnt);
 
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
@@ -1013,14 +1029,15 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
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
@@ -1105,10 +1122,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
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
index 4c3ab8377fd3..467377884b63 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -167,6 +167,68 @@ enum sd_dif_target_protection_types {
 };
 
 /*
+ * Look up the DIX operation based on whether the command is read or
+ * write and whether dix and dif are enabled.
+ */
+static inline unsigned int sd_prot_op(bool write, bool dix, bool dif)
+{
+	/* Lookup table: bit 2 (write), bit 1 (dix), bit 0 (dif) */
+	const unsigned int ops[] = {	/* wrt dix dif */
+		SCSI_PROT_NORMAL,	/*  0	0   0  */
+		SCSI_PROT_READ_STRIP,	/*  0	0   1  */
+		SCSI_PROT_READ_INSERT,	/*  0	1   0  */
+		SCSI_PROT_READ_PASS,	/*  0	1   1  */
+		SCSI_PROT_NORMAL,	/*  1	0   0  */
+		SCSI_PROT_WRITE_INSERT, /*  1	0   1  */
+		SCSI_PROT_WRITE_STRIP,	/*  1	1   0  */
+		SCSI_PROT_WRITE_PASS,	/*  1	1   1  */
+	};
+
+	return ops[write << 2 | dix << 1 | dif];
+}
+
+/*
+ * Returns a mask of the protection flags that are valid for a given DIX
+ * operation.
+ */
+static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
+{
+	const unsigned int flag_mask[] = {
+		[SCSI_PROT_NORMAL]		= 0,
+
+		[SCSI_PROT_READ_STRIP]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT,
+
+		[SCSI_PROT_READ_INSERT]		= SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_READ_PASS]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_WRITE_INSERT]	= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_REF_INCREMENT,
+
+		[SCSI_PROT_WRITE_STRIP]		= SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+
+		[SCSI_PROT_WRITE_PASS]		= SCSI_PROT_TRANSFER_PI |
+						  SCSI_PROT_GUARD_CHECK |
+						  SCSI_PROT_REF_CHECK |
+						  SCSI_PROT_REF_INCREMENT |
+						  SCSI_PROT_IP_CHECKSUM,
+	};
+
+	return flag_mask[prot_op];
+}
+
+/*
  * Data Integrity Field tuple.
  */
 struct sd_dif_tuple {
@@ -178,7 +240,7 @@ struct sd_dif_tuple {
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_config_host(struct scsi_disk *);
-extern void sd_dif_prepare(struct request *rq, sector_t, unsigned int);
+extern void sd_dif_prepare(struct scsi_cmnd *scmd);
 extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
@@ -186,7 +248,7 @@ extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
 static inline void sd_dif_config_host(struct scsi_disk *disk)
 {
 }
-static inline int sd_dif_prepare(struct request *rq, sector_t s, unsigned int a)
+static inline int sd_dif_prepare(struct scsi_cmnd *scmd)
 {
 	return 0;
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index b7eaeadc18f9..14c7d42a11c2 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -106,8 +106,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
  *
  * Type 3 does not have a reference tag so no remapping is required.
  */
-void sd_dif_prepare(struct request *rq, sector_t hw_sector,
-		    unsigned int sector_sz)
+void sd_dif_prepare(struct scsi_cmnd *scmd)
 {
 	const int tuple_sz = sizeof(struct t10_pi_tuple);
 	struct bio *bio;
@@ -115,14 +114,14 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 	struct t10_pi_tuple *pi;
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
@@ -163,7 +162,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	struct scsi_disk *sdkp;
 	struct bio *bio;
 	struct t10_pi_tuple *pi;
-	unsigned int j, sectors, sector_sz;
+	unsigned int j, intervals;
 	u32 phys, virt;
 
 	sdkp = scsi_disk(scmd->request->rq_disk);
@@ -171,12 +170,8 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION || good_bytes == 0)
 		return;
 
-	sector_sz = scmd->device->sector_size;
-	sectors = good_bytes / sector_sz;
-
-	phys = blk_rq_pos(scmd->request) & 0xffffffff;
-	if (sector_sz == 4096)
-		phys >>= 3;
+	intervals = good_bytes / scsi_prot_interval(scmd);
+	phys = scsi_prot_ref_tag(scmd);
 
 	__rq_for_each_bio(bio, scmd->request) {
 		struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -190,7 +185,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 
 			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
-				if (sectors == 0) {
+				if (intervals == 0) {
 					kunmap_atomic(pi);
 					return;
 				}
@@ -200,7 +195,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 
 				virt++;
 				phys++;
-				sectors--;
+				intervals--;
 			}
 
 			kunmap_atomic(pi);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 42e62cfff515..12af53cb4d70 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -10,9 +10,10 @@
 #include <scsi/scsi_device.h>
 
 struct Scsi_Host;
-struct scsi_device;
 struct scsi_driver;
 
+#include <scsi/scsi_device.h>
+
 /*
  * MAX_COMMAND_SIZE is:
  * The longest fixed-length SCSI CDB as per the SCSI standard.
@@ -81,6 +82,7 @@ struct scsi_cmnd {
 
 	unsigned char prot_op;
 	unsigned char prot_type;
+	unsigned char prot_flags;
 
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
@@ -252,6 +254,14 @@ static inline unsigned char scsi_get_prot_op(struct scsi_cmnd *scmd)
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
 /*
  * The controller usually does not know anything about the target it
  * is communicating with.  However, when DIX is enabled the controller
@@ -280,6 +290,17 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
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
@@ -317,17 +338,12 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd,
 					    struct scsi_data_buffer *sdb)
 {
 	unsigned int xfer_len = sdb->length;
-	unsigned int prot_op = scsi_get_prot_op(scmd);
-	unsigned int sector_size = scmd->device->sector_size;
+	unsigned int prot_interval = scsi_prot_interval(scmd);
 
-	switch (prot_op) {
-	case SCSI_PROT_NORMAL:
-	case SCSI_PROT_WRITE_STRIP:
-	case SCSI_PROT_READ_INSERT:
-		return xfer_len;
-	}
+	if (scmd->prot_flags & SCSI_PROT_TRANSFER_PI)
+		xfer_len += (xfer_len >> ilog2(prot_interval)) * 8;
 
-	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
+	return xfer_len;
 }
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.9.3

