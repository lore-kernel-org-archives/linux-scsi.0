Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A4BCDB484
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjJPJZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjJPJYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973DAAD
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D0EA21FEB9;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2C07B2D119;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id ECF5C51EBDD7; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 13/17] snic: Use scsi_host_busy_iter() to traverse commands
Date:   Mon, 16 Oct 2023 11:24:26 +0200
Message-Id: <20231016092430.55557-14-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [8.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: D0EA21FEB9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_busy_iter() to traverse commands instead of hand-crafted
routines walking the command list.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/snic/snic_scsi.c | 177 ++++++++++++++++------------------
 1 file changed, 84 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 06615619b84c..48261a37d4a6 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -63,7 +63,7 @@ static const char * const snic_io_status_str[] = {
 	[SNIC_STAT_FATAL_ERROR]	= "SNIC_STAT_FATAL_ERROR",
 };
 
-static void snic_scsi_cleanup(struct snic *, int);
+static void snic_scsi_cleanup(struct snic *);
 
 const char *
 snic_state_to_str(unsigned int state)
@@ -958,7 +958,7 @@ snic_hba_reset_scsi_cleanup(struct snic *snic)
 	long act_ios = 0, act_fwreqs = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "HBA Reset scsi cleanup.\n");
-	snic_scsi_cleanup(snic, snic->max_tag_id);
+	snic_scsi_cleanup(snic);
 
 	/* Update stats on pending IOs */
 	act_ios = atomic64_read(&st->io.active);
@@ -2357,53 +2357,36 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
 		complete(rqi->abts_done);
 }
 
-/*
- * snic_scsi_cleanup: Walks through tag map and releases the reqs
- */
-static void
-snic_scsi_cleanup(struct snic *snic, int ex_tag)
+static bool
+snic_scsi_cleanup_iter(struct scsi_cmnd *sc, void *data, bool reserved)
 {
+	struct snic *snic = data;
 	struct snic_req_info *rqi = NULL;
-	struct scsi_cmnd *sc = NULL;
 	spinlock_t *io_lock = NULL;
 	unsigned long flags;
-	int tag;
+	int tag = scsi_cmd_to_rq(sc)->tag;
 	u64 st_time = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup.\n");
 
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		/* Skip ex_tag */
-		if (tag == ex_tag)
-			continue;
-
-		io_lock = snic_io_lock_tag(snic, tag);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
-		if (!sc) {
-			spin_unlock_irqrestore(io_lock, flags);
-
-			continue;
-		}
-
-		if (unlikely(snic_tmreq_pending(sc))) {
-			/*
-			 * When FW Completes reset w/o sending completions
-			 * for outstanding ios.
-			 */
-			snic_cmpl_pending_tmreq(snic, sc);
-			spin_unlock_irqrestore(io_lock, flags);
-
-			continue;
-		}
+	io_lock = snic_io_lock_tag(snic, tag);
+	spin_lock_irqsave(io_lock, flags);
 
-		rqi = (struct snic_req_info *) CMD_SP(sc);
-		if (!rqi) {
-			spin_unlock_irqrestore(io_lock, flags);
+	if (unlikely(snic_tmreq_pending(sc))) {
+		/*
+		 * When FW Completes reset w/o sending completions
+		 * for outstanding ios.
+		 */
+		snic_cmpl_pending_tmreq(snic, sc);
+		spin_unlock_irqrestore(io_lock, flags);
 
-			goto cleanup;
-		}
+		return true;
+	}
 
+	rqi = (struct snic_req_info *) CMD_SP(sc);
+	if (!rqi)
+		spin_unlock_irqrestore(io_lock, flags);
+	else {
 		SNIC_SCSI_DBG(snic->shost,
 			      "sc_clean: sc %p, rqi %p, tag %d flags 0x%llx\n",
 			      sc, rqi, tag, CMD_FLAGS(sc));
@@ -2418,24 +2401,34 @@ snic_scsi_cleanup(struct snic *snic, int ex_tag)
 			       rqi, CMD_FLAGS(sc));
 
 		snic_release_req_buf(snic, rqi, sc);
+	}
+	sc->result = DID_TRANSPORT_DISRUPTED << 16;
+	SNIC_HOST_INFO(snic->shost,
+		       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
+		       sc, tag, CMD_FLAGS(sc), rqi,
+		       jiffies_to_msecs(jiffies - st_time));
 
-cleanup:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		SNIC_HOST_INFO(snic->shost,
-			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
-			       sc, scsi_cmd_to_rq(sc)->tag, CMD_FLAGS(sc), rqi,
-			       jiffies_to_msecs(jiffies - st_time));
+	/* Update IO stats */
+	snic_stats_update_io_cmpl(&snic->s_stats);
 
-		/* Update IO stats */
-		snic_stats_update_io_cmpl(&snic->s_stats);
+	SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+		 jiffies_to_msecs(jiffies - st_time), 0,
+		 SNIC_TRC_CMD(sc),
+		 SNIC_TRC_CMD_STATE_FLAGS(sc));
 
-		SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
-			 jiffies_to_msecs(jiffies - st_time), 0,
-			 SNIC_TRC_CMD(sc),
-			 SNIC_TRC_CMD_STATE_FLAGS(sc));
+	scsi_done(sc);
+	return true;
+}
 
-		scsi_done(sc);
-	}
+/*
+ * snic_scsi_cleanup: Walks through tag map and releases the reqs
+ */
+static void
+snic_scsi_cleanup(struct snic *snic)
+{
+	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup\n");
+
+	scsi_host_busy_iter(snic->shost, snic_scsi_cleanup_iter, snic);
 } /* end of snic_scsi_cleanup */
 
 void
@@ -2443,7 +2436,7 @@ snic_shutdown_scsi_cleanup(struct snic *snic)
 {
 	SNIC_HOST_INFO(snic->shost, "Shutdown time SCSI Cleanup.\n");
 
-	snic_scsi_cleanup(snic, SCSI_NO_TAG);
+	snic_scsi_cleanup(snic);
 } /* end of snic_shutdown_scsi_cleanup */
 
 /*
@@ -2457,7 +2450,7 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
 	spinlock_t *io_lock = NULL;
 	unsigned long flags;
 	u32 sv_state = 0;
-	int ret = 0;
+	int ret = FAILED;
 
 	io_lock = snic_io_lock_hash(snic, sc);
 	spin_lock_irqsave(io_lock, flags);
@@ -2532,6 +2525,35 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
 	return ret;
 } /* end of snic_internal_abort_io */
 
+struct snic_tgt_scsi_abort_io_data {
+	struct snic *snic;
+	struct snic_tgt *tgt;
+	int tmf;
+	int abt_cnt;
+};
+
+static bool snic_tgt_scsi_abort_io_iter(struct scsi_cmnd *sc, void *data,
+					bool reserved)
+{
+	struct snic_tgt_scsi_abort_io_data *iter_data = data;
+	struct snic *snic = iter_data->snic;
+	struct snic_tgt *sc_tgt;
+	int ret;
+
+	sc_tgt = starget_to_tgt(scsi_target(sc->device));
+	if (sc_tgt != iter_data->tgt)
+		return true;
+
+	ret = snic_internal_abort_io(snic, sc, iter_data->tmf);
+	if (ret == SUCCESS)
+		iter_data->abt_cnt++;
+	else
+		SNIC_HOST_ERR(snic->shost,
+			      "tgt_abt_io: Tag %x, Failed w err = %d\n",
+			      scsi_cmd_to_rq(sc)->tag, ret);
+	return true;
+}
+
 /*
  * snic_tgt_scsi_abort_io : called by snic_tgt_del
  */
@@ -2539,11 +2561,9 @@ int
 snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
 {
 	struct snic *snic = NULL;
-	struct scsi_cmnd *sc = NULL;
-	struct snic_tgt *sc_tgt = NULL;
-	spinlock_t *io_lock = NULL;
-	unsigned long flags;
-	int ret = 0, tag, abt_cnt = 0, tmf = 0;
+	struct snic_tgt_scsi_abort_io_data data = {
+		.abt_cnt = 0,
+	};
 
 	if (!tgt)
 		return -1;
@@ -2551,44 +2571,15 @@ snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
 	snic = shost_priv(snic_tgt_to_shost(tgt));
 	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: Cleaning Pending IOs.\n");
 
+	data.snic = snic;
 	if (tgt->tdata.typ == SNIC_TGT_DAS)
-		tmf = SNIC_ITMF_ABTS_TASK;
+		data.tmf = SNIC_ITMF_ABTS_TASK;
 	else
-		tmf = SNIC_ITMF_ABTS_TASK_TERM;
-
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		io_lock = snic_io_lock_tag(snic, tag);
-
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
-		if (!sc) {
-			spin_unlock_irqrestore(io_lock, flags);
-
-			continue;
-		}
+		data.tmf = SNIC_ITMF_ABTS_TASK_TERM;
 
-		sc_tgt = starget_to_tgt(scsi_target(sc->device));
-		if (sc_tgt != tgt) {
-			spin_unlock_irqrestore(io_lock, flags);
-
-			continue;
-		}
-		spin_unlock_irqrestore(io_lock, flags);
-
-		ret = snic_internal_abort_io(snic, sc, tmf);
-		if (ret < 0) {
-			SNIC_HOST_ERR(snic->shost,
-				      "tgt_abt_io: Tag %x, Failed w err = %d\n",
-				      tag, ret);
-
-			continue;
-		}
-
-		if (ret == SUCCESS)
-			abt_cnt++;
-	}
+	scsi_host_busy_iter(snic->shost, snic_tgt_scsi_abort_io_iter, &data);
 
-	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n", abt_cnt);
+	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n", data.abt_cnt);
 
 	return 0;
 } /* end of snic_tgt_scsi_abort_io */
-- 
2.35.3

