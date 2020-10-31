Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5ABC388F7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 08:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646132076D
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 08:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgJaIGH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 04:06:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7016 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgJaIGH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2020 04:06:07 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNWvt5xTKzhdGg;
        Sat, 31 Oct 2020 16:06:02 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 16:05:52 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>
CC:     <lduncan@suse.com>, <cleech@redhat.com>, <jejb@linux.ibm.com>,
        <lutianxiong@huawei.com>, <linfeilong@huawei.com>,
        <liuzhiqiang26@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH] scsi: libiscsi: Fix cmds hung when sd_shutdown
Date:   Sat, 31 Oct 2020 16:23:42 +0800
Message-ID: <1604132622-497115-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For some reason, during reboot the system, iscsi.service failed to
logout all sessions. kernel will hang forever on its
sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd to all
still existent paths.

[ 1044.098991] reboot: Mddev shutdown finished.
[ 1044.099311] reboot: Usermodehelper disable finished.
[ 1050.611244]  connection2:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4295152378, last ping 4295153633, now 4295154944
[ 1348.599676] Call trace:
[ 1348.599887]  __switch_to+0xe8/0x150
[ 1348.600113]  __schedule+0x33c/0xa08
[ 1348.600372]  schedule+0x2c/0x88
[ 1348.600567]  schedule_timeout+0x184/0x3a8
[ 1348.600820]  io_schedule_timeout+0x28/0x48
[ 1348.601089]  wait_for_common_io.constprop.2+0x168/0x258
[ 1348.601425]  wait_for_completion_io_timeout+0x28/0x38
[ 1348.601762]  blk_execute_rq+0x98/0xd8
[ 1348.602006]  __scsi_execute+0xe0/0x1e8
[ 1348.602262]  sd_sync_cache+0xd0/0x220 [sd_mod]
[ 1348.602551]  sd_shutdown+0x6c/0xf8 [sd_mod]
[ 1348.602826]  device_shutdown+0x13c/0x250
[ 1348.603078]  kernel_restart_prepare+0x5c/0x68
[ 1348.603400]  kernel_restart+0x20/0x98
[ 1348.603683]  __se_sys_reboot+0x214/0x260
[ 1348.603987]  __arm64_sys_reboot+0x24/0x30
[ 1348.604300]  el0_svc_common+0x80/0x1b8
[ 1348.604590]  el0_svc_handler+0x78/0xe0
[ 1348.604877]  el0_svc+0x10/0x260

d754941225 (scsi: libiscsi: Allow sd_shutdown on bad transport) Once
solved this problem. The iscsi_eh_cmd_timed_out() function add system_state
judgment, and will return BLK_EH_DONE and mark the result as 
DID_NO_CONNECT when system_state is not SYSTEM_RUNNING, 
To tell upper layers that the command was handled during 
the transport layer error handler helper.

The scsi Mid Layer timeout handler function(scsi_times_out) will be
abort the cmd if the scsi LLD timeout handler return BLK_EH_DONE.
if abort cmd failed, will enter scsi EH logic.

Scsi EH will do reset target logic, if reset target failed, Will
call iscsi_eh_session_reset() function to drop the session.

The iscsi_eh_session_reset function will wait for a relogin,
session termination from userspace, or a recovery/replacement timeout.
But at this time, the app iscsid has exited, and the session was marked as
ISCSI_STATE_FAILED, So the SCSI EH process will never be 
scheduled back again.

PID: 9123   TASK: ffff80020c1b4d80  CPU: 3   COMMAND: "scsi_eh_2"
 #0 [ffff00008632bb70] __switch_to at ffff000080088738
 #1 [ffff00008632bb90] __schedule at ffff000080a00480
 #2 [ffff00008632bc20] schedule at ffff000080a00b58
 #3 [ffff00008632bc30] iscsi_eh_session_reset at ffff000000d1ab9c [libiscsi]
 #4 [ffff00008632bcb0] iscsi_eh_recover_target at ffff000000d1d1fc [libiscsi]
 #5 [ffff00008632bd00] scsi_try_target_reset at ffff0000806f0bac
 #6 [ffff00008632bd30] scsi_eh_ready_devs at ffff0000806f2724
 #7 [ffff00008632bde0] scsi_error_handler at ffff0000806f41d4
 #8 [ffff00008632be70] kthread at ffff000080119ae0

Reported-by: Tianxiong Lu <lutianxiong@huawei.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/libiscsi.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1e9c317..2570768 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2380,7 +2380,17 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_TERMINATE) {
+
+	/*
+	 * During shutdown, if session is prematurely disconnected
+	 * recovery won't happen and there will be hung cmds.
+	 * To solve this case, all cmds would be enter scsi EH.
+	 * But the EH path will wait for wait_event_interruptible() completed,
+	 * when the session state machine is not ISCSI_STATE_TERMINATE,
+	 * ISCSI_STATE_LOGGED_IN and ISCSI_STATE_RECOVERY_FAILED.
+	 */
+	if (session->state == ISCSI_STATE_TERMINATE ||
+		unlikely(system_state != SYSTEM_RUNNING)) {
 failed:
 		ISCSI_DBG_EH(session,
 			     "failing session reset: Could not log back into "
-- 
1.8.3.1

