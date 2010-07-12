From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 02/20] be2iscsi: Fixing return values
Date: Mon, 12 Jul 2010 23:19:30 +0530
Message-ID: <20100712174919.GA11368@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:30709 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753141Ab0GLRt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:49:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch fixes the return values as per comment from Mike Christie

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |   12 ++++++------
 drivers/scsi/be2iscsi/be_iscsi.c |   12 ++++++------
 drivers/scsi/be2iscsi/be_main.c  |    4 ++--
 drivers/scsi/be2iscsi/be_mgmt.c  |    4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4f19030..9cc1f55 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -98,7 +98,7 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 		dev_err(&ctrl->pdev->dev,
 			"error in cmd completion: status(compl/extd)=%d/%d\n",
 			compl_status, extd_status);
-		return -1;
+		return -EBUSY;
 	}
 	return 0;
 }
@@ -231,7 +231,7 @@ static int be_mcc_wait_compl(struct beiscsi_hba *phba)
 	}
 	if (i == mcc_timeout) {
 		dev_err(&phba->pcidev->dev, "mccq poll timed out\n");
-		return -1;
+		return -EBUSY;
 	}
 	return 0;
 }
@@ -257,7 +257,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 
 		if (cnt > 6000000) {
 			dev_err(&ctrl->pdev->dev, "mbox_db poll timed out\n");
-			return -1;
+			return -EBUSY;
 		}
 
 		if (cnt > 50) {
@@ -309,7 +309,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 		}
 	} else {
 		dev_err(&ctrl->pdev->dev, "invalid mailbox completion\n");
-		return -1;
+		return -EBUSY;
 	}
 	return 0;
 }
@@ -355,7 +355,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba *phba)
 			return status;
 	} else {
 		dev_err(&phba->pcidev->dev, "invalid mailbox completion\n");
-		return -1;
+		return -EBUSY;
 	}
 	return 0;
 }
@@ -652,7 +652,7 @@ int beiscsi_cmd_q_destroy(struct be_ctrl_info *ctrl, struct be_queue_info *q,
 	default:
 		spin_unlock(&ctrl->mbox_lock);
 		BUG();
-		return -1;
+		return -ENXIO;
 	}
 	be_cmd_hdr_prepare(&req->hdr, subsys, opcode, sizeof(*req));
 	if (queue_type != QTYPE_SGL)
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 7e48f30..ca9bd3a 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -230,7 +230,7 @@ int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	if (!beiscsi_ep) {
 		SE_DEBUG(DBG_LVL_1,
 			 "In beiscsi_conn_get_param , no beiscsi_ep\n");
-		return -1;
+		return -ENODEV;
 	}
 
 	switch (param) {
@@ -309,7 +309,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 		tag = be_cmd_get_mac_addr(phba);
 		if (!tag) {
 			SE_DEBUG(DBG_LVL_1, "be_cmd_get_mac_addr Failed\n");
-			return -1;
+			return -EAGAIN;
 		} else
 			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 						 phba->ctrl.mcc_numtag[tag]);
@@ -322,7 +322,7 @@ int beiscsi_get_host_param(struct Scsi_Host *shost,
 					    " status = %d extd_status = %d\n",
 					    status, extd_status);
 			free_mcc_tag(&phba->ctrl, tag);
-			return -1;
+			return -EAGAIN;
 		} else {
 			wrb = queue_get_wrb(mccq, wrb_num);
 			free_mcc_tag(&phba->ctrl, tag);
@@ -460,7 +460,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	struct tcp_connect_and_offload_out *ptcpcnct_out;
 	unsigned short status, extd_status;
 	unsigned int tag, wrb_num;
-	int ret = -1;
+	int ret = -ENOMEM;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_open_conn\n");
 	beiscsi_ep->ep_cid = beiscsi_get_cid(phba);
@@ -496,7 +496,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 				    " status = %d extd_status = %d\n",
 				    status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
-		return -1;
+		return -EAGAIN;
 	} else {
 		wrb = queue_get_wrb(mccq, wrb_num);
 		free_mcc_tag(&phba->ctrl, tag);
@@ -622,7 +622,7 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 	if (!tag) {
 		SE_DEBUG(DBG_LVL_8, "upload failed for cid 0x%x\n",
 			 beiscsi_ep->ep_cid);
-		ret = -1;
+		ret = -EAGAIN;
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a9e33ff..8552ee5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2681,7 +2681,7 @@ static int be_queue_alloc(struct beiscsi_hba *phba, struct be_queue_info *q,
 	mem->size = len * entry_size;
 	mem->va = pci_alloc_consistent(phba->pcidev, mem->size, &mem->dma);
 	if (!mem->va)
-		return -1;
+		return -ENOMEM;
 	memset(mem->va, 0, mem->size);
 	return 0;
 }
@@ -2876,7 +2876,7 @@ mcc_cq_destroy:
 mcc_cq_free:
 	be_queue_free(phba, cq);
 err:
-	return -1;
+	return -ENOMEM;
 }
 
 static int find_num_cpus(void)
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index dc55945..ff8b1cd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -81,7 +81,7 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for mgmt_check_supported_fw"
 			 "\n");
-		return -1;
+		return -ENOMEM;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
 	req = nonemb_cmd.va;
@@ -169,7 +169,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to alloc memory for mgmt_invalidate_icds\n");
 		spin_unlock(&ctrl->mbox_lock);
-		return -1;
+		return 0;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
 	req = nonemb_cmd.va;
-- 
1.6.5.2

