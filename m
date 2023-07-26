Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55714C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 12:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbjGZMOj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbjGZMOe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 08:14:34 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46CA19AD;
        Wed, 26 Jul 2023 05:14:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com A5B1BC0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690372548; bh=oUjTtSSfsT+s1M0rrU8Rr6IMXX0bGDYAJXHZaIsRH9U=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=oG35zqIKrBxClLAk716LZrrVqtuTE/EmYSEto6Phg0Nmp+k8jP5WqkXuTYjdzyDo6
         ujdDvK1XGA/xSBA5Gjk/eC9SKT7zQgb99UumDwYmXwbuE2WoEQ9WnzmHLGvYX5liMP
         dOtIYEu1Orc9x/d7C17w4E6f8hEHB4mmCMES9T8D2WEePRarkaQt3Bmrrl8Z+drsAr
         sbaktD2KT+x4Kx7g5ddvXu50gZPmv07U0mz5uRxnGtLSNddqz5J8Fz7X9JFOY8owhd
         tLhexi+WkYiYR7MvSeWL47SivO0PpUFbOd/YiCnauQYuLhMtGgWA9o37sejTqhAvQp
         1/Dg5TpgbdrOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690372548; bh=oUjTtSSfsT+s1M0rrU8Rr6IMXX0bGDYAJXHZaIsRH9U=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=lhlajvWusb9R02Qj9UoYnmJ/DC1cesjp4UIKBS32hRiZUHOxYAo3gtBbvkd3DsNyi
         rSeQpI3MN0tYmUnkh7Vy4SfrG3DPcCztv2sbDsXzWzTa4wf+ZDDSTgBd7Caf+CBO3z
         9DvFYRw9zm11lqSt7NIdkDF4dFy9G6PdIxY0L5wpO2h5tymFztcaGMjK9Jl/K2Od2k
         UNM9RDJG680VrnpvcknsmIMMT1hK027v9feyBaAubIU25yed1tqdbIKkfH2hcZKm5t
         2p5yi5iGb03kL6MV60MFB8tP3dfl9aFPWx+Z69VibDAVWUlFn0Cv0YbvbNYbqwsLBw
         4Blf10LUYtirw==
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: [RFC PATCH 3/3] target: core: apply the new wrapper to iblock
Date:   Wed, 26 Jul 2023 14:55:09 +0300
Message-ID: <20230726115509.357-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230726115509.357-1-a.kovaleva@yadro.com>
References: <20230726115509.357-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/target_core_iblock.c | 94 ++++++++++++++---------------
 1 file changed, 45 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e6029ea87e2f..e8153d99a83b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -37,6 +37,8 @@
 #define IBLOCK_MAX_BIO_PER_TASK	 32	/* max # of bios to submit at a time */
 #define IBLOCK_BIO_POOL_SIZE	128
 
+#define TARGET_PREFIX "iblock"
+
 static inline struct iblock_dev *IBLOCK_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct iblock_dev, dev);
@@ -45,9 +47,8 @@ static inline struct iblock_dev *IBLOCK_DEV(struct se_device *dev)
 
 static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 {
-	pr_debug("CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
-		" Generic Target Core Stack %s\n", hba->hba_id,
-		IBLOCK_VERSION, TARGET_CORE_VERSION);
+	target_debug("CORE_HBA[%d] - TCM iblock HBA Driver %s on Generic Target Core Stack %s\n",
+		     hba->hba_id, IBLOCK_VERSION, TARGET_CORE_VERSION);
 	return 0;
 }
 
@@ -61,7 +62,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 
 	ib_dev = kzalloc(sizeof(struct iblock_dev), GFP_KERNEL);
 	if (!ib_dev) {
-		pr_err("Unable to allocate struct iblock_dev\n");
+		target_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
 
@@ -70,7 +71,7 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 	if (!ib_dev->ibd_plug)
 		goto free_dev;
 
-	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
+	target_debug("Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
 
@@ -98,17 +99,17 @@ static int iblock_configure_device(struct se_device *dev)
 	int ret;
 
 	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
-		pr_err("Missing udev_path= parameters for IBLOCK\n");
+		target_err("Missing udev_path= parameters\n");
 		return -EINVAL;
 	}
 
 	ret = bioset_init(&ib_dev->ibd_bio_set, IBLOCK_BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 	if (ret) {
-		pr_err("IBLOCK: Unable to create bioset\n");
+		target_err("Unable to create bioset\n");
 		goto out;
 	}
 
-	pr_debug( "IBLOCK: Claiming struct block_device: %s\n",
+	target_debug("Claiming struct block_device: %s\n",
 			ib_dev->ibd_udev_path);
 
 	mode = FMODE_READ|FMODE_EXCL;
@@ -151,8 +152,8 @@ static int iblock_configure_device(struct se_device *dev)
 
 		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-IP") ||
 		    !strcmp(bi->profile->name, "T10-DIF-TYPE1-IP")) {
-			pr_err("IBLOCK export of blk_integrity: %s not"
-			       " supported\n", bi->profile->name);
+			target_err("Export of blk_integrity: %s not supported\n",
+				   bi->profile->name);
 			ret = -ENOSYS;
 			goto out_blkdev_put;
 		}
@@ -165,12 +166,12 @@ static int iblock_configure_device(struct se_device *dev)
 
 		if (dev->dev_attrib.pi_prot_type) {
 			if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
-				pr_err("Unable to allocate bioset for PI\n");
+				target_err("Unable to allocate bioset for PI\n");
 				ret = -ENOMEM;
 				goto out_blkdev_put;
 			}
-			pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
-				 &bs->bio_integrity_pool);
+			target_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
+				     &bs->bio_integrity_pool);
 		}
 		dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
 	}
@@ -339,7 +340,7 @@ static void iblock_bio_done(struct bio *bio)
 	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
-		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
+		target_cmd_err(cmd, "bio error: %p,  err: %d\n", bio, bio->bi_status);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
@@ -365,7 +366,7 @@ static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
 	bio = bio_alloc_bioset(ib_dev->ibd_bd, bio_max_segs(sg_num), opf,
 			       GFP_NOIO, &ib_dev->ibd_bio_set);
 	if (!bio) {
-		pr_err("Unable to allocate memory for bio\n");
+		target_cmd_err(cmd, "Unable to allocate memory for bio\n");
 		return NULL;
 	}
 
@@ -395,7 +396,7 @@ static void iblock_end_io_flush(struct bio *bio)
 	struct se_cmd *cmd = bio->bi_private;
 
 	if (bio->bi_status)
-		pr_err("IBLOCK: cache flush failed: %d\n", bio->bi_status);
+		target_cmd_err(cmd, "Cache flush failed: %d\n", bio->bi_status);
 
 	if (cmd) {
 		if (bio->bi_status)
@@ -446,7 +447,7 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 				   target_to_linux_sector(dev,  nolb),
 				   GFP_KERNEL);
 	if (ret < 0) {
-		pr_err("blkdev_issue_discard() failed: %d\n", ret);
+		target_cmd_err(cmd, "blkdev_issue_discard() failed: %d\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -500,8 +501,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 					sbc_get_write_same_sectors(cmd));
 
 	if (cmd->prot_op) {
-		pr_err("WRITE_SAME: Protection information with IBLOCK"
-		       " backends not supported\n");
+		target_cmd_err(cmd, "WRITE_SAME: Protection information with IBLOCK backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -512,9 +512,8 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 	if (cmd->t_data_nents > 1 ||
 	    sg->length != cmd->se_dev->dev_attrib.block_size) {
-		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			" block_size: %u\n", cmd->t_data_nents, sg->length,
-			cmd->se_dev->dev_attrib.block_size);
+		target_cmd_err(cmd, "WRITE_SAME: Illegal SGL t_data_nents: %u length: %u block_size: %u\n",
+			       cmd->t_data_nents, sg->length, cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -600,8 +599,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 		switch (token) {
 		case Opt_udev_path:
 			if (ib_dev->ibd_bd) {
-				pr_err("Unable to set udev_path= while"
-					" ib_dev->ibd_bd exists\n");
+				target_err("Unable to set udev_path= while ib_dev->ibd_bd exists\n");
 				ret = -EEXIST;
 				goto out;
 			}
@@ -610,8 +608,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 				ret = -EINVAL;
 				break;
 			}
-			pr_debug("IBLOCK: Referencing UDEV path: %s\n",
-					ib_dev->ibd_udev_path);
+			target_debug("Referencing UDEV path: %s\n", ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
 			break;
 		case Opt_readonly:
@@ -623,12 +620,11 @@ static ssize_t iblock_set_configfs_dev_params(struct se_device *dev,
 			ret = kstrtoul(arg_p, 0, &tmp_readonly);
 			kfree(arg_p);
 			if (ret < 0) {
-				pr_err("kstrtoul() failed for"
-						" readonly=\n");
+				target_err("kstrtoul() failed for readonly=\n");
 				goto out;
 			}
 			ib_dev->ibd_readonly = tmp_readonly;
-			pr_debug("IBLOCK: readonly: %d\n", ib_dev->ibd_readonly);
+			target_debug("readonly: %d\n", ib_dev->ibd_readonly);
 			break;
 		case Opt_force:
 			break;
@@ -680,13 +676,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 
 	bi = bdev_get_integrity(ib_dev->ibd_bd);
 	if (!bi) {
-		pr_err("Unable to locate bio_integrity\n");
+		target_cmd_err(cmd, "Unable to locate bio_integrity\n");
 		return -ENODEV;
 	}
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, bio_max_segs(cmd->t_prot_nents));
 	if (IS_ERR(bip)) {
-		pr_err("Unable to allocate bio_integrity_payload\n");
+		target_cmd_err(cmd, "Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
@@ -695,8 +691,8 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 	bip_set_seed(bip, bio->bi_iter.bi_sector >>
 				  (bi->interval_exp - SECTOR_SHIFT));
 
-	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
-		 (unsigned long long)bip->bip_iter.bi_sector);
+	target_cmd_debug(cmd, "BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
+			 (unsigned long long)bip->bip_iter.bi_sector);
 
 	resid = bip->bip_iter.bi_size;
 	while (resid > 0 && sg_miter_next(miter)) {
@@ -705,13 +701,13 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
 		rc = bio_integrity_add_page(bio, miter->page, len,
 					    offset_in_page(miter->addr));
 		if (rc != len) {
-			pr_err("bio_integrity_add_page() failed; %d\n", rc);
+			target_cmd_err(cmd, "bio_integrity_add_page() failed; %d\n", rc);
 			sg_miter_stop(miter);
 			return -ENOMEM;
 		}
 
-		pr_debug("Added bio integrity page: %p length: %zu offset: %lu\n",
-			  miter->page, len, offset_in_page(miter->addr));
+		target_cmd_debug(cmd, "Added bio integrity page: %p length: %zu offset: %lu\n",
+				 miter->page, len, offset_in_page(miter->addr));
 
 		resid -= len;
 		if (len < miter->length)
@@ -845,7 +841,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	int ret;
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_cmd_err(cmd, "Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -853,20 +849,20 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	case PRO_REGISTER:
 	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
 		if (!ops->pr_register) {
-			pr_err("block device does not support pr_register.\n");
+			target_cmd_err(cmd, "block device does not support pr_register.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
 		/* The block layer pr ops always enables aptpl */
 		if (!aptpl)
-			pr_info("APTPL not set by initiator, but will be used.\n");
+			target_cmd_info(cmd, "APTPL not set by initiator, but will be used.\n");
 
 		ret = ops->pr_register(bdev, key, sa_key,
 				sa == PRO_REGISTER ? 0 : PR_FL_IGNORE_KEY);
 		break;
 	case PRO_RESERVE:
 		if (!ops->pr_reserve) {
-			pr_err("block_device does not support pr_reserve.\n");
+			target_cmd_err(cmd, "block_device does not support pr_reserve.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -874,7 +870,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_CLEAR:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_clear.\n");
+			target_cmd_err(cmd, "block_device does not support pr_clear.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -883,7 +879,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_preempt.\n");
+			target_cmd_err(cmd, "block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
@@ -893,14 +889,14 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_RELEASE:
 		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_pclear.\n");
+			target_cmd_err(cmd, "block_device does not support pr_pclear.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
 		ret = ops->pr_release(bdev, key, scsi_pr_type_to_block(type));
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		target_cmd_err(cmd, "Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -966,12 +962,12 @@ static sense_reason_t iblock_pr_read_keys(struct se_cmd *cmd,
 	sense_reason_t ret;
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_cmd_err(cmd, "Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (!ops->pr_read_keys) {
-		pr_err("Block device does not support read_keys.\n");
+		target_cmd_err(cmd, "Block device does not support read_keys.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -1033,12 +1029,12 @@ static sense_reason_t iblock_pr_read_reservation(struct se_cmd *cmd,
 	struct pr_held_reservation rsv = { };
 
 	if (!ops) {
-		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		target_cmd_err(cmd, "Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
 	if (!ops->pr_read_reservation) {
-		pr_err("Block device does not support read_keys.\n");
+		target_cmd_err(cmd, "Block device does not support read_keys.\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
@@ -1080,7 +1076,7 @@ static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
 		ret = iblock_pr_read_reservation(cmd, param_data);
 		break;
 	default:
-		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
+		target_cmd_err(cmd, "Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
-- 
2.40.1

