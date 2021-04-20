Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E825BC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B34BE6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhDTAJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:40 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:44822 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhDTAJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:37 -0400
Received: by mail-pl1-f177.google.com with SMTP id y1so3024414plg.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkpKiiQ7QErhpRfwfIqYg+u3+hV/n0/tj7DxsSL3k/A=;
        b=q8pzrqwQnAOmwx5NDMOhpd7KyXyhGiveIidyw7kEqOo4V0RdcliitkolGotJqj6ibH
         TCEGlloF0fzj3X2XfgBWz+Fuynoe4s0ugDwYiIrac1UAOOCHLA8dyNJSJjiXgDVfvMsu
         kiNFRU1aZGTeTN3pH1kX+Soxry4pshbNaWMHolYJ9vryFZmCg/OonvOYSBXlnKj5T33I
         OrPxdsPFE+O0CNGd8+o1TjKGx4J6KUwNUJLHPu4ZKh84Z4BEDh1LUIpl2iu0esMnHTGC
         jA0agECyEPSxRnDClZbs4nt99Mlb0ik1VUemHP/7HTWEblQ92sceRWUKIEKxds8CPOs4
         jnOA==
X-Gm-Message-State: AOAM533KVAWW40lZZleVKGnGTmpZV9mgpdeo0tXl4gYMNEluXcjPht8d
        V4qKwiwCBK1Jp757K3snH8U=
X-Google-Smtp-Source: ABdhPJxFhS7djgoLNJuWRXBS3/1yjqYU1r+8hKNyJbNGcIIBcgvY8issobWn2Hb6hvVe8cjWm2CSAQ==
X-Received: by 2002:a17:90a:c984:: with SMTP id w4mr1777768pjt.110.1618877346160;
        Mon, 19 Apr 2021 17:09:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 012/117] block: Convert SCSI and bsg code to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:00 -0700
Message-Id: <20210420000845.25873-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bsg-lib.c    | 16 ++++++++--------
 block/bsg.c        |  6 +++---
 block/scsi_ioctl.c | 14 +++++++-------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 330fede77271..35a01a264816 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -82,18 +82,18 @@ static int bsg_transport_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	 * The assignments below don't make much sense, but are kept for
 	 * bug by bug backwards compatibility:
 	 */
-	hdr->device_status = job->result & 0xff;
-	hdr->transport_status = host_byte(job->result);
-	hdr->driver_status = driver_byte(job->result);
+	hdr->device_status = job->status.b.status;
+	hdr->transport_status = host_byte(job->status);
+	hdr->driver_status = driver_byte(job->status);
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
 	hdr->response_len = 0;
 
-	if (job->result < 0) {
+	if (job->status.combined < 0) {
 		/* we're only returning the result field in the reply */
 		job->reply_len = sizeof(u32);
-		ret = job->result;
+		ret = job->status.combined;
 	}
 
 	if (job->reply_len && hdr->response) {
@@ -183,7 +183,7 @@ void bsg_job_done(struct bsg_job *job, int result,
 {
 	struct request *rq = blk_mq_rq_from_pdu(job);
 
-	job->result = result;
+	job->status.combined = result;
 	job->reply_payload_rcv_len = reply_payload_rcv_len;
 	if (likely(!blk_should_fake_timeout(rq->q)))
 		blk_mq_complete_request(rq);
@@ -247,7 +247,7 @@ static bool bsg_prepare_job(struct device *dev, struct request *req)
 failjob_rls_rqst_payload:
 	kfree(job->request_payload.sg_list);
 failjob_rls_job:
-	job->result = -ENOMEM;
+	job->status.combined = -ENOMEM;
 	return false;
 }
 
@@ -257,7 +257,7 @@ static bool bsg_prepare_job(struct device *dev, struct request *req)
  * @bd: queue data
  *
  * On error the create_bsg_job function should return a -Exyz error value
- * that will be set to ->result.
+ * that will be set to ->status.
  *
  * Drivers/subsys should pass this to the queue init function.
  */
diff --git a/block/bsg.c b/block/bsg.c
index bd10922d5cbb..a03d43ed2bcc 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -94,9 +94,9 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = sreq->result & 0xff;
-	hdr->transport_status = host_byte(sreq->result);
-	hdr->driver_status = driver_byte(sreq->result);
+	hdr->device_status = sreq->status.b.status;
+	hdr->transport_status = host_byte(sreq->status);
+	hdr->driver_status = driver_byte(sreq->status);
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6599bac0a78c..3a56dc979df2 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -252,11 +252,11 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->status = req->result & 0xff;
-	hdr->masked_status = status_byte(req->result);
-	hdr->msg_status = msg_byte(req->result);
-	hdr->host_status = host_byte(req->result);
-	hdr->driver_status = driver_byte(req->result);
+	hdr->status = req->status.b.status;
+	hdr->masked_status = status_byte(req->status);
+	hdr->msg_status = msg_byte(req->status);
+	hdr->host_status = host_byte(req->status);
+	hdr->driver_status = driver_byte(req->status);
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
@@ -495,7 +495,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(disk, rq, 0);
 
-	err = req->result & 0xff;	/* only 8 bit SCSI status */
+	err = req->status.b.status;	/* only 8 bit SCSI status */
 	if (err) {
 		if (req->sense_len && req->sense) {
 			bytes = (OMAX_SB_LEN > req->sense_len) ?
@@ -533,7 +533,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	scsi_req(rq)->cmd[4] = data;
 	scsi_req(rq)->cmd_len = 6;
 	blk_execute_rq(bd_disk, rq, 0);
-	err = scsi_req(rq)->result ? -EIO : 0;
+	err = scsi_req(rq)->status.combined ? -EIO : 0;
 	blk_put_request(rq);
 
 	return err;
