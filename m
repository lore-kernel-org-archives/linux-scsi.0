From: Dan Williams <dan.j.williams@intel.com>
Subject: RE: [PATCH v1] Fix sector number translation in sense buffer for
 SATA drives
Date: Thu, 21 Jun 2012 21:21:25 -0700
Message-ID: <1340338888.13003.9.camel@dwillia2-mobl>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
	<CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
	<1340324637.3712.67.camel@praveen-debian.lg.local>
	 <CABE8wws6w0uWhskDJZPuKr3S1_qwo8M1vy-q8CuvJs=C1BRs2A@mail.gmail.com>
	 <33E83F701EA663469FEBA23868D25955026B43DA@lgsbs.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:59067 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752899Ab2FVEVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 00:21:37 -0400
Received: by dano14 with SMTP id o14so1812804dan.25
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 21:21:29 -0700 (PDT)
In-Reply-To: <33E83F701EA663469FEBA23868D25955026B43DA@lgsbs.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: linux-scsi@vger.kernel.org

please bottom-post on linux-scsi / lkml

On Thu, 2012-06-21 at 19:06 -0700, Praveen Murali wrote:
> 
> something like this you mean?

Kind of, I think the real problem is that we convert to an ata_taskfile
too early.
> 
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -251,8 +251,27 @@ static unsigned int sas_ata_qc_issue(struct
> ata_queued_cmd *qc)
>  static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
>  {
>         struct domain_device *dev = qc->ap->private_data;
> +       struct ata_taskfile *rtf = &qc->result_tf;
> +       struct ata_taskfile *fis_tf = &dev->sata_dev.tf;
> +
> +        /* copy only required data to result tf from
> +         * fis converted tf
> +         */
> +       rtf->command     = fis_tf->command;
> +       rtf->feature     = fis_tf->feature;
> +
> +       rtf->lbal        = fis_tf->lbal;
> +       rtf->lbam        = fis_tf->lbam;
> +       rtf->lbah        = fis_tf->lbah;
> +       rtf->device      = fis_tf->device;
> +
> +       rtf->hob_lbal    = fis_tf->hob_lbal;
> +       rtf->hob_lbam    = fis_tf->hob_lbam;
> +       rtf->hob_lbah    = fis_tf->hob_lbah;
> +
> +       rtf->nsect       = fis_tf->nsect;
> +       rtf->hob_nsect   = fis_tf->hob_nsect;
> 
> -       memcpy(&qc->result_tf, &dev->sata_dev.tf,
> sizeof(qc->result_tf));
>         return true;
>  }
> 
> I was actually talking about doing the following

> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -113,6 +113,7 @@ static void sas_ata_task_done(struct sas_task
> *task)
>             ((stat->stat == SAM_STAT_CHECK_CONDITION &&
>               dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
>                 ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
> +               dev->sata_dev.tf.flags = qc->tf.flags;

This is smaller but leaves the bug of sas_ata_qc_fill_rtf in-tact.  What
happens when/if ata_taskfile grows more internal details?

I think we need a larger cleanup like this that makes it clear when
sas_ata can work with the raw fis and when it needs to convert it into
an ata_taskfile:

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 532d212..393e7ce 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -201,7 +201,7 @@ static void asd_get_response_tasklet(struct asd_ascb *ascb,
 
 		if (SAS_STATUS_BUF_SIZE >= sizeof(*resp)) {
 			resp->frame_len = le16_to_cpu(*(__le16 *)(r+6));
-			memcpy(&resp->ending_fis[0], r+16, 24);
+			memcpy(&resp->ending_fis[0], r+16, ATA_RESP_FIS_SIZE);
 			ts->buf_valid_size = sizeof(*resp);
 		}
 	}
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 899d190..905ae45 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -139,12 +139,12 @@ static void sas_ata_task_done(struct sas_task *task)
 	if (stat->stat == SAS_PROTO_RESPONSE || stat->stat == SAM_STAT_GOOD ||
 	    ((stat->stat == SAM_STAT_CHECK_CONDITION &&
 	      dev->sata_dev.command_set == ATAPI_COMMAND_SET))) {
-		ata_tf_from_fis(resp->ending_fis, &dev->sata_dev.tf);
+		memcpy(dev->sata_dev.fis, resp->ending_fis, ATA_RESP_FIS_SIZE);
 
 		if (!link->sactive) {
-			qc->err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			qc->err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 		} else {
-			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.tf.command);
+			link->eh_info.err_mask |= ac_err_mask(dev->sata_dev.fis[2]);
 			if (unlikely(link->eh_info.err_mask))
 				qc->flags |= ATA_QCFLAG_FAILED;
 		}
@@ -161,8 +161,8 @@ static void sas_ata_task_done(struct sas_task *task)
 				qc->flags |= ATA_QCFLAG_FAILED;
 			}
 
-			dev->sata_dev.tf.feature = 0x04; /* status err */
-			dev->sata_dev.tf.command = ATA_ERR;
+			dev->sata_dev.fis[3] = 0x04; /* status err */
+			dev->sata_dev.fis[2] = ATA_ERR;
 		}
 	}
 
@@ -269,7 +269,7 @@ static bool sas_ata_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
 	struct domain_device *dev = qc->ap->private_data;
 
-	memcpy(&qc->result_tf, &dev->sata_dev.tf, sizeof(qc->result_tf));
+	ata_tf_from_fis(dev->sata_dev.fis, &qc->result_tf);
 	return true;
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 5c7677f..ef937b5 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -166,6 +166,8 @@ enum ata_command_set {
         ATAPI_COMMAND_SET = 1,
 };
 
+#define ATA_RESP_FIS_SIZE 24
+
 struct sata_device {
         enum   ata_command_set command_set;
         struct smp_resp        rps_resp; /* report_phy_sata_resp */
@@ -174,7 +176,7 @@ struct sata_device {
 
 	struct ata_port *ap;
 	struct ata_host ata_host;
-	struct ata_taskfile tf;
+	u8     fis[ATA_RESP_FIS_SIZE];
 };
 
 struct ssp_device {
@@ -555,7 +557,7 @@ enum exec_status {
  */
 struct ata_task_resp {
 	u16  frame_len;
-	u8   ending_fis[24];	  /* dev to host or data-in */
+	u8   ending_fis[ATA_RESP_FIS_SIZE];	  /* dev to host or data-in */
 };
 
 #define SAS_STATUS_BUF_SIZE 96


