Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1954AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E1464F0D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 18:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhBXSz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbhBXSyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 13:54:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A53C061574;
        Wed, 24 Feb 2021 10:53:59 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id n1so3903660edv.2;
        Wed, 24 Feb 2021 10:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gksBhoaIRczZhW5M8AbWR9zpp3PlAb3ucluDeeCKzfk=;
        b=I4yEDnVd7DZ29O5n7nodnKmZW0UWuUZZxKqKrwnBW013xUbZu4pOzzMP0PPWSDz1qa
         cFYGO9Re7Last7Dv6B0VTgfZFZ6Ro2NneRWanj+wPQyg4QCK4Hm24avCU1P+oZrkVgXf
         znx4k5SwB6GApV/+yprnrL6bGodGxzG+Es9iEwd+pcHJGxWJA/Gn6AOirkVZi+rBpyPx
         Vy2nv1tvF4oMBclRUFBJmPC3D026FrjE7VzoR3bOVj+ZngNJyefAi4Qj0knWpUuys5Gn
         pwCn3Bfy+54yboleB2NG2qZf4Exv/7lXhrsCk7Om2hJtgZMRRxq9xwL24Rz2vMrdEZLH
         fuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gksBhoaIRczZhW5M8AbWR9zpp3PlAb3ucluDeeCKzfk=;
        b=gzW/Tj8bX4X0WAldJ0McD6TMzDf9MsyDmHBCPLVnj+merHd4Oah1ZD8E+EgHAG7nIg
         0NjdU6bZ6JgtwopeXrlAJ6K4OQ6NK1l32GpzUlzGJItj9j3QJekFWbPFIYg+KXNjYK03
         LOZYk7MsrkraTZ3SVsEm59foMoRwVEK7H6KIKri6QYzuzcOmC38s+4qq5PTIEjQnMO0g
         OeFJ+lX7u6+tTHStMftKVpWxIb9Jf/jKtgUA4zsF5AbEnvydQCjyngHHZMeSHbULOfit
         LnGUPR6PpEAO9t5/hCSsfLi4PdlGnpWfTVvUmzk8uOLIhTwsH3wdlXM8GTh8kXaNttrU
         TNog==
X-Gm-Message-State: AOAM5326k1uCIMqGAT2AZdfH9TXfUlzaf4EONl5RCW/y1XJ/i+LdLIc+
        RJoHsCwIZ6K5yQiENtcTCOeaZUTUK3g=
X-Google-Smtp-Source: ABdhPJyzvZrVB5b0D0nncsGg/bPX896FEF+/DH5nhXfBCHBYDdOOtgkUZDDK0ALMtkYPSWzEqtH+Nw==
X-Received: by 2002:a05:6402:3096:: with SMTP id de22mr3671736edb.141.1614192838284;
        Wed, 24 Feb 2021 10:53:58 -0800 (PST)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id y8sm1755938ejw.32.2021.02.24.10.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 10:53:57 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 1/2] scsi: target: tcmu: Replace IDR by XArray
Date:   Wed, 24 Feb 2021 19:53:34 +0100
Message-Id: <20210224185335.13844-2-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210224185335.13844-1-bostroesser@gmail.com>
References: <20210224185335.13844-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An attempt from Matthew Wilcox to replace IDR usage by XArray
in tcmu more than 1 year ago unfortunately got lost.

I rebased that work on latest tcmu and tested it.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bf73cd5f4b04..1fbfb307d5e5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -8,12 +8,12 @@
 
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/parser.h>
 #include <linux/vmalloc.h>
 #include <linux/uio_driver.h>
+#include <linux/xarray.h>
 #include <linux/radix-tree.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
@@ -145,7 +145,7 @@ struct tcmu_dev {
 	unsigned long *data_bitmap;
 	struct radix_tree_root data_blocks;
 
-	struct idr commands;
+	struct xarray commands;
 
 	struct timer_list cmd_timer;
 	unsigned int cmd_time_out;
@@ -977,8 +977,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	struct tcmu_mailbox *mb = udev->mb_addr;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
-	int iov_cnt, iov_bidi_cnt, cmd_id;
-	uint32_t cmd_head;
+	int iov_cnt, iov_bidi_cnt;
+	uint32_t cmd_id, cmd_head;
 	uint64_t cdb_off;
 	/* size of data buffer needed */
 	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
@@ -1031,8 +1031,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 		 */
 		goto free_and_queue;
 
-	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
-	if (cmd_id < 0) {
+	if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
+		     GFP_NOWAIT) < 0) {
 		pr_err("tcmu: Could not allocate cmd id.\n");
 
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
@@ -1415,7 +1415,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		}
 		WARN_ON(tcmu_hdr_get_op(entry->hdr.len_op) != TCMU_OP_CMD);
 
-		cmd = idr_remove(&udev->commands, entry->hdr.cmd_id);
+		cmd = xa_erase(&udev->commands, entry->hdr.cmd_id);
 		if (!cmd) {
 			pr_err("cmd_id %u not found, ring is broken\n",
 			       entry->hdr.cmd_id);
@@ -1433,7 +1433,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		free_space = tcmu_run_tmr_queue(udev);
 
 	if (atomic_read(&global_db_count) > tcmu_global_max_blocks &&
-	    idr_is_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
+	    xa_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
 		/*
 		 * Allocated blocks exceeded global block limit, currently no
 		 * more pending or waiting commands so try to reclaim blocks.
@@ -1556,7 +1556,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&udev->qfull_queue);
 	INIT_LIST_HEAD(&udev->tmr_queue);
 	INIT_LIST_HEAD(&udev->inflight_queue);
-	idr_init(&udev->commands);
+	xa_init_flags(&udev->commands, XA_FLAGS_ALLOC1);
 
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
@@ -1616,7 +1616,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	struct se_device *dev = &udev->se_dev;
 	struct tcmu_cmd *cmd;
 	bool all_expired = true;
-	int i;
+	unsigned long i;
 
 	vfree(udev->mb_addr);
 	udev->mb_addr = NULL;
@@ -1628,7 +1628,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 
 	/* Upper layer should drain all requests before calling this */
 	mutex_lock(&udev->cmdr_lock);
-	idr_for_each_entry(&udev->commands, cmd, i) {
+	xa_for_each(&udev->commands, i, cmd) {
 		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
 			all_expired = false;
 	}
@@ -1636,7 +1636,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	tcmu_remove_all_queued_tmr(udev);
 	if (!list_empty(&udev->qfull_queue))
 		all_expired = false;
-	idr_destroy(&udev->commands);
+	xa_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
 	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
@@ -2226,16 +2226,16 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 {
 	struct tcmu_mailbox *mb;
 	struct tcmu_cmd *cmd;
-	int i;
+	unsigned long i;
 
 	mutex_lock(&udev->cmdr_lock);
 
-	idr_for_each_entry(&udev->commands, cmd, i) {
+	xa_for_each(&udev->commands, i, cmd) {
 		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
 			  cmd->cmd_id, udev->name,
 			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
 
-		idr_remove(&udev->commands, i);
+		xa_erase(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
 			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
-- 
2.12.3

