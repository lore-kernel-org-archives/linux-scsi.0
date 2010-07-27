From: James Bottomley <James.Bottomley@suse.de>
Subject: Unify SAM_ and SAM_STAT_ macros
Date: Tue, 27 Jul 2010 15:51:13 -0500
Message-ID: <1280263873.2833.437.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0G0UvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 16:51:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>, Ying Chu <jasonchu@marvell.com>, jack wang <jack_wang@usish.com>

We have two separate definitions for identical constants with nearly the
same name.  One comes from the generic headers in scsi.h; the other is
an enum in libsas.h ... it's causing confusion about which one is
correct (fortunately they both are).

Fix this by eliminating the libsas.h duplicate

James

---

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 75d20f7..532d212 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -223,7 +223,7 @@ Again:
 	switch (opcode) {
 	case TC_NO_ERROR:
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_GOOD;
+		ts->stat = SAM_STAT_GOOD;
 		break;
 	case TC_UNDERRUN:
 		ts->resp = SAS_TASK_COMPLETE;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index b00efd1..336677f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -71,7 +71,7 @@ static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
 		case SAS_SG_ERR:
 			return AC_ERR_INVALID;
 
-		case SAM_CHECK_COND:
+		case SAM_STAT_CHECK_CONDITION:
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
@@ -107,7 +107,7 @@ static void sas_ata_task_done(struct sas_task *task)
 	sas_ha = dev->port->ha;
 
 	spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_GOOD) {
+	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD) {
 		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
 		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
 		dev->sata_dev.sstatus = resp->sstatus;
@@ -506,12 +506,12 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 					goto ex_err;
 			}
 		}
-		if (task->task_status.stat == SAM_BUSY ||
-			   task->task_status.stat == SAM_TASK_SET_FULL ||
+		if (task->task_status.stat == SAM_STAT_BUSY ||
+			   task->task_status.stat == SAM_STAT_TASK_SET_FULL ||
 			   task->task_status.stat == SAS_QUEUE_FULL) {
 			SAS_DPRINTK("task: q busy, sleeping...\n");
 			schedule_timeout_interruptible(HZ);
-		} else if (task->task_status.stat == SAM_CHECK_COND) {
+		} else if (task->task_status.stat == SAM_STAT_CHECK_CONDITION) {
 			struct scsi_sense_hdr shdr;
 
 			if (!scsi_normalize_sense(ts->buf, ts->buf_valid_size,
@@ -544,7 +544,7 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 					    shdr.asc, shdr.ascq);
 			}
 		} else if (task->task_status.resp != SAS_TASK_COMPLETE ||
-			   task->task_status.stat != SAM_GOOD) {
+			   task->task_status.stat != SAM_STAT_GOOD) {
 			SAS_DPRINTK("task finished with resp:0x%x, "
 				    "stat:0x%x\n",
 				    task->task_status.resp,
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c65af02..83dd507 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -107,7 +107,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 			}
 		}
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		    task->task_status.stat == SAM_GOOD) {
+		    task->task_status.stat == SAM_STAT_GOOD) {
 			res = 0;
 			break;
 		} if (task->task_status.resp == SAS_TASK_COMPLETE &&
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2660e1b..d621345 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -113,10 +113,10 @@ static void sas_scsi_task_done(struct sas_task *task)
 		case SAS_ABORTED_TASK:
 			hs = DID_ABORT;
 			break;
-		case SAM_CHECK_COND:
+		case SAM_STAT_CHECK_CONDITION:
 			memcpy(sc->sense_buffer, ts->buf,
 			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
-			stat = SAM_CHECK_COND;
+			stat = SAM_STAT_CHECK_CONDITION;
 			break;
 		default:
 			stat = ts->stat;
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index 594524d..b13a334 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -15,13 +15,13 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	else if (iu->datapres == 1)
 		tstat->stat = iu->resp_data[3];
 	else if (iu->datapres == 2) {
-		tstat->stat = SAM_CHECK_COND;
+		tstat->stat = SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
 			min_t(int, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-		if (iu->status != SAM_CHECK_COND)
+		if (iu->status != SAM_STAT_CHECK_CONDITION)
 			dev_printk(KERN_WARNING, dev,
 				   "dev %llx sent sense data, but "
 				   "stat(%x) is not CHECK CONDITION\n",
@@ -30,7 +30,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	}
 	else
 		/* when datapres contains corrupt/unknown value... */
-		tstat->stat = SAM_CHECK_COND;
+		tstat->stat = SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(sas_ssp_task_response);
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f5e3217..47d05a1 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1483,7 +1483,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-		    task->task_status.stat == SAM_GOOD) {
+		    task->task_status.stat == SAM_STAT_GOOD) {
 			res = TMF_RESP_FUNC_COMPLETE;
 			break;
 		}
@@ -1756,7 +1756,7 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 	struct mvs_device *mvi_dev = task->dev->lldd_dev;
 	struct task_status_struct *tstat = &task->task_status;
 	struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
-	int stat = SAM_GOOD;
+	int stat = SAM_STAT_GOOD;
 
 
 	resp->frame_len = sizeof(struct dev_to_host_fis);
@@ -1788,13 +1788,13 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 
 	MVS_CHIP_DISP->command_active(mvi, slot_idx);
 
-	stat = SAM_CHECK_COND;
+	stat = SAM_STAT_CHECK_CONDITION;
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SSP:
 		stat = SAS_ABORTED_TASK;
 		break;
 	case SAS_PROTOCOL_SMP:
-		stat = SAM_CHECK_COND;
+		stat = SAM_STAT_CHECK_CONDITION;
 		break;
 
 	case SAS_PROTOCOL_SATA:
@@ -1879,7 +1879,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	case SAS_PROTOCOL_SSP:
 		/* hw says status == 0, datapres == 0 */
 		if (rx_desc & RXQ_GOOD) {
-			tstat->stat = SAM_GOOD;
+			tstat->stat = SAM_STAT_GOOD;
 			tstat->resp = SAS_TASK_COMPLETE;
 		}
 		/* response frame present */
@@ -1888,12 +1888,12 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 						sizeof(struct mvs_err_info);
 			sas_ssp_task_response(mvi->dev, task, iu);
 		} else
-			tstat->stat = SAM_CHECK_COND;
+			tstat->stat = SAM_STAT_CHECK_CONDITION;
 		break;
 
 	case SAS_PROTOCOL_SMP: {
 			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
-			tstat->stat = SAM_GOOD;
+			tstat->stat = SAM_STAT_GOOD;
 			to = kmap_atomic(sg_page(sg_resp), KM_IRQ0);
 			memcpy(to + sg_resp->offset,
 				slot->response + sizeof(struct mvs_err_info),
@@ -1910,7 +1910,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		}
 
 	default:
-		tstat->stat = SAM_CHECK_COND;
+		tstat->stat = SAM_STAT_CHECK_CONDITION;
 		break;
 	}
 	if (!slot->port->port_attached) {
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 5ff8261..356ad26 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1480,7 +1480,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			",param = %d \n", param));
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
-			ts->stat = SAM_GOOD;
+			ts->stat = SAM_STAT_GOOD;
 		} else {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_PROTO_RESPONSE;
@@ -1909,7 +1909,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
-			ts->stat = SAM_GOOD;
+			ts->stat = SAM_STAT_GOOD;
 		} else {
 			u8 len;
 			ts->resp = SAS_TASK_COMPLETE;
@@ -2450,7 +2450,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_GOOD;
+		ts->stat = SAM_STAT_GOOD;
 	if (pm8001_dev)
 			pm8001_dev->running_req--;
 		break;
@@ -2479,19 +2479,19 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_ERROR_HW_TIMEOUT\n"));
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_BUSY;
+		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_BREAK:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_BREAK\n"));
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_BUSY;
+		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_XFER_ERROR_PHY_NOT_READY:
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("IO_XFER_ERROR_PHY_NOT_READY\n"));
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_BUSY;
+		ts->stat = SAM_STAT_BUSY;
 		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
@@ -3260,7 +3260,7 @@ mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case IO_SUCCESS:
 		PM8001_EH_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
 		ts->resp = SAS_TASK_COMPLETE;
-		ts->stat = SAM_GOOD;
+		ts->stat = SAM_STAT_GOOD;
 		break;
 	case IO_NOT_VALID:
 		PM8001_EH_DBG(pm8001_ha, pm8001_printk("IO_NOT_VALID\n"));
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index bff4f51..edd7d11 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -763,7 +763,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-			task->task_status.stat == SAM_GOOD) {
+			task->task_status.stat == SAM_STAT_GOOD) {
 			res = TMF_RESP_FUNC_COMPLETE;
 			break;
 		}
@@ -853,7 +853,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-			task->task_status.stat == SAM_GOOD) {
+			task->task_status.stat == SAM_STAT_GOOD) {
 			res = TMF_RESP_FUNC_COMPLETE;
 			break;
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3b58685..d06e13b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -422,16 +422,7 @@ enum service_response {
 };
 
 enum exec_status {
-	SAM_GOOD         = 0,
-	SAM_CHECK_COND   = 2,
-	SAM_COND_MET     = 4,
-	SAM_BUSY         = 8,
-	SAM_INTERMEDIATE = 0x10,
-	SAM_IM_COND_MET  = 0x12,
-	SAM_RESV_CONFLICT= 0x14,
-	SAM_TASK_SET_FULL= 0x28,
-	SAM_ACA_ACTIVE   = 0x30,
-	SAM_TASK_ABORTED = 0x40,
+	/* The SAM_STAT_.. codes fit in the lower 6 bits */
 
 	SAS_DEV_NO_RESPONSE = 0x80,
 	SAS_DATA_UNDERRUN,


