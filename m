Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFB3C18E5A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FEE22525
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCJQcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:32:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11211 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727126AbgCJQcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:32:19 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8A45719DCC84BA2FEE8A;
        Wed, 11 Mar 2020 00:30:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:29 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 16/24] snic: use tagset iter for traversing commands
Date:   Wed, 11 Mar 2020 00:25:42 +0800
Message-ID: <1583857550-12049-17-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Use the tagset iter to traverse active commands during device and
hba reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic_scsi.c | 406 ++++++++++++++++------------------
 1 file changed, 194 insertions(+), 212 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index c4aaad945d51..f969d1654526 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -77,7 +77,7 @@ static const char * const snic_io_status_str[] = {
 	[SNIC_STAT_FATAL_ERROR]	= "SNIC_STAT_FATAL_ERROR",
 };
 
-static void snic_scsi_cleanup(struct snic *, int);
+static void snic_scsi_cleanup(struct snic *);
 
 const char *
 snic_state_to_str(unsigned int state)
@@ -974,13 +974,13 @@ snic_itmf_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 
 
 static void
-snic_hba_reset_scsi_cleanup(struct snic *snic, struct scsi_cmnd *sc)
+snic_hba_reset_scsi_cleanup(struct snic *snic)
 {
 	struct snic_stats *st = &snic->s_stats;
 	long act_ios = 0, act_fwreqs = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "HBA Reset scsi cleanup.\n");
-	snic_scsi_cleanup(snic, snic_cmd_tag(sc));
+	snic_scsi_cleanup(snic);
 
 	/* Update stats on pending IOs */
 	act_ios = atomic64_read(&st->io.active);
@@ -1021,17 +1021,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 		      "reset_cmpl: type = %x, hdr_stat = %x, cmnd_id = %x, hid = %x, ctx = %lx\n",
 		      typ, hdr_stat, cmnd_id, hid, ctx);
 
-	/* spl case, host reset issued through ioctl */
-	if (cmnd_id == SCSI_NO_TAG) {
-		rqi = (struct snic_req_info *) ctx;
-		SNIC_HOST_INFO(snic->shost,
-			       "reset_cmpl:Tag %d ctx %lx cmpl stat %s\n",
-			       cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
-		sc = rqi->sc;
-
-		goto ioctl_hba_rst;
-	}
-
 	if (cmnd_id >= snic->max_tag_id) {
 		SNIC_HOST_ERR(snic->shost,
 			      "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
@@ -1042,7 +1031,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	}
 
 	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-ioctl_hba_rst:
 	if (!sc) {
 		atomic64_inc(&snic->s_stats.io.sc_null);
 		SNIC_HOST_ERR(snic->shost,
@@ -1089,7 +1077,7 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	spin_unlock_irqrestore(io_lock, flags);
 
 	/* scsi cleanup */
-	snic_hba_reset_scsi_cleanup(snic, sc);
+	snic_hba_reset_scsi_cleanup(snic);
 
 	SNIC_BUG_ON(snic_get_state(snic) != SNIC_OFFLINE &&
 		    snic_get_state(snic) != SNIC_FWRESET);
@@ -1359,7 +1347,7 @@ snic_issue_tm_req(struct snic *snic,
 		    int tmf)
 {
 	struct snic_host_req *tmreq = NULL;
-	int req_id = 0, tag = snic_cmd_tag(sc);
+	int tag = snic_cmd_tag(sc);
 	int ret = 0;
 
 	if (snic_get_state(snic) == SNIC_FWRESET)
@@ -1372,13 +1360,10 @@ snic_issue_tm_req(struct snic *snic,
 		      tmf, rqi, tag);
 
 
-	if (tmf == SNIC_ITMF_LUN_RESET) {
+	if (tmf == SNIC_ITMF_LUN_RESET)
 		tmreq = snic_dr_req_init(snic, rqi);
-		req_id = SCSI_NO_TAG;
-	} else {
+	else
 		tmreq = snic_abort_req_init(snic, rqi);
-		req_id = tag;
-	}
 
 	if (!tmreq) {
 		ret = -ENOMEM;
@@ -1386,7 +1371,7 @@ snic_issue_tm_req(struct snic *snic,
 		goto tmreq_err;
 	}
 
-	ret = snic_queue_itmf_req(snic, tmreq, sc, tmf, req_id);
+	ret = snic_queue_itmf_req(snic, tmreq, sc, tmf, tag);
 	if (ret)
 		goto tmreq_err;
 
@@ -1395,12 +1380,12 @@ snic_issue_tm_req(struct snic *snic,
 tmreq_err:
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
-			      "issu_tmreq: Queing ITMF(%d) Req, sc %p rqi %p req_id %d tag %x fails err = %d\n",
-			      tmf, sc, rqi, req_id, tag, ret);
+			      "issu_tmreq: Queing ITMF(%d) Req, sc %p rqi %p tag %x fails err = %d\n",
+			      tmf, sc, rqi, tag, ret);
 	} else {
 		SNIC_SCSI_DBG(snic->shost,
-			      "issu_tmreq: Queuing ITMF(%d) Req, sc %p, rqi %p, req_id %d tag %x - Success.\n",
-			      tmf, sc, rqi, req_id, tag);
+			      "issu_tmreq: Queuing ITMF(%d) Req, sc %p, rqi %p, tag %x - Success.\n",
+			      tmf, sc, rqi, tag);
 	}
 
 	atomic_dec(&snic->ios_inflight);
@@ -1671,84 +1656,87 @@ snic_abort_cmd(struct scsi_cmnd *sc)
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
-
-	/* walk through the tag map, an dcheck if IOs are still pending in fw*/
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		io_lock = snic_io_lock_tag(snic, tag);
-
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
+	if (reserved)
+		return true;
 
-		if (!sc || (lr_sc && (sc->device != lr_sdev || sc == lr_sc))) {
-			spin_unlock_irqrestore(io_lock, flags);
+	if (iter_data->sdev && iter_data->sdev != sc->device)
+		return true;
 
-			continue;
-		}
+	io_lock = snic_io_lock_tag(iter_data->snic, sc->request->tag);
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
+	scsi_host_tagset_busy_iter(snic->shost,
+				snic_is_abts_pending_iter, &iter_data);
 
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
 
+	io_lock = snic_io_lock_tag(snic, sc->request->tag);
+	spin_lock_irqsave(io_lock, flags);
 	rqi = (struct snic_req_info *) CMD_SP(sc);
-
 	if (!rqi)
 		goto skip_clean;
 
@@ -1807,7 +1795,7 @@ snic_dr_clean_single_req(struct snic *snic,
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
 			      "clean_single_req_err:sc %p, tag %d abt failed. tm_tag %d flags 0x%llx\n",
-			      sc, tag, rqi->tm_tag, CMD_FLAGS(sc));
+			      sc, sc->request->tag, rqi->tm_tag, CMD_FLAGS(sc));
 
 		spin_lock_irqsave(io_lock, flags);
 		rqi = (struct snic_req_info *) CMD_SP(sc);
@@ -1818,7 +1806,7 @@ snic_dr_clean_single_req(struct snic *snic,
 		if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING)
 			CMD_STATE(sc) = sv_state;
 
-		ret = 1;
+		iter_data->ret = 1;
 		goto skip_clean;
 	}
 
@@ -1844,56 +1832,49 @@ snic_dr_clean_single_req(struct snic *snic,
 	if (CMD_ABTS_STATUS(sc) == SNIC_INVALID_CODE) {
 		SNIC_HOST_ERR(snic->shost,
 			      "clean_single_req_err:sc %p tag %d abt still pending w/ fw, tm_tag %d flags 0x%llx\n",
-			      sc, tag, rqi->tm_tag, CMD_FLAGS(sc));
+			      sc, sc->request->tag, rqi->tm_tag, CMD_FLAGS(sc));
 
 		CMD_FLAGS(sc) |= SNIC_IO_ABTS_TERM_DONE;
-		ret = 1;
-
-		goto skip_clean;
-	}
-
-	CMD_STATE(sc) = SNIC_IOREQ_ABTS_COMPLETE;
-	CMD_SP(sc) = NULL;
-	spin_unlock_irqrestore(io_lock, flags);
-
-	snic_release_req_buf(snic, rqi, sc);
-
-	sc->result = (DID_ERROR << 16);
-	sc->scsi_done(sc);
+		iter_data->ret = 1;
+	} else {
+		CMD_STATE(sc) = SNIC_IOREQ_ABTS_COMPLETE;
+		CMD_SP(sc) = NULL;
+		spin_unlock_irqrestore(io_lock, flags);
 
-	ret = 0;
+		snic_release_req_buf(snic, rqi, sc);
 
-	return ret;
+		sc->result = (DID_ERROR << 16);
+		sc->scsi_done(sc);
+	}
+	return true;
 
 skip_clean:
 	spin_unlock_irqrestore(io_lock, flags);
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
+	scsi_host_tagset_busy_iter(snic->shost,
+				snic_dr_clean_single_req, &iter_data);
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
@@ -1980,7 +1961,7 @@ snic_dr_finish(struct snic *snic, struct scsi_cmnd *sc)
 	 * succeeds.
 	 */
 
-	ret = snic_dr_clean_pending_req(snic, sc);
+	ret = snic_dr_clean_pending_req(snic, sc->device);
 	if (ret) {
 		spin_lock_irqsave(io_lock, flags);
 		SNIC_SCSI_DBG(snic->shost,
@@ -2438,87 +2419,83 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
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
 	u64 st_time = 0;
 
-	SNIC_SCSI_DBG(snic->shost, "sc_clean: scsi cleanup.\n");
-
-	for (tag = 0; tag < snic->max_tag_id; tag++) {
-		/* Skip ex_tag */
-		if (tag == ex_tag)
-			continue;
+	if (reserved)
+		return true;
 
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
+	io_lock = snic_io_lock_tag(snic, snic_cmd_tag(sc));
+	spin_lock_irqsave(io_lock, flags);
+	if (unlikely(snic_tmreq_pending(sc))) {
+		/*
+		 * When FW Completes reset w/o sending completions
+		 * for outstanding ios.
+		 */
+		snic_cmpl_pending_tmreq(snic, sc);
+		spin_unlock_irqrestore(io_lock, flags);
 
-		rqi = (struct snic_req_info *) CMD_SP(sc);
-		if (!rqi) {
-			spin_unlock_irqrestore(io_lock, flags);
+		return true;;
+	}
 
-			goto cleanup;
-		}
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
+		      sc, rqi, snic_cmd_tag(sc), CMD_FLAGS(sc));
 
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
+		       sc, snic_cmd_tag(sc), CMD_FLAGS(sc), rqi,
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
+		SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), (ulong) sc,
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
+	scsi_host_tagset_busy_iter(snic->shost,
+				   snic_scsi_cleanup_iter, snic);
 } /* end of snic_scsi_cleanup */
 
 void
@@ -2526,7 +2503,7 @@ snic_shutdown_scsi_cleanup(struct snic *snic)
 {
 	SNIC_HOST_INFO(snic->shost, "Shutdown time SCSI Cleanup.\n");
 
-	snic_scsi_cleanup(snic, SCSI_NO_TAG);
+	snic_scsi_cleanup(snic);
 } /* end of snic_shutdown_scsi_cleanup */
 
 /*
@@ -2615,6 +2592,40 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
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
@@ -2622,11 +2633,10 @@ int
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
@@ -2635,43 +2645,15 @@ snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
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
-
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
+		iter_data.tmf = SNIC_ITMF_ABTS_TASK_TERM;
+	iter_data.snic = snic;
 
-			continue;
-		}
-
-		if (ret == SUCCESS)
-			abt_cnt++;
-	}
+	scsi_host_tagset_busy_iter(snic->shost,
+				   snic_tgt_scsi_abort_io_iter, &iter_data);
 
-	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n", abt_cnt);
+	SNIC_SCSI_DBG(snic->shost, "tgt_abt_io: abt_cnt = %d\n", iter_data.abt_cnt);
 
 	return 0;
 } /* end of snic_tgt_scsi_abort_io */
-- 
2.17.1

