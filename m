Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF2BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 424B864E6F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhBRTON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbhBRRvo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 12:51:44 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B19C061786;
        Thu, 18 Feb 2021 09:51:02 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id t11so7082917ejx.6;
        Thu, 18 Feb 2021 09:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=709jOtKADHrRWb/hSokEdJDCvwZZvPL3q+O9JdwciLw=;
        b=olcyxwVAoUR4+LLVPmRQseUkQmdb8qfmWopqQH2Ph+VRZJG9jUOH86Kc9SRHa0OOGU
         Qm3Tk2+MAjagmZPBrV+XarH2t8sMlw7FgOQn3b3Az91G9Z16T+DLuOO7eypfVIWJX0tf
         8zFR2F2LZl/bhVUdkm3zjb0rn5LiYaUVTUmrZ2QMtGrZxZX7JpmmyZr0IzDpGOmZ9cgx
         CEk8uIeQTuSZoMiKHG8MlHXAD4VzLEWuIF2osV9eQUClgB3fecMGlVpqIYGLLepZ+0AH
         AzTxLFgZZjZsx0T9yE9/6fYo9U2GHeg9URAOjbBijJi1/Cm47r7jogOIxT9BbfJs2QlN
         UN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=709jOtKADHrRWb/hSokEdJDCvwZZvPL3q+O9JdwciLw=;
        b=R05vWOIR5PQ8NfFqmxPu+PGytlsAHYTny2da5LR39OzlEXSV8d/zL84cVrYCgJjLT/
         sJKj4GW0JLnFTHskti4uHiPxlL+o31lwm0HLlbIGIXXUOYVv39++QhClykb44l4T7l4y
         inAg+WvjMbPLSfj2z6pry016LHai+v2oGHVt5pj6BhhMEHi9UxfHSZuyYlgf1Z2mZi4m
         h1LXLhBdMA2NrvB61Bgs/M5ugK8/V5Rq1+wAMfpfd3wBU/6dX1I8WTm8XgcxErmk0hgE
         G4W6uj2NyR1mliR3RZqEoAl9T/LAoT78kaIw+Tm7v7gOKFJxIzHKYKMkx5MKBjnOF2t1
         0zWA==
X-Gm-Message-State: AOAM5335uBGJt0lcW/zWjyP8l/gMAYYpWbbC/1OKlnCCGV75GGRb4i/n
        Clw4RHx8ZMJWYOMFUAgBsfUh7NB52aE=
X-Google-Smtp-Source: ABdhPJwfh/QVG+363MD7eLz8Z9wsdSPXXGNQhpPDKSXtrsipuX8zlrOMGjFSL5jgch4v2JcPYOiZ3g==
X-Received: by 2002:a17:906:36cc:: with SMTP id b12mr5118883ejc.323.1613670660932;
        Thu, 18 Feb 2021 09:51:00 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id l13sm3021919ejk.0.2021.02.18.09.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 09:51:00 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/2] scsi: target: tcmu: Move some functions without code change
Date:   Thu, 18 Feb 2021 18:50:38 +0100
Message-Id: <20210218175039.7829-2-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210218175039.7829-1-bostroesser@gmail.com>
References: <20210218175039.7829-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch just moves one block of code containing some functions
inside target_core_user.c to avoid adding prototypes in next patch.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 160 +++++++++++++++++++-------------------
 1 file changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a5991df23581..6d010cf22879 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1566,6 +1566,86 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
+static void tcmu_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	kfree(udev->uio_info.name);
+	kfree(udev->name);
+	kfree(udev);
+}
+
+static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
+{
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		kmem_cache_free(tcmu_cmd_cache, cmd);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static void tcmu_blocks_release(struct radix_tree_root *blocks,
+				int start, int end)
+{
+	int i;
+	struct page *page;
+
+	for (i = start; i < end; i++) {
+		page = radix_tree_delete(blocks, i);
+		if (page) {
+			__free_page(page);
+			atomic_dec(&global_db_count);
+		}
+	}
+}
+
+static void tcmu_remove_all_queued_tmr(struct tcmu_dev *udev)
+{
+	struct tcmu_tmr *tmr, *tmp;
+
+	list_for_each_entry_safe(tmr, tmp, &udev->tmr_queue, queue_entry) {
+		list_del_init(&tmr->queue_entry);
+		kfree(tmr);
+	}
+}
+
+static void tcmu_dev_kref_release(struct kref *kref)
+{
+	struct tcmu_dev *udev = container_of(kref, struct tcmu_dev, kref);
+	struct se_device *dev = &udev->se_dev;
+	struct tcmu_cmd *cmd;
+	bool all_expired = true;
+	int i;
+
+	vfree(udev->mb_addr);
+	udev->mb_addr = NULL;
+
+	spin_lock_bh(&timed_out_udevs_lock);
+	if (!list_empty(&udev->timedout_entry))
+		list_del(&udev->timedout_entry);
+	spin_unlock_bh(&timed_out_udevs_lock);
+
+	/* Upper layer should drain all requests before calling this */
+	mutex_lock(&udev->cmdr_lock);
+	idr_for_each_entry(&udev->commands, cmd, i) {
+		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
+			all_expired = false;
+	}
+	/* There can be left over TMR cmds. Remove them. */
+	tcmu_remove_all_queued_tmr(udev);
+	if (!list_empty(&udev->qfull_queue))
+		all_expired = false;
+	idr_destroy(&udev->commands);
+	WARN_ON(!all_expired);
+
+	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	bitmap_free(udev->data_bitmap);
+	mutex_unlock(&udev->cmdr_lock);
+
+	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
+}
+
 static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
@@ -1751,86 +1831,6 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 	return 0;
 }
 
-static void tcmu_dev_call_rcu(struct rcu_head *p)
-{
-	struct se_device *dev = container_of(p, struct se_device, rcu_head);
-	struct tcmu_dev *udev = TCMU_DEV(dev);
-
-	kfree(udev->uio_info.name);
-	kfree(udev->name);
-	kfree(udev);
-}
-
-static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
-{
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
-		kmem_cache_free(tcmu_cmd_cache, cmd);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static void tcmu_blocks_release(struct radix_tree_root *blocks,
-				int start, int end)
-{
-	int i;
-	struct page *page;
-
-	for (i = start; i < end; i++) {
-		page = radix_tree_delete(blocks, i);
-		if (page) {
-			__free_page(page);
-			atomic_dec(&global_db_count);
-		}
-	}
-}
-
-static void tcmu_remove_all_queued_tmr(struct tcmu_dev *udev)
-{
-	struct tcmu_tmr *tmr, *tmp;
-
-	list_for_each_entry_safe(tmr, tmp, &udev->tmr_queue, queue_entry) {
-		list_del_init(&tmr->queue_entry);
-		kfree(tmr);
-	}
-}
-
-static void tcmu_dev_kref_release(struct kref *kref)
-{
-	struct tcmu_dev *udev = container_of(kref, struct tcmu_dev, kref);
-	struct se_device *dev = &udev->se_dev;
-	struct tcmu_cmd *cmd;
-	bool all_expired = true;
-	int i;
-
-	vfree(udev->mb_addr);
-	udev->mb_addr = NULL;
-
-	spin_lock_bh(&timed_out_udevs_lock);
-	if (!list_empty(&udev->timedout_entry))
-		list_del(&udev->timedout_entry);
-	spin_unlock_bh(&timed_out_udevs_lock);
-
-	/* Upper layer should drain all requests before calling this */
-	mutex_lock(&udev->cmdr_lock);
-	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
-			all_expired = false;
-	}
-	/* There can be left over TMR cmds. Remove them. */
-	tcmu_remove_all_queued_tmr(udev);
-	if (!list_empty(&udev->qfull_queue))
-		all_expired = false;
-	idr_destroy(&udev->commands);
-	WARN_ON(!all_expired);
-
-	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
-	bitmap_free(udev->data_bitmap);
-	mutex_unlock(&udev->cmdr_lock);
-
-	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
-}
-
 static int tcmu_release(struct uio_info *info, struct inode *inode)
 {
 	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
-- 
2.12.3

