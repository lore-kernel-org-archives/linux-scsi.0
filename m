From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 16/18] megaraid_sas : add missing byte swaps to the sriov code
Date: Mon, 20 Apr 2015 18:05:00 +0530
Message-ID: <201504201237.t3KCbCJU016872@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:2704
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755057AbbDTNNA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 09:13:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   46 +++++++++++++++-------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 67b9de8..e863701 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1921,20 +1921,22 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_BOTH;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = sizeof(struct MR_LD_VF_AFFILIATION_111);
-	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111;
+	dcmd->data_xfer_len =
+		cpu_to_le32(sizeof(struct MR_LD_VF_AFFILIATION_111));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111);
 
 	if (initial)
 		dcmd->sgl.sge32[0].phys_addr =
-			instance->vf_affiliation_111_h;
+			cpu_to_le32(instance->vf_affiliation_111_h);
 	else
-		dcmd->sgl.sge32[0].phys_addr = new_affiliation_111_h;
+		dcmd->sgl.sge32[0].phys_addr =
+			cpu_to_le32(new_affiliation_111_h);
 
-	dcmd->sgl.sge32[0].length =
-		sizeof(struct MR_LD_VF_AFFILIATION_111);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(
+		sizeof(struct MR_LD_VF_AFFILIATION_111));
 
 	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
 	       "scsi%d\n", instance->host->host_no);
@@ -2032,20 +2034,22 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_BOTH;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = (MAX_LOGICAL_DRIVES + 1) *
-		sizeof(struct MR_LD_VF_AFFILIATION);
-	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS;
+	dcmd->data_xfer_len = cpu_to_le32((MAX_LOGICAL_DRIVES + 1) *
+		sizeof(struct MR_LD_VF_AFFILIATION));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_LD_VF_MAP_GET_ALL_LDS);
 
 	if (initial)
-		dcmd->sgl.sge32[0].phys_addr = instance->vf_affiliation_h;
+		dcmd->sgl.sge32[0].phys_addr =
+			cpu_to_le32(instance->vf_affiliation_h);
 	else
-		dcmd->sgl.sge32[0].phys_addr = new_affiliation_h;
+		dcmd->sgl.sge32[0].phys_addr =
+			cpu_to_le32(new_affiliation_h);;
 
-	dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
-		sizeof(struct MR_LD_VF_AFFILIATION);
+	dcmd->sgl.sge32[0].length = cpu_to_le32((MAX_LOGICAL_DRIVES + 1) *
+		sizeof(struct MR_LD_VF_AFFILIATION));
 
 	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
 	       "scsi%d\n", instance->host->host_no);
@@ -2193,17 +2197,17 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
 
-	dcmd->mbox.s[0] = sizeof(struct MR_CTRL_HB_HOST_MEM);
+	dcmd->mbox.s[0] = cpu_to_le16(sizeof(struct MR_CTRL_HB_HOST_MEM));
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_BOTH;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = sizeof(struct MR_CTRL_HB_HOST_MEM);
-	dcmd->opcode = MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC;
-	dcmd->sgl.sge32[0].phys_addr = instance->hb_host_mem_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct MR_CTRL_HB_HOST_MEM);
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct MR_CTRL_HB_HOST_MEM));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->hb_host_mem_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_CTRL_HB_HOST_MEM));
 
 	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
 	       instance->host->host_no);
-- 
1.7.1

