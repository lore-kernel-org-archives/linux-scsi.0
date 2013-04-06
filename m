From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 03/18] be2iscsi: Fix MBX Command issues
Date: Fri,  5 Apr 2013 20:38:23 -0700
Message-ID: <1365219519-3457-3-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39291 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162255Ab3DFDix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:38:53 -0400
Received: by mail-pd0-f170.google.com with SMTP id 10so2300745pdi.29
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:38:52 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 - Check Ready Bit before posting the BMBX Hi Address
 - Fix the parameters passed to beiscsi_mccq_compl
   in beiscsi_open_conn()
 - Fix tag value check in beiscsi_ep_connect.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c  |   10 +++++++++-
 drivers/scsi/be2iscsi/be_iscsi.c |    7 +++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 3ad95c7..dfbe7e4 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -492,7 +492,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 {
 	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
-	int wait = 0;
+	uint32_t wait = 0;
 	u32 ready;
 
 	do {
@@ -540,6 +540,10 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
 	struct be_mcc_compl *compl = &mbox->compl;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status)
+		return status;
+
 	val &= ~MPU_MAILBOX_DB_RDY_MASK;
 	val |= MPU_MAILBOX_DB_HI_MASK;
 	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
@@ -593,6 +597,10 @@ static int be_mbox_notify_wait(struct beiscsi_hba *phba)
 	struct be_mcc_compl *compl = &mbox->compl;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 
+	status = be_mbox_db_ready_wait(ctrl);
+	if (status)
+		return status;
+
 	val |= MPU_MAILBOX_DB_HI_MASK;
 	/* at bits 2 - 31 place mbox dma addr msb bits 34 - 63 */
 	val |= (upper_32_bits(mbox_mem->dma) >> 2) << 2;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 214d691..1097fa2 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1009,7 +1009,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 {
 	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
-	struct be_mcc_wrb *wrb;
 	struct tcp_connect_and_offload_out *ptcpcnct_out;
 	struct be_dma_mem nonemb_cmd;
 	unsigned int tag;
@@ -1055,7 +1054,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
 	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
-	if (!tag) {
+	if (tag <= 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : mgmt_open_connection Failed for cid=%d\n",
 			    beiscsi_ep->ep_cid);
@@ -1066,7 +1065,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		return -EAGAIN;
 	}
 
-	ret = beiscsi_mccq_compl(phba, tag, &wrb, NULL);
+	ret = beiscsi_mccq_compl(phba, tag, NULL, nonemb_cmd.va);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -1077,7 +1076,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		goto free_ep;
 	}
 
-	ptcpcnct_out = embedded_payload(wrb);
+	ptcpcnct_out = (struct tcp_connect_and_offload_out *)nonemb_cmd.va;
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->fw_handle = ptcpcnct_out->connection_handle;
 	beiscsi_ep->cid_vld = 1;
-- 
1.7.10.4

