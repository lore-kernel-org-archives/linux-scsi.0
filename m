From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: add SATAPI support
Date: Sun, 15 Oct 2006 20:24:35 -0500
Message-ID: <1160961875.3544.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28840 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751188AbWJPBYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 21:24:37 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k9G1OZ105973
	for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 21:24:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

It turns out this is fairly easy to plumb in by recognising the three
command types and copying the CDB.  The protocol response path needs to
be amended to cope with SAS_PROTO_RESPONSE.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2006-10-15 20:05:56.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c	2006-10-15 20:06:22.000000000 -0500
@@ -580,7 +580,6 @@ static enum ata_completion_errors sas_to
 		case SAM_CHECK_COND:
 		case SAS_OPEN_TO:
 		case SAS_OPEN_REJECT:
-		case SAS_PROTO_RESPONSE:
 			SAS_DPRINTK("%s: Saw error %d.  What to do?\n",
 				    __FUNCTION__, ts->stat);
 			return AC_ERR_OTHER;
@@ -588,6 +587,10 @@ static enum ata_completion_errors sas_to
 		case SAS_ABORTED_TASK:
 			return AC_ERR_DEV;
 
+		case SAS_PROTO_RESPONSE:
+			/* This means the ending_fis has the error
+			 * value; return 0 here to collect it */
+			return 0;
 		default:
 			return 0;
 	}
@@ -601,23 +604,25 @@ static void sas_ata_task_done(struct sas
 	struct ata_task_resp *resp = (struct ata_task_resp *)stat->buf;
 	enum ata_completion_errors ac;
 
-	ac = sas_to_ata_err(stat);
-	if (ac) {
-		SAS_DPRINTK("%s: SAS error %x\n", __FUNCTION__, stat->stat);
-		/* We saw a SAS error. Send a vague error. */
-		qc->err_mask = ac;
-		dev->sata_dev.tf.feature = 0x04; /* status err */
-		dev->sata_dev.tf.command = ATA_ERR;
-		goto end;
-	}
-
-	ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
-	qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
-	dev->sata_dev.sstatus = resp->sstatus;
-	dev->sata_dev.serror = resp->serror;
-	dev->sata_dev.scontrol = resp->scontrol;
-	dev->sata_dev.ap->sactive = resp->sactive;
-end:
+	if (stat->stat == SAS_PROTO_RESPONSE) {
+		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
+		qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+		dev->sata_dev.sstatus = resp->sstatus;
+		dev->sata_dev.serror = resp->serror;
+		dev->sata_dev.scontrol = resp->scontrol;
+		dev->sata_dev.ap->sactive = resp->sactive;
+	} else if (stat->stat != SAM_STAT_GOOD) {
+		ac = sas_to_ata_err(stat);
+		if (ac) {
+			SAS_DPRINTK("%s: SAS error %x\n", __FUNCTION__,
+				    stat->stat);
+			/* We saw a SAS error. Send a vague error. */
+			qc->err_mask = ac;
+			dev->sata_dev.tf.feature = 0x04; /* status err */
+			dev->sata_dev.tf.command = ATA_ERR;
+		}
+	}
+
 	ata_qc_complete(qc);
 	list_del_init(&task->list);
 	sas_free_task(task);
@@ -677,11 +682,20 @@ static unsigned int sas_ata_qc_issue(str
 	case ATA_PROT_NCQ:
 		task->ata_task.use_ncq = 1;
 		/* fall through */
+	case ATA_PROT_ATAPI_DMA:
 	case ATA_PROT_DMA:
 		task->ata_task.dma_xfer = 1;
 		break;
 	}
 
+	switch (qc->tf.protocol) {
+	case ATA_PROT_ATAPI:
+	case ATA_PROT_ATAPI_NODATA:
+	case ATA_PROT_ATAPI_DMA:
+		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
+		break;
+	}
+
 	if (sas_ha->lldd_max_execute_num < 2)
 		res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
 	else


