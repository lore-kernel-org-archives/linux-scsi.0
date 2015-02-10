From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 10 Feb 2015 10:38:13 -0800
Message-ID: <1423593493.15343.1.camel@perches.com>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
	 <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
	 <1423587337.8339.3.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423587337.8339.3.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert printks to pr_<level>

Miscellaneous:

o Coalesce formats
  Add and remove spaces where appropriate when coalescing
o Add pr_fmt
o Remove embedded prefixes
o Convert embedded function names to "%s:", __func__
o Realign arguments
o Outdent one block that was inappropriately indented
o Use pr_cont where appropriate

Signed-off-by: Joe Perches <joe@perches.com>
---

Maybe this patch instead:

 drivers/scsi/megaraid/megaraid_sas_base.c   | 484 ++++++++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  13 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 181 ++++-------
 3 files changed, 291 insertions(+), 387 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..263b209 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -31,6 +31,8 @@
  *  San Jose, California 95131
  */
 
+#define pr_fmt(fmt) "megasas: " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -217,7 +219,7 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		list_del_init(&cmd->list);
 		atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_DETACHED);
 	} else {
-		printk(KERN_ERR "megasas: Command pool empty!\n");
+		pr_err("Command pool empty!\n");
 	}
 
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
@@ -382,9 +384,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 		msleep(1000); /* sleep for 3 secs */
 	pcidata  = 0;
 	pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
-	printk(KERN_NOTICE "pcidata = %x\n", pcidata);
+	pr_notice("pcidata = %x\n", pcidata);
 	if (pcidata & 0x2) {
-		printk(KERN_NOTICE "mfi 1068 offset read=%x\n", pcidata);
+		pr_notice("mfi 1068 offset read=%x\n", pcidata);
 		pcidata &= ~0x2;
 		pci_write_config_dword(instance->pdev,
 				MFI_1068_PCSR_OFFSET, pcidata);
@@ -395,9 +397,9 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 		pcidata  = 0;
 		pci_read_config_dword(instance->pdev,
 				MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
-		printk(KERN_NOTICE "1068 offset handshake read=%x\n", pcidata);
+		pr_notice("1068 offset handshake read=%x\n", pcidata);
 		if ((pcidata & 0xffff0000) == MFI_1068_FW_READY) {
-			printk(KERN_NOTICE "1068 offset pcidt=%x\n", pcidata);
+			pr_notice("1068 offset pcidt=%x\n", pcidata);
 			pcidata = 0;
 			pci_write_config_dword(instance->pdev,
 				MFI_1068_FW_HANDSHAKE_OFFSET, pcidata);
@@ -836,15 +838,15 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
-					retry, HostDiag);
+		pr_notice("RESETGEN2: retry=%x, hostdiag=%x\n",
+			  retry, HostDiag);
 
 		if (retry++ >= 100)
 			return 1;
 
 	}
 
-	printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
+	pr_notice("ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
 
 	writel((HostDiag | DIAG_RESET_ADAPTER), hostdiag_offset);
 
@@ -854,8 +856,8 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
-		printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
-				retry, HostDiag);
+		pr_notice("RESET_GEN2: retry=%x, hostdiag=%x\n",
+			  retry, HostDiag);
 
 		if (retry++ >= 1000)
 			return 1;
@@ -1253,8 +1255,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 						      &pthru->sgl);
 
 	if (pthru->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: DCDB two many SGE NUM=%x\n",
-			pthru->sge_count);
+		pr_err("DCDB two many SGE NUM=%x\n", pthru->sge_count);
 		return 0;
 	}
 
@@ -1394,8 +1395,7 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);
 
 	if (ldio->sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: build_ld_io: sge_count = %x\n",
-			ldio->sge_count);
+		pr_err("build_ld_io: sge_count = %x\n", ldio->sge_count);
 		return 0;
 	}
 
@@ -1461,63 +1461,73 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	u32 sgcount;
 	u32 max_cmd = instance->max_fw_cmds;
 
-	printk(KERN_ERR "\nmegasas[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
-	printk(KERN_ERR "megasas[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
+	pr_err("[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",
+	       instance->host->host_no);
+	pr_err("[%d]: Total OS Pending cmds : %d\n",
+	       instance->host->host_no, atomic_read(&instance->fw_outstanding));
 	if (IS_DMA64)
-		printk(KERN_ERR "\nmegasas[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
+		pr_err("[%d]: 64 bit SGLs were sent to FW\n",
+		       instance->host->host_no);
 	else
-		printk(KERN_ERR "\nmegasas[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);
+		pr_err("[%d]: 32 bit SGLs were sent to FW\n",
+		       instance->host->host_no);
 
-	printk(KERN_ERR "megasas[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
+	pr_err("[%d]: Pending OS cmds in FW:\n", instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if(!cmd->scmd)
 			continue;
-		printk(KERN_ERR "megasas[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
+		pr_err("[%d]: Frame addr :0x%08lx : ",
+		       instance->host->host_no,
+		       (unsigned long)cmd->frame_phys_addr);
 		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
 			ldio = (struct megasas_io_frame *)cmd->frame;
 			mfi_sgl = &ldio->sgl;
 			sgcount = ldio->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x,"
-			" lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
-			instance->host->host_no, cmd->frame_count, ldio->cmd, ldio->target_id,
-			le32_to_cpu(ldio->start_lba_lo), le32_to_cpu(ldio->start_lba_hi),
-			le32_to_cpu(ldio->sense_buf_phys_addr_lo), sgcount);
+			pr_err("[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x, sge count : 0x%x\n",
+			       instance->host->host_no, cmd->frame_count,
+			       ldio->cmd, ldio->target_id,
+			       le32_to_cpu(ldio->start_lba_lo),
+			       le32_to_cpu(ldio->start_lba_hi),
+			       le32_to_cpu(ldio->sense_buf_phys_addr_lo),
+			       sgcount);
 		}
 		else {
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
-			printk(KERN_ERR "megasas[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
-			"lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
-			instance->host->host_no, cmd->frame_count, pthru->cmd, pthru->target_id,
-			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
-			le32_to_cpu(pthru->sense_buf_phys_addr_lo), sgcount);
+			pr_err("[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x, sge count : 0x%x\n",
+			       instance->host->host_no, cmd->frame_count,
+			       pthru->cmd, pthru->target_id, pthru->lun,
+			       pthru->cdb_len,
+			       le32_to_cpu(pthru->data_xfer_len),
+			       le32_to_cpu(pthru->sense_buf_phys_addr_lo),
+			       sgcount);
 		}
 	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
 		for (n = 0; n < sgcount; n++){
 			if (IS_DMA64)
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%llx ",
-					le32_to_cpu(mfi_sgl->sge64[n].length),
-					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
+				pr_err("sgl len : 0x%x, sgl addr : 0x%llx\n",
+				       le32_to_cpu(mfi_sgl->sge64[n].length),
+				       le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
 			else
-				printk(KERN_ERR "megasas: sgl len : 0x%x, sgl addr : 0x%x ",
-					le32_to_cpu(mfi_sgl->sge32[n].length),
-					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
+				pr_err("sgl len : 0x%x, sgl addr : 0x%x\n",
+				       le32_to_cpu(mfi_sgl->sge32[n].length),
+				       le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 			}
 		}
-		printk(KERN_ERR "\n");
 	} /*for max_cmd*/
-	printk(KERN_ERR "\nmegasas[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
+	pr_err("[%d]: Pending Internal cmds in FW", instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 
 		cmd = instance->cmd_list[i];
 
 		if(cmd->sync_cmd == 1){
-			printk(KERN_ERR "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
+			pr_cont(" : 0x%08lx",
+				(unsigned long)cmd->frame_phys_addr);
 		}
 	}
-	printk(KERN_ERR "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
+	pr_err("[%d]: Dumping Done\n", instance->host->host_no);
 }
 
 u32
@@ -1635,7 +1645,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	}
 
 	if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
-		printk(KERN_ERR "megasas: Err returned from build_and_issue_cmd\n");
+		pr_err("Err returned from build_and_issue_cmd\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1806,8 +1816,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 	while (consumer != producer) {
 		context = le32_to_cpu(instance->reply_queue[consumer]);
 		if (context >= instance->max_fw_cmds) {
-			printk(KERN_ERR "Unexpected context value %x\n",
-				context);
+			pr_err("Unexpected context value %x\n", context);
 			BUG();
 		}
 
@@ -1885,17 +1894,16 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
-		       "Failed to get cmd for scsi%d.\n",
-			instance->host->host_no);
+		pr_debug("%s: Failed to get cmd for scsi%d\n",
+			 __func__, instance->host->host_no);
 		return -ENOMEM;
 	}
 
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation_111) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
-		       "affiliation for scsi%d.\n", instance->host->host_no);
+		pr_warn("SR-IOV: Couldn't get LD/VF affiliation for scsi%d\n",
+			instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -1909,9 +1917,8 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION_111),
 					     &new_affiliation_111_h);
 		if (!new_affiliation_111) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
-			       "memory for new affiliation for scsi%d.\n",
-			       instance->host->host_no);
+			pr_debug("SR-IOV: Couldn't allocate memory for new affiliation for scsi%d\n",
+				 instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
 			return -ENOMEM;
 		}
@@ -1939,15 +1946,14 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length =
 		sizeof(struct MR_LD_VF_AFFILIATION_111);
 
-	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
-	       "scsi%d\n", instance->host->host_no);
+	pr_warn("SR-IOV: Getting LD/VF affiliation for scsi%d\n",
+		instance->host->host_no);
 
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
-		       " failed with status 0x%x for scsi%d.\n",
-		       dcmd->cmd_status, instance->host->host_no);
+		pr_warn("SR-IOV: LD/VF affiliation DCMD failed with status 0x%x for scsi%d\n",
+			dcmd->cmd_status, instance->host->host_no);
 		retval = 1; /* Do a scan if we couldn't get affiliation */
 		goto out;
 	}
@@ -1957,10 +1963,8 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 		for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
 			if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
 			    new_affiliation_111->map[ld].policy[thisVf]) {
-				printk(KERN_WARNING "megasas: SR-IOV: "
-				       "Got new LD/VF affiliation "
-				       "for scsi%d.\n",
-				       instance->host->host_no);
+				pr_warn("SR-IOV: Got new LD/VF affiliation for scsi%d\n",
+					instance->host->host_no);
 				memcpy(instance->vf_affiliation_111,
 				       new_affiliation_111,
 				       sizeof(struct MR_LD_VF_AFFILIATION_111));
@@ -1999,17 +2003,16 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation12: "
-		       "Failed to get cmd for scsi%d.\n",
-		       instance->host->host_no);
+		pr_debug("%s: Failed to get cmd for scsi%d\n",
+			 __func__, instance->host->host_no);
 		return -ENOMEM;
 	}
 
 	dcmd = &cmd->frame->dcmd;
 
 	if (!instance->vf_affiliation) {
-		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
-		       "affiliation for scsi%d.\n", instance->host->host_no);
+		pr_warn("SR-IOV: Couldn't get LD/VF affiliation for scsi%d\n",
+			instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -2024,9 +2027,8 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION),
 					     &new_affiliation_h);
 		if (!new_affiliation) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
-			       "memory for new affiliation for scsi%d.\n",
-			       instance->host->host_no);
+			pr_debug("SR-IOV: Couldn't allocate memory for new affiliation for scsi%d\n",
+				 instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
 			return -ENOMEM;
 		}
@@ -2054,24 +2056,22 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
 		sizeof(struct MR_LD_VF_AFFILIATION);
 
-	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
-	       "scsi%d\n", instance->host->host_no);
+	pr_warn("R-IOV: Getting LD/VF affiliation for scsi%d\n",
+		instance->host->host_no);
 
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
-		       " failed with status 0x%x for scsi%d.\n",
-		       dcmd->cmd_status, instance->host->host_no);
+		pr_warn("SR-IOV: LD/VF affiliation DCMD failed with status 0x%x for scsi%d\n",
+			dcmd->cmd_status, instance->host->host_no);
 		retval = 1; /* Do a scan if we couldn't get affiliation */
 		goto out;
 	}
 
 	if (!initial) {
 		if (!new_affiliation->ldCount) {
-			printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
-			       "affiliation for passive path for scsi%d.\n",
-			       instance->host->host_no);
+			pr_warn("SR-IOV: Got new LD/VF affiliation for passive path for scsi%d\n",
+				instance->host->host_no);
 			retval = 1;
 			goto out;
 		}
@@ -2135,8 +2135,8 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	}
 out:
 	if (doscan) {
-		printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
-		       "affiliation for scsi%d.\n", instance->host->host_no);
+		pr_warn("SR-IOV: Got new LD/VF affiliation for scsi%d\n",
+			instance->host->host_no);
 		memcpy(instance->vf_affiliation, new_affiliation,
 		       new_affiliation->size);
 		retval = 1;
@@ -2180,9 +2180,8 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_sriov_start_heartbeat: "
-		       "Failed to get cmd for scsi%d.\n",
-		       instance->host->host_no);
+		pr_debug("%s: Failed to get cmd for scsi%d\n",
+			 __func__, instance->host->host_no);
 		return -ENOMEM;
 	}
 
@@ -2194,9 +2193,8 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 					      sizeof(struct MR_CTRL_HB_HOST_MEM),
 					      &instance->hb_host_mem_h);
 		if (!instance->hb_host_mem) {
-			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate"
-			       " memory for heartbeat host memory for "
-			       "scsi%d.\n", instance->host->host_no);
+			pr_debug("SR-IOV: Couldn't allocate memory for heartbeat host memory for scsi%d\n",
+				 instance->host->host_no);
 			retval = -ENOMEM;
 			goto out;
 		}
@@ -2216,25 +2214,22 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].phys_addr = instance->hb_host_mem_h;
 	dcmd->sgl.sge32[0].length = sizeof(struct MR_CTRL_HB_HOST_MEM);
 
-	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
-	       instance->host->host_no);
+	pr_warn("SR-IOV: Starting heartbeat for scsi%d\n",
+		instance->host->host_no);
 
 	if (!megasas_issue_polled(instance, cmd)) {
 		retval = 0;
 	} else {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
-		       "_MEM_ALLOC DCMD timed out for scsi%d\n",
-		       instance->host->host_no);
+		pr_warn("SR-IOV: MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC DCMD timed out for scsi%d\n",
+			instance->host->host_no);
 		retval = 1;
 		goto out;
 	}
 
 
 	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
-		       "_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
-		       dcmd->cmd_status,
-		       instance->host->host_no);
+		pr_warn("SR-IOV: MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
+			dcmd->cmd_status, instance->host->host_no);
 		retval = 1;
 		goto out;
 	}
@@ -2258,8 +2253,8 @@ void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
 		mod_timer(&instance->sriov_heartbeat_timer,
 			  jiffies + MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
 	} else {
-		printk(KERN_WARNING "megasas: SR-IOV: Heartbeat never "
-		       "completed for scsi%d\n", instance->host->host_no);
+		pr_warn("SR-IOV: Heartbeat never completed for scsi%d\n",
+			instance->host->host_no);
 		schedule_work(&instance->work_init);
 	}
 }
@@ -2296,7 +2291,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 				&clist_local);
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_NOTICE "megasas: HBA reset wait ...\n");
+		pr_notice("HBA reset wait ...\n");
 		for (i = 0; i < wait_time; i++) {
 			msleep(1000);
 			spin_lock_irqsave(&instance->hba_lock, flags);
@@ -2307,7 +2302,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		}
 
 		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
-			printk(KERN_NOTICE "megasas: reset: Stopping HBA.\n");
+			pr_notice("reset: stopping HBA\n");
 			spin_lock_irqsave(&instance->hba_lock, flags);
 			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
 			spin_unlock_irqrestore(&instance->hba_lock, flags);
@@ -2321,25 +2316,23 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
 				reset_cmd->scmd->result = DID_RESET << 16;
-				printk(KERN_NOTICE "%d:%p reset [%02x]\n",
-					reset_index, reset_cmd,
-					reset_cmd->scmd->cmnd[0]);
+				pr_notice("%d:%p reset [%02x]\n",
+					  reset_index, reset_cmd,
+					  reset_cmd->scmd->cmnd[0]);
 
 				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
 				megasas_return_cmd(instance, reset_cmd);
 			} else if (reset_cmd->sync_cmd) {
-				printk(KERN_NOTICE "megasas:%p synch cmds"
-						"reset queue\n",
-						reset_cmd);
+				pr_notice("%p synch cmds reset queue\n",
+					  reset_cmd);
 
 				reset_cmd->cmd_status = ENODATA;
 				instance->instancet->fire_cmd(instance,
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
 			} else {
-				printk(KERN_NOTICE "megasas: %p unexpected"
-					"cmds lst\n",
-					reset_cmd);
+				pr_notice("%p unexpected cmds lst\n",
+					  reset_cmd);
 			}
 			reset_index++;
 		}
@@ -2355,8 +2348,8 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			break;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
-			       "commands to complete\n",i,outstanding);
+			pr_notice("[%2d]waiting for %d commands to complete\n",
+				  i, outstanding);
 			/*
 			 * Call cmd completion routine. Cmd to be
 			 * be completed directly without depending on isr.
@@ -2406,7 +2399,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 
 	if (atomic_read(&instance->fw_outstanding) ||
 					(kill_adapter_flag == 2)) {
-		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
+		pr_notice("pending cmds after reset\n");
 		/*
 		* Send signal to FW to stop processing any pending cmds.
 		* The controller will be taken offline by the OS now.
@@ -2428,7 +2421,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		return FAILED;
 	}
 
-	printk(KERN_NOTICE "megaraid_sas: no pending cmds after reset\n");
+	pr_notice("no pending cmds after reset\n");
 
 	return SUCCESS;
 }
@@ -2452,16 +2445,15 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
 		 scmd->cmnd[0], scmd->retries);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_ERR "megasas: cannot recover from previous reset "
-		       "failures\n");
+		pr_err("cannot recover from previous reset failures\n");
 		return FAILED;
 	}
 
 	ret_val = megasas_wait_for_outstanding(instance);
 	if (ret_val == SUCCESS)
-		printk(KERN_NOTICE "megasas: reset successful \n");
+		pr_notice("reset successful\n");
 	else
-		printk(KERN_ERR "megasas: failed to do reset\n");
+		pr_err("failed to do reset\n");
 
 	return ret_val;
 }
@@ -2622,9 +2614,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		((instance->issuepend_done == 1))) {
 		struct megasas_aen_event *ev;
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
-		if (!ev) {
-			printk(KERN_ERR "megasas_service_aen: out of memory\n");
-		} else {
+		if (ev) {
 			ev->instance = instance;
 			instance->ev = ev;
 			INIT_DELAYED_WORK(&ev->hotplug_work,
@@ -2877,10 +2867,8 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		   MR_DCMD_CTRL_EVENT_GET_INFO left over from the main kernel
 		   when booting the kdump kernel.  Ignore this command to
 		   prevent a kernel panic on shutdown of the kdump kernel. */
-		printk(KERN_WARNING "megaraid_sas: MFI_CMD_INVALID command "
-		       "completed.\n");
-		printk(KERN_WARNING "megaraid_sas: If you have a controller "
-		       "other than PERC5, please upgrade your firmware.\n");
+		pr_warn("MFI_CMD_INVALID command completed\n");
+		pr_warn("If you have a controller other than PERC5, please upgrade your firmware\n");
 		break;
 	case MFI_CMD_PD_SCSI_IO:
 	case MFI_CMD_LD_SCSI_IO:
@@ -2948,8 +2936,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: MFI FW status %#x\n",
-			       hdr->cmd_status);
+			pr_debug("MFI FW status %#x\n", hdr->cmd_status);
 			cmd->scmd->result = DID_ERROR << 16;
 			break;
 		}
@@ -2974,9 +2961,8 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			if (cmd->frame->hdr.cmd_status != 0) {
 				if (cmd->frame->hdr.cmd_status !=
 				    MFI_STAT_NOT_FOUND)
-					printk(KERN_WARNING "megasas: map sync"
-					       "failed, status = 0x%x.\n",
-					       cmd->frame->hdr.cmd_status);
+					pr_warn("map sync failed, status = 0x%x\n",
+						cmd->frame->hdr.cmd_status);
 				else {
 					megasas_return_mfi_mpt_pthr(instance,
 						cmd, cmd->mpt_pthr_cmd_blocked);
@@ -3029,8 +3015,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		break;
 
 	default:
-		printk("megasas: Unknown command completed! [0x%X]\n",
-		       hdr->cmd);
+		pr_notice("Unknown command completed! [0x%X]\n", hdr->cmd);
 		break;
 	}
 }
@@ -3060,17 +3045,14 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 		list_del_init(&cmd->list);
 
 		if (cmd->sync_cmd || cmd->scmd) {
-			printk(KERN_NOTICE "megaraid_sas: command %p, %p:%d"
-				"detected to be pending while HBA reset.\n",
-					cmd, cmd->scmd, cmd->sync_cmd);
+			pr_notice("command %p, %p:%d detected to be pending while HBA reset\n",
+				  cmd, cmd->scmd, cmd->sync_cmd);
 
 			cmd->retry_for_fw_reset++;
 
 			if (cmd->retry_for_fw_reset == 3) {
-				printk(KERN_NOTICE "megaraid_sas: cmd %p, %p:%d"
-					"was tried multiple times during reset."
-					"Shutting down the HBA\n",
-					cmd, cmd->scmd, cmd->sync_cmd);
+				pr_notice("cmd %p, %p:%d was tried multiple times during reset - shutting down the HBA\n",
+					  cmd, cmd->scmd, cmd->sync_cmd);
 				instance->instancet->disable_intr(instance);
 				atomic_set(&instance->fw_reset_no_pci_access, 1);
 				megaraid_sas_kill_hba(instance);
@@ -3080,34 +3062,30 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 
 		if (cmd->sync_cmd == 1) {
 			if (cmd->scmd) {
-				printk(KERN_NOTICE "megaraid_sas: unexpected"
-					"cmd attached to internal command!\n");
+				pr_notice("unexpected cmd attached to internal command!\n");
 			}
-			printk(KERN_NOTICE "megasas: %p synchronous cmd"
-						"on the internal reset queue,"
-						"issue it again.\n", cmd);
+			pr_notice("%p synchronous cmd on the internal reset queue, issue it again\n",
+				  cmd);
 			cmd->cmd_status = ENODATA;
 			instance->instancet->fire_cmd(instance,
 							cmd->frame_phys_addr ,
 							0, instance->reg_set);
 		} else if (cmd->scmd) {
-			printk(KERN_NOTICE "megasas: %p scsi cmd [%02x]"
-			"detected on the internal queue, issue again.\n",
-			cmd, cmd->scmd->cmnd[0]);
+			pr_notice("%p scsi cmd [%02x]  detected on the internal queue, issue again\n",
+				  cmd, cmd->scmd->cmnd[0]);
 
 			atomic_inc(&instance->fw_outstanding);
 			instance->instancet->fire_cmd(instance,
 					cmd->frame_phys_addr,
 					cmd->frame_count-1, instance->reg_set);
 		} else {
-			printk(KERN_NOTICE "megasas: %p unexpected cmd on the"
-				"internal reset defer list while re-issue!!\n",
-				cmd);
+			pr_notice("%p unexpected cmd on the internal reset defer list while re-issue!!\n",
+				  cmd);
 		}
 	}
 
 	if (instance->aen_cmd) {
-		printk(KERN_NOTICE "megaraid_sas: aen_cmd in def process\n");
+		pr_notice("aen_cmd in def process\n");
 		megasas_return_cmd(instance, instance->aen_cmd);
 
 		instance->aen_cmd	= NULL;
@@ -3147,15 +3125,12 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
 		if (cmd->sync_cmd == 1 || cmd->scmd) {
-			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
-					"on the defer queue as internal\n",
-				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
+			pr_notice("moving cmd[%d]:%p:%d:%p on the defer queue as internal\n",
+				  defer_index, cmd, cmd->sync_cmd, cmd->scmd);
 
 			if (!list_empty(&cmd->list)) {
-				printk(KERN_NOTICE "megaraid_sas: ERROR while"
-					" moving this cmd:%p, %d %p, it was"
-					"discovered on some list?\n",
-					cmd, cmd->sync_cmd, cmd->scmd);
+				pr_notice("ERROR while moving this cmd:%p, %d %p, it was discovered on some list?\n",
+					  cmd, cmd->sync_cmd, cmd->scmd);
 
 				list_del_init(&cmd->list);
 			}
@@ -3177,14 +3152,12 @@ process_fw_state_change_wq(struct work_struct *work)
 	unsigned long flags;
 
 	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
-		printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
-				instance->adprecovery);
+		pr_notice("error, recovery st %x\n", instance->adprecovery);
 		return ;
 	}
 
 	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
-		printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
-					"state, restarting it...\n");
+		pr_notice("FW detected to be in fault state, restarting it...\n");
 
 		instance->instancet->disable_intr(instance);
 		atomic_set(&instance->fw_outstanding, 0);
@@ -3193,11 +3166,9 @@ process_fw_state_change_wq(struct work_struct *work)
 		instance->instancet->adp_reset(instance, instance->reg_set);
 		atomic_set(&instance->fw_reset_no_pci_access, 0 );
 
-		printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
-					"initiating next stage...\n");
+		pr_notice("FW restarted successfully, initiating next stage...\n");
 
-		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
-					"state 2 starting...\n");
+		pr_notice("HBA recovery state machine, state 2 starting...\n");
 
 		/*waitting for about 20 second before start the second init*/
 		for (wait = 0; wait < 30; wait++) {
@@ -3205,7 +3176,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		}
 
 		if (megasas_transition_to_ready(instance, 1)) {
-			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
+			pr_notice("adapter not ready\n");
 
 			atomic_set(&instance->fw_reset_no_pci_access, 1);
 			megaraid_sas_kill_hba(instance);
@@ -3270,13 +3241,12 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 				instance->reg_set) & MFI_STATE_MASK;
 
 		if (fw_state != MFI_STATE_FAULT) {
-			printk(KERN_NOTICE "megaraid_sas: fw state:%x\n",
-						fw_state);
+			pr_notice("fw state:%x\n", fw_state);
 		}
 
 		if ((fw_state == MFI_STATE_FAULT) &&
 				(instance->disableOnlineCtrlReset == 0)) {
-			printk(KERN_NOTICE "megaraid_sas: wait adp restart\n");
+			pr_notice("wait adp restart\n");
 
 			if ((instance->pdev->device ==
 					PCI_DEVICE_ID_LSI_SAS1064R) ||
@@ -3297,15 +3267,15 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 			atomic_set(&instance->fw_outstanding, 0);
 			megasas_internal_reset_defer_cmds(instance);
 
-			printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
-					fw_state, instance->adprecovery);
+			pr_notice("fwState=%x, stage:%d\n",
+				  fw_state, instance->adprecovery);
 
 			schedule_work(&instance->work_init);
 			return IRQ_HANDLED;
 
 		} else {
-			printk(KERN_NOTICE "megasas: fwstate:%x, dis_OCR=%x\n",
-				fw_state, instance->disableOnlineCtrlReset);
+			pr_notice("fwstate:%x, dis_OCR=%x\n",
+				  fw_state, instance->disableOnlineCtrlReset);
 		}
 	}
 
@@ -3354,15 +3324,14 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 	fw_state = abs_state & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
-		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
-		       " state\n");
+		pr_info("Waiting for FW to come to ready state\n");
 
 	while (fw_state != MFI_STATE_READY) {
 
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
-			printk(KERN_DEBUG "megasas: FW in FAULT state!!\n");
+			pr_debug("FW in FAULT state!!\n");
 			if (ocr) {
 				max_wait = MEGASAS_RESET_WAIT_TIME;
 				cur_state = MFI_STATE_FAULT;
@@ -3501,8 +3470,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			break;
 
 		default:
-			printk(KERN_DEBUG "megasas: Unknown state 0x%x\n",
-			       fw_state);
+			pr_debug("Unknown state 0x%x\n", fw_state);
 			return -ENODEV;
 		}
 
@@ -3523,15 +3491,15 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		 * Return error if fw_state hasn't changed after max_wait
 		 */
 		if (curr_abs_state == abs_state) {
-			printk(KERN_DEBUG "FW state [%d] hasn't changed "
-			       "in %d secs\n", fw_state, max_wait);
+			pr_debug("FW state [%d] hasn't changed in %d secs\n",
+				 fw_state, max_wait);
 			return -ENODEV;
 		}
 
 		abs_state = curr_abs_state;
 		fw_state = curr_abs_state & MFI_STATE_MASK;
 	}
-	printk(KERN_INFO "megasas: FW now in Ready state\n");
+	pr_info("FW now in Ready state\n");
 
 	return 0;
 }
@@ -3626,7 +3594,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 					instance->pdev, total_sz, 256, 0);
 
 	if (!instance->frame_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup frame pool\n");
+		pr_debug("failed to setup frame pool\n");
 		return -ENOMEM;
 	}
 
@@ -3634,7 +3602,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 						   instance->pdev, 128, 4, 0);
 
 	if (!instance->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool\n");
+		pr_debug("failed to setup sense pool\n");
 
 		pci_pool_destroy(instance->frame_dma_pool);
 		instance->frame_dma_pool = NULL;
@@ -3662,7 +3630,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed \n");
+			pr_debug("pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool(instance);
 			return -ENOMEM;
 		}
@@ -3738,11 +3706,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * commands.
 	 */
 	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
-
-	if (!instance->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory\n");
+	if (!instance->cmd_list)
 		return -ENOMEM;
-	}
 
 	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) *max_cmd);
 
@@ -3777,7 +3742,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		pr_debug("Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
 	}
 
@@ -3806,7 +3771,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+		pr_debug("(get_pd_list): Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3816,7 +3781,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		  MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for pd_list\n");
+		pr_debug("Failed to alloc mem for pd_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3905,7 +3870,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas_get_ld_list: Failed to get cmd\n");
+		pr_debug("%s: Failed to get cmd\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -3916,7 +3881,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 				&ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem in get_ld_list\n");
+		pr_debug("Failed to alloc mem in get_ld_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3995,8 +3960,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_WARNING
-		       "megasas:(megasas_ld_list_query): Failed to get cmd\n");
+		pr_warn("(megasas_ld_list_query): Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -4006,8 +3970,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 				  sizeof(struct MR_LD_TARGETID_LIST), &ci_h);
 
 	if (!ci) {
-		printk(KERN_WARNING
-		       "megasas: Failed to alloc mem for ld_list_query\n");
+		pr_warn("Failed to alloc mem for ld_list_query\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4139,7 +4102,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
+		pr_debug("Failed to get a free cmd\n");
 		return -ENOMEM;
 	}
 
@@ -4149,7 +4112,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				  sizeof(struct megasas_ctrl_info), &ci_h);
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ctrl info\n");
+		pr_debug("Failed to alloc mem for ctrl info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4318,7 +4281,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	 */
 
 	if (megasas_issue_polled(instance, cmd)) {
-		printk(KERN_ERR "megasas: Failed to init firmware\n");
+		pr_err("Failed to init firmware\n");
 		megasas_return_cmd(instance, cmd);
 		goto fail_fw_init;
 	}
@@ -4376,7 +4339,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 						     &instance->reply_queue_h);
 
 	if (!instance->reply_queue) {
-		printk(KERN_DEBUG "megasas: Out of DMA mem for reply queue\n");
+		pr_debug("Out of DMA mem for reply queue\n");
 		goto fail_reply_queue;
 	}
 
@@ -4395,8 +4358,8 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		(instance->instancet->read_fw_status_reg(reg_set) &
 		0x04000000);
 
-	printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
-			instance->fw_support_ieee);
+	pr_notice("%s: fw_support_ieee=%d\n",
+		  __func__, instance->fw_support_ieee);
 
 	if (instance->fw_support_ieee)
 		instance->flag_ieee = 1;
@@ -4438,7 +4401,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
-		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
+		pr_debug("IO memory region busy!\n");
 		return -EBUSY;
 	}
 
@@ -4446,7 +4409,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
-		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
+		pr_debug("Failed to map IO mem\n");
 		goto fail_ioremap;
 	}
 
@@ -4574,7 +4537,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
-	printk(KERN_ERR "megasas: INIT adapter done\n");
+	pr_err("INIT adapter done\n");
 
 	/** for passthrough
 	* the following function will get the PD LIST.
@@ -4583,7 +4546,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	memset(instance->pd_list, 0 ,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
-		printk(KERN_ERR "megasas: failed to get PD list\n");
+		pr_err("failed to get PD list\n");
 		goto fail_init_adapter;
 	}
 
@@ -4910,8 +4873,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 								  aen_cmd, 30);
 
 			if (ret_val) {
-				printk(KERN_DEBUG "megasas: Failed to abort "
-				       "previous AEN command\n");
+				pr_debug("Failed to abort previous AEN command\n");
 				return ret_val;
 			}
 		}
@@ -5028,9 +4990,8 @@ static int megasas_io_attach(struct megasas_instance *instance)
 				(max_sectors <= MEGASAS_MAX_SECTORS)) {
 				instance->max_sectors_per_req = max_sectors;
 			} else {
-			printk(KERN_INFO "megasas: max_sectors should be > 0"
-				"and <= %d (or < 1MB for GEN2 controller)\n",
-				instance->max_sectors_per_req);
+				pr_info("max_sectors should be > 0 and <= %d (or < 1MB for GEN2 controller)\n",
+					instance->max_sectors_per_req);
 			}
 		}
 	}
@@ -5055,7 +5016,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	 * Notify the mid-layer about the new controller
 	 */
 	if (scsi_add_host(host, &instance->pdev->dev)) {
-		printk(KERN_DEBUG "megasas: scsi_add_host failed\n");
+		pr_debug("scsi_add_host failed\n");
 		return -ENODEV;
 	}
 
@@ -5131,12 +5092,11 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	/*
 	 * Announce PCI information
 	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
-
-	printk("bus %d:slot %d:func %d\n",
-	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+	pr_info("0x%04x:%04x:%04x:%04x: bus %d:slot %d:func %d\n",
+		pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device,
+		pdev->bus->number,
+		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
 	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
@@ -5156,7 +5116,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			       sizeof(struct megasas_instance));
 
 	if (!host) {
-		printk(KERN_DEBUG "megasas: scsi_host_alloc failed\n");
+		pr_debug("scsi_host_alloc failed\n");
 		goto fail_alloc_instance;
 	}
 
@@ -5176,8 +5136,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL,
 				instance->ctrl_context_pages);
 		if (!instance->ctrl_context) {
-			printk(KERN_DEBUG "megasas: Failed to allocate "
-			       "memory for Fusion context info\n");
+			pr_debug("Failed to allocate memory for Fusion context info\n");
 			goto fail_alloc_dma_buf;
 		}
 		fusion = instance->ctrl_context;
@@ -5197,8 +5156,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					     &instance->consumer_h);
 
 		if (!instance->producer || !instance->consumer) {
-			printk(KERN_DEBUG "megasas: Failed to allocate"
-			       "memory for producer, consumer\n");
+			pr_debug("Failed to allocate memory for producer, consumer\n");
 			goto fail_alloc_dma_buf;
 		}
 
@@ -5237,8 +5195,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						    &instance->evt_detail_h);
 
 	if (!instance->evt_detail) {
-		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
-		       "event detail structure\n");
+		pr_debug("Failed to allocate memory for event detail structure\n");
 		goto fail_alloc_dma_buf;
 	}
 
@@ -5301,8 +5258,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 				pci_alloc_consistent(pdev, sizeof(struct MR_LD_VF_AFFILIATION_111),
 						     &instance->vf_affiliation_111_h);
 			if (!instance->vf_affiliation_111)
-				printk(KERN_WARNING "megasas: Can't allocate "
-				       "memory for VF affiliation buffer\n");
+				pr_warn("Can't allocate memory for VF affiliation buffer\n");
 		} else {
 			instance->vf_affiliation =
 				pci_alloc_consistent(pdev,
@@ -5310,8 +5266,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						     sizeof(struct MR_LD_VF_AFFILIATION),
 						     &instance->vf_affiliation_h);
 			if (!instance->vf_affiliation)
-				printk(KERN_WARNING "megasas: Can't allocate "
-				       "memory for VF affiliation buffer\n");
+				pr_warn("Can't allocate memory for VF affiliation buffer\n");
 		}
 	}
 
@@ -5328,8 +5283,8 @@ retry_irq_register:
 					instance->instancet->service_isr, 0,
 					"megasas",
 					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
+				pr_debug("Failed to register IRQ for vector %d\n",
+					 i);
 				for (j = 0; j < i; j++) {
 					if (smp_affinity_enable)
 						irq_set_affinity_hint(
@@ -5357,7 +5312,7 @@ retry_irq_register:
 		if (request_irq(pdev->irq, instance->instancet->service_isr,
 				IRQF_SHARED, "megasas",
 				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			pr_debug("Failed to register IRQ\n");
 			goto fail_irq;
 		}
 	}
@@ -5393,7 +5348,7 @@ retry_irq_register:
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance)) {
-		printk(KERN_DEBUG "megasas: start aen failed\n");
+		pr_debug("start aen failed\n");
 		goto fail_start_aen;
 	}
 
@@ -5627,7 +5582,7 @@ megasas_resume(struct pci_dev *pdev)
 	rval = pci_enable_device_mem(pdev);
 
 	if (rval) {
-		printk(KERN_ERR "megasas: Enable device failed\n");
+		pr_err("Enable device failed\n");
 		return rval;
 	}
 
@@ -5693,8 +5648,8 @@ megasas_resume(struct pci_dev *pdev)
 					instance->instancet->service_isr, 0,
 					"megasas",
 					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
+				pr_debug("Failed to register IRQ for vector %d\n",
+					 i);
 				for (j = 0; j < i; j++) {
 					if (smp_affinity_enable)
 						irq_set_affinity_hint(
@@ -5721,7 +5676,7 @@ megasas_resume(struct pci_dev *pdev)
 		if (request_irq(pdev->irq, instance->instancet->service_isr,
 				IRQF_SHARED, "megasas",
 				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			pr_debug("Failed to register IRQ\n");
 			goto fail_irq;
 		}
 	}
@@ -5744,7 +5699,7 @@ megasas_resume(struct pci_dev *pdev)
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance))
-		printk(KERN_ERR "megasas: Start AEN failed\n");
+		pr_err("Start AEN failed\n");
 
 	return 0;
 
@@ -5969,7 +5924,7 @@ static int megasas_mgmt_fasync(int fd, struct file *filep, int mode)
 		return 0;
 	}
 
-	printk(KERN_DEBUG "megasas: fasync_helper failed [%d]\n", rc);
+	pr_debug("fasync_helper failed [%d]\n", rc);
 
 	return rc;
 }
@@ -6054,14 +6009,14 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
 	if (ioc->sge_count > MAX_IOCTL_SGE) {
-		printk(KERN_DEBUG "megasas: SGE count [%d] >  max limit [%d]\n",
-		       ioc->sge_count, MAX_IOCTL_SGE);
+		pr_debug("SGE count [%d] >  max limit [%d]\n",
+			 ioc->sge_count, MAX_IOCTL_SGE);
 		return -EINVAL;
 	}
 
 	cmd = megasas_get_cmd(instance);
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get a cmd packet\n");
+		pr_debug("Failed to get a cmd packet\n");
 		return -ENOMEM;
 	}
 
@@ -6106,8 +6061,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
-			printk(KERN_DEBUG "megasas: Failed to alloc "
-			       "kernel SGL buffer for IOCTL \n");
+			pr_debug("Failed to alloc kernel SGL buffer for IOCTL\n");
 			error = -ENOMEM;
 			goto out;
 		}
@@ -6180,8 +6134,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 
 		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
 				 sense, ioc->sense_len)) {
-			printk(KERN_ERR "megasas: Failed to copy out to user "
-					"sense data\n");
+			pr_err("Failed to copy out to user sense data\n");
 			error = -EFAULT;
 			goto out;
 		}
@@ -6192,7 +6145,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 */
 	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
 			 &cmd->frame->hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: Error copying out cmd_status\n");
+		pr_debug("Error copying out cmd_status\n");
 		error = -EFAULT;
 	}
 
@@ -6256,7 +6209,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	}
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_ERR "Controller in crit error\n");
+		pr_err("Controller in crit error\n");
 		error = -ENODEV;
 		goto out_kfree_ioc;
 	}
@@ -6281,8 +6234,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting"
-				"for controller reset to finish\n");
+			pr_notice("waiting for controller reset to finish\n");
 		}
 
 		msleep(1000);
@@ -6292,8 +6244,7 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
-		printk(KERN_ERR "megaraid_sas: timed out while"
-			"waiting for HBA to recover\n");
+		pr_err("timed out while waiting for HBA to recover\n");
 		error = -ENODEV;
 		goto out_up;
 	}
@@ -6318,8 +6269,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	if (file->private_data != file) {
-		printk(KERN_DEBUG "megasas: fasync_helper was not "
-		       "called first\n");
+		pr_debug("fasync_helper was not called first\n");
 		return -EINVAL;
 	}
 
@@ -6351,8 +6301,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: waiting for"
-				"controller reset to finish\n");
+			pr_notice("waiting for controller reset to finish\n");
 		}
 
 		msleep(1000);
@@ -6361,8 +6310,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		printk(KERN_ERR "megaraid_sas: timed out while waiting"
-				"for HBA to recover.\n");
+		pr_err("timed out while waiting for HBA to recover\n");
 		return -ENODEV;
 	}
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
@@ -6440,7 +6388,7 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 
 	if (copy_in_user(&cioc->frame.hdr.cmd_status,
 			 &ioc->frame.hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: error copy_in_user cmd_status\n");
+		pr_debug("error copy_in_user cmd_status\n");
 		return -EFAULT;
 	}
 	return error;
@@ -6530,7 +6478,7 @@ megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t coun
 {
 	int retval = count;
 	if(sscanf(buf,"%u",&megasas_dbg_lvl)<1){
-		printk(KERN_ERR "megasas: could not set dbg_lvl\n");
+		pr_err("could not set dbg_lvl\n");
 		retval = -EINVAL;
 	}
 	return retval;
@@ -6555,7 +6503,7 @@ megasas_aen_polling(struct work_struct *work)
 	int error;
 
 	if (!instance) {
-		printk(KERN_ERR "invalid instance!\n");
+		pr_err("invalid instance!\n");
 		kfree(ev);
 		return;
 	}
@@ -6569,9 +6517,8 @@ megasas_aen_polling(struct work_struct *work)
 		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL)
 			break;
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: %s waiting for "
-			       "controller reset to finish for scsi%d\n",
-			       __func__, instance->host->host_no);
+			pr_notice("%s: waiting for controller reset to finish for scsi%d\n",
+				  __func__, instance->host->host_no);
 		}
 		msleep(1000);
 	}
@@ -6711,14 +6658,13 @@ megasas_aen_polling(struct work_struct *work)
 			break;
 		}
 	} else {
-		printk(KERN_ERR "invalid evt_detail!\n");
+		pr_err("invalid evt_detail!\n");
 		kfree(ev);
 		return;
 	}
 
 	if (doscan) {
-		printk(KERN_INFO "megaraid_sas: scanning for scsi%d...\n",
-		       instance->host->host_no);
+		pr_info("scanning for scsi%d...\n", instance->host->host_no);
 		if (megasas_get_pd_list(instance) == 0) {
 			for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
 				for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
@@ -6789,7 +6735,7 @@ megasas_aen_polling(struct work_struct *work)
 	mutex_unlock(&instance->aen_mutex);
 
 	if (error)
-		printk(KERN_ERR "register aen failed error %x\n", error);
+		pr_err("register aen failed error %x\n", error);
 
 	kfree(ev);
 }
@@ -6804,7 +6750,7 @@ static int __init megasas_init(void)
 	/*
 	 * Announce driver version and other information
 	 */
-	pr_info("megasas: %s\n", MEGASAS_VERSION);
+	pr_info("%s\n", MEGASAS_VERSION);
 
 	spin_lock_init(&poll_aen_lock);
 
@@ -6819,7 +6765,7 @@ static int __init megasas_init(void)
 	rval = register_chrdev(0, "megaraid_sas_ioctl", &megasas_mgmt_fops);
 
 	if (rval < 0) {
-		printk(KERN_DEBUG "megasas: failed to open device node\n");
+		pr_debug("failed to open device node\n");
 		return rval;
 	}
 
@@ -6831,7 +6777,7 @@ static int __init megasas_init(void)
 	rval = pci_register_driver(&megasas_pci_driver);
 
 	if (rval) {
-		printk(KERN_DEBUG "megasas: PCI hotplug registration failed \n");
+		pr_debug("PCI hotplug registration failed\n");
 		goto err_pcidrv;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 4f72287..f13845f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -32,6 +32,8 @@
  *  San Jose, California 95131
  */
 
+#define pr_fmt(fmt) "megasas: " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -89,7 +91,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
 	u32 remainder;
 
 	if (!divisor)
-		printk(KERN_ERR "megasas : DIVISOR is zero, in div fn\n");
+		pr_err("DIVISOR is zero, in div fn\n");
 	d = dividend;
 	remainder = do_div(d, divisor);
 	return remainder;
@@ -107,7 +109,7 @@ u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 	u64 d;
 
 	if (!divisor)
-		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
+		pr_err("DIVISOR is zero in mod fn\n");
 
 	d = dividend;
 	remainder = do_div(d, divisor);
@@ -1189,10 +1191,9 @@ void mr_update_span_set(struct MR_DRV_RAID_MAP_ALL *map,
 						span_row_width +=
 							MR_LdSpanPtrGet
 							(ld, count, map)->spanRowDataSize;
-						printk(KERN_INFO "megasas:"
-							"span %x rowDataSize %x\n",
-							count, MR_LdSpanPtrGet
-							(ld, count, map)->spanRowDataSize);
+						pr_info("span %x rowDataSize %x\n",
+							count,
+							MR_LdSpanPtrGet(ld, count, map)->spanRowDataSize);
 					}
 				}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675b5e7..e5b995e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -31,6 +31,8 @@
  *  San Jose, California 95131
  */
 
+#define pr_fmt(fmt) "megasas: " fmt
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -173,7 +175,7 @@ struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
 				 struct megasas_cmd_fusion, list);
 		list_del_init(&cmd->list);
 	} else {
-		printk(KERN_ERR "megasas: Command pool (fusion) empty!\n");
+		pr_err("Command pool (fusion) empty!\n");
 	}
 
 	spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags);
@@ -244,9 +246,8 @@ static void megasas_teardown_frame_pool_fusion(
 	struct megasas_cmd_fusion *cmd;
 
 	if (!fusion->sg_dma_pool || !fusion->sense_dma_pool) {
-		printk(KERN_ERR "megasas: dma pool is null. SG Pool %p, "
-		       "sense pool : %p\n", fusion->sg_dma_pool,
-		       fusion->sense_dma_pool);
+		pr_err("dma pool is null. SG Pool %p, sense pool : %p\n",
+		       fusion->sg_dma_pool, fusion->sense_dma_pool);
 		return;
 	}
 
@@ -356,8 +357,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 					      total_sz_chain_frame, 4,
 					      0);
 	if (!fusion->sg_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup request pool "
-		       "fusion\n");
+		pr_debug("failed to setup request pool fusion\n");
 		return -ENOMEM;
 	}
 	fusion->sense_dma_pool = pci_pool_create("megasas sense pool fusion",
@@ -365,8 +365,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 						 SCSI_SENSE_BUFFERSIZE, 64, 0);
 
 	if (!fusion->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool "
-		       "fusion\n");
+		pr_debug("failed to setup sense pool fusion\n");
 		pci_pool_destroy(fusion->sg_dma_pool);
 		fusion->sg_dma_pool = NULL;
 		return -ENOMEM;
@@ -390,7 +389,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->sg_frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed\n");
+			pr_debug("pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool_fusion(instance);
 			return -ENOMEM;
 		}
@@ -436,8 +435,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   &fusion->req_frames_desc_phys, GFP_KERNEL);
 
 	if (!fusion->req_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
-		       "request_frames\n");
+		pr_err("Could not allocate memory for request_frames\n");
 		goto fail_req_desc;
 	}
 
@@ -447,8 +445,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->reply_alloc_sz * count, 16, 0);
 
 	if (!fusion->reply_frames_desc_pool) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
-		       "reply_frame pool\n");
+		pr_err("Could not allocate memory for reply_frame pool\n");
 		goto fail_reply_desc;
 	}
 
@@ -456,8 +453,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->reply_frames_desc_pool, GFP_KERNEL,
 			       &fusion->reply_frames_desc_phys);
 	if (!fusion->reply_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
-		       "reply_frame pool\n");
+		pr_err("Could not allocate memory for reply_frame pool\n");
 		pci_pool_destroy(fusion->reply_frames_desc_pool);
 		goto fail_reply_desc;
 	}
@@ -473,8 +469,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->io_frames_alloc_sz, 16, 0);
 
 	if (!fusion->io_request_frames_pool) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
-		       "io_request_frame pool\n");
+		pr_err("Could not allocate memory for io_request_frame pool\n");
 		goto fail_io_frames;
 	}
 
@@ -482,8 +477,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->io_request_frames_pool, GFP_KERNEL,
 			       &fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
-		       "io_request_frames frames\n");
+		pr_err("Could not allocate memory for io_request_frames frames\n");
 		pci_pool_destroy(fusion->io_request_frames_pool);
 		goto fail_io_frames;
 	}
@@ -497,8 +491,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   * max_cmd, GFP_KERNEL);
 
 	if (!fusion->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
-		       "memory for cmd_list_fusion\n");
+		pr_debug("out of memory. Could not alloc memory for cmd_list_fusion\n");
 		goto fail_cmd_list;
 	}
 
@@ -507,7 +500,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		fusion->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd_fusion),
 					      GFP_KERNEL);
 		if (!fusion->cmd_list[i]) {
-			printk(KERN_ERR "Could not alloc cmd list fusion\n");
+			pr_err("Could not alloc cmd list fusion\n");
 
 			for (j = 0; j < i; j++)
 				kfree(fusion->cmd_list[j]);
@@ -551,7 +544,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool_fusion(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		pr_debug("Error creating frame DMA pool\n");
 		megasas_free_cmds_fusion(instance);
 		goto fail_req_desc;
 	}
@@ -639,7 +632,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_ERR "Could not allocate cmd for INIT Frame\n");
+		pr_err("Could not allocate cmd for INIT Frame\n");
 		ret = 1;
 		goto fail_get_cmd;
 	}
@@ -650,8 +643,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			     &ioc_init_handle, GFP_KERNEL);
 
 	if (!IOCInitMessage) {
-		printk(KERN_ERR "Could not allocate memory for "
-		       "IOCInitMessage\n");
+		pr_err("Could not allocate memory for IOCInitMessage\n");
 		ret = 1;
 		goto fail_fw_init;
 	}
@@ -729,7 +721,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+	pr_info("IOC Init cmd success\n");
 
 	ret = 0;
 
@@ -772,7 +764,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for map info.\n");
+		pr_debug("Failed to get cmd for map info\n");
 		return -ENOMEM;
 	}
 
@@ -791,7 +783,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	ci_h = fusion->ld_map_phys[(instance->map_id & 1)];
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ld_map_info\n");
+		pr_debug("Failed to alloc mem for ld_map_info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -870,8 +862,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for sync"
-		       "info.\n");
+		pr_debug("Failed to get cmd for sync info\n");
 		return -ENOMEM;
 	}
 
@@ -1107,8 +1098,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 						       &fusion->ld_map_phys[i],
 						       GFP_KERNEL);
 		if (!fusion->ld_map[i]) {
-			printk(KERN_ERR "megasas: Could not allocate memory "
-			       "for map info\n");
+			pr_err("Could not allocate memory for map info\n");
 			goto fail_map_info;
 		}
 	}
@@ -1200,7 +1190,7 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 		cmd->scmd->result = DID_IMM_RETRY << 16;
 		break;
 	default:
-		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
+		pr_debug("FW status %#x\n", status);
 		cmd->scmd->result = DID_ERROR << 16;
 		break;
 	}
@@ -1849,9 +1839,8 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 					&io_request->SGL, cmd);
 
 	if (sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: Error. sge_count (0x%x) exceeds "
-		       "max (0x%x) allowed\n", sge_count,
-		       instance->max_num_sge);
+		pr_err("Error: sge_count (0x%x) exceeds max (0x%x) allowed\n",
+		       sge_count, instance->max_num_sge);
 		return 1;
 	}
 
@@ -1883,9 +1872,8 @@ megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 	struct fusion_context *fusion;
 
 	if (index >= instance->max_fw_cmds) {
-		printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
-		       "descriptor for scsi%d\n", index,
-			instance->host->host_no);
+		pr_err("Invalid SMID (0x%x)request for descriptor for scsi%d\n",
+		       index, instance->host->host_no);
 		return NULL;
 	}
 	fusion = instance->ctrl_context;
@@ -1927,7 +1915,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (megasas_build_io_fusion(instance, scmd, cmd)) {
 		megasas_return_cmd_fusion(instance, cmd);
-		printk(KERN_ERR "megasas: Error building command.\n");
+		pr_err("Error building command\n");
 		cmd->request_desc = NULL;
 		return 1;
 	}
@@ -1937,8 +1925,8 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (cmd->io_request->ChainOffset != 0 &&
 	    cmd->io_request->ChainOffset != 0xF)
-		printk(KERN_ERR "megasas: The chain offset value is not "
-		       "correct : %x\n", cmd->io_request->ChainOffset);
+		pr_err("The chain offset value is not correct : %x\n",
+		       cmd->io_request->ChainOffset);
 
 	/*
 	 * Issue the command to the FW
@@ -2025,8 +2013,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 			if (reply_descript_type ==
 			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
 				if (megasas_dbg_lvl == 5)
-					printk(KERN_ERR "\nmegasas: FAST Path "
-					       "IO Success\n");
+					pr_err("FAST Path IO Success\n");
 			}
 			/* Fall thru and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
@@ -2190,8 +2177,8 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 			else if (fw_state == MFI_STATE_FAULT)
 				schedule_work(&instance->work_init);
 		} else if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megaraid_sas: Iop2SysDoorbellInt"
-			       "for scsi%d\n", instance->host->host_no);
+			pr_warn("Iop2SysDoorbellInt for scsi%d\n",
+				instance->host->host_no);
 			schedule_work(&instance->work_init);
 		}
 	}
@@ -2287,7 +2274,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	u16 index;
 
 	if (build_mpt_mfi_pass_thru(instance, cmd)) {
-		printk(KERN_ERR "Couldn't build MFI pass thru cmd\n");
+		pr_err("Couldn't build MFI pass thru cmd\n");
 		return NULL;
 	}
 
@@ -2321,7 +2308,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 
 	req_desc = build_mpt_cmd(instance, cmd);
 	if (!req_desc) {
-		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
+		pr_err("Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
 	atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_ATTACHED);
@@ -2433,8 +2420,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		fw_state = instance->instancet->read_fw_status_reg(
 			instance->reg_set) & MFI_STATE_MASK;
 		if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megasas: Found FW in FAULT state,"
-			       " will reset adapter scsi%d.\n",
+			pr_warn("Found FW in FAULT state, will reset adapter scsi%d\n",
 				instance->host->host_no);
 			retval = 1;
 			goto out;
@@ -2456,15 +2442,11 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				hb_seconds_missed++;
 				if (hb_seconds_missed ==
 				    (MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF/HZ)) {
-					printk(KERN_WARNING "megasas: SR-IOV:"
-					       " Heartbeat never completed "
-					       " while polling during I/O "
-					       " timeout handling for "
-					       "scsi%d.\n",
-					       instance->host->host_no);
-					       *convert = 1;
-					       retval = 1;
-					       goto out;
+					pr_warn("SR-IOV: Heartbeat never completed while polling during I/O timeout handling for scsi%d\n",
+						instance->host->host_no);
+					*convert = 1;
+					retval = 1;
+					goto out;
 				}
 			}
 		}
@@ -2474,9 +2456,8 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			goto out;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
-			       "commands to complete for scsi%d\n", i,
-			       outstanding, instance->host->host_no);
+			pr_notice("[%2d] waiting for %d commands to complete for scsi%d\n",
+				  i, outstanding, instance->host->host_no);
 			megasas_complete_cmd_dpc_fusion(
 				(unsigned long)instance);
 		}
@@ -2484,8 +2465,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	}
 
 	if (atomic_read(&instance->fw_outstanding)) {
-		printk("megaraid_sas: pending commands remain after waiting, "
-		       "will reset adapter scsi%d.\n",
+		pr_err("pending commands remain after waiting, will reset adapter scsi%d\n",
 		       instance->host->host_no);
 		retval = 1;
 	}
@@ -2550,8 +2530,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	mutex_lock(&instance->reset_mutex);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
-		       "returning FAILED for scsi%d.\n",
+		pr_warn("Hardware critical error, returning FAILED for scsi%d.\n",
 			instance->host->host_no);
 		mutex_unlock(&instance->reset_mutex);
 		return FAILED;
@@ -2604,8 +2583,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	if (megasas_wait_for_outstanding_fusion(instance, iotimeout,
 						&convert)) {
 		instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
-		printk(KERN_WARNING "megaraid_sas: resetting fusion "
-		       "adapter scsi%d.\n", instance->host->host_no);
+		pr_warn("resetting fusion adapter scsi%d\n",
+			instance->host->host_no);
 		if (convert)
 			iotimeout = 0;
 
@@ -2630,8 +2609,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 		if (instance->disableOnlineCtrlReset ||
 		    (abs_state == MFI_STATE_FAULT && !reset_adapter)) {
 			/* Reset not supported, kill adapter */
-			printk(KERN_WARNING "megaraid_sas: Reset not supported"
-			       ", killing adapter scsi%d.\n",
+			pr_warn("Reset not supported, killing adapter scsi%d\n",
 				instance->host->host_no);
 			megaraid_sas_kill_hba(instance);
 			instance->skip_heartbeat_timer_del = 1;
@@ -2648,10 +2626,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			     instance->hb_host_mem->HB.driverCounter)) {
 					instance->hb_host_mem->HB.driverCounter =
 						instance->hb_host_mem->HB.fwCounter;
-					printk(KERN_WARNING "megasas: SR-IOV:"
-					       "Late FW heartbeat update for "
-					       "scsi%d.\n",
-					       instance->host->host_no);
+					pr_warn("SR-IOV: Late FW heartbeat update for scsi%d\n",
+						instance->host->host_no);
 			} else {
 				/* In VF mode, first poll for FW ready */
 				for (i = 0;
@@ -2664,23 +2640,17 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					abs_state = status_reg &
 						MFI_STATE_MASK;
 					if (abs_state == MFI_STATE_READY) {
-						printk(KERN_WARNING "megasas"
-						       ": SR-IOV: FW was found"
-						       "to be in ready state "
-						       "for scsi%d.\n",
-						       instance->host->host_no);
+						pr_warn("SR-IOV: FW was found to be in ready state for scsi%d\n",
+							instance->host->host_no);
 						break;
 					}
 					msleep(20);
 				}
 				if (abs_state != MFI_STATE_READY) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
-					       "FW not in ready state after %d"
-					       " seconds for scsi%d, status_reg = "
-					       "0x%x.\n",
-					       MEGASAS_RESET_WAIT_TIME,
-					       instance->host->host_no,
-					       status_reg);
+					pr_warn("SR-IOV: FW not in ready state after %d seconds for scsi%d, status_reg = 0x%x\n",
+						MEGASAS_RESET_WAIT_TIME,
+						instance->host->host_no,
+						status_reg);
 					megaraid_sas_kill_hba(instance);
 					instance->skip_heartbeat_timer_del = 1;
 					instance->adprecovery =
@@ -2716,9 +2686,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 100) {
-					printk(KERN_WARNING "megaraid_sas: "
-					       "Host diag unlock failed! "
-					       "for scsi%d\n",
+					pr_warn("Host diag unlock failed for scsi%d\n",
 						instance->host->host_no);
 					break;
 				}
@@ -2739,9 +2707,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 1000) {
-					printk(KERN_WARNING "megaraid_sas: "
-					       "Diag reset adapter never "
-					       "cleared for scsi%d!\n",
+					pr_warn("Diag reset adapter never cleared for scsi%d!\n",
 						instance->host->host_no);
 					break;
 				}
@@ -2762,28 +2728,22 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					instance->reg_set) & MFI_STATE_MASK;
 			}
 			if (abs_state <= MFI_STATE_FW_INIT) {
-				printk(KERN_WARNING "megaraid_sas: firmware "
-				       "state < MFI_STATE_FW_INIT, state = "
-				       "0x%x for scsi%d\n", abs_state,
-					instance->host->host_no);
+				pr_warn("firmware state < MFI_STATE_FW_INIT, state = 0x%x for scsi%d\n",
+					abs_state, instance->host->host_no);
 				continue;
 			}
 
 			/* Wait for FW to become ready */
 			if (megasas_transition_to_ready(instance, 1)) {
-				printk(KERN_WARNING "megaraid_sas: Failed to "
-				       "transition controller to ready "
-				       "for scsi%d.\n",
-				       instance->host->host_no);
+				pr_warn("Failed to transition controller to ready for scsi%d\n",
+					instance->host->host_no);
 				continue;
 			}
 
 			megasas_reset_reply_desc(instance);
 			if (megasas_ioc_init_fusion(instance)) {
-				printk(KERN_WARNING "megaraid_sas: "
-				       "megasas_ioc_init_fusion() failed!"
-				       " for scsi%d\n",
-				       instance->host->host_no);
+				pr_warn("megasas_ioc_init_fusion() failed for scsi%d\n",
+					instance->host->host_no);
 				continue;
 			}
 
@@ -2805,9 +2765,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 							cmd_mfi->context.smid
 							-1);
 						if (!req_desc) {
-							printk(KERN_WARNING
-							       "req_desc NULL"
-							       " for scsi%d\n",
+							pr_warn("req_desc NULL for scsi%d\n",
 								instance->host->host_no);
 							/* Return leaked MPT
 							   frame */
@@ -2858,8 +2816,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			}
 
 			/* Adapter reset completed successfully */
-			printk(KERN_WARNING "megaraid_sas: Reset "
-			       "successful for scsi%d.\n",
+			pr_warn("Reset successful for scsi%d\n",
 				instance->host->host_no);
 
 			if (instance->crash_dump_drv_support &&
@@ -2874,8 +2831,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			goto out;
 		}
 		/* Reset failed, kill the adapter */
-		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
-		       "adapter scsi%d.\n", instance->host->host_no);
+		pr_warn("Reset failed, killing adapter scsi%d\n",
+			instance->host->host_no);
 		megaraid_sas_kill_hba(instance);
 		instance->skip_heartbeat_timer_del = 1;
 		retval = FAILED;
