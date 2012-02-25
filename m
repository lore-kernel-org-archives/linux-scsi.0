From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/7] target: Push target_submit_tmr LUN lookup failure to system_wq context
Date: Sat, 25 Feb 2012 21:05:57 +0000
Message-ID: <1330203959-6170-6-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45546 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2BYVOS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:18 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

In order to handle incoming target_submit_tmr() callers using interrupt
context, use system_wq process context for transport_lookup_tmr_lun()
failures to return TMR_LUN_DOES_NOT_EXIST status for fabric TM response.

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce88cd2..9bbbf89 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1701,6 +1701,15 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 }
 EXPORT_SYMBOL(target_submit_cmd);
 
+static void target_complete_tmr_failure(struct work_struct *work)
+{
+	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
+	
+	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
+	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
+	transport_generic_free_cmd(se_cmd, 0);
+}
+
 /**
  * target_submit_tmr - lookup unpacked lun and submit uninitialized se_cmd
  *                     for TMR CDBs
@@ -1741,9 +1750,12 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
-		se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
-		se_cmd->se_tfo->queue_tm_rsp(se_cmd);
-		transport_generic_free_cmd(se_cmd, 0);
+		/*
+		 * For callback during failure handling, push this work off
+		 * to process context with TMR_LUN_DOES_NOT_EXIST status.
+		 */
+		INIT_WORK(&se_cmd->work, target_complete_tmr_failure);
+		schedule_work(&se_cmd->work);
 		return 0;
 	}
 	transport_generic_handle_tmr(se_cmd);
-- 
1.7.2.5

