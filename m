From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/7] tcm_fc: Handle target_submit_tmr allocation failure
Date: Sat, 25 Feb 2012 21:05:56 +0000
Message-ID: <1330203959-6170-5-git-send-email-nab@linux-iscsi.org>
References: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45541 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2BYVOR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Feb 2012 16:14:17 -0500
In-Reply-To: <1330203959-6170-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Kiran Patil <kiran.patil@intel.com>, Arun Easi <arun.easi@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes ft_send_tm() handle target_submit_tmr() allocation failures
via an ft_send_resp_code_and_free() w/ FCP_TMF_FAILED status.

Cc: Andy Grover <agrover@redhat.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 1baee28..00dcc5f 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -354,6 +354,7 @@ static void ft_send_resp_code_and_free(struct ft_cmd *cmd,
 static void ft_send_tm(struct ft_cmd *cmd)
 {
 	struct fcp_cmnd *fcp;
+	int rc;
 	u8 tm_func;
 
 	fcp = fc_frame_payload_get(cmd->req_frame, sizeof(*fcp));
@@ -383,9 +384,11 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		return;
 	}
 
-	target_submit_tmr(&cmd->se_cmd, cmd->sess->se_sess,
+	rc = target_submit_tmr(&cmd->se_cmd, cmd->sess->se_sess,
 		&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 			  cmd, tm_func, 0);
+	if (rc < 0)
+		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
 }
 
 /*
-- 
1.7.2.5

