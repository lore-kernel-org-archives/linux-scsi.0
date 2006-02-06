From: brking@us.ibm.com
Subject: [patch 02/15] libata: Add host lock to struct ata_port
Date: Mon, 06 Feb 2006 09:42:17 -0600
Message-ID: <200602061542.k16FgROF014749@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:25218 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932155AbWBFPm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 10:42:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Prepare for changes required to support SATA devices
attached to SAS HBAs. For these devices we don't want to
use host_set at all, since libata will not be the owner
of struct scsi_host.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   26 +++++++++++++-------------
 drivers/scsi/libata-scsi.c |    8 ++++----
 include/linux/libata.h     |    1 +
 3 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/libata.h~libata_port_lock include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_port_lock	2006-02-03 12:33:28.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-03 12:33:28.000000000 -0600
@@ -363,6 +363,7 @@ struct ata_device {
 struct ata_port {
 	struct Scsi_Host	*host;	/* our co-allocated scsi host */
 	const struct ata_port_operations *ops;
+	spinlock_t		*lock;
 	unsigned long		flags;	/* ATA_FLAG_xxx */
 	unsigned int		id;	/* unique id req'd by scsi midlyr */
 	unsigned int		port_no; /* unique port #; from zero */
diff -puN drivers/scsi/libata-core.c~libata_port_lock drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_port_lock	2006-02-03 12:33:28.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:34:12.000000000 -0600
@@ -1127,7 +1127,7 @@ ata_exec_internal(struct ata_port *ap, s
 	unsigned long flags;
 	unsigned int err_mask;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	qc = ata_qc_new_init(ap, dev);
 	BUG_ON(qc == NULL);
@@ -1146,10 +1146,10 @@ ata_exec_internal(struct ata_port *ap, s
 	if (qc->err_mask)
 		ata_qc_complete(qc);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (!wait_for_completion_timeout(&wait, ATA_TMOUT_INTERNAL)) {
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 
 		/* We're racing with irq here.  If we lose, the
 		 * following test prevents us from completing the qc
@@ -1164,7 +1164,7 @@ ata_exec_internal(struct ata_port *ap, s
 			       ap->id, command);
 		}
 
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	}
 
 	*tf = qc->tf;
@@ -2080,9 +2080,9 @@ static unsigned int ata_bus_edd(struct a
 	tf.protocol = ATA_PROT_NODATA;
 
 	/* do bus reset */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ata_tf_to_host(ap, &tf);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* spec says at least 2ms.  but who knows with those
 	 * crazy ATAPI devices...
@@ -3190,11 +3190,11 @@ void ata_poll_qc_complete(struct ata_que
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
@@ -3762,13 +3762,12 @@ fsm_start:
 static void ata_qc_timeout(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ata_host_set *host_set = ap->host_set;
 	u8 host_stat = 0, drv_stat;
 	unsigned long flags;
 
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	switch (qc->tf.protocol) {
 
@@ -3796,7 +3795,7 @@ static void ata_qc_timeout(struct ata_qu
 		break;
 	}
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_qc_complete(qc);
 
@@ -4497,12 +4496,12 @@ static void atapi_packet_task(void *_dat
 		 * interrupt handler shouldn't be invoked before we're
 		 * finished.  Hence, the following locking.
 		 */
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 		ap->flags &= ~ATA_FLAG_NOINTR;
 		ata_data_xfer(ap, qc->cdb, ap->cdb_len, 1);
 		if (qc->tf.protocol == ATA_PROT_ATAPI_DMA)
 			ap->ops->bmdma_start(qc);	/* initiate bmdma */
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	} else {
 		ata_data_xfer(ap, qc->cdb, ap->cdb_len, 1);
 
@@ -4720,6 +4719,7 @@ static void ata_host_init(struct ata_por
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
 
+	ap->lock = &host_set->lock;
 	ap->flags = ATA_FLAG_PORT_DISABLED;
 	ap->id = host->unique_id;
 	ap->host = host;
diff -puN drivers/scsi/libata-scsi.c~libata_port_lock drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_port_lock	2006-02-03 12:33:28.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-03 12:36:20.000000000 -0600
@@ -757,11 +757,11 @@ static void __ata_eh_qc_complete(struct 
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc->scsidone = ata_eh_scsidone;
 	ata_qc_complete(qc);
 	assert(!ata_tag_valid(qc->tag));
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
 }
@@ -2528,7 +2528,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 	ap = (struct ata_port *) &shost->hostdata[0];
 
 	spin_unlock(shost->host_lock);
-	spin_lock(&ap->host_set->lock);
+	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
@@ -2551,7 +2551,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 		ata_scsi_translate(ap, dev, cmd, done, atapi_xlat);
 
 out_unlock:
-	spin_unlock(&ap->host_set->lock);
+	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
 	return 0;
 }
_
