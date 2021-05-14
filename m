Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2BEC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 133DD613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhENVh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:29 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:35382 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhENVhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:19 -0400
Received: by mail-pl1-f175.google.com with SMTP id t21so111342plo.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uhZ4sQ8r6Nq3O36Cd68M5CqF7+kJz1r4WpZqlrf3MM=;
        b=h6dZzZuxrNN1glnFuC09xN04gFecdd+MX2qHa5XaSRVZQMKrhreZExXHbf5Y2Rypq2
         wktAi47ifa2IKGcDbpkGeOG7FBJjVDIBYbnWruLx++tVJlAhlhHuWxAa7ugNcC95jnc7
         14KuejsNQgdYN3adMDXBdLfnca4JZVdX0xa9m2yawghqGa6LzUK5Acqogs+fAuBCa8NX
         NlVA8OviL2nvryT/rU4wMBGlGOQNZY/jE7zD/sK2KKNgzij+ZL5Wi4ydZIgsvHLGpPQV
         jOX07a93RnjTcEEQ5Sr1qKbB3wSgszuz6LDVH700vk0Z0DAdd27xS/flKAtJo/VtOUqE
         mt1Q==
X-Gm-Message-State: AOAM532jaOccXlXUKkJ8x3kAVTIT3/4HC4vSdNCt1HQ7uAX0hs+JUnua
        hJ/55c0foxat9gKUrOUKQn4=
X-Google-Smtp-Source: ABdhPJwH5Fo+0H/+uDj+4MynBtDXvivYcJ1Yb5TorA01AvfVSj0MqWAQ2VQZ6twPaTlCOebQi5nPmw==
X-Received: by 2002:a17:90a:e550:: with SMTP id ei16mr13506612pjb.127.1621028166161;
        Fri, 14 May 2021 14:36:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 19/50] fnic: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:25 -0700
Message-Id: <20210514213356.5264-71-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 40 ++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 762cc8bd2653..5a0dcea64ad3 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -107,7 +107,7 @@ static void fnic_cleanup_io(struct fnic *fnic);
 static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 					    struct scsi_cmnd *sc)
 {
-	u32 hash = sc->request->tag & (FNIC_IO_LOCKS - 1);
+	u32 hash = blk_req(sc)->tag & (FNIC_IO_LOCKS - 1);
 
 	return &fnic->io_req_lock[hash];
 }
@@ -390,7 +390,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	    (rp->flags & FC_RP_FLAGS_RETRY))
 		exch_flags |= FCPIO_ICMND_SRFLAG_RETRY;
 
-	fnic_queue_wq_copy_desc_icmnd_16(wq, sc->request->tag,
+	fnic_queue_wq_copy_desc_icmnd_16(wq, blk_req(sc)->tag,
 					 0, exch_flags, io_req->sgl_cnt,
 					 SCSI_SENSE_BUFFERSIZE,
 					 io_req->sgl_list_pa,
@@ -511,7 +511,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	sg_count = scsi_dma_map(sc);
 	if (sg_count < 0) {
 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-			  sc->request->tag, sc, 0, sc->cmnd[0],
+			  blk_req(sc)->tag, sc, 0, sc->cmnd[0],
 			  sg_count, CMD_STATE(sc));
 		mempool_free(io_req, fnic->io_req_pool);
 		goto out;
@@ -571,7 +571,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		 * refetch the pointer under the lock.
 		 */
 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-			  sc->request->tag, sc, 0, 0, 0,
+			  blk_req(sc)->tag, sc, 0, 0, 0,
 			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		CMD_SP(sc) = NULL;
@@ -603,7 +603,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			sc->cmnd[5]);
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-		  sc->request->tag, sc, io_req,
+		  blk_req(sc)->tag, sc, io_req,
 		  sg_count, cmd_trace,
 		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
 
@@ -1371,7 +1371,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 	unsigned long start_time = 0;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
-	io_lock = fnic_io_lock_tag(fnic, sc->request->tag);
+	io_lock = fnic_io_lock_tag(fnic, blk_req(sc)->tag);
 	spin_lock_irqsave(io_lock, flags);
 
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
@@ -1413,7 +1413,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 	sc->result = DID_TRANSPORT_DISRUPTED << 16;
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "fnic_cleanup_io: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
-		      sc->request->tag, sc, (jiffies - start_time));
+		      blk_req(sc)->tag, sc, jiffies - start_time);
 
 	if (atomic64_read(&fnic->io_cmpl_skip))
 		atomic64_dec(&fnic->io_cmpl_skip);
@@ -1425,10 +1425,10 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
-				     sc->request->tag, sc);
+				     blk_req(sc)->tag, sc);
 
 		FNIC_TRACE(fnic_cleanup_io,
-			   sc->device->host->host_no, sc->request->tag, sc,
+			   sc->device->host->host_no, blk_req(sc)->tag, sc,
 			   jiffies_to_msecs(jiffies - start_time),
 			   0, ((u64)sc->cmnd[0] << 32 |
 			       (u64)sc->cmnd[2] << 24 |
@@ -1566,7 +1566,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_rport_abort_io_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
-	int abt_tag = sc->request->tag;
+	int abt_tag = blk_req(sc)->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
@@ -1757,7 +1757,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	term_stats = &fnic->fnic_stats.term_stats;
 
 	rport = starget_to_rport(scsi_target(sc->device));
-	tag = sc->request->tag;
+	tag = blk_req(sc)->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
 		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
@@ -1842,7 +1842,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	/* Now queue the abort command to firmware */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	if (fnic_queue_abort_io_req(fnic, sc->request->tag, task_req,
+	if (fnic_queue_abort_io_req(fnic, blk_req(sc)->tag, task_req,
 				    fc_lun.scsi_lun, io_req)) {
 		spin_lock_irqsave(io_lock, flags);
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
@@ -1944,7 +1944,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 
 fnic_abort_cmd_end:
 	FNIC_TRACE(fnic_abort_cmd, sc->device->host->host_no,
-		  sc->request->tag, sc,
+		  blk_req(sc)->tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
 		  0, ((u64)sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
@@ -1994,7 +1994,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	/* fill in the lun info */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	fnic_queue_wq_copy_desc_itmf(wq, sc->request->tag | FNIC_TAG_DEV_RST,
+	fnic_queue_wq_copy_desc_itmf(wq, blk_req(sc)->tag | FNIC_TAG_DEV_RST,
 				     0, FCPIO_ITMF_LUN_RESET, SCSI_NO_TAG,
 				     fc_lun.scsi_lun, io_req->port_id,
 				     fnic->config.ra_tov, fnic->config.ed_tov);
@@ -2025,7 +2025,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
 	struct scsi_device *lun_dev = iter_data->lun_dev;
-	int abt_tag = sc->request->tag;
+	int abt_tag = blk_req(sc)->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
@@ -2206,14 +2206,16 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 static inline int
 fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
 {
-	struct request_queue *q = sc->request->q;
+	struct request_queue *q = blk_req(sc)->q;
 	struct request *dummy;
 
 	dummy = blk_mq_alloc_request(q, REQ_OP_WRITE, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(dummy))
 		return SCSI_NO_TAG;
 
-	sc->tag = sc->request->tag = dummy->tag;
+	WARN_ON_ONCE(blk_req(sc)->tag);
+	WARN_ON_ONCE(sc->tag);
+	sc->tag = blk_req(sc)->tag = dummy->tag;
 	sc->host_scribble = (unsigned char *)dummy;
 
 	return dummy->tag;
@@ -2284,7 +2286,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
 	/* Allocate tag if not present */
 
-	tag = sc->request->tag;
+	tag = blk_req(sc)->tag;
 	if (unlikely(tag < 0)) {
 		/*
 		 * Really should fix the midlayer to pass in a proper
@@ -2459,7 +2461,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 fnic_device_reset_end:
 	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
-		  sc->request->tag, sc,
+		  blk_req(sc)->tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
 		  0, ((u64)sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
