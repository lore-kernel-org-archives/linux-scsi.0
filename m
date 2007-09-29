From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/6] mpt fusion: adding usage of shost_priv and removing all the typecasting
Date: Sat, 29 Sep 2007 10:15:59 -0600
Message-ID: <20070929161559.GA4356@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41933 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbXI2QPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:15:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

The driver is currently typecasting to obtain the shost hostdata. The driver is updated to use the shost_priv macro.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-09-17 11:58:15.000000000 -0600
@@ -348,7 +348,7 @@ static int mptctl_bus_reset(MPT_IOCTL *i
 	if (ioctl->ioc->sh == NULL)
 		return -EPERM;
 
-	hd = (MPT_SCSI_HOST *) ioctl->ioc->sh->hostdata;
+	hd = shost_priv(ioctl->ioc->sh);
 	if (hd == NULL)
 		return -EPERM;
 
@@ -449,7 +449,7 @@ mptctl_free_tm_flags(MPT_ADAPTER *ioc)
 	MPT_SCSI_HOST * hd;
 	unsigned long flags;
 
-	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
+	hd = shost_priv(ioc->sh);
 	if (hd == NULL)
 		return;
 
@@ -2026,7 +2026,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	case MPI_FUNCTION_SCSI_TASK_MGMT:
 		{
 			MPT_SCSI_HOST *hd = NULL;
-			if ((ioc->sh == NULL) || ((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL)) {
+			if ((ioc->sh == NULL) || ((hd = shost_priv(ioc->sh)) == NULL)) {
 				printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
 					"SCSI driver not loaded or SCSI host not found. \n",
 					ioc->name, __FILE__, __LINE__);
@@ -2466,7 +2466,7 @@ mptctl_hp_hostinfo(unsigned long arg, un
 	karg.soft_resets = 0;
 	karg.timeouts = 0;
 	if (ioc->sh != NULL) {
-		MPT_SCSI_HOST *hd =  (MPT_SCSI_HOST *)ioc->sh->hostdata;
+		MPT_SCSI_HOST *hd =  shost_priv(ioc->sh);
 
 		if (hd && (cim_rev == 1)) {
 			karg.hard_resets = hd->hard_resets;
@@ -2683,7 +2683,7 @@ mptctl_hp_targetinfo(unsigned long arg)
 			pci_free_consistent(ioc->pcidev, data_sz, (u8 *) pg3_alloc, page_dma);
 		}
 	}
-	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
+	hd = shost_priv(ioc->sh);
 	if (hd != NULL)
 		karg.select_timeouts = hd->sel_timeout[karg.hdr.id];
 
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-09-17 11:57:11.000000000 -0600
@@ -196,7 +196,7 @@ mptfc_block_error_handler(struct scsi_cm
 	int			ready;
 	MPT_ADAPTER 		*ioc;
 
-	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
+	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	spin_lock_irqsave(shost->host_lock, flags);
 	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY) {
@@ -204,8 +204,7 @@ mptfc_block_error_handler(struct scsi_cm
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 			"mptfc_block_error_handler.%d: %d:%d, port status is "
 			"DID_IMM_RETRY, deferring %s recovery.\n",
-			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
-			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+			ioc->name, ioc->sh->host_no,
 			SCpnt->device->id, SCpnt->device->lun, caller));
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
@@ -216,16 +215,14 @@ mptfc_block_error_handler(struct scsi_cm
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%d, failing recovery, "
 			"port state %d, vdevice %p.\n", caller,
-			((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
-			((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+			ioc->name, ioc->sh->host_no,
 			SCpnt->device->id, SCpnt->device->lun, ready,
 			SCpnt->device->hostdata));
 		return FAILED;
 	}
 	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
 		"%s.%d: %d:%d, executing recovery.\n", caller,
-		((MPT_SCSI_HOST *) shost->hostdata)->ioc->name,
-		((MPT_SCSI_HOST *) shost->hostdata)->ioc->sh->host_no,
+		ioc->name, ioc->sh->host_no,
 		SCpnt->device->id, SCpnt->device->lun));
 	return (*func)(SCpnt);
 }
@@ -615,7 +612,7 @@ mptfc_slave_alloc(struct scsi_device *sd
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
 
-	hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	hd = shost_priv(sdev->host);
 	ioc = hd->ioc;
 
 	vdevice = kzalloc(sizeof(VirtDevice), GFP_KERNEL);
@@ -1279,7 +1276,7 @@ mptfc_probe(struct pci_dev *pdev, const 
 
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
-	hd = (MPT_SCSI_HOST *) sh->hostdata;
+	hd = shost_priv(sh);
 	hd->ioc = ioc;
 
 	/* SCSI needs scsi_cmnd lookup table!
@@ -1386,7 +1383,7 @@ mptfc_event_process(MPT_ADAPTER *ioc, Ev
 			ioc->name, event));
 
 	if (ioc->sh == NULL ||
-		((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL))
+		((hd = shost_priv(ioc->sh)) == NULL))
 		return 1;
 
 	switch (event) {
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-17 11:56:56.000000000 -0600
@@ -575,7 +575,7 @@ static void
 mptsas_target_reset_queue(MPT_ADAPTER *ioc,
     EVENT_DATA_SAS_DEVICE_STATUS_CHANGE *sas_event_data)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
 	VirtTarget *vtarget = NULL;
 	struct mptsas_target_reset_event *target_reset_list;
 	u8		id, channel;
@@ -622,7 +622,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *i
 static void
 mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
         struct list_head *head = &hd->target_reset_list;
 	struct mptsas_target_reset_event *target_reset_list;
 	struct mptsas_hotplug_event *ev;
@@ -739,7 +739,7 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int r
 
 	if (!ioc->sh || !ioc->sh->hostdata)
 		goto out;
-	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	hd = shost_priv(ioc->sh);
 	if (!hd->ioc)
 		goto out;
 
@@ -839,7 +839,7 @@ static int
 mptsas_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(&starget->dev);
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(host);
 	VirtTarget		*vtarget;
 	u8			id, channel;
 	struct sas_rphy		*rphy;
@@ -908,7 +908,7 @@ static void
 mptsas_target_destroy(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(&starget->dev);
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(host);
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
 	int 			 i;
@@ -941,7 +941,7 @@ static int
 mptsas_slave_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host = sdev->host;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(host);
 	struct sas_rphy		*rphy;
 	struct mptsas_portinfo	*p;
 	VirtDevice		*vdevice;
@@ -3215,7 +3215,7 @@ mptsas_probe(struct pci_dev *pdev, const
 		sh->sg_tablesize = numSGE;
 	}
 
-	hd = (MPT_SCSI_HOST *) sh->hostdata;
+	hd = shost_priv(sh);
 	hd->ioc = ioc;
 
 	/* SCSI needs scsi_cmnd lookup table!
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-17 11:43:44.000000000 -0600
@@ -647,8 +647,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 	VirtDevice	 *vdevice;
 	VirtTarget	 *vtarget;
 
-	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
-
+	hd = shost_priv(ioc->sh);
 	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
 	req_idx_MR = (mr != NULL) ?
 	    le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx) : req_idx;
@@ -1105,7 +1104,7 @@ mptscsih_report_queue_full(struct scsi_c
 		return;
 	if (sc->device->host == NULL)
 		return;
-	if ((hd = (MPT_SCSI_HOST *)sc->device->host->hostdata) == NULL)
+	if ((hd = shost_priv(sc->device->host)) == NULL)
 		return;
 	ioc = hd->ioc;
 	if (time - hd->last_queue_full > 10 * HZ) {
@@ -1137,7 +1136,7 @@ mptscsih_remove(struct pci_dev *pdev)
 
 	scsi_remove_host(host);
 
-	if((hd = (MPT_SCSI_HOST *)host->hostdata) == NULL)
+	if((hd = shost_priv(host)) == NULL)
 		return;
 
 	mptscsih_shutdown(pdev);
@@ -1174,15 +1173,6 @@ mptscsih_remove(struct pci_dev *pdev)
 void
 mptscsih_shutdown(struct pci_dev *pdev)
 {
-	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
-	struct Scsi_Host 	*host = ioc->sh;
-	MPT_SCSI_HOST		*hd;
-
-	if(!host)
-		return;
-
-	hd = (MPT_SCSI_HOST *)host->hostdata;
-
 }
 
 #ifdef CONFIG_PM
@@ -1228,7 +1218,7 @@ mptscsih_info(struct Scsi_Host *SChost)
 	MPT_SCSI_HOST *h;
 	int size = 0;
 
-	h = (MPT_SCSI_HOST *)SChost->hostdata;
+	h = shost_priv(SChost);
 
 	if (h) {
 		if (h->info_kbuf == NULL)
@@ -1322,7 +1312,7 @@ int
 mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 			int length, int func)
 {
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER	*ioc = hd->ioc;
 	int size = 0;
 
@@ -1371,7 +1361,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	int	 ii;
 	MPT_ADAPTER *ioc;
 
-	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
+	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	lun = SCpnt->device->lun;
 	SCpnt->scsi_done = done;
@@ -1807,7 +1797,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL) {
 		SCpnt->result = DID_RESET << 16;
 		SCpnt->scsi_done(SCpnt);
 		printk(KERN_ERR MYNAM ": task abort: "
@@ -1913,7 +1903,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
 		printk(KERN_ERR MYNAM ": target reset: "
 		   "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -1976,7 +1966,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
 		printk(KERN_ERR MYNAM ": bus reset: "
 		   "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -2020,7 +2010,7 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 	MPT_ADAPTER	*ioc;
 
 	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
+	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
 		printk(KERN_ERR MYNAM ": host reset: "
 		    "Can't locate host! (sc=%p)\n", SCpnt);
 		return FAILED;
@@ -2186,7 +2176,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *
 		return 1;
 	}
 
-	hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
+	hd = shost_priv(ioc->sh);
 	pScsiTmReply = (SCSITaskMgmtReply_t*)mr;
 	pScsiTmReq = (SCSITaskMgmt_t*)mf;
 	tmType = pScsiTmReq->TaskType;
@@ -2380,7 +2370,7 @@ void
 mptscsih_slave_destroy(struct scsi_device *sdev)
 {
 	struct Scsi_Host	*host = sdev->host;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(host);
 	VirtTarget		*vtarget;
 	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
@@ -2407,7 +2397,7 @@ mptscsih_slave_destroy(struct scsi_devic
 int
 mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(sdev->host);
 	VirtTarget 		*vtarget;
 	struct scsi_target 	*starget;
 	int			max_depth;
@@ -2452,7 +2442,7 @@ mptscsih_slave_configure(struct scsi_dev
 	VirtTarget		*vtarget;
 	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
-	MPT_SCSI_HOST		*hd = (MPT_SCSI_HOST *)sh->hostdata;
+	MPT_SCSI_HOST		*hd = shost_priv(sh);
 	MPT_ADAPTER		*ioc = hd->ioc;
 
 	starget = scsi_target(sdev);
@@ -2567,7 +2557,7 @@ SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc
 	MPT_SCSI_HOST *hd;
 	int i;
 
-	hd = (MPT_SCSI_HOST *) sc->device->host->hostdata;
+	hd = shost_priv(sc->device->host);
 
 	for (i = 0; i < hd->ioc->req_depth; i++) {
 		if (hd->ScsiLookup[i] == sc) {
@@ -2595,10 +2585,10 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 	 * before all scsi hosts have been attached, then an alt_ioc
 	 * may have a NULL sh pointer.
 	 */
-	if ((ioc->sh == NULL) || (ioc->sh->hostdata == NULL))
+	if (ioc->sh == NULL || shost_priv(ioc->sh) == NULL)
 		return 0;
 	else
-		hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
+		hd = shost_priv(ioc->sh);
 
 	if (reset_phase == MPT_IOC_SETUP_RESET) {
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Setup-Diag Reset\n", ioc->name));
@@ -2691,7 +2681,7 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 			ioc->name, event));
 
 	if (ioc->sh == NULL ||
-		((hd = (MPT_SCSI_HOST *)ioc->sh->hostdata) == NULL))
+		((hd = shost_priv(ioc->sh)) == NULL))
 		return 1;
 
 	switch (event) {
@@ -2770,7 +2760,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 	int		 completionCode;
 	u16		 req_idx;
 
-	hd = (MPT_SCSI_HOST *) ioc->sh->hostdata;
+	hd = shost_priv(ioc->sh);
 
 	if ((mf == NULL) ||
 	    (mf >= MPT_INDEX_2_MFPTR(ioc, ioc->req_depth))) {
@@ -3254,7 +3244,7 @@ static ssize_t
 mptscsih_version_fw_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02d.%02d.%02d.%02d\n",
@@ -3269,7 +3259,7 @@ static ssize_t
 mptscsih_version_bios_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x\n",
@@ -3284,7 +3274,7 @@ static ssize_t
 mptscsih_version_mpi_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%03x\n", ioc->facts.MsgVersion);
@@ -3295,7 +3285,7 @@ static ssize_t
 mptscsih_version_product_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->prod_name);
@@ -3307,7 +3297,7 @@ static ssize_t
 mptscsih_version_nvdata_persistent_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02xh\n",
@@ -3320,7 +3310,7 @@ static ssize_t
 mptscsih_version_nvdata_default_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02xh\n",ioc->nvdata_version_default);
@@ -3332,7 +3322,7 @@ static ssize_t
 mptscsih_board_name_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_name);
@@ -3343,7 +3333,7 @@ static ssize_t
 mptscsih_board_assembly_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_assembly);
@@ -3355,7 +3345,7 @@ static ssize_t
 mptscsih_board_tracer_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_tracer);
@@ -3367,7 +3357,7 @@ static ssize_t
 mptscsih_io_delay_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
@@ -3379,7 +3369,7 @@ static ssize_t
 mptscsih_device_delay_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
@@ -3391,7 +3381,7 @@ static ssize_t
 mptscsih_debug_level_show(struct class_device *cdev, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 
 	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->debug_level);
@@ -3401,7 +3391,7 @@ mptscsih_debug_level_store(struct class_
 								size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
-	MPT_SCSI_HOST	*hd = (MPT_SCSI_HOST *)host->hostdata;
+	MPT_SCSI_HOST	*hd = shost_priv(host);
 	MPT_ADAPTER *ioc = hd->ioc;
 	int val = 0;
 
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-17 11:59:07.000000000 -0600
@@ -397,7 +397,7 @@ mptspi_is_raid(struct _MPT_SCSI_HOST *hd
 static int mptspi_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(shost);
 	VirtTarget		*vtarget;
 	MPT_ADAPTER *ioc;
 
@@ -514,7 +514,7 @@ static int mptspi_read_spi_device_pg0(st
 			     struct _CONFIG_PAGE_SCSI_DEVICE_0 *pass_pg0)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(shost);
 	struct _MPT_ADAPTER *ioc = hd->ioc;
 	struct _CONFIG_PAGE_SCSI_DEVICE_0 *pg0;
 	dma_addr_t pg0_dma;
@@ -702,7 +702,7 @@ static void mptspi_dv_device(struct _MPT
 
 static int mptspi_slave_alloc(struct scsi_device *sdev)
 {
-	MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *)sdev->host->hostdata;
+	MPT_SCSI_HOST *hd = shost_priv(sdev->host);
 	VirtTarget		*vtarget;
 	VirtDevice		*vdevice;
 	struct scsi_target 	*starget;
@@ -735,8 +735,7 @@ static int mptspi_slave_alloc(struct scs
 
 static int mptspi_slave_configure(struct scsi_device *sdev)
 {
-	struct _MPT_SCSI_HOST *hd =
-		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(sdev->host);
 	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
 	int ret;
 
@@ -764,7 +763,7 @@ static int mptspi_slave_configure(struct
 static int
 mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
-	struct _MPT_SCSI_HOST *hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 	MPT_ADAPTER *ioc = hd->ioc;
 
@@ -839,7 +838,7 @@ static int mptspi_write_spi_device_pg1(s
 			       struct _CONFIG_PAGE_SCSI_DEVICE_1 *pass_pg1)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(shost);
 	struct _MPT_ADAPTER *ioc = hd->ioc;
 	struct _CONFIG_PAGE_SCSI_DEVICE_1 *pg1;
 	dma_addr_t pg1_dma;
@@ -1027,7 +1026,7 @@ static void mptspi_write_qas(struct scsi
 {
 	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)shost->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(shost);
 	VirtTarget *vtarget = starget->hostdata;
 	u32 nego;
 
@@ -1137,7 +1136,7 @@ static int
 mptspi_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 {
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 
 	if (hd && event ==  MPI_EVENT_INTEGRATED_RAID) {
 		int reason
@@ -1267,7 +1266,7 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
@@ -1286,7 +1285,7 @@ static int
 mptspi_resume(struct pci_dev *pdev)
 {
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
-	struct _MPT_SCSI_HOST *hd = (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
 	rc = mptscsih_resume(pdev);
@@ -1441,7 +1440,7 @@ mptspi_probe(struct pci_dev *pdev, const
 
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
-	hd = (MPT_SCSI_HOST *) sh->hostdata;
+	hd = shost_priv(sh);
 	hd->ioc = ioc;
 
 	/* SCSI needs scsi_cmnd lookup table!
