From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 7/12]: Update generic REPORT_LUN code
Date: Fri, 12 Dec 2008 01:33:39 -0800
Message-ID: <1229074419.4153.651.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:49086 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756945AbYLLJdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:33:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From 566bf52116461c4639bacd7a109fcdd07849c251 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:54:23 -0800
Subject: [PATCH] [Target_Core_Mod]: Update generic REPORT_LUN code

This patch converts target_core_reportluns.c to use the updated target_core_base.h
variable prefixes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_reportluns.c |   30 ++++++++++++++--------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/lio-core/target_core_reportluns.c b/drivers/lio-core/target_core_reportluns.c
index 64e0bea..57401e4 100644
--- a/drivers/lio-core/target_core_reportluns.c
+++ b/drivers/lio-core/target_core_reportluns.c
@@ -131,15 +131,15 @@ static int rl_allocate_fake_lun (se_cmd_t *cmd, u32 lun)
 {
 	se_lun_t *lun_p;
 	
-	if (!(cmd->iscsi_lun = (se_lun_t *)
+	if (!(cmd->se_lun = (se_lun_t *)
 			kzalloc(sizeof(se_lun_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate se_lun_t\n");
 		return(-1);
 	}
-	ISCSI_LUN(cmd)->iscsi_lun = lun;
+	ISCSI_LUN(cmd)->unpacked_lun = lun;
 	lun_p = ISCSI_LUN(cmd);
 	
-	if (!(lun_p->iscsi_dev = (se_device_t *)
+	if (!(lun_p->se_dev = (se_device_t *)
 			kzalloc(sizeof(se_device_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate se_device_t\n");
 		kfree(ISCSI_LUN(cmd));
@@ -196,7 +196,7 @@ extern int se_allocate_rl_cmd (
 	init_MUTEX_LOCKED(&task->task_stop_sem);
 	task->task_no = 0;
 	task->task_se_cmd = cmd;
-	task->iscsi_dev = ISCSI_DEV(cmd);
+	task->se_dev = ISCSI_DEV(cmd);
 	task->transport_req = (void *) rl_cmd;
 
         spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
@@ -213,10 +213,10 @@ failure:
 	if (ISCSI_LUN(cmd)) {
 		if (ISCSI_DEV(cmd)) {
 			kfree(ISCSI_DEV(cmd));
-			cmd->iscsi_lun->iscsi_dev = NULL;
+			cmd->se_lun->se_dev = NULL;
 		}
 		kfree(ISCSI_LUN(cmd));
-		cmd->iscsi_lun = NULL;
+		cmd->se_lun = NULL;
 	}
 	if (T_TASK(cmd)) {
 		kfree(cmd->t_task);
@@ -245,7 +245,7 @@ extern int iscsi_build_report_luns_response (
 	u32 cdb_offset = 0, lun_count = 0, offset = 8;
 	u64 i, lun;
 	se_dev_entry_t *deve;
-	se_lun_t *iscsi_lun;
+	se_lun_t *se_lun;
 	se_session_t *sess = SE_SESS(se_cmd);
 	se_task_t *task;
 	rl_cmd_t *rl_cmd;
@@ -258,9 +258,9 @@ extern int iscsi_build_report_luns_response (
 	spin_lock_bh(&SE_NODE_ACL(sess)->device_list_lock);
 	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
 		deve = &SE_NODE_ACL(sess)->device_list[i];
-		if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS))
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
 			continue;
-		iscsi_lun = deve->iscsi_lun;
+		se_lun = deve->se_lun;
 
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
@@ -319,14 +319,14 @@ extern void rl_free_task (se_task_t *task)
 	/*
 	 * Free the pseudo device.
 	 */
-	if (task->iscsi_dev) {
-		kfree(task->iscsi_dev);
-		task->iscsi_dev = NULL;
+	if (task->se_dev) {
+		kfree(task->se_dev);
+		task->se_dev = NULL;
 	}
 
-	if (se_cmd->iscsi_lun) {
-		kfree(se_cmd->iscsi_lun);
-		se_cmd->iscsi_lun = NULL;
+	if (se_cmd->se_lun) {
+		kfree(se_cmd->se_lun);
+		se_cmd->se_lun = NULL;
 	}
 	
 	if (rl_cmd->rl_buf) {
-- 
1.5.4.1



