From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/21] target: Remove duplicate task completions in transport_emulate_control_cdb
Date: Wed, 17 Aug 2011 23:17:15 +0000
Message-ID: <1313623045-15916-12-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58329 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1HQXmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:35 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes a duplicate set of transport_complete_task() calls in
target_emulate_unmap() and target_emulate_write_same() as the completion
call is already done within transport_emulate_control_cdb()

This patch also adds a check in transport_emulate_control_cdb() for the
existing SCF_EMULATE_CDB_ASYNC flag currently used by SYNCHRONIZE_CACHE
in order to handle IMMEDIATE processing.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 4c1d3a9..40ad142 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1077,8 +1077,6 @@ target_emulate_unmap(struct se_task *task)
 		size -= 16;
 	}
 
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
 err:
 	transport_kunmap_first_data_page(cmd);
 
@@ -1115,8 +1113,6 @@ target_emulate_write_same(struct se_task *task, u32 num_blocks)
 		return ret;
 	}
 
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
 	return 0;
 }
 
@@ -1228,8 +1224,14 @@ transport_emulate_control_cdb(struct se_task *task)
 
 	if (ret < 0)
 		return ret;
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
+	/*
+	 * Handle the successful completion here unless a caller
+	 * has explictly requested an asychronous completion.
+	 */
+	if (!(cmd->se_cmd_flags & SCF_EMULATE_CDB_ASYNC)) {
+		task->task_scsi_status = GOOD;
+		transport_complete_task(task, 1);
+	}
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
-- 
1.7.6

