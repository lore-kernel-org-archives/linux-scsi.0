From: crquan@gmail.com
Subject: [PATCH 2/2] mpt fusion: port "4.00.43.00" to mainstream git kernel
Date: Fri,  5 Dec 2008 21:26:50 +0800
Message-ID: <1228483610-18502-2-git-send-email-crquan@gmail.com>
References: <1228483610-18502-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:43096 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYLEN0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 08:26:10 -0500
Received: by ti-out-0910.google.com with SMTP id b6so2960526tic.23
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2008 05:26:09 -0800 (PST)
In-Reply-To: <1228483610-18502-1-git-send-email-crquan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

this one just can build with mainstream git kernel, I did not even test it.

I just have tested it with kernel 2.6.26.2, that patch is very similar to
this, and it did work well with 2.6.26.2.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/message/fusion/linux_compat.h |    3 +-
 drivers/message/fusion/mptbase.c      |   10 +-
 drivers/message/fusion/mptbase.h      |    6 +-
 drivers/message/fusion/mptfc.c        |    4 +-
 drivers/message/fusion/mptsas.c       |   14 +---
 drivers/message/fusion/mptscsih.c     |  169 +++++++++++++--------------------
 drivers/message/fusion/mptscsih.h     |    2 +-
 7 files changed, 79 insertions(+), 129 deletions(-)

diff --git a/drivers/message/fusion/linux_compat.h b/drivers/message/fusion/linux_compat.h
index 24ad3f1..92e9797 100644
--- a/drivers/message/fusion/linux_compat.h
+++ b/drivers/message/fusion/linux_compat.h
@@ -31,7 +31,6 @@ static inline void *shost_private(struct Scsi_Host *shost)
 #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
 /**
  * mpt_scsilun_to_int: convert a scsi_lun to an int
  * @scsilun:    struct scsi_lun to be converted.
@@ -62,7 +61,7 @@ static inline int mpt_scsilun_to_int(struct scsi_lun *scsilun)
                               scsilun->scsi_lun[i + 1]) << (i * 8));
         return lun;
 }
-#endif
+
 #if (defined(CONFIG_SUSE_KERNEL) && !defined(scsi_is_sas_phy_local))
 #define SUSE_KERNEL_BASE	1
 #endif
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 2979b63..36dd62a 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1618,7 +1618,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	}
 #else
 	ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
-	if (pci_enable_device_bars(pdev, ioc->bars)) {
+	if (pci_enable_device(pdev)) {
 		printk(MYIOC_s_ERR_FMT "pci_enable_device_bars() with MEM "
 		    "failed\n",ioc->name);
 		return r;
@@ -1826,7 +1826,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 #endif
 
 	/* Initialize workqueue */
-	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
+	snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name),
+			"mpt_poll_%d", ioc->id);
 	ioc->reset_work_q =
 		create_singlethread_workqueue(ioc->reset_work_q_name);
 	if (!ioc->reset_work_q) {
@@ -1949,7 +1950,8 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	INIT_LIST_HEAD(&ioc->fw_event_list);
 	spin_lock_init(&ioc->fw_event_lock);
-	snprintf(ioc->fw_event_q_name, KOBJ_NAME_LEN, "mpt/%d", ioc->id);
+	snprintf(ioc->fw_event_q_name, sizeof(ioc->fw_event_q_name),
+			"mpt/%d", ioc->id);
 	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
 
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
@@ -2303,7 +2305,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 		pci_release_selected_regions(ioc->pcidev, ioc->bars);
 		ioc->bars = pci_select_bars(ioc->pcidev, IORESOURCE_MEM |
 		    IORESOURCE_IO);
-		if (pci_enable_device_bars(ioc->pcidev, ioc->bars))
+		if (pci_enable_device(ioc->pcidev))
 			return -5;
 		if (pci_request_selected_regions(ioc->pcidev, ioc->bars,
 			"mpt"))
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 73b326d..63f74be 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -711,7 +711,7 @@ typedef struct _MPT_ADAPTER
 	struct list_head	 fw_event_list;
 	spinlock_t		 fw_event_lock;
 	u8			 fw_events_off; /* if '1', then ignore events */
-	char fw_event_q_name[KOBJ_NAME_LEN];
+	char fw_event_q_name[20];
 
 	struct mptsas_portinfo	*hba_port_info; /* port_info object for the host */
 	u64			 hba_port_sas_addr;
@@ -734,7 +734,7 @@ typedef struct _MPT_ADAPTER
 	u8			 num_ports;
 #endif
 
-	char			 reset_work_q_name[KOBJ_NAME_LEN];
+	char			 reset_work_q_name[20];
 	struct workqueue_struct *reset_work_q;
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19))
 	struct delayed_work	 fault_reset_work;
@@ -747,7 +747,7 @@ typedef struct _MPT_ADAPTER
 	u8			 fc_link_speed[2];
 	spinlock_t		 fc_rescan_work_lock;
 	struct work_struct	 fc_rescan_work;
-	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
+	char			 fc_rescan_work_q_name[20];
 	struct workqueue_struct *fc_rescan_work_q;
 	unsigned long		  hard_resets;		/* driver forced bus resets count */
 	unsigned long		  soft_resets;		/* fw/external bus resets count */
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 0e943ba..bfb18c8 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1398,8 +1398,8 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* initialize workqueue */
 
-	snprintf(ioc->fc_rescan_work_q_name, KOBJ_NAME_LEN, "mptfc_wq_%d",
-		sh->host_no);
+	snprintf(ioc->fc_rescan_work_q_name, sizeof(ioc->fc_rescan_work_q_name),
+			"mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
 		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
 	if (!ioc->fc_rescan_work_q)
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index ee1edaf..4218686 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -147,11 +147,7 @@ static int mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *por
 static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
 static void mptsas_not_responding_devices(MPT_ADAPTER *ioc);
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19))
 static void mptsas_firmware_event_work(struct work_struct *work);
-#else
-static void mptsas_firmware_event_work(void *arg);
-#endif
 
 /**
  *	mptsas_set_sdev_queue_depth - global setting of the mpt_sdev_queue_depth
@@ -4847,16 +4843,10 @@ mptsas_handle_queue_full_event(struct fw_event_work *fw_event)
  *
  */
 static void
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19))
 mptsas_firmware_event_work(struct work_struct *work)
 {
-	struct mptsas_hotplug_event *ev =
-		container_of(work, struct fw_event_work, fw_event.work);
-#else
-mptsas_firmware_event_work(void *arg)
-{
-	struct fw_event_work *fw_event = (struct fw_event_work *)arg;
-#endif
+	struct fw_event_work *fw_event =
+		container_of(work, struct fw_event_work, work.work);
 	MPT_ADAPTER *ioc = fw_event->ioc;
 
 	/* special rescan topology handling */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 9f0106e..e358f72 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -199,30 +199,13 @@ mptscsih_AddSGE(MPT_ADAPTER *ioc, struct scsi_cmnd *SCpnt,
 	/* Map the data portion, if any.
 	 * sges_left  = 0 if no data transfer.
 	 */
-	if ( (sges_left = SCpnt->use_sg) ) {
-		sges_left = pci_map_sg(ioc->pcidev,
-			       (struct scatterlist *) SCpnt->request_buffer,
- 			       SCpnt->use_sg,
-			       SCpnt->sc_data_direction);
-		if (sges_left == 0)
-			return FAILED;
-	} else if (SCpnt->request_bufflen) {
-		SCpnt->SCp.dma_handle = pci_map_single(ioc->pcidev,
-				      SCpnt->request_buffer,
-				      SCpnt->request_bufflen,
-				      SCpnt->sc_data_direction);
-		dsgprintk(ioc, printk(MYIOC_s_DEBUG_FMT "SG: non-SG for %p, len=%d\n",
-				ioc->name, SCpnt, SCpnt->request_bufflen));
-		ioc->add_sge((char *) &pReq->SGL,
-			0xD1000000|sgdir|SCpnt->request_bufflen,
-			SCpnt->SCp.dma_handle);
-
-		return SUCCESS;
-	}
+	sges_left = scsi_dma_map(SCpnt);
+	if (sges_left < 0)
+		return FAILED;
 
 	/* Handle the SG case.
 	 */
-	sg = (struct scatterlist *) SCpnt->request_buffer;
+	sg = scsi_sglist(SCpnt);
 	sg_done  = 0;
 	sgeOffset = sizeof(SCSIIORequest_t) - sizeof(SGE_IO_UNION);
 	chainSge = NULL;
@@ -246,7 +229,7 @@ nextSGEset:
 	for (ii=0; ii < (numSgeThisFrame-1); ii++) {
 		thisxfer = sg_dma_len(sg);
 		if (thisxfer == 0) {
-			sg ++; /* Get next SG element from the OS */
+			sg = sg_next(sg); /* Get next SG element from the OS */
 			sg_done++;
 			continue;
 		}
@@ -254,7 +237,7 @@ nextSGEset:
 		v2 = sg_dma_address(sg);
 		ioc->add_sge(psge, sgflags | thisxfer, v2);
 
-		sg++;		/* Get next SG element from the OS */
+		sg = sg_next(sg); /* Get next SG element from the OS */
 		psge += ioc->SGE_size;
 		sgeOffset += ioc->SGE_size;
 		sg_done++;
@@ -544,7 +527,7 @@ mptscsih_info_scsiio(MPT_ADAPTER *ioc, struct scsi_cmnd *sc, SCSIIOReply_t * pSc
 	printk(MYIOC_s_DEBUG_FMT "\tfw_channel = %d, fw_id = %d, lun = %d\n",
 	    ioc->name, pScsiReply->Bus, pScsiReply->TargetID, sc->device->lun);
 	printk(MYIOC_s_DEBUG_FMT "\trequest_len = %d, underflow = %d, resid = %d\n",
-	    ioc->name, sc->request_bufflen, sc->underflow, sc->resid);
+	    ioc->name, scsi_bufflen(sc), sc->underflow, scsi_get_resid(sc));
 	printk(MYIOC_s_DEBUG_FMT "\ttag = %d, transfer_count = %d, sc->result = %08X\n",
 	    ioc->name, le16_to_cpu(pScsiReply->TaskTag),
 	    le32_to_cpu(pScsiReply->TransferCount), sc->result);
@@ -665,7 +648,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		scsi_state = pScsiReply->SCSIState;
 		scsi_status = pScsiReply->SCSIStatus;
 		xfer_cnt = le32_to_cpu(pScsiReply->TransferCount);
-		sc->resid = sc->request_bufflen - xfer_cnt;
+		scsi_set_resid(sc, scsi_bufflen(sc) - xfer_cnt);
 		log_info = le32_to_cpu(pScsiReply->IOCLogInfo);
 		vdevice = sc->device->hostdata;
 
@@ -760,7 +743,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			break;
 
 		case MPI_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:	/* 0x0049 */
-			sc->resid = sc->request_bufflen - xfer_cnt;
+			scsi_set_resid(sc, scsi_bufflen(sc) - xfer_cnt);
 			if((xfer_cnt==0)||(sc->underflow > xfer_cnt))
 				sc->result=DID_SOFT_ERROR << 16;
 			else /* Sufficient data transfer occurred */
@@ -791,12 +774,12 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					    pScsiReq->CDB[0] == READ_16 ||
 					    pScsiReq->CDB[0] == VERIFY  ||
 					    pScsiReq->CDB[0] == VERIFY_16) {
-						if (sc->request_bufflen !=
+						if (scsi_bufflen(sc) !=
 						    xfer_cnt) {
 						    sc->result = DID_SOFT_ERROR << 16;
 						    printk(MYIOC_s_WARN_FMT "Errata"
 						    "on LSI53C1030 occurred. sc->request_bufflen=0x%02x, "
-						    "xfer_cnt=0x%02x\n", ioc->name, sc->request_bufflen, xfer_cnt);
+						    "xfer_cnt=0x%02x\n", ioc->name, scsi_bufflen(sc), xfer_cnt);
 						}
 					}
 				}
@@ -826,7 +809,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			break;
 
 		case MPI_IOCSTATUS_SCSI_DATA_OVERRUN:		/* 0x0044 */
-			sc->resid=0;
+			scsi_set_resid(sc, 0);
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
 			sc->result = (DID_OK << 16) | scsi_status;
@@ -849,23 +832,23 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 					    sc->sense_buffer[5] << 8 |
 					    sc->sense_buffer[6];
 					    if ((sc->sense_buffer[3] & 0x80) == 0x80) {
-						if (sc->request_bufflen != xfer_cnt) {
+						if (scsi_bufflen(sc) != xfer_cnt) {
 						    sc->sense_buffer[2] = MEDIUM_ERROR;
 						    sc->sense_buffer[12] = 0xff;
 						    sc->sense_buffer[13] = 0xff;
 						    printk(MYIOC_s_WARN_FMT "Errata on "
 						    "LSI53C1030 occurred. sc->request_bufflen=0x%02x,"
-						    "xfer_cnt=0x%02x\n", ioc->name, sc->request_bufflen, xfer_cnt);
+						    "xfer_cnt=0x%02x\n", ioc->name, scsi_bufflen(sc), xfer_cnt);
 						}
 					} else {
-						if (sc->request_bufflen != xfer_cnt + difftransfer) {
+						if (scsi_bufflen(sc) != xfer_cnt + difftransfer) {
 						    sc->sense_buffer[2] = MEDIUM_ERROR;
 						    sc->sense_buffer[12] = 0xff;
 						    sc->sense_buffer[13] = 0xff;
 						    printk(MYIOC_s_WARN_FMT "Errata on "
 						    "LSI53C1030 occurred. sc->request_bufflen=0x%02x,"
 						    " xfer_cnt=0x%02x, difftransfer=0x%02x\n",
-						    ioc->name, sc->request_bufflen , xfer_cnt, difftransfer);
+						    ioc->name, scsi_bufflen(sc) , xfer_cnt, difftransfer);
 						}
 						}
 					}
@@ -939,13 +922,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 	} /* end of address reply case */
 
 	/* Unmap the DMA buffers, if any. */
-	if (sc->use_sg) {
-		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
-			    sc->use_sg, sc->sc_data_direction);
-	} else if (sc->request_bufflen) {
-		pci_unmap_single(ioc->pcidev, sc->SCp.dma_handle,
-				sc->request_bufflen, sc->sc_data_direction);
-	}
+	scsi_dma_unmap(sc);
 
 	sc->scsi_done(sc);		/* Issue the command callback */
 
@@ -986,15 +963,7 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 		mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
 		if ((unsigned char *)mf != sc->host_scribble)
 			continue;
-		if (sc->use_sg) {
-			pci_unmap_sg(ioc->pcidev,
-			    (struct scatterlist *) sc->request_buffer,
-			    sc->use_sg, sc->sc_data_direction);
-		} else if (sc->request_bufflen) {
-			pci_unmap_single(ioc->pcidev,
-			    sc->SCp.dma_handle, sc->request_bufflen,
-			    sc->sc_data_direction);
-		}
+		scsi_dma_unmap(sc);
 		sc->result = DID_RESET << 16;
 		sc->host_scribble = NULL;
 		dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device, MYIOC_s_FMT
@@ -1058,17 +1027,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HOST *hd, VirtDevice *vdevice)
 			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 			mptscsih_freeChainBuffers(ioc, ii);
 			mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
-			if (sc->use_sg) {
-				pci_unmap_sg(ioc->pcidev,
-				(struct scatterlist *) sc->request_buffer,
-					sc->use_sg,
-					sc->sc_data_direction);
-			} else if (sc->request_bufflen) {
-				pci_unmap_single(ioc->pcidev,
-					sc->SCp.dma_handle,
-					sc->request_bufflen,
-					sc->sc_data_direction);
-			}
+			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
 			dtmprintk(ioc, sdev_printk(KERN_INFO, sc->device,
@@ -1404,10 +1363,10 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	 *    will be no data transfer!  GRRRRR...
 	 */
 	if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
-		datalen = SCpnt->request_bufflen;
+		datalen = scsi_bufflen(SCpnt);
 		scsidir = MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) */
 	} else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
-		datalen = SCpnt->request_bufflen;
+		datalen = scsi_bufflen(SCpnt);
 		scsidir = MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT (host-->ioc-->dev) */
 	} else {
 		datalen = 0;
@@ -1851,7 +1810,7 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *m
 int
 mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout)
 {
-	MPT_FRAME_HDR	*mf;
+	MPT_FRAME_HDR	*uninitialized_var(mf);
 	SCSITaskMgmt_t	*pScsiTm;
 	int		 ii;
 	int		 retval;
@@ -3270,7 +3229,7 @@ mptscsih_synchronize_cache(struct scsi_device *sdev, MPT_SCSI_HOST *hd, VirtDevi
  * shost attributes
  */
 static ssize_t
-mptscsih_version_fw_show(struct class_device *cdev, char *buf)
+mptscsih_version_fw_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3282,10 +3241,10 @@ mptscsih_version_fw_show(struct class_device *cdev, char *buf)
 	    (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
 	    ioc->facts.FWVersion.Word & 0x000000FF);
 }
-static CLASS_DEVICE_ATTR(version_fw, S_IRUGO, mptscsih_version_fw_show, NULL);
+static DEVICE_ATTR(version_fw, S_IRUGO, mptscsih_version_fw_show, NULL);
 
 static ssize_t
-mptscsih_version_bios_show(struct class_device *cdev, char *buf)
+mptscsih_version_bios_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3297,10 +3256,10 @@ mptscsih_version_bios_show(struct class_device *cdev, char *buf)
 	    (ioc->biosVersion & 0x0000FF00) >> 8,
 	    ioc->biosVersion & 0x000000FF);
 }
-static CLASS_DEVICE_ATTR(version_bios, S_IRUGO, mptscsih_version_bios_show, NULL);
+static DEVICE_ATTR(version_bios, S_IRUGO, mptscsih_version_bios_show, NULL);
 
 static ssize_t
-mptscsih_version_mpi_show(struct class_device *cdev, char *buf)
+mptscsih_version_mpi_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3313,10 +3272,10 @@ mptscsih_version_mpi_show(struct class_device *cdev, char *buf)
 		return snprintf(buf, PAGE_SIZE, "%03x\n",
 		    ioc->facts.MsgVersion);
 }
-static CLASS_DEVICE_ATTR(version_mpi, S_IRUGO, mptscsih_version_mpi_show, NULL);
+static DEVICE_ATTR(version_mpi, S_IRUGO, mptscsih_version_mpi_show, NULL);
 
 static ssize_t
-mptscsih_version_product_show(struct class_device *cdev, char *buf)
+mptscsih_version_product_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3324,11 +3283,11 @@ mptscsih_version_product_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->prod_name);
 }
-static CLASS_DEVICE_ATTR(version_product, S_IRUGO,
+static DEVICE_ATTR(version_product, S_IRUGO,
     mptscsih_version_product_show, NULL);
 
 static ssize_t
-mptscsih_version_nvdata_persistent_show(struct class_device *cdev, char *buf)
+mptscsih_version_nvdata_persistent_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3337,11 +3296,11 @@ mptscsih_version_nvdata_persistent_show(struct class_device *cdev, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%02xh\n",
 	    ioc->nvdata_version_persistent);
 }
-static CLASS_DEVICE_ATTR(version_nvdata_persistent, S_IRUGO,
+static DEVICE_ATTR(version_nvdata_persistent, S_IRUGO,
     mptscsih_version_nvdata_persistent_show, NULL);
 
 static ssize_t
-mptscsih_version_nvdata_default_show(struct class_device *cdev, char *buf)
+mptscsih_version_nvdata_default_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3349,11 +3308,11 @@ mptscsih_version_nvdata_default_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%02xh\n",ioc->nvdata_version_default);
 }
-static CLASS_DEVICE_ATTR(version_nvdata_default, S_IRUGO,
+static DEVICE_ATTR(version_nvdata_default, S_IRUGO,
     mptscsih_version_nvdata_default_show, NULL);
 
 static ssize_t
-mptscsih_board_name_show(struct class_device *cdev, char *buf)
+mptscsih_board_name_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3361,10 +3320,10 @@ mptscsih_board_name_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_name);
 }
-static CLASS_DEVICE_ATTR(board_name, S_IRUGO, mptscsih_board_name_show, NULL);
+static DEVICE_ATTR(board_name, S_IRUGO, mptscsih_board_name_show, NULL);
 
 static ssize_t
-mptscsih_board_assembly_show(struct class_device *cdev, char *buf)
+mptscsih_board_assembly_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3372,11 +3331,11 @@ mptscsih_board_assembly_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_assembly);
 }
-static CLASS_DEVICE_ATTR(board_assembly, S_IRUGO,
+static DEVICE_ATTR(board_assembly, S_IRUGO,
     mptscsih_board_assembly_show, NULL);
 
 static ssize_t
-mptscsih_board_tracer_show(struct class_device *cdev, char *buf)
+mptscsih_board_tracer_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3384,11 +3343,11 @@ mptscsih_board_tracer_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%s\n", ioc->board_tracer);
 }
-static CLASS_DEVICE_ATTR(board_tracer, S_IRUGO,
+static DEVICE_ATTR(board_tracer, S_IRUGO,
     mptscsih_board_tracer_show, NULL);
 
 static ssize_t
-mptscsih_io_delay_show(struct class_device *cdev, char *buf)
+mptscsih_io_delay_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3396,11 +3355,11 @@ mptscsih_io_delay_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->io_missing_delay);
 }
-static CLASS_DEVICE_ATTR(io_delay, S_IRUGO,
+static DEVICE_ATTR(io_delay, S_IRUGO,
     mptscsih_io_delay_show, NULL);
 
 static ssize_t
-mptscsih_device_delay_show(struct class_device *cdev, char *buf)
+mptscsih_device_delay_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3408,11 +3367,11 @@ mptscsih_device_delay_show(struct class_device *cdev, char *buf)
 
 	return snprintf(buf, PAGE_SIZE, "%02d\n", ioc->device_missing_delay);
 }
-static CLASS_DEVICE_ATTR(device_delay, S_IRUGO,
+static DEVICE_ATTR(device_delay, S_IRUGO,
     mptscsih_device_delay_show, NULL);
 
 static ssize_t
-mptscsih_debug_level_show(struct class_device *cdev, char *buf)
+mptscsih_debug_level_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3421,7 +3380,7 @@ mptscsih_debug_level_show(struct class_device *cdev, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%08xh\n", ioc->debug_level);
 }
 static ssize_t
-mptscsih_debug_level_store(struct class_device *cdev, const char *buf, size_t count)
+mptscsih_debug_level_store(struct device *cdev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3436,11 +3395,11 @@ mptscsih_debug_level_store(struct class_device *cdev, const char *buf, size_t co
 	    ioc->debug_level);
 	return strlen(buf);
 }
-static CLASS_DEVICE_ATTR(debug_level, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(debug_level, S_IRUGO | S_IWUSR,
     mptscsih_debug_level_show, mptscsih_debug_level_store);
 
 static ssize_t
-mptscsih_disable_hotplug_remove_show(struct class_device *cdev, char *buf)
+mptscsih_disable_hotplug_remove_show(struct device *cdev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3449,7 +3408,7 @@ mptscsih_disable_hotplug_remove_show(struct class_device *cdev, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%02xh\n", ioc->disable_hotplug_remove);
 }
 static ssize_t
-mptscsih_disable_hotplug_remove_store(struct class_device *cdev, const char *buf, size_t count)
+mptscsih_disable_hotplug_remove_store(struct device *cdev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct Scsi_Host *host = class_to_shost(cdev);
 	MPT_SCSI_HOST	*hd = shost_private(host);
@@ -3467,23 +3426,23 @@ mptscsih_disable_hotplug_remove_store(struct class_device *cdev, const char *buf
 		printk(MYIOC_s_INFO_FMT "eanbling hotplug remove\n", ioc->name);
 	return strlen(buf);
 }
-static CLASS_DEVICE_ATTR(disable_hotplug_remove, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(disable_hotplug_remove, S_IRUGO | S_IWUSR,
     mptscsih_disable_hotplug_remove_show, mptscsih_disable_hotplug_remove_store);
 
-struct class_device_attribute *mptscsih_host_attrs[] = {
-	&class_device_attr_version_fw,
-	&class_device_attr_version_bios,
-	&class_device_attr_version_mpi,
-	&class_device_attr_version_product,
-	&class_device_attr_version_nvdata_persistent,
-	&class_device_attr_version_nvdata_default,
-	&class_device_attr_board_name,
-	&class_device_attr_board_assembly,
-	&class_device_attr_board_tracer,
-	&class_device_attr_io_delay,
-	&class_device_attr_device_delay,
-	&class_device_attr_debug_level,
-	&class_device_attr_disable_hotplug_remove,
+struct device_attribute *mptscsih_host_attrs[] = {
+	&dev_attr_version_fw,
+	&dev_attr_version_bios,
+	&dev_attr_version_mpi,
+	&dev_attr_version_product,
+	&dev_attr_version_nvdata_persistent,
+	&dev_attr_version_nvdata_default,
+	&dev_attr_board_name,
+	&dev_attr_board_assembly,
+	&dev_attr_board_tracer,
+	&dev_attr_io_delay,
+	&dev_attr_device_delay,
+	&dev_attr_debug_level,
+	&dev_attr_disable_hotplug_remove,
 	NULL,
 };
 EXPORT_SYMBOL(mptscsih_host_attrs);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 9b0b0b0..c199843 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -133,7 +133,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id,
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
-extern struct class_device_attribute *mptscsih_host_attrs[];
+extern struct device_attribute *mptscsih_host_attrs[];
 extern int mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id);
 extern struct scsi_cmnd * mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
-- 
1.6.0.3

