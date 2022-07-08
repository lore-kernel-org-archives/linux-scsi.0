Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66DEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 03:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbiGHDdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 23:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiGHDdD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 23:33:03 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5D3747B6;
        Thu,  7 Jul 2022 20:33:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VIhqdCa_1657251175;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VIhqdCa_1657251175)
          by smtp.aliyun-inc.com;
          Fri, 08 Jul 2022 11:32:59 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     bostroesser@gmail.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH] scsi: target: tcmu: check cmd aborted earlier
Date:   Fri,  8 Jul 2022 11:32:55 +0800
Message-Id: <1657251175-116098-1-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lift the check of cmd aborted to the head of tcmu_queue_cmd(), which
avoids pointless tcmu_cmd allocation if the cmd is already aborted.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3deaeec..c1c1d2f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1204,16 +1204,18 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t scsi_ret = TCM_CHECK_CONDITION_ABORT_CMD;
-	int ret = -1;
+	sense_reason_t scsi_ret;
+	int ret;
+
+	if (se_cmd->transport_state & CMD_T_ABORTED)
+		return TCM_CHECK_CONDITION_ABORT_CMD;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
-	if (!(se_cmd->transport_state & CMD_T_ABORTED))
-		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
+	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
 	else
-- 
1.8.3.1

