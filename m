Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2BAC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154EC20848
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgCJQao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35520 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbgCJQan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:43 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C7B96811E55FCE8FBEB7;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 10/24] fnic: use scsi_host_tagset_busy_iter() to traverse commands
Date:   Wed, 11 Mar 2020 00:25:36 +0800
Message-ID: <1583857550-12049-11-git-send-email-john.garry@huawei.com>
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

Use scsi_host_tagset_busy_iter() to traverse commands instead of
hand-crafted routine walking the tagspace.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 540 ++++++++++++++--------------------
 1 file changed, 220 insertions(+), 320 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index e96c4bbf2374..54a11510e93e 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -101,7 +101,7 @@ static const char *fnic_fcpio_status_to_str(unsigned int status)
 	return fcpio_status_str[status];
 }
 
-static void fnic_cleanup_io(struct fnic *fnic, int exclude_id);
+static void fnic_cleanup_io(struct fnic *fnic);
 
 static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 					    struct scsi_cmnd *sc)
@@ -637,7 +637,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	atomic64_inc(&reset_stats->fw_reset_completions);
 
 	/* Clean up all outstanding io requests */
-	fnic_cleanup_io(fnic, SCSI_NO_TAG);
+	fnic_cleanup_io(fnic);
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
@@ -1359,94 +1359,90 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 	return wq_work_done;
 }
 
-static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
+static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
+				 bool reserved)
 {
-	int i;
+	struct fnic *fnic = data;
 	struct fnic_io_req *io_req;
 	unsigned long flags = 0;
-	struct scsi_cmnd *sc;
 	spinlock_t *io_lock;
 	unsigned long start_time = 0;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
-	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
-		if (i == exclude_id)
-			continue;
-
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
-			goto cleanup_scsi_cmd;
-		}
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+	    !(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
+		/*
+		 * We will be here only when FW completes reset
+		 * without sending completions for outstanding ios.
+		 */
+		CMD_FLAGS(sc) |= FNIC_DEV_RST_DONE;
+		if (io_req && io_req->dr_done)
+			complete(io_req->dr_done);
+		else if (io_req && io_req->abts_done)
+			complete(io_req->abts_done);
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	} else if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
+	if (!io_req) {
+		spin_unlock_irqrestore(io_lock, flags);
+		goto cleanup_scsi_cmd;
+	}
 
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
 
 cleanup_scsi_cmd:
-		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "%s: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
-			      __func__, sc->request->tag, sc,
-			      (jiffies - start_time));
-
-		if (atomic64_read(&fnic->io_cmpl_skip))
-			atomic64_dec(&fnic->io_cmpl_skip);
-		else
-			atomic64_inc(&fnic_stats->io_stats.io_completions);
+	sc->result = DID_TRANSPORT_DISRUPTED << 16;
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "fnic_cleanup_io: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
+		      sc->request->tag, sc, (jiffies - start_time));
 
-		/* Complete the command to SCSI */
-		if (sc->scsi_done) {
-			if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
-				shost_printk(KERN_ERR, fnic->lport->host,
-				"Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
-				 sc->request->tag, sc);
+	if (atomic64_read(&fnic->io_cmpl_skip))
+		atomic64_dec(&fnic->io_cmpl_skip);
+	else
+		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
-			FNIC_TRACE(fnic_cleanup_io,
-				  sc->device->host->host_no, i, sc,
-				  jiffies_to_msecs(jiffies - start_time),
-				  0, ((u64)sc->cmnd[0] << 32 |
-				  (u64)sc->cmnd[2] << 24 |
-				  (u64)sc->cmnd[3] << 16 |
-				  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-				  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
+	/* Complete the command to SCSI */
+	if (sc->scsi_done) {
+		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
+			shost_printk(KERN_ERR, fnic->lport->host,
+				     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
+				     sc->request->tag, sc);
+
+		FNIC_TRACE(fnic_cleanup_io,
+			   sc->device->host->host_no, sc->request->tag, sc,
+			   jiffies_to_msecs(jiffies - start_time),
+			   0, ((u64)sc->cmnd[0] << 32 |
+			       (u64)sc->cmnd[2] << 24 |
+			       (u64)sc->cmnd[3] << 16 |
+			       (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
+			   (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
-			sc->scsi_done(sc);
-		}
+		sc->scsi_done(sc);
 	}
+	return true;
+}
+
+static void fnic_cleanup_io(struct fnic *fnic)
+{
+	scsi_host_tagset_busy_iter(fnic->lport->host,
+				   fnic_cleanup_io_iter, fnic);
 }
 
 void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
@@ -1557,143 +1553,140 @@ static inline int fnic_queue_abort_io_req(struct fnic *fnic, int tag,
 	return 0;
 }
 
-static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
+struct fnic_rport_abort_io_iter_data {
+	struct fnic *fnic;
+	u32 port_id;
+	int term_cnt;
+};
+
+static bool fnic_rport_abort_io(struct scsi_cmnd *sc, void *data, bool reserved)
 {
-	int tag;
-	int abt_tag;
-	int term_cnt = 0;
+	struct fnic_rport_abort_io_iter_data *iter_data = data;
+	struct fnic *fnic = iter_data->fnic;
+	int abt_tag = sc->request->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
-	struct scsi_cmnd *sc;
 	struct reset_stats *reset_stats = &fnic->fnic_stats.reset_stats;
 	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
 	struct scsi_lun fc_lun;
 	enum fnic_ioreq_state old_ioreq_state;
 
-	FNIC_SCSI_DBG(KERN_DEBUG,
-		      fnic->lport->host,
-		      "fnic_rport_exch_reset called portid 0x%06x\n",
-		      port_id);
-
-	if (fnic->in_remove)
-		return;
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
+	io_lock = fnic_io_lock_tag(fnic, abt_tag);
+	spin_lock_irqsave(io_lock, flags);
 
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
 
-		if (!io_req || io_req->port_id != port_id) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+	if (!io_req || io_req->port_id != iter_data->port_id) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
-		if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
-			(!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+	if ((CMD_FLAGS(sc) & FNIC_DEVICE_RESET) &&
+	    (!(CMD_FLAGS(sc) & FNIC_DEV_RST_ISSUED))) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			"fnic_rport_exch_reset dev rst not pending sc 0x%p\n",
 			sc);
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
 
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
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to rport that went away
+	 */
+	if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
+	if (io_req->abts_done) {
+		shost_printk(KERN_ERR, fnic->lport->host,
 			"fnic_rport_exch_reset: io_req->abts_done is set "
 			"state is %s\n",
 			fnic_ioreq_state_to_str(CMD_STATE(sc)));
-		}
+	}
 
-		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				  "rport_exch_reset "
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
-			"fnic_rport_exch_reset dev rst sc 0x%p\n",
-			sc);
-		}
+	if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED)) {
+		shost_printk(KERN_ERR, fnic->lport->host,
+			     "rport_exch_reset "
+			     "IO not yet issued %p tag 0x%x flags "
+			     "%x state %d\n",
+			     sc, abt_tag, CMD_FLAGS(sc), CMD_STATE(sc));
+	}
+	old_ioreq_state = CMD_STATE(sc);
+	CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
+	CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
+	if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET) {
+		atomic64_inc(&reset_stats->device_reset_terminates);
+		abt_tag |= FNIC_TAG_DEV_RST;
+	}
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "fnic_rport_exch_reset dev rst sc 0x%p\n", sc);
+	BUG_ON(io_req->abts_done);
 
-		BUG_ON(io_req->abts_done);
+	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+		      "fnic_rport_reset_exch: Issuing abts\n");
 
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-			      "fnic_rport_reset_exch: Issuing abts\n");
+	spin_unlock_irqrestore(io_lock, flags);
+
+	/* Now queue the abort command to firmware */
+	int_to_scsilun(sc->device->lun, &fc_lun);
 
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
 		spin_unlock_irqrestore(io_lock, flags);
+	} else {
+		spin_lock_irqsave(io_lock, flags);
+		if (CMD_FLAGS(sc) & FNIC_DEVICE_RESET)
+			CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
+		else
+			CMD_FLAGS(sc) |= FNIC_IO_INTERNAL_TERM_ISSUED;
+		spin_unlock_irqrestore(io_lock, flags);
+		atomic64_inc(&term_stats->terminates);
+		iter_data->term_cnt++;
+	}
+	return true;
+}
 
-		/* Now queue the abort command to firmware */
-		int_to_scsilun(sc->device->lun, &fc_lun);
+static void fnic_rport_exch_reset(struct fnic *fnic, u32 port_id)
+{
+	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
+	struct fnic_rport_abort_io_iter_data iter_data = {
+		.fnic = fnic,
+		.port_id = port_id,
+		.term_cnt = 0,
+	};
 
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
+	FNIC_SCSI_DBG(KERN_DEBUG,
+		      fnic->lport->host,
+		      "fnic_rport_exch_reset called portid 0x%06x\n",
+		      port_id);
+
+	if (fnic->in_remove)
+		return;
+
+	scsi_host_tagset_busy_iter(fnic->lport->host, fnic_rport_abort_io,
+				   &iter_data);
+	if (iter_data.term_cnt > atomic64_read(&term_stats->max_terminates))
+		atomic64_set(&term_stats->max_terminates, iter_data.term_cnt);
 
 }
 
 void fnic_terminate_rport_io(struct fc_rport *rport)
 {
-	int tag;
-	int abt_tag;
-	int term_cnt = 0;
-	struct fnic_io_req *io_req;
-	spinlock_t *io_lock;
-	unsigned long flags;
-	struct scsi_cmnd *sc;
-	struct scsi_lun fc_lun;
 	struct fc_rport_libfc_priv *rdata;
 	struct fc_lport *lport;
 	struct fnic *fnic;
-	struct fc_rport *cmd_rport;
-	struct reset_stats *reset_stats;
-	struct terminate_stats *term_stats;
-	enum fnic_ioreq_state old_ioreq_state;
 
 	if (!rport) {
 		printk(KERN_ERR "fnic_terminate_rport_io: rport is NULL\n");
@@ -1721,109 +1714,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
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
-		cmd_rport = starget_to_rport(scsi_target(sc->device));
-		if (rport != cmd_rport) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
-
-		if (!io_req || rport != cmd_rport) {
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
-
+	fnic_rport_exch_reset(fnic, rport->port_id);
 }
 
 /*
@@ -2741,6 +2632,46 @@ void fnic_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
 
 }
 
+static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data,
+				   bool reserved)
+{
+	struct fnic_pending_aborts_iter_data *iter_data = data;
+	struct fnic *fnic = iter_data->fnic;
+	int cmd_state;
+	struct fnic_io_req *io_req;
+	spinlock_t *io_lock;
+	unsigned long flags;
+
+	if (reserved)
+		return true;
+
+	if (iter_data->lun_dev && sc->device != iter_data->lun_dev)
+		return true;
+
+	io_lock = fnic_io_lock_hash(fnic, sc);
+	spin_lock_irqsave(io_lock, flags);
+
+	io_req = (struct fnic_io_req *)CMD_SP(sc);
+	if (!io_req) {
+		spin_unlock_irqrestore(io_lock, flags);
+		return true;
+	}
+
+	/*
+	 * Found IO that is still pending with firmware and
+	 * belongs to the LUN that we are resetting
+	 */
+	FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
+		      "Found IO in %s on lun\n",
+		      fnic_ioreq_state_to_str(CMD_STATE(sc)));
+	cmd_state = CMD_STATE(sc);
+	spin_unlock_irqrestore(io_lock, flags);
+	if (cmd_state == FNIC_IOREQ_ABTS_PENDING)
+		iter_data->ret = 1;
+
+	return iter_data->ret ? false : true;
+}
+
 /*
  * fnic_is_abts_pending() is a helper function that
  * walks through tag map to check if there is any IOs pending,if there is one,
@@ -2750,49 +2681,18 @@ void fnic_exch_mgr_reset(struct fc_lport *lp, u32 sid, u32 did)
  */
 int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
 {
-	int tag;
-	struct fnic_io_req *io_req;
-	spinlock_t *io_lock;
-	unsigned long flags;
-	int ret = 0;
-	struct scsi_cmnd *sc;
-	struct scsi_device *lun_dev = NULL;
+	struct fnic_pending_aborts_iter_data iter_data = {
+		.fnic = fnic,
+		.lun_dev = NULL,
+		.ret = 0,
+	};
 
 	if (lr_sc)
-		lun_dev = lr_sc->device;
+		iter_data.lun_dev = lr_sc->device;
 
 	/* walk again to check, if IOs are still pending in fw */
-	for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
-		sc = scsi_host_find_tag(fnic->lport->host, tag);
-		/*
-		 * ignore this lun reset cmd or cmds that do not belong to
-		 * this lun
-		 */
-		if (!sc || (lr_sc && (sc->device != lun_dev || sc == lr_sc)))
-			continue;
-
-		io_lock = fnic_io_lock_hash(fnic, sc);
-		spin_lock_irqsave(io_lock, flags);
-
-		io_req = (struct fnic_io_req *)CMD_SP(sc);
-
-		if (!io_req || sc->device != lun_dev) {
-			spin_unlock_irqrestore(io_lock, flags);
-			continue;
-		}
-
-		/*
-		 * Found IO that is still pending with firmware and
-		 * belongs to the LUN that we are resetting
-		 */
-		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-			      "Found IO in %s on lun\n",
-			      fnic_ioreq_state_to_str(CMD_STATE(sc)));
-
-		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
-			ret = 1;
-		spin_unlock_irqrestore(io_lock, flags);
-	}
+	scsi_host_tagset_busy_iter(fnic->lport->host,
+				fnic_abts_pending_iter, &iter_data);
 
-	return ret;
+	return iter_data.ret;
 }
-- 
2.17.1

