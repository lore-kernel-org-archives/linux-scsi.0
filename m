Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232D5C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0110B61435
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhDUIDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234202AbhDUICz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 04:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618992142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f2IAoIByH3ev2kKwV7r9bhguSfcT9NvZEm5wcfvwITc=;
        b=gQTxzJ/rrDriyL2zXJQAmFdCDtJWTqX/J3Y5j/h5xXTubB+Bic3YIDihnqOgm91GRhj/Kr
        tdqU8Mg2LObe44xbeZag5eJr7BOwCyoOYBOV3lRZeogzlbyPsK9ENHn/YTz9UGuK9Z2Cuw
        8iRKL+ltfMCQCdq7+uEgzdZ2jJghhcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-LoBfzvIHOnyHHTKu7QM2eg-1; Wed, 21 Apr 2021 04:02:09 -0400
X-MC-Unique: LoBfzvIHOnyHHTKu7QM2eg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 185DE8E2CD;
        Wed, 21 Apr 2021 07:57:15 +0000 (UTC)
Received: from localhost (ovpn-13-15.pek2.redhat.com [10.72.13.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AB105D9D0;
        Wed, 21 Apr 2021 07:57:10 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH 2/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in fnic_clean_pending_aborts
Date:   Wed, 21 Apr 2021 15:55:40 +0800
Message-Id: <20210421075543.1919826-3-ming.lei@redhat.com>
In-Reply-To: <20210421075543.1919826-1-ming.lei@redhat.com>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So far, scsi_host_find_tag() is supposed to use in fast path and the
passed tag should be active.

Convert the scsi command walking into blk_mq_tagset_busy_iter() in
fnic_terminate_rport_io, which has been one common pattern for handling
failure.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 283 ++++++++++++++++++----------------
 1 file changed, 153 insertions(+), 130 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 522e1b43409d..12503b59f42c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2121,172 +2121,195 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	return ret;
 }
 
-/*
- * Clean up any pending aborts on the lun
- * For each outstanding IO on this lun, whose abort is not completed by fw,
- * issue a local abort. Wait for abort to complete. Return 0 if all commands
- * successfully aborted, 1 otherwise
- */
-static int fnic_clean_pending_aborts(struct fnic *fnic,
-				     struct scsi_cmnd *lr_sc,
-					 bool new_sc)
+struct fnic_clean_pending_aborts_data {
+	struct fnic *fnic;
+	struct scsi_cmnd *lr_sc;
+	bool new_sc;
+	int ret;
+};
 
+static bool __fnic_clean_pending_aborts(struct request *req, void *data,
+		bool reserved)
 {
-	int tag, abt_tag;
+	struct fnic_clean_pending_aborts_data *aborts_data = data;
+	struct fnic *fnic = aborts_data->fnic;
+	struct scsi_cmnd *lr_sc = aborts_data->lr_sc;
+	bool new_sc = aborts_data->new_sc;
+	struct scsi_device *lun_dev = lr_sc->device;
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(req);
+	int tag = req->tag;
+	int abt_tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	int ret = 0;
-	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct scsi_device *lun_dev = lr_sc->device;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	enum fnic_ioreq_state old_ioreq_state;
 
-	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		io_lock = fnic_io_lock_tag(fnic, tag);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		/*
-		 * ignore this lun reset cmd if issued using new SC
-		 * or cmds that do not belong to this lun
-		 */
-		if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_lock = fnic_io_lock_tag(fnic, tag);
+	spin_lock_irqsave(io_lock, flags);
+	sc = scsi_host_find_tag(fnic->lport->host, tag);
+	/*
+	 * ignore this lun reset cmd if issued using new SC
+	 * or cmds that do not belong to this lun
+	 */
+	if (!sc || ((sc == lr_sc) && new_sc) || sc->device != lun_dev)
+		goto unlock;
 
-		if (!io_req || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
 
-		/*
-		 * Found IO that is still pending with firmware and
-		 * belongs to the LUN that we are resetting
-		 */
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	if (!io_req || sc->device != lun_dev)
+		goto unlock;
 
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				"%s dev rst not pending sc 0x%p\n", __func__,
-				sc);
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to the LUN that we are resetting
+	 */
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "Found IO in %s on lun\n",
+		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
 
-		if (io_req->abts_done)
-			shost_printk(KERN_ERR, fnic->lport->host,
-			  "%s: io_req->abts_done is set state is %s\n",
-			  __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
-		old_ioreq_state = CMD_STATE(sc);
-		/*
-		 * Any pending IO issued prior to reset is expected to be
-		 * in abts pending state, if not we need to set
-		 * FNIC_IOREQ_ABTS_PENDING to indicate the IO is abort pending.
-		 * When IO is completed, the IO will be handed over and
-		 * handled in this function.
-		 */
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
+	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+		goto unlock;
 
-		BUG_ON(io_req->abts_done);
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+		(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			"%s dev rst not pending sc 0x%p\n", __func__,
+			sc);
+		goto unlock;
+	}
 
-		abt_tag = tag;
-		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
-			abt_tag |= FNIC_TAG_DEV_RST;
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				  "%s: dev rst sc 0x%p\n", __func__, sc);
-		}
+	if (io_req->abts_done)
+		shost_printk(KERN_ERR, fnic->lport->host,
+		  "%s: io_req->abts_done is set state is %s\n",
+		  __func__, fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	old_ioreq_state = CMD_STATE(sc);
+	/*
+	 * Any pending IO issued prior to reset is expected to be
+	 * in abts pending state, if not we need to set
+	 * FNIC_IOREQ_ABTS_PENDING to indicate the IO is abort pending.
+	 * When IO is completed, the IO will be handed over and
+	 * handled in this function.
+	 */
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 
-		CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
-		io_req->abts_done = &tm_done;
-		spin_unlock_irqrestore(io_lock, flags);
+	BUG_ON(io_req->abts_done);
 
-		/* Now queue the abort command to firmware */
-		int_to_scsilun(sc->device->lun, &fc_lun);
+	abt_tag = tag;
+	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		abt_tag |= FNIC_TAG_DEV_RST;
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			  "%s: dev rst sc 0x%p\n", __func__, sc);
+	}
 
-		if (fnic_queue_abort_io_req(fnic, abt_tag,
-					    FCPIO_ITMF_ABT_TASK_TERM,
-					    fc_lun.scsi_lun, io_req)) {
-			spin_lock_irqsave(io_lock, flags);
-			io_req = (struct fnic_io_req *)CMD_SP(sc);
-			if (io_req)
-				io_req->abts_done = NULL;
-			if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
-				CMD_STATE(sc) = old_ioreq_state;
-			spin_unlock_irqrestore(io_lock, flags);
-			ret = 1;
-			goto clean_pending_aborts_end;
-		} else {
-			spin_lock_irqsave(io_lock, flags);
-			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
-				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
-			spin_unlock_irqrestore(io_lock, flags);
-		}
-		CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
+	CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
+	io_req->abts_done = &tm_done;
+	spin_unlock_irqrestore(io_lock, flags);
 
-		wait_for_completion_timeout(&tm_done,
-					    msecs_to_jiffies
-					    (fnic->config.ed_tov));
+	/* Now queue the abort command to firmware */
+	int_to_scsilun(sc->device->lun, &fc_lun);
 
-		/* Recheck cmd state to check if it is now aborted */
+	if (fnic_queue_abort_io_req(fnic, abt_tag,
+				    FCPIO_ITMF_ABT_TASK_TERM,
+				    fc_lun.scsi_lun, io_req)) {
 		spin_lock_irqsave(io_lock, flags);
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		if (!io_req) {
-			spin_unlock_irqrestore(io_lock, flags);
-			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
-			continue;
-		}
+		if (io_req)
+			io_req->abts_done = NULL;
+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+			CMD_STATE(sc) = old_ioreq_state;
+		spin_unlock_irqrestore(io_lock, flags);
+		goto fail;
+	} else {
+		spin_lock_irqsave(io_lock, flags);
+		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
+			CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+		spin_unlock_irqrestore(io_lock, flags);
+	}
+	CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
 
-		io_req->abts_done = NULL;
+	wait_for_completion_timeout(&tm_done,
+				    msecs_to_jiffies
+				    (fnic->config.ed_tov));
 
-		/* if abort is still pending with fw, fail */
-		if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
-			spin_unlock_irqrestore(io_lock, flags);
-			CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
-			ret = 1;
-			goto clean_pending_aborts_end;
-		}
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
+	/* Recheck cmd state to check if it is now aborted */
+	spin_lock_irqsave(io_lock, flags);
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (!io_req) {
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_REQ_NULL;
+		goto unlock;
+	}
 
-		/* original sc used for lr is handled by dev reset code */
-		if (sc != lr_sc)
-			CMD_SP(sc) = NULL;
+	io_req->abts_done = NULL;
+
+	/* if abort is still pending with fw, fail */
+	if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
 		spin_unlock_irqrestore(io_lock, flags);
+		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
+		goto fail;
+	}
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
-		/* original sc used for lr is handled by dev reset code */
-		if (sc != lr_sc) {
-			fnic_release_ioreq_buf(fnic, io_req, sc);
-			mempool_free(io_req, fnic->io_req_pool);
-		}
+	/* original sc used for lr is handled by dev reset code */
+	if (sc != lr_sc)
+		CMD_SP(sc) = NULL;
+	spin_unlock_irqrestore(io_lock, flags);
 
-		/*
-		 * Any IO is returned during reset, it needs to call scsi_done
-		 * to return the scsi_cmnd to upper layer.
-		 */
-		if (sc->scsi_done) {
-			/* Set result to let upper SCSI layer retry */
-			sc->result = DID_RESET << 16;
-			sc->scsi_done(sc);
-		}
+	/* original sc used for lr is handled by dev reset code */
+	if (sc != lr_sc) {
+		fnic_release_ioreq_buf(fnic, io_req, sc);
+		mempool_free(io_req, fnic->io_req_pool);
 	}
 
+	/*
+	 * Any IO is returned during reset, it needs to call scsi_done
+	 * to return the scsi_cmnd to upper layer.
+	 */
+	if (sc->scsi_done) {
+		/* Set result to let upper SCSI layer retry */
+		sc->result = DID_RESET << 16;
+		sc->scsi_done(sc);
+	}
+	return true;
+ unlock:
+	spin_unlock_irqrestore(io_lock, flags);
+	return true;
+ fail:
+	aborts_data->ret = 1;
+	return false;
+}
+
+/*
+ * Clean up any pending aborts on the lun
+ * For each outstanding IO on this lun, whose abort is not completed by fw,
+ * issue a local abort. Wait for abort to complete. Return 0 if all commands
+ * successfully aborted, 1 otherwise
+ */
+static int fnic_clean_pending_aborts(struct fnic *fnic,
+				     struct scsi_cmnd *lr_sc,
+					 bool new_sc)
+
+{
+	int ret = 0;
+	struct fnic_clean_pending_aborts_data data = {
+		.fnic	=	fnic,
+		.lr_sc	=	lr_sc,
+		.new_sc	=	new_sc,
+		.ret	=	0,
+	};
+
+	blk_mq_tagset_busy_iter(&fnic->lport->host->tag_set,
+			__fnic_clean_pending_aborts, &data);
+	if (data.ret)
+		return data.ret;
+
 	schedule_timeout(msecs_to_jiffies(2 * fnic->config.ed_tov));
 
 	/* walk again to check, if IOs are still pending in fw */
 	if (fnic_is_abts_pending(fnic, lr_sc))
 		ret = FAILED;
 
-clean_pending_aborts_end:
 	return ret;
 }
 
-- 
2.29.2

