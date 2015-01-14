From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 07/10] megaraid_sas: add missing byte swaps to the sriov code
Date: Wed, 14 Jan 2015 16:32:01 +0530
Message-ID: <2255d5d70cf7858afeb4fec547f2dba6@mail.gmail.com>
References: <1420909883-19479-1-git-send-email-hch@lst.de> <1420909883-19479-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:41211 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbANLCX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 06:02:23 -0500
Received: by mail-qg0-f46.google.com with SMTP id q107so6316172qgd.5
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 03:02:02 -0800 (PST)
In-Reply-To: <1420909883-19479-8-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@avagotech.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@lst.de]
>Sent: Saturday, January 10, 2015 10:41 PM
>To: Sumit.Saxena@avagotech.com; kashyap.desai@avagotech.com
>Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org
>Subject: [PATCH 07/10] megaraid_sas: add missing byte swaps to the sriov
>code
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 46 +++++++++++++++++-------
>-------
> 1 file changed, 25 insertions(+), 21 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 548d033..5350e18 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -1924,20 +1924,22 @@ static int
>megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
> 	dcmd->cmd = MFI_CMD_DCMD;
> 	dcmd->cmd_status = 0xFF;
> 	dcmd->sge_count = 1;
>-	dcmd->flags = MFI_FRAME_DIR_BOTH;
>+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
> 	dcmd->timeout = 0;
> 	dcmd->pad_0 = 0;
>-	dcmd->data_xfer_len = sizeof(struct MR_LD_VF_AFFILIATION_111);
>-	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111;
>+	dcmd->data_xfer_len =
>+		cpu_to_le32(sizeof(struct MR_LD_VF_AFFILIATION_111));
>+	dcmd->opcode =
>cpu_to_le32(MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111);
>
> 	if (initial)
> 		dcmd->sgl.sge32[0].phys_addr =
>-			instance->vf_affiliation_111_h;
>+			cpu_to_le32(instance->vf_affiliation_111_h);
> 	else
>-		dcmd->sgl.sge32[0].phys_addr = new_affiliation_111_h;
>+		dcmd->sgl.sge32[0].phys_addr =
>+			cpu_to_le32(new_affiliation_111_h);
>
>-	dcmd->sgl.sge32[0].length =
>-		sizeof(struct MR_LD_VF_AFFILIATION_111);
>+	dcmd->sgl.sge32[0].length = cpu_to_le32(
>+		sizeof(struct MR_LD_VF_AFFILIATION_111));
>
> 	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation
>for "
> 	       "scsi%d\n", instance->host->host_no); @@ -2039,20 +2041,22
@@
>static int megasas_get_ld_vf_affiliation_12(struct megasas_instance
>*instance,
> 	dcmd->cmd = MFI_CMD_DCMD;
> 	dcmd->cmd_status = 0xFF;
> 	dcmd->sge_count = 1;
>-	dcmd->flags = MFI_FRAME_DIR_BOTH;
>+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
> 	dcmd->timeout = 0;
> 	dcmd->pad_0 = 0;
>-	dcmd->data_xfer_len = (MAX_LOGICAL_DRIVES + 1) *
>-		sizeof(struct MR_LD_VF_AFFILIATION);
>-	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS;
>+	dcmd->data_xfer_len = cpu_to_le32((MAX_LOGICAL_DRIVES + 1) *
>+		sizeof(struct MR_LD_VF_AFFILIATION));
>+	dcmd->opcode =
>cpu_to_le32(MR_DCMD_LD_VF_MAP_GET_ALL_LDS);
>
> 	if (initial)
>-		dcmd->sgl.sge32[0].phys_addr = instance->vf_affiliation_h;
>+		dcmd->sgl.sge32[0].phys_addr =
>+			cpu_to_le32(instance->vf_affiliation_h);
> 	else
>-		dcmd->sgl.sge32[0].phys_addr = new_affiliation_h;
>+		dcmd->sgl.sge32[0].phys_addr =
>+			cpu_to_le32(new_affiliation_h);;
>
>-	dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
>-		sizeof(struct MR_LD_VF_AFFILIATION);
>+	dcmd->sgl.sge32[0].length = cpu_to_le32((MAX_LOGICAL_DRIVES +
>1) *
>+		sizeof(struct MR_LD_VF_AFFILIATION));
>
> 	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation
>for "
> 	       "scsi%d\n", instance->host->host_no); @@ -2204,17 +2208,17
@@
>int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
>
> 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
>
>-	dcmd->mbox.s[0] = sizeof(struct MR_CTRL_HB_HOST_MEM);
>+	dcmd->mbox.s[0] = cpu_to_le16(sizeof(struct
>MR_CTRL_HB_HOST_MEM));
> 	dcmd->cmd = MFI_CMD_DCMD;
> 	dcmd->cmd_status = 0xFF;
> 	dcmd->sge_count = 1;
>-	dcmd->flags = MFI_FRAME_DIR_BOTH;
>+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
> 	dcmd->timeout = 0;
> 	dcmd->pad_0 = 0;
>-	dcmd->data_xfer_len = sizeof(struct MR_CTRL_HB_HOST_MEM);
>-	dcmd->opcode = MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC;
>-	dcmd->sgl.sge32[0].phys_addr = instance->hb_host_mem_h;
>-	dcmd->sgl.sge32[0].length = sizeof(struct
>MR_CTRL_HB_HOST_MEM);
>+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct
>MR_CTRL_HB_HOST_MEM));
>+	dcmd->opcode =
>cpu_to_le32(MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC);
>+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance-
>>hb_host_mem_h);
>+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct
>+MR_CTRL_HB_HOST_MEM));
>
> 	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for
>scsi%d\n",
> 	       instance->host->host_no);
Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.1
