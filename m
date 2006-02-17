From: Brian King <brking@us.ibm.com>
Subject: [PATCH 08/16] libata: Add host lock to struct ata_port
Date: Fri, 17 Feb 2006 16:20:31 -0600
Message-ID: <200602172220.k1HMKW8f006073@d01av03.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Prepare for changes required to support SATA devices
attached to SAS HBAs. For these devices we don't want to
use host_set at all, since libata will not be the owner
of struct scsi_host.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   34 +++++++++++++-------------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   20 +++++++--------
 libata-dev-bjking1/include/linux/libata.h     |    1 
 3 files changed, 28 insertions(+), 27 deletions(-)

diff -puN include/linux/libata.h~libata_port_lock include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_port_lock	2006-02-17 15:54:05.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-17 15:54:06.000000000 -0600
@@ -359,6 +359,7 @@ struct ata_device {
 struct ata_port {
 	struct Scsi_Host	*host;	/* our co-allocated scsi host */
 	const struct ata_port_operations *ops;
+	spinlock_t		*lock;
 	unsigned long		flags;	/* ATA_FLAG_xxx */
 	unsigned int		id;	/* unique id req'd by scsi midlyr */
 	unsigned int		port_no; /* unique port #; from zero */
diff -puN drivers/scsi/libata-core.c~libata_port_lock drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_port_lock	2006-02-17 15:54:06.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-17 15:54:06.000000000 -0600
@@ -756,9 +756,9 @@ static void ata_flush_pio_tasks(struct a
 
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags |= ATA_FLAG_FLUSH_PIO_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
 	flush_workqueue(ata_wq);
@@ -775,9 +775,9 @@ static void ata_flush_pio_tasks(struct a
 		flush_workqueue(ata_wq);
 	}
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags &= ~ATA_FLAG_FLUSH_PIO_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("EXIT\n");
 }
@@ -820,7 +820,7 @@ ata_exec_internal(struct ata_port *ap, s
 	unsigned long flags;
 	unsigned int err_mask;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	qc = ata_qc_new_init(ap, dev);
 	BUG_ON(qc == NULL);
@@ -839,10 +839,10 @@ ata_exec_internal(struct ata_port *ap, s
 	if (qc->err_mask)
 		ata_qc_complete(qc);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (!wait_for_completion_timeout(&wait, ATA_TMOUT_INTERNAL)) {
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 
 		/* We're racing with irq here.  If we lose, the
 		 * following test prevents us from completing the qc
@@ -857,7 +857,7 @@ ata_exec_internal(struct ata_port *ap, s
 			       ap->id, command);
 		}
 
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	}
 
 	*tf = qc->tf;
@@ -1786,9 +1786,9 @@ static unsigned int ata_bus_edd(struct a
 	tf.protocol = ATA_PROT_NODATA;
 
 	/* do bus reset */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ata_tf_to_host(ap, &tf);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* spec says at least 2ms.  but who knows with those
 	 * crazy ATAPI devices...
@@ -2927,11 +2927,11 @@ void ata_poll_qc_complete(struct ata_que
 	struct ata_port *ap = qc->ap;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags &= ~ATA_FLAG_NOINTR;
 	ata_irq_on(ap);
 	ata_qc_complete(qc);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
@@ -3499,7 +3499,6 @@ fsm_start:
 static void ata_qc_timeout(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ata_host_set *host_set = ap->host_set;
 	u8 host_stat = 0, drv_stat;
 	unsigned long flags;
 
@@ -3508,7 +3507,7 @@ static void ata_qc_timeout(struct ata_qu
 	ata_flush_pio_tasks(ap);
 	ap->hsm_task_state = HSM_ST_IDLE;
 
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	switch (qc->tf.protocol) {
 
@@ -3536,7 +3535,7 @@ static void ata_qc_timeout(struct ata_qu
 		break;
 	}
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_qc_complete(qc);
 
@@ -4215,12 +4214,12 @@ static void atapi_packet_task(void *_dat
 		 * interrupt handler shouldn't be invoked before we're
 		 * finished.  Hence, the following locking.
 		 */
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 		ap->flags &= ~ATA_FLAG_NOINTR;
 		ata_data_xfer(ap, qc->cdb, qc->dev->cdb_len, 1);
 		if (qc->tf.protocol == ATA_PROT_ATAPI_DMA)
 			ap->ops->bmdma_start(qc);	/* initiate bmdma */
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	} else {
 		ata_data_xfer(ap, qc->cdb, qc->dev->cdb_len, 1);
 
@@ -4438,6 +4437,7 @@ static void ata_host_init(struct ata_por
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = ATAPI_CDB_LEN;
 
+	ap->lock = &host_set->lock;
 	ap->flags = ATA_FLAG_PORT_DISABLED;
 	ap->id = host->unique_id;
 	ap->host = host;
diff -puN drivers/scsi/libata-scsi.c~libata_port_lock drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_port_lock	2006-02-17 15:54:06.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-17 15:54:06.000000000 -0600
@@ -765,7 +765,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc = ata_qc_from_tag(ap, ap->active_tag);
 	if (qc) {
 		WARN_ON(qc->scsicmd != cmd);
@@ -773,7 +773,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 		qc->err_mask |= AC_ERR_TIMEOUT;
 		ret = EH_NOT_HANDLED;
 	}
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("EXIT, ret=%d\n", ret);
 	return ret;
@@ -801,11 +801,11 @@ int ata_scsi_error(struct Scsi_Host *hos
 
 	ap = (struct ata_port *) &host->hostdata[0];
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	WARN_ON(ap->flags & ATA_FLAG_IN_EH);
 	ap->flags |= ATA_FLAG_IN_EH;
 	WARN_ON(ata_qc_from_tag(ap, ap->active_tag) == NULL);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ap->ops->eng_timeout(ap);
 
@@ -813,9 +813,9 @@ int ata_scsi_error(struct Scsi_Host *hos
 
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags &= ~ATA_FLAG_IN_EH;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("EXIT\n");
 	return 0;
@@ -832,11 +832,11 @@ static void __ata_eh_qc_complete(struct 
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc->scsidone = ata_eh_scsidone;
 	__ata_qc_complete(qc);
 	WARN_ON(ata_tag_valid(qc->tag));
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
 }
@@ -2621,7 +2621,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 	ap = (struct ata_port *) &shost->hostdata[0];
 
 	spin_unlock(shost->host_lock);
-	spin_lock(&ap->host_set->lock);
+	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
@@ -2635,7 +2635,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 	__ata_scsi_queuecmd(cmd, done, ap, dev);
 
 out_unlock:
-	spin_unlock(&ap->host_set->lock);
+	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
 	return 0;
 }
_
