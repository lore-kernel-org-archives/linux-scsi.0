From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/2] be2iscsi: Adding bsg Interface
Date: Wed, 4 Nov 2009 04:49:00 +0530
Message-ID: <20091103231850.GA2468@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:5590 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751416AbZKCXSs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 18:18:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

  This patch adds bsg Interface to the driver.

This patch is dependent on the patch from James Smart

   http://mail.spinics.net/lists/linux-scsi/msg40079.html

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   25 +++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.c |   62 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h |    5 +++
 3 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 06e1aa6..e72a9bb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -28,6 +28,7 @@
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -3656,6 +3657,29 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
+/**
+* beiscsi_bsg_request - handle bsg request from ISCSI transport
+ * @job: iscsi_bsg_job to handle
+ */
+static int beiscsi_bsg_request(struct iscsi_bsg_job *job)
+{
+	uint32_t msgcode;
+	int rc = -EINVAL;
+	struct beiscsi_hba *phba;
+
+	msgcode = job->request->msgcode;
+	phba = iscsi_host_priv(job->shost);
+	switch (msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		rc = mgmt_fw_cmd(&phba->ctrl, phba, job);
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
 static void beiscsi_remove(struct pci_dev *pcidev)
 {
 	struct beiscsi_hba *phba = NULL;
@@ -3897,6 +3921,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.ep_poll = beiscsi_ep_poll,
 	.ep_disconnect = beiscsi_ep_disconnect,
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	.bsg_request = beiscsi_bsg_request,
 };
 
 static struct pci_driver beiscsi_pci_driver = {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8bfb574..a3c840d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -21,6 +21,7 @@
 #include "be_mgmt.h"
 #include "be_iscsi.h"
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 
 unsigned char mgmt_get_fw_config(struct be_ctrl_info *ctrl,
 				struct beiscsi_hba *phba)
@@ -117,6 +118,67 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	return status;
 }
 
+int  mgmt_fw_cmd(struct be_ctrl_info *ctrl,
+		 struct beiscsi_hba *phba,
+		 struct iscsi_bsg_job *job)
+{
+	struct be_dma_mem nonemb_cmd;
+	unsigned char *pdata;
+	int num, tot_len, status = -EIO;
+	struct scatterlist *sge = NULL;
+	struct be_cmd_resp_hdr *resp;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_sge *mcc_sge = nonembedded_sgl(wrb);
+
+	tot_len = 0;
+	for_each_sg(job->request_payload.sg_list, sge,
+		    job->request_payload.sg_cnt, num) {
+		tot_len += sg_dma_len(sge);
+	}
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+					     tot_len,
+					     &nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			 "Failed to allocate memory for mgmt_fw_cmd \n");
+		return -EIO;
+	}
+	pdata = nonemb_cmd.va;
+	resp = nonemb_cmd.va;
+	nonemb_cmd.size = tot_len;
+	for_each_sg(job->request_payload.sg_list, sge,
+			 job->request_payload.sg_cnt, num) {
+		memcpy(pdata, sg_virt(sge), sg_dma_len(sge));
+		pdata += sg_dma_len(sge);
+	}
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, tot_len, false, job->request_payload.sg_cnt);
+	mcc_sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	mcc_sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	mcc_sge->len = cpu_to_le32(nonemb_cmd.size);
+
+	status = be_mbox_notify(ctrl);
+	if (status)
+		SE_DEBUG(DBG_LVL_1, " Failed in mgmt_fw_cmd\n");
+
+	pdata = nonemb_cmd.va;
+	for_each_sg(job->reply_payload.sg_list, sge,
+		    job->request_payload.sg_cnt, num) {
+		memcpy(sg_virt(sge), pdata, sg_dma_len(sge));
+		pdata += sg_dma_len(sge);
+	}
+	pci_free_consistent(ctrl->pdev, nonemb_cmd.size,
+				    nonemb_cmd.va, nonemb_cmd.dma);
+
+	spin_unlock(&ctrl->mbox_lock);
+	job->reply->reply_payload_rcv_len = resp->response_length;
+	job->reply->result = status;
+	job->job_done(job);
+	return 0;
+ }
+
 unsigned char mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 {
 	struct be_ctrl_info *ctrl = &phba->ctrl;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index b97c3cd..2cba2f4 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -248,4 +248,9 @@ unsigned char mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short cid,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
+
+int  mgmt_fw_cmd(struct be_ctrl_info *ctrl,
+		 struct beiscsi_hba *phba,
+		 struct iscsi_bsg_job *job);
+
 #endif
-- 
1.6.4

