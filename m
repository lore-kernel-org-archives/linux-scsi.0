From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 03/20] be2iscsi: Fixing the return type of functions
Date: Mon, 12 Jul 2010 23:20:17 +0530
Message-ID: <20100712175006.GA11396@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:30832 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756246Ab0GLRuN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:50:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   Fixing some functions return values that did not match with
the possible return values

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.h |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c |   13 ++++++-------
 drivers/scsi/be2iscsi/be_mgmt.h |   10 +++++-----
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index f94df6c..30a293f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -423,7 +423,7 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 			struct be_queue_info *cq);
 
 int be_poll_mcc(struct be_ctrl_info *ctrl);
-unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
+int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba);
 unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba);
 void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ff8b1cd..dcb70fa 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -21,7 +21,7 @@
 #include "be_mgmt.h"
 #include "be_iscsi.h"
 
-unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
+int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
 {
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
@@ -65,7 +65,7 @@ unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 	return status;
 }
 
-unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
+int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 				      struct beiscsi_hba *phba)
 {
 	struct be_dma_mem nonemb_cmd;
@@ -117,8 +117,7 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	return status;
 }
 
-
-unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
+int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb = wrb_from_mccq(phba);
@@ -144,7 +143,7 @@ unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 	return status;
 }
 
-unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+unsigned int  mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				struct invalidate_command_table *inv_tbl,
 				unsigned int num_invalidate, unsigned int cid)
 {
@@ -202,7 +201,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 	return tag;
 }
 
-unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
 					 unsigned short issue_reset,
@@ -239,7 +238,7 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 	return tag;
 }
 
-unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
 				unsigned short cid, unsigned int upload_flag)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 3d316b8..74b885a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -86,14 +86,14 @@ struct mcc_wrb {
 	struct mcc_wrb_payload payload;
 };
 
-unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute);
+int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute);
 int mgmt_open_connection(struct beiscsi_hba *phba, struct sockaddr *dst_addr,
 			 struct beiscsi_endpoint *beiscsi_ep);
 
-unsigned char mgmt_upload_connection(struct beiscsi_hba *phba,
+unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
 				     unsigned short cid,
 				     unsigned int upload_flag);
-unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
+unsigned int mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				struct invalidate_command_table *inv_tbl,
 				unsigned int num_invalidate, unsigned int cid);
 
@@ -237,10 +237,10 @@ struct beiscsi_endpoint {
 	u16 cid_vld;
 };
 
-unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
+int mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				 struct beiscsi_hba *phba);
 
-unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
+unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 struct beiscsi_endpoint *beiscsi_ep,
 					 unsigned short cid,
 					 unsigned short issue_reset,
-- 
1.6.5.2

