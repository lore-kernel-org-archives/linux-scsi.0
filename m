From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 03/10] be2iscsi: add bsg support
Date: Sun, 24 Jul 2011 03:59:17 -0500
Message-ID: <1311497964-26842-4-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1GXI4i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:38 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds bsg support to be2iscsi. It is completely
untested. This patch is based on Jay's
[PATCH 2_2] be2iscsi: Adding bsg Interface
patch from Nov 3, 2009.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   25 +++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.c |   66 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h |    3 ++
 3 files changed, 93 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0a9bdfa..fb946a8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -27,9 +27,11 @@
 #include <linux/kernel.h>
 #include <linux/semaphore.h>
 #include <linux/iscsi_boot_sysfs.h>
+#include <linux/bsg-lib.h>
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -4102,6 +4104,28 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 	return beiscsi_iotask(task, sg, num_sg, xferlen, writedir);
 }
 
+/**
+* beiscsi_bsg_request - handle bsg request from ISCSI transport
+ * @job: iscsi_bsg_job to handle
+ */
+static int beiscsi_bsg_request(struct bsg_job *job)
+{
+	struct iscsi_bsg_request *req = job->request;
+	struct Scsi_Host *shost = iscsi_job_to_shost(job);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	int rc = -ENOSYS;
+
+	switch (req->msgcode) {
+	case ISCSI_BSG_HST_VENDOR:
+		rc = mgmt_bsg_fw_cmd(&phba->ctrl, phba, job);
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
@@ -4412,6 +4436,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.ep_poll = beiscsi_ep_poll,
 	.ep_disconnect = beiscsi_ep_disconnect,
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	.bsg_request = beiscsi_bsg_request,
 };
 
 static struct pci_driver beiscsi_pci_driver = {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 44762cf..bb819a9 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -17,9 +17,12 @@
  * Costa Mesa, CA 92626
  */
 
+#include <linux/bsg-lib.h>
+#include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_bsg_iscsi.h>
+
 #include "be_mgmt.h"
 #include "be_iscsi.h"
-#include <scsi/scsi_transport_iscsi.h>
 
 unsigned int beiscsi_get_boot_target(struct beiscsi_hba *phba)
 {
@@ -447,3 +450,64 @@ unsigned int be_cmd_get_mac_addr(struct beiscsi_hba *phba)
 	return tag;
 }
 
+int mgmt_bsg_fw_cmd(struct be_ctrl_info *ctrl, struct beiscsi_hba *phba,
+		    struct bsg_job *job)
+{
+	struct iscsi_bsg_reply *reply = job->reply;
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
+		    job->request_payload.sg_cnt, num)
+		tot_len += sg_dma_len(sge);
+
+	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev, tot_len,
+					     &nonemb_cmd.dma);
+	if (nonemb_cmd.va == NULL) {
+		SE_DEBUG(DBG_LVL_1,
+			"Failed to allocate memory for mgmt_fw_cmd \n");
+		return -EIO;
+	}
+
+	pdata = nonemb_cmd.va;
+	resp = nonemb_cmd.va;
+	nonemb_cmd.size = tot_len;
+	for_each_sg(job->request_payload.sg_list, sge,
+		    job->request_payload.sg_cnt, num) {
+		memcpy(pdata, sg_virt(sge), sg_dma_len(sge));
+		pdata += sg_dma_len(sge);
+	}
+
+	spin_lock(&ctrl->mbox_lock);
+	memset(wrb, 0, sizeof(*wrb));
+
+	be_wrb_hdr_prepare(wrb, tot_len, false, job->request_payload.sg_cnt);
+	mcc_sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd.dma));
+	mcc_sge->pa_lo = cpu_to_le32(nonemb_cmd.dma & 0xFFFFFFFF);
+	mcc_sge->len = cpu_to_le32(nonemb_cmd.size);
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
+
+	pci_free_consistent(ctrl->pdev, nonemb_cmd.size, nonemb_cmd.va,
+			    nonemb_cmd.dma);
+
+	spin_unlock(&ctrl->mbox_lock);
+	reply->reply_payload_rcv_len = resp->response_length;
+	reply->result = status;
+	bsg_job_done(job, reply->result, reply->reply_payload_rcv_len);
+	return 0;
+}
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 0842882..3a9526e 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -248,4 +248,7 @@ unsigned int mgmt_invalidate_connection(struct beiscsi_hba *phba,
 					 unsigned short issue_reset,
 					 unsigned short savecfg_flag);
 
+int mgmt_bsg_fw_cmd(struct be_ctrl_info *ctrl, struct beiscsi_hba *phba,
+		    struct bsg_job *job);
+
 #endif
-- 
1.7.2.3

