Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7074EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BC660E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240881AbhJOPQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:16:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50758 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbhJOPQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:16:35 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634310867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2vyjTQFjQd4X++czmFyYar/C0EbLUZWpU7OKsZ1+o4=;
        b=YoMS8BrxVWyprwlIDvdgAX07ZHkyn7LV9i7lrcTZv1H1KlLCjiPqw26FXHTsqIMoYF4Mcg
        sw8Ib832X02v6rb+EwGX7NWjmNlyTC58l2JGS8IxwXoypwciw3qLXcWzu8DKUBicE2vqe2
        nhWxYTa9DTBIASVUe/L8FWortjCr3X0Dgipi2UxPsgm3BFVQV3xIsUHASiv0dD70OEG77c
        X7dY09UImMrKyNMIaeI0qrv6kWwATLjDCgakjAW80vVDFscmTyyRPxndINQplCeFT0qjwY
        OOiFG4Uqr1B1wzA6A5JYUY2rrp0i8ySJQMkCHy+DU0zki9EQNDQETCYku4XqPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634310867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2vyjTQFjQd4X++czmFyYar/C0EbLUZWpU7OKsZ1+o4=;
        b=Z5HO8+NB/9UEy3ZvH2v7lAQZ8BvQB7KY4BTcCiTpNx+p7JkxN1x82YUpHVhE3pkYcyCesx
        jgcdePyLL+/KgVCA==
To:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 1/3] blk-mq: Add blk_mq_complete_request_direct()
Date:   Fri, 15 Oct 2021 17:14:10 +0200
Message-Id: <20211015151412.3229037-2-bigeasy@linutronix.de>
In-Reply-To: <20211015151412.3229037-1-bigeasy@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add blk_mq_complete_request_direct() which completes the block request
directly instead deferring it to softirq for single queue devices.

This is useful for devices which complete the requests in preemptible
context and raising softirq from means scheduling ksoftirqd.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 block/blk-mq.c         | 6 ++++++
 include/linux/blk-mq.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 108a352051be5..44582aef3c32c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -667,6 +667,12 @@ bool blk_mq_complete_request_remote(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_mq_complete_request_remote);
=20
+void blk_mq_complete_request_direct(struct request *rq)
+{
+	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
+	rq->q->mq_ops->complete(rq);
+}
+
 /**
  * blk_mq_complete_request - end I/O on a request
  * @rq:		the request being processed
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 13ba1861e688f..df9ea4c5d91c9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -528,6 +528,7 @@ void __blk_mq_end_request(struct request *rq, blk_statu=
s_t error);
 void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long=
 msecs);
+void blk_mq_complete_request_direct(struct request *rq);
 void blk_mq_complete_request(struct request *rq);
 bool blk_mq_complete_request_remote(struct request *rq);
 bool blk_mq_queue_stopped(struct request_queue *q);
--=20
2.33.0

