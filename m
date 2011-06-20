From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 10/12] tcm_fc: Fixing reference counting problem which was
 causing ft_sess to be deleted.
Date: Mon, 20 Jun 2011 16:59:41 -0700
Message-ID: <20110620235941.1777.89859.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15144 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab1FTX7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:41 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: After fixing the issue in TCM core w.r.t LUN Reset (Task Management request)
, ran into issue where during the completing of this LUN Reset command, reference
count of "ft_sess" drops to zero which caused "sess" to be deleted.

Fix: As part of handling task management request (e.g. LUN Reset), TCM core function
"transport_generic_do_tmr" ends up calling ft_free_cmd  which in turn calls "ft_sess_put"
(which drops session's reference count by 1) and then frees ft_cmd. Then function
"transport_generic_do_tmr" calls "transport_cmd_check_stop" which in turn also calls
ft_free_cmd (which calls ft_sess_put - which drops reference count of sess by 1, hence
reference count of sess becomes zero and session gets deleted). Fix is to just send
response in case of tmr from function "ft_queue_resp_code" and not delete "ft_cmd"
(means don't call ft_free_cmd). Earlier code was to send the response code and also
free ft_cmd. ft_free_cmd will be freed later after sending response code as a result of
"transport_cmd_check_stop" (which calls ft_release_cmd -> ft_free_cmd) being called
from "transport_generic_do_tmr" after sening TMR response code.

Notes/Dependencies: This bug was found after fixing NULL pointer access issue in TCM
core (in LUN Reset codepath)

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index cdbcb6c..2b60eee 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -380,12 +380,23 @@ static void ft_send_resp_status(struct fc_lport *lport,
 
 /*
  * Send error or task management response.
- * Always frees the cmd and associated state.
  */
-static void ft_send_resp_code(struct ft_cmd *cmd, enum fcp_resp_rsp_codes code)
+static void ft_send_resp_code(struct ft_cmd *cmd,
+			      enum fcp_resp_rsp_codes code)
 {
 	ft_send_resp_status(cmd->sess->tport->lport,
 			    cmd->req_frame, SAM_STAT_GOOD, code);
+}
+
+
+/*
+ * Send error or task management response.
+ * Always frees the cmd and associated state.
+ */
+static void ft_send_resp_code_and_free(struct ft_cmd *cmd,
+				      enum fcp_resp_rsp_codes code)
+{
+	ft_send_resp_code(cmd, code);
 	ft_free_cmd(cmd);
 }
 
@@ -422,7 +433,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		 * tm_flags set is invalid.
 		 */
 		FT_TM_DBG("invalid FCP tm_flags %x\n", fcp->fc_tm_flags);
-		ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
+		ft_send_resp_code_and_free(cmd, FCP_CMND_FIELDS_INVALID);
 		return;
 	}
 
@@ -430,7 +441,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func);
 	if (!tmr) {
 		FT_TM_DBG("alloc failed\n");
-		ft_send_resp_code(cmd, FCP_TMF_FAILED);
+		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
 		return;
 	}
 	cmd->se_cmd.se_tmr_req = tmr;
@@ -668,7 +679,7 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 	return;
 
 err:
-	ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
+	ft_send_resp_code_and_free(cmd, FCP_CMND_FIELDS_INVALID);
 	return;
 }
 

