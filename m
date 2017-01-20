From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.10-rc4
Date: Thu, 19 Jan 2017 23:20:20 -0500
Message-ID: <1484886020.3140.84.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of 12 fixes including the mpt3sas one that was causing
hangs on ATA passthrough.  The others are a couple of zoned block
device fixes, a SAS device detection bug which lead to SATA drives not
being matched to bays, two qla2xxx MSI fixes, a qla2xxx req for rsp
confusion caused by cut and paste, and a few other minor fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (2):
      scsi: qla2xxx: remove irq_affinity_notifier
      scsi: qla2xxx: fix MSI-X vector affinity

Damien Le Moal (2):
      scsi: sd: Ignore zoned field for host-managed devices
      scsi: sd: Fix wrong DPOFUA disable in sd_read_cache_type

Dave Jones (1):
      scsi: qla2xxx: Fix apparent cut-n-paste error.

Ewan D. Milne (1):
      scsi: ses: Fix SAS device detection in enclosure

Fam Zheng (1):
      scsi: libfc: Fix variable name in fc_set_wwpn

James Bottomley (1):
      scsi: mpt3sas: fix hang on ata passthrough commands

Johannes Thumshirn (2):
      scsi: lpfc: Set elsiocb contexts to NULL after freeing it
      scsi: bfa: fix wrongly initialized variable in bfad_im_bsg_els_ct_request()

Milan P. Gandhi (1):
      scsi: qla2xxx: Get mutex lock before checking optrom_state

Roberto Sassu (1):
      scsi: lpfc: avoid double free of resource identifiers

And the diffstat:

 drivers/scsi/bfa/bfad_bsg.c          |  2 +-
 drivers/scsi/lpfc/lpfc_els.c         |  2 +
 drivers/scsi/lpfc/lpfc_sli.c         |  7 +++
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 12 +++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 40 ++++++++++------
 drivers/scsi/qla2xxx/qla_attr.c      | 18 ++++++--
 drivers/scsi/qla2xxx/qla_def.h       |  3 +-
 drivers/scsi/qla2xxx/qla_isr.c       | 88 +++++-------------------------------
 drivers/scsi/qla2xxx/qla_os.c        |  2 +-
 drivers/scsi/sd.c                    | 23 +++++++---
 drivers/scsi/ses.c                   |  2 +-
 include/scsi/libfc.h                 |  6 +--
 12 files changed, 94 insertions(+), 111 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index a9a0016..b2e8c0d 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3363,7 +3363,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 	struct bfad_fcxp    *drv_fcxp;
 	struct bfa_fcs_lport_s *fcs_port;
 	struct bfa_fcs_rport_s *fcs_rport;
-	struct fc_bsg_request *bsg_request = bsg_request;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct fc_bsg_reply *bsg_reply = job->reply;
 	uint32_t command_type = bsg_request->msgcode;
 	unsigned long flags;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 236e4e5..7b6bd8e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3590,12 +3590,14 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 		} else {
 			buf_ptr1 = (struct lpfc_dmabuf *) elsiocb->context2;
 			lpfc_els_free_data(phba, buf_ptr1);
+			elsiocb->context2 = NULL;
 		}
 	}
 
 	if (elsiocb->context3) {
 		buf_ptr = (struct lpfc_dmabuf *) elsiocb->context3;
 		lpfc_els_free_bpl(phba, buf_ptr);
+		elsiocb->context3 = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, elsiocb);
 	return 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4faa767..a78a3df 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5954,18 +5954,25 @@ lpfc_sli4_alloc_resource_identifiers(struct lpfc_hba *phba)
 
  free_vfi_bmask:
 	kfree(phba->sli4_hba.vfi_bmask);
+	phba->sli4_hba.vfi_bmask = NULL;
  free_xri_ids:
 	kfree(phba->sli4_hba.xri_ids);
+	phba->sli4_hba.xri_ids = NULL;
  free_xri_bmask:
 	kfree(phba->sli4_hba.xri_bmask);
+	phba->sli4_hba.xri_bmask = NULL;
  free_vpi_ids:
 	kfree(phba->vpi_ids);
+	phba->vpi_ids = NULL;
  free_vpi_bmask:
 	kfree(phba->vpi_bmask);
+	phba->vpi_bmask = NULL;
  free_rpi_ids:
 	kfree(phba->sli4_hba.rpi_ids);
+	phba->sli4_hba.rpi_ids = NULL;
  free_rpi_bmask:
 	kfree(phba->sli4_hba.rpi_bmask);
+	phba->sli4_hba.rpi_bmask = NULL;
  err_exit:
 	return rc;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 394fe13..dcb33f4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -393,6 +393,7 @@ struct MPT3SAS_TARGET {
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
  * @eedp_block_length: block size
+ * @ata_command_pending: SATL passthrough outstanding for device
  */
 struct MPT3SAS_DEVICE {
 	struct MPT3SAS_TARGET *sas_target;
@@ -404,6 +405,17 @@ struct MPT3SAS_DEVICE {
 	u8	ignore_delay_remove;
 	/* Iopriority Command Handling */
 	u8	ncq_prio_enable;
+	/*
+	 * Bug workaround for SATL handling: the mpt2/3sas firmware
+	 * doesn't return BUSY or TASK_SET_FULL for subsequent
+	 * commands while a SATL pass through is in operation as the
+	 * spec requires, it simply does nothing with them until the
+	 * pass through completes, causing them possibly to timeout if
+	 * the passthrough is a long executing command (like format or
+	 * secure erase).  This variable allows us to do the right
+	 * thing while a SATL command is pending.
+	 */
+	unsigned long ata_command_pending;
 
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..75f3fce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3899,9 +3899,18 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 {
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+	struct MPT3SAS_DEVICE *priv = scmd->device->hostdata;
+
+	if (scmd->cmnd[0] != ATA_12 && scmd->cmnd[0] != ATA_16)
+		return 0;
+
+	if (pending)
+		return test_and_set_bit(0, &priv->ata_command_pending);
+
+	clear_bit(0, &priv->ata_command_pending);
+	return 0;
 }
 
 /**
@@ -3925,9 +3934,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
-		if (ata_12_16_cmd(scmd))
-			scsi_internal_device_unblock(scmd->device,
-							SDEV_RUNNING);
+		_scsih_set_satl_pending(scmd, false);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4063,13 +4070,6 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
-	/*
-	 * Lock the device for any subsequent command until command is
-	 * done.
-	 */
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
-
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4083,6 +4083,19 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		return 0;
 	}
 
+	/*
+	 * Bug work around for firmware SATL handling.  The loop
+	 * is based on atomic operations and ensures consistency
+	 * since we're lockless at this point
+	 */
+	do {
+		if (test_bit(0, &sas_device_priv_data->ata_command_pending)) {
+			scmd->result = SAM_STAT_BUSY;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
+	} while (_scsih_set_satl_pending(scmd, true));
+
 	sas_target_priv_data = sas_device_priv_data->sas_target;
 
 	/* invalid device handle */
@@ -4650,8 +4663,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
-	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+	_scsih_set_satl_pending(scmd, false);
 
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 47eb4d5..83f8527 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -243,12 +243,15 @@ qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
 	struct qla_hw_data *ha = vha->hw;
 	ssize_t rval = 0;
 
+	mutex_lock(&ha->optrom_mutex);
+
 	if (ha->optrom_state != QLA_SREADING)
-		return 0;
+		goto out;
 
-	mutex_lock(&ha->optrom_mutex);
 	rval = memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
 	    ha->optrom_region_size);
+
+out:
 	mutex_unlock(&ha->optrom_mutex);
 
 	return rval;
@@ -263,14 +266,19 @@ qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ha->optrom_state != QLA_SWRITING)
+	mutex_lock(&ha->optrom_mutex);
+
+	if (ha->optrom_state != QLA_SWRITING) {
+		mutex_unlock(&ha->optrom_mutex);
 		return -EINVAL;
-	if (off > ha->optrom_region_size)
+	}
+	if (off > ha->optrom_region_size) {
+		mutex_unlock(&ha->optrom_mutex);
 		return -ERANGE;
+	}
 	if (off + count > ha->optrom_region_size)
 		count = ha->optrom_region_size - off;
 
-	mutex_lock(&ha->optrom_mutex);
 	memcpy(&ha->optrom_buffer[off], buf, count);
 	mutex_unlock(&ha->optrom_mutex);
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f7df01b..1549aac 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2732,7 +2732,7 @@ struct isp_operations {
 #define QLA_MSIX_FW_MODE(m)	(((m) & (BIT_7|BIT_8|BIT_9)) >> 7)
 #define QLA_MSIX_FW_MODE_1(m)	(QLA_MSIX_FW_MODE(m) == 1)
 
-#define QLA_MSIX_DEFAULT		0x00
+#define QLA_BASE_VECTORS	2 /* default + RSP */
 #define QLA_MSIX_RSP_Q			0x01
 #define QLA_ATIO_VECTOR		0x02
 #define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
@@ -2754,7 +2754,6 @@ struct qla_msix_entry {
 	uint16_t entry;
 	char name[30];
 	void *handle;
-	struct irq_affinity_notify irq_notify;
 	int cpuid;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5093ca9..54e1223 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -19,10 +19,6 @@ static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
 static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
-static void qla_irq_affinity_notify(struct irq_affinity_notify *,
-    const cpumask_t *);
-static void qla_irq_affinity_release(struct kref *);
-
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
@@ -2572,14 +2568,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (!vha->flags.online)
 		return;
 
-	if (rsp->msix && rsp->msix->cpuid != smp_processor_id()) {
-		/* if kernel does not notify qla of IRQ's CPU change,
-		 * then set it here.
-		 */
-		rsp->msix->cpuid = smp_processor_id();
-		ha->tgt.rspq_vector_cpuid = rsp->msix->cpuid;
-	}
-
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
@@ -3018,13 +3006,20 @@ static struct qla_init_msix_entry qla82xx_msix_entries[] = {
 static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
-#define MIN_MSIX_COUNT	2
 	int i, ret;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	struct irq_affinity desc = {
+		.pre_vectors = QLA_BASE_VECTORS,
+	};
+
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha))
+		desc.pre_vectors++;
+
+	ret = pci_alloc_irq_vectors_affinity(ha->pdev, QLA_BASE_VECTORS,
+			ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+			&desc);
 
-	ret = pci_alloc_irq_vectors(ha->pdev, MIN_MSIX_COUNT, ha->msix_count,
-				    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
 		    "MSI-X: Failed to enable support, "
@@ -3069,13 +3064,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		qentry->have_irq = 0;
 		qentry->in_use = 0;
 		qentry->handle = NULL;
-		qentry->irq_notify.notify  = qla_irq_affinity_notify;
-		qentry->irq_notify.release = qla_irq_affinity_release;
-		qentry->cpuid = -1;
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < (QLA_MSIX_RSP_Q + 1); i++) {
+	for (i = 0; i < QLA_BASE_VECTORS; i++) {
 		qentry = &ha->msix_entries[i];
 		qentry->handle = rsp;
 		rsp->msix = qentry;
@@ -3093,18 +3085,6 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->in_use = 1;
-
-		/* Register for CPU affinity notification. */
-		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
-
-		/* Schedule work (ie. trigger a notification) to read cpu
-		 * mask for this specific irq.
-		 * kref_get is required because
-		* irq_affinity_notify() will do
-		* kref_put().
-		*/
-		kref_get(&qentry->irq_notify.kref);
-		schedule_work(&qentry->irq_notify.work);
 	}
 
 	/*
@@ -3301,49 +3281,3 @@ int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
 	msix->handle = qpair;
 	return ret;
 }
-
-
-/* irq_set_affinity/irqbalance will trigger notification of cpu mask update */
-static void qla_irq_affinity_notify(struct irq_affinity_notify *notify,
-	const cpumask_t *mask)
-{
-	struct qla_msix_entry *e =
-		container_of(notify, struct qla_msix_entry, irq_notify);
-	struct qla_hw_data *ha;
-	struct scsi_qla_host *base_vha;
-	struct rsp_que *rsp = e->handle;
-
-	/* user is recommended to set mask to just 1 cpu */
-	e->cpuid = cpumask_first(mask);
-
-	ha = rsp->hw;
-	base_vha = pci_get_drvdata(ha->pdev);
-
-	ql_dbg(ql_dbg_init, base_vha, 0xffff,
-	    "%s: host %ld : vector %d cpu %d \n", __func__,
-	    base_vha->host_no, e->vector, e->cpuid);
-
-	if (e->have_irq) {
-		if ((IS_QLA83XX(ha) || IS_QLA27XX(ha)) &&
-		    (e->entry == QLA83XX_RSPQ_MSIX_ENTRY_NUMBER)) {
-			ha->tgt.rspq_vector_cpuid = e->cpuid;
-			ql_dbg(ql_dbg_init, base_vha, 0xffff,
-			    "%s: host%ld: rspq vector %d cpu %d  runtime change\n",
-			    __func__, base_vha->host_no, e->vector, e->cpuid);
-		}
-	}
-}
-
-static void qla_irq_affinity_release(struct kref *ref)
-{
-	struct irq_affinity_notify *notify =
-		container_of(ref, struct irq_affinity_notify, kref);
-	struct qla_msix_entry *e =
-		container_of(notify, struct qla_msix_entry, irq_notify);
-	struct rsp_que *rsp = e->handle;
-	struct scsi_qla_host *base_vha = pci_get_drvdata(rsp->hw->pdev);
-
-	ql_dbg(ql_dbg_init, base_vha, 0xffff,
-		"%s: host%ld: vector %d cpu %d\n", __func__,
-	    base_vha->host_no, e->vector, e->cpuid);
-}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8521cfe..ad4edc1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -466,7 +466,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 			continue;
 
 		rsp = ha->rsp_q_map[cnt];
-		clear_bit(cnt, ha->req_qid_map);
+		clear_bit(cnt, ha->rsp_qid_map);
 		ha->rsp_q_map[cnt] =  NULL;
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		qla2x00_free_rsp_que(ha, rsp);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b193304..6e6d4a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2600,7 +2600,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		if (sdp->broken_fua) {
 			sd_first_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
 			sdkp->DPOFUA = 0;
-		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
+		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw &&
+			   !sdkp->device->use_16_for_rw) {
 			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA = 0;
@@ -2783,13 +2784,21 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
-	sdkp->zoned = (buffer[8] >> 4) & 3;
-	if (sdkp->zoned == 1)
-		q->limits.zoned = BLK_ZONED_HA;
-	else if (sdkp->device->type == TYPE_ZBC)
+	if (sdkp->device->type == TYPE_ZBC) {
+		/* Host-managed */
 		q->limits.zoned = BLK_ZONED_HM;
-	else
-		q->limits.zoned = BLK_ZONED_NONE;
+	} else {
+		sdkp->zoned = (buffer[8] >> 4) & 3;
+		if (sdkp->zoned == 1)
+			/* Host-aware */
+			q->limits.zoned = BLK_ZONED_HA;
+		else
+			/*
+			 * Treat drive-managed devices as
+			 * regular block devices.
+			 */
+			q->limits.zoned = BLK_ZONED_NONE;
+	}
 	if (blk_queue_is_zoned(q) && sdkp->first_scan)
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 8c9a35c..50adabb 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 
 	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
 
-	if (scsi_is_sas_rphy(&sdev->sdev_gendev))
+	if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
 		efd.addr = sas_get_address(sdev);
 
 	if (efd.addr) {
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 96dd0b3..da5033d 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -809,11 +809,11 @@ static inline void fc_set_wwnn(struct fc_lport *lport, u64 wwnn)
 /**
  * fc_set_wwpn() - Set the World Wide Port Name of a local port
  * @lport: The local port whose WWPN is to be set
- * @wwnn:  The new WWPN
+ * @wwpn:  The new WWPN
  */
-static inline void fc_set_wwpn(struct fc_lport *lport, u64 wwnn)
+static inline void fc_set_wwpn(struct fc_lport *lport, u64 wwpn)
 {
-	lport->wwpn = wwnn;
+	lport->wwpn = wwpn;
 }
 
 /**
