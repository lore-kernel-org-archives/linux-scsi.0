Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F85C636C9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4D5A60238
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbhGUKCr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:02:47 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59384
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238792AbhGUJep (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jul 2021 05:34:45 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id CB2333F243;
        Wed, 21 Jul 2021 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626862521;
        bh=SjoWjrqwnItTOh5zDKu4Dx2Q1flNerPBza5NTZJ0c4o=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=A0ZhYv4iW0I+Z2k/Ro32erSR/secBJ8GyhpKr2JJSa15MBEbZ1MnqSlPwwxaWlhW/
         UMZnLhgaHe8Th/kdWSL7Q0ZMZPYAzYYDkyVL08TpT3Td2wLegXsLmsNxQm3f5SSsMX
         bElzX+GVl93BYfXLWQbyAN5KfMnxBhS1rp++q2i26x/ddkUbcwtHb80NxmdgLCUkMO
         PCzBPk22zj5ocdWaY1QKVEG1lpD94tpY+5aWlSijC6fzdACGCYki3cyxS20FHtZCus
         RycbsTED2KJ0nxkyyT1Y3xL2yQshXG54AIeveRRqoLolaB4iPHQC7VfSlfJq+IQYFC
         V7qCObWbSqs5g==
From:   Colin King <colin.king@canonical.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Varun Prakash <varun@chelsio.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: remove redundant assignment to variable ret
Date:   Wed, 21 Jul 2021 11:15:19 +0100
Message-Id: <20210721101519.42299-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never
read, the assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c | 2 +-
 drivers/target/loopback/tcm_loop.c       | 4 ++--
 drivers/target/target_core_iblock.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index b044999ad002..072afd070f3e 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -234,7 +234,7 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct cxgbit_device *cdev = csk->com.cdev;
 	struct cxgbit_cmd *ccmd = iscsit_priv_cmd(cmd);
 	struct cxgbi_task_tag_info *ttinfo = &ccmd->ttinfo;
-	int ret = -EINVAL;
+	int ret;
 
 	if ((!ccmd->setup_ddp) ||
 	    (!test_bit(CSK_DDP_ENABLE, &csk->com.flags)))
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6d0b0e67e79e..fdc36274cb39 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -241,7 +241,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
-	int ret = FAILED;
+	int ret;
 
 	/*
 	 * Locate the tcm_loop_hba_t pointer
@@ -261,7 +261,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
-	int ret = FAILED;
+	int ret;
 
 	/*
 	 * Locate the tcm_loop_hba_t pointer
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 44d9d028f716..4069a1edcfa3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -83,7 +83,7 @@ static int iblock_configure_device(struct se_device *dev)
 	struct blk_integrity *bi;
 	fmode_t mode;
 	unsigned int max_write_zeroes_sectors;
-	int ret = -ENOMEM;
+	int ret;
 
 	if (!(ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)) {
 		pr_err("Missing udev_path= parameters for IBLOCK\n");
-- 
2.31.1

