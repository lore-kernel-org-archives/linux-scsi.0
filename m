Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED857C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D594160F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhHIXFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:04 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:55940 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237023AbhHIXEz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:04:55 -0400
Received: by mail-pj1-f44.google.com with SMTP id ca5so30338433pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=djM37HuIShtCpzHqVRW3ib7SQa26MtJYLntYYsXPTNY=;
        b=EsBvnExgdud5bQXClgF+d0SoGZuNdbYpxwqqJK1M4IaKr9HTEAXSfcSCAsbHtIroDE
         oBBhFbg2vJo2EP7piIkjmsZpDlpkFjLl+aL7+HbMQ3ba+VPeTWPhe2FDhIbH4AcSaTev
         GOLYOcod6USB+MhGcb4D9cMVKy3xQTJDYys7jo45MCN9MHo6s65YSn9b4gWE8dDAjDHW
         mj4kfsuTK4N+bsJO17hllC4R/vY0Sc0/5AaJO3l49dVjHrDGiRDRACHnvYlhImTfkIRr
         h+2JPFWY9XpXC/CqYdtgjnO9Wnpar/VyEPJX4muwPovy+ffkFmpLElRgySIBOeLSL9fw
         AJuw==
X-Gm-Message-State: AOAM5313McPfJLd9p4SVi7fs9gzZbh+pmq8CPLgELLPejt5+RU5QOgJV
        qXpygyrqZMQvrjKiTLoqycc=
X-Google-Smtp-Source: ABdhPJzCzml+B6IcQDY8dp6VDX0VZNRkAGKtRoOeuUyB6R40zJfMGJaWUW2rhG511V/2M+R/irQ+tg==
X-Received: by 2002:a17:90a:c57:: with SMTP id u23mr1502557pje.186.1628550274160;
        Mon, 09 Aug 2021 16:04:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 20/52] fnic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:23 -0700
Message-Id: <20210809230355.8186-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 51 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 762cc8bd2653..0f9cedf78872 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -107,7 +107,7 @@ static void fnic_cleanup_io(struct fnic *fnic);
 static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 					    struct scsi_cmnd *sc)
 {
-	u32 hash = sc->request->tag & (FNIC_IO_LOCKS - 1);
+	u32 hash = scsi_cmd_to_rq(sc)->tag & (FNIC_IO_LOCKS - 1);
 
 	return &fnic->io_req_lock[hash];
 }
@@ -390,7 +390,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
 	    (rp->flags & FC_RP_FLAGS_RETRY))
 		exch_flags |= FCPIO_ICMND_SRFLAG_RETRY;
 
-	fnic_queue_wq_copy_desc_icmnd_16(wq, sc->request->tag,
+	fnic_queue_wq_copy_desc_icmnd_16(wq, scsi_cmd_to_rq(sc)->tag,
 					 0, exch_flags, io_req->sgl_cnt,
 					 SCSI_SENSE_BUFFERSIZE,
 					 io_req->sgl_list_pa,
@@ -422,6 +422,7 @@ static inline int fnic_queue_wq_copy_desc(struct fnic *fnic,
  */
 static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
+	const int tag = scsi_cmd_to_rq(sc)->tag;
 	struct fc_lport *lp = shost_priv(sc->device->host);
 	struct fc_rport *rport;
 	struct fnic_io_req *io_req = NULL;
@@ -511,8 +512,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	sg_count = scsi_dma_map(sc);
 	if (sg_count < 0) {
 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-			  sc->request->tag, sc, 0, sc->cmnd[0],
-			  sg_count, CMD_STATE(sc));
+			  tag, sc, 0, sc->cmnd[0], sg_count, CMD_STATE(sc));
 		mempool_free(io_req, fnic->io_req_pool);
 		goto out;
 	}
@@ -571,7 +571,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		 * refetch the pointer under the lock.
 		 */
 		FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-			  sc->request->tag, sc, 0, 0, 0,
+			  tag, sc, 0, 0, 0,
 			  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		CMD_SP(sc) = NULL;
@@ -603,8 +603,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			sc->cmnd[5]);
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
-		  sc->request->tag, sc, io_req,
-		  sg_count, cmd_trace,
+		  tag, sc, io_req, sg_count, cmd_trace,
 		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
@@ -1364,6 +1363,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 				 bool reserved)
 {
+	const int tag = scsi_cmd_to_rq(sc)->tag;
 	struct fnic *fnic = data;
 	struct fnic_io_req *io_req;
 	unsigned long flags = 0;
@@ -1371,7 +1371,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 	unsigned long start_time = 0;
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
-	io_lock = fnic_io_lock_tag(fnic, sc->request->tag);
+	io_lock = fnic_io_lock_tag(fnic, tag);
 	spin_lock_irqsave(io_lock, flags);
 
 	io_req = (struct fnic_io_req *)CMD_SP(sc);
@@ -1413,7 +1413,7 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 	sc->result = DID_TRANSPORT_DISRUPTED << 16;
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "fnic_cleanup_io: tag:0x%x : sc:0x%p duration = %lu DID_TRANSPORT_DISRUPTED\n",
-		      sc->request->tag, sc, (jiffies - start_time));
+		      tag, sc, jiffies - start_time);
 
 	if (atomic64_read(&fnic->io_cmpl_skip))
 		atomic64_dec(&fnic->io_cmpl_skip);
@@ -1425,10 +1425,10 @@ static bool fnic_cleanup_io_iter(struct scsi_cmnd *sc, void *data,
 		if (!(CMD_FLAGS(sc) & FNIC_IO_ISSUED))
 			shost_printk(KERN_ERR, fnic->lport->host,
 				     "Calling done for IO not issued to fw: tag:0x%x sc:0x%p\n",
-				     sc->request->tag, sc);
+				     tag, sc);
 
 		FNIC_TRACE(fnic_cleanup_io,
-			   sc->device->host->host_no, sc->request->tag, sc,
+			   sc->device->host->host_no, tag, sc,
 			   jiffies_to_msecs(jiffies - start_time),
 			   0, ((u64)sc->cmnd[0] << 32 |
 			       (u64)sc->cmnd[2] << 24 |
@@ -1566,7 +1566,7 @@ static bool fnic_rport_abort_io_iter(struct scsi_cmnd *sc, void *data,
 {
 	struct fnic_rport_abort_io_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
-	int abt_tag = sc->request->tag;
+	int abt_tag = scsi_cmd_to_rq(sc)->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
@@ -1727,6 +1727,7 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
  */
 int fnic_abort_cmd(struct scsi_cmnd *sc)
 {
+	struct request *const rq = scsi_cmd_to_rq(sc);
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -1741,7 +1742,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	struct abort_stats *abts_stats;
 	struct terminate_stats *term_stats;
 	enum fnic_ioreq_state old_ioreq_state;
-	int tag;
+	const int tag = rq->tag;
 	unsigned long abt_issued_time;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
@@ -1757,7 +1758,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	term_stats = &fnic->fnic_stats.term_stats;
 
 	rport = starget_to_rport(scsi_target(sc->device));
-	tag = sc->request->tag;
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
 		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
@@ -1842,8 +1842,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	/* Now queue the abort command to firmware */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	if (fnic_queue_abort_io_req(fnic, sc->request->tag, task_req,
-				    fc_lun.scsi_lun, io_req)) {
+	if (fnic_queue_abort_io_req(fnic, tag, task_req, fc_lun.scsi_lun,
+				    io_req)) {
 		spin_lock_irqsave(io_lock, flags);
 		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
 			CMD_STATE(sc) = old_ioreq_state;
@@ -1943,8 +1943,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	}
 
 fnic_abort_cmd_end:
-	FNIC_TRACE(fnic_abort_cmd, sc->device->host->host_no,
-		  sc->request->tag, sc,
+	FNIC_TRACE(fnic_abort_cmd, sc->device->host->host_no, tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
 		  0, ((u64)sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
@@ -1994,7 +1993,7 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
 	/* fill in the lun info */
 	int_to_scsilun(sc->device->lun, &fc_lun);
 
-	fnic_queue_wq_copy_desc_itmf(wq, sc->request->tag | FNIC_TAG_DEV_RST,
+	fnic_queue_wq_copy_desc_itmf(wq, scsi_cmd_to_rq(sc)->tag | FNIC_TAG_DEV_RST,
 				     0, FCPIO_ITMF_LUN_RESET, SCSI_NO_TAG,
 				     fc_lun.scsi_lun, io_req->port_id,
 				     fnic->config.ra_tov, fnic->config.ed_tov);
@@ -2025,7 +2024,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc,
 	struct fnic_pending_aborts_iter_data *iter_data = data;
 	struct fnic *fnic = iter_data->fnic;
 	struct scsi_device *lun_dev = iter_data->lun_dev;
-	int abt_tag = sc->request->tag;
+	int abt_tag = scsi_cmd_to_rq(sc)->tag;
 	struct fnic_io_req *io_req;
 	spinlock_t *io_lock;
 	unsigned long flags;
@@ -2206,14 +2205,15 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
 static inline int
 fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
 {
-	struct request_queue *q = sc->request->q;
+	struct request *rq = scsi_cmd_to_rq(sc);
+	struct request_queue *q = rq->q;
 	struct request *dummy;
 
 	dummy = blk_mq_alloc_request(q, REQ_OP_WRITE, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(dummy))
 		return SCSI_NO_TAG;
 
-	sc->tag = sc->request->tag = dummy->tag;
+	sc->tag = rq->tag = dummy->tag;
 	sc->host_scribble = (unsigned char *)dummy;
 
 	return dummy->tag;
@@ -2238,6 +2238,7 @@ fnic_scsi_host_end_tag(struct fnic *fnic, struct scsi_cmnd *sc)
  */
 int fnic_device_reset(struct scsi_cmnd *sc)
 {
+	struct request *rq = scsi_cmd_to_rq(sc);
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2250,7 +2251,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
 	struct reset_stats *reset_stats;
-	int tag = 0;
+	int tag = rq->tag;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 	int tag_gen_flag = 0;   /*to track tags allocated by fnic driver*/
 	bool new_sc = 0;
@@ -2284,7 +2285,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
 	/* Allocate tag if not present */
 
-	tag = sc->request->tag;
 	if (unlikely(tag < 0)) {
 		/*
 		 * Really should fix the midlayer to pass in a proper
@@ -2458,8 +2458,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	}
 
 fnic_device_reset_end:
-	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
-		  sc->request->tag, sc,
+	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no, rq->tag, sc,
 		  jiffies_to_msecs(jiffies - start_time),
 		  0, ((u64)sc->cmnd[0] << 32 |
 		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
