From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 2/3] megaraid_sas : use dev_printk when possible
Date: Mon, 01 Jun 2015 10:40:10 -0500
Message-ID: <20150601154010.23309.60670.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33429 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbbFAPkN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 11:40:13 -0400
Received: by igbpi8 with SMTP id pi8so64267307igb.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2015 08:40:12 -0700 (PDT)
In-Reply-To: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use dev_printk() when possible to make messages more useful.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  263 +++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   92 +++++----
 2 files changed, 177 insertions(+), 178 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c54fe6f..a8c512f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -216,7 +216,7 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 				 struct megasas_cmd, list);
 		list_del_init(&cmd->list);
 	} else {
-		printk(KERN_ERR "megasas: Command pool empty!\n");
+		dev_err(&instance->pdev->dev, "Command pool empty!\n");
 	}
 
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
@@ -370,9 +370,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 		msleep(1000); /* sleep for 3 secs */
 	pcidata  = 0;
 	pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
-	printk(KERN_NOTICE "pcidata = %x\n", pcidata);
+	dev_notice(&instance->pdev->dev, "pcidata = %x\n", pcidata);
 	if (pcidata & 0x2) {
-		printk(KERN_NOTICE "mfi 1068 offset read=%x\n", pcidata);
+		dev_notice(&instance->pdev->dev, "mfi 1068 offset read=%x\n", pcidata);
 		pcidata &= ~0x2;
 		pci_write_config_dword(instance->pdev,
 				MFI_1068_PCSR_OFFSET, pcidata);
@@ -383,9 +383,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 		pcidata  = 0;
 		pci_read_config_dword(instance->pdev,
 				MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
-		printk(KERN_NOTICE "1068 offset handshake read=%x\n", pcidata);
+		dev_notice(&instance->pdev->dev, "1068 offset handshake read=%x\n", pcidata);
 		if ((pcidata & 0xffff0000) == MFI_1068_FW_READY) {
-			printk(KERN_NOTICE "1068 offset pcidt=%x\n", pcidata);
+			dev_notice(&instance->pdev->dev, "1068 offset pcidt=%x\n", pcidata);
 			pcidata = 0;
 			pci_write_config_dword(instance->pdev,
 				MFI_1068_FW_HANDSHAKE_OFFSET, pcidata);
@@ -824,7 +824,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
+		dev_notice(&instance->pdev->dev, "RESETGEN2: retry=%x, hostdiag=%x\n",
 					retry, HostDiag);
 
 		if (retry++ >= 100)
@@ -832,7 +832,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 
 	}
 
-	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
+	dev_notice(&instance->pdev->dev, "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
 
 	writel((HostDiag | DIAG_RESET_ADAPTER), hostdiag_offset);
 
@@ -842,7 +842,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
+		dev_notice(&instance->pdev->dev, "RESET_GEN2: retry=%x, hostdiag=%x\n",
 				retry, HostDiag);
 
 		if (retry++ >= 1000)
@@ -1240,7 +1240,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 						      &pthru->sgl);
 
 	if (pthru->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: DCDB two many SGE NUM=%x\n",
+		dev_err(&instance->pdev->dev, "DCDB two many SGE NUM=%x\n",
 			pthru->sge_count);
 		return 0;
 	}
@@ -1381,7 +1381,7 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);
 
 	if (ldio->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: build_ld_io: sge_count = %x\n",
+		dev_err(&instance->pdev->dev, "build_ld_io: sge_count = %x\n",
 			ldio->sge_count);
 		return 0;
 	}
@@ -1448,24 +1448,24 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	u32 sgcount;
 	u32 max_cmd = instance->max_fw_cmds;
 
-	printk(KERN_ERR "\nmegasas[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
-	printk(KERN_ERR "megasas[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
+	dev_err(&instance->pdev->dev, "\nmegasas[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "megasas[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
 	if (IS_DMA64)
-		printk(KERN_ERR "\nmegasas[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
+		dev_err(&instance->pdev->dev, "\nmegasas[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
 	else
-		printk(KERN_ERR "\nmegasas[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);
+		dev_err(&instance->pdev->dev, "\nmegasas[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);
 
-	printk(KERN_ERR "megasas[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "megasas[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if(!cmd->scmd)
 			continue;
-		printk(KERN_ERR "megasas[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
+		dev_err(&instance->pdev->dev, "megasas[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
 		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
 			ldio = (struct megasas_io_frame *)cmd->frame;
 			mfi_sgl = &ldio->sgl;
 			sgcount = ldio->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x,"
+			dev_err(&instance->pdev->dev, "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x,"
 			" lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
 			instance->host->host_no, cmd->frame_count, ldio->cmd, ldio->target_id,
 			le32_to_cpu(ldio->start_lba_lo), le32_to_cpu(ldio->start_lba_hi),
@@ -1475,7 +1475,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
+			dev_err(&instance->pdev->dev, "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
 			"lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
 			instance->host->host_no, cmd->frame_count, pthru->cmd, pthru->target_id,
 			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
@@ -1484,27 +1484,26 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
 		for (n = 0; n < sgcount; n++){
 			if (IS_DMA64)
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%llx ",
+				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
 					le32_to_cpu(mfi_sgl->sge64[n].length),
 					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
 			else
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",
+				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
 					le32_to_cpu(mfi_sgl->sge32[n].length),
 					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 			}
 		}
-		printk(KERN_ERR "\n");
 	} /*for max_cmd*/
-	printk(KERN_ERR "\nmegasas[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "\nmegasas[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 
 		cmd = instance->cmd_list[i];
 
 		if(cmd->sync_cmd == 1){
-			printk(KERN_ERR "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
+			dev_err(&instance->pdev->dev, "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
 		}
 	}
-	printk(KERN_ERR "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
+	dev_err(&instance->pdev->dev, "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
 }
 
 u32
@@ -1622,7 +1621,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	}
 
 	if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
-		printk(KERN_ERR "megasas: Err returned from build_and_issue_cmd\n");
+		dev_err(&instance->pdev->dev, "Err returned from build_and_issue_cmd\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1793,7 +1792,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 	while (consumer != producer) {
 		context = le32_to_cpu(instance->reply_queue[consumer]);
 		if (context >= instance->max_fw_cmds) {
-			printk(KERN_ERR "Unexpected context value %x\n",
+			dev_err(&instance->pdev->dev, "Unexpected context value %x\n",
 				context);
 			BUG();
 		}
@@ -1872,7 +1871,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
 		       "Failed to get cmd for scsi%d.\n",
 			instance->host->host_no);
 		return -ENOMEM;
@@ -1881,7 +1880,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation_111) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Couldn't get LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -1896,7 +1895,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION_111),
 					     &new_affiliation_111_h);
 		if (!new_affiliation_111) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d.\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -1928,13 +1927,13 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length = cpu_to_le32(
 		sizeof(struct MR_LD_VF_AFFILIATION_111));
 
-	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
+	dev_warn(&instance->pdev->dev, "SR-IOV: Getting LD/VF affiliation for "
 	       "scsi%d\n", instance->host->host_no);
 
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
+		dev_warn(&instance->pdev->dev, "SR-IOV: LD/VF affiliation DCMD"
 		       " failed with status 0x%x for scsi%d.\n",
 		       dcmd->cmd_status, instance->host->host_no);
 		retval = 1; /* Do a scan if we couldn't get affiliation */
@@ -1946,7 +1945,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 		for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
 			if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
 			    new_affiliation_111->map[ld].policy[thisVf]) {
-				printk(KERN_WARNING "megasas: SR-IOV: "
+				dev_warn(&instance->pdev->dev, "SR-IOV: "
 				       "Got new LD/VF affiliation "
 				       "for scsi%d.\n",
 				       instance->host->host_no);
@@ -1984,7 +1983,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation12: "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation12: "
 		       "Failed to get cmd for scsi%d.\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -1993,7 +1992,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Couldn't get LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -2009,7 +2008,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION),
 					     &new_affiliation_h);
 		if (!new_affiliation) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d.\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -2041,13 +2040,13 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length = cpu_to_le32((MAX_LOGICAL_DRIVES + 1) *
 		sizeof(struct MR_LD_VF_AFFILIATION));
 
-	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
+	dev_warn(&instance->pdev->dev, "SR-IOV: Getting LD/VF affiliation for "
 	       "scsi%d\n", instance->host->host_no);
 
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
+		dev_warn(&instance->pdev->dev, "SR-IOV: LD/VF affiliation DCMD"
 		       " failed with status 0x%x for scsi%d.\n",
 		       dcmd->cmd_status, instance->host->host_no);
 		retval = 1; /* Do a scan if we couldn't get affiliation */
@@ -2056,7 +2055,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 
 	if (!initial) {
 		if (!new_affiliation->ldCount) {
-			printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+			dev_warn(&instance->pdev->dev, "SR-IOV: Got new LD/VF "
 			       "affiliation for passive path for scsi%d.\n",
 			       instance->host->host_no);
 			retval = 1;
@@ -2122,7 +2121,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	}
 out:
 	if (doscan) {
-		printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Got new LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		memcpy(instance->vf_affiliation, new_affiliation,
 		       new_affiliation->size);
@@ -2163,7 +2162,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_sriov_start_heartbeat: "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_sriov_start_heartbeat: "
 		       "Failed to get cmd for scsi%d.\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -2177,7 +2176,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 					      sizeof(struct MR_CTRL_HB_HOST_MEM),
 					      &instance->hb_host_mem_h);
 		if (!instance->hb_host_mem) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate"
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate"
 			       " memory for heartbeat host memory for "
 			       "scsi%d.\n", instance->host->host_no);
 			retval = -ENOMEM;
@@ -2199,7 +2198,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->hb_host_mem_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_CTRL_HB_HOST_MEM));
 
-	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
+	dev_warn(&instance->pdev->dev, "SR-IOV: Starting heartbeat for scsi%d\n",
 	       instance->host->host_no);
 
 	if (instance->ctrl_context && !instance->mask_interrupts)
@@ -2209,7 +2208,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 		retval = megasas_issue_polled(instance, cmd);
 
 	if (retval) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+		dev_warn(&instance->pdev->dev, "SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
 		       "_MEM_ALLOC DCMD timed out for scsi%d\n",
 		       instance->host->host_no);
 		retval = 1;
@@ -2218,7 +2217,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+		dev_warn(&instance->pdev->dev, "SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
 		       "_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
 		       dcmd->cmd_status,
 		       instance->host->host_no);
@@ -2245,7 +2244,7 @@ void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
 		mod_timer(&instance->sriov_heartbeat_timer,
 			  jiffies + MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
 	} else {
-		printk(KERN_WARNING "megasas: SR-IOV: Heartbeat never "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Heartbeat never "
 		       "completed for scsi%d\n", instance->host->host_no);
 		schedule_work(&instance->work_init);
 	}
@@ -2283,7 +2282,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 				&clist_local);
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_NOTICE "megasas: HBA reset wait ...\n");
+		dev_notice(&instance->pdev->dev, "HBA reset wait ...\n");
 		for (i = 0; i < wait_time; i++) {
 			msleep(1000);
 			spin_lock_irqsave(&instance->hba_lock, flags);
@@ -2294,7 +2293,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		}
 
 		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
-			printk(KERN_NOTICE "megasas: reset: Stopping HBA.\n");
+			dev_notice(&instance->pdev->dev, "reset: Stopping HBA.\n");
 			spin_lock_irqsave(&instance->hba_lock, flags);
 			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
 			spin_unlock_irqrestore(&instance->hba_lock, flags);
@@ -2308,14 +2307,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
 				reset_cmd->scmd->result = DID_RESET << 16;
-				printk(KERN_NOTICE "%d:%p reset [%02x]\n",
+				dev_notice(&instance->pdev->dev, "%d:%p reset [%02x]\n",
 					reset_index, reset_cmd,
 					reset_cmd->scmd->cmnd[0]);
 
 				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
 				megasas_return_cmd(instance, reset_cmd);
 			} else if (reset_cmd->sync_cmd) {
-				printk(KERN_NOTICE "megasas:%p synch cmds"
+				dev_notice(&instance->pdev->dev, "%p synch cmds"
 						"reset queue\n",
 						reset_cmd);
 
@@ -2324,7 +2323,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
 			} else {
-				printk(KERN_NOTICE "megasas: %p unexpected"
+				dev_notice(&instance->pdev->dev, "%p unexpected"
 					"cmds lst\n",
 					reset_cmd);
 			}
@@ -2342,7 +2341,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			break;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
 			       "commands to complete\n",i,outstanding);
 			/*
 			 * Call cmd completion routine. Cmd to be
@@ -2393,7 +2392,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 
 	if (atomic_read(&instance->fw_outstanding) ||
 					(kill_adapter_flag == 2)) {
-		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
+		dev_notice(&instance->pdev->dev, "pending cmds after reset\n");
 		/*
 		* Send signal to FW to stop processing any pending cmds.
 		* The controller will be taken offline by the OS now.
@@ -2415,7 +2414,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		return FAILED;
 	}
 
-	printk(KERN_NOTICE "megaraid_sas: no pending cmds after reset\n");
+	dev_notice(&instance->pdev->dev, "no pending cmds after reset\n");
 
 	return SUCCESS;
 }
@@ -2439,16 +2438,16 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
 		 scmd->cmnd[0], scmd->retries);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_ERR "megasas: cannot recover from previous reset "
+		dev_err(&instance->pdev->dev, "cannot recover from previous reset "
 		       "failures\n");
 		return FAILED;
 	}
 
 	ret_val = megasas_wait_for_outstanding(instance);
 	if (ret_val == SUCCESS)
-		printk(KERN_NOTICE "megasas: reset successful \n");
+		dev_notice(&instance->pdev->dev, "reset successful \n");
 	else
-		printk(KERN_ERR "megasas: failed to do reset\n");
+		dev_err(&instance->pdev->dev, "failed to do reset\n");
 
 	return ret_val;
 }
@@ -2606,7 +2605,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		struct megasas_aen_event *ev;
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
-			printk(KERN_ERR "megasas_service_aen: out of memory\n");
+			dev_err(&instance->pdev->dev, "megasas_service_aen: out of memory\n");
 		} else {
 			ev->instance = instance;
 			instance->ev = ev;
@@ -2860,9 +2859,9 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		   MR_DCMD_CTRL_EVENT_GET_INFO left over from the main kernel
 		   when booting the kdump kernel.  Ignore this command to
 		   prevent a kernel panic on shutdown of the kdump kernel. */
-		printk(KERN_WARNING "megaraid_sas: MFI_CMD_INVALID command "
+		dev_warn(&instance->pdev->dev, "MFI_CMD_INVALID command "
 		       "completed.\n");
-		printk(KERN_WARNING "megaraid_sas: If you have a controller "
+		dev_warn(&instance->pdev->dev, "If you have a controller "
 		       "other than PERC5, please upgrade your firmware.\n");
 		break;
 	case MFI_CMD_PD_SCSI_IO:
@@ -2931,7 +2930,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: MFI FW status %#x\n",
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "MFI FW status %#x\n",
 			       hdr->cmd_status);
 			cmd->scmd->result = DID_ERROR << 16;
 			break;
@@ -2957,7 +2956,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			if (cmd->frame->hdr.cmd_status != 0) {
 				if (cmd->frame->hdr.cmd_status !=
 				    MFI_STAT_NOT_FOUND)
-					printk(KERN_WARNING "megasas: map sync"
+					dev_warn(&instance->pdev->dev, "map sync"
 					       "failed, status = 0x%x.\n",
 					       cmd->frame->hdr.cmd_status);
 				else {
@@ -3010,7 +3009,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		break;
 
 	default:
-		printk("megasas: Unknown command completed! [0x%X]\n",
+		dev_info(&instance->pdev->dev, "Unknown command completed! [0x%X]\n",
 		       hdr->cmd);
 		break;
 	}
@@ -3041,14 +3040,14 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 		list_del_init(&cmd->list);
 
 		if (cmd->sync_cmd || cmd->scmd) {
-			printk(KERN_NOTICE "megaraid_sas: command %p, %p:%d"
+			dev_notice(&instance->pdev->dev, "command %p, %p:%d"
 				"detected to be pending while HBA reset.\n",
 					cmd, cmd->scmd, cmd->sync_cmd);
 
 			cmd->retry_for_fw_reset++;
 
 			if (cmd->retry_for_fw_reset == 3) {
-				printk(KERN_NOTICE "megaraid_sas: cmd %p, %p:%d"
+				dev_notice(&instance->pdev->dev, "cmd %p, %p:%d"
 					"was tried multiple times during reset."
 					"Shutting down the HBA\n",
 					cmd, cmd->scmd, cmd->sync_cmd);
@@ -3061,10 +3060,10 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 
 		if (cmd->sync_cmd == 1) {
 			if (cmd->scmd) {
-				printk(KERN_NOTICE "megaraid_sas: unexpected"
+				dev_notice(&instance->pdev->dev, "unexpected"
 					"cmd attached to internal command!\n");
 			}
-			printk(KERN_NOTICE "megasas: %p synchronous cmd"
+			dev_notice(&instance->pdev->dev, "%p synchronous cmd"
 						"on the internal reset queue,"
 						"issue it again.\n", cmd);
 			cmd->cmd_status = ENODATA;
@@ -3072,7 +3071,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 							cmd->frame_phys_addr ,
 							0, instance->reg_set);
 		} else if (cmd->scmd) {
-			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x]"
+			dev_notice(&instance->pdev->dev, "%p scsi cmd [%02x]"
 			"detected on the internal queue, issue again.\n",
 			cmd, cmd->scmd->cmnd[0]);
 
@@ -3081,14 +3080,14 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 					cmd->frame_phys_addr,
 					cmd->frame_count-1, instance->reg_set);
 		} else {
-			printk(KERN_NOTICE "megasas: %p unexpected cmd on the"
+			dev_notice(&instance->pdev->dev, "%p unexpected cmd on the"
 				"internal reset defer list while re-issue!!\n",
 				cmd);
 		}
 	}
 
 	if (instance->aen_cmd) {
-		printk(KERN_NOTICE "megaraid_sas: aen_cmd in def process\n");
+		dev_notice(&instance->pdev->dev, "aen_cmd in def process\n");
 		megasas_return_cmd(instance, instance->aen_cmd);
 
 		instance->aen_cmd	= NULL;
@@ -3128,12 +3127,12 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if (cmd->sync_cmd == 1 || cmd->scmd) {
-			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
+			dev_notice(&instance->pdev->dev, "moving cmd[%d]:%p:%d:%p"
 					"on the defer queue as internal\n",
 				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
 
 			if (!list_empty(&cmd->list)) {
-				printk(KERN_NOTICE "megaraid_sas: ERROR while"
+				dev_notice(&instance->pdev->dev, "ERROR while"
 					" moving this cmd:%p, %d %p, it was"
 					"discovered on some list?\n",
 					cmd, cmd->sync_cmd, cmd->scmd);
@@ -3158,13 +3157,13 @@ process_fw_state_change_wq(struct work_struct *work)
 	unsigned long flags;
 
 	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
-		printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
+		dev_notice(&instance->pdev->dev, "error, recovery st %x \n",
 				instance->adprecovery);
 		return ;
 	}
 
 	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
-		printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
+		dev_notice(&instance->pdev->dev, "FW detected to be in fault"
 					"state, restarting it...\n");
 
 		instance->instancet->disable_intr(instance);
@@ -3174,10 +3173,10 @@ process_fw_state_change_wq(struct work_struct *work)
 		instance->instancet->adp_reset(instance, instance->reg_set);
 		atomic_set(&instance->fw_reset_no_pci_access, 0 );
 
-		printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
+		dev_notice(&instance->pdev->dev, "FW restarted successfully,"
 					"initiating next stage...\n");
 
-		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
+		dev_notice(&instance->pdev->dev, "HBA recovery state machine,"
 					"state 2 starting...\n");
 
 		/*waitting for about 20 second before start the second init*/
@@ -3186,7 +3185,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		}
 
 		if (megasas_transition_to_ready(instance, 1)) {
-			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
+			dev_notice(&instance->pdev->dev, "adapter not ready\n");
 
 			atomic_set(&instance->fw_reset_no_pci_access, 1);
 			megaraid_sas_kill_hba(instance);
@@ -3251,13 +3250,13 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 				instance->reg_set) & MFI_STATE_MASK;
 
 		if (fw_state != MFI_STATE_FAULT) {
-			printk(KERN_NOTICE "megaraid_sas: fw state:%x\n",
+			dev_notice(&instance->pdev->dev, "fw state:%x\n",
 						fw_state);
 		}
 
 		if ((fw_state == MFI_STATE_FAULT) &&
 				(instance->disableOnlineCtrlReset == 0)) {
-			printk(KERN_NOTICE "megaraid_sas: wait adp restart\n");
+			dev_notice(&instance->pdev->dev, "wait adp restart\n");
 
 			if ((instance->pdev->device ==
 					PCI_DEVICE_ID_LSI_SAS1064R) ||
@@ -3278,14 +3277,14 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 			atomic_set(&instance->fw_outstanding, 0);
 			megasas_internal_reset_defer_cmds(instance);
 
-			printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
+			dev_notice(&instance->pdev->dev, "fwState=%x, stage:%d\n",
 					fw_state, instance->adprecovery);
 
 			schedule_work(&instance->work_init);
 			return IRQ_HANDLED;
 
 		} else {
-			printk(KERN_NOTICE "megasas: fwstate:%x, dis_OCR=%x\n",
+			dev_notice(&instance->pdev->dev, "fwstate:%x, dis_OCR=%x\n",
 				fw_state, instance->disableOnlineCtrlReset);
 		}
 	}
@@ -3335,7 +3334,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 	fw_state = abs_state & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
-		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
+		dev_info(&instance->pdev->dev, "Waiting for FW to come to ready"
 		       " state\n");
 
 	while (fw_state != MFI_STATE_READY) {
@@ -3343,7 +3342,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
-			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW in FAULT state!!\n");
 			if (ocr) {
 				max_wait = MEGASAS_RESET_WAIT_TIME;
 				cur_state = MFI_STATE_FAULT;
@@ -3482,7 +3481,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: Unknown state 0x%x\n",
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Unknown state 0x%x\n",
 			       fw_state);
 			return -ENODEV;
 		}
@@ -3504,7 +3503,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		 * Return error if fw_state hasn't changed after max_wait
 		 */
 		if (curr_abs_state == abs_state) {
-			printk(KERN_DEBUG "FW state [%d] hasn't changed "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW state [%d] hasn't changed "
 			       "in %d secs\n", fw_state, max_wait);
 			return -ENODEV;
 		}
@@ -3512,7 +3511,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		abs_state = curr_abs_state;
 		fw_state = curr_abs_state & MFI_STATE_MASK;
 	}
-	printk(KERN_INFO "megasas: FW now in Ready state\n");
+	dev_info(&instance->pdev->dev, "FW now in Ready state\n");
 
 	return 0;
 }
@@ -3607,7 +3606,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 					instance->pdev, total_sz, 256, 0);
 
 	if (!instance->frame_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup frame pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup frame pool\n");
 		return -ENOMEM;
 	}
 
@@ -3615,7 +3614,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 						   instance->pdev, 128, 4, 0);
 
 	if (!instance->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup sense pool\n");
 
 		pci_pool_destroy(instance->frame_dma_pool);
 		instance->frame_dma_pool = NULL;
@@ -3643,7 +3642,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed \n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool(instance);
 			return -ENOMEM;
 		}
@@ -3721,7 +3720,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
 
 	if (!instance->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -3757,7 +3756,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
 	}
 
@@ -3786,7 +3785,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "(get_pd_list): Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3796,7 +3795,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		  MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for pd_list\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for pd_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3881,7 +3880,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas_get_ld_list: Failed to get cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_list: Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3892,7 +3891,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 				&ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem in get_ld_list\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem in get_ld_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3967,7 +3966,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_WARNING
+		dev_warn(&instance->pdev->dev,
 		       "megasas:(megasas_ld_list_query): Failed to get cmd\n");
 		return -ENOMEM;
 	}
@@ -3978,7 +3977,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 				  sizeof(struct MR_LD_TARGETID_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_WARNING
+		dev_warn(&instance->pdev->dev,
 		       "megasas: Failed to alloc mem for ld_list_query\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -4106,7 +4105,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a free cmd\n");
 		return -ENOMEM;
 	}
 
@@ -4116,7 +4115,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				  sizeof(struct megasas_ctrl_info), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ctrl info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for ctrl info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4282,7 +4281,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	 */
 
 	if (megasas_issue_polled(instance, cmd)) {
-		printk(KERN_ERR "megasas: Failed to init firmware\n");
+		dev_err(&instance->pdev->dev, "Failed to init firmware\n");
 		megasas_return_cmd(instance, cmd);
 		goto fail_fw_init;
 	}
@@ -4355,7 +4354,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 						     &instance->reply_queue_h);
 
 	if (!instance->reply_queue) {
-		printk(KERN_DEBUG "megasas: Out of DMA mem for reply queue\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Out of DMA mem for reply queue\n");
 		goto fail_reply_queue;
 	}
 
@@ -4374,7 +4373,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		(instance->instancet->read_fw_status_reg(reg_set) &
 		0x04000000);
 
-	printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
+	dev_notice(&instance->pdev->dev, "megasas_init_mfi: fw_support_ieee=%d",
 			instance->fw_support_ieee);
 
 	if (instance->fw_support_ieee)
@@ -4518,7 +4517,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
-		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO memory region busy!\n");
 		return -EBUSY;
 	}
 
@@ -4526,7 +4525,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
-		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to map IO mem\n");
 		goto fail_ioremap;
 	}
 
@@ -4564,7 +4563,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			(instance, instance->reg_set);
 		atomic_set(&instance->fw_reset_no_pci_access, 0);
 		dev_info(&instance->pdev->dev,
-			"megasas: FW restarted successfully from %s!\n",
+			"FW restarted successfully from %s!\n",
 			__func__);
 
 		/*waitting for about 30 second before retry*/
@@ -4661,7 +4660,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		goto fail_init_adapter;
 	instance->instancet->enable_intr(instance);
 
-	printk(KERN_ERR "megasas: INIT adapter done\n");
+	dev_err(&instance->pdev->dev, "INIT adapter done\n");
 
 	/** for passthrough
 	* the following function will get the PD LIST.
@@ -4670,7 +4669,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	memset(instance->pd_list, 0 ,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
-		printk(KERN_ERR "megasas: failed to get PD list\n");
+		dev_err(&instance->pdev->dev, "failed to get PD list\n");
 		goto fail_get_pd_list;
 	}
 
@@ -4975,7 +4974,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 								  aen_cmd, 30);
 
 			if (ret_val) {
-				printk(KERN_DEBUG "megasas: Failed to abort "
+				dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to abort "
 				       "previous AEN command\n");
 				return ret_val;
 			}
@@ -5094,7 +5093,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 				(max_sectors <= MEGASAS_MAX_SECTORS)) {
 				instance->max_sectors_per_req = max_sectors;
 			} else {
-			printk(KERN_INFO "megasas: max_sectors should be > 0"
+			dev_info(&instance->pdev->dev, "max_sectors should be > 0"
 				"and <= %d (or < 1MB for GEN2 controller)\n",
 				instance->max_sectors_per_req);
 			}
@@ -5221,7 +5220,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			       sizeof(struct megasas_instance));
 
 	if (!host) {
-		printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");
+		dev_printk(KERN_DEBUG, &pdev->dev, "scsi_host_alloc failed\n");
 		goto fail_alloc_instance;
 	}
 
@@ -5241,7 +5240,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL,
 				instance->ctrl_context_pages);
 		if (!instance->ctrl_context) {
-			printk(KERN_DEBUG "megasas: Failed to allocate "
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
 			       "memory for Fusion context info\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5260,7 +5259,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					     &instance->consumer_h);
 
 		if (!instance->producer || !instance->consumer) {
-			printk(KERN_DEBUG "megasas: Failed to allocate"
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
 			       "memory for producer, consumer\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5291,7 +5290,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						CRASH_DMA_BUF_SIZE,
 						&instance->crash_dump_h);
 	if (!instance->crash_dump_buf)
-		dev_err(&instance->pdev->dev, "Can't allocate Firmware "
+		dev_err(&pdev->dev, "Can't allocate Firmware "
 			"crash dump DMA buffer\n");
 
 	megasas_poll_wait_aen = 0;
@@ -5307,7 +5306,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						    &instance->evt_detail_h);
 
 	if (!instance->evt_detail) {
-		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
+		dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate memory for "
 		       "event detail structure\n");
 		goto fail_alloc_dma_buf;
 	}
@@ -5371,7 +5370,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 				pci_alloc_consistent(pdev, sizeof(struct MR_LD_VF_AFFILIATION_111),
 						     &instance->vf_affiliation_111_h);
 			if (!instance->vf_affiliation_111)
-				printk(KERN_WARNING "megasas: Can't allocate "
+				dev_warn(&pdev->dev, "Can't allocate "
 				       "memory for VF affiliation buffer\n");
 		} else {
 			instance->vf_affiliation =
@@ -5380,7 +5379,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						     sizeof(struct MR_LD_VF_AFFILIATION),
 						     &instance->vf_affiliation_h);
 			if (!instance->vf_affiliation)
-				printk(KERN_WARNING "megasas: Can't allocate "
+				dev_warn(&pdev->dev, "Can't allocate "
 				       "memory for VF affiliation buffer\n");
 		}
 	}
@@ -5414,7 +5413,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance)) {
-		printk(KERN_DEBUG "megasas: start aen failed\n");
+		dev_printk(KERN_DEBUG, &pdev->dev, "start aen failed\n");
 		goto fail_start_aen;
 	}
 
@@ -5622,7 +5621,7 @@ megasas_resume(struct pci_dev *pdev)
 	rval = pci_enable_device_mem(pdev);
 
 	if (rval) {
-		printk(KERN_ERR "megasas: Enable device failed\n");
+		dev_err(&pdev->dev, "Enable device failed\n");
 		return rval;
 	}
 
@@ -5701,7 +5700,7 @@ megasas_resume(struct pci_dev *pdev)
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance))
-		printk(KERN_ERR "megasas: Start AEN failed\n");
+		dev_err(&instance->pdev->dev, "Start AEN failed\n");
 
 	return 0;
 
@@ -5997,14 +5996,14 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
 	if (ioc->sge_count > MAX_IOCTL_SGE) {
-		printk(KERN_DEBUG "megasas: SGE count [%d] >  max limit [%d]\n",
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "SGE count [%d] >  max limit [%d]\n",
 		       ioc->sge_count, MAX_IOCTL_SGE);
 		return -EINVAL;
 	}
 
 	cmd = megasas_get_cmd(instance);
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get a cmd packet\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a cmd packet\n");
 		return -ENOMEM;
 	}
 
@@ -6049,7 +6048,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
-			printk(KERN_DEBUG "megasas: Failed to alloc "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
 			error = -ENOMEM;
 			goto out;
@@ -6123,7 +6122,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 
 		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
 				 sense, ioc->sense_len)) {
-			printk(KERN_ERR "megasas: Failed to copy out to user "
+			dev_err(&instance->pdev->dev, "Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;
 			goto out;
@@ -6135,7 +6134,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 */
 	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
 			 &cmd->frame->hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: Error copying out cmd_status\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error copying out cmd_status\n");
 		error = -EFAULT;
 	}
 
@@ -6195,7 +6194,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	}
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_ERR "Controller in crit error\n");
+		dev_err(&instance->pdev->dev, "Controller in crit error\n");
 		error = -ENODEV;
 		goto out_kfree_ioc;
 	}
@@ -6220,7 +6219,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting"
+			dev_notice(&instance->pdev->dev, "waiting"
 				"for controller reset to finish\n");
 		}
 
@@ -6231,7 +6230,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_ERR "megaraid_sas: timed out while"
+		dev_err(&instance->pdev->dev, "timed out while"
 			"waiting for HBA to recover\n");
 		error = -ENODEV;
 		goto out_up;
@@ -6290,7 +6289,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting for"
+			dev_notice(&instance->pdev->dev, "waiting for"
 				"controller reset to finish\n");
 		}
 
@@ -6300,7 +6299,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		printk(KERN_ERR "megaraid_sas: timed out while waiting"
+		dev_err(&instance->pdev->dev, "timed out while waiting"
 				"for HBA to recover.\n");
 		return -ENODEV;
 	}
@@ -6517,7 +6516,7 @@ megasas_aen_polling(struct work_struct *work)
 		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL)
 			break;
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: %s waiting for "
+			dev_notice(&instance->pdev->dev, "%s waiting for "
 			       "controller reset to finish for scsi%d\n",
 			       __func__, instance->host->host_no);
 		}
@@ -6659,13 +6658,13 @@ megasas_aen_polling(struct work_struct *work)
 			break;
 		}
 	} else {
-		printk(KERN_ERR "invalid evt_detail!\n");
+		dev_err(&instance->pdev->dev, "invalid evt_detail!\n");
 		kfree(ev);
 		return;
 	}
 
 	if (doscan) {
-		printk(KERN_INFO "megaraid_sas: scanning for scsi%d...\n",
+		dev_info(&instance->pdev->dev, "scanning for scsi%d...\n",
 		       instance->host->host_no);
 		if (megasas_get_pd_list(instance) == 0) {
 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
@@ -6737,7 +6736,7 @@ megasas_aen_polling(struct work_struct *work)
 	mutex_unlock(&instance->aen_mutex);
 
 	if (error)
-		printk(KERN_ERR "register aen failed error %x\n", error);
+		dev_err(&instance->pdev->dev, "register aen failed error %x\n", error);
 
 	kfree(ev);
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 32df332..57f9dee 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -221,7 +221,7 @@ static void megasas_teardown_frame_pool_fusion(
 	struct megasas_cmd_fusion *cmd;
 
 	if (!fusion->sg_dma_pool || !fusion->sense_dma_pool) {
-		printk(KERN_ERR "megasas: dma pool is null. SG Pool %p, "
+		dev_err(&instance->pdev->dev, "dma pool is null. SG Pool %p, "
 		       "sense pool : %p\n", fusion->sg_dma_pool,
 		       fusion->sense_dma_pool);
 		return;
@@ -332,7 +332,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 					      total_sz_chain_frame, 4,
 					      0);
 	if (!fusion->sg_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup request pool "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup request pool "
 		       "fusion\n");
 		return -ENOMEM;
 	}
@@ -341,7 +341,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 						 SCSI_SENSE_BUFFERSIZE, 64, 0);
 
 	if (!fusion->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup sense pool "
 		       "fusion\n");
 		pci_pool_destroy(fusion->sg_dma_pool);
 		fusion->sg_dma_pool = NULL;
@@ -366,7 +366,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->sg_frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed\n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool_fusion(instance);
 			return -ENOMEM;
 		}
@@ -412,7 +412,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   &fusion->req_frames_desc_phys, GFP_KERNEL);
 
 	if (!fusion->req_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "request_frames\n");
 		goto fail_req_desc;
 	}
@@ -423,7 +423,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->reply_alloc_sz * count, 16, 0);
 
 	if (!fusion->reply_frames_desc_pool) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "reply_frame pool\n");
 		goto fail_reply_desc;
 	}
@@ -432,7 +432,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->reply_frames_desc_pool, GFP_KERNEL,
 			       &fusion->reply_frames_desc_phys);
 	if (!fusion->reply_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "reply_frame pool\n");
 		pci_pool_destroy(fusion->reply_frames_desc_pool);
 		goto fail_reply_desc;
@@ -449,7 +449,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->io_frames_alloc_sz, 16, 0);
 
 	if (!fusion->io_request_frames_pool) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "io_request_frame pool\n");
 		goto fail_io_frames;
 	}
@@ -458,7 +458,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->io_request_frames_pool, GFP_KERNEL,
 			       &fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "io_request_frames frames\n");
 		pci_pool_destroy(fusion->io_request_frames_pool);
 		goto fail_io_frames;
@@ -473,7 +473,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   * max_cmd, GFP_KERNEL);
 
 	if (!fusion->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory. Could not alloc "
 		       "memory for cmd_list_fusion\n");
 		goto fail_cmd_list;
 	}
@@ -483,7 +483,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		fusion->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd_fusion),
 					      GFP_KERNEL);
 		if (!fusion->cmd_list[i]) {
-			printk(KERN_ERR "Could not alloc cmd list fusion\n");
+			dev_err(&instance->pdev->dev, "Could not alloc cmd list fusion\n");
 
 			for (j = 0; j < i; j++)
 				kfree(fusion->cmd_list[j]);
@@ -527,7 +527,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool_fusion(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error creating frame DMA pool\n");
 		megasas_free_cmds_fusion(instance);
 		goto fail_req_desc;
 	}
@@ -612,7 +612,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_ERR "Could not allocate cmd for INIT Frame\n");
+		dev_err(&instance->pdev->dev, "Could not allocate cmd for INIT Frame\n");
 		ret = 1;
 		goto fail_get_cmd;
 	}
@@ -623,7 +623,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			     &ioc_init_handle, GFP_KERNEL);
 
 	if (!IOCInitMessage) {
-		printk(KERN_ERR "Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "IOCInitMessage\n");
 		ret = 1;
 		goto fail_fw_init;
@@ -713,7 +713,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+	dev_err(&instance->pdev->dev, "Init cmd success\n");
 
 	ret = 0;
 
@@ -756,7 +756,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for map info.\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for map info.\n");
 		return -ENOMEM;
 	}
 
@@ -775,7 +775,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	ci_h = fusion->ld_map_phys[(instance->map_id & 1)];
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ld_map_info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for ld_map_info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -850,7 +850,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for sync"
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for sync"
 		       "info.\n");
 		return -ENOMEM;
 	}
@@ -1096,7 +1096,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 						       &fusion->ld_map_phys[i],
 						       GFP_KERNEL);
 		if (!fusion->ld_map[i]) {
-			printk(KERN_ERR "megasas: Could not allocate memory "
+			dev_err(&instance->pdev->dev, "Could not allocate memory "
 			       "for map info\n");
 			goto fail_map_info;
 		}
@@ -1161,7 +1161,7 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 		cmd->scmd->result = DID_IMM_RETRY << 16;
 		break;
 	default:
-		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
+		dev_printk(KERN_DEBUG, &cmd->instance->pdev->dev, "FW status %#x\n", status);
 		cmd->scmd->result = DID_ERROR << 16;
 		break;
 	}
@@ -1850,7 +1850,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 					&io_request->SGL, cmd);
 
 	if (sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: Error. sge_count (0x%x) exceeds "
+		dev_err(&instance->pdev->dev, "Error. sge_count (0x%x) exceeds "
 		       "max (0x%x) allowed\n", sge_count,
 		       instance->max_num_sge);
 		return 1;
@@ -1884,7 +1884,7 @@ megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 	struct fusion_context *fusion;
 
 	if (index >= instance->max_fw_cmds) {
-		printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
+		dev_err(&instance->pdev->dev, "Invalid SMID (0x%x)request for "
 		       "descriptor for scsi%d\n", index,
 			instance->host->host_no);
 		return NULL;
@@ -1926,7 +1926,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (megasas_build_io_fusion(instance, scmd, cmd)) {
 		megasas_return_cmd_fusion(instance, cmd);
-		printk(KERN_ERR "megasas: Error building command.\n");
+		dev_err(&instance->pdev->dev, "Error building command.\n");
 		cmd->request_desc = NULL;
 		return 1;
 	}
@@ -1936,7 +1936,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (cmd->io_request->ChainOffset != 0 &&
 	    cmd->io_request->ChainOffset != 0xF)
-		printk(KERN_ERR "megasas: The chain offset value is not "
+		dev_err(&instance->pdev->dev, "The chain offset value is not "
 		       "correct : %x\n", cmd->io_request->ChainOffset);
 
 	/*
@@ -2024,7 +2024,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 			if (reply_descript_type ==
 			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
 				if (megasas_dbg_lvl == 5)
-					printk(KERN_ERR "\nmegasas: FAST Path "
+					dev_err(&instance->pdev->dev, "\nFAST Path "
 					       "IO Success\n");
 			}
 			/* Fall thru and complete IO */
@@ -2185,7 +2185,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 			else if (fw_state == MFI_STATE_FAULT)
 				schedule_work(&instance->work_init);
 		} else if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megaraid_sas: Iop2SysDoorbellInt"
+			dev_warn(&instance->pdev->dev, "Iop2SysDoorbellInt"
 			       "for scsi%d\n", instance->host->host_no);
 			schedule_work(&instance->work_init);
 		}
@@ -2268,7 +2268,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	u16 index;
 
 	if (build_mpt_mfi_pass_thru(instance, cmd)) {
-		printk(KERN_ERR "Couldn't build MFI pass thru cmd\n");
+		dev_err(&instance->pdev->dev, "Couldn't build MFI pass thru cmd\n");
 		return NULL;
 	}
 
@@ -2302,7 +2302,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 
 	req_desc = build_mpt_cmd(instance, cmd);
 	if (!req_desc) {
-		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
+		dev_err(&instance->pdev->dev, "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
 	megasas_fire_cmd_fusion(instance, req_desc);
@@ -2412,7 +2412,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		fw_state = instance->instancet->read_fw_status_reg(
 			instance->reg_set) & MFI_STATE_MASK;
 		if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megasas: Found FW in FAULT state,"
+			dev_warn(&instance->pdev->dev, "Found FW in FAULT state,"
 			       " will reset adapter scsi%d.\n",
 				instance->host->host_no);
 			retval = 1;
@@ -2435,7 +2435,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				hb_seconds_missed++;
 				if (hb_seconds_missed ==
 				    (MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF/HZ)) {
-					printk(KERN_WARNING "megasas: SR-IOV:"
+					dev_warn(&instance->pdev->dev, "SR-IOV:"
 					       " Heartbeat never completed "
 					       " while polling during I/O "
 					       " timeout handling for "
@@ -2453,7 +2453,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			goto out;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
 			       "commands to complete for scsi%d\n", i,
 			       outstanding, instance->host->host_no);
 			megasas_complete_cmd_dpc_fusion(
@@ -2463,7 +2463,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	}
 
 	if (atomic_read(&instance->fw_outstanding)) {
-		printk("megaraid_sas: pending commands remain after waiting, "
+		dev_err(&instance->pdev->dev, "pending commands remain after waiting, "
 		       "will reset adapter scsi%d.\n",
 		       instance->host->host_no);
 		retval = 1;
@@ -2563,7 +2563,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	mutex_lock(&instance->reset_mutex);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
+		dev_warn(&instance->pdev->dev, "Hardware critical error, "
 		       "returning FAILED for scsi%d.\n",
 			instance->host->host_no);
 		mutex_unlock(&instance->reset_mutex);
@@ -2617,7 +2617,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	if (megasas_wait_for_outstanding_fusion(instance, iotimeout,
 						&convert)) {
 		instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
-		printk(KERN_WARNING "megaraid_sas: resetting fusion "
+		dev_warn(&instance->pdev->dev, "resetting fusion "
 		       "adapter scsi%d.\n", instance->host->host_no);
 		if (convert)
 			iotimeout = 0;
@@ -2644,7 +2644,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 		if (instance->disableOnlineCtrlReset ||
 		    (abs_state == MFI_STATE_FAULT && !reset_adapter)) {
 			/* Reset not supported, kill adapter */
-			printk(KERN_WARNING "megaraid_sas: Reset not supported"
+			dev_warn(&instance->pdev->dev, "Reset not supported"
 			       ", killing adapter scsi%d.\n",
 				instance->host->host_no);
 			megaraid_sas_kill_hba(instance);
@@ -2662,7 +2662,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			     instance->hb_host_mem->HB.driverCounter)) {
 					instance->hb_host_mem->HB.driverCounter =
 						instance->hb_host_mem->HB.fwCounter;
-					printk(KERN_WARNING "megasas: SR-IOV:"
+					dev_warn(&instance->pdev->dev, "SR-IOV:"
 					       "Late FW heartbeat update for "
 					       "scsi%d.\n",
 					       instance->host->host_no);
@@ -2678,8 +2678,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					abs_state = status_reg &
 						MFI_STATE_MASK;
 					if (abs_state == MFI_STATE_READY) {
-						printk(KERN_WARNING "megasas"
-						       ": SR-IOV: FW was found"
+						dev_warn(&instance->pdev->dev,
+						       "SR-IOV: FW was found"
 						       "to be in ready state "
 						       "for scsi%d.\n",
 						       instance->host->host_no);
@@ -2688,7 +2688,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					msleep(20);
 				}
 				if (abs_state != MFI_STATE_READY) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
+					dev_warn(&instance->pdev->dev, "SR-IOV: "
 					       "FW not in ready state after %d"
 					       " seconds for scsi%d, status_reg = "
 					       "0x%x.\n",
@@ -2730,7 +2730,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 100) {
-					printk(KERN_WARNING "megaraid_sas: "
+					dev_warn(&instance->pdev->dev,
 					       "Host diag unlock failed! "
 					       "for scsi%d\n",
 						instance->host->host_no);
@@ -2753,7 +2753,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 1000) {
-					printk(KERN_WARNING "megaraid_sas: "
+					dev_warn(&instance->pdev->dev,
 					       "Diag reset adapter never "
 					       "cleared for scsi%d!\n",
 						instance->host->host_no);
@@ -2776,7 +2776,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					instance->reg_set) & MFI_STATE_MASK;
 			}
 			if (abs_state <= MFI_STATE_FW_INIT) {
-				printk(KERN_WARNING "megaraid_sas: firmware "
+				dev_warn(&instance->pdev->dev, "firmware "
 				       "state < MFI_STATE_FW_INIT, state = "
 				       "0x%x for scsi%d\n", abs_state,
 					instance->host->host_no);
@@ -2785,7 +2785,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 
 			/* Wait for FW to become ready */
 			if (megasas_transition_to_ready(instance, 1)) {
-				printk(KERN_WARNING "megaraid_sas: Failed to "
+				dev_warn(&instance->pdev->dev, "Failed to "
 				       "transition controller to ready "
 				       "for scsi%d.\n",
 				       instance->host->host_no);
@@ -2794,7 +2794,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 
 			megasas_reset_reply_desc(instance);
 			if (megasas_ioc_init_fusion(instance)) {
-				printk(KERN_WARNING "megaraid_sas: "
+				dev_warn(&instance->pdev->dev,
 				       "megasas_ioc_init_fusion() failed!"
 				       " for scsi%d\n",
 				       instance->host->host_no);
@@ -2835,7 +2835,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			}
 
 			/* Adapter reset completed successfully */
-			printk(KERN_WARNING "megaraid_sas: Reset "
+			dev_warn(&instance->pdev->dev, "Reset "
 			       "successful for scsi%d.\n",
 				instance->host->host_no);
 
@@ -2851,7 +2851,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			goto out;
 		}
 		/* Reset failed, kill the adapter */
-		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
+		dev_warn(&instance->pdev->dev, "Reset failed, killing "
 		       "adapter scsi%d.\n", instance->host->host_no);
 		megaraid_sas_kill_hba(instance);
 		instance->skip_heartbeat_timer_del = 1;

