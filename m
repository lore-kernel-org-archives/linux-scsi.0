Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD466C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 08:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354389AbiCPIDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354430AbiCPIDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 04:03:03 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45B460D92;
        Wed, 16 Mar 2022 01:01:48 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V7M5ZZ1_1647417702;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0V7M5ZZ1_1647417702)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Mar 2022 16:01:46 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     bostroesser@gmail.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH] scsi:target:tcmu: make sure dev blocked before resetting ring
Date:   Wed, 16 Mar 2022 16:01:42 +0800
Message-Id: <1647417702-129883-1-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If dev is not blocked when resetting ring, then there could be new
commands coming in after resetting ring, this will make cmd ring broken,
because tcmu can not find tcmu_cmd when tcmu-runner handled these
newcome commands.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/target/target_core_user.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7b2a89a..548ad94 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2333,7 +2333,7 @@ static void tcmu_block_dev(struct tcmu_dev *udev)
 	mutex_unlock(&udev->cmdr_lock);
 }
 
-static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+static int tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
@@ -2341,6 +2341,12 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 	mutex_lock(&udev->cmdr_lock);
 
+	if (!test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags)) {
+		pr_err("The dev should be blocked before resetting ring.\n");
+		mutex_unlock(&udev->cmdr_lock);
+		return -EINVAL;
+	}
+
 	xa_for_each(&udev->commands, i, cmd) {
 		pr_debug("removing cmd %u on dev %s from ring %s\n",
 			 cmd->cmd_id, udev->name,
@@ -2396,6 +2402,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	run_qfull_queue(udev, false);
 
 	mutex_unlock(&udev->cmdr_lock);
+	return 0;
 }
 
 enum {
@@ -2995,7 +3002,10 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 		return -EINVAL;
 	}
 
-	tcmu_reset_ring(udev, val);
+	ret = tcmu_reset_ring(udev, val);
+	if (ret < 0)
+		return ret;
+
 	return count;
 }
 CONFIGFS_ATTR_WO(tcmu_, reset_ring);
-- 
1.8.3.1

