Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBE3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 506256105A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhDWHpW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 03:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhDWHpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 03:45:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619163885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ei8krr9CUGgakrR/5bmkWWk7cxxpCGX6OiWAm488cIQ=;
        b=GGbZiraatOdUiTw9n4J6toPu4CDm8zZii22aJMxTeNvTYuGwwYg9YUDMlaDB6ekLxAUmwG
        zPNpT05eWTjbqKGGOpqVBNxtUAP1ZZ/+sboeHxyp9ZGTpeI6d4m6Y/SVAOmBffF+Yc0H8c
        LgpF8RclOGprME10+jozMICbll+1+uI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-j0fWHBjoMRaPY9sYmnoRgw-1; Fri, 23 Apr 2021 03:44:43 -0400
X-MC-Unique: j0fWHBjoMRaPY9sYmnoRgw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08741108C209;
        Fri, 23 Apr 2021 07:44:36 +0000 (UTC)
Received: from localhost (ovpn-13-161.pek2.redhat.com [10.72.13.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0BED1042AA9;
        Fri, 23 Apr 2021 07:44:16 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH V2 1/5] scsi: fnic: use scsi_host_busy_iter in fnic_terminate_rport_io
Date:   Fri, 23 Apr 2021 15:43:44 +0800
Message-Id: <20210423074348.2255671-2-ming.lei@redhat.com>
In-Reply-To: <20210423074348.2255671-1-ming.lei@redhat.com>
References: <20210423074348.2255671-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So far, scsi_host_find_tag() is supposed to use in fast path and the
passed tag has to be active.

Convert the scsi command walking into scsi_host_busy_iter(), which has
been one common pattern for handling failure.

Cc: Satish Kharat <satishkh@cisco.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 216 +++++++++++++++++-----------------
 1 file changed, 109 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index e619a82f921b..c276146fdbef 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1678,24 +1678,124 @@ static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
 
 }
 
-void fnic_terminate_rport_io(struct fc_rport *rport)
+static bool fnic_terminate_cmd(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
 	int tag;
 	int abt_tag;
-	int term_cnt = 0;
+	int *term_cnt = data;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct fc_rport_libfc_priv *rdata;
-	struct fc_lport *lport;
-	struct fnic *fnic;
 	struct fc_rport *cmd_rport;
+	struct fc_lport *lp = shost_priv(sc->device->host);
+	struct fnic *fnic = lport_priv(lp);
+	struct fc_rport *rport;
 	struct reset_stats *reset_stats;
 	struct terminate_stats *term_stats;
 	enum fnic_ioreq_state old_ioreq_state;
 
+	term_stats = &fnic->fnic_stats.term_stats;
+	reset_stats = &fnic->fnic_stats.reset_stats;
+	tag = sc->request->tag;
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
+
 	if (!rport) {
 		printk(KERN_ERR "fnic_terminate_rport_io: rport is NULL\n");
 		return;
@@ -1722,108 +1822,10 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
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
+	scsi_host_busy_iter(fnic->lport->host, fnic_terminate_cmd, &term_cnt);
 
+	if (term_cnt > atomic64_read(&fnic->fnic_stats.term_stats.max_terminates))
+		atomic64_set(&fnic->fnic_stats.term_stats.max_terminates, term_cnt);
 }
 
 /*
-- 
2.29.2

