Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B07FC8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC712076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD3NUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:60778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgD3NUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 19B61AF9F;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v3 30/41] snic: use tagset iter for traversing commands
Date:   Thu, 30 Apr 2020 15:18:53 +0200
Message-Id: <20200430131904.5847-31-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Use the tagset iter to traverse active commands during device and
hba reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic_scsi.c | 246 +++++++++++++++++++++---------------------
 1 file changed, 124 insertions(+), 122 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index d42e178bfab3..01bec9d773ef 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1648,84 +1648,87 @@ snic_abort_cmd(struct scsi_cmnd *sc)
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
+	if (iter_data->sdev && iter_data->sdev != sc->device)
+		return true;
 
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(snic->shost, tag);
-
-		if (!sc || (lr_sc && (sc->device != lr_sdev || sc == lr_sc))) {
-			spin_unlock_irqrestore(io_lock, flags);
-
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
 
+	io_lock = snic_io_lock_tag(snic, sc->request->tag);
+	spin_lock_irqsave(io_lock, flags);
 	rqi = (struct snic_req_info *) CMD_SP(sc);
-
 	if (!rqi)
 		goto skip_clean;
 
@@ -1784,7 +1787,7 @@ snic_dr_clean_single_req(struct snic *snic,
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
 			      "clean_single_req_err:sc %p, tag %d abt failed. tm_tag %d flags 0x%llx\n",
-			      sc, tag, rqi->tm_tag, CMD_FLAGS(sc));
+			      sc, sc->request->tag, rqi->tm_tag, CMD_FLAGS(sc));
 
 		spin_lock_irqsave(io_lock, flags);
 		rqi = (struct snic_req_info *) CMD_SP(sc);
@@ -1795,7 +1798,7 @@ snic_dr_clean_single_req(struct snic *snic,
 		if (CMD_STATE(sc) == SNIC_IOREQ_ABTS_PENDING)
 			CMD_STATE(sc) = sv_state;
 
-		ret = 1;
+		iter_data->ret = 1;
 		goto skip_clean;
 	}
 
@@ -1821,56 +1824,49 @@ snic_dr_clean_single_req(struct snic *snic,
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
-
-		ret = snic_dr_clean_single_req(snic, tag, lr_sdev);
-		if (ret) {
-			SNIC_HOST_ERR(snic->shost, "clean_err:tag = %d\n", tag);
+	scsi_host_busy_iter(snic->shost,
+			    snic_dr_clean_single_req, &iter_data);
+	if (iter_data.ret) {
+		SNIC_HOST_ERR(snic->shost, "clean_err = %d\n", iter_data.ret);
 
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
@@ -1957,7 +1953,7 @@ snic_dr_finish(struct snic *snic, struct scsi_cmnd *sc)
 	 * succeeds.
 	 */
 
-	ret = snic_dr_clean_pending_req(snic, sc);
+	ret = snic_dr_clean_pending_req(snic, sc->device);
 	if (ret) {
 		spin_lock_irqsave(io_lock, flags);
 		SNIC_SCSI_DBG(snic->shost,
@@ -2581,6 +2577,40 @@ snic_internal_abort_io(struct snic *snic, struct scsi_cmnd *sc, int tmf)
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
@@ -2588,11 +2618,10 @@ int
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
@@ -2601,43 +2630,16 @@ snic_tgt_scsi_abort_io(struct snic_tgt *tgt)
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
+		iter_data.tmf = SNIC_ITMF_ABTS_TASK_TERM;
+	iter_data.snic = snic;
 
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
2.16.4

