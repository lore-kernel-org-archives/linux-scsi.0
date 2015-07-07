From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 3/3] megaraid_sas : fix whitespace errors
Date: Tue, 07 Jul 2015 15:52:45 -0500
Message-ID: <20150707205245.6218.59809.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35328 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbbGGUwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2015 16:52:49 -0400
Received: by iecuq6 with SMTP id uq6so142838087iec.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2015 13:52:48 -0700 (PDT)
In-Reply-To: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>

Fix whitespace and indentation errors.  No code change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |  244 ++++++++++++++---------------
 1 file changed, 118 insertions(+), 126 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a9bd592..5156faa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -273,6 +273,7 @@ static inline void
 megasas_enable_intr_xscale(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
+
 	regs = instance->reg_set;
 	writel(0, &(regs)->outbound_intr_mask);
 
@@ -289,6 +290,7 @@ megasas_disable_intr_xscale(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
 	u32 mask = 0x1f;
+
 	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
@@ -313,6 +315,7 @@ megasas_clear_intr_xscale(struct megasas_register_set __iomem * regs)
 {
 	u32 status;
 	u32 mfiStatus = 0;
+
 	/*
 	 * Check if it is our interrupt
 	 */
@@ -348,6 +351,7 @@ megasas_fire_cmd_xscale(struct megasas_instance *instance,
 		struct megasas_register_set __iomem *regs)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr >> 3)|(frame_count),
 	       &(regs)->inbound_queue_port);
@@ -364,6 +368,7 @@ megasas_adp_reset_xscale(struct megasas_instance *instance,
 {
 	u32 i;
 	u32 pcidata;
+
 	writel(MFI_ADP_RESET, &regs->inbound_doorbell);
 
 	for (i = 0; i < 3; i++)
@@ -402,7 +407,6 @@ static int
 megasas_check_reset_xscale(struct megasas_instance *instance,
 		struct megasas_register_set __iomem *regs)
 {
-
 	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
 	    (le32_to_cpu(*instance->consumer) ==
 		MEGASAS_ADPRESET_INPROG_SIGN))
@@ -433,7 +437,7 @@ static struct megasas_instance_template megasas_instance_template_xscale = {
 
 /**
 *	The following functions are defined for ppc (deviceid : 0x60)
-* 	controllers
+*	controllers
 */
 
 /**
@@ -444,6 +448,7 @@ static inline void
 megasas_enable_intr_ppc(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
+
 	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
 
@@ -462,6 +467,7 @@ megasas_disable_intr_ppc(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+
 	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
@@ -522,6 +528,7 @@ megasas_fire_cmd_ppc(struct megasas_instance *instance,
 		struct megasas_register_set __iomem *regs)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 			&(regs)->inbound_queue_port);
@@ -566,6 +573,7 @@ static inline void
 megasas_enable_intr_skinny(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
+
 	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_intr_mask);
 
@@ -584,6 +592,7 @@ megasas_disable_intr_skinny(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+
 	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
@@ -634,8 +643,8 @@ megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
 	writel(status, &regs->outbound_intr_status);
 
 	/*
-	* dummy read to flush PCI
-	*/
+	 * dummy read to flush PCI
+	 */
 	readl(&regs->outbound_intr_status);
 
 	return mfiStatus;
@@ -654,6 +663,7 @@ megasas_fire_cmd_skinny(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *regs)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel(upper_32_bits(frame_phys_addr),
 	       &(regs)->inbound_high_queue_port);
@@ -706,6 +716,7 @@ static inline void
 megasas_enable_intr_gen2(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
+
 	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
 
@@ -725,6 +736,7 @@ megasas_disable_intr_gen2(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+
 	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
@@ -750,6 +762,7 @@ megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
 {
 	u32 status;
 	u32 mfiStatus = 0;
+
 	/*
 	 * Check if it is our interrupt
 	 */
@@ -786,6 +799,7 @@ megasas_fire_cmd_gen2(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *regs)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 			&(regs)->inbound_queue_port);
@@ -800,10 +814,10 @@ static int
 megasas_adp_reset_gen2(struct megasas_instance *instance,
 			struct megasas_register_set __iomem *reg_set)
 {
-	u32			retry = 0 ;
-	u32			HostDiag;
-	u32 __iomem		*seq_offset = &reg_set->seq_offset;
-	u32 __iomem		*hostdiag_offset = &reg_set->host_diag;
+	u32 retry = 0 ;
+	u32 HostDiag;
+	u32 __iomem *seq_offset = &reg_set->seq_offset;
+	u32 __iomem *hostdiag_offset = &reg_set->host_diag;
 
 	if (instance->instancet == &megasas_instance_template_skinny) {
 		seq_offset = &reg_set->fusion_seq_offset;
@@ -821,7 +835,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 
 	HostDiag = (u32)readl(hostdiag_offset);
 
-	while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
+	while (!(HostDiag & DIAG_WRITE_ENABLE)) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
 		dev_notice(&instance->pdev->dev, "RESETGEN2: retry=%x, hostdiag=%x\n",
@@ -839,7 +853,7 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 	ssleep(10);
 
 	HostDiag = (u32)readl(hostdiag_offset);
-	while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
+	while (HostDiag & DIAG_RESET_ADAPTER) {
 		msleep(100);
 		HostDiag = (u32)readl(hostdiag_offset);
 		dev_notice(&instance->pdev->dev, "RESET_GEN2: retry=%x, hostdiag=%x\n",
@@ -904,7 +918,6 @@ int
 megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	int seconds;
-
 	struct megasas_header *frame_hdr = &cmd->frame->hdr;
 
 	frame_hdr->cmd_status = MFI_CMD_STATUS_POLL_MODE;
@@ -940,6 +953,7 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd, int timeout)
 {
 	int ret = 0;
+
 	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 
 	instance->instancet->issue_dcmd(instance, cmd);
@@ -1120,7 +1134,7 @@ static u32 megasas_get_frame_count(struct megasas_instance *instance,
 	int num_cnt;
 	int sge_bytes;
 	u32 sge_sz;
-	u32 frame_count=0;
+	u32 frame_count = 0;
 
 	sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
 	    sizeof(struct megasas_sge32);
@@ -1151,14 +1165,14 @@ static u32 megasas_get_frame_count(struct megasas_instance *instance,
 			num_cnt = sge_count - 3;
 	}
 
-	if(num_cnt>0){
+	if (num_cnt > 0) {
 		sge_bytes = sge_sz * num_cnt;
 
 		frame_count = (sge_bytes / MEGAMFI_FRAME_SIZE) +
 		    ((sge_bytes % MEGAMFI_FRAME_SIZE) ? 1 : 0) ;
 	}
 	/* Main frame */
-	frame_count +=1;
+	frame_count += 1;
 
 	if (frame_count > 7)
 		frame_count = 8;
@@ -1215,9 +1229,9 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	memcpy(pthru->cdb, scp->cmnd, scp->cmd_len);
 
 	/*
-	* If the command is for the tape device, set the
-	* pthru timeout to the os layer timeout value.
-	*/
+	 * If the command is for the tape device, set the
+	 * pthru timeout to the os layer timeout value.
+	 */
 	if (scp->device->type == TYPE_TAPE) {
 		if ((scp->request->timeout / HZ) > 0xFFFF)
 			pthru->timeout = cpu_to_le16(0xFFFF);
@@ -1435,7 +1449,7 @@ inline int megasas_cmd_type(struct scsi_cmnd *cmd)
 
  /**
  * megasas_dump_pending_frames -	Dumps the frame address of all pending cmds
- *                              	in FW
+ *					in FW
  * @instance:				Adapter soft state
  */
 static inline void
@@ -1459,7 +1473,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	dev_err(&instance->pdev->dev, "[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
-		if(!cmd->scmd)
+		if (!cmd->scmd)
 			continue;
 		dev_err(&instance->pdev->dev, "[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
 		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
@@ -1471,8 +1485,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			instance->host->host_no, cmd->frame_count, ldio->cmd, ldio->target_id,
 			le32_to_cpu(ldio->start_lba_lo), le32_to_cpu(ldio->start_lba_hi),
 			le32_to_cpu(ldio->sense_buf_phys_addr_lo), sgcount);
-		}
-		else {
+		} else {
 			pthru = (struct megasas_pthru_frame *) cmd->frame;
 			mfi_sgl = &pthru->sgl;
 			sgcount = pthru->sge_count;
@@ -1482,16 +1495,16 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
 			le32_to_cpu(pthru->sense_buf_phys_addr_lo), sgcount);
 		}
-	if(megasas_dbg_lvl & MEGASAS_DBG_LVL){
-		for (n = 0; n < sgcount; n++){
-			if (IS_DMA64)
-				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
-					le32_to_cpu(mfi_sgl->sge64[n].length),
-					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
-			else
-				dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
-					le32_to_cpu(mfi_sgl->sge32[n].length),
-					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
+		if (megasas_dbg_lvl & MEGASAS_DBG_LVL) {
+			for (n = 0; n < sgcount; n++) {
+				if (IS_DMA64)
+					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
+						le32_to_cpu(mfi_sgl->sge64[n].length),
+						le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
+				else
+					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
+						le32_to_cpu(mfi_sgl->sge32[n].length),
+						le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 			}
 		}
 	} /*for max_cmd*/
@@ -1500,9 +1513,8 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 
 		cmd = instance->cmd_list[i];
 
-		if(cmd->sync_cmd == 1){
+		if (cmd->sync_cmd == 1)
 			dev_err(&instance->pdev->dev, "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
-		}
 	}
 	dev_err(&instance->pdev->dev, "[%d]: Dumping Done\n\n",instance->host->host_no);
 }
@@ -1650,8 +1662,8 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
 	/*
-	* The RAID firmware may require extended timeouts.
-	*/
+	 * The RAID firmware may require extended timeouts.
+	 */
 	blk_queue_rq_timeout(sdev->request_queue,
 		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
 
@@ -1660,8 +1672,9 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 
 static int megasas_slave_alloc(struct scsi_device *sdev)
 {
-	u16             pd_index = 0;
+	u16 pd_index = 0;
 	struct megasas_instance *instance ;
+
 	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
 		/*
@@ -1727,8 +1740,7 @@ void megaraid_sas_kill_hba(struct megasas_instance *instance)
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
-		writel(MFI_STOP_ADP,
-			&instance->reg_set->doorbell);
+		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
 		/* Flush */
 		readl(&instance->reg_set->doorbell);
 		if (instance->mpio && instance->requestorId)
@@ -1782,7 +1794,7 @@ static void megasas_complete_cmd_dpc(unsigned long instance_addr)
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
-	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR )
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
 	spin_lock_irqsave(&instance->completion_lock, flags);
@@ -2285,14 +2297,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
 			dev_notice(&instance->pdev->dev, "reset: Stopping HBA.\n");
 			spin_lock_irqsave(&instance->hba_lock, flags);
-			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
+			instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
 			spin_unlock_irqrestore(&instance->hba_lock, flags);
 			return FAILED;
 		}
 
-		reset_index	= 0;
+		reset_index = 0;
 		while (!list_empty(&clist_local)) {
-			reset_cmd	= list_entry((&clist_local)->next,
+			reset_cmd = list_entry((&clist_local)->next,
 						struct megasas_cmd, list);
 			list_del_init(&reset_cmd->list);
 			if (reset_cmd->scmd) {
@@ -2324,7 +2336,6 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 	}
 
 	for (i = 0; i < resetwaittime; i++) {
-
 		int outstanding = atomic_read(&instance->fw_outstanding);
 
 		if (!outstanding)
@@ -2363,10 +2374,8 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		i++;
 	} while (i <= 3);
 
-	if (atomic_read(&instance->fw_outstanding) &&
-					!kill_adapter_flag) {
+	if (atomic_read(&instance->fw_outstanding) && !kill_adapter_flag) {
 		if (instance->disableOnlineCtrlReset == 0) {
-
 			megasas_do_ocr(instance);
 
 			/* wait for 5 secs to let FW finish the pending cmds */
@@ -2384,9 +2393,9 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 					(kill_adapter_flag == 2)) {
 		dev_notice(&instance->pdev->dev, "pending cmds after reset\n");
 		/*
-		* Send signal to FW to stop processing any pending cmds.
-		* The controller will be taken offline by the OS now.
-		*/
+		 * Send signal to FW to stop processing any pending cmds.
+		 * The controller will be taken offline by the OS now.
+		 */
 		if ((instance->pdev->device ==
 			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 			(instance->pdev->device ==
@@ -2399,7 +2408,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 		}
 		megasas_dump_pending_frames(instance);
 		spin_lock_irqsave(&instance->hba_lock, flags);
-		instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
+		instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		return FAILED;
 	}
@@ -2478,14 +2487,10 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
  */
 static int megasas_reset_device(struct scsi_cmnd *scmd)
 {
-	int ret;
-
 	/*
 	 * First wait for all commands to complete
 	 */
-	ret = megasas_generic_reset(scmd);
-
-	return ret;
+	return megasas_generic_reset(scmd);
 }
 
 /**
@@ -2495,6 +2500,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 {
 	int ret;
 	struct megasas_instance *instance;
+
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
 	/*
@@ -2513,7 +2519,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 
 /**
  * megasas_bios_param - Returns disk geometry for a disk
- * @sdev: 		device handle
+ * @sdev:		device handle
  * @bdev:		block device
  * @capacity:		drive capacity
  * @geom:		geometry parameters
@@ -2526,6 +2532,7 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	int sectors;
 	sector_t cylinders;
 	unsigned long tmp;
+
 	/* Default heads (64) & sectors (32) */
 	heads = 64;
 	sectors = 32;
@@ -2572,6 +2579,7 @@ static void
 megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	unsigned long flags;
+
 	/*
 	 * Don't signal app if it is just an aborted previously registered aen
 	 */
@@ -2592,6 +2600,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	if ((instance->unload == 0) &&
 		((instance->issuepend_done == 1))) {
 		struct megasas_aen_event *ev;
+
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
 			dev_err(&instance->pdev->dev, "megasas_service_aen: out of memory\n");
@@ -2651,8 +2660,7 @@ megasas_fw_crash_buffer_show(struct device *cdev,
 
 	buff_addr = (unsigned long) buf;
 
-	if (buff_offset >
-		(instance->fw_crash_buffer_size * dmachunk)) {
+	if (buff_offset > (instance->fw_crash_buffer_size * dmachunk)) {
 		dev_err(&instance->pdev->dev,
 			"Firmware crash dump offset is out of range\n");
 		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
@@ -2664,7 +2672,7 @@ megasas_fw_crash_buffer_show(struct device *cdev,
 
 	src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
 		(buff_offset % dmachunk);
-	memcpy(buf, (void *)src_addr,  size);
+	memcpy(buf, (void *)src_addr, size);
 	spin_unlock_irqrestore(&instance->crashdump_lock, flags);
 
 	return size;
@@ -2724,6 +2732,7 @@ megasas_fw_crash_state_show(struct device *cdev,
 	struct Scsi_Host *shost = class_to_shost(cdev);
 	struct megasas_instance *instance =
 		(struct megasas_instance *) shost->hostdata;
+
 	return snprintf(buf, PAGE_SIZE, "%d\n", instance->fw_crash_state);
 }
 
@@ -2808,8 +2817,6 @@ megasas_complete_abort(struct megasas_instance *instance,
 		cmd->cmd_status_drv = 0;
 		wake_up(&instance->abort_cmd_wait_q);
 	}
-
-	return;
 }
 
 /**
@@ -2817,10 +2824,10 @@ megasas_complete_abort(struct megasas_instance *instance,
  * @instance:			Adapter soft state
  * @cmd:			Command to be completed
  * @alt_status:			If non-zero, use this value as status to
- * 				SCSI mid-layer instead of the value returned
- * 				by the FW. This should be used if caller wants
- * 				an alternate status (as in the case of aborted
- * 				commands)
+ *				SCSI mid-layer instead of the value returned
+ *				by the FW. This should be used if caller wants
+ *				an alternate status (as in the case of aborted
+ *				commands)
  */
 void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
@@ -3001,7 +3008,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 
 /**
  * megasas_issue_pending_cmds_again -	issue all pending cmds
- *                              	in FW again because of the fw reset
+ *					in FW again because of the fw reset
  * @instance:				Adapter soft state
  */
 static inline void
@@ -3019,7 +3026,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	while (!list_empty(&clist_local)) {
-		cmd	= list_entry((&clist_local)->next,
+		cmd = list_entry((&clist_local)->next,
 					struct megasas_cmd, list);
 		list_del_init(&cmd->list);
 
@@ -3052,7 +3059,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 						"issue it again.\n", cmd);
 			cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 			instance->instancet->fire_cmd(instance,
-							cmd->frame_phys_addr ,
+							cmd->frame_phys_addr,
 							0, instance->reg_set);
 		} else if (cmd->scmd) {
 			dev_notice(&instance->pdev->dev, "%p scsi cmd [%02x]"
@@ -3074,12 +3081,12 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 		dev_notice(&instance->pdev->dev, "aen_cmd in def process\n");
 		megasas_return_cmd(instance, instance->aen_cmd);
 
-		instance->aen_cmd	= NULL;
+		instance->aen_cmd = NULL;
 	}
 
 	/*
-	* Initiate AEN (Asynchronous Event Notification)
-	*/
+	 * Initiate AEN (Asynchronous Event Notification)
+	 */
 	seq_num = instance->last_seq_num;
 	class_locale.members.reserved = 0;
 	class_locale.members.locale = MR_EVT_LOCALE_ALL;
@@ -3106,7 +3113,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 	u32 defer_index;
 	unsigned long flags;
 
-	defer_index     = 0;
+	defer_index = 0;
 	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
 	for (i = 0; i < max_cmd; i++) {
 		cmd = instance->cmd_list[i];
@@ -3155,7 +3162,7 @@ process_fw_state_change_wq(struct work_struct *work)
 
 		atomic_set(&instance->fw_reset_no_pci_access, 1);
 		instance->instancet->adp_reset(instance, instance->reg_set);
-		atomic_set(&instance->fw_reset_no_pci_access, 0 );
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
 
 		dev_notice(&instance->pdev->dev, "FW restarted successfully,"
 					"initiating next stage...\n");
@@ -3163,7 +3170,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		dev_notice(&instance->pdev->dev, "HBA recovery state machine,"
 					"state 2 starting...\n");
 
-		/*waitting for about 20 second before start the second init*/
+		/* waiting for about 20 second before start the second init */
 		for (wait = 0; wait < 30; wait++) {
 			msleep(1000);
 		}
@@ -3196,15 +3203,14 @@ process_fw_state_change_wq(struct work_struct *work)
 		megasas_issue_pending_cmds_again(instance);
 		instance->issuepend_done = 1;
 	}
-	return ;
 }
 
 /**
  * megasas_deplete_reply_queue -	Processes all completed commands
  * @instance:				Adapter soft state
  * @alt_status:				Alternate status to be returned to
- * 					SCSI mid-layer instead of the status
- * 					returned by the FW
+ *					SCSI mid-layer instead of the status
+ *					returned by the FW
  * Note: this must be called with hba lock held
  */
 static int
@@ -3284,13 +3290,13 @@ static irqreturn_t megasas_isr(int irq, void *devp)
 	struct megasas_irq_context *irq_context = devp;
 	struct megasas_instance *instance = irq_context->instance;
 	unsigned long flags;
-	irqreturn_t	rc;
+	irqreturn_t rc;
 
 	if (atomic_read(&instance->fw_reset_no_pci_access))
 		return IRQ_HANDLED;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
-	rc =  megasas_deplete_reply_queue(instance, DID_OK);
+	rc = megasas_deplete_reply_queue(instance, DID_OK);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	return rc;
@@ -3566,9 +3572,8 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 	sge_sz = (IS_DMA64) ? sizeof(struct megasas_sge64) :
 	    sizeof(struct megasas_sge32);
 
-	if (instance->flag_ieee) {
+	if (instance->flag_ieee)
 		sge_sz = sizeof(struct megasas_sge_skinny);
-	}
 
 	/*
 	 * For MFI controllers.
@@ -3652,6 +3657,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 void megasas_free_cmds(struct megasas_instance *instance)
 {
 	int i;
+
 	/* First free the MFI frame pool */
 	megasas_teardown_frame_pool(instance);
 
@@ -3807,12 +3813,12 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		ret = megasas_issue_polled(instance, cmd);
 
 	/*
-	* the following function will get the instance PD LIST.
-	*/
+	 * the following function will get the instance PD LIST.
+	 */
 
 	pd_addr = ci->addr;
 
-	if ( ret == 0 &&
+	if (ret == 0 &&
 	     (le32_to_cpu(ci->count) <
 		  (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL))) {
 
@@ -4048,11 +4054,11 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		instance->supportmax256vd ? "Extended VD(240 VD)firmware" :
 		"Legacy(64 VD) firmware");
 
-	old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
+	old_map_sz = sizeof(struct MR_FW_RAID_MAP) +
 				(sizeof(struct MR_LD_SPAN_MAP) *
 				(instance->fw_supported_vd_count - 1));
-	new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
-	fusion->drv_map_sz =  sizeof(struct MR_DRV_RAID_MAP) +
+	new_map_sz = sizeof(struct MR_FW_RAID_MAP_EXT);
+	fusion->drv_map_sz = sizeof(struct MR_DRV_RAID_MAP) +
 				(sizeof(struct MR_LD_SPAN_MAP) *
 				(instance->drv_supported_vd_count - 1));
 
@@ -4063,7 +4069,6 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		fusion->current_map_sz = new_map_sz;
 	else
 		fusion->current_map_sz = old_map_sz;
-
 }
 
 /**
@@ -4210,9 +4215,7 @@ static int
 megasas_issue_init_mfi(struct megasas_instance *instance)
 {
 	__le32 context;
-
 	struct megasas_cmd *cmd;
-
 	struct megasas_init_frame *init_frame;
 	struct megasas_init_queue_info *initq_info;
 	dma_addr_t init_frame_h;
@@ -4651,10 +4654,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	dev_err(&instance->pdev->dev, "INIT adapter done\n");
 
 	/** for passthrough
-	* the following function will get the PD LIST.
-	*/
-
-	memset(instance->pd_list, 0 ,
+	 * the following function will get the PD LIST.
+	 */
+	memset(instance->pd_list, 0,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		dev_err(&instance->pdev->dev, "failed to get PD list\n");
@@ -4682,7 +4684,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		le16_to_cpu(ctrl_info->max_strips_per_io);
 	max_sectors_2 = le32_to_cpu(ctrl_info->max_request_size);
 
-	tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
+	tmp_sectors = min_t(u32, max_sectors_1, max_sectors_2);
 
 	instance->disableOnlineCtrlReset =
 	ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
@@ -5047,7 +5049,7 @@ static int megasas_start_aen(struct megasas_instance *instance)
 static int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
-	u32		error;
+	u32 error;
 
 	/*
 	 * Export parameters required by SCSI mid-layer
@@ -5122,7 +5124,7 @@ static int
 megasas_set_dma_mask(struct pci_dev *pdev)
 {
 	/*
-	 * All our contollers are capable of performing 64-bit DMA
+	 * All our controllers are capable of performing 64-bit DMA
 	 */
 	if (IS_DMA64) {
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
@@ -5208,7 +5210,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	instance = (struct megasas_instance *)host->hostdata;
 	memset(instance, 0, sizeof(*instance));
-	atomic_set( &instance->fw_reset_no_pci_access, 0 );
+	atomic_set(&instance->fw_reset_no_pci_access, 0);
 	instance->pdev = pdev;
 
 	switch (instance->pdev->device) {
@@ -5405,8 +5407,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 	return 0;
 
-      fail_start_aen:
-      fail_io_attach:
+fail_start_aen:
+fail_io_attach:
 	megasas_mgmt_info.count--;
 	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 	megasas_mgmt_info.max_index--;
@@ -5424,7 +5426,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 fail_init_mfi:
-      fail_alloc_dma_buf:
+fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 				    instance->evt_detail,
@@ -5438,8 +5440,8 @@ fail_init_mfi:
 				    instance->consumer_h);
 	scsi_host_put(host);
 
-      fail_alloc_instance:
-      fail_set_dma_mask:
+fail_alloc_instance:
+fail_set_dma_mask:
 	pci_disable_device(pdev);
 
 	return -ENODEV;
@@ -5481,8 +5483,6 @@ static void megasas_flush_cache(struct megasas_instance *instance)
 			" from %s\n", __func__);
 
 	megasas_return_cmd(instance, cmd);
-
-	return;
 }
 
 /**
@@ -5528,8 +5528,6 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 			"from %s\n", __func__);
 
 	megasas_return_cmd(instance, cmd);
-
-	return;
 }
 
 #ifdef CONFIG_PM
@@ -5835,8 +5833,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	scsi_host_put(host);
 
 	pci_disable_device(pdev);
-
-	return;
 }
 
 /**
@@ -5905,11 +5901,11 @@ static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
 {
 	unsigned int mask;
 	unsigned long flags;
+
 	poll_wait(file, &megasas_poll_wait, wait);
 	spin_lock_irqsave(&poll_aen_lock, flags);
 	if (megasas_poll_wait_aen)
-		mask =   (POLLIN | POLLRDNORM);
-
+		mask = (POLLIN | POLLRDNORM);
 	else
 		mask = 0;
 	megasas_poll_wait_aen = 0;
@@ -5923,8 +5919,7 @@ static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
  * @cmd:	MFI command frame
  */
 
-static int megasas_set_crash_dump_params_ioctl(
-	struct megasas_cmd *cmd)
+static int megasas_set_crash_dump_params_ioctl(struct megasas_cmd *cmd)
 {
 	struct megasas_instance *local_instance;
 	int i, error = 0;
@@ -6120,7 +6115,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		error = -EFAULT;
 	}
 
-      out:
+out:
 	if (sense) {
 		dma_free_coherent(&instance->pdev->dev, ioc->sense_len,
 				    sense, sense_handle);
@@ -6220,10 +6215,10 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
-      out_up:
+out_up:
 	up(&instance->ioctl_sem);
 
-      out_kfree_ioc:
+out_kfree_ioc:
 	kfree(ioc);
 	return error;
 }
@@ -6458,7 +6453,8 @@ static ssize_t
 megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t count)
 {
 	int retval = count;
-	if(sscanf(buf,"%u",&megasas_dbg_lvl)<1){
+
+	if (sscanf(buf,"%u",&megasas_dbg_lvl) < 1) {
 		printk(KERN_ERR "megasas: could not set dbg_lvl\n");
 		retval = -EINVAL;
 	}
@@ -6520,14 +6516,12 @@ megasas_aen_polling(struct work_struct *work)
 				pd_index =
 				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
 
-				sdev1 =
-				scsi_device_lookup(host, i, j, 0);
+				sdev1 = scsi_device_lookup(host, i, j, 0);
 
 				if (instance->pd_list[pd_index].driveState
 						== MR_PD_STATE_SYSTEM) {
-						if (!sdev1) {
+					if (!sdev1)
 						scsi_add_device(host, i, j, 0);
-						}
 
 					if (sdev1)
 						scsi_device_put(sdev1);
@@ -6548,14 +6542,12 @@ megasas_aen_polling(struct work_struct *work)
 				pd_index =
 				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
 
-				sdev1 =
-				scsi_device_lookup(host, i, j, 0);
+				sdev1 = scsi_device_lookup(host, i, j, 0);
 
 				if (instance->pd_list[pd_index].driveState
 					== MR_PD_STATE_SYSTEM) {
-					if (sdev1) {
+					if (sdev1)
 						scsi_device_put(sdev1);
-					}
 				} else {
 					if (sdev1) {
 						scsi_remove_device(sdev1);
@@ -6701,7 +6693,7 @@ megasas_aen_polling(struct work_struct *work)
 		}
 	}
 
-	if ( instance->aen_cmd != NULL ) {
+	if (instance->aen_cmd != NULL) {
 		kfree(ev);
 		return ;
 	}

