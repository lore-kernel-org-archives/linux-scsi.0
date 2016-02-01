From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 04/12] be2iscsi: Rename MCC and BMBX processing functions
Date: Mon,  1 Feb 2016 15:42:43 +0530
Message-ID: <1454321571-16167-5-git-send-email-jitendra.bhivare@avagotech.com>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54813 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753277AbcBAKNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 05:13:25 -0500
In-Reply-To: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

beiscsi_mccq_compl -> beiscsi_mccq_compl_wait - indicate blocking call.
be_mcc_wait_compl -> be_mcc_compl_poll - indicate polling for completion.
be_mbox_db_ready_wait -> be_mbox_db_ready_poll - indicate polling for RDY.
be_mcc_compl_process -> beiscsi_process_mbox_compl - indicate BMBX compl.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  | 35 +++++++++++++++++------------------
 drivers/scsi/be2iscsi/be_cmds.h  |  6 +++---
 drivers/scsi/be2iscsi/be_iscsi.c |  8 ++++----
 drivers/scsi/be2iscsi/be_main.c  |  8 ++++----
 drivers/scsi/be2iscsi/be_mgmt.c  | 12 ++++++------
 5 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index fa010ac..8dd8521 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -140,7 +140,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 }
 
 /*
- * beiscsi_mccq_compl()- Wait for completion of MBX
+ * beiscsi_mccq_compl_wait()- Process completion in MCC CQ
  * @phba: Driver private structure
  * @tag: Tag for the MBX Command
  * @wrb: the WRB used for the MBX Command
@@ -152,9 +152,9 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
  * Success: 0
  * Failure: Non-Zero
  **/
-int beiscsi_mccq_compl(struct beiscsi_hba *phba,
-		uint32_t tag, struct be_mcc_wrb **wrb,
-		struct be_dma_mem *mbx_cmd_mem)
+int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
+			    uint32_t tag, struct be_mcc_wrb **wrb,
+			    struct be_dma_mem *mbx_cmd_mem)
 {
 	int rc = 0;
 	uint32_t mcc_tag_status;
@@ -283,7 +283,7 @@ static inline void be_mcc_compl_use(struct be_mcc_compl *compl)
 }
 
 /*
- * be_mcc_compl_process()- Check the MBX comapletion status
+ * beiscsi_process_mbox_compl()- Check the MBX completion status
  * @ctrl: Function specific MBX data structure
  * @compl: Completion status of MBX Command
  *
@@ -293,8 +293,8 @@ static inline void be_mcc_compl_use(struct be_mcc_compl *compl)
  * Success: Zero
  * Failure: Non-Zero
  **/
-static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
-				struct be_mcc_compl *compl)
+static int beiscsi_process_mbox_compl(struct be_ctrl_info *ctrl,
+				      struct be_mcc_compl *compl)
 {
 	u16 compl_status, extd_status;
 	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
@@ -520,7 +520,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
 }
 
 /*
- * be_mcc_wait_compl()- Wait for MBX completion
+ * be_mcc_compl_poll()- Wait for MBX completion
  * @phba: driver private structure
  *
  * Wait till no more pending mcc requests are present
@@ -556,8 +556,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
 }
 
 /*
-/*
- * be_mbox_db_ready_wait()- Check ready status
+ * be_mbox_db_ready_poll()- Check ready status
  * @ctrl: Function specific MBX data structure
  *
  * Check for the ready status of FW to send BMBX
@@ -567,7 +566,7 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
  * Success: 0
  * Failure: Non-Zero
  **/
-static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
+static int be_mbox_db_ready_poll(struct be_ctrl_info *ctrl)
 {
 	/* wait 30s for generic non-flash MBOX operation */
 #define BEISCSI_MBX_RDY_BIT_TIMEOUT	30000
@@ -629,7 +628,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	struct be_mcc_compl *compl = &mbox->compl;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status)
 		return status;
 
@@ -638,7 +637,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
 	iowrite32(val, db);
 
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status)
 		return status;
 
@@ -648,7 +647,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	val |= (u32) (mbox_mem->dma >> 4) << 2;
 	iowrite32(val, db);
 
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status)
 		return status;
 
@@ -656,7 +655,7 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	udelay(1);
 
 	if (be_mcc_compl_is_new(compl)) {
-		status = be_mcc_compl_process(ctrl, &mbox->compl);
+		status = beiscsi_process_mbox_compl(ctrl, compl);
 		be_mcc_compl_use(compl);
 		if (status) {
 			beiscsi_log(phba, KERN_ERR,
@@ -689,7 +688,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba *phba)
 	struct be_mcc_compl *compl = &mbox->compl;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status)
 		return status;
 
@@ -699,7 +698,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba *phba)
 	iowrite32(val, db);
 
 	/* wait for ready to be set */
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status != 0)
 		return status;
 
@@ -708,7 +707,7 @@ static int be_mbox_notify_wait(struct beiscsi_hba *phba)
 	val |= (u32)(mbox_mem->dma >> 4) << 2;
 	iowrite32(val, db);
 
-	status = be_mbox_db_ready_wait(ctrl);
+	status = be_mbox_db_ready_poll(ctrl);
 	if (status != 0)
 		return status;
 
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index f50b32ac..b14ac01 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -732,9 +732,9 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
 
 int be_cmd_modify_eq_delay(struct beiscsi_hba *phba, struct be_set_eqd *,
 			    int num);
-int beiscsi_mccq_compl(struct beiscsi_hba *phba,
-			uint32_t tag, struct be_mcc_wrb **wrb,
-			struct be_dma_mem *mbx_cmd_mem);
+int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
+			    uint32_t tag, struct be_mcc_wrb **wrb,
+			    struct be_dma_mem *mbx_cmd_mem);
 /*ISCSI Functuions */
 int be_cmd_fw_initialize(struct be_ctrl_info *ctrl);
 int be_cmd_fw_uninit(struct be_ctrl_info *ctrl);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 633257b..09f89a3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -735,7 +735,7 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
 		return -EBUSY;
 	}
 
-	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+	rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -1143,7 +1143,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		return -EAGAIN;
 	}
 
-	ret = beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
+	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -1302,7 +1302,7 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 		ret = -EAGAIN;
 	}
 
-	ret = beiscsi_mccq_compl(phba, tag, NULL, NULL);
+	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 
 	/* Flush the CQ entries */
 	beiscsi_flush_cq(phba);
@@ -1377,7 +1377,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 			    beiscsi_ep->ep_cid);
 	}
 
-	beiscsi_mccq_compl(phba, tag, NULL, NULL);
+	beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 	beiscsi_close_conn(beiscsi_ep, tcp_upload_flag);
 free_ep:
 	msleep(BEISCSI_LOGOUT_SYNC_DELAY);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8b9d01a..dfc2ee9 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -286,7 +286,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
-	rc = beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
+	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (rc != -EBUSY)
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
@@ -367,7 +367,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 
-	rc = beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
+	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (rc != -EBUSY)
 		pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 				    nonemb_cmd.va, nonemb_cmd.dma);
@@ -4394,7 +4394,7 @@ static int beiscsi_get_boot_info(struct beiscsi_hba *phba)
 		goto boot_freemem;
 	}
 
-	ret = beiscsi_mccq_compl(phba, tag, NULL, &nonemb_cmd);
+	ret = beiscsi_mccq_compl_wait(phba, tag, NULL, &nonemb_cmd);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
@@ -5424,7 +5424,7 @@ static void be_eqd_update(struct beiscsi_hba *phba)
 	if (num) {
 		tag = be_cmd_modify_eq_delay(phba, set_eqd, num);
 		if (tag)
-			beiscsi_mccq_compl(phba, tag, NULL, NULL);
+			beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 	}
 }
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a88e636..85044b8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -942,7 +942,7 @@ unsigned int mgmt_get_all_if_id(struct beiscsi_hba *phba)
 	be_mcc_notify(phba, tag);
 	mutex_unlock(&ctrl->mbox_lock);
 
-	status = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+	status = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (status) {
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 			    "BG_%d : Failed in mgmt_get_all_if_id\n");
@@ -993,7 +993,7 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_hba *phba,
 	be_mcc_notify(phba, tag);
 	mutex_unlock(&ctrl->mbox_lock);
 
-	rc = beiscsi_mccq_compl(phba, tag, NULL, nonemb_cmd);
+	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, nonemb_cmd);
 
 	if (resp_buf)
 		memcpy(resp_buf, nonemb_cmd->va, resp_buf_len);
@@ -1427,7 +1427,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 			return -EAGAIN;
 		}
 
-		rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+		rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 		if (rc) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
@@ -1461,7 +1461,7 @@ int be_mgmt_get_boot_shandle(struct beiscsi_hba *phba,
 			return -EAGAIN;
 		}
 
-		rc = beiscsi_mccq_compl(phba, tag, NULL, NULL);
+		rc = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 		if (rc) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
@@ -1503,7 +1503,7 @@ int mgmt_set_vlan(struct beiscsi_hba *phba,
 		return -EBUSY;
 	}
 
-	rc = beiscsi_mccq_compl(phba, tag, NULL, NULL);
+	rc = beiscsi_mccq_compl_wait(phba, tag, NULL, NULL);
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    (BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX),
@@ -1869,7 +1869,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *phba,
 	be_mcc_notify(phba, tag);
 	mutex_unlock(&ctrl->mbox_lock);
 
-	rc = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+	rc = beiscsi_mccq_compl_wait(phba, tag, &wrb, NULL);
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
-- 
2.5.0

