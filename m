From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: State of big-endian for MegaRAID SAS driver
Date: Wed, 14 Aug 2013 14:11:22 -0400
Message-ID: <yq1zjskgn1x.fsf@sermon.lab.mkp.net>
References: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36027 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3HNSLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 14:11:42 -0400
In-Reply-To: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com> (Ben
	Collins's message of "Wed, 14 Aug 2013 12:57:35 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.c@servergy.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, aradford@gmail.com

>>>>> "Ben" == Ben Collins <ben.c@servergy.com> writes:

Ben> Based on some searching, back when the megaraid_sas driver was
Ben> first introduced in 2005, issues were raised with the lack of
Ben> support for big-endian architectures[1]. In this conversation, it
Ben> was said that LSI would revisit this later, and thus the driver was
Ben> included without support for big-endian architectures. Here it is 8
Ben> years later, and I'm wondering if this will ever get resolved.

I have megaraid working on big endian. PoC patch against my slightly
outdated working tree attached. Happy to forward port if there's
interest?

-- 
Martin K. Petersen	Oracle Linux Engineering

commit 906b6af65cde77a13641a476b55879424bfaae24
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Sat Aug 10 17:55:58 2013 -0400

    megaraid_sas: Big endian support
    
    This driver only worked on a little endian system. Make sure that all
    frames submitted to the hardware are converted to little endian.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a7b0876..69f6ce0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -373,12 +373,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance, struct megasas_regis
 static int 
 megasas_check_reset_xscale(struct megasas_instance *instance, struct megasas_register_set __iomem * regs)
 {
-	u32 consumer;
-	consumer = *instance->consumer;
-
-	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) && (*instance->consumer == MEGASAS_ADPRESET_INPROG_SIGN)) {
+	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
+	    (le32_to_cpu(*instance->consumer) == MEGASAS_ADPRESET_INPROG_SIGN))
 		return 1;
-	}
 
 	return 0;
 }
@@ -628,9 +625,10 @@ megasas_fire_cmd_skinny(struct megasas_instance *instance,
 {
 	unsigned long flags;
 	spin_lock_irqsave(&instance->hba_lock, flags);
-	writel(0, &(regs)->inbound_high_queue_port);
-	writel((frame_phys_addr | (frame_count<<1))|1,
-		&(regs)->inbound_low_queue_port);
+	writel(upper_32_bits(frame_phys_addr),
+	       &(regs)->inbound_high_queue_port);
+	writel((lower_32_bits(frame_phys_addr) | (frame_count<<1))|1,
+	       &(regs)->inbound_low_queue_port);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 	/*msleep(5);*/
 }
@@ -764,6 +762,7 @@ megasas_fire_cmd_gen2(struct megasas_instance *instance,
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 			&(regs)->inbound_queue_port);
+	readl(&regs->inbound_queue_port);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 }
 
@@ -881,8 +880,8 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
 
 	struct megasas_header *frame_hdr = &cmd->frame->hdr;
 
-	frame_hdr->cmd_status = 0xFF;
-	frame_hdr->flags |= MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
+	frame_hdr->cmd_status = MFI_CMD_STATUS_POLL_MODE;
+	frame_hdr->flags |= cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE);
 
 	/*
 	 * Issue the frame using inbound queue port
@@ -957,10 +956,12 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 	 */
 	abort_fr->cmd = MFI_CMD_ABORT;
 	abort_fr->cmd_status = 0xFF;
-	abort_fr->flags = 0;
+	abort_fr->flags = cpu_to_le16(0);
 	abort_fr->abort_context = cmd_to_abort->index;
-	abort_fr->abort_mfi_phys_addr_lo = cmd_to_abort->frame_phys_addr;
-	abort_fr->abort_mfi_phys_addr_hi = 0;
+	abort_fr->abort_mfi_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(cmd_to_abort->frame_phys_addr));
+	abort_fr->abort_mfi_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
 	cmd->cmd_status = 0xFF;
@@ -1001,8 +1002,8 @@ megasas_make_sgl32(struct megasas_instance *instance, struct scsi_cmnd *scp,
 
 	if (sge_count) {
 		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
-			mfi_sgl->sge32[i].length = sg_dma_len(os_sgl);
-			mfi_sgl->sge32[i].phys_addr = sg_dma_address(os_sgl);
+			mfi_sgl->sge32[i].length = cpu_to_le32(sg_dma_len(os_sgl));
+			mfi_sgl->sge32[i].phys_addr = cpu_to_le32(sg_dma_address(os_sgl));
 		}
 	}
 	return sge_count;
@@ -1030,8 +1031,8 @@ megasas_make_sgl64(struct megasas_instance *instance, struct scsi_cmnd *scp,
 
 	if (sge_count) {
 		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
-			mfi_sgl->sge64[i].length = sg_dma_len(os_sgl);
-			mfi_sgl->sge64[i].phys_addr = sg_dma_address(os_sgl);
+			mfi_sgl->sge64[i].length = cpu_to_le32(sg_dma_len(os_sgl));
+			mfi_sgl->sge64[i].phys_addr = cpu_to_le64(sg_dma_address(os_sgl));
 		}
 	}
 	return sge_count;
@@ -1058,10 +1059,10 @@ megasas_make_sgl_skinny(struct megasas_instance *instance,
 
 	if (sge_count) {
 		scsi_for_each_sg(scp, os_sgl, sge_count, i) {
-			mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
+			mfi_sgl->sge_skinny[i].length = cpu_to_le32(sg_dma_len(os_sgl));
 			mfi_sgl->sge_skinny[i].phys_addr =
-						sg_dma_address(os_sgl);
-			mfi_sgl->sge_skinny[i].flag = 0;
+				cpu_to_le64(sg_dma_address(os_sgl));
+			mfi_sgl->sge_skinny[i].flag = cpu_to_le32(0);
 		}
 	}
 	return sge_count;
@@ -1141,7 +1142,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 {
 	u32 is_logical;
 	u32 device_id;
-	u16 flags = 0;
+	u16 flags = 0, timeout = 0;
 	struct megasas_pthru_frame *pthru;
 
 	is_logical = MEGASAS_IS_LOGICAL(scp);
@@ -1155,10 +1156,6 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	else if (scp->sc_data_direction == PCI_DMA_NONE)
 		flags = MFI_FRAME_DIR_NONE;
 
-	if (instance->flag_ieee == 1) {
-		flags |= MFI_FRAME_IEEE;
-	}
-
 	/*
 	 * Prepare the DCDB frame
 	 */
@@ -1168,10 +1165,8 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	pthru->target_id = device_id;
 	pthru->lun = scp->device->lun;
 	pthru->cdb_len = scp->cmd_len;
-	pthru->timeout = 0;
 	pthru->pad_0 = 0;
-	pthru->flags = flags;
-	pthru->data_xfer_len = scsi_bufflen(scp);
+	pthru->data_xfer_len = cpu_to_le32(scsi_bufflen(scp));
 
 	memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);
 
@@ -1181,36 +1176,42 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	*/
 	if (scp->device->type == TYPE_TAPE) {
 		if ((scp->request->timeout / HZ) > 0xFFFF)
-			pthru->timeout = 0xFFFF;
+			timeout = 0xFFFF;
 		else
-			pthru->timeout = scp->request->timeout / HZ;
+			timeout = scp->request->timeout / HZ;
 	}
 
 	/*
 	 * Construct SGL
 	 */
 	if (instance->flag_ieee == 1) {
-		pthru->flags |= MFI_FRAME_SGL64;
+		flags |= MFI_FRAME_SGL64 | MFI_FRAME_IEEE;
 		pthru->sge_count = megasas_make_sgl_skinny(instance, scp,
 						      &pthru->sgl);
 	} else if (IS_DMA64) {
-		pthru->flags |= MFI_FRAME_SGL64;
+		flags |= MFI_FRAME_SGL64;
 		pthru->sge_count = megasas_make_sgl64(instance, scp,
 						      &pthru->sgl);
 	} else
 		pthru->sge_count = megasas_make_sgl32(instance, scp,
 						      &pthru->sgl);
 
-       if (pthru->sge_count > instance->max_num_sge) {
+	if (pthru->sge_count > instance->max_num_sge) {
         	printk("megasas: build_dcdb error, two many SGE\n");
 	        return 0;
 	}
+
+	pthru->flags = cpu_to_le16(flags);
+	pthru->timeout = cpu_to_le16(timeout);
+
 	/*
 	 * Sense info specific
 	 */
 	pthru->sense_len = SCSI_SENSE_BUFFERSIZE;
-	pthru->sense_buf_phys_addr_hi = 0;
-	pthru->sense_buf_phys_addr_lo = cmd->sense_phys_addr;
+	pthru->sense_buf_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(cmd->sense_phys_addr));
+	pthru->sense_buf_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(cmd->sense_phys_addr));
 
 	/*
 	 * Compute the total number of frames this command consumes. FW uses
@@ -1410,10 +1411,6 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
 		flags = MFI_FRAME_DIR_READ;
 
-	if (instance->flag_ieee == 1) {
-		flags |= MFI_FRAME_IEEE;
-	}
-
 	/*
 	 * Prepare the Logical IO frame: 2nd bit is zero for all read cmds
 	 */
@@ -1421,10 +1418,9 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	ldio->cmd_status = 0x0;
 	ldio->scsi_status = 0x0;
 	ldio->target_id = device_id;
-	ldio->timeout = 0;
+	ldio->timeout = cpu_to_le16(0);
 	ldio->reserved_0 = 0;
 	ldio->pad_0 = 0;
-	ldio->flags = flags;
 	ldio->start_lba_hi = 0;
 	ldio->access_byte = (scp->cmd_len != 6) ? scp->cmnd[1] : 0;
 
@@ -1485,11 +1481,11 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	 * Construct SGL
 	 */
 	if (instance->flag_ieee) {
-		ldio->flags |= MFI_FRAME_SGL64;
+		flags |= MFI_FRAME_SGL64 | MFI_FRAME_IEEE;
 		ldio->sge_count = megasas_make_sgl_skinny(instance, scp,
 					      &ldio->sgl);
 	} else if (IS_DMA64) {
-		ldio->flags |= MFI_FRAME_SGL64;
+		flags |= MFI_FRAME_SGL64;
 		ldio->sge_count = megasas_make_sgl64(instance, scp, &ldio->sgl);
 	} else
 		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);
@@ -1498,12 +1494,20 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
         	printk("megasas: build_ld_io  error, sge_count = %x\n", ldio->sge_count);
 	        return 0;
 	}
+
+	ldio->lba_count = cpu_to_le32(ldio->lba_count);
+	ldio->start_lba_lo = cpu_to_le32(ldio->start_lba_lo);
+	ldio->start_lba_hi = cpu_to_le32(ldio->start_lba_hi);
+	ldio->flags = cpu_to_le16(flags);
+
 	/*
 	 * Sense info specific
 	 */
 	ldio->sense_len = SCSI_SENSE_BUFFERSIZE;
-	ldio->sense_buf_phys_addr_hi = 0;
-	ldio->sense_buf_phys_addr_lo = cmd->sense_phys_addr;
+	ldio->sense_buf_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(cmd->sense_phys_addr));
+	ldio->sense_buf_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(cmd->sense_phys_addr));
 
 	/*
 	 * Compute the total number of frames this command consumes. FW uses
@@ -1580,20 +1584,20 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			ldio = (struct megasas_io_frame *)cmd->frame;
 			mfi_sgl = &ldio->sgl;
 			sgcount = ldio->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no, cmd->frame_count,ldio->cmd,ldio->target_id, ldio->start_lba_lo,ldio->start_lba_hi,ldio->sense_buf_phys_addr_lo,sgcount);
+			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no, cmd->frame_count,ldio->cmd,ldio->target_id,le32_to_cpu(ldio->start_lba_lo),le32_to_cpu(ldio->start_lba_hi),le32_to_cpu(ldio->sense_buf_phys_addr_lo),sgcount);
 		}
 		else {
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no,cmd->frame_count,pthru->cmd,pthru->target_id,pthru->lun,pthru->cdb_len , pthru->data_xfer_len,pthru->sense_buf_phys_addr_lo,sgcount);
+			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",instance->host->host_no,cmd->frame_count,pthru->cmd,pthru->target_id,pthru->lun,pthru->cdb_len,le32_to_cpu(pthru->data_xfer_len),le32_to_cpu(pthru->sense_buf_phys_addr_lo),sgcount);
 		}
 	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
 		for (n = 0; n < sgcount; n++){
 			if (IS_DMA64)
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%08lx ",mfi_sgl->sge64[n].length , (unsigned long)mfi_sgl->sge64[n].phys_addr) ;
+				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%llx ",le32_to_cpu(mfi_sgl->sge64[n].length),le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
 			else
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",mfi_sgl->sge32[n].length , mfi_sgl->sge32[n].phys_addr) ;
+				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",le32_to_cpu(mfi_sgl->sge32[n].length),le32_to_cpu(mfi_sgl->sge32[n].phys_addr)) ;
 			}
 		}
 		printk(KERN_ERR "\n");
@@ -2834,8 +2838,8 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 
 	spin_lock_irqsave(&instance->completion_lock, flags);
 
-	producer = *instance->producer;
-	consumer = *instance->consumer;
+	producer = le32_to_cpu(*instance->producer);
+	consumer = le32_to_cpu(*instance->consumer);
 
 	while (consumer != producer) {
 		context = instance->reply_queue[consumer];
@@ -2854,7 +2858,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 		}
 	}
 
-	*instance->consumer = producer;
+	*instance->consumer = cpu_to_le32(producer);
 
 	spin_unlock_irqrestore(&instance->completion_lock, flags);
 
@@ -2876,7 +2880,7 @@ void megasas_do_ocr(struct megasas_instance *instance)
                (instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
                (instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR))
        {
-               *instance->consumer     = MEGASAS_ADPRESET_INPROG_SIGN;
+               *instance->consumer = cpu_to_le32(MEGASAS_ADPRESET_INPROG_SIGN);
        }
 
 	instance->instancet->disable_intr(instance);
@@ -3366,6 +3370,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 {
 	unsigned long flags;
 	int exception = 0;
+	u32 opcode;
 	struct megasas_header *hdr = &cmd->frame->hdr;
 	struct fusion_context *fusion = instance->ctrl_context;
 
@@ -3470,8 +3475,10 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	case MFI_CMD_SMP:
 	case MFI_CMD_STP:
 	case MFI_CMD_DCMD:
+		opcode = le32_to_cpu(cmd->frame->dcmd.opcode);
+
 		/* Check for LD map update */
-		if ((cmd->frame->dcmd.opcode == MR_DCMD_LD_MAP_GET_INFO) && (cmd->frame->dcmd.mbox.b[1] == 1)) {
+		if ((opcode == MR_DCMD_LD_MAP_GET_INFO) && (cmd->frame->dcmd.mbox.b[1] == 1)) {
 			fusion->fast_path_io = 0;
 			spin_lock_irqsave(instance->host->host_lock, flags);
 			if (cmd->frame->hdr.cmd_status != 0) {
@@ -3495,8 +3502,8 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			spin_unlock_irqrestore(instance->host->host_lock, flags);
 			break;
 		}
-		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
-			cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET) {
+		if (opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
+		    opcode == MR_DCMD_CTRL_EVENT_GET) {
 			spin_lock_irqsave(&poll_aen_lock, flags);
 			megasas_poll_wait_aen = 0;
 			spin_unlock_irqrestore(&poll_aen_lock, flags);
@@ -3505,7 +3512,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		/*
 		 * See if got an event notification
 		 */
-		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_WAIT)
+		if (opcode == MR_DCMD_CTRL_EVENT_WAIT)
 			megasas_service_aen(instance, cmd);
 		else
 			megasas_complete_int_cmd(instance, cmd);
@@ -3761,7 +3768,7 @@ megasas_deplete_reply_queue(struct megasas_instance *instance, u8 alt_status)
                                	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
                                	(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR))
                                	{
-					*instance->consumer	= MEGASAS_ADPRESET_INPROG_SIGN;
+					*instance->consumer = cpu_to_le32(MEGASAS_ADPRESET_INPROG_SIGN);
                        	}
 
 
@@ -4265,6 +4272,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	struct MR_PD_LIST *ci;
 	struct MR_PD_ADDRESS *pd_addr;
 	dma_addr_t ci_h = 0;
+	u32 pd_count;
 
 	cmd = megasas_get_cmd(instance);
 
@@ -4292,13 +4300,15 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = cpu_to_le16(0);
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
-	dcmd->opcode = MR_DCMD_PD_LIST_QUERY;
-	dcmd->sgl.sge32[0].phys_addr = ci_h;
-	dcmd->sgl.sge32[0].length = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
+	dcmd->data_xfer_len =
+		cpu_to_le32(MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_PD_LIST_QUERY);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
+	dcmd->sgl.sge32[0].length =
+		cpu_to_le32(MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST));
 
 	if (!megasas_issue_polled(instance, cmd)) {
 		ret = 0;
@@ -4311,18 +4321,19 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	*/
 
 	pd_addr = ci->addr;
+	pd_count = le32_to_cpu(ci->count);
 
 	if ( ret == 0 &&
-		(ci->count <
+		(pd_count <
 		  (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL))) {
 
 		memset(instance->pd_list, 0,
 			MEGASAS_MAX_PD * sizeof(struct megasas_pd_list));
 
-		for (pd_index = 0; pd_index < ci->count; pd_index++) {
+		for (pd_index = 0; pd_index < pd_count; pd_index++) {
 
 			instance->pd_list[pd_addr->deviceId].tid	=
-							pd_addr->deviceId;
+				le16_to_cpu(pd_addr->deviceId);
 			instance->pd_list[pd_addr->deviceId].driveType	=
 							pd_addr->scsiDevType;
 			instance->pd_list[pd_addr->deviceId].driveState	=
@@ -4357,6 +4368,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	struct megasas_dcmd_frame *dcmd;
 	struct MR_LD_LIST *ci;
 	dma_addr_t ci_h = 0;
+	u32 ld_count;
 
 	cmd = megasas_get_cmd(instance);
 
@@ -4381,12 +4393,12 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
-	dcmd->data_xfer_len = sizeof(struct MR_LD_LIST);
-	dcmd->opcode = MR_DCMD_LD_GET_LIST;
-	dcmd->sgl.sge32[0].phys_addr = ci_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct MR_LD_LIST);
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = cpu_to_le16(0);
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct MR_LD_LIST));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_LD_GET_LIST);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_LD_LIST));
 	dcmd->pad_0  = 0;
 
 	if (!megasas_issue_polled(instance, cmd)) {
@@ -4396,15 +4408,17 @@ megasas_get_ld_list(struct megasas_instance *instance)
 		ret = -1;
 	}
 
+	ld_count = le32_to_cpu(ci->ldCount);
+
 	/*
 	* the following function will get the instance PD LIST.
 	*/
 
-	if ( (ret == 0) && (ci->ldCount <= (MAX_LOGICAL_DRIVES))){
-		instance->CurLdCount = ci->ldCount;
+	if ( (ret == 0) && (ld_count <= (MAX_LOGICAL_DRIVES))){
+		instance->CurLdCount = ld_count;
 		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
 
-		for (ld_index = 0; ld_index < ci->ldCount; ld_index++) {
+		for (ld_index = 0; ld_index < ld_count; ld_index++) {
 			if (ci->ldList[ld_index].state != 0) {
 				ids = ci->ldList[ld_index].ref.targetId;
 				instance->ld_ids[ids] = ci->ldList[ld_index].ref.targetId;
@@ -4465,13 +4479,13 @@ megasas_get_ctrl_info(struct megasas_instance *instance,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0xFF;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = cpu_to_le16(0);
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = sizeof(struct megasas_ctrl_info);
-	dcmd->opcode = MR_DCMD_CTRL_GET_INFO;
-	dcmd->sgl.sge32[0].phys_addr = ci_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct megasas_ctrl_info);
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_ctrl_info));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_GET_INFO);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct megasas_ctrl_info));
 
 	if (!megasas_issue_polled(instance, cmd)) {
 		ret = 0;
@@ -4516,14 +4530,14 @@ static int megasas_check_cpx_support( struct megasas_instance *instance)
 
 
 	dcmd = &cmd->frame->dcmd;
-	dcmd->flags = 0;
-	dcmd->opcode = MR_DCMD_CTRL_MISC_CPX_INIT_DATA_GET;
-	dcmd->data_xfer_len  = sizeof(struct mr_cpx_init_data );
+	dcmd->flags = cpu_to_le16(0);
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_MISC_CPX_INIT_DATA_GET);
+	dcmd->data_xfer_len  = cpu_to_le32(sizeof(struct mr_cpx_init_data));
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status  = 0xff;
 	dcmd->sge_count = 1;
-	dcmd->sgl.sge32[0].phys_addr = cpx_init_data_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct mr_cpx_init_data);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(cpx_init_data_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct mr_cpx_init_data));
 
 	retval = megasas_issue_polled ( instance, cmd );
 	
@@ -4570,9 +4584,9 @@ static int megasas_send_cpx_queue_data( struct megasas_instance *instance )
 
 	//initialize dcmd data
 	dcmd = &cmd->frame->dcmd;
-	dcmd->flags = 0;
-	dcmd->opcode = MR_DCMD_CTRL_MISC_CPX_QUEUE_DATA;
-	dcmd->data_xfer_len  = sizeof( struct mr_cpx_queue_data );
+	dcmd->flags = cpu_to_le16(0);
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_MISC_CPX_QUEUE_DATA);
+	dcmd->data_xfer_len  = cpu_to_le32(sizeof( struct mr_cpx_queue_data));
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status  = 0xff;
 	dcmd->sge_count = 1;
@@ -4683,11 +4697,15 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	memset(initq_info, 0, sizeof(struct megasas_init_queue_info));
 	init_frame->context = context;
 
-	initq_info->reply_queue_entries = instance->max_fw_cmds + 1;
-	initq_info->reply_queue_start_phys_addr_lo = instance->reply_queue_h;
+	initq_info->reply_queue_entries =
+		cpu_to_le32(instance->max_fw_cmds + 1);
+	initq_info->reply_queue_start_phys_addr_lo =
+		cpu_to_le32(instance->reply_queue_h);
 
-	initq_info->producer_index_phys_addr_lo = instance->producer_h;
-	initq_info->consumer_index_phys_addr_lo = instance->consumer_h;
+	initq_info->producer_index_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(instance->producer_h));
+	initq_info->consumer_index_phys_addr_lo =
+		cpu_to_le32(upper_32_bits(instance->consumer_h));
 
 	init_frame->cmd = MFI_CMD_INIT;
 	init_frame->cmd_status = 0xFF;
@@ -4700,9 +4718,12 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 		init_frame->driver_ver_hi = 0;
 	}
 
-	init_frame->queue_info_new_phys_addr_lo = initq_info_h;
-
-	init_frame->data_xfer_len = sizeof(struct megasas_init_queue_info);
+	init_frame->queue_info_new_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(initq_info_h));
+	init_frame->queue_info_new_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(initq_info_h));
+	init_frame->data_xfer_len =
+		cpu_to_le32(sizeof(struct megasas_init_queue_info));
 
 	/*
 	 * disable the intr before firing the init frame to FW
@@ -4736,10 +4757,15 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 
 	reg_set = instance->reg_set;
 
+#if defined(CONFIG_SPARC)
+	instance->max_fw_cmds = 400;
+#else  /* CONFIG_SPARC */
 	/*
 	 * Get various operational parameters from status register
 	 */
 	instance->max_fw_cmds = instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
+#endif	/* CONFIG_SPARC */
+
 	/*
 	 * Reduce the max supported cmds by 1. This is to ensure that the
 	 * reply_q_sz (1 more than the max cmd that driver may send)
@@ -4967,8 +4993,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (ctrl_info && !megasas_get_ctrl_info(instance, ctrl_info)) {
 
 		max_sectors_1 = (1 << ctrl_info->stripe_sz_ops.min) *
-		    ctrl_info->max_strips_per_io;
-		max_sectors_2 = ctrl_info->max_request_size;
+			le16_to_cpu(ctrl_info->max_strips_per_io);
+		max_sectors_2 = le32_to_cpu(ctrl_info->max_request_size);
 
 		tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
 		
@@ -5102,20 +5128,25 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0x0;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
-	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = sizeof(struct megasas_evt_log_info);
-	dcmd->opcode = MR_DCMD_CTRL_EVENT_GET_INFO;
-	dcmd->sgl.sge32[0].phys_addr = el_info_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct megasas_evt_log_info);
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = cpu_to_le16(0);
+	dcmd->pad_0 = cpu_to_le16(0);
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_log_info));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_GET_INFO);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(el_info_h);
+	dcmd->sgl.sge32[0].length =
+		cpu_to_le32(sizeof(struct megasas_evt_log_info));
 
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 
 	/*
 	 * Copy the data back into callers buffer
 	 */
-	memcpy(eli, el_info, sizeof(struct megasas_evt_log_info));
+	eli->newest_seq_num = le32_to_cpu(el_info->newest_seq_num);
+	eli->oldest_seq_num = le32_to_cpu(el_info->oldest_seq_num);
+	eli->clear_seq_num = le32_to_cpu(el_info->clear_seq_num);
+	eli->shutdown_seq_num = le32_to_cpu(el_info->shutdown_seq_num);
+	eli->boot_seq_num = le32_to_cpu(el_info->boot_seq_num);
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
 			    el_info, el_info_h);
@@ -5162,6 +5193,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 	if (instance->aen_cmd) {
 
 		prev_aen.word = instance->aen_cmd->frame->dcmd.mbox.w[1];
+		prev_aen.members.locale = le16_to_cpu(prev_aen.members.locale);
 
 		/*
 		 * A class whose enum value is smaller is inclusive of all
@@ -5219,16 +5251,17 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0x0;
 	dcmd->sge_count = 1;
-	dcmd->flags = MFI_FRAME_DIR_READ;
-	dcmd->timeout = 0;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = cpu_to_le16(0);
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = sizeof(struct megasas_evt_detail);
-	dcmd->opcode = MR_DCMD_CTRL_EVENT_WAIT;
-	dcmd->mbox.w[0] = seq_num;
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct megasas_evt_detail));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_EVENT_WAIT);
+	dcmd->mbox.w[0] = cpu_to_le32(seq_num);
         instance->last_seq_num = seq_num;
-	dcmd->mbox.w[1] = curr_aen.word;
-	dcmd->sgl.sge32[0].phys_addr = (u32) instance->evt_detail_h;
-	dcmd->sgl.sge32[0].length = sizeof(struct megasas_evt_detail);
+	dcmd->mbox.w[1] = cpu_to_le32(curr_aen.word);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->evt_detail_h);
+	dcmd->sgl.sge32[0].length =
+		cpu_to_le32(sizeof(struct megasas_evt_detail));
 
 	if (instance->aen_cmd != NULL) {
 		megasas_return_cmd(instance, cmd);
@@ -5408,6 +5441,14 @@ megasas_set_dma_mask(struct pci_dev *pdev)
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
 			goto fail_set_dma_mask;
 	}
+
+	/*
+	 * Ensure that all data structures are allocated in 32-bit
+	 * memory.
+	 */
+	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)
+		goto fail_set_dma_mask;
+
 	return 0;
 
 fail_set_dma_mask:
@@ -5724,11 +5765,11 @@ static void megasas_flush_cache(struct megasas_instance *instance)
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0x0;
 	dcmd->sge_count = 0;
-	dcmd->flags = MFI_FRAME_DIR_NONE;
-	dcmd->timeout = 0;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_NONE);
+	dcmd->timeout = cpu_to_le16(0);
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = 0;
-	dcmd->opcode = MR_DCMD_CTRL_CACHE_FLUSH;
+	dcmd->data_xfer_len = cpu_to_le32(0);
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_CACHE_FLUSH);
 	dcmd->mbox.b[0] = MR_FLUSH_CTRL_CACHE | MR_FLUSH_DISK_CACHE;
 
 	megasas_issue_blocked_cmd(instance, cmd, 30);
@@ -5768,11 +5809,11 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	dcmd->cmd = MFI_CMD_DCMD;
 	dcmd->cmd_status = 0x0;
 	dcmd->sge_count = 0;
-	dcmd->flags = MFI_FRAME_DIR_NONE;
-	dcmd->timeout = 0;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_NONE);
+	dcmd->timeout = cpu_to_le16(0);
 	dcmd->pad_0 = 0;
-	dcmd->data_xfer_len = 0;
-	dcmd->opcode = opcode;
+	dcmd->data_xfer_len = cpu_to_le32(0);
+	dcmd->opcode = cpu_to_le32(opcode);
 
 	megasas_issue_blocked_cmd(instance, cmd, 30);
 
@@ -6277,7 +6318,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		goto out;
 	}
 
-	if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_IO_METRICS_GET) {
+	if (cmd->frame->dcmd.opcode == le32_to_cpu(MR_DCMD_CTRL_IO_METRICS_GET)) {
 		ProcessPerfMetricRequest(instance , kbuff_arr[0], ioc->sgl[0].iov_len);
 	}
 
@@ -6671,8 +6712,7 @@ megasas_aen_polling(struct work_struct *work)
 	instance->ev = NULL;
 	host = instance->host;
 	if (instance->evt_detail) {
-
-		switch (instance->evt_detail->code) {
+		switch (le32_to_cpu(instance->evt_detail->code)) {
 
 		case MR_EVT_PD_INSERTED:
 			if(megasas_get_pd_list(instance) == 0) {
@@ -6824,7 +6864,7 @@ megasas_aen_polling(struct work_struct *work)
 		}		
 	}
 
-	seq_num = instance->evt_detail->seq_num + 1;
+	seq_num = le32_to_cpu(instance->evt_detail->seq_num + 1);
 
 	/* Register AEN with FW for latest sequence number plus 1 */
 	class_locale.members.reserved = 0;
