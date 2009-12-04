From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 13/15] be2iscsi: Removing BUG_ON for async messages
Date: Fri, 4 Dec 2009 08:56:39 +0530
Message-ID: <20091204032629.GA6299@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:7026 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754381AbZLDD00 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:26:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch removes BUG_ON when non Link Status
is reported as Async messages

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   11 +++++++----
 drivers/scsi/be2iscsi/be_cmds.h |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 9d80729..9701de6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -199,11 +199,14 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
 	while ((compl = be_mcc_compl_get(phba))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
 			/* Interpret flags as an async trailer */
-			BUG_ON(!is_link_state_evt(compl->flags));
-
-			/* Interpret compl as a async link evt */
-			beiscsi_async_link_state_process(phba,
+			if (is_link_state_evt(compl->flags))
+				/* Interpret compl as a async link evt */
+				beiscsi_async_link_state_process(phba,
 				(struct be_async_event_link_state *) compl);
+			else
+				SE_DEBUG(DBG_LVL_1,
+					" Unsupported Async Event, flags"
+					" = 0x%08x \n", compl->flags);
 		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
 				status = be_mcc_compl_process(ctrl, compl);
 				atomic_dec(&phba->ctrl.mcc_obj.q.used);
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 9b9f78a..69dddfa 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -454,6 +454,8 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 		       struct be_queue_info *wrbq);
 
+bool is_link_state_evt(u32 trailer);
+
 struct be_default_pdu_context {
 	u32 dw[4];
 } __packed;
-- 
1.6.4

