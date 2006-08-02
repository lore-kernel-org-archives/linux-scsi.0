From: James Smart <James.Smart@Emulex.Com>
Subject: [REPOST #3][PATCH 1/6] lpfc 8.1.7 : Adding statistics reset
	callback for FC transport
Date: Wed, 02 Aug 2006 15:24:34 -0400
Message-ID: <1154546674.3663.0.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3276 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932151AbWHBTYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 15:24:38 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k72JObVu006603
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 12:24:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry folks - a last code review identified one last reference
to seconds_since_last_reset that didn't get caught.

--

Patch updated for comments from Rolf Eike Beer
 - better handling of seconds_since_last_reset
 - remove some spaces around use of "sizeof()"

---

Adding statistics reset callback for FC transport

Signed-off-by: James Smart <James.Smart@emulex.com>




Adding statistics reset callback for FC transport

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-08-02 15:13:42.000000000 -0400
@@ -1210,8 +1210,10 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
 	struct lpfc_sli *psli = &phba->sli;
 	struct fc_host_statistics *hs = &phba->link_stats;
+	struct lpfc_lnk_stat * lso = &psli->lnk_stat_offsets;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
+	unsigned long seconds;
 	int rc = 0;
 
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -1272,22 +1274,103 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	hs->invalid_crc_count = pmb->un.varRdLnk.crcCnt;
 	hs->error_frames = pmb->un.varRdLnk.crcCnt;
 
+	hs->link_failure_count -= lso->link_failure_count;
+	hs->loss_of_sync_count -= lso->loss_of_sync_count;
+	hs->loss_of_signal_count -= lso->loss_of_signal_count;
+	hs->prim_seq_protocol_err_count -= lso->prim_seq_protocol_err_count;
+	hs->invalid_tx_word_count -= lso->invalid_tx_word_count;
+	hs->invalid_crc_count -= lso->invalid_crc_count;
+	hs->error_frames -= lso->error_frames;
+
 	if (phba->fc_topology == TOPOLOGY_LOOP) {
 		hs->lip_count = (phba->fc_eventTag >> 1);
+		hs->lip_count -= lso->link_events;
 		hs->nos_count = -1;
 	} else {
 		hs->lip_count = -1;
 		hs->nos_count = (phba->fc_eventTag >> 1);
+		hs->nos_count -= lso->link_events;
 	}
 
 	hs->dumped_frames = -1;
 
-/* FIX ME */
-	/*hs->SecondsSinceLastReset = (jiffies - lpfc_loadtime) / HZ;*/
+	seconds = get_seconds();
+	if (seconds < psli->stats_start)
+		hs->seconds_since_last_reset = seconds +
+				((unsigned long)-1 - psli->stats_start);
+	else
+		hs->seconds_since_last_reset = seconds - psli->stats_start;
 
 	return hs;
 }
 
+static void
+lpfc_reset_stats(struct Scsi_Host *shost)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_lnk_stat * lso = &psli->lnk_stat_offsets;
+	LPFC_MBOXQ_t *pmboxq;
+	MAILBOX_t *pmb;
+	int rc = 0;
+
+	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmboxq)
+		return;
+	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
+
+	pmb = &pmboxq->mb;
+	pmb->mbxCommand = MBX_READ_STATUS;
+	pmb->mbxOwner = OWN_HOST;
+	pmb->un.varWords[0] = 0x1; /* reset request */
+	pmboxq->context1 = NULL;
+
+	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
+		(!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+
+	if (rc != MBX_SUCCESS) {
+		if (rc == MBX_TIMEOUT)
+			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		else
+			mempool_free(pmboxq, phba->mbox_mem_pool);
+		return;
+	}
+
+	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
+	pmb->mbxCommand = MBX_READ_LNK_STAT;
+	pmb->mbxOwner = OWN_HOST;
+	pmboxq->context1 = NULL;
+
+	if ((phba->fc_flag & FC_OFFLINE_MODE) ||
+	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
+
+	if (rc != MBX_SUCCESS) {
+		if (rc == MBX_TIMEOUT)
+			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		else
+			mempool_free( pmboxq, phba->mbox_mem_pool);
+		return;
+	}
+
+	lso->link_failure_count = pmb->un.varRdLnk.linkFailureCnt;
+	lso->loss_of_sync_count = pmb->un.varRdLnk.lossSyncCnt;
+	lso->loss_of_signal_count = pmb->un.varRdLnk.lossSignalCnt;
+	lso->prim_seq_protocol_err_count = pmb->un.varRdLnk.primSeqErrCnt;
+	lso->invalid_tx_word_count = pmb->un.varRdLnk.invalidXmitWord;
+	lso->invalid_crc_count = pmb->un.varRdLnk.crcCnt;
+	lso->error_frames = pmb->un.varRdLnk.crcCnt;
+	lso->link_events = (phba->fc_eventTag >> 1);
+
+	psli->stats_start = get_seconds();
+
+	return;
+}
 
 /*
  * The LPFC driver treats linkdown handling as target loss events so there
@@ -1431,8 +1514,7 @@ struct fc_function_template lpfc_transpo
 	 */
 
 	.get_fc_host_stats = lpfc_get_stats,
-
-	/* the LPFC driver doesn't support resetting stats yet */
+	.reset_fc_host_stats = lpfc_reset_stats,
 
 	.dd_fcrport_size = sizeof(struct lpfc_rport_data),
 	.show_rport_maxframe_size = 1,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-08-02 15:14:11.000000000 -0400
@@ -1792,6 +1792,9 @@ lpfc_sli_brdrestart(struct lpfc_hba * ph
 
 	spin_unlock_irq(phba->host->host_lock);
 
+	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
+	psli->stats_start = get_seconds();
+
 	if (skip_post)
 		mdelay(100);
 	else
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2006-08-02 15:13:42.000000000 -0400
@@ -172,6 +172,18 @@ struct lpfc_sli_stat {
 	uint32_t mbox_busy;	 /* Mailbox cmd busy */
 };
 
+/* Structure to store link status values when port stats are reset */
+struct lpfc_lnk_stat {
+	uint32_t link_failure_count;
+	uint32_t loss_of_sync_count;
+	uint32_t loss_of_signal_count;
+	uint32_t prim_seq_protocol_err_count;
+	uint32_t invalid_tx_word_count;
+	uint32_t invalid_crc_count;
+	uint32_t error_frames;
+	uint32_t link_events;
+};
+
 /* Structure used to hold SLI information */
 struct lpfc_sli {
 	uint32_t num_rings;
@@ -201,6 +213,8 @@ struct lpfc_sli {
 	struct lpfc_iocbq ** iocbq_lookup; /* array to lookup IOCB by IOTAG */
 	size_t iocbq_lookup_len;           /* current lengs of the array */
 	uint16_t  last_iotag;              /* last allocated IOTAG */
+	unsigned long  stats_start;        /* in seconds */
+	struct lpfc_lnk_stat lnk_stat_offsets;
 };
 
 /* Given a pointer to the start of the ring, and the slot number of


