Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F425C433E9
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1440A64E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhB1F6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:58:14 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2436 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhB1F6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491893; x=1646027893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+nCZClvPRWXeXByMdBarp3rVDLfZcc7xOm2J+buTHg=;
  b=FOfBhBBAvoALmRY9x/PCxHPgB5NgGtcwMMayN7LGbfqi6+Mh0Zivk2As
   keXgGWXRXNJSFPGd46XdxVZHgOimyq1dqfTMpTpUCZL6kvogMbycdlCDj
   G6qgQrAg+3W+AO6JoMawLT1YRN9Ygyca4V3SpkZDtwxfOEt+pz/XGwsm3
   6BTqrUnD7PatW79JRiOV1/PumdUcRGkAbKa7aIrAMW0UdZcGl0jPvP50p
   V5ZxD2eA641CH/CZT2yRIeZTx7PE1qtYjtD0vP/29NjuqlRpqQ5b7rBRU
   C6ZcB7MZMglOao0TGLuAAFtYCgqqKW5bmnH82072ertH8i1xpJr5be66Y
   w==;
IronPort-SDR: rA3YEqw0Kp4TAircqdl+RIx7mfVcHf60kBYg8MdxUjJ17mbr3OalJWtPfbrd+VV+Fq2zrN7SNx
 DWklshVyWH1Sd3+ZyAReVGyNQldJMYAqTxD9Yt8y75hzOB7/HTzKmshQpWWWDJGq3DKb5fL6ty
 Xl+AFQDzgJtlEu0AmKaiQyYi1Z9GBU1HLW/uVqFejEauKZJD420sTvWkZewHessbkh674OaKei
 2gMCEk7K9oWGPwZGCknvOaf1GXI0extoX82CdPuJ4fMFk0pgUjX/j9IY2jhVEscJWY9rZSsAxX
 O0Y=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="162152791"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:57:03 +0800
IronPort-SDR: E6nY2IkZC+Sm4uDwlnX7hZp5OVcvDvx9Kcefv2yG/SUPbhc8KjnLxklklidtE2MaczgUxW6ED7
 +EIFspYR4doWMDasrF5WM7ZPVkytiksq0Poahav64vNDzrwvj6RlSD8xa4JOxn3Hzwxyhuuoy/
 QKt8YX/7p3Mk+TbdRdd2Lb5zFTktlxF+TFhxRKW7yj/PBg4h/RVIzoxUJdTqMx8KLRnWf+vjmo
 M5FB6GsTNmNmqyPImfP0OZeilooUvK6WtZOT8BrfRnOcVHVdsYq3eTvTSH/S7olQiCnhTryWuK
 NVxtjCDFa2EhE8v1a0M6bv3W
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:12 -0800
IronPort-SDR: Z8zPdriP7Z3VdhAVdEwYRzCO8QMsccu/21jBNytMY+0VpPxOCngV5z0ITQh58uDUJ+Yhwbt1Cx
 yZaPmOlIsvnlOjJqc3P3xcaHPugc+oOupuATF+gg/cPIoCc5Q4s/t/9hY9PlLiKuqKBOowKP6w
 R+qVH7Kugu4rr3zdivy5xFU/sEs8bIdCnWUeQXUN3Yb/g7H/HX3c1Qd5D+GuWY5vp35aQmvpNM
 /9R/MnmtuJo9aOaeAbLHAk1jFWEcES7N1bj2Ylae6plXfp+0kCxyem5iH16yL/XYBdDhCiUNVl
 WIg=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:57:02 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 01/23] target/iblock: remove an extra argument
Date:   Sat, 27 Feb 2021 21:56:23 -0800
Message-Id: <20210228055645.22253-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The twp arguments to the functions op and opf which are REQ_OP_XXX and
REQ_XXX flags belong to the two different namespaces, i.e. they can be
combined safely given that REQ_OP_XXX takes 8bits of the flags and rest 
is available to REQ_XXX flags.

Replace op and op_flag arguments with opf.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 34 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ee3d52061281..04aeed6558d6 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -304,9 +304,8 @@ static void iblock_bio_done(struct bio *bio)
 	iblock_complete_cmd(cmd);
 }
 
-static struct bio *
-iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
-	       int op_flags)
+static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
+				  unsigned int opf)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
 	struct bio *bio;
@@ -326,7 +325,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
-	bio_set_op_attrs(bio, op, op_flags);
+	bio->bi_opf = opf;
 
 	return bio;
 }
@@ -477,7 +476,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE, 0);
+	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -490,8 +489,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE,
-					     0);
+			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -685,9 +683,11 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct bio_list list;
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
+	unsigned int opf;
 	unsigned bio_cnt;
-	int i, rc, op, op_flags = 0;
+	int i, rc;
 	struct sg_mapping_iter prot_miter;
+	unsigned int miter_dir;
 
 	if (data_direction == DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -696,15 +696,17 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 * Force writethrough using REQ_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
-		op = REQ_OP_WRITE;
+		opf = REQ_OP_WRITE;
+		miter_dir = SG_MITER_TO_SG;
 		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
 			if (cmd->se_cmd_flags & SCF_FUA)
-				op_flags = REQ_FUA;
+				opf |= REQ_FUA;
 			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
-				op_flags = REQ_FUA;
+				opf |= REQ_FUA;
 		}
 	} else {
-		op = REQ_OP_READ;
+		opf = REQ_OP_READ;
+		miter_dir = SG_MITER_FROM_SG;
 	}
 
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
@@ -718,7 +720,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
+	bio = iblock_get_bio(cmd, block_lba, sgl_nents, opf);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -730,8 +732,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (cmd->prot_type && dev->dev_attrib.pi_prot_type)
 		sg_miter_start(&prot_miter, cmd->t_prot_sg, cmd->t_prot_nents,
-			       op == REQ_OP_READ ? SG_MITER_FROM_SG :
-						   SG_MITER_TO_SG);
+			       miter_dir);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		/*
@@ -752,8 +753,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num, op,
-					     op_flags);
+			bio = iblock_get_bio(cmd, block_lba, sg_num, opf);
 			if (!bio)
 				goto fail_put_bios;
 
-- 
2.22.1

