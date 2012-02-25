From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/7] target: Fix target_submit_tmr LUN lookup failures
Date: Sat, 25 Feb 2012 21:05:54 +0000
Message-ID: <1330203959-6170-3-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45531 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2BYVOO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:14 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target_submit_tmr() LUN lookup failures to set response
status TMR_LUN_DOES_NOT_EXIST and invoke TFO->queue_tm_rsp(), instead of
sending CHECK_CONDITION status that can cause problems with Linux FCoE
clients.

Tested with tcm_fc ports and explict LUN_RESET lookup failures.

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4988899..a526907 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1741,8 +1741,8 @@ void target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 
 	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
 	if (ret) {
-		transport_send_check_condition_and_sense(se_cmd,
-			se_cmd->scsi_sense_reason, 0);
+		se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
+		se_cmd->se_tfo->queue_tm_rsp(se_cmd);
 		transport_generic_free_cmd(se_cmd, 0);
 		return;
 	}
-- 
1.7.2.5

