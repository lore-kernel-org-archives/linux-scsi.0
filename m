From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 09/17] mpt2sas: print level KERN_DEBUG is replaced by KERN_INFO
Date: Thu, 17 Jun 2010 13:43:57 +0530
Message-ID: <20100617081357.GJ28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:56968 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab0FQIti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:49:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Converting print level from  MPT2SAS_DEBUG_FMT  to MPT2SAS_INFO_FMT.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 93c0623..3774b07 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1242,7 +1242,7 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	u64 pio_chip = 0;
 	u64 chip_phys = 0;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n",
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n",
 	    ioc->name, __func__));
 
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
@@ -1865,7 +1865,7 @@ _base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
 static void
 _base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
 {
-	dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	if (ioc->request) {
@@ -1951,7 +1951,7 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 	u32 retry_sz;
 	u16 max_request_credit;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	retry_sz = 0;
@@ -2378,7 +2378,7 @@ _base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
-			dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successfull count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
 			return 0;
@@ -2419,7 +2419,7 @@ _base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
 		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
-			dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successfull count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
 			return 0;
@@ -2467,7 +2467,7 @@ _base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	do {
 		doorbell_reg = readl(&ioc->chip->Doorbell);
 		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
-			dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successfull count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
 			return 0;
@@ -2641,9 +2641,9 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 
 	if (ioc->logging_level & MPT_DEBUG_INIT) {
 		mfp = (u32 *)reply;
-		printk(KERN_DEBUG "\toffset:data\n");
+		printk(KERN_INFO "\toffset:data\n");
 		for (i = 0; i < reply_bytes/4; i++)
-			printk(KERN_DEBUG "\t[0x%02x]:%08x\n", i*4,
+			printk(KERN_INFO "\t[0x%02x]:%08x\n", i*4,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
@@ -2676,7 +2676,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	void *request;
 	u16 wait_state_count;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	mutex_lock(&ioc->base_cmds.mutex);
@@ -2781,7 +2781,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	void *request;
 	u16 wait_state_count;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	mutex_lock(&ioc->base_cmds.mutex);
@@ -2869,7 +2869,7 @@ _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int sleep_flag)
 	Mpi2PortFactsReply_t mpi_reply, *pfacts;
 	int mpi_reply_sz, mpi_request_sz, r;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	mpi_reply_sz = sizeof(Mpi2PortFactsReply_t);
@@ -2911,7 +2911,7 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	Mpi2IOCFactsReply_t mpi_reply, *facts;
 	int mpi_reply_sz, mpi_request_sz, r;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
@@ -2983,7 +2983,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	struct timeval current_time;
 	u16 ioc_status;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	memset(&mpi_request, 0, sizeof(Mpi2IOCInitRequest_t));
@@ -3044,9 +3044,9 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		int i;
 
 		mfp = (u32 *)&mpi_request;
-		printk(KERN_DEBUG "\toffset:data\n");
+		printk(KERN_INFO "\toffset:data\n");
 		for (i = 0; i < sizeof(Mpi2IOCInitRequest_t)/4; i++)
-			printk(KERN_DEBUG "\t[0x%02x]:%08x\n", i*4,
+			printk(KERN_INFO "\t[0x%02x]:%08x\n", i*4,
 			    le32_to_cpu(mfp[i]));
 	}
 
@@ -3125,7 +3125,7 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 			r = -ETIME;
 		goto out;
 	} else
-		dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: complete\n",
+		dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: complete\n",
 		    ioc->name, __func__));
 
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_OPERATIONAL,
@@ -3185,7 +3185,7 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	int r = 0;
 	int i;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	if (ioc->base_cmds.status & MPT2_CMD_PENDING) {
@@ -3223,7 +3223,7 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		else
 			r = -ETIME;
 	} else
-		dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: complete\n",
+		dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: complete\n",
 		    ioc->name, __func__));
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 	return r;
@@ -3285,7 +3285,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	_base_save_msix_table(ioc);
 
-	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "clear interrupts\n",
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
 	    ioc->name));
 
 	count = 0;
@@ -3293,7 +3293,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		/* Write magic sequence to WriteSequence register
 		 * Loop until in diagnostic mode
 		 */
-		drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "write magic "
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "write magic "
 		    "sequence\n", ioc->name));
 		writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
 		writel(MPI2_WRSEQ_1ST_KEY_VALUE, &ioc->chip->WriteSequence);
@@ -3313,7 +3313,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 			goto out;
 
 		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
-		drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "wrote magic "
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "wrote magic "
 		    "sequence: count(%d), host_diagnostic(0x%08x)\n",
 		    ioc->name, count, host_diagnostic));
 
@@ -3321,7 +3321,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	hcb_size = readl(&ioc->chip->HCBSize);
 
-	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "diag reset: issued\n",
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "diag reset: issued\n",
 	    ioc->name));
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
 	     &ioc->chip->HostDiagnostic);
@@ -3348,29 +3348,29 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 
 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
 
-		drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "restart the adapter "
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "restart the adapter "
 		    "assuming the HCB Address points to good F/W\n",
 		    ioc->name));
 		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
 		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
 		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
 
-		drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "re-enable the HCDW\n", ioc->name));
 		writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
 		    &ioc->chip->HCBSize);
 	}
 
-	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "restart the adapter\n",
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "restart the adapter\n",
 	    ioc->name));
 	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
 	    &ioc->chip->HostDiagnostic);
 
-	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "disable writes to the "
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "disable writes to the "
 	    "diagnostic register\n", ioc->name));
 	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
 
-	drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "Wait for FW to go to the "
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "Wait for FW to go to the "
 	    "READY state\n", ioc->name));
 	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20,
 	    sleep_flag);
@@ -3404,18 +3404,18 @@ _base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	u32 ioc_state;
 	int rc;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 0);
-	dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: ioc_state(0x%08x)\n",
+	dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: ioc_state(0x%08x)\n",
 	    ioc->name, __func__, ioc_state));
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY)
 		return 0;
 
 	if (ioc_state & MPI2_DOORBELL_USED) {
-		dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "unexpected doorbell "
+		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "unexpected doorbell "
 		    "active!\n", ioc->name));
 		goto issue_diag_reset;
 	}
@@ -3458,7 +3458,7 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	u16 smid;
 	struct _tr_list *delayed_tr, *delayed_tr_next;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	/* clean the delayed target reset list */
@@ -3554,7 +3554,7 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 {
 	struct pci_dev *pdev = ioc->pdev;
 
-	dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	_base_mask_interrupts(ioc);
@@ -3587,7 +3587,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 {
 	int r, i;
 
-	dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	r = mpt2sas_base_map_resources(ioc);
@@ -3719,7 +3719,7 @@ void
 mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 {
 
-	dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dexitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	mpt2sas_base_stop_watchdog(ioc);
@@ -3752,11 +3752,11 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
 		break;
 	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
 		if (ioc->transport_cmds.status & MPT2_CMD_PENDING) {
 			ioc->transport_cmds.status |= MPT2_CMD_RESET;
@@ -3776,7 +3776,7 @@ _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		}
 		break;
 	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
@@ -3836,7 +3836,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	int r;
 	unsigned long flags;
 
-	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	if (mpt2sas_fwfault_debug)
@@ -3854,7 +3854,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 		do {
 			ssleep(1);
 		} while (ioc->shost_recovery == 1);
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: exit\n", ioc->name,
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 		    __func__));
 		return ioc->ioc_reset_in_progress_status;
 	}
@@ -3874,7 +3874,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);
  out:
-	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: %s\n",
+	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: %s\n",
 	    ioc->name, __func__, ((r == 0) ? "SUCCESS" : "FAILED")));
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
@@ -3884,7 +3884,7 @@ mpt2sas_base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
-	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: exit\n", ioc->name,
+	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
 }
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index ffe9398..08404b3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -124,7 +124,6 @@
  * logging format
  */
 #define MPT2SAS_FMT			"%s: "
-#define MPT2SAS_DEBUG_FMT		KERN_DEBUG MPT2SAS_FMT
 #define MPT2SAS_INFO_FMT		KERN_INFO MPT2SAS_FMT
 #define MPT2SAS_NOTE_FMT		KERN_NOTICE MPT2SAS_FMT
 #define MPT2SAS_WARN_FMT		KERN_WARNING MPT2SAS_FMT
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index c654429..e26f920 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -159,7 +159,7 @@ _config_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	if (!desc)
 		return;
 
-	printk(MPT2SAS_DEBUG_FMT "%s: %s(%d), action(%d), form(0x%08x), "
+	printk(MPT2SAS_INFO_FMT "%s: %s(%d), action(%d), form(0x%08x), "
 	    "smid(%d)\n", ioc->name, calling_function_name, desc,
 	    mpi_request->Header.PageNumber, mpi_request->Action,
 	    le32_to_cpu(mpi_request->PageAddress), smid);
@@ -168,7 +168,7 @@ _config_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 		return;
 
 	if (mpi_reply->IOCStatus || mpi_reply->IOCLogInfo)
-		printk(MPT2SAS_DEBUG_FMT
+		printk(MPT2SAS_INFO_FMT
 		    "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
 		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
 		    le32_to_cpu(mpi_reply->IOCLogInfo));
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 371f063..55fbd5b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -188,14 +188,14 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	if (!desc)
 		return;
 
-	printk(MPT2SAS_DEBUG_FMT "%s: %s, smid(%d)\n",
+	printk(MPT2SAS_INFO_FMT "%s: %s, smid(%d)\n",
 	    ioc->name, calling_function_name, desc, smid);
 
 	if (!mpi_reply)
 		return;
 
 	if (mpi_reply->IOCStatus || mpi_reply->IOCLogInfo)
-		printk(MPT2SAS_DEBUG_FMT
+		printk(MPT2SAS_INFO_FMT
 		    "\tiocstatus(0x%04x), loginfo(0x%08x)\n",
 		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
 		    le32_to_cpu(mpi_reply->IOCLogInfo));
@@ -206,7 +206,7 @@ _ctl_display_some_debug(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 		Mpi2SCSIIOReply_t *scsi_reply =
 		    (Mpi2SCSIIOReply_t *)mpi_reply;
 		if (scsi_reply->SCSIState || scsi_reply->SCSIStatus)
-			printk(MPT2SAS_DEBUG_FMT
+			printk(MPT2SAS_INFO_FMT
 			    "\tscsi_state(0x%02x), scsi_status"
 			    "(0x%02x)\n", ioc->name,
 			    scsi_reply->SCSIState,
@@ -392,7 +392,7 @@ mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
 		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
 			if (!(ioc->diag_buffer_status[i] &
@@ -405,7 +405,7 @@ mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		}
 		break;
 	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
 		if (ioc->ctl_cmds.status & MPT2_CMD_PENDING) {
 			ioc->ctl_cmds.status |= MPT2_CMD_RESET;
@@ -414,7 +414,7 @@ mpt2sas_ctl_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		}
 		break;
 	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 
 		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
@@ -531,7 +531,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 	if (!found) {
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "handle(0x%04x), lun(%d), no active mid!!\n", ioc->name,
 		    desc, le16_to_cpu(tm_request->DevHandle), lun));
 		tm_reply = ioc->ctl_cmds.reply;
@@ -549,7 +549,7 @@ _ctl_set_task_mid(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command *karg,
 		return 1;
 	}
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 	    "handle(0x%04x), lun(%d), task_mid(%d)\n", ioc->name,
 	    desc, le16_to_cpu(tm_request->DevHandle), lun,
 	     le16_to_cpu(tm_request->TaskMID)));
@@ -756,7 +756,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		Mpi2SCSITaskManagementRequest_t *tm_request =
 		    (Mpi2SCSITaskManagementRequest_t *)mpi_request;
 
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "TASK_MGMT: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "TASK_MGMT: "
 		    "handle(0x%04x), task_type(0x%02x)\n", ioc->name,
 		    le16_to_cpu(tm_request->DevHandle), tm_request->TaskType));
 
@@ -851,7 +851,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		Mpi2SCSITaskManagementReply_t *tm_reply =
 		    (Mpi2SCSITaskManagementReply_t *)mpi_reply;
 
-		printk(MPT2SAS_DEBUG_FMT "TASK_MGMT: "
+		printk(MPT2SAS_INFO_FMT "TASK_MGMT: "
 		    "IOCStatus(0x%04x), IOCLogInfo(0x%08x), "
 		    "TerminationCount(0x%08x)\n", ioc->name,
 		    le16_to_cpu(tm_reply->IOCStatus),
@@ -950,7 +950,7 @@ _ctl_getiocinfo(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	memset(&karg, 0 , sizeof(karg));
@@ -998,7 +998,7 @@ _ctl_eventquery(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	karg.event_entries = MPT2SAS_CTL_EVENT_LOG_SIZE;
@@ -1031,7 +1031,7 @@ _ctl_eventenable(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	if (ioc->event_log)
@@ -1073,7 +1073,7 @@ _ctl_eventreport(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	number_bytes = karg.hdr.max_data_size -
@@ -1118,7 +1118,7 @@ _ctl_do_reset(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	retval = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
@@ -1219,7 +1219,7 @@ _ctl_btdh_mapping(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	rc = _ctl_btdh_search_sas_device(ioc, &karg);
@@ -1288,7 +1288,7 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 	u16 ioc_status;
 	u8 issue_reset = 0;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	if (ioc->ctl_cmds.status != MPT2_CMD_NOT_USED) {
@@ -1376,7 +1376,7 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(0x%p), "
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: diag_buffer(0x%p), "
 	    "dma(0x%llx), sz(%d)\n", ioc->name, __func__, request_data,
 	    (unsigned long long)request_data_dma,
 	    le32_to_cpu(mpi_request->BufferLength)));
@@ -1414,10 +1414,10 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 			MPT2_DIAG_BUFFER_IS_REGISTERED;
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: success\n",
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: success\n",
 		    ioc->name, __func__));
 	} else {
-		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
+		printk(MPT2SAS_INFO_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
 		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
@@ -1541,7 +1541,7 @@ _ctl_diag_unregister(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
@@ -1611,7 +1611,7 @@ _ctl_diag_query(void __user *arg)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	karg.application_flags = 0;
@@ -1689,7 +1689,7 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 	int rc;
 	unsigned long timeleft;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	rc = 0;
@@ -1697,7 +1697,7 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "skipping due to FAULT state\n", ioc->name,
 		    __func__));
 		rc = -EAGAIN;
@@ -1759,10 +1759,10 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 		    MPT2_DIAG_BUFFER_IS_RELEASED;
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: success\n",
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: success\n",
 		    ioc->name, __func__));
 	} else {
-		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
+		printk(MPT2SAS_INFO_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
 		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
@@ -1800,7 +1800,7 @@ _ctl_diag_release(void __user *arg, enum block_state state)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
@@ -1896,7 +1896,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	if (_ctl_verify_adapter(karg.hdr.ioc_number, &ioc) == -1 || !ioc)
 		return -ENODEV;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\n", ioc->name,
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
 	buffer_type = karg.unique_id & 0x000000ff;
@@ -1927,7 +1927,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	}
 
 	diag_data = (void *)(request_data + karg.starting_offset);
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: diag_buffer(%p), "
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: diag_buffer(%p), "
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
@@ -1942,11 +1942,11 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	if ((karg.flags & MPT2_FLAGS_REREGISTER) == 0)
 		return 0;
 
-	dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: Reregister "
+	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: Reregister "
 		"buffer_type(0x%02x)\n", ioc->name, __func__, buffer_type));
 	if ((ioc->diag_buffer_status[buffer_type] &
 	    MPT2_DIAG_BUFFER_IS_RELEASED) == 0) {
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "buffer_type(0x%02x) is still registered\n", ioc->name,
 		     __func__, buffer_type));
 		return 0;
@@ -2020,10 +2020,10 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
 		ioc->diag_buffer_status[buffer_type] |=
 		    MPT2_DIAG_BUFFER_IS_REGISTERED;
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: success\n",
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: success\n",
 		    ioc->name, __func__));
 	} else {
-		printk(MPT2SAS_DEBUG_FMT "%s: ioc_status(0x%04x) "
+		printk(MPT2SAS_INFO_FMT "%s: ioc_status(0x%04x) "
 		    "log_info(0x%08x)\n", ioc->name, __func__,
 		    ioc_status, le32_to_cpu(mpi_reply->IOCLogInfo));
 		rc = -EFAULT;
@@ -2140,7 +2140,7 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg)
 		    !ioc)
 			return -ENODEV;
 
-		dctlprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		dctlprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "unsupported ioctl opcode(0x%08x)\n", ioc->name, cmd));
 		break;
 	}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 87c6865..82c2d4c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -435,7 +435,7 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
 		    (ioc->bios_pg2.ReqBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.RequestedBootDevice)) {
-			dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+			dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
 			   "%s: req_boot_device(0x%016llx)\n",
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
@@ -450,7 +450,7 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
 		    (ioc->bios_pg2.ReqAltBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.RequestedAltBootDevice)) {
-			dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+			dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
 			   "%s: req_alt_boot_device(0x%016llx)\n",
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
@@ -465,7 +465,7 @@ _scsih_determine_boot_device(struct MPT2SAS_ADAPTER *ioc,
 		    (ioc->bios_pg2.CurrentBootDeviceForm &
 		    MPI2_BIOSPAGE2_FORM_MASK),
 		    &ioc->bios_pg2.CurrentBootDevice)) {
-			dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+			dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
 			   "%s: current_boot_device(0x%016llx)\n",
 			    ioc->name, __func__,
 			    (unsigned long long)sas_address));
@@ -566,7 +566,7 @@ _scsih_sas_device_add(struct MPT2SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: handle"
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle"
 	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
@@ -593,7 +593,7 @@ _scsih_sas_device_init_add(struct MPT2SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: handle"
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle"
 	    "(0x%04x), sas_addr(0x%016llx)\n", ioc->name, __func__,
 	    sas_device->handle, (unsigned long long)sas_device->sas_address));
 
@@ -695,7 +695,7 @@ _scsih_raid_device_add(struct MPT2SAS_ADAPTER *ioc,
 {
 	unsigned long flags;
 
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: handle"
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle"
 	    "(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
 	    raid_device->handle, (unsigned long long)raid_device->wwid));
 
@@ -2002,7 +2002,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 0);
 	if (ioc_state & MPI2_DOORBELL_USED) {
-		dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "unexpected doorbell "
+		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "unexpected doorbell "
 		    "active!\n", ioc->name));
 		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
@@ -2806,7 +2806,7 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_ES_RESPONDING) {
 			if (le16_to_cpu(local_event_data->ExpanderDevHandle) ==
 			    expander_handle) {
-				dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+				dewtprintk(ioc, printk(MPT2SAS_INFO_FMT
 				    "setting ignoring flag\n", ioc->name));
 				fw_event->ignore = 1;
 			}
@@ -4347,9 +4347,9 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		status_str = "unknown status";
 		break;
 	}
-	printk(MPT2SAS_DEBUG_FMT "sas topology change: (%s)\n",
+	printk(MPT2SAS_INFO_FMT "sas topology change: (%s)\n",
 	    ioc->name, status_str);
-	printk(KERN_DEBUG "\thandle(0x%04x), enclosure_handle(0x%04x) "
+	printk(KERN_INFO "\thandle(0x%04x), enclosure_handle(0x%04x) "
 	    "start_phy(%02d), count(%d)\n",
 	    le16_to_cpu(event_data->ExpanderDevHandle),
 	    le16_to_cpu(event_data->EnclosureHandle),
@@ -4383,7 +4383,7 @@ _scsih_sas_topology_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		}
 		link_rate = event_data->PHY[i].LinkRate >> 4;
 		prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
-		printk(KERN_DEBUG "\tphy(%02d), attached_handle(0x%04x): %s:"
+		printk(KERN_INFO "\tphy(%02d), attached_handle(0x%04x): %s:"
 		    " link rate: new(0x%02x), old(0x%02x)\n", phy_number,
 		    handle, status_str, link_rate, prev_link_rate);
 
@@ -4427,7 +4427,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 		_scsih_sas_host_refresh(ioc);
 
 	if (fw_event->ignore) {
-		dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "ignoring expander "
+		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "ignoring expander "
 		    "event\n", ioc->name));
 		return;
 	}
@@ -4453,7 +4453,7 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc,
 	/* handle siblings events */
 	for (i = 0; i < event_data->NumEntries; i++) {
 		if (fw_event->ignore) {
-			dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "ignoring "
+			dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "ignoring "
 			    "expander event\n", ioc->name));
 			return;
 		}
@@ -4573,12 +4573,12 @@ _scsih_sas_device_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		reason_str = "unknown reason";
 		break;
 	}
-	printk(MPT2SAS_DEBUG_FMT "device status change: (%s)\n"
+	printk(MPT2SAS_INFO_FMT "device status change: (%s)\n"
 	    "\thandle(0x%04x), sas address(0x%016llx)", ioc->name,
 	    reason_str, le16_to_cpu(event_data->DevHandle),
 	    (unsigned long long)le64_to_cpu(event_data->SASAddress));
 	if (event_data->ReasonCode == MPI2_EVENT_SAS_DEV_STAT_RC_SMART_DATA)
-		printk(MPT2SAS_DEBUG_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
+		printk(MPT2SAS_INFO_FMT ", ASC(0x%x), ASCQ(0x%x)\n", ioc->name,
 		    event_data->ASC, event_data->ASCQ);
 	printk(KERN_INFO "\n");
 }
@@ -4662,7 +4662,7 @@ _scsih_sas_enclosure_dev_status_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 		break;
 	}
 
-	printk(MPT2SAS_DEBUG_FMT "enclosure status change: (%s)\n"
+	printk(MPT2SAS_INFO_FMT "enclosure status change: (%s)\n"
 	    "\thandle(0x%04x), enclosure logical id(0x%016llx)"
 	    " number slots(%d)\n", ioc->name, reason_str,
 	    le16_to_cpu(event_data->EnclosureHandle),
@@ -4713,10 +4713,10 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event->event_data;
 #endif
 	u16 ioc_status;
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "broadcast primative: "
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "broadcast primative: "
 	    "phy number(%d), width(%d)\n", ioc->name, event_data->PhyNum,
 	    event_data->PortWidth));
-	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: enter\n", ioc->name,
+	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
 	termination_count = 0;
@@ -4760,7 +4760,7 @@ _scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
 	}
 	ioc->broadcast_aen_busy = 0;
 
-	dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT
 	    "%s - exit, query_count = %d termination_count = %d\n",
 	    ioc->name, __func__, query_count, termination_count));
 }
@@ -4781,7 +4781,7 @@ _scsih_sas_discovery_event(struct MPT2SAS_ADAPTER *ioc,
 
 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) {
-		printk(MPT2SAS_DEBUG_FMT "discovery event: (%s)", ioc->name,
+		printk(MPT2SAS_INFO_FMT "discovery event: (%s)", ioc->name,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 	if (event_data->DiscoveryStatus)
@@ -5075,7 +5075,7 @@ _scsih_sas_ir_config_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
 
-	printk(MPT2SAS_DEBUG_FMT "raid config change: (%s), elements(%d)\n",
+	printk(MPT2SAS_INFO_FMT "raid config change: (%s), elements(%d)\n",
 	    ioc->name, (le32_to_cpu(event_data->Flags) &
 	    MPI2_EVENT_IR_CHANGE_FLAGS_FOREIGN_CONFIG) ?
 	    "foreign" : "native", event_data->NumElements);
@@ -5128,7 +5128,7 @@ _scsih_sas_ir_config_change_event_debug(struct MPT2SAS_ADAPTER *ioc,
 			element_str = "unknown element";
 			break;
 		}
-		printk(KERN_DEBUG "\t(%s:%s), vol handle(0x%04x), "
+		printk(KERN_INFO "\t(%s:%s), vol handle(0x%04x), "
 		    "pd handle(0x%04x), pd num(0x%02x)\n", element_str,
 		    reason_str, le16_to_cpu(element->VolDevHandle),
 		    le16_to_cpu(element->PhysDiskDevHandle),
@@ -5218,7 +5218,7 @@ _scsih_sas_ir_volume_event(struct MPT2SAS_ADAPTER *ioc,
 
 	handle = le16_to_cpu(event_data->VolDevHandle);
 	state = le32_to_cpu(event_data->NewValue);
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: handle(0x%04x), "
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle(0x%04x), "
 	    "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,  handle,
 	    le32_to_cpu(event_data->PreviousValue), state));
 
@@ -5306,7 +5306,7 @@ _scsih_sas_ir_physical_disk_event(struct MPT2SAS_ADAPTER *ioc,
 	handle = le16_to_cpu(event_data->PhysDiskDevHandle);
 	state = le32_to_cpu(event_data->NewValue);
 
-	dewtprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: handle(0x%04x), "
+	dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: handle(0x%04x), "
 	    "old(0x%08x), new(0x%08x)\n", ioc->name, __func__,  handle,
 	    le32_to_cpu(event_data->PreviousValue), state));
 
@@ -5494,7 +5494,7 @@ _scsih_task_set_full(struct MPT2SAS_ADAPTER *ioc, struct fw_event_work
 	}
 
 	if (ioc->logging_level & MPT_DEBUG_TASK_SET_FULL)
-		starget_printk(KERN_DEBUG, sas_device->starget, "task set "
+		starget_printk(KERN_INFO, sas_device->starget, "task set "
 		    "full: handle(0x%04x), sas_addr(0x%016llx), depth(%d)\n",
 		    handle, (unsigned long long)sas_address, current_depth);
 
@@ -5885,11 +5885,11 @@ mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_PRE_RESET\n", ioc->name, __func__));
 		break;
 	case MPT2_IOC_AFTER_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_AFTER_RESET\n", ioc->name, __func__));
 		if (ioc->scsih_cmds.status & MPT2_CMD_PENDING) {
 			ioc->scsih_cmds.status |= MPT2_CMD_RESET;
@@ -5906,7 +5906,7 @@ mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 		_scsih_queue_rescan(ioc);
 		break;
 	case MPT2_IOC_DONE_RESET:
-		dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
+		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		_scsih_sas_host_refresh(ioc);
 		_scsih_prep_device_scan(ioc);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 6c94dee..f29ea5e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -397,7 +397,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	    sizeof(struct rep_manu_reply), data_out_dma +
 	    sizeof(struct rep_manu_request));
 
-	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "report_manufacture - "
+	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "report_manufacture - "
 	    "send to sas_addr(0x%016llx)\n", ioc->name,
 	    (unsigned long long)sas_address));
 	mpt2sas_base_put_smid_default(ioc, smid);
@@ -415,7 +415,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 		goto issue_host_reset;
 	}
 
-	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "report_manufacture - "
+	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "report_manufacture - "
 	    "complete\n", ioc->name));
 
 	if (ioc->transport_cmds.status & MPT2_CMD_REPLY_VALID) {
@@ -423,7 +423,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 
 		mpi_reply = ioc->transport_cmds.reply;
 
-		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "report_manufacture - reply data transfer size(%d)\n",
 		    ioc->name, le16_to_cpu(mpi_reply->ResponseDataLength)));
 
@@ -449,7 +449,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 			    manufacture_reply->component_revision_id;
 		}
 	} else
-		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "report_manufacture - no reply\n", ioc->name));
 
  issue_host_reset:
@@ -1861,7 +1861,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	ioc->base_add_sg_single(psge, sgl_flags | (blk_rq_bytes(rsp) + 4),
 	    dma_addr_in);
 
-	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s - "
+	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "%s - "
 	    "sending smp request\n", ioc->name, __func__));
 
 	mpt2sas_base_put_smid_default(ioc, smid);
@@ -1879,14 +1879,14 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		goto issue_host_reset;
 	}
 
-	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s - "
+	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "%s - "
 	    "complete\n", ioc->name, __func__));
 
 	if (ioc->transport_cmds.status & MPT2_CMD_REPLY_VALID) {
 
 		mpi_reply = ioc->transport_cmds.reply;
 
-		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "%s - reply data transfer size(%d)\n",
 		    ioc->name, __func__,
 		    le16_to_cpu(mpi_reply->ResponseDataLength)));
@@ -1897,7 +1897,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		rsp->resid_len -=
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
 	} else {
-		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
+		dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "%s - no reply\n", ioc->name, __func__));
 		rc = -ENXIO;
 	}
