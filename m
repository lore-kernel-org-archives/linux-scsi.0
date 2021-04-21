Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBC3C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D692E61158
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 08:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhDUIDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 04:03:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233932AbhDUICp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 04:02:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618992130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a1hD/3rjKkdxv5OoEpCwDI/vC5R7zg8GHDnJJ7oJclY=;
        b=SHxKuONqdk0ycNJA7O7ucLFvcFwg17YQzNIC0utMMiTeHGI7nzYGHhe4iSok3rNTg4dlpp
        C3lp9AIKn0z7N/Pa3KSbJ9LEt42X6oIAF2WFa0DCdXc1ymGs9zJq0FgZfc6GQdWOV2AWOu
        2Ofh8GOzHWgzgDyRDPGwipp/UHYBvU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-7JcF-WwPNS-n2JbZnKuwlQ-1; Wed, 21 Apr 2021 04:02:06 -0400
X-MC-Unique: 7JcF-WwPNS-n2JbZnKuwlQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232F919253F9;
        Wed, 21 Apr 2021 07:57:09 +0000 (UTC)
Received: from localhost (ovpn-13-15.pek2.redhat.com [10.72.13.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6649E60916;
        Wed, 21 Apr 2021 07:57:07 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH 1/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk scsi commands in fnic_terminate_rport_io
Date:   Wed, 21 Apr 2021 15:55:39 +0800
Message-Id: <20210421075543.1919826-2-ming.lei@redhat.com>
In-Reply-To: <20210421075543.1919826-1-ming.lei@redhat.com>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So far, scsi_host_find_tag() is supposed to use in fast path and the
passed tag should be active.

Convert the scsi command walking into blk_mq_tagset_busy_iter(), which has
been one common pattern for handling failure.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 223 +++++++++++++++++-----------------
 1 file changed, 113 insertions(+), 110 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 36744968378f..522e1b43409d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1678,23 +1678,123 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 }
 
-void fnic_terminate_rport_io(struct fc_rport *rport)
+static bool fnic_terminate_cmd(struct request *req, void *data, bool reserved)
 {
-	int tag;
-	int abt_tag;
-	int term_cnt = 0;
+	int abt_tag, tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct fc_rport_libfc_priv *rdata;
-	struct fc_lport *lport;
-	struct fnic *fnic;
 	struct fc_rport *cmd_rport;
+	enum fnic_ioreq_state old_ioreq_state;
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(req);
+	struct fc_lport *lp = shost_priv(sc->device->host);
+	struct fnic *fnic = lport_priv(lp);
+	struct fc_rport *rport;
 	struct reset_stats *reset_stats;
 	struct terminate_stats *term_stats;
-	enum fnic_ioreq_state old_ioreq_state;
+	int *term_cnt = data;
+
+	term_stats = &fnic->fnic_stats.term_stats;
+	reset_stats = &fnic->fnic_stats.reset_stats;
+	tag = req->tag;
+	io_lock = fnic_io_lock_tag(fnic, tag);
+
+	spin_lock_irqsave(io_lock, flags);
+	rport = starget_to_rport(scsi_target(sc->device));
+	abt_tag = tag;
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (!io_req)
+		goto unlock;
+
+	cmd_rport = starget_to_rport(scsi_target(sc->device));
+	if (rport != cmd_rport)
+		goto unlock;
+
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+		(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
+		sc);
+		goto unlock;
+	}
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to rport that went away
+	 */
+	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+		goto unlock;
+
+	if (io_req->abts_done) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+		"fnic_terminate_rport_io: io_req->abts_done is set "
+		"state is %s\n",
+		fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	}
+	if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
+		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+			  "fnic_terminate_rport_io "
+			  "IO not yet issued %p tag 0x%x flags "
+			  "%x state %d\n",
+			  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
+	}
+	old_ioreq_state = CMD_STATE(sc);
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
+	CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
+	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		atomic64_inc(&reset_stats->device_reset_terminates);
+		abt_tag = (tag | FNIC_TAG_DEV_RST);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		"fnic_terminate_rport_io dev rst sc 0x%p\n", sc);
+	}
+
+	BUG_ON(io_req->abts_done);
+
+	FNIC_SCSI_DBG(KERN_DEBUG,
+		      fnic->lport->host,
+		      "fnic_terminate_rport_io: Issuing abts\n");
+
+	spin_unlock_irqrestore(io_lock, flags);
+
+	/* Now queue the abort command to firmware */
+	int_to_scsilun(sc->device->lun, &fc_lun);
+
+	if (fnic_queue_abort_io_req(fnic, abt_tag,
+				    FCPIO_ITMF_ABT_TASK_TERM,
+				    fc_lun.scsi_lun, io_req)) {
+		/*
+		 * Revert the cmd state back to old state, if
+		 * it hasn't changed in between. This cmd will get
+		 * aborted later by scsi_eh, or cleaned up during
+		 * lun reset
+		 */
+		spin_lock_irqsave(io_lock, flags);
+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+			CMD_STATE(sc) = old_ioreq_state;
+		spin_unlock_irqrestore(io_lock, flags);
+	} else {
+		spin_lock_irqsave(io_lock, flags);
+		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
+			CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+		else
+			CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
+		spin_unlock_irqrestore(io_lock, flags);
+		atomic64_inc(&term_stats->terminates);
+		(*term_cnt)++;
+	}
+
+	return true;
+ unlock:
+	spin_unlock_irqrestore(io_lock, flags);
+	return true;
+}
+
+void fnic_terminate_rport_io(struct fc_rport *rport)
+{
+	int term_cnt = 0;
+	struct fc_rport_libfc_priv *rdata;
+	struct fc_lport *lport;
+	struct fnic *fnic;
 
 	if (!rport) {
 		printk(KERN_ERR "fnic_terminate_rport_io: rport is NULL\n");
@@ -1722,108 +1822,11 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 	if (fnic->in_remove)
 		return;
 
-	reset_stats = &fnic->fnic_stats.reset_stats;
-	term_stats = &fnic->fnic_stats.term_stats;
-
-	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		abt_tag = tag;
-		io_lock = fnic_io_lock_tag(fnic, tag);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		if (!sc) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		if (!io_req) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		cmd_rport = starget_to_rport(scsi_target(sc->device));
-		if (rport != cmd_rport) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_terminate_rport_io dev rst not pending sc 0x%p\n",
-			sc);
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-		/*
-		 * Found IO that is still pending with firmware and
-		 * belongs to rport that went away
-		 */
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-		if (io_req->abts_done) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-			"fnic_terminate_rport_io: io_req->abts_done is set "
-			"state is %s\n",
-			fnic_ioreq_state_to_str(CMD_STATE(sc)));
-		}
-		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				  "fnic_terminate_rport_io "
-				  "IO not yet issued %p tag 0x%x flags "
-				  "%x state %d\n",
-				  sc, tag, CMD_FLAGS(sc), CMD_STATE(sc));
-		}
-		old_ioreq_state = CMD_STATE(sc);
-		CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
-		CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
-		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
-			atomic64_inc(&reset_stats->device_reset_terminates);
-			abt_tag = (tag | FNIC_TAG_DEV_RST);
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			"fnic_terminate_rport_io dev rst sc 0x%p\n", sc);
-		}
-
-		BUG_ON(io_req->abts_done);
-
-		FNIC_SCSI_DBG(KERN_DEBUG,
-			      fnic->lport->host,
-			      "fnic_terminate_rport_io: Issuing abts\n");
-
-		spin_unlock_irqrestore(io_lock, flags);
-
-		/* Now queue the abort command to firmware */
-		int_to_scsilun(sc->device->lun, &fc_lun);
-
-		if (fnic_queue_abort_io_req(fnic, abt_tag,
-					    FCPIO_ITMF_ABT_TASK_TERM,
-					    fc_lun.scsi_lun, io_req)) {
-			/*
-			 * Revert the cmd state back to old state, if
-			 * it hasn't changed in between. This cmd will get
-			 * aborted later by scsi_eh, or cleaned up during
-			 * lun reset
-			 */
-			spin_lock_irqsave(io_lock, flags);
-			if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
-				CMD_STATE(sc) = old_ioreq_state;
-			spin_unlock_irqrestore(io_lock, flags);
-		} else {
-			spin_lock_irqsave(io_lock, flags);
-			if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
-				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
-			else
-				CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
-			spin_unlock_irqrestore(io_lock, flags);
-			atomic64_inc(&term_stats->terminates);
-			term_cnt++;
-		}
-	}
-	if (term_cnt > atomic64_read(&term_stats->max_terminates))
-		atomic64_set(&term_stats->max_terminates, term_cnt);
+	blk_mq_tagset_busy_iter(&fnic->lport->host->tag_set,
+			fnic_terminate_cmd, &term_cnt);
 
+	if (term_cnt > atomic64_read(&fnic->fnic_stats.term_stats.max_terminates))
+		atomic64_set(&fnic->fnic_stats.term_stats.max_terminates, term_cnt);
 }
 
 /*
-- 
2.29.2

