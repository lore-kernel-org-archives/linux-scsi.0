Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9381CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6222A61450
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhDWHpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 03:45:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241173AbhDWHpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 03:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619163898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfKAQl+TOXZrFd3O8SD6RSYkEm0HlX92M3WQS5UO6F0=;
        b=ibr8V+3E06s5v0lQiGcuvG2Mzp1tcEeQsFYlaCayaZiOXvVJM4UUR3IX4SZyE0dBx759el
        t9sTwhQuZDRQNAI632wNKZedYdKOIqNSkKztHVCfp5B4y2xeTuOX14Xlfubah0TghMikys
        P8+r56s6k04RSeem+Quo0643WvaHPsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-LGhgV14dPwCuUNWqfd9pjg-1; Fri, 23 Apr 2021 03:44:56 -0400
X-MC-Unique: LGhgV14dPwCuUNWqfd9pjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74088106BC90;
        Fri, 23 Apr 2021 07:44:42 +0000 (UTC)
Received: from localhost (ovpn-13-161.pek2.redhat.com [10.72.13.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A35D560938;
        Fri, 23 Apr 2021 07:44:41 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH V2 3/5] scsi: fnic: use scsi_host_busy_iter in fnic_cleanup_io
Date:   Fri, 23 Apr 2021 15:43:46 +0800
Message-Id: <20210423074348.2255671-4-ming.lei@redhat.com>
In-Reply-To: <20210423074348.2255671-1-ming.lei@redhat.com>
References: <20210423074348.2255671-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/scsi/fnic/fnic_scsi.c | 137 +++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 9ddcaf4caafc..1baa100a97a1 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1361,93 +1361,92 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 	return wq_work_done;
 }
 
-static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
+static bool fnic_cleanup_cmd(struct scsi_cmnd *sc, void *data, bool rsvd)
 {
-	int i;
 	struct fnic_io_req *io_req;
 	unsigned long flags = 0;
-	struct scsi_cmnd *sc;
 	spinlock_t *io_lock;
 	unsigned long start_time = 0;
+	struct fc_lport *lp = shost_priv(sc->device->host);
+	struct fnic *fnic = lport_priv(lp);
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	int *exclude_id = data;
 
-	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
-		if (i == exclude_id)
-			continue;
+	if (*exclude_id == sc->request->tag)
+		return true;
 
-		io_lock = fnic_io_lock_tag(fnic, i);
-		spin_lock_irqsave(io_lock, flags);
-		sc = scsi_host_find_tag(fnic->lport->host, i);
-		if (!sc) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	io_lock = fnic_io_lock_tag(fnic, sc->request->tag);
+	spin_lock_irqsave(io_lock, flags);
 
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
-		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			!(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
-			/*
-			 * We will be here only when FW completes reset
-			 * without sending completions for outstanding ios.
-			 */
-			CMD_FLAGS(sc) |= FNIC_DEV_RST_DONE;
-			if (io_req && io_req->dr_done)
-				complete(io_req->dr_done);
-			else if (io_req && io_req->abts_done)
-				complete(io_req->abts_done);
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		} else if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-		if (!io_req) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+		!(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
+		/*
+		 * We will be here only when FW completes reset
+		 * without sending completions for outstanding ios.
+		 */
+		CMD_FLAGS(sc) |= FNIC_DEV_RST_DONE;
+		if (io_req && io_req->dr_done)
+			complete(io_req->dr_done);
+		else if (io_req && io_req->abts_done)
+			complete(io_req->abts_done);
+		goto unlock;
+	} else if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		goto unlock;
+	}
+	if (!io_req)
+		goto unlock;
 
-		CMD_SP(sc) = NULL;
+	CMD_SP(sc) = NULL;
 
-		spin_unlock_irqrestore(io_lock, flags);
+	spin_unlock_irqrestore(io_lock, flags);
 
-		/*
-		 * If there is a scsi_cmnd associated with this io_req, then
-		 * free the corresponding state
-		 */
-		start_time = io_req->start_time;
-		fnic_release_ioreq_buf(fnic, io_req, sc);
-		mempool_free(io_req, fnic->io_req_pool);
+	/*
+	 * If there is a scsi_cmnd associated with this io_req, then
+	 * free the corresponding state
+	 */
+	start_time = io_req->start_time;
+	fnic_release_ioreq_buf(fnic, io_req, sc);
+	mempool_free(io_req, fnic->io_req_pool);
 
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
-			      __func__, sc->request->tag, sc,
-			      (jiffies - start_time));
+	sc->result = DID_TRANSPORT_DISRUPTED << 16;
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
+		      __func__, sc->request->tag, sc,
+		      (jiffies - start_time));
 
-		if (atomic64_read(&fnic->io_cmpl_skip))
-			atomic64_dec(&fnic->io_cmpl_skip);
-		else
-			atomic64_inc(&fnic_stats->io_stats.io_completions);
+	if (atomic64_read(&fnic->io_cmpl_skip))
+		atomic64_dec(&fnic->io_cmpl_skip);
+	else
+		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
-		/* Complete the command to SCSI */
-		if (sc->scsi_done) {
-			if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
-				shost_printk(KERN_ERR, fnic->lport->host,
-				"Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
-				 sc->request->tag, sc);
+	/* Complete the command to SCSI */
+	if (sc->scsi_done) {
+		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
+			shost_printk(KERN_ERR, fnic->lport->host,
+			"Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
+			 sc->request->tag, sc);
 
-			FNIC_TRACE(fnic_cleanup_io,
-				  sc->device->host->host_no, i, sc,
-				  jiffies_to_msecs(jiffies - start_time),
-				  0, ((u64)sc->cmnd[0] << 32 |
-				  (u64)sc->cmnd[2] << 24 |
-				  (u64)sc->cmnd[3] << 16 |
-				  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
+		FNIC_TRACE(fnic_cleanup_io,
+			  sc->device->host->host_no, sc->request->tag, sc,
+			  jiffies_to_msecs(jiffies - start_time),
+			  0, ((u64)sc->cmnd[0] << 32 |
+			  (u64)sc->cmnd[2] << 24 |
+			  (u64)sc->cmnd[3] << 16 |
+			  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
+			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-			sc->scsi_done(sc);
-		}
+		sc->scsi_done(sc);
 	}
+	return true;
+ unlock:
+	spin_unlock_irqrestore(io_lock, flags);
+	return true;
+}
+
+static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
+{
+	scsi_host_busy_iter(fnic->lport->host, fnic_cleanup_cmd, &exclude_id);
 }
 
 void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
-- 
2.29.2

