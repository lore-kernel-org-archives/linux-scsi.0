Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996F6C43462
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BAE610A0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 15:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhECPEq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 11:04:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:40878 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhECPEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 11:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F011B1B8;
        Mon,  3 May 2021 15:03:44 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/18] snic: use tagset iter for traversing commands
Date:   Mon,  3 May 2021 17:03:24 +0200
Message-Id: <20210503150333.130310-10-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210503150333.130310-1-hare@suse.de>
References: <20210503150333.130310-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the tagset iter to traverse active commands during device and
hba reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/snic/snic_scsi.c | 366 +++++++++++++++++-----------------
 1 file changed, 187 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 63cb9f81f82b..7bffad6626f8 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1641,90 +1641,97 @@ snic_abort_cmd(struct scsi_cmnd *sc)
 	return ret;
 }
 
+struct snic_cmd_pending_iter_data {
+	struct snic *snic;
+	struct scsi_device *sdev;
+	int ret;
+};
 
-
-static int
-snic_is_abts_pending(struct snic *snic, struct scsi_cmnd *lr_sc)
+static bool
+snic_is_abts_pending_iter(struct scsi_cmnd *sc, void *data, bool reserved)
 {
+	struct snic_cmd_pending_iter_data *iter_data = data;
 	struct snic_req_info *rqi = NULL;
-	struct scsi_cmnd *sc = NULL;
-	struct scsi_device *lr_sdev = NULL;
 	spinlock_t *io_lock = NULL;
-	u32 tag;
 	unsigned long flags;
 
-	if (lr_sc)
-		lr_sdev = lr_sc->device;
+	if (reserved)
+		return true;
 
-	/* walk through the tag map, an dcheck if IOs are still pending in fw*/
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		io_lock = snic_io_lock_tag(snic, tag);
-
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
-
-		if (!sc || (lr_sc && (sc->device != lr_sdev || sc == lr_sc))) {
-			spin_unlock_irqrestore(io_lock, flags);
+	if (iter_data->sdev && iter_data->sdev != sc->device)
+		return true;
 
-			continue;
-		}
+	io_lock = snic_io_lock_hash(iter_data->snic, sc);
+	spin_lock_irqsave(io_lock, flags);
 
-		rqi = (struct snic_req_info *) CMD_SP(sc);
-		if (!rqi) {
-			spin_unlock_irqrestore(io_lock, flags);
+	rqi = (struct snic_req_info *) CMD_SP(sc);
+	if (!rqi) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
-			continue;
-		}
+	/*
+	 * Found IO that is still pending w/ firmware and belongs to
+	 * the LUN that is under reset, if lr_sc != NULL
+	 */
+	SNIC_SCSI_DBG(iter_data->snic->shost, "Found IO in %s on LUN\n",
+		      snic_ioreq_state_to_str(CMD_STATE(sc)));
 
-		/*
-		 * Found IO that is still pending w/ firmware and belongs to
-		 * the LUN that is under reset, if lr_sc != NULL
-		 */
-		SNIC_SCSI_DBG(snic->shost, "Found IO in %s on LUN\n",
-			      snic_ioreq_state_to_str(CMD_STATE(sc)));
+	if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING)
+		iter_data->ret = 1;
+	spin_unlock_irqrestore(io_lock, flags);
 
-		if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING) {
-			spin_unlock_irqrestore(io_lock, flags);
+	return true;
+}
 
-			return 1;
-		}
+static int
+snic_is_abts_pending(struct snic *snic, struct scsi_device *lr_sdev)
+{
+	struct snic_cmd_pending_iter_data iter_data = {
+		.snic = snic,
+		.sdev = lr_sdev,
+		.ret = 0,
+	};
 
-		spin_unlock_irqrestore(io_lock, flags);
-	}
+	/* walk through the tag map, an dcheck if IOs are still pending in fw*/
+	scsi_host_busy_iter(snic->shost,
+			    snic_is_abts_pending_iter, &iter_data);
 
-	return 0;
+	return iter_data.ret;
 } /* end of snic_is_abts_pending */
 
-static int
-snic_dr_clean_single_req(struct snic *snic,
-			 u32 tag,
-			 struct scsi_device *lr_sdev)
+static bool
+snic_dr_clean_single_req(struct scsi_cmnd *sc, void *data, bool reserved)
 {
 	struct snic_req_info *rqi = NULL;
 	struct snic_tgt *tgt = NULL;
-	struct scsi_cmnd *sc = NULL;
 	spinlock_t *io_lock = NULL;
 	u32 sv_state = 0, tmf = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	unsigned long flags;
 	int ret = 0;
+	struct snic_cmd_pending_iter_data *iter_data = data;
+	struct snic *snic = iter_data->snic;
 
-	io_lock = snic_io_lock_tag(snic, tag);
-	spin_lock_irqsave(io_lock, flags);
-	sc = scsi_host_find_tag(snic->shost, tag);
+	if (reserved)
+		return true;
 
-	/* Ignore Cmd that don't belong to Lun Reset device */
-	if (!sc || sc->device != lr_sdev)
-		goto skip_clean;
+	if (sc->device != iter_data->sdev)
+		return true;
 
+	io_lock = snic_io_lock_hash(snic, sc);
+	spin_lock_irqsave(io_lock, flags);
 	rqi = (struct snic_req_info *) CMD_SP(sc);
-
-	if (!rqi)
-		goto skip_clean;
+	if (!rqi) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
 
-	if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING)
-		goto skip_clean;
+	if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
 
 	if ((CMD_FLAGS(sc) & SNIC_DEVICE_RESET) &&
@@ -1733,8 +1740,8 @@ snic_dr_clean_single_req(struct snic *snic,
 		SNIC_SCSI_DBG(snic->shost,
 			      "clean_single_req: devrst is not pending sc 0x%p\n",
 			      sc);
-
-		goto skip_clean;
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
 	}
 
 	SNIC_SCSI_DBG(snic->shost,
@@ -1777,7 +1784,7 @@ snic_dr_clean_single_req(struct snic *snic,
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
 			      "clean_single_req_err:sc %p, tag %d abt failed. tm_tag %d flags 0x%llx\n",
-			      sc, tag, rqi->tm_tag, CMD_FLAGS(sc));
+			      sc, snic_cmd_tag(sc), rqi->tm_tag, CMD_FLAGS(sc));
 
 		spin_lock_irqsave(io_lock, flags);
 		rqi = (struct snic_req_info *) CMD_SP(sc);
@@ -1788,8 +1795,9 @@ snic_dr_clean_single_req(struct snic *snic,
 		if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING)
 			CMD_STATE(sc) = sv_state;
 
-		ret = 1;
-		goto skip_clean;
+		iter_data->ret = 1;
+		spin_unlock_irqrestore(io_lock, flags);
+		return false;
 	}
 
 	spin_lock_irqsave(io_lock, flags);
@@ -1806,7 +1814,8 @@ snic_dr_clean_single_req(struct snic *snic,
 	rqi = (struct snic_req_info *) CMD_SP(sc);
 	if (!rqi) {
 		CMD_FLAGS(sc) |= SNIC_IO_ABTS_TERM_REQ_NULL;
-		goto skip_clean;
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;;
 	}
 	rqi->abts_done = NULL;
 
@@ -1814,14 +1823,13 @@ snic_dr_clean_single_req(struct snic *snic,
 	if (CMD_ABTS_STATUS(sc) == SNIC_INVALID_CODE) {
 		SNIC_HOST_ERR(snic->shost,
 			      "clean_single_req_err:sc %p tag %d abt still pending w/ fw, tm_tag %d flags 0x%llx\n",
-			      sc, tag, rqi->tm_tag, CMD_FLAGS(sc));
+			      sc, snic_cmd_tag(sc), rqi->tm_tag, CMD_FLAGS(sc));
 
 		CMD_FLAGS(sc) |= SNIC_IO_ABTS_TERM_DONE;
-		ret = 1;
-
-		goto skip_clean;
+		iter_data->ret = 1;
+		spin_unlock_irqrestore(io_lock, flags);
+		return false;
 	}
-
 	CMD_STATE(sc) = SNIC_IOREQ_ABTS_COMPLETE;
 	CMD_SP(sc) = NULL;
 	spin_unlock_irqrestore(io_lock, flags);
@@ -1831,39 +1839,31 @@ snic_dr_clean_single_req(struct snic *snic,
 	sc->result = (DID_ERROR << 16);
 	sc->scsi_done(sc);
 
-	ret = 0;
-
-	return ret;
-
-skip_clean:
-	spin_unlock_irqrestore(io_lock, flags);
-
-	return ret;
+	return true;
 } /* end of snic_dr_clean_single_req */
 
 static int
-snic_dr_clean_pending_req(struct snic *snic, struct scsi_cmnd *lr_sc)
+snic_dr_clean_pending_req(struct snic *snic, struct scsi_device *lr_sdev)
 {
-	struct scsi_device *lr_sdev = lr_sc->device;
-	u32 tag = 0;
 	int ret = FAILED;
+	struct snic_cmd_pending_iter_data iter_data = {
+		.snic = snic,
+		.sdev = lr_sdev,
+		.ret = 0,
+	};
 
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		if (tag == snic_cmd_tag(lr_sc))
-			continue;
+	scsi_host_busy_iter(snic->shost,
+			    snic_dr_clean_single_req, &iter_data);
+	if (iter_data.ret) {
+		SNIC_HOST_ERR(snic->shost, "clean_err = %d\n", iter_data.ret);
 
-		ret = snic_dr_clean_single_req(snic, tag, lr_sdev);
-		if (ret) {
-			SNIC_HOST_ERR(snic->shost, "clean_err:tag = %d\n", tag);
-
-			goto clean_err;
-		}
+		goto clean_err;
 	}
 
 	schedule_timeout(msecs_to_jiffies(100));
 
 	/* Walk through all the cmds and check abts status. */
-	if (snic_is_abts_pending(snic, lr_sc)) {
+	if (snic_is_abts_pending(snic, lr_sdev)) {
 		ret = FAILED;
 
 		goto clean_err;
@@ -1950,7 +1950,7 @@ snic_dr_finish(struct snic *snic, struct scsi_cmnd *sc)
 	 * succeeds.
 	 */
 
-	ret = snic_dr_clean_pending_req(snic, sc);
+	ret = snic_dr_clean_pending_req(snic, sc->device);
 	if (ret) {
 		spin_lock_irqsave(io_lock, flags);
 		SNIC_SCSI_DBG(snic->shost,
@@ -2408,77 +2408,79 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
 		complete(rqi->abts_done);
 }
 
-/*
- * snic_scsi_cleanup: Walks through tag map and releases the reqs
- */
-static void
-snic_scsi_cleanup(struct snic *snic)
+static bool
+snic_scsi_cleanup_iter(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
+	struct snic *snic = data;
 	struct snic_req_info *rqi = NULL;
-	struct scsi_cmnd *sc = NULL;
 	spinlock_t *io_lock = NULL;
 	unsigned long flags;
-	int tag;
+	int tag = snic_cmd_tag(sc);
 	u64 st_time = 0;
 
-	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup.\n");
-
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		io_lock = snic_io_lock_tag(snic, tag);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
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
-
-		rqi = (struct snic_req_info *) CMD_SP(sc);
-		if (!rqi) {
-			spin_unlock_irqrestore(io_lock, flags);
+	io_lock = snic_io_lock_hash(snic, sc);
+	spin_lock_irqsave(io_lock, flags);
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
+	if (!rqi) {
+		spin_unlock_irqrestore(io_lock, flags);
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
+		       "sc_clean: DID_TRANSPORT_DISRUPTED for sc %p, Tag %d flags 0x%llx rqi %p duration %u msecs\n",
+		       sc, tag, CMD_FLAGS(sc), rqi,
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
@@ -2575,6 +2577,40 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
 	return ret;
 } /* end of snic_internal_abort_io */
 
+struct snic_tgt_scsi_abort_io_iter_data {
+	struct snic *snic;
+	struct snic_tgt *tgt;
+	int tmf;
+	int abt_cnt;
+};
+
+static bool
+snic_tgt_scsi_abort_io_iter(struct scsi_cmnd *sc, void *data, bool reserved)
+{
+	struct snic_tgt_scsi_abort_io_iter_data *iter_data = data;
+	struct snic_tgt *sc_tgt = NULL;
+	int ret;
+
+	if (reserved)
+		return true;
+
+	sc_tgt = starget_to_tgt(scsi_target(sc->device));
+	if (sc_tgt != iter_data->tgt)
+		return true;
+
+	ret = snic_internal_abort_io(iter_data->snic, sc, iter_data->tmf);
+	if (ret < 0) {
+		SNIC_HOST_ERR(iter_data->snic->shost,
+			      "tgt_abt_io: Tag %x, Failed w err = %d\n",
+			      snic_cmd_tag(sc), ret);
+		return true;
+	}
+
+	if (ret == SUCCESS)
+		iter_data->abt_cnt++;
+	return true;
+}
+
 /*
  * snic_tgt_scsi_abort_io : called by snic_tgt_del
  */
@@ -2582,11 +2618,10 @@ int
 snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
 {
 	struct snic *snic = NULL;
-	struct scsi_cmnd *sc = NULL;
-	struct snic_tgt *sc_tgt = NULL;
-	spinlock_t *io_lock = NULL;
-	unsigned long flags;
-	int ret = 0, tag, abt_cnt = 0, tmf = 0;
+	struct snic_tgt_scsi_abort_io_iter_data iter_data = {
+		.tgt = tgt,
+		.abt_cnt = 0,
+	};
 
 	if (!tgt)
 		return -1;
@@ -2595,43 +2630,16 @@ snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
 	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: Cleaning Pending IOs.\n");
 
 	if (tgt->tdata.typ == SNIC_TGT_DAS)
-		tmf = SNIC_ITMF_ABTS_TASK;
+		iter_data.tmf = SNIC_ITMF_ABTS_TASK;
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
+		iter_data.tmf = SNIC_ITMF_ABTS_TASK_TERM;
+	iter_data.snic = snic;
 
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
+	scsi_host_busy_iter(snic->shost,
+			    snic_tgt_scsi_abort_io_iter, &iter_data);
 
-	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n", abt_cnt);
+	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n",
+		      iter_data.abt_cnt);
 
 	return 0;
 } /* end of snic_tgt_scsi_abort_io */
-- 
2.29.2

