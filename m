Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92088C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F86264EB2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBTViN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:13 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65529 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTViM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857091; x=1645393091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lrVqzjG3GG6vMX9gO62Yhk/jVAU1NUt7V7kganSmJYM=;
  b=EixrUnqIZX1+rAb8W6r7tPIH5wrsaGZff/p8gRkJcgIejy3PUKOXiy7T
   Y6q14PyYDmoFKWutCtmtLJhWE+WyA43+VVe+gYk9zhc6NEx1wtaFhhlVw
   MoaEmBJB0fYqmL0fVgl3z+V4E6S5wCs2n4ygxgyImNRFwqrXUfvzfcTdi
   +kAO3xX4Dg6U9pshEiwd+AK+YrIh+F3KfyoHJPpLP5UfH7QFeF5pL7y+v
   ZVPqYtcqmsnQVhAPm5VN/RjuTlOlYcWSQHq7Ebs9Roe4a+qI6MZI+drMi
   wkNxFLNNzzhR8GaVASD3o1C0zi/9Nx2YJhi7o+eMrZ8O4gz28IBYJp7Jb
   Q==;
IronPort-SDR: J+M1bHqF0NwDT5C0u8C+N+48s4iAMqjlvbXkT0jnTypIyEsk+gKee9me8/fndCTPRuKSDtGW7X
 0sCWrUWCEEIF1UAXzYmOKHywUj8CFTBZEYCdei0+JBeP8MfMu42zPr99DgIow0x/wOHS+VrCB+
 xDpOKpcxtaeTyk6PXrkg7Ing9B1inmIintad2A5I0eVM5F1Vx0qkEPKQ8R94XnyI62HCz3e5gc
 MoB61XMCjzx0oiyGVbmR1+VGtQFZOvy2yWnn9SZM96qbOVcmVr4TTwv8anziUZmtJ8pBM70Bwa
 A+4=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="164901568"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:05 +0800
IronPort-SDR: LLNWU0s4jIX1sakbV2xxAalHMLof1zxxkjtqCeS/1G8iIfF226bB3+459TKMWOrrXOzFuJcJVC
 IgWAT8pz2nGPs6FzU+sWT4AsldZ1flC/lup/5a0l1npQlvoZAxyGdxy+Ow2L9si/gcKolkZSSA
 4wSB7D60c2ov33wIYLrLLuMFN+/rUWClV6uRsLoRV5V5hNMpPXvwGhl+cXJ5QNek8fBOZNo84+
 jmB2085L9G4ObOKtcrEqnjiBJ8BumkjtO7aSoKZT1tx/6+H51mGq3TFfE8qZ+fULcSnTy6yJjo
 DwLWTGOQkowLF7TCxoFa6FC3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:27 -0800
IronPort-SDR: KOHPrM8J774qa6wApHhFE+sqkgQ0eIs5nn1nlD9NgGKIDFtutoX6G4ndnAbOonvNtMMU1942eU
 J3iLJOQbHL0emspAxdaH74GVU23v+mu+9zJVZ+YEv4dQPv4Nvp+PaWH6ZmudSq2zdzMsWKiipR
 0Ibdg4gCDFyqvzl9cjj4mFf+lEOgg5Qe0e4pkKfT/9PQVmLfp59PNnnuJTAcbvBXYsmfwz0Fsk
 N7BOIvz9TVo2KRs6d+EH/7Sah2PE5oUhkkfhzY2cHc8iTg9U6Rg8BymHDanv8mcarIMAcc5mN2
 8tk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:05 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 01/24] target/iblock: remove an extra argument
Date:   Sat, 20 Feb 2021 13:37:03 -0800
Message-Id: <20210220213703.6334-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The twp arguments to the functions op and opf which are REQ_OP_XXX and
REQ_XXX flags are belongs to the two different namespaces, i.e. they
can be combined safely given that REQ_OP_XXX takes 8bits of the flags
and rest is available to REQ_XXX flags.

Replace op and op_flag arguments with opf.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_iblock.c | 34 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..4bb34711bdc5 100644
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
@@ -328,7 +327,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
-	bio_set_op_attrs(bio, op, op_flags);
+	bio->bi_opf = opf;
 
 	return bio;
 }
@@ -479,7 +478,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE, 0);
+	bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -492,8 +491,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE,
-					     0);
+			bio = iblock_get_bio(cmd, block_lba, 1, REQ_OP_WRITE);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -688,9 +686,11 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
@@ -699,15 +699,17 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
@@ -721,7 +723,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
+	bio = iblock_get_bio(cmd, block_lba, sgl_nents, opf);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -733,8 +735,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (cmd->prot_type && dev->dev_attrib.pi_prot_type)
 		sg_miter_start(&prot_miter, cmd->t_prot_sg, cmd->t_prot_nents,
-			       op == REQ_OP_READ ? SG_MITER_FROM_SG :
-						   SG_MITER_TO_SG);
+			       miter_dir);
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		/*
@@ -755,8 +756,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num, op,
-					     op_flags);
+			bio = iblock_get_bio(cmd, block_lba, sg_num, opf);
 			if (!bio)
 				goto fail_put_bios;
 
-- 
2.22.1

