From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 14/15] pm80xx: NCQ error handling changes
Date: Tue, 12 Feb 2013 04:43:39 -0800
Message-ID: <511A38FB.5080802@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48670 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932927Ab3BLMm5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:42:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From 97d4edce607941e931b77d1fed12096294ff6c8e Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Wed, 6 Feb 2013 17:27:22 +0530
Subject: [PATCH 14/15] pm80xx: NCQ error handling changes

Handled NCQ errors in the low level driver as the FW
is not providing the faulty tag for NCQ errors for libsas
to recover.

Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  270 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_sas.c |   22 +++-
 drivers/scsi/pm8001/pm8001_sas.h |   15 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c |  262 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.h |    1 +
 5 files changed, 543 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 265dbf4..a90c002 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1707,6 +1707,123 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
 	return ret;
 }
 
+static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_device *pm8001_ha_dev)
+{
+	int res;
+	u32 ccb_tag;
+	struct pm8001_ccb_info *ccb;
+	struct sas_task *task = NULL;
+	struct task_abort_req task_abort;
+	struct inbound_queue_table *circularQ;
+	u32 opc = OPC_INB_SATA_ABORT;
+	int ret;
+
+	if (!pm8001_ha_dev) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null \n"));
+		return;
+	}
+
+	task = sas_alloc_slow_task(GFP_ATOMIC);
+
+	if (!task) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
+						"allocate task \n"));
+		return;
+	}
+
+	task->task_done = pm8001_task_done;
+
+	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
+	if (res)
+		return;
+
+	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb->device = pm8001_ha_dev;
+	ccb->ccb_tag = ccb_tag;
+	ccb->task = task;
+
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	memset(&task_abort, 0, sizeof(task_abort));
+	task_abort.abort_all = cpu_to_le32(1);
+	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
+	task_abort.tag = cpu_to_le32(ccb_tag);
+
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+
+}
+
+static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_device *pm8001_ha_dev)
+{
+	struct sata_start_req sata_cmd;
+	int res;
+	u32 ccb_tag;
+	struct pm8001_ccb_info *ccb;
+	struct sas_task *task = NULL;
+	struct host_to_dev_fis fis;
+	struct domain_device *dev;
+	struct inbound_queue_table *circularQ;
+	u32 opc = OPC_INB_SATA_HOST_OPSTART;
+
+	task = sas_alloc_slow_task(GFP_ATOMIC);
+
+	if (!task) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("cannot allocate task !!!\n"));
+		return;
+	}
+	task->task_done = pm8001_task_done;
+
+	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
+	if (res) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("cannot allocate tag !!!\n"));
+		return;
+	}
+
+	/* allocate domain device by ourselves as libsas
+	 * is not going to provide any
+	*/
+	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
+	if (!dev) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("Domain device cannot be allocated \n"));
+		sas_free_task(task);
+		return;
+	} else {
+		task->dev = dev;
+		task->dev->lldd_dev = pm8001_ha_dev;
+	}
+
+	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb->device = pm8001_ha_dev;
+	ccb->ccb_tag = ccb_tag;
+	ccb->task = task;
+	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
+	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
+
+	memset(&sata_cmd, 0, sizeof(sata_cmd));
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	/* construct read log FIS */
+	memset(&fis, 0, sizeof(struct host_to_dev_fis));
+	fis.fis_type = 0x27;
+	fis.flags = 0x80;
+	fis.command = ATA_CMD_READ_LOG_EXT;
+	fis.lbal = 0x10;
+	fis.sector_count = 0x1;
+
+	sata_cmd.tag = cpu_to_le32(ccb_tag);
+	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
+	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
+	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
+
+	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
+
+}
+
 /**
  * mpi_ssp_completion- process the event that FW response to the SSP request.
  * @pm8001_ha: our hba card information
@@ -2170,16 +2287,44 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	status = le32_to_cpu(psataPayload->status);
 	tag = le32_to_cpu(psataPayload->tag);
 
+	if (!tag) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("tag null \n"));
+		return;
+	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	param = le32_to_cpu(psataPayload->param);
-	t = ccb->task;
+	if (ccb) {
+		t = ccb->task;
+		pm8001_dev = ccb->device;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("ccb null \n"));
+		return;
+	}
+
+	if (t) {
+		if (t->dev && (t->dev->lldd_dev))
+			pm8001_dev = t->dev->lldd_dev;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("task null\n"));
+		return;
+	}
+
+	if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
+		&& unlikely(!t || !t->lldd_task || !t->dev)) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("task or dev null\n"));
+		return;
+	}
+
 	ts = &t->task_status;
-	pm8001_dev = ccb->device;
-	if (status)
+	if (!ts) {
 		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sata IO status 0x%x\n", status));
-	if (unlikely(!t || !t->lldd_task || !t->dev))
+			pm8001_printk("ts null \n"));
 		return;
+	}
 
 	switch (status) {
 	case IO_SUCCESS:
@@ -2187,6 +2332,19 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
+			/* check if response is for SEND READ LOG */
+			if (pm8001_dev &&
+				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
+				/* set new bit for abort_all */
+				pm8001_dev->id |= NCQ_ABORT_ALL_FLAG;
+				/* clear bit for read log */
+				pm8001_dev->id = pm8001_dev->id & 0x7FFFFFFF;
+				pm8001_send_abort_all(pm8001_ha, pm8001_dev);
+				/* Free the tag */
+				pm8001_tag_free(pm8001_ha, tag);
+				sas_free_task(t);
+				return;
+			}
 		} else {
 			u8 len;
 			ts->resp = SAS_TASK_COMPLETE;
@@ -2498,6 +2656,29 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
+
+	if (ccb) {
+		t = ccb->task;
+		pm8001_dev = ccb->device;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("No CCB !!!. returning \n"));
+	}
+	if (event)
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("SATA EVENT 0x%x\n", event));
+
+	/* Check if this is NCQ error */
+	if (event == IO_XFER_ERROR_ABORTED_NCQ_MODE) {
+		/* find device using device id */
+		pm8001_dev = pm8001_find_dev(pm8001_ha, dev_id);
+		/* send read log extension */
+		if (pm8001_dev)
+			pm8001_send_read_log(pm8001_ha, pm8001_dev);
+		return;
+	}
+
+	ccb = &pm8001_ha->ccb_info[tag];
 	t = ccb->task;
 	pm8001_dev = ccb->device;
 	if (event)
@@ -3512,19 +3693,29 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 status ;
 	u32 tag, scp;
 	struct task_status_struct *ts;
+	struct pm8001_device *pm8001_dev;
 
 	struct task_abort_resp *pPayload =
 		(struct task_abort_resp *)(piomb + 4);
 
 	status = le32_to_cpu(pPayload->status);
 	tag = le32_to_cpu(pPayload->tag);
+	if (!tag) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk(" TAG NULL. RETURNING !!!"));
+		return -1;
+	}
+
 	scp = le32_to_cpu(pPayload->scp);
 	ccb = &pm8001_ha->ccb_info[tag];
 	t = ccb->task;
-	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk(" status = 0x%x\n", status));
-	if (t == NULL)
+	pm8001_dev = ccb->device; /* retrieve device */
+
+	if (!t)	{
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk(" TASK NULL. RETURNING !!!"));
 		return -1;
+	}
 	ts = &t->task_status;
 	if (status != 0)
 		PM8001_FAIL_DBG(pm8001_ha,
@@ -3548,7 +3739,15 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	spin_unlock_irqrestore(&t->task_state_lock, flags);
 	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	mb();
-	t->task_done(t);
+
+	if ((pm8001_dev->id & NCQ_ABORT_ALL_FLAG) && t)	{
+		pm8001_tag_free(pm8001_ha, tag);
+		sas_free_task(t);
+		/* clear the flag */
+		pm8001_dev->id &= 0xBFFFFFFF;
+	} else
+		t->task_done(t);
+
 	return 0;
 }
 
@@ -4133,6 +4332,7 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 ATAP = 0x0;
 	u32 dir;
 	struct inbound_queue_table *circularQ;
+	unsigned long flags;
 	u32  opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -4153,8 +4353,10 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
 	}
-	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag))
+	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
+		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		ncg_tag = hdr_tag;
+	}
 	dir = data_dir_flags[task->data_dir] << 8;
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
@@ -4185,6 +4387,54 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		sata_cmd.len = cpu_to_le32(task->total_xfer_len);
 		sata_cmd.esgl = 0;
 	}
+
+	/* Check for read log for failed drive and return */
+	if (sata_cmd.sata_fis.command == 0x2f) {
+		if (pm8001_ha_dev && ((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
+			(pm8001_ha_dev->id & NCQ_ABORT_ALL_FLAG) ||
+			(pm8001_ha_dev->id & NCQ_2ND_RLE_FLAG))) {
+			struct task_status_struct *ts;
+
+			pm8001_ha_dev->id &= 0xDFFFFFFF;
+			ts = &task->task_status;
+
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			ts->resp = SAS_TASK_COMPLETE;
+			ts->stat = SAM_STAT_GOOD;
+			task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
+			task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
+			task->task_state_flags |= SAS_TASK_STATE_DONE;
+			if (unlikely((task->task_state_flags &
+					SAS_TASK_STATE_ABORTED))) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("task 0x%p resp 0x%x "
+					" stat 0x%x but aborted by upper layer "
+					"\n", task, ts->resp, ts->stat));
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			} else if (task->uldd_task) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				mb();/* ditto */
+				spin_unlock_irq(&pm8001_ha->lock);
+				task->task_done(task);
+				spin_lock_irq(&pm8001_ha->lock);
+				return 0;
+			} else if (!task->uldd_task) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				mb();/*ditto*/
+				spin_unlock_irq(&pm8001_ha->lock);
+				task->task_done(task);
+				spin_lock_irq(&pm8001_ha->lock);
+				return 0;
+			}
+		}
+	}
+
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
 	return ret;
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6bba59c..c720917 100755
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -68,7 +68,7 @@ static void pm8001_tag_clear(struct pm8001_hba_info *pm8001_ha, u32 tag)
 	clear_bit(tag, bitmap);
 }
 
-static void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
+void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
 {
 	pm8001_tag_clear(pm8001_ha, tag);
 }
@@ -565,6 +565,24 @@ struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
 	}
 	return NULL;
 }
+/**
+  * pm8001_find_dev - find a matching pm8001_device
+  * @pm8001_ha: our hba card information
+  */
+struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
+					u32 device_id)
+{
+	u32 dev;
+	for (dev = 0; dev < PM8001_MAX_DEVICES; dev++) {
+		if (pm8001_ha->devices[dev].device_id == device_id)
+			return &pm8001_ha->devices[dev];
+	}
+	if (dev == PM8001_MAX_DEVICES) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("NO MATCHING "
+				"DEVICE FOUND !!!\n"));
+	}
+	return NULL;
+}
 
 static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
 {
@@ -653,7 +671,7 @@ int pm8001_dev_found(struct domain_device *dev)
 	return pm8001_dev_found_notify(dev);
 }
 
-static void pm8001_task_done(struct sas_task *task)
+void pm8001_task_done(struct sas_task *task)
 {
 	if (!del_timer(&task->slow_task->timer))
 		return;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 53d7f3b..c1598dc 100755
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -321,7 +321,9 @@ union main_cfg_table {
 	u32			inbound_queue_offset;
 	u32			outbound_queue_offset;
 	u32			inbound_q_nppd_hppd;
-	u32			rsvd[10];
+	u32			rsvd[8];
+	u32			crc_core_dump;
+	u32			rsvd1;
 	u32			upper_event_log_addr;
 	u32			lower_event_log_addr;
 	u32			event_log_size;
@@ -492,6 +494,9 @@ struct pm8001_fw_image_header {
 #define FLASH_UPDATE_DNLD_NOT_SUPPORTED		0x10
 #define FLASH_UPDATE_DISABLED			0x11
 
+#define	NCQ_READ_LOG_FLAG			0x80000000
+#define	NCQ_ABORT_ALL_FLAG			0x40000000
+#define	NCQ_2ND_RLE_FLAG			0x20000000
 /**
  * brief param structure for firmware flash update.
  */
@@ -566,7 +571,6 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
 	dma_addr_t *pphys_addr, u32 *pphys_addr_hi, u32 *pphys_addr_lo,
 	u32 mem_size, u32 align);
 
-/********** functions common to spc & spcv - begins ************/
 void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha);
 int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 			struct inbound_queue_table *circularQ,
@@ -614,7 +618,12 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 							void *piomb);
 int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);
 int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
-/*********** functions common to spc & spcv - ends ************/
+struct sas_task *pm8001_alloc_task(void);
+void pm8001_task_done(struct sas_task *task);
+void pm8001_free_task(struct sas_task *task);
+void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag);
+struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
+					u32 device_id);
 
 int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6e1e664..3ac22e4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -270,6 +270,9 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
+	/* Disable end to end CRC checking */
+	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
+
 	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
@@ -353,6 +356,8 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity);
 	pm8001_mw32(address, MAIN_FATAL_ERROR_INTERRUPT,
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt);
+	pm8001_mw32(address, MAIN_EVENT_CRC_CHECK,
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump);
 
 	/* SPCv specific */
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.gpio_led_mapping &= 0xCFFFFFFF;
@@ -1026,6 +1031,123 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
 }
 
+static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_device *pm8001_ha_dev)
+{
+	int res;
+	u32 ccb_tag;
+	struct pm8001_ccb_info *ccb;
+	struct sas_task *task = NULL;
+	struct task_abort_req task_abort;
+	struct inbound_queue_table *circularQ;
+	u32 opc = OPC_INB_SATA_ABORT;
+	int ret;
+
+	if (!pm8001_ha_dev) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null \n"));
+		return;
+	}
+
+	task = sas_alloc_slow_task(GFP_ATOMIC);
+
+	if (!task) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("cannot "
+						"allocate task \n"));
+		return;
+	}
+
+	task->task_done = pm8001_task_done;
+
+	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
+	if (res)
+		return;
+
+	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb->device = pm8001_ha_dev;
+	ccb->ccb_tag = ccb_tag;
+	ccb->task = task;
+
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	memset(&task_abort, 0, sizeof(task_abort));
+	task_abort.abort_all = cpu_to_le32(1);
+	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
+	task_abort.tag = cpu_to_le32(ccb_tag);
+
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+
+}
+
+static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
+		struct pm8001_device *pm8001_ha_dev)
+{
+	struct sata_start_req sata_cmd;
+	int res;
+	u32 ccb_tag;
+	struct pm8001_ccb_info *ccb;
+	struct sas_task *task = NULL;
+	struct host_to_dev_fis fis;
+	struct domain_device *dev;
+	struct inbound_queue_table *circularQ;
+	u32 opc = OPC_INB_SATA_HOST_OPSTART;
+
+	task = sas_alloc_slow_task(GFP_ATOMIC);
+
+	if (!task) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("cannot allocate task !!!\n"));
+		return;
+	}
+	task->task_done = pm8001_task_done;
+
+	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
+	if (res) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("cannot allocate tag !!!\n"));
+		return;
+	}
+
+	/* allocate domain device by ourselves as libsas
+	 * is not going to provide any
+	*/
+	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
+	if (!dev) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("Domain device cannot be allocated \n"));
+		sas_free_task(task);
+		return;
+	} else {
+		task->dev = dev;
+		task->dev->lldd_dev = pm8001_ha_dev;
+	}
+
+	ccb = &pm8001_ha->ccb_info[ccb_tag];
+	ccb->device = pm8001_ha_dev;
+	ccb->ccb_tag = ccb_tag;
+	ccb->task = task;
+	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
+	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
+
+	memset(&sata_cmd, 0, sizeof(sata_cmd));
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	/* construct read log FIS */
+	memset(&fis, 0, sizeof(struct host_to_dev_fis));
+	fis.fis_type = 0x27;
+	fis.flags = 0x80;
+	fis.command = ATA_CMD_READ_LOG_EXT;
+	fis.lbal = 0x10;
+	fis.sector_count = 0x1;
+
+	sata_cmd.tag = cpu_to_le32(ccb_tag);
+	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
+	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
+	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
+
+	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
+
+}
+
 /**
  * mpi_ssp_completion- process the event that FW response to the SSP request.
  * @pm8001_ha: our hba card information
@@ -1480,22 +1602,50 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct ata_task_resp *resp ;
 	u32 *sata_resp;
 	struct pm8001_device *pm8001_dev;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	psataPayload = (struct sata_completion_resp *)(piomb + 4);
 	status = le32_to_cpu(psataPayload->status);
 	tag = le32_to_cpu(psataPayload->tag);
 
+	if (!tag) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("tag null \n"));
+		return;
+	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	param = le32_to_cpu(psataPayload->param);
-	t = ccb->task;
+	if (ccb) {
+		t = ccb->task;
+		pm8001_dev = ccb->device;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("ccb null \n"));
+		return;
+	}
+
+	if (t) {
+		if (t->dev && (t->dev->lldd_dev))
+			pm8001_dev = t->dev->lldd_dev;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("task null\n"));
+		return;
+	}
+
+	if ((pm8001_dev && !(pm8001_dev->id & NCQ_READ_LOG_FLAG))
+		&& unlikely(!t || !t->lldd_task || !t->dev)) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("task or dev null\n"));
+		return;
+	}
+
 	ts = &t->task_status;
-	pm8001_dev = ccb->device;
-	if (status)
+	if (!ts) {
 		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sata IO status 0x%x\n", status));
-	if (unlikely(!t || !t->lldd_task || !t->dev))
+			pm8001_printk("ts null \n"));
 		return;
+	}
 
 	switch (status) {
 	case IO_SUCCESS:
@@ -1503,6 +1653,19 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
+			/* check if response is for SEND READ LOG */
+			if (pm8001_dev &&
+				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
+				/* set new bit for abort_all */
+				pm8001_dev->id |= NCQ_ABORT_ALL_FLAG;
+				/* clear bit for read log */
+				pm8001_dev->id = pm8001_dev->id & 0x7FFFFFFF;
+				pm80xx_send_abort_all(pm8001_ha, pm8001_dev);
+				/* Free the tag */
+				pm8001_tag_free(pm8001_ha, tag);
+				sas_free_task(t);
+				return;
+			}
 		} else {
 			u8 len;
 			ts->resp = SAS_TASK_COMPLETE;
@@ -1807,16 +1970,39 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	u32 event = le32_to_cpu(psataPayload->event);
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
-	unsigned long flags = 0;
+	u32 dev_id = le32_to_cpu(psataPayload->device_id);
+	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
-	t = ccb->task;
-	pm8001_dev = ccb->device;
+
+	if (ccb) {
+		t = ccb->task;
+		pm8001_dev = ccb->device;
+	} else {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("No CCB !!!. returning \n"));
+		return;
+	}
 	if (event)
 		PM8001_FAIL_DBG(pm8001_ha,
-			pm8001_printk("sata IO status 0x%x\n", event));
-	if (unlikely(!t || !t->lldd_task || !t->dev))
+			pm8001_printk("SATA EVENT 0x%x\n", event));
+
+	/* Check if this is NCQ error */
+	if (event == IO_XFER_ERROR_ABORTED_NCQ_MODE) {
+		/* find device using device id */
+		pm8001_dev = pm8001_find_dev(pm8001_ha, dev_id);
+		/* send read log extension */
+		if (pm8001_dev)
+			pm80xx_send_read_log(pm8001_ha, pm8001_dev);
+		return;
+	}
+
+	if (unlikely(!t || !t->lldd_task || !t->dev)) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("task or dev null\n"));
 		return;
+	}
+
 	ts = &t->task_status;
 	PM8001_IO_DBG(pm8001_ha,
 		pm8001_printk("port_id:0x%x, tag:0x%x, event:0x%x\n",
@@ -3414,6 +3600,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	u32 ATAP = 0x0;
 	u32 dir;
 	struct inbound_queue_table *circularQ;
+	unsigned long flags;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	circularQ = &pm8001_ha->inbnd_q_tbl[inb++];
@@ -3438,8 +3625,10 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			PM8001_IO_DBG(pm8001_ha, pm8001_printk("FPDMA\n"));
 		}
 	}
-	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag))
+	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
+		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		ncg_tag = hdr_tag;
+	}
 	dir = data_dir_flags[task->data_dir] << 8;
 	sata_cmd.tag = cpu_to_le32(tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
@@ -3547,6 +3736,55 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 				(task->ata_task.atapi_packet[14] << 16) |
 				(task->ata_task.atapi_packet[15] << 24)));
 	}
+
+	/* Check for read log for failed drive and return */
+	if (sata_cmd.sata_fis.command == 0x2f) {
+		if (pm8001_ha_dev && ((pm8001_ha_dev->id & NCQ_READ_LOG_FLAG) ||
+			(pm8001_ha_dev->id & NCQ_ABORT_ALL_FLAG) ||
+			(pm8001_ha_dev->id & NCQ_2ND_RLE_FLAG))) {
+			struct task_status_struct *ts;
+
+			pm8001_ha_dev->id &= 0xDFFFFFFF;
+			ts = &task->task_status;
+
+			spin_lock_irqsave(&task->task_state_lock, flags);
+			ts->resp = SAS_TASK_COMPLETE;
+			ts->stat = SAM_STAT_GOOD;
+			task->task_state_flags &= ~SAS_TASK_STATE_PENDING;
+			task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
+			task->task_state_flags |= SAS_TASK_STATE_DONE;
+			if (unlikely((task->task_state_flags &
+					SAS_TASK_STATE_ABORTED))) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				PM8001_FAIL_DBG(pm8001_ha,
+					pm8001_printk("task 0x%p resp 0x%x "
+					" stat 0x%x but aborted by upper layer "
+					"\n", task, ts->resp, ts->stat));
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				return 0;
+			} else if (task->uldd_task) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				mb();/* ditto */
+				spin_unlock_irq(&pm8001_ha->lock);
+				task->task_done(task);
+				spin_lock_irq(&pm8001_ha->lock);
+				return 0;
+			} else if (!task->uldd_task) {
+				spin_unlock_irqrestore(&task->task_state_lock,
+							flags);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				mb();/*ditto*/
+				spin_unlock_irq(&pm8001_ha->lock);
+				task->task_done(task);
+				spin_lock_irq(&pm8001_ha->lock);
+				return 0;
+			}
+		}
+	}
+
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
 						&sata_cmd, outb++);
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index cea0696..0c15627 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1278,6 +1278,7 @@ struct ssp_coalesced_comp_resp {
 #define MAIN_IQNPPD_HPPD_OFFSET		0x24 /* DWORD 0x09 */
 
 /* 0x28 - 0x4C - RSVD */
+#define MAIN_EVENT_CRC_CHECK		0x48 /* DWORD 0x12 */
 #define MAIN_EVENT_LOG_ADDR_HI		0x50 /* DWORD 0x14 */
 #define MAIN_EVENT_LOG_ADDR_LO		0x54 /* DWORD 0x15 */
 #define MAIN_EVENT_LOG_BUFF_SIZE	0x58 /* DWORD 0x16 */
-- 
1.7.1

