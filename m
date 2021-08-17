Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B963DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A528760F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbhHQJSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47746 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbhHQJRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D6F7A2002F;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1Z17M4de88jlLw9XSckKt5y/yB8C98nMZ5kTafWzCo=;
        b=DPzW/o3AF42oYQsq2eW6ACllFmTNoU1IRiEljgenpvBTZtfZpVEY9TQXgngvDYWqH0uwIT
        AWoHT3QWiggr4+HmOXtUqt+Syg1My019znO3zIfa+4Do9OlnxyRjSgmXoy1WHoRPUc7TPR
        QXWQ1PVvUPuMqzWuAVaTkb76ugl4a18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V1Z17M4de88jlLw9XSckKt5y/yB8C98nMZ5kTafWzCo=;
        b=ZWj+TwEaGJSimSzz3uWpxwmqg07nVxFkXTkbePR87lS0AKMCTjeNXQyT9Xn5St0w2zW+mW
        NOz03Rg8UfbABoBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D13CAA3BBE;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CE4D5518CEBF; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 48/51] snic: Use scsi_host_busy_iter() to traverse commands
Date:   Tue, 17 Aug 2021 11:14:53 +0200
Message-Id: <20210817091456.73342-49-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_busy_iter() to traverse commands instead of hand-crafted
routines walking the command list.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/snic/snic_scsi.c | 207 ++++++++++++++++------------------
 1 file changed, 100 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 26fbc0141b51..ca5ec14907cb 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -77,7 +77,7 @@ static const char * const snic_io_status_str[] = {
 	[SNIC_STAT_FATAL_ERROR]	= "SNIC_STAT_FATAL_ERROR",
 };
 
-static void snic_scsi_cleanup(struct snic *, int);
+static void snic_scsi_cleanup(struct snic *);
 
 const char *
 snic_state_to_str(unsigned int state)
@@ -980,7 +980,7 @@ snic_hba_reset_scsi_cleanup(struct snic *snic, struct scsi_cmnd *sc)
 	long act_ios = 0, act_fwreqs = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "HBA Reset scsi cleanup.\n");
-	snic_scsi_cleanup(snic, snic_cmd_tag(sc));
+	snic_scsi_cleanup(snic);
 
 	/* Update stats on pending IOs */
 	act_ios = atomic64_read(&st->io.active);
@@ -2402,87 +2402,82 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
 		complete(rqi->abts_done);
 }
 
-/*
- * snic_scsi_cleanup: Walks through tag map and releases the reqs
- */
-static void
-snic_scsi_cleanup(struct snic *snic, int ex_tag)
+static bool snic_scsi_cleanup_iter(struct scsi_cmnd *sc, void *data,
+				   bool reserved)
 {
-	struct snic_req_info *rqi = NULL;
-	struct scsi_cmnd *sc = NULL;
+	struct snic *snic = data;
+	u32 tag = sc->request->tag;
 	spinlock_t *io_lock = NULL;
-	unsigned long flags;
-	int tag;
+	struct snic_req_info *rqi = NULL;
 	u64 st_time = 0;
+	unsigned long flags;
 
-	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup.\n");
-
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
+	io_lock = snic_io_lock_tag(snic, tag);
+	spin_lock_irqsave(io_lock, flags);
+	if (unlikely(snic_tmreq_pending(sc))) {
+		/*
+		 * When FW Completes reset w/o sending completions
+		 * for outstanding ios.
+		 */
+		snic_cmpl_pending_tmreq(snic, sc);
+		spin_unlock_irqrestore(io_lock, flags);
 
-			continue;
-		}
+		return true;
+	}
 
-		rqi = (struct snic_req_info *) CMD_SP(sc);
-		if (!rqi) {
-			spin_unlock_irqrestore(io_lock, flags);
+	rqi = (struct snic_req_info *) CMD_SP(sc);
+	if (!rqi) {
+		spin_unlock_irqrestore(io_lock, flags);
 
-			goto cleanup;
-		}
+		goto cleanup;
+	}
 
-		SNIC_SCSI_DBG(snic->shost,
-			      "sc_clean: sc %p, rqi %p, tag %d flags 0x%llx\n",
-			      sc, rqi, tag, CMD_FLAGS(sc));
+	SNIC_SCSI_DBG(snic->shost,
+		      "sc_clean: sc %p, rqi %p, tag %d flags 0x%llx\n",
+		      sc, rqi, tag, CMD_FLAGS(sc));
 
-		CMD_SP(sc) = NULL;
-		CMD_FLAGS(sc) |= SNIC_SCSI_CLEANUP;
-		spin_unlock_irqrestore(io_lock, flags);
-		st_time = rqi->start_time;
+	CMD_SP(sc) = NULL;
+	CMD_FLAGS(sc) |= SNIC_SCSI_CLEANUP;
+	spin_unlock_irqrestore(io_lock, flags);
+	st_time = rqi->start_time;
 
-		SNIC_HOST_INFO(snic->shost,
-			       "sc_clean: Releasing rqi %p : flags 0x%llx\n",
-			       rqi, CMD_FLAGS(sc));
+	SNIC_HOST_INFO(snic->shost,
+		       "sc_clean: Releasing rqi %p : flags 0x%llx\n",
+		       rqi, CMD_FLAGS(sc));
 
-		snic_release_req_buf(snic, rqi, sc);
+	snic_release_req_buf(snic, rqi, sc);
 
 cleanup:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		SNIC_HOST_INFO(snic->shost,
-			       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
-			       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
-			       jiffies_to_msecs(jiffies - st_time));
+	sc->result = DID_TRANSPORT_DISRUPTED << 16;
+	SNIC_HOST_INFO(snic->shost,
+		       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, "
+		       "Tag %d flags 0x%llx rqi %p duration %u msecs\n",
+		       sc, sc->request->tag, CMD_FLAGS(sc), rqi,
+		       jiffies_to_msecs(jiffies - st_time));
 
-		/* Update IO stats */
-		snic_stats_update_io_cmpl(&snic->s_stats);
+	/* Update IO stats */
+	snic_stats_update_io_cmpl(&snic->s_stats);
 
-		if (sc->scsi_done) {
-			SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
-				 jiffies_to_msecs(jiffies - st_time), 0,
-				 SNIC_TRC_CMD(sc),
-				 SNIC_TRC_CMD_STATE_FLAGS(sc));
+	if (sc->scsi_done) {
+		SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+			 jiffies_to_msecs(jiffies - st_time), 0,
+			 SNIC_TRC_CMD(sc),
+			 SNIC_TRC_CMD_STATE_FLAGS(sc));
 
-			sc->scsi_done(sc);
-		}
+		sc->scsi_done(sc);
 	}
+	return true;
+}
+
+/*
+ * snic_scsi_cleanup: Walks through tag map and releases the reqs
+ */
+static void
+snic_scsi_cleanup(struct snic *snic)
+{
+	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup.\n");
+
+	scsi_host_busy_iter(snic->shost, snic_scsi_cleanup_iter, snic);
 } /* end of snic_scsi_cleanup */
 
 void
@@ -2490,7 +2485,7 @@ snic_shutdown_scsi_cleanup(struct snic *snic)
 {
 	SNIC_HOST_INFO(snic->shost, "Shutdown time SCSI Cleanup.\n");
 
-	snic_scsi_cleanup(snic, SCSI_NO_TAG);
+	snic_scsi_cleanup(snic);
 } /* end of snic_shutdown_scsi_cleanup */
 
 /*
@@ -2504,7 +2499,7 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
 	spinlock_t *io_lock = NULL;
 	unsigned long flags;
 	u32 sv_state = 0;
-	int ret = 0;
+	int ret = FAILED;
 
 	io_lock = snic_io_lock_hash(snic, sc);
 	spin_lock_irqsave(io_lock, flags);
@@ -2579,6 +2574,35 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
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
+			      sc->request->tag, ret);
+	return true;
+}
+
 /*
  * snic_tgt_scsi_abort_io : called by snic_tgt_del
  */
@@ -2586,11 +2610,9 @@ int
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
@@ -2598,44 +2620,15 @@ snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
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
-
-		sc_tgt = starget_to_tgt(scsi_target(sc->device));
-		if (sc_tgt != tgt) {
-			spin_unlock_irqrestore(io_lock, flags);
+		data.tmf = SNIC_ITMF_ABTS_TASK_TERM;
 
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
2.29.2

