Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5649553A
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787857064; cv=none; b=IuNiKyDZJFOuZaWEudPUS2intqxL9W5ZX+7vqgrFWfx/K8qIwQIOsXR7bIccazRer8iUs7q5lUZEcYxVCJhRpWvY8oUeUZIxOtGIf+8L6bq/BY7yDoVflpLpSswI1N7xNPYNdhJXhdvmenQsv5P2L4U8aKA9BLNAjsh7e9UANzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787857064; c=relaxed/simple;
	bh=0hKzxnL8XE6fGVBWT7EQKItv4FkZAY/aHcHONEZp87M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgzOWGSV6biKnnFhD41mIFC96C+Rl1h/ltaawXNBTAdhqOzGOqoRxUCbPKW99El+1m4DuemLvlu+jX+rTlaTpVtXVhnm+1w3eGjyCd4yZSPvKiQNBQItV2ppUz29dfNH3HFA/KPnQr4/+o5xYfwk1l139jcJKVPvUWUjtgdYmQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NEKtZEhB; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NEKtZEhB"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8552619b869so27420b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 11:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787857051; x=1788461851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXyg/Z49jw4aKGSw6uMDay7JycMrkh3Jwq5rCDvbinw=;
        b=NEKtZEhBQknQEm/9AVjwGxUazhEzoXXSKQl7AV2lbamALFoqxCOUjVToYoBW0zKZ92
         FuYPFy/fOeUbAiDt/rnJ2lNycfTIiuMzKP65ZSPp//eJdoyUFQXBCZGsZbe8KnK0Klty
         KD9fJOF9qucvTjeBM63St53cCIBI57eBDNVWCd7hacrXBtCHehVA1VoNNFHedmMZR4GW
         MHH18kQdtr/V/C7ibaRHJwDu4XmzOUy/4CMhZg5865GDk+RgdqxoKHOMu2kZ+i6pPTEP
         1wjXxJUkEoebvTQAhqZjTQ3WP8s3Gj/J5Tb/yUs55kTQ9+qtAdtyNObmLksz6oZpPRgH
         SA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787857051; x=1788461851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXyg/Z49jw4aKGSw6uMDay7JycMrkh3Jwq5rCDvbinw=;
        b=k+rFdtmAAarWEdV20tEBJjs0o8kUpe9q/aWFcBQ+fh/HNr7JvsyoyBdXkTxQmu+a2q
         3PoZI2uw1yM+1LJJQO6Q1dO1pcNPWd0me6Avdjzf2GX3RGDadyry8zk5qG+39qUD47MZ
         gzpcZqXoTPd70FX6Yo1w1aTpDe1uMjIagmTpG8CVgrhdbwOm5sRF0CqYZyL0jIAwnDBX
         WXGJ8zvHme+Hx7OXp5oFSTMHx4y4cG6E3v9Tin6T2ydkRMgjx3pfy/vmLk6whPDMI0Qi
         TOvcLAdLYqtO5Qq0Iol/gtcqLXILyeAqB96Yr3wyv5ybY+csoFcgLArk0o9daP/n/3QS
         MvYA==
X-Forwarded-Encrypted: i=1; AHgh+RpaxBgrJj8aixKj2RsjJzLXj9uNXTv1PdVzEIPKiGVinWHuC0JaJc5SfOy2949yjrjFfI+CQZ7dkAwo@vger.kernel.org
X-Gm-Message-State: AFuF++nYf1gN1ktYn7kSLdgnV+PHnnXz23+ah9A32OSFHgGhrQi8w4WQ
	IDNKVKfO8mY/R8TWH0QIZI0Dj9YouO6kZ3KWoQVRetV6Qm+ZU/Xmfqrgf/hb1YXHaQSZNogPKNq
	Wvc9/GGeo0nLtKZORcHFyGKWHn0D+FEUNZRbe
X-Gm-Gg: AR+sD119aoU0bj18Vl8raEFFAKsqVLB9EVVP9Bdz9J7yIxtr9nJue7hD/AG7eHrp7g0
	/qvxxzy0R5kHq1IPG07Q/29B/GBnR7gGaOvlczLPDGKP4EBwP+eYjYlUFVF/1IBEYALv51nUMDE
	t7aG4ptUA9TuXnJ+WnktcB4quqfLKGPeZgx9Vm26w430m6dqaBCGGQ5hpfi64gUgnjxAgXeZi82
	mj3NYVI3jUDP13C52lJMuMSiP1aaB4SokFkn6zPV7cMiTMUrrU/yrOJZbQhRPhbWjLp3doFd0Oe
	g0m/oRbonZV00Fi/7zldtyg3hxtRLF9oEguitCITR1/GrS0jY9lr5vq5bNtW8ShKw88/9T+7yRT
	AMrO5h0GH7QKMnCH07ldSTQSHhNhzsI1D
X-Received: by 2002:a17:90a:38a5:b0:396:d28e:b52 with SMTP id 98e67ed59e1d1-396d28e0d9cmr549029a91.3.1787857051190;
        Thu, 27 Aug 2026 11:57:31 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-396b0d2fecbsm1264708a91.2.2026.08.27.11.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 11:57:31 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (bond0.slc5-n17m28-k8s.dev.purestorage.com [IPv6:2620:125:9025:20::a31:41f])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id 826E140308;
	Thu, 27 Aug 2026 12:57:30 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7EF97E404C2; Thu, 27 Aug 2026 12:57:30 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <tom.leiming@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
Date: Thu, 27 Aug 2026 12:57:20 -0600
Message-ID: <20260827185722.3234622-2-csander@purestorage.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827185722.3234622-1-csander@purestorage.com>
References: <20260827185722.3234622-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for setting the io_uring NVMe passthru CQE results from
the blk-mq request completion rather than the task work callback, split
out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}().
This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
consolidated into a single CQE-size-agnostic function with 3 fewer
arguments than __io_uring_cmd_done().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 block/ioctl.c                |  7 ++++---
 drivers/block/ublk_drv.c     | 24 ++++++++++++++++--------
 drivers/nvme/host/ioctl.c    |  7 ++++---
 drivers/scsi/scsi_bsg.c      |  4 ++--
 fs/btrfs/ioctl.c             |  3 ++-
 fs/fuse/dev_uring.c          | 15 ++++++++++-----
 include/linux/io_uring/cmd.h | 30 ++++++++++++++----------------
 io_uring/uring_cmd.c         | 35 +++++++++++++++++++----------------
 8 files changed, 71 insertions(+), 54 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 64b4e6c0f696..946cab74f253 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -869,13 +869,14 @@ static void blk_cmd_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	struct blk_iou_cmd *bic = io_uring_cmd_to_pdu(cmd, struct blk_iou_cmd);
 
 	if (bic->res == -EAGAIN && bic->nowait)
 		io_uring_cmd_issue_blocking(cmd);
-	else
-		io_uring_cmd_done(cmd, bic->res,
-				  IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+	else {
+		io_uring_cmd_set_res(cmd, bic->res);
+		io_uring_cmd_done(cmd, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+	}
 }
 
 static void bio_cmd_bio_end_io(struct bio *bio)
 {
 	struct io_uring_cmd *cmd = bio->bi_private;
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4d17ed264da1..51f15e5b3c01 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -837,11 +837,12 @@ static void ublk_batch_deinit_fetch_buf(struct ublk_queue *ubq,
 	list_del_init(&fcmd->node);
 	WARN_ON_ONCE(fcmd != ubq->active_fcmd);
 	__ublk_release_fcmd(ubq);
 	spin_unlock(&ubq->evts_lock);
 
-	io_uring_cmd_done(fcmd->cmd, res, data->issue_flags);
+	io_uring_cmd_set_res(fcmd->cmd, res);
+	io_uring_cmd_done(fcmd->cmd, data->issue_flags);
 	ublk_batch_free_fcmd(fcmd);
 }
 
 static int ublk_batch_fetch_post_cqe(struct ublk_batch_fetch_cmd *fcmd,
 				     struct io_br_sel *sel,
@@ -1640,11 +1641,12 @@ static void ublk_complete_io_cmd(struct ublk_io *io, struct request *req,
 				 int res, unsigned issue_flags)
 {
 	struct io_uring_cmd *cmd = __ublk_prep_compl_io_cmd(io, req);
 
 	/* tell ublksrv one io request is coming */
-	io_uring_cmd_done(cmd, res, issue_flags);
+	io_uring_cmd_set_res(cmd, res);
+	io_uring_cmd_done(cmd, issue_flags);
 }
 
 #define UBLK_REQUEUE_DELAY_MS	3
 
 static inline void __ublk_abort_rq(struct ublk_queue *ubq,
@@ -1726,11 +1728,12 @@ static void ublk_auto_buf_dispatch(const struct ublk_queue *ubq,
 	enum auto_buf_reg_res res = ublk_auto_buf_register(ubq, req, io, cmd,
 			issue_flags);
 
 	if (res != AUTO_BUF_REG_FAIL) {
 		ublk_auto_buf_io_setup(ubq, req, io, cmd, res);
-		io_uring_cmd_done(cmd, UBLK_IO_RES_OK, issue_flags);
+		io_uring_cmd_set_res(cmd, UBLK_IO_RES_OK);
+		io_uring_cmd_done(cmd, issue_flags);
 	}
 }
 
 static bool ublk_start_io(const struct ublk_queue *ubq, struct request *req,
 			  struct ublk_io *io)
@@ -2787,12 +2790,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, u16 tag,
 		cmd = io->cmd;
 		io->cmd = NULL;
 	}
 	spin_unlock(&ubq->cancel_lock);
 
-	if (!done && cmd)
-		io_uring_cmd_done(cmd, UBLK_IO_RES_ABORT, issue_flags);
+	if (!done && cmd) {
+		io_uring_cmd_set_res(cmd, UBLK_IO_RES_ABORT);
+		io_uring_cmd_done(cmd, issue_flags);
+	}
 }
 
 /*
  * Cancel a batch fetch command if it hasn't been claimed by another path.
  *
@@ -2814,11 +2819,12 @@ static void ublk_batch_cancel_cmd(struct ublk_queue *ubq,
 	if (done)
 		list_del_init(&fcmd->node);
 	spin_unlock(&ubq->evts_lock);
 
 	if (done) {
-		io_uring_cmd_done(fcmd->cmd, UBLK_IO_RES_ABORT, issue_flags);
+		io_uring_cmd_set_res(fcmd->cmd, UBLK_IO_RES_ABORT);
+		io_uring_cmd_done(fcmd->cmd, issue_flags);
 		ublk_batch_free_fcmd(fcmd);
 	}
 }
 
 static void ublk_batch_cancel_queue(struct ublk_queue *ubq)
@@ -3524,12 +3530,14 @@ static void ublk_ch_uring_cmd_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_uring_cmd *cmd = io_uring_cmd_from_tw(tw_req);
 	int ret = -ECANCELED;
 
 	if (!tw.cancel)
 		ret = ublk_ch_uring_cmd_local(cmd, issue_flags);
-	if (ret != -EIOCBQUEUED)
-		io_uring_cmd_done(cmd, ret, issue_flags);
+	if (ret != -EIOCBQUEUED) {
+		io_uring_cmd_set_res(cmd, ret);
+		io_uring_cmd_done(cmd, issue_flags);
+	}
 }
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 6539d4750098..131959c00287 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -438,12 +438,12 @@ static void nvme_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-	io_uring_cmd_done32(ioucmd, pdu->status, pdu->result,
-			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+	io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
+	io_uring_cmd_done(ioucmd, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 						blk_status_t err,
 						const struct io_comp_batch *iob)
@@ -469,11 +469,12 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 */
 	if (blk_rq_is_poll(req) && iob &&
 	    iob->poll_ctx == io_uring_cmd_ctx_handle(ioucmd)) {
 		if (pdu->bio)
 			blk_rq_unmap_user(pdu->bio);
-		io_uring_cmd_done32(ioucmd, pdu->status, pdu->result, 0);
+		io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
+		io_uring_cmd_done(ioucmd, 0);
 	} else {
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
 	}
 	return RQ_END_IO_FREE;
 }
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..8b32d8e8f29f 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -58,12 +58,12 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	res2 = bsg_scsi_res2_build(status_byte(scmd->result), driver_status,
 				  host_byte(scmd->result), sense_len_wr,
 				  scmd->resid_len);
 
 	blk_mq_free_request(rq);
-	io_uring_cmd_done32(ioucmd, ret, res2,
-			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+	io_uring_cmd_set_res32(ioucmd, ret, res2);
+	io_uring_cmd_done(ioucmd, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
 
 static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 						  blk_status_t status,
 						  const struct io_comp_batch *iocb)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72bc9d4f7708..07057a708452 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4619,11 +4619,12 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 
 out:
 	btrfs_unlock_extent(io_tree, priv->start, priv->lockend, &priv->cached_state);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 
-	io_uring_cmd_done(cmd, ret, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+	io_uring_cmd_set_res(cmd, ret);
+	io_uring_cmd_done(cmd, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 	add_rchar(current, ret);
 
 	for (index = 0; index < priv->nr_pages; index++)
 		__free_page(priv->pages[index]);
 
diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 77c8cec43d9c..c5bb50183e1c 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -364,12 +364,14 @@ static void fuse_uring_entry_teardown(struct fuse_ring_ent *ent)
 	 */
 	list_move(&ent->list, &queue->ent_released);
 	ent->state = FRRS_RELEASED;
 	spin_unlock(&queue->lock);
 
-	if (cmd)
-		io_uring_cmd_done(cmd, -ENOTCONN, IO_URING_F_UNLOCKED);
+	if (cmd) {
+		io_uring_cmd_set_res(cmd, -ENOTCONN);
+		io_uring_cmd_done(cmd, IO_URING_F_UNLOCKED);
+	}
 
 	if (req)
 		fuse_uring_stop_fuse_req_end(req);
 }
 
@@ -529,11 +531,12 @@ static void fuse_uring_cancel(struct io_uring_cmd *cmd,
 	}
 	spin_unlock(&queue->lock);
 
 	if (need_cmd_done) {
 		/* no queue lock to avoid lock order issues */
-		io_uring_cmd_done(cmd, -ENOTCONN, issue_flags);
+		io_uring_cmd_set_res(cmd, -ENOTCONN);
+		io_uring_cmd_done(cmd, issue_flags);
 		kfree(ent);
 		if (atomic_dec_and_test(&queue->ring->queue_refs))
 			wake_up_all(&queue->ring->stop_waitq);
 	}
 }
@@ -940,11 +943,12 @@ static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
 	list_move_tail(&ent->list, &queue->ent_in_userspace);
 	ent->cmd = NULL;
 	fuse_uring_add_to_pq(ent);
 	spin_unlock(&queue->lock);
 
-	io_uring_cmd_done(cmd, ret, issue_flags);
+	io_uring_cmd_set_res(cmd, ret);
+	io_uring_cmd_done(cmd, issue_flags);
 }
 
 /* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
 static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 				   struct fuse_chan *fch)
@@ -1307,11 +1311,12 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 
 		spin_lock(&queue->lock);
 		list_del_init(&ent->list);
 		spin_unlock(&queue->lock);
 
-		io_uring_cmd_done(cmd, err, issue_flags);
+		io_uring_cmd_set_res(cmd, err);
+		io_uring_cmd_done(cmd, issue_flags);
 
 		fuse_uring_req_end(ent, ent->fuse_req, err);
 		kfree(ent);
 		if (atomic_dec_and_test(&queue->ring->queue_refs))
 			wake_up_all(&queue->ring->stop_waitq);
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 331dcbefe72f..96fcc06097c4 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -50,19 +50,22 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  const struct iovec __user *uvec,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
 
+/* One of these must be called prior to io_uring_cmd_done() */
+void io_uring_cmd_set_res(struct io_uring_cmd *, s32 ret);
+void io_uring_cmd_set_res32(struct io_uring_cmd *, s32 ret, u64 res2);
+
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
  * and the corresponding io_uring request.
  *
  * Note: the caller should never hard code @issue_flags and is only allowed
  * to pass the mask provided by the core io_uring code.
  */
-void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret, u64 res2,
-			 unsigned issue_flags, bool is_cqe32);
+void io_uring_cmd_done(struct io_uring_cmd *, unsigned issue_flags);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    io_req_tw_func_t task_work_cb,
 			    unsigned flags);
 
@@ -105,12 +108,19 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 						int ddir, struct iov_iter *iter,
 						unsigned issue_flags)
 {
 	return -EOPNOTSUPP;
 }
-static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
-		u64 ret2, unsigned issue_flags, bool is_cqe32)
+static inline void io_uring_cmd_set_res(struct io_uring_cmd *cmd, s32 ret)
+{
+}
+static inline void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret,
+					  u64 res2)
+{
+}
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd,
+				     unsigned issue_flags)
 {
 }
 static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    io_req_tw_func_t task_work_cb, unsigned flags)
 {
@@ -168,22 +178,10 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
 static inline void *io_uring_cmd_ctx_handle(struct io_uring_cmd *cmd)
 {
 	return cmd_to_io_kiocb(cmd)->ctx;
 }
 
-static inline void io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret,
-				     unsigned issue_flags)
-{
-	return __io_uring_cmd_done(ioucmd, ret, 0, issue_flags, false);
-}
-
-static inline void io_uring_cmd_done32(struct io_uring_cmd *ioucmd, s32 ret,
-				       u64 res2, unsigned issue_flags)
-{
-	return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, true);
-}
-
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags);
 int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 			      unsigned int issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 726a659f38c3..ef3e7e352c6a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -136,40 +136,43 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 	req->io_task_work.func = task_work_cb;
 	__io_req_task_work_add(req, flags);
 }
 EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
 
-static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
-					  u64 extra1, u64 extra2)
+void io_uring_cmd_set_res(struct io_uring_cmd *cmd, s32 ret)
 {
-	req->big_cqe.extra1 = extra1;
-	req->big_cqe.extra2 = extra2;
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
 }
+EXPORT_SYMBOL_GPL(io_uring_cmd_set_res);
+
+void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 res2)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res32(req, ret, 0, res2, 0);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_set_res32);
 
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
  */
-void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
-		       unsigned issue_flags, bool is_cqe32)
+void io_uring_cmd_done(struct io_uring_cmd *ioucmd, unsigned issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
 
 	io_uring_cmd_del_cancelable(ioucmd, issue_flags);
 
-	if (ret < 0)
-		req_set_fail(req);
-
-	io_req_set_res(req, ret, 0);
-	if (is_cqe32) {
-		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
-			req->cqe.flags |= IORING_CQE_F_32;
-		io_req_set_cqe32_extra(req, res2, 0);
-	}
 	io_req_uring_cleanup(req, issue_flags);
 	if (req->flags & REQ_F_IOPOLL) {
 		/* order with io_do_iopoll() checking ->iopoll_completed */
 		smp_store_release(&req->iopoll_completed, 1);
 	} else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
@@ -179,11 +182,11 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	} else {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	}
 }
-EXPORT_SYMBOL_GPL(__io_uring_cmd_done);
+EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_async_cmd *ac;
-- 
2.55.0

