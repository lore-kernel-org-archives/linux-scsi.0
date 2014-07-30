From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] libata: consolidate ata_dev_classify()
Date: Wed, 30 Jul 2014 09:55:08 +0200
Message-ID: <1406706911-79510-2-git-send-email-hare@suse.de>
References: <1406706911-79510-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaG3HzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 03:55:16 -0400
In-Reply-To: <1406706911-79510-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>

ata_dev_classify() just uses the 'lbah' and 'lbam'
fields from the taskfile, so we can as well use those
as arguments and rip out the custom code from sas_ata.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libahci.c               | 11 +++----
 drivers/ata/libata-core.c           | 14 +++++----
 drivers/ata/libata-sff.c            |  2 +-
 drivers/ata/sata_fsl.c              | 11 +++----
 drivers/ata/sata_inic162x.c         |  2 +-
 drivers/ata/sata_sil24.c            |  2 +-
 drivers/scsi/aic94xx/aic94xx_task.c | 10 +++---
 drivers/scsi/isci/request.c         |  4 +--
 drivers/scsi/libsas/sas_ata.c       | 63 +++++--------------------------------
 drivers/scsi/mvsas/mv_sas.c         |  4 +--
 drivers/scsi/pm8001/pm8001_hwi.c    |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c    |  2 +-
 include/linux/libata.h              |  2 +-
 include/scsi/libsas.h               | 11 ++-----
 14 files changed, 44 insertions(+), 96 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d72ce04..09f9fcb 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1185,16 +1185,15 @@ static void ahci_dev_config(struct ata_device *dev)
 unsigned int ahci_dev_classify(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
-	struct ata_taskfile tf;
+	u8 lbah, lbam, lbal;
 	u32 tmp;
 
 	tmp = readl(port_mmio + PORT_SIG);
-	tf.lbah		= (tmp >> 24)	& 0xff;
-	tf.lbam		= (tmp >> 16)	& 0xff;
-	tf.lbal		= (tmp >> 8)	& 0xff;
-	tf.nsect	= (tmp)		& 0xff;
+	lbah		= (tmp >> 24)	& 0xff;
+	lbam		= (tmp >> 16)	& 0xff;
+	lbal		= (tmp >> 8)	& 0xff;
 
-	return ata_dev_classify(&tf);
+	return ata_dev_classify(lbah, lbam, lbal);
 }
 EXPORT_SYMBOL_GPL(ahci_dev_classify);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 18d97d5..2c4d742 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1032,7 +1032,9 @@ const char *sata_spd_string(unsigned int spd)
 
 /**
  *	ata_dev_classify - determine device type based on ATA-spec signature
- *	@tf: ATA taskfile register set for device to be identified
+ *	@lbah: LBA high byte (LBA bits 23:16)
+ *	@lbam: LBA mid byte (LBA bits 15:8)
+ *	@lbal: LBA low byte (LBA bits 7:0)
  *
  *	Determine from taskfile register contents whether a device is
  *	ATA or ATAPI, as per "Signature and persistence" section
@@ -1045,7 +1047,7 @@ const char *sata_spd_string(unsigned int spd)
  *	Device type, %ATA_DEV_ATA, %ATA_DEV_ATAPI, %ATA_DEV_PMP or
  *	%ATA_DEV_UNKNOWN the event of failure.
  */
-unsigned int ata_dev_classify(const struct ata_taskfile *tf)
+unsigned int ata_dev_classify(u8 lbah, u8 lbam, u8 lbal)
 {
 	/* Apple's open source Darwin code hints that some devices only
 	 * put a proper signature into the LBA mid/high registers,
@@ -1068,22 +1070,22 @@ unsigned int ata_dev_classify(const struct ata_taskfile *tf)
 	 * SEMB signature.  This is worked around in
 	 * ata_dev_read_id().
 	 */
-	if ((tf->lbam == 0) && (tf->lbah == 0)) {
+	if ((lbam == 0) && (lbah == 0)) {
 		DPRINTK("found ATA device by sig\n");
 		return ATA_DEV_ATA;
 	}
 
-	if ((tf->lbam == 0x14) && (tf->lbah == 0xeb)) {
+	if ((lbam == 0x14) && (lbah == 0xeb)) {
 		DPRINTK("found ATAPI device by sig\n");
 		return ATA_DEV_ATAPI;
 	}
 
-	if ((tf->lbam == 0x69) && (tf->lbah == 0x96)) {
+	if ((lbam == 0x69) && (lbah == 0x96)) {
 		DPRINTK("found PMP device by sig\n");
 		return ATA_DEV_PMP;
 	}
 
-	if ((tf->lbam == 0x3c) && (tf->lbah == 0xc3)) {
+	if ((lbam == 0x3c) && (lbah == 0xc3)) {
 		DPRINTK("found SEMB device by sig (could be ATA device)\n");
 		return ATA_DEV_SEMB;
 	}
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1121153..ec9b5db 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1903,7 +1903,7 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 		return ATA_DEV_NONE;
 
 	/* determine if device is ATA or ATAPI */
-	class = ata_dev_classify(&tf);
+	class = ata_dev_classify(tf.lbah, tf.lbam, tf.lbal);
 
 	if (class == ATA_DEV_UNKNOWN) {
 		/* If the device failed diagnostic, it's likely to
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 616a6d2..2194fa0 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -807,8 +807,8 @@ static unsigned int sata_fsl_dev_classify(struct ata_port *ap)
 {
 	struct sata_fsl_host_priv *host_priv = ap->host->private_data;
 	void __iomem *hcr_base = host_priv->hcr_base;
-	struct ata_taskfile tf;
 	u32 temp;
+	u8 lbah, lbam, lbal;
 
 	temp = ioread32(hcr_base + SIGNATURE);
 
@@ -816,12 +816,11 @@ static unsigned int sata_fsl_dev_classify(struct ata_port *ap)
 	VPRINTK("HStatus = 0x%x\n", ioread32(hcr_base + HSTATUS));
 	VPRINTK("HControl = 0x%x\n", ioread32(hcr_base + HCONTROL));
 
-	tf.lbah = (temp >> 24) & 0xff;
-	tf.lbam = (temp >> 16) & 0xff;
-	tf.lbal = (temp >> 8) & 0xff;
-	tf.nsect = temp & 0xff;
+	lbah = (temp >> 24) & 0xff;
+	lbam = (temp >> 16) & 0xff;
+	lbal = (temp >>  8) & 0xff;
 
-	return ata_dev_classify(&tf);
+	return ata_dev_classify(lbah, lbam, lbal);
 }
 
 static int sata_fsl_hardreset(struct ata_link *link, unsigned int *class,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 0698278..7d95cc4 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -649,7 +649,7 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 		}
 
 		inic_tf_read(ap, &tf);
-		*class = ata_dev_classify(&tf);
+		*class = ata_dev_classify(tf. lbah, tf.lbam, tf.lbal);
 	}
 
 	return 0;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 0534890..c69ebaf 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -686,7 +686,7 @@ static int sil24_softreset(struct ata_link *link, unsigned int *class,
 	}
 
 	sil24_read_tf(ap, 0, &tf);
-	*class = ata_dev_classify(&tf);
+	*class = ata_dev_classify(tf. lbah, tf.lbam, tf.lbal);
 
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 59b86e2..7abbe42 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -373,10 +373,10 @@ static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 
 	if (unlikely(task->ata_task.device_control_reg_update))
 		scb->header.opcode = CONTROL_ATA_DEV;
-	else if (dev->sata_dev.command_set == ATA_COMMAND_SET)
-		scb->header.opcode = INITIATE_ATA_TASK;
-	else
+	else if (dev->sata_dev.class == ATA_DEV_ATAPI)
 		scb->header.opcode = INITIATE_ATAPI_TASK;
+	else
+		scb->header.opcode = INITIATE_ATA_TASK;
 
 	scb->ata_task.proto_conn_rate = (1 << 5); /* STP */
 	if (dev->port->oob_mode == SAS_OOB_MODE)
@@ -387,7 +387,7 @@ static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	if (likely(!task->ata_task.device_control_reg_update))
 		scb->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
 	scb->ata_task.fis.flags &= 0xF0; /* PM_PORT field shall be 0 */
-	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
+	if (dev->sata_dev.class == ATA_DEV_ATAPI)
 		memcpy(scb->ata_task.atapi_packet, task->ata_task.atapi_packet,
 		       16);
 	scb->ata_task.sister_scb = cpu_to_le16(0xFFFF);
@@ -399,7 +399,7 @@ static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 		if (task->ata_task.dma_xfer)
 			flags |= DATA_XFER_MODE_DMA;
 		if (task->ata_task.use_ncq &&
-		    dev->sata_dev.command_set != ATAPI_COMMAND_SET)
+		    dev->sata_dev.class != ATA_DEV_ATAPI)
 			flags |= ATA_Q_TYPE_NCQ;
 		flags |= data_dir_flags[task->data_dir];
 		scb->ata_task.ata_flags = flags;
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 56e3809..cfd0084 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -694,7 +694,7 @@ sci_io_request_construct_sata(struct isci_request *ireq,
 	}
 
 	/* ATAPI */
-	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET &&
+	if (dev->sata_dev.class == ATA_DEV_ATAPI &&
 	    task->ata_task.fis.command == ATA_CMD_PACKET) {
 		sci_atapi_construct(ireq);
 		return SCI_SUCCESS;
@@ -2980,7 +2980,7 @@ static void sci_request_started_state_enter(struct sci_base_state_machine *sm)
 		state = SCI_REQ_SMP_WAIT_RESP;
 	} else if (task && sas_protocol_ata(task->task_proto) &&
 		   !task->ata_task.use_ncq) {
-		if (dev->sata_dev.command_set == ATAPI_COMMAND_SET &&
+		if (dev->sata_dev.class == ATA_DEV_ATAPI &&
 			task->ata_task.fis.command == ATA_CMD_PACKET) {
 			state = SCI_REQ_ATAPI_WAIT_H2D;
 		} else if (task->data_dir == DMA_NONE) {
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..865de86 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -138,7 +138,7 @@ static void sas_ata_task_done(struct sas_task *task)
 
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
 	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
-	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
+	      dev->sata_dev.class == ATA_DEV_ATAPI))) {
 		memcpy(dev->sata_dev.fis, resp->ending_fis, ATA_RESP_FIS_SIZE);
 
 		if (!link->sactive) {
@@ -278,7 +278,7 @@ static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
 	return to_sas_internal(dev->port->ha->core.shost->transportt);
 }
 
-static void sas_get_ata_command_set(struct domain_device *dev);
+static int sas_get_ata_command_set(struct domain_device *dev);
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 {
@@ -303,8 +303,7 @@ int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
 		}
 		memcpy(dev->frame_rcvd, &dev->sata_dev.rps_resp.rps.fis,
 		       sizeof(struct dev_to_host_fis));
-		/* TODO switch to ata_dev_classify() */
-		sas_get_ata_command_set(dev);
+		dev->sata_dev.class = sas_get_ata_command_set(dev);
 	}
 	return 0;
 }
@@ -425,18 +424,7 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	if (ret && ret != -EAGAIN)
 		sas_ata_printk(KERN_ERR, dev, "reset failed (errno=%d)\n", ret);
 
-	/* XXX: if the class changes during the reset the upper layer
-	 * should be informed, if the device has gone away we assume
-	 * libsas will eventually delete it
-	 */
-	switch (dev->sata_dev.command_set) {
-	case ATA_COMMAND_SET:
-		*class = ATA_DEV_ATA;
-		break;
-	case ATAPI_COMMAND_SET:
-		*class = ATA_DEV_ATAPI;
-		break;
-	}
+	*class = dev->sata_dev.class;
 
 	ap->cbl = ATA_CBL_SATA;
 	return ret;
@@ -626,50 +614,15 @@ void sas_ata_task_abort(struct sas_task *task)
 	complete(waiting);
 }
 
-static void sas_get_ata_command_set(struct domain_device *dev)
+static int sas_get_ata_command_set(struct domain_device *dev)
 {
 	struct dev_to_host_fis *fis =
 		(struct dev_to_host_fis *) dev->frame_rcvd;
 
 	if (dev->dev_type == SAS_SATA_PENDING)
-		return;
+		return ATA_DEV_UNKNOWN;
 
-	if ((fis->sector_count == 1 && /* ATA */
-	     fis->lbal         == 1 &&
-	     fis->lbam         == 0 &&
-	     fis->lbah         == 0 &&
-	     fis->device       == 0)
-	    ||
-	    (fis->sector_count == 0 && /* CE-ATA (mATA) */
-	     fis->lbal         == 0 &&
-	     fis->lbam         == 0xCE &&
-	     fis->lbah         == 0xAA &&
-	     (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATA_COMMAND_SET;
-
-	else if ((fis->interrupt_reason == 1 &&	/* ATAPI */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x14 &&
-		  fis->byte_count_high  == 0xEB &&
-		  (fis->device & ~0x10) == 0))
-
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
-
-	else if ((fis->sector_count == 1 && /* SEMB */
-		  fis->lbal         == 1 &&
-		  fis->lbam         == 0x3C &&
-		  fis->lbah         == 0xC3 &&
-		  fis->device       == 0)
-		||
-		 (fis->interrupt_reason == 1 &&	/* SATA PM */
-		  fis->lbal             == 1 &&
-		  fis->byte_count_low   == 0x69 &&
-		  fis->byte_count_high  == 0x96 &&
-		  (fis->device & ~0x10) == 0))
-
-		/* Treat it as a superset? */
-		dev->sata_dev.command_set = ATAPI_COMMAND_SET;
+	return ata_dev_classify(fis->lbah, fis->lbam, fis->lbal);
 }
 
 void sas_probe_sata(struct asd_sas_port *port)
@@ -775,7 +728,7 @@ int sas_discover_sata(struct domain_device *dev)
 	if (dev->dev_type == SAS_SATA_PM)
 		return -ENODEV;
 
-	sas_get_ata_command_set(dev);
+	dev->sata_dev.class = sas_get_ata_command_set(dev);
 	sas_fill_in_rphy(dev, dev->rphy);
 
 	res = sas_notify_lldd_dev_found(dev);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..44625b8 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -479,7 +479,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 
 	if (task->ata_task.use_ncq)
 		flags |= MCH_FPDMA;
-	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
+	if (dev->sata_dev.class == ATA_DEV_ATAPI) {
 		if (task->ata_task.fis.command != ATA_CMD_ID_ATAPI)
 			flags |= MCH_ATAPI;
 	}
@@ -546,7 +546,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 		task->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
 	/* fill in command FIS and ATAPI CDB */
 	memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
-	if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
+	if (dev->sata_dev.class == ATA_DEV_ATAPI)
 		memcpy(buf_cmd + STP_ATAPI_CMD,
 			task->ata_task.atapi_packet, 16);
 
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index a97be01..70f9b45 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4356,7 +4356,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
 		}
 		if (task->ata_task.use_ncq &&
-			dev->sata_dev.command_set != ATAPI_COMMAND_SET) {
+			dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d70587f..b1f47f7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4059,7 +4059,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
 		}
 		if (task->ata_task.use_ncq &&
-			dev->sata_dev.command_set != ATAPI_COMMAND_SET) {
+		    dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5ab4e3a..3412aee 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1172,7 +1172,7 @@ extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
-extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
+extern unsigned int ata_dev_classify(u8 lbah, u8 lbam, u8 lbal);
 extern void ata_dev_disable(struct ata_device *adev);
 extern void ata_id_string(const u16 *id, unsigned char *s,
 			  unsigned int ofs, unsigned int len);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ef7872c..8528a09 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -161,17 +161,12 @@ struct expander_device {
 };
 
 /* ---------- SATA device ---------- */
-enum ata_command_set {
-        ATA_COMMAND_SET   = 0,
-        ATAPI_COMMAND_SET = 1,
-};
-
 #define ATA_RESP_FIS_SIZE 24
 
 struct sata_device {
-        enum   ata_command_set command_set;
-        struct smp_resp        rps_resp; /* report_phy_sata_resp */
-        u8     port_no;        /* port number, if this is a PM (Port) */
+	unsigned int class;
+	struct smp_resp        rps_resp; /* report_phy_sata_resp */
+	u8     port_no;        /* port number, if this is a PM (Port) */
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
-- 
1.7.12.4

