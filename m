From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] be2iscsi: Fix for kdump failure
Date: Fri,  7 Oct 2011 19:31:08 -0500
Message-ID: <1318033872-5900-2-git-send-email-michaelc@cs.wisc.edu>
References: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1JHA0C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:26:02 -0400
In-Reply-To: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch fixes the Kdump failure reported by Redhat wich was caused by be2iscsi resetting the Chip when
be2iscsi detects it is in crashdump mode. If be2net was loaded before be2iscsi then this leaves be2net driver
hanging on to resources that the chip stopped recognising after the reset.

This patch replaces  chip reset with Function reset so that only the
particular function and not the whole chip is affected

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_cmds.c |   19 +++++++++++++++++++
 drivers/scsi/be2iscsi/be_cmds.h |    2 ++
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index b8a82f2..67fd831 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -868,3 +868,22 @@ error:
 		beiscsi_cmd_q_destroy(ctrl, NULL, QTYPE_SGL);
 	return status;
 }
+
+int beiscsi_cmd_reset_function(struct beiscsi_hba  *phba)
+{
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	struct be_post_sgl_pages_req *req = embedded_payload(wrb);
+	int status;
+
+	spin_lock(&ctrl->mbox_lock);
+
+	req = embedded_payload(wrb);
+	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
+			   OPCODE_COMMON_FUNCTION_RESET, sizeof(*req));
+	status = be_mbox_notify_wait(phba);
+
+	spin_unlock(&ctrl->mbox_lock);
+	return status;
+}
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 497eb29..8b40a5b 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -561,6 +561,8 @@ int be_cmd_iscsi_post_sgl_pages(struct be_ctrl_info *ctrl,
 				struct be_dma_mem *q_mem, u32 page_offset,
 				u32 num_pages);
 
+int beiscsi_cmd_reset_function(struct beiscsi_hba *phba);
+
 int be_cmd_wrbq_create(struct be_ctrl_info *ctrl, struct be_dma_mem *q_mem,
 		       struct be_queue_info *wrbq);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 57fea38..804c46e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4276,7 +4276,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 			gcrashmode++;
 			shost_printk(KERN_ERR, phba->shost,
 				"Loading Driver in crashdump mode\n");
-			ret = beiscsi_pci_soft_reset(phba);
+			ret = beiscsi_cmd_reset_function(phba);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
 					"Reset Failed. Aborting Crashdump\n");
-- 
1.7.6

