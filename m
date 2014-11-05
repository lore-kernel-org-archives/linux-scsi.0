From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libsas: use ata_dev_classify()
Date: Wed,  5 Nov 2014 13:08:20 +0100
Message-ID: <1415189302-108476-2-git-send-email-hare@suse.de>
References: <1415189302-108476-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1415189302-108476-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

Use the ata device class from libata in libsas instead of checking
the supported command set and switch to using ata_dev_classify()
instead of our own method.

Cc: Tejun Heo <tj@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 10 +++---
 drivers/scsi/isci/request.c         |  4 +--
 drivers/scsi/libsas/sas_ata.c       | 66 +++++++------------------------------
 drivers/scsi/mvsas/mv_sas.c         |  4 +--
 drivers/scsi/pm8001/pm8001_hwi.c    |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c    |  2 +-
 include/scsi/libsas.h               | 11 ++-----
 7 files changed, 25 insertions(+), 74 deletions(-)

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
index 766098a..9f68db7 100644
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
@@ -626,50 +614,18 @@ void sas_ata_task_abort(struct sas_task *task)
 	complete(waiting);
 }
 
-static void sas_get_ata_command_set(struct domain_device *dev)
+static int sas_get_ata_command_set(struct domain_device *dev)
 {
 	struct dev_to_host_fis *fis =
 		(struct dev_to_host_fis *) dev->frame_rcvd;
+	struct ata_taskfile tf;
 
 	if (dev->dev_type == SAS_SATA_PENDING)
-		return;
+		return ATA_DEV_UNKNOWN;
+
+	ata_tf_from_fis((const u8 *)fis, &tf);
 
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
+	return ata_dev_classify(&tf);
 }
 
 void sas_probe_sata(struct asd_sas_port *port)
@@ -775,7 +731,7 @@ int sas_discover_sata(struct domain_device *dev)
 	if (dev->dev_type == SAS_SATA_PM)
 		return -ENODEV;
 
-	sas_get_ata_command_set(dev);
+	dev->sata_dev.class = sas_get_ata_command_set(dev);
 	sas_fill_in_rphy(dev, dev->rphy);
 
 	res = sas_notify_lldd_dev_found(dev);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index ac52f7c..48a493c 100644
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
index 933f214..96dcc09 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4367,7 +4367,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
 		}
 		if (task->ata_task.use_ncq &&
-			dev->sata_dev.command_set != ATAPI_COMMAND_SET) {
+			dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index b06443a..05cce46 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4077,7 +4077,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("PIO\n"));
 		}
 		if (task->ata_task.use_ncq &&
-			dev->sata_dev.command_set != ATAPI_COMMAND_SET) {
+		    dev->sata_dev.class != ATA_DEV_ATAPI) {
 			ATAP = 0x07; /* FPDMA */
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
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
1.8.5.2

