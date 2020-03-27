Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03CBC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB39520658
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 14:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgC0OUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 10:20:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:55330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbgC0OUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 10:20:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 13C9EB217;
        Fri, 27 Mar 2020 14:20:15 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH v3 5/5] scsi: target: use the stack for XCOPY passthrough cmds
Date:   Fri, 27 Mar 2020 15:19:54 +0100
Message-Id: <20200327141954.955-6-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200327141954.955-1-ddiss@suse.de>
References: <20200327141954.955-1-ddiss@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reads and writes in the XCOPY loop are synchronous, so needn't be
heap allocated / freed with each loop.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_xcopy.c | 84 ++++++++++++++------------------------
 drivers/target/target_core_xcopy.h |  5 ---
 2 files changed, 31 insertions(+), 58 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d61c41f33f81..bd3ed6ce7571 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -410,7 +410,8 @@ static void xcopy_pt_release_cmd(struct se_cmd *se_cmd)
 	struct xcopy_pt_cmd *xpt_cmd = container_of(se_cmd,
 				struct xcopy_pt_cmd, se_cmd);
 
-	kfree(xpt_cmd);
+	/* xpt_cmd is on the stack, nothing to free here */
+	pr_debug("xpt_cmd done: %p\n", xpt_cmd);
 }
 
 static int xcopy_pt_check_stop_free(struct se_cmd *se_cmd)
@@ -566,20 +567,15 @@ static int target_xcopy_read_source(
 	sector_t src_lba,
 	u32 src_sectors)
 {
-	struct xcopy_pt_cmd *xpt_cmd;
-	struct se_cmd *se_cmd;
+	struct xcopy_pt_cmd xpt_cmd;
+	struct se_cmd *se_cmd = &xpt_cmd.se_cmd;
 	u32 length = (src_sectors * src_dev->dev_attrib.block_size);
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_DEST_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
-		return -ENOMEM;
-	}
-	init_completion(&xpt_cmd->xpt_passthrough_sem);
-	se_cmd = &xpt_cmd->se_cmd;
+	memset(&xpt_cmd, 0, sizeof(xpt_cmd));
+	init_completion(&xpt_cmd.xpt_passthrough_sem);
 
 	memset(&cdb[0], 0, 16);
 	cdb[0] = READ_16;
@@ -589,28 +585,24 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, src_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_FROM_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
-	xop->src_pt_cmd = xpt_cmd;
+			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0]);
 
-	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
+	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
+		ec_cmd->scsi_status = se_cmd->scsi_status;
+		goto out;
 	}
 
 	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
 		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
 
-	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
-	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
-	}
-
-	return 0;
+	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
+	if (rc < 0)
+		ec_cmd->scsi_status = se_cmd->scsi_status;
+out:
+	transport_generic_free_cmd(se_cmd, 0);
+	return rc;
 }
 
 static int target_xcopy_write_destination(
@@ -620,20 +612,15 @@ static int target_xcopy_write_destination(
 	sector_t dst_lba,
 	u32 dst_sectors)
 {
-	struct xcopy_pt_cmd *xpt_cmd;
-	struct se_cmd *se_cmd;
+	struct xcopy_pt_cmd xpt_cmd;
+	struct se_cmd *se_cmd = &xpt_cmd.se_cmd;
 	u32 length = (dst_sectors * dst_dev->dev_attrib.block_size);
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_SOURCE_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
-		return -ENOMEM;
-	}
-	init_completion(&xpt_cmd->xpt_passthrough_sem);
-	se_cmd = &xpt_cmd->se_cmd;
+	memset(&xpt_cmd, 0, sizeof(xpt_cmd));
+	init_completion(&xpt_cmd.xpt_passthrough_sem);
 
 	memset(&cdb[0], 0, 16);
 	cdb[0] = WRITE_16;
@@ -643,25 +630,21 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, dst_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_TO_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
-	xop->dst_pt_cmd = xpt_cmd;
+			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0]);
 
-	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, dst_dev, &cdb[0],
+	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
-	}
-
-	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
-	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
+		ec_cmd->scsi_status = se_cmd->scsi_status;
+		goto out;
 	}
 
-	return 0;
+	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
+	if (rc < 0)
+		ec_cmd->scsi_status = se_cmd->scsi_status;
+out:
+	transport_generic_free_cmd(se_cmd, 0);
+	return rc;
 }
 
 static void target_xcopy_do_work(struct work_struct *work)
@@ -736,10 +719,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
 						dst_lba, cur_nolb);
-		if (rc < 0) {
-			transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
+		if (rc < 0)
 			goto out;
-		}
 
 		dst_lba += cur_nolb;
 		pr_debug("target_xcopy_do_work: Incremented WRITE dst_lba to %llu\n",
@@ -747,9 +728,6 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 		copied_nolb += cur_nolb;
 		nolb -= cur_nolb;
-
-		transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
-		transport_generic_free_cmd(&xop->dst_pt_cmd->se_cmd, 0);
 	}
 
 	xcopy_pt_undepend_remotedev(xop);
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index f1aaf7140798..c56a1bde9417 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -18,8 +18,6 @@ enum xcopy_origin_list {
 	XCOL_DEST_RECV_OP = 0x02,
 };
 
-struct xcopy_pt_cmd;
-
 struct xcopy_op {
 	int op_origin;
 
@@ -36,9 +34,6 @@ struct xcopy_op {
 	unsigned short dtdi;
 	unsigned short nolb;
 
-	struct xcopy_pt_cmd *src_pt_cmd;
-	struct xcopy_pt_cmd *dst_pt_cmd;
-
 	u32 xop_data_bytes;
 	u32 xop_data_nents;
 	struct scatterlist *xop_data_sg;
-- 
2.16.4

