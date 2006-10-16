From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: add SATAPI support
Date: Mon, 16 Oct 2006 10:47:40 -0500
Message-ID: <1161013660.3433.15.camel@mulgrave.il.steeleye.com>
References: <1160961875.3544.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27083 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161006AbWJPPrm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 11:47:42 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k9GFlf118124
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 11:47:41 -0400
In-Reply-To: <1160961875.3544.37.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2006-10-15 at 20:24 -0500, James Bottomley wrote:
> +	switch (qc->tf.protocol) {
> +	case ATA_PROT_ATAPI:
> +	case ATA_PROT_ATAPI_NODATA:
> +	case ATA_PROT_ATAPI_DMA:
> +		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
> +		break;
> +	}

I missed the fact that this is covered in the is_atapi_taskfile() if
clause above.

Here's the amended patch.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2006-10-16 10:18:42.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c	2006-10-16 10:20:13.000000000 -0500
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
@@ -662,7 +667,7 @@ static unsigned int sas_ata_qc_issue(str
 	ata_tf_to_fis(&qc->tf, (u8*)&task->ata_task.fis, 0);
 	task->uldd_task = qc;
 	if (is_atapi_taskfile(&qc->tf)) {
-		memcpy(task->ata_task.atapi_packet, qc->cdb, ATAPI_CDB_LEN);
+		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes + qc->pad_len;
 		task->num_scatter = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
 	} else {
@@ -684,6 +689,7 @@ static unsigned int sas_ata_qc_issue(str
 	case ATA_PROT_NCQ:
 		task->ata_task.use_ncq = 1;
 		/* fall through */
+	case ATA_PROT_ATAPI_DMA:
 	case ATA_PROT_DMA:
 		task->ata_task.dma_xfer = 1;
 		break;


