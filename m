From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/3] megaraid_sas: use dev_printk when possible
Date: Tue, 28 Apr 2015 18:14:11 -0500
Message-ID: <20150428231411.10378.44047.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use dev_printk() when possible to make messages more useful.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |  281 ++++++++++++++---------------
 1 file changed, 139 insertions(+), 142 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..9ef6631 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -217,7 +217,7 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		list_del_init(&cmd->list);
 		atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_DETACHED);
 	} else {
-		printk(KERN_ERR "megasas: Command pool empty!\n");
+		dev_err(&instance->pdev->dev, "Command pool empty!\n");
 	}
 
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
@@ -382,9 +382,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
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
@@ -395,9 +395,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
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
@@ -836,7 +836,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
+		dev_notice(&instance->pdev->dev, "RESETGEN2: retry=%x, hostdiag=%x\n",
 					retry, HostDiag);
 
 		if (retry++ >= 100)
@@ -844,7 +844,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 
 	}
 
-	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
+	dev_notice(&instance->pdev->dev, "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
 
 	writel((HostDiag | DIAG_RESET_ADAPTER), hostdiag_offset);
 
@@ -854,7 +854,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
+		dev_notice(&instance->pdev->dev, "RESET_GEN2: retry=%x, hostdiag=%x\n",
 				retry, HostDiag);
 
 		if (retry++ >= 1000)
@@ -1253,7 +1253,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 						      &pthru->sgl);
 
 	if (pthru->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: DCDB two many SGE NUM=%x\n",
+		dev_err(&instance->pdev->dev, "DCDB two many SGE NUM=%x\n",
 			pthru->sge_count);
 		return 0;
 	}
@@ -1394,7 +1394,7 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);
 
 	if (ldio->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: build_ld_io: sge_count = %x\n",
+		dev_err(&instance->pdev->dev, "build_ld_io: sge_count = %x\n",
 			ldio->sge_count);
 		return 0;
 	}
@@ -1461,24 +1461,24 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
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
@@ -1488,7 +1488,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
+			dev_err(&instance->pdev->dev, "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
 			"lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
 			instance->host->host_no, cmd->frame_count, pthru->cmd, pthru->target_id,
 			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
@@ -1497,27 +1497,27 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
 		for (n = 0; n < sgcount; n++){
 			if (IS_DMA64)
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%llx ",
+				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx ",
 					le32_to_cpu(mfi_sgl->sge64[n].length),
 					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
 			else
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",
+				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x ",
 					le32_to_cpu(mfi_sgl->sge32[n].length),
 					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 			}
 		}
-		printk(KERN_ERR "\n");
+		dev_err(&instance->pdev->dev, "\n");
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
@@ -1635,7 +1635,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	}
 
 	if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
-		printk(KERN_ERR "megasas: Err returned from build_and_issue_cmd\n");
+		dev_err(&instance->pdev->dev, "Err returned from build_and_issue_cmd\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1806,7 +1806,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 	while (consumer != producer) {
 		context = le32_to_cpu(instance->reply_queue[consumer]);
 		if (context >= instance->max_fw_cmds) {
-			printk(KERN_ERR "Unexpected context value %x\n",
+			dev_err(&instance->pdev->dev, "Unexpected context value %x\n",
 				context);
 			BUG();
 		}
@@ -1885,7 +1885,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
 		       "Failed to get cmd for scsi%d.\n",
 			instance->host->host_no);
 		return -ENOMEM;
@@ -1894,7 +1894,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation_111) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Couldn't get LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -1909,7 +1909,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION_111),
 					     &new_affiliation_111_h);
 		if (!new_affiliation_111) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d.\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -1939,13 +1939,13 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length =
 		sizeof(struct MR_LD_VF_AFFILIATION_111);
 
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
@@ -1957,7 +1957,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 		for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
 			if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
 			    new_affiliation_111->map[ld].policy[thisVf]) {
-				printk(KERN_WARNING "megasas: SR-IOV: "
+				dev_warn(&instance->pdev->dev, "SR-IOV: "
 				       "Got new LD/VF affiliation "
 				       "for scsi%d.\n",
 				       instance->host->host_no);
@@ -1999,7 +1999,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation12: "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation12: "
 		       "Failed to get cmd for scsi%d.\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -2008,7 +2008,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Couldn't get LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -2024,7 +2024,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION),
 					     &new_affiliation_h);
 		if (!new_affiliation) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d.\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -2054,13 +2054,13 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
 		sizeof(struct MR_LD_VF_AFFILIATION);
 
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
@@ -2069,7 +2069,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 
 	if (!initial) {
 		if (!new_affiliation->ldCount) {
-			printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+			dev_warn(&instance->pdev->dev, "SR-IOV: Got new LD/VF "
 			       "affiliation for passive path for scsi%d.\n",
 			       instance->host->host_no);
 			retval = 1;
@@ -2135,7 +2135,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	}
 out:
 	if (doscan) {
-		printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Got new LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		memcpy(instance->vf_affiliation, new_affiliation,
 		       new_affiliation->size);
@@ -2180,7 +2180,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_sriov_start_heartbeat: "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_sriov_start_heartbeat: "
 		       "Failed to get cmd for scsi%d.\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -2194,7 +2194,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 					      sizeof(struct MR_CTRL_HB_HOST_MEM),
 					      &instance->hb_host_mem_h);
 		if (!instance->hb_host_mem) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate"
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate"
 			       " memory for heartbeat host memory for "
 			       "scsi%d.\n", instance->host->host_no);
 			retval = -ENOMEM;
@@ -2216,13 +2216,13 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].phys_addr = instance->hb_host_mem_h;
 	dcmd->sgl.sge32[0].length = sizeof(struct MR_CTRL_HB_HOST_MEM);
 
-	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
+	dev_warn(&instance->pdev->dev, "SR-IOV: Starting heartbeat for scsi%d\n",
 	       instance->host->host_no);
 
 	if (!megasas_issue_polled(instance, cmd)) {
 		retval = 0;
 	} else {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+		dev_warn(&instance->pdev->dev, "SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
 		       "_MEM_ALLOC DCMD timed out for scsi%d\n",
 		       instance->host->host_no);
 		retval = 1;
@@ -2231,7 +2231,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+		dev_warn(&instance->pdev->dev, "SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
 		       "_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
 		       dcmd->cmd_status,
 		       instance->host->host_no);
@@ -2258,7 +2258,7 @@ void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
 		mod_timer(&instance->sriov_heartbeat_timer,
 			  jiffies + MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
 	} else {
-		printk(KERN_WARNING "megasas: SR-IOV: Heartbeat never "
+		dev_warn(&instance->pdev->dev, "SR-IOV: Heartbeat never "
 		       "completed for scsi%d\n", instance->host->host_no);
 		schedule_work(&instance->work_init);
 	}
@@ -2296,7 +2296,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 				&clist_local);
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_NOTICE "megasas: HBA reset wait ...\n");
+		dev_notice(&instance->pdev->dev, "HBA reset wait ...\n");
 		for (i = 0; i < wait_time; i++) {
 			msleep(1000);
 			spin_lock_irqsave(&instance->hba_lock, flags);
@@ -2307,7 +2307,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		}
 
 		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
-			printk(KERN_NOTICE "megasas: reset: Stopping HBA.\n");
+			dev_notice(&instance->pdev->dev, "reset: Stopping HBA.\n");
 			spin_lock_irqsave(&instance->hba_lock, flags);
 			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
 			spin_unlock_irqrestore(&instance->hba_lock, flags);
@@ -2321,14 +2321,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
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
 
@@ -2337,7 +2337,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
 			} else {
-				printk(KERN_NOTICE "megasas: %p unexpected"
+				dev_notice(&instance->pdev->dev, "%p unexpected"
 					"cmds lst\n",
 					reset_cmd);
 			}
@@ -2355,7 +2355,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			break;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
 			       "commands to complete\n",i,outstanding);
 			/*
 			 * Call cmd completion routine. Cmd to be
@@ -2406,7 +2406,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 
 	if (atomic_read(&instance->fw_outstanding) ||
 					(kill_adapter_flag == 2)) {
-		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
+		dev_notice(&instance->pdev->dev, "pending cmds after reset\n");
 		/*
 		* Send signal to FW to stop processing any pending cmds.
 		* The controller will be taken offline by the OS now.
@@ -2428,7 +2428,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		return FAILED;
 	}
 
-	printk(KERN_NOTICE "megaraid_sas: no pending cmds after reset\n");
+	dev_notice(&instance->pdev->dev, "no pending cmds after reset\n");
 
 	return SUCCESS;
 }
@@ -2452,16 +2452,16 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
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
@@ -2623,7 +2623,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		struct megasas_aen_event *ev;
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
-			printk(KERN_ERR "megasas_service_aen: out of memory\n");
+			dev_err(&instance->pdev->dev, "megasas_service_aen: out of memory\n");
 		} else {
 			ev->instance = instance;
 			instance->ev = ev;
@@ -2877,9 +2877,9 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
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
@@ -2948,7 +2948,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: MFI FW status %#x\n",
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "MFI FW status %#x\n",
 			       hdr->cmd_status);
 			cmd->scmd->result = DID_ERROR << 16;
 			break;
@@ -2974,7 +2974,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			if (cmd->frame->hdr.cmd_status != 0) {
 				if (cmd->frame->hdr.cmd_status !=
 				    MFI_STAT_NOT_FOUND)
-					printk(KERN_WARNING "megasas: map sync"
+					dev_warn(&instance->pdev->dev, "map sync"
 					       "failed, status = 0x%x.\n",
 					       cmd->frame->hdr.cmd_status);
 				else {
@@ -3029,7 +3029,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		break;
 
 	default:
-		printk("megasas: Unknown command completed! [0x%X]\n",
+		dev_info(&instance->pdev->dev, "Unknown command completed! [0x%X]\n",
 		       hdr->cmd);
 		break;
 	}
@@ -3060,14 +3060,14 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
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
@@ -3080,10 +3080,10 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 
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
@@ -3091,7 +3091,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 							cmd->frame_phys_addr ,
 							0, instance->reg_set);
 		} else if (cmd->scmd) {
-			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x]"
+			dev_notice(&instance->pdev->dev, "%p scsi cmd [%02x]"
 			"detected on the internal queue, issue again.\n",
 			cmd, cmd->scmd->cmnd[0]);
 
@@ -3100,14 +3100,14 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
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
@@ -3147,12 +3147,12 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
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
@@ -3177,13 +3177,13 @@ process_fw_state_change_wq(struct work_struct *work)
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
@@ -3193,10 +3193,10 @@ process_fw_state_change_wq(struct work_struct *work)
 		instance->instancet->adp_reset(instance, instance->reg_set);
 		atomic_set(&instance->fw_reset_no_pci_access, 0 );
 
-		printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
+		dev_notice(&instance->pdev->dev, "FW restarted successfully,"
 					"initiating next stage...\n");
 
-		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
+		dev_notice(&instance->pdev->dev, "HBA recovery state machine,"
 					"state 2 starting...\n");
 
 		/*waitting for about 20 second before start the second init*/
@@ -3205,7 +3205,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		}
 
 		if (megasas_transition_to_ready(instance, 1)) {
-			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
+			dev_notice(&instance->pdev->dev, "adapter not ready\n");
 
 			atomic_set(&instance->fw_reset_no_pci_access, 1);
 			megaraid_sas_kill_hba(instance);
@@ -3270,13 +3270,13 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
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
@@ -3297,14 +3297,14 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
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
@@ -3354,7 +3354,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 	fw_state = abs_state & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
-		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
+		dev_info(&instance->pdev->dev, "Waiting for FW to come to ready"
 		       " state\n");
 
 	while (fw_state != MFI_STATE_READY) {
@@ -3362,7 +3362,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
-			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW in FAULT state!!\n");
 			if (ocr) {
 				max_wait = MEGASAS_RESET_WAIT_TIME;
 				cur_state = MFI_STATE_FAULT;
@@ -3501,7 +3501,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: Unknown state 0x%x\n",
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Unknown state 0x%x\n",
 			       fw_state);
 			return -ENODEV;
 		}
@@ -3523,7 +3523,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		 * Return error if fw_state hasn't changed after max_wait
 		 */
 		if (curr_abs_state == abs_state) {
-			printk(KERN_DEBUG "FW state [%d] hasn't changed "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW state [%d] hasn't changed "
 			       "in %d secs\n", fw_state, max_wait);
 			return -ENODEV;
 		}
@@ -3531,7 +3531,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		abs_state = curr_abs_state;
 		fw_state = curr_abs_state & MFI_STATE_MASK;
 	}
-	printk(KERN_INFO "megasas: FW now in Ready state\n");
+	dev_info(&instance->pdev->dev, "FW now in Ready state\n");
 
 	return 0;
 }
@@ -3626,7 +3626,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 					instance->pdev, total_sz, 256, 0);
 
 	if (!instance->frame_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup frame pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup frame pool\n");
 		return -ENOMEM;
 	}
 
@@ -3634,7 +3634,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 						   instance->pdev, 128, 4, 0);
 
 	if (!instance->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup sense pool\n");
 
 		pci_pool_destroy(instance->frame_dma_pool);
 		instance->frame_dma_pool = NULL;
@@ -3662,7 +3662,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed \n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool(instance);
 			return -ENOMEM;
 		}
@@ -3740,7 +3740,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
 
 	if (!instance->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -3777,7 +3777,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
 	}
 
@@ -3806,7 +3806,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "(get_pd_list): Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3816,7 +3816,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		  MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for pd_list\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for pd_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3905,7 +3905,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas_get_ld_list: Failed to get cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_list: Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3916,7 +3916,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 				&ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem in get_ld_list\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem in get_ld_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3995,7 +3995,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_WARNING
+		dev_warn(&instance->pdev->dev,
 		       "megasas:(megasas_ld_list_query): Failed to get cmd\n");
 		return -ENOMEM;
 	}
@@ -4006,7 +4006,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 				  sizeof(struct MR_LD_TARGETID_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_WARNING
+		dev_warn(&instance->pdev->dev,
 		       "megasas: Failed to alloc mem for ld_list_query\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
@@ -4139,7 +4139,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a free cmd\n");
 		return -ENOMEM;
 	}
 
@@ -4149,7 +4149,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				  sizeof(struct megasas_ctrl_info), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ctrl info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for ctrl info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4318,7 +4318,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	 */
 
 	if (megasas_issue_polled(instance, cmd)) {
-		printk(KERN_ERR "megasas: Failed to init firmware\n");
+		dev_err(&instance->pdev->dev, "Failed to init firmware\n");
 		megasas_return_cmd(instance, cmd);
 		goto fail_fw_init;
 	}
@@ -4376,7 +4376,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 						     &instance->reply_queue_h);
 
 	if (!instance->reply_queue) {
-		printk(KERN_DEBUG "megasas: Out of DMA mem for reply queue\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Out of DMA mem for reply queue\n");
 		goto fail_reply_queue;
 	}
 
@@ -4395,7 +4395,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		(instance->instancet->read_fw_status_reg(reg_set) &
 		0x04000000);
 
-	printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
+	dev_notice(&instance->pdev->dev, "megasas_init_mfi: fw_support_ieee=%d",
 			instance->fw_support_ieee);
 
 	if (instance->fw_support_ieee)
@@ -4438,7 +4438,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
-		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO memory region busy!\n");
 		return -EBUSY;
 	}
 
@@ -4446,7 +4446,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
-		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to map IO mem\n");
 		goto fail_ioremap;
 	}
 
@@ -4484,7 +4484,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			(instance, instance->reg_set);
 		atomic_set(&instance->fw_reset_no_pci_access, 0);
 		dev_info(&instance->pdev->dev,
-			"megasas: FW restarted successfully from %s!\n",
+			"FW restarted successfully from %s!\n",
 			__func__);
 
 		/*waitting for about 30 second before retry*/
@@ -4574,7 +4574,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
-	printk(KERN_ERR "megasas: INIT adapter done\n");
+	dev_err(&instance->pdev->dev, "INIT adapter done\n");
 
 	/** for passthrough
 	* the following function will get the PD LIST.
@@ -4583,7 +4583,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	memset(instance->pd_list, 0 ,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
-		printk(KERN_ERR "megasas: failed to get PD list\n");
+		dev_err(&instance->pdev->dev, "failed to get PD list\n");
 		goto fail_init_adapter;
 	}
 
@@ -4910,7 +4910,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 								  aen_cmd, 30);
 
 			if (ret_val) {
-				printk(KERN_DEBUG "megasas: Failed to abort "
+				dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to abort "
 				       "previous AEN command\n");
 				return ret_val;
 			}
@@ -5028,7 +5028,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 				(max_sectors <= MEGASAS_MAX_SECTORS)) {
 				instance->max_sectors_per_req = max_sectors;
 			} else {
-			printk(KERN_INFO "megasas: max_sectors should be > 0"
+			dev_info(&instance->pdev->dev, "max_sectors should be > 0"
 				"and <= %d (or < 1MB for GEN2 controller)\n",
 				instance->max_sectors_per_req);
 			}
@@ -5055,7 +5055,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	 * Notify the mid-layer about the new controller
 	 */
 	if (scsi_add_host(host, &instance->pdev->dev)) {
-		printk(KERN_DEBUG "megasas: scsi_add_host failed\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "scsi_add_host failed\n");
 		return -ENODEV;
 	}
 
@@ -5131,13 +5131,10 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	/*
 	 * Announce PCI information
 	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
+	dev_info(&pdev->dev, "%#4.04x:%#4.04x:%#4.04x:%#4.04x\n",
 	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
 	       pdev->subsystem_device);
 
-	printk("bus %d:slot %d:func %d\n",
-	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
-
 	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
 	 */
@@ -5156,7 +5153,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			       sizeof(struct megasas_instance));
 
 	if (!host) {
-		printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");
+		dev_printk(KERN_DEBUG, &pdev->dev, "scsi_host_alloc failed\n");
 		goto fail_alloc_instance;
 	}
 
@@ -5176,7 +5173,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL,
 				instance->ctrl_context_pages);
 		if (!instance->ctrl_context) {
-			printk(KERN_DEBUG "megasas: Failed to allocate "
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
 			       "memory for Fusion context info\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5197,7 +5194,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					     &instance->consumer_h);
 
 		if (!instance->producer || !instance->consumer) {
-			printk(KERN_DEBUG "megasas: Failed to allocate"
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
 			       "memory for producer, consumer\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5221,7 +5218,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						CRASH_DMA_BUF_SIZE,
 						&instance->crash_dump_h);
 	if (!instance->crash_dump_buf)
-		dev_err(&instance->pdev->dev, "Can't allocate Firmware "
+		dev_err(&pdev->dev, "Can't allocate Firmware "
 			"crash dump DMA buffer\n");
 
 	megasas_poll_wait_aen = 0;
@@ -5237,7 +5234,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						    &instance->evt_detail_h);
 
 	if (!instance->evt_detail) {
-		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
+		dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate memory for "
 		       "event detail structure\n");
 		goto fail_alloc_dma_buf;
 	}
@@ -5301,7 +5298,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 				pci_alloc_consistent(pdev, sizeof(struct MR_LD_VF_AFFILIATION_111),
 						     &instance->vf_affiliation_111_h);
 			if (!instance->vf_affiliation_111)
-				printk(KERN_WARNING "megasas: Can't allocate "
+				dev_warn(&pdev->dev, "Can't allocate "
 				       "memory for VF affiliation buffer\n");
 		} else {
 			instance->vf_affiliation =
@@ -5310,7 +5307,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						     sizeof(struct MR_LD_VF_AFFILIATION),
 						     &instance->vf_affiliation_h);
 			if (!instance->vf_affiliation)
-				printk(KERN_WARNING "megasas: Can't allocate "
+				dev_warn(&pdev->dev, "Can't allocate "
 				       "memory for VF affiliation buffer\n");
 		}
 	}
@@ -5328,7 +5325,7 @@ retry_irq_register:
 					instance->instancet->service_isr, 0,
 					"megasas",
 					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
+				dev_printk(KERN_DEBUG, &pdev->dev, "Failed to "
 				       "register IRQ for vector %d.\n", i);
 				for (j = 0; j < i; j++) {
 					if (smp_affinity_enable)
@@ -5345,7 +5342,7 @@ retry_irq_register:
 			if (smp_affinity_enable) {
 				if (irq_set_affinity_hint(instance->msixentry[i].vector,
 					get_cpu_mask(cpu)))
-					dev_err(&instance->pdev->dev,
+					dev_err(&pdev->dev,
 						"Error setting affinity hint "
 						"for cpu %d\n", cpu);
 				cpu = cpumask_next(cpu, cpu_online_mask);
@@ -5357,7 +5354,7 @@ retry_irq_register:
 		if (request_irq(pdev->irq, instance->instancet->service_isr,
 				IRQF_SHARED, "megasas",
 				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to register IRQ\n");
 			goto fail_irq;
 		}
 	}
@@ -5393,7 +5390,7 @@ retry_irq_register:
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance)) {
-		printk(KERN_DEBUG "megasas: start aen failed\n");
+		dev_printk(KERN_DEBUG, &pdev->dev, "start aen failed\n");
 		goto fail_start_aen;
 	}
 
@@ -5627,7 +5624,7 @@ megasas_resume(struct pci_dev *pdev)
 	rval = pci_enable_device_mem(pdev);
 
 	if (rval) {
-		printk(KERN_ERR "megasas: Enable device failed\n");
+		dev_err(&pdev->dev, "Enable device failed\n");
 		return rval;
 	}
 
@@ -5693,7 +5690,7 @@ megasas_resume(struct pci_dev *pdev)
 					instance->instancet->service_isr, 0,
 					"megasas",
 					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
+				dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to "
 				       "register IRQ for vector %d.\n", i);
 				for (j = 0; j < i; j++) {
 					if (smp_affinity_enable)
@@ -5721,7 +5718,7 @@ megasas_resume(struct pci_dev *pdev)
 		if (request_irq(pdev->irq, instance->instancet->service_isr,
 				IRQF_SHARED, "megasas",
 				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to register IRQ\n");
 			goto fail_irq;
 		}
 	}
@@ -5744,7 +5741,7 @@ megasas_resume(struct pci_dev *pdev)
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance))
-		printk(KERN_ERR "megasas: Start AEN failed\n");
+		dev_err(&instance->pdev->dev, "Start AEN failed\n");
 
 	return 0;
 
@@ -6054,14 +6051,14 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
 
@@ -6106,7 +6103,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
-			printk(KERN_DEBUG "megasas: Failed to alloc "
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
 			error = -ENOMEM;
 			goto out;
@@ -6180,7 +6177,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 
 		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
 				 sense, ioc->sense_len)) {
-			printk(KERN_ERR "megasas: Failed to copy out to user "
+			dev_err(&instance->pdev->dev, "Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;
 			goto out;
@@ -6192,7 +6189,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 */
 	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
 			 &cmd->frame->hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: Error copying out cmd_status\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error copying out cmd_status\n");
 		error = -EFAULT;
 	}
 
@@ -6256,7 +6253,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	}
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_ERR "Controller in crit error\n");
+		dev_err(&instance->pdev->dev, "Controller in crit error\n");
 		error = -ENODEV;
 		goto out_kfree_ioc;
 	}
@@ -6281,7 +6278,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting"
+			dev_notice(&instance->pdev->dev, "waiting"
 				"for controller reset to finish\n");
 		}
 
@@ -6292,7 +6289,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_ERR "megaraid_sas: timed out while"
+		dev_err(&instance->pdev->dev, "timed out while"
 			"waiting for HBA to recover\n");
 		error = -ENODEV;
 		goto out_up;
@@ -6351,7 +6348,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting for"
+			dev_notice(&instance->pdev->dev, "waiting for"
 				"controller reset to finish\n");
 		}
 
@@ -6361,7 +6358,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		printk(KERN_ERR "megaraid_sas: timed out while waiting"
+		dev_err(&instance->pdev->dev, "timed out while waiting"
 				"for HBA to recover.\n");
 		return -ENODEV;
 	}
@@ -6569,7 +6566,7 @@ megasas_aen_polling(struct work_struct *work)
 		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL)
 			break;
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: %s waiting for "
+			dev_notice(&instance->pdev->dev, "%s waiting for "
 			       "controller reset to finish for scsi%d\n",
 			       __func__, instance->host->host_no);
 		}
@@ -6711,13 +6708,13 @@ megasas_aen_polling(struct work_struct *work)
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
@@ -6789,7 +6786,7 @@ megasas_aen_polling(struct work_struct *work)
 	mutex_unlock(&instance->aen_mutex);
 
 	if (error)
-		printk(KERN_ERR "register aen failed error %x\n", error);
+		dev_err(&instance->pdev->dev, "register aen failed error %x\n", error);
 
 	kfree(ev);
 }
