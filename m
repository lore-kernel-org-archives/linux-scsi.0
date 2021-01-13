Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523E9C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1503023120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 02:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbhAMCqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 21:46:17 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23338 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbhAMCqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 21:46:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610505975; x=1642041975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Xf6qlI2st+RJp44dBtRLbjM6u8hw1HIH9wC1FEtltg=;
  b=VnF5xZ9lnx5flbk/yprT7Zkm18kbbhuIKB2aERoF5U4JC/HX9VXI8ed3
   hhXIRy/PJENbtu4VqLYoP+4poYRX6+/CUyMe6dqFWxYdmaySxorUQ+gB2
   R1/rvEu4cXfLyEBtPGGCEfr4Azk5D1qw8X+dKRb3b5l/Y9NVC7WF42MTi
   CRiUjo4Ca6k0UQz9omRVoCGyAnFkaxymOVakTUJAdlAfCbwZ0sDFPyS9p
   5pKIuZUxs3gTt5/i7wlMukaEiCI8jSH72TLwqqNdLedve4N2jNUT1Rc+f
   e0xFpbK4EOOnziufs+PX6rVns8DUOQrjRy2kzcFTliY8tKcsggomwC1eo
   Q==;
IronPort-SDR: Jzu1FEwFvrEkq3H29YoWRFWrmsJzGu24j1aoFZF2ESRdamf5HNMSeMbey1p5WsaOxBsJINXypZ
 hKVtQL44SqBFkfwGeb9wi9ADUagXg8hOkd9z7nWEUQKt3c8FqeMqpIaHIczcHxFcbmobxIftHn
 Q0mf4AP7O4KHsubOYw3aIL3z6Uov5/5nO29CPIz0uafAeRhfzKnjQYGY5RLMVJAdCPwpK3HKVH
 9TIZ/uIu2cRKCILBM033MwENtvR9NGxIV31cyt4fyYUC6UD3SYwcmC4sX1rNNUfXqoB63Hn2LZ
 +z8=
X-IronPort-AV: E=Sophos;i="5.79,343,1602518400"; 
   d="scan'208";a="267598514"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jan 2021 10:45:10 +0800
IronPort-SDR: 3SCwMf/r9fcxkCDP/Z/WG/ckEmyKQRNNp56hVHPoeRGleGBlYRO2Cdj9l62mVEvLXqnWFpXn8E
 L0A3YRIf4lj9xZbGS052K2a3XZj/S4MPJ0eVxwNL0N+jCf5qyhvNDjyeSMulFQV5H1T06RYohk
 qevC2RgI9aUwXurdhvLUi72LAObR3f2Ixygwd/8CR6V/cpVe+t2ll/8dIiB4IEtYYlFjiaYRWq
 4Bt7p+m9fl+6/auExQU3N19ztG/oEcXlWQTkxQHt16RB/Ex7tjo96Nb5UqE6k4xMtQ1DRQFN5r
 A724peCr5oWFfFD2EgYG9JiA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 18:29:55 -0800
IronPort-SDR: I3t4uJi7uZ6U+8FbcXBp+c2lWOoRIr2WLxhkURx6PTmvHUSIQavoQJzkyWiAQic5yJAb9sPO46
 +zecJOh0ERoXkoqNejpXK7xgppYwArAx3y+LtgP8sSvAXCdobh4c3nV7X8X7HkIz4aZOUzgGjO
 InC9hmCZ9KjAswWg90UJbHn1XrM573fxqHfJrwU4EoUjr/s+kiOm+jf+9l3l9FGUmzR+R0xG9d
 VkZEx7Ozd65YWl4aP09TFwQABxIDeEDOfZcBeEW/RbeAkLvlQ6j3MHOo8rdQVb36+wFB3xSILg
 qSY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com ([10.149.52.189])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2021 18:45:09 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: target: tcmu: Fix use-after-free of se_cmd->priv
Date:   Wed, 13 Jan 2021 11:45:08 +0900
Message-Id: <20210113024508.1264992-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit a35129024e88 ("scsi: target: tcmu: Use priv pointer in se_cmd")
modified tcmu_free_cmd() to set NULL to priv pointer in se_cmd. However,
se_cmd can be already freed by work queue triggered in
target_complete_cmd(). This caused BUG KASAN use-after-free [1].

To fix the bug, do not touch priv pointer in tcmu_free_cmd(). Instead,
set NULL to priv pointer before target_complete_cmd() calls. Also, to
avoid unnecessary priv pointer change in tcmu_queue_cmd(), modify priv
pointer in the function only when tcmu_free_cmd() is not called.

[1]
BUG: KASAN: use-after-free in tcmu_handle_completions+0x1172/0x1770 [target_core_user]
Write of size 8 at addr ffff88814cf79a40 by task cmdproc-uio0/14842

CPU: 2 PID: 14842 Comm: cmdproc-uio0 Not tainted 5.11.0-rc2 #1
Hardware name: Supermicro Super Server/X10SRL-F, BIOS 3.2 11/22/2019
Call Trace:
 dump_stack+0x9a/0xcc
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 print_address_description.constprop.0+0x18/0x130
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 kasan_report.cold+0x7f/0x10e
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 ? queue_tmr_ring+0x5d0/0x5d0 [target_core_user]
 tcmu_irqcontrol+0x28/0x60 [target_core_user]
 uio_write+0x155/0x230
 ? uio_vma_fault+0x460/0x460
 ? security_file_permission+0x4f/0x440
 vfs_write+0x1ce/0x860
 ksys_write+0xe9/0x1b0
 ? __ia32_sys_read+0xb0/0xb0
 ? syscall_enter_from_user_mode+0x27/0x70
 ? trace_hardirqs_on+0x1c/0x110
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fcf8b61905f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 b9 fc ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 0c fd ff ff 48
RSP: 002b:00007fcf7b3e6c30 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcf8b61905f
RDX: 0000000000000004 RSI: 00007fcf7b3e6c78 RDI: 000000000000000c
RBP: 00007fcf7b3e6c80 R08: 0000000000000000 R09: 00007fcf7b3e6aa8
R10: 000000000b01c000 R11: 0000000000000293 R12: 00007ffe0c32a52e
R13: 00007ffe0c32a52f R14: 0000000000000000 R15: 00007fcf7b3e7640

Allocated by task 383:
 kasan_save_stack+0x1b/0x40
 ____kasan_kmalloc.constprop.0+0x84/0xa0
 kmem_cache_alloc+0x142/0x330
 tcm_loop_queuecommand+0x2a/0x4e0 [tcm_loop]
 scsi_queue_rq+0x12ec/0x2d20
 blk_mq_dispatch_rq_list+0x30a/0x1db0
 __blk_mq_do_dispatch_sched+0x326/0x830
 __blk_mq_sched_dispatch_requests+0x2c8/0x3f0
 blk_mq_sched_dispatch_requests+0xca/0x120
 __blk_mq_run_hw_queue+0x93/0xe0
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

Freed by task 11655:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 ____kasan_slab_free+0xec/0x120
 slab_free_freelist_hook+0x53/0x160
 kmem_cache_free+0xf4/0x5c0
 target_release_cmd_kref+0x3ea/0x9e0 [target_core_mod]
 transport_generic_free_cmd+0x28b/0x2f0 [target_core_mod]
 target_complete_ok_work+0x250/0xac0 [target_core_mod]
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40
 kasan_record_aux_stack+0xa3/0xb0
 insert_work+0x48/0x2e0
 __queue_work+0x4e8/0xdf0
 queue_work_on+0x78/0x80
 tcmu_handle_completions+0xad0/0x1770 [target_core_user]
 tcmu_irqcontrol+0x28/0x60 [target_core_user]
 uio_write+0x155/0x230
 vfs_write+0x1ce/0x860
 ksys_write+0xe9/0x1b0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40
 kasan_record_aux_stack+0xa3/0xb0
 insert_work+0x48/0x2e0
 __queue_work+0x4e8/0xdf0
 queue_work_on+0x78/0x80
 tcm_loop_queuecommand+0x1c3/0x4e0 [tcm_loop]
 scsi_queue_rq+0x12ec/0x2d20
 blk_mq_dispatch_rq_list+0x30a/0x1db0
 __blk_mq_do_dispatch_sched+0x326/0x830
 __blk_mq_sched_dispatch_requests+0x2c8/0x3f0
 blk_mq_sched_dispatch_requests+0xca/0x120
 __blk_mq_run_hw_queue+0x93/0xe0
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

The buggy address belongs to the object at ffff88814cf79800
 which belongs to the cache tcm_loop_cmd_cache of size 896

Fixes: a35129024e88 ("scsi: target: tcmu: Use priv pointer in se_cmd")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/target/target_core_user.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 6b171fff007b..a5991df23581 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -562,8 +562,6 @@ tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
-	if (tcmu_cmd->se_cmd)
-		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1174,11 +1172,12 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
-	se_cmd->priv = tcmu_cmd;
 	if (!(se_cmd->transport_state & CMD_T_ABORTED))
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	else
+		se_cmd->priv = tcmu_cmd;
 	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
@@ -1241,6 +1240,7 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 
 		list_del_init(&cmd->queue_entry);
 		tcmu_free_cmd(cmd);
+		se_cmd->priv = NULL;
 		target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
 		unqueued = true;
 	}
@@ -1332,6 +1332,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	}
 
 done:
+	se_cmd->priv = NULL;
 	if (read_len_valid) {
 		pr_debug("read_len = %d\n", read_len);
 		target_complete_cmd_with_length(cmd->se_cmd,
@@ -1478,6 +1479,7 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
+	se_cmd->priv = NULL;
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
@@ -1592,6 +1594,7 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * removed then LIO core will do the right thing and
 			 * fail the retry.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
 			tcmu_free_cmd(tcmu_cmd);
 			continue;
@@ -1605,6 +1608,7 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd,
 					    SAM_STAT_CHECK_CONDITION);
 			tcmu_free_cmd(tcmu_cmd);
@@ -2212,6 +2216,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
 			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
+			cmd->se_cmd->priv = NULL;
 			if (err_level == 1) {
 				/*
 				 * Userspace was not able to start the
-- 
2.28.0

