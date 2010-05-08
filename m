From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.34-rc6
Date: Sat, 08 May 2010 09:39:08 -0500
Message-ID: <1273329548.18171.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0EHOjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2010 10:39:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

The biggest one here is a couple of patches that fix an enterprise
problem where filesystems would suddenly remount read only when the
array issued an asynchronous event.  The patches are available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

ouglas Gilbert (1):
      scsi_debug: virtual_gb ignores sector_size

Hannes Reinecke (1):
      Enable retries for SYNCRONIZE_CACHE commands to fix I/O error

Herton Ronaldo Krzesinski (1):
      advansys: fix narrow board error path

James Bottomley (1):
      Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error

Mike Christie (1):
      libiscsi: regression: fix header digest errors

Tejun Heo (1):
      fix locking around blk_abort_request()

and the diffstat:

 drivers/scsi/advansys.c             |   50 +++++++++++++++++++++++++-----------
 drivers/scsi/libiscsi.c             |    2 -
 drivers/scsi/libsas/sas_ata.c       |    4 ++
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++
 drivers/scsi/scsi_debug.c           |    3 +-
 drivers/scsi/scsi_error.c           |   15 ++++++++++
 drivers/scsi/sd.c                   |    1 
 7 files changed, 62 insertions(+), 17 deletions(-)

the full diff is below.

James

---

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9201afe..7f87979 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4724,6 +4724,10 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	BUG_ON((unsigned long)asc_dvc->overrun_buf & 7);
 	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
+		warn_code = -ENOMEM;
+		goto err_dma_map;
+	}
 	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
 				 (uchar *)&phy_addr, 1);
@@ -4739,14 +4743,23 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
 	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
 		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
-		return warn_code;
+		warn_code = UW_ERR;
+		goto err_mcode_start;
 	}
 	if (AscStartChip(iop_base) != 1) {
 		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
-		return warn_code;
+		warn_code = UW_ERR;
+		goto err_mcode_start;
 	}
 
 	return warn_code;
+
+err_mcode_start:
+	dma_unmap_single(board->dev, asc_dvc->overrun_dma,
+			 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+err_dma_map:
+	asc_dvc->overrun_dma = 0;
+	return warn_code;
 }
 
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -4802,6 +4815,8 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	}
 	release_firmware(fw);
 	warn_code |= AscInitMicroCodeVar(asc_dvc);
+	if (!asc_dvc->overrun_dma)
+		return warn_code;
 	asc_dvc->init_state |= ASC_INIT_STATE_END_LOAD_MC;
 	AscEnableInterrupt(iop_base);
 	return warn_code;
@@ -7978,9 +7993,10 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		status = AscInitAsc1000Driver(asc_dvc);
 
 		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
-		if (asc_dvc->err_code) {
+		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset error: "
-				    "0x%x\n", asc_dvc->err_code);
+				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
+				    status);
 			ret = FAILED;
 		} else if (status) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset warning: "
@@ -12311,7 +12327,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
 		if (!asc_dvc_varp->overrun_buf) {
 			ret = -ENOMEM;
-			goto err_free_wide_mem;
+			goto err_free_irq;
 		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
@@ -12320,30 +12336,36 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code) {
+			if (!asc_dvc_varp->overrun_dma) {
 				ret = -ENODEV;
-				kfree(asc_dvc_varp->overrun_buf);
+				goto err_free_mem;
 			}
 		}
 	} else {
-		if (advansys_wide_init_chip(shost))
+		if (advansys_wide_init_chip(shost)) {
 			ret = -ENODEV;
+			goto err_free_mem;
+		}
 	}
 
-	if (ret)
-		goto err_free_wide_mem;
-
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	ret = scsi_add_host(shost, boardp->dev);
 	if (ret)
-		goto err_free_wide_mem;
+		goto err_free_mem;
 
 	scsi_scan_host(shost);
 	return 0;
 
- err_free_wide_mem:
-	advansys_wide_free_mem(boardp);
+ err_free_mem:
+	if (ASC_NARROW_BOARD(boardp)) {
+		if (asc_dvc_varp->overrun_dma)
+			dma_unmap_single(boardp->dev, asc_dvc_varp->overrun_dma,
+					 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
+	} else
+		advansys_wide_free_mem(boardp);
+ err_free_irq:
 	free_irq(boardp->irq, shost);
  err_free_dma:
 #ifdef CONFIG_ISA
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6d5ae44..633e090 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -471,12 +471,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
+	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
-	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index b00efd1..88f7446 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,11 +395,15 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
+	struct request_queue *q = qc->scsicmd->device->request_queue;
 	struct completion *waiting;
+	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2660e1b..8228350 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,6 +1030,8 @@ int __sas_task_abort(struct sas_task *task)
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
+	struct request_queue *q = sc->device->request_queue;
+	unsigned long flags;
 
 	/* Escape for libsas internal commands */
 	if (!sc) {
@@ -1044,7 +1046,9 @@ void sas_task_abort(struct sas_task *task)
 		return;
 	}
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(sc->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 	scsi_schedule_eh(sc->device->host);
 }
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3e10c30..3a5bfd1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -957,7 +957,8 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 static sector_t get_sdebug_capacity(void)
 {
 	if (scsi_debug_virtual_gb > 0)
-		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
+		return (sector_t)scsi_debug_virtual_gb *
+			(1073741824 / scsi_debug_sector_size);
 	else
 		return sdebug_store_sectors;
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d45c69c..7ad53fa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -302,7 +302,20 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
-		return SUCCESS;
+
+		if (blk_barrier_rq(scmd->request))
+			/*
+			 * barrier requests should always retry on UA
+			 * otherwise block will get a spurious error
+			 */
+			return NEEDS_RETRY;
+		else
+			/*
+			 * for normal (non barrier) commands, pass the
+			 * UA upwards for a determination in the
+			 * completion functions
+			 */
+			return SUCCESS;
 
 		/* these three are not supported */
 	case COPY_ABORTED:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b827f3..de6c603 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1040,6 +1040,7 @@ static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
+	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }


