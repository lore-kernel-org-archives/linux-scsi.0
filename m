From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH V2] be2iscsi: Use pci_zalloc_consistent() where possible and get rid of memset(,0,)
Date: Mon,  9 Mar 2015 09:13:15 +0100
Message-ID: <1425888795-7099-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbbCIINn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Mar 2015 04:13:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohan.kallickal@emulex.com, hch@infradead.org, James.Bottomley@HansenPartnership.com

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 3 +--
 drivers/scsi/be2iscsi/be_main.c  | 3 +--
 drivers/scsi/be2iscsi/be_mgmt.c  | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b7391a3..85d42b1 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1133,7 +1133,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	else
 		req_memsize = sizeof(struct tcp_connect_and_offload_in_v1);
 
-	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
 				req_memsize,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
@@ -1146,7 +1146,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		return -ENOMEM;
 	}
 	nonemb_cmd.size = req_memsize;
-	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
 	if (tag <= 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a7cc618..b63344c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -344,7 +344,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	spin_unlock_bh(&session->frwd_lock);
 	inv_tbl = phba->inv_tbl;
 
-	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
+	nonemb_cmd.va = pci_zalloc_consistent(phba->ctrl.pdev,
 				sizeof(struct invalidate_commands_params_in),
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
@@ -354,7 +354,6 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
-	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate,
 				   cid, &nonemb_cmd);
 	if (!tag) {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 681d4e8..b27a625 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -428,7 +428,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	struct be_sge *sge = nonembedded_sgl(wrb);
 	int status = 0;
 
-	nonemb_cmd.va = pci_alloc_consistent(ctrl->pdev,
+	nonemb_cmd.va = pci_zalloc_consistent(ctrl->pdev,
 				sizeof(struct be_mgmt_controller_attributes),
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
@@ -439,7 +439,6 @@ int mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
 	req = nonemb_cmd.va;
-	memset(req, 0, sizeof(*req));
 	spin_lock(&ctrl->mbox_lock);
 	memset(wrb, 0, sizeof(*wrb));
 	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
-- 
Maurizio Lombardi

