Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F03C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B06520719
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgCWQy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:54:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgCWQy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 12:54:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3B76B1C2;
        Mon, 23 Mar 2020 16:54:26 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, David Disseldorp <ddiss@suse.de>
Subject: [RFC PATCH 5/5] scsi: target: avoid XCOPY per-loop read/write cmd allocations
Date:   Mon, 23 Mar 2020 17:54:10 +0100
Message-Id: <20200323165410.24423-6-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
References: <20200323165410.24423-1-ddiss@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reads and writes in the XCOPY loop are synchronous, so needn't be
allocated / freed with each loop.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.c | 33 +++++++++------------------------
 drivers/target/target_core_xcopy.h | 10 +++++++---
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index e9c50766d4fc..cdc6c65168da 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -374,12 +374,6 @@ static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
  * Start xcopy_pt ops
  */
 
-struct xcopy_pt_cmd {
-	struct se_cmd se_cmd;
-	struct completion xpt_passthrough_sem;
-	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
-};
-
 struct se_portal_group xcopy_pt_tpg;
 static struct se_session xcopy_pt_sess;
 static struct se_node_acl xcopy_pt_nacl;
@@ -410,7 +404,8 @@ static void xcopy_pt_release_cmd(struct se_cmd *se_cmd)
 	struct xcopy_pt_cmd *xpt_cmd = container_of(se_cmd,
 				struct xcopy_pt_cmd, se_cmd);
 
-	kfree(xpt_cmd);
+	/* xpt_cmd is backed by parent xop, nothing to free */
+	pr_debug("xpt_cmd done: %p\n", xpt_cmd);
 }
 
 static int xcopy_pt_check_stop_free(struct se_cmd *se_cmd)
@@ -582,18 +577,14 @@ static int target_xcopy_read_source(
 	sector_t src_lba,
 	u32 src_sectors)
 {
-	struct xcopy_pt_cmd *xpt_cmd;
+	struct xcopy_pt_cmd *xpt_cmd = &xop->src_pt_cmd;
 	struct se_cmd *se_cmd;
 	u32 length = (src_sectors * src_dev->dev_attrib.block_size);
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_DEST_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
-		return -ENOMEM;
-	}
+	memset(xpt_cmd, 0, sizeof(*xpt_cmd));
 	init_completion(&xpt_cmd->xpt_passthrough_sem);
 	se_cmd = &xpt_cmd->se_cmd;
 
@@ -606,7 +597,6 @@ static int target_xcopy_read_source(
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
 			      DMA_FROM_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
-	xop->src_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
@@ -636,18 +626,14 @@ static int target_xcopy_write_destination(
 	sector_t dst_lba,
 	u32 dst_sectors)
 {
-	struct xcopy_pt_cmd *xpt_cmd;
+	struct xcopy_pt_cmd *xpt_cmd = &xop->dst_pt_cmd;
 	struct se_cmd *se_cmd;
 	u32 length = (dst_sectors * dst_dev->dev_attrib.block_size);
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_SOURCE_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
-		return -ENOMEM;
-	}
+	memset(xpt_cmd, 0, sizeof(*xpt_cmd));
 	init_completion(&xpt_cmd->xpt_passthrough_sem);
 	se_cmd = &xpt_cmd->se_cmd;
 
@@ -660,7 +646,6 @@ static int target_xcopy_write_destination(
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
 			      DMA_TO_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
-	xop->dst_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
@@ -754,7 +739,7 @@ static void target_xcopy_do_work(struct work_struct *work)
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
 						dst_lba, cur_nolb);
 		if (rc < 0) {
-			transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
+			transport_generic_free_cmd(&xop->src_pt_cmd.se_cmd, 0);
 			goto out;
 		}
 
@@ -765,8 +750,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 		copied_nolb += cur_nolb;
 		nolb -= cur_nolb;
 
-		transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
-		transport_generic_free_cmd(&xop->dst_pt_cmd->se_cmd, 0);
+		transport_generic_free_cmd(&xop->src_pt_cmd.se_cmd, 0);
+		transport_generic_free_cmd(&xop->dst_pt_cmd.se_cmd, 0);
 	}
 
 	xcopy_pt_undepend_remotedev(xop);
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index f1aaf7140798..f52640fcb12d 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -18,7 +18,11 @@ enum xcopy_origin_list {
 	XCOL_DEST_RECV_OP = 0x02,
 };
 
-struct xcopy_pt_cmd;
+struct xcopy_pt_cmd {
+	struct se_cmd se_cmd;
+	struct completion xpt_passthrough_sem;
+	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
+};
 
 struct xcopy_op {
 	int op_origin;
@@ -36,8 +40,8 @@ struct xcopy_op {
 	unsigned short dtdi;
 	unsigned short nolb;
 
-	struct xcopy_pt_cmd *src_pt_cmd;
-	struct xcopy_pt_cmd *dst_pt_cmd;
+	struct xcopy_pt_cmd src_pt_cmd;
+	struct xcopy_pt_cmd dst_pt_cmd;
 
 	u32 xop_data_bytes;
 	u32 xop_data_nents;
-- 
2.16.4

