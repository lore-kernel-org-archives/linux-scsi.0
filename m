From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Device or HBA level QD throttling creates randomness in sequetial
 workload
Date: Mon, 31 Oct 2016 11:24:02 -0600
Message-ID: <298b6ff6-9feb-4b70-ec4c-d1295a0e1f41@kernel.dk>
References: <2d656e9c9fbde7206e40a635c61a6084@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:35959 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754790AbcJaRYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 13:24:05 -0400
Received: by mail-yb0-f180.google.com with SMTP id v78so15824845ybe.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2016 10:24:04 -0700 (PDT)
In-Reply-To: <2d656e9c9fbde7206e40a635c61a6084@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Omar Sandoval <osandov@osandov.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org

Hi,

One guess would be that this isn't around a requeue condition, but
rather the fact that we don't really guarantee any sort of hard FIFO
behavior between the software queues. Can you try this test patch to see
if it changes the behavior for you? Warning: untested...

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f3d27a6dee09..5404ca9c71b2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -772,6 +772,14 @@ static inline unsigned int queued_to_index(unsigned 
int queued)
  	return min(BLK_MQ_MAX_DISPATCH_ORDER - 1, ilog2(queued) + 1);
  }

+static int rq_pos_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct request *rqa = container_of(a, struct request, queuelist);
+	struct request *rqb = container_of(b, struct request, queuelist);
+
+	return blk_rq_pos(rqa) < blk_rq_pos(rqb);
+}
+
  /*
   * Run this hardware queue, pulling any software queues mapped to it in.
   * Note that this function currently has various problems around ordering
@@ -812,6 +820,14 @@ static void __blk_mq_run_hw_queue(struct 
blk_mq_hw_ctx *hctx)
  	}

  	/*
+	 * If the device is rotational, sort the list sanely to avoid
+	 * unecessary seeks. The software queues are roughly FIFO, but
+	 * only roughly, there are no hard guarantees.
+	 */
+	if (!blk_queue_nonrot(q))
+		list_sort(NULL, &rq_list, rq_pos_cmp);
+
+	/*
  	 * Start off with dptr being NULL, so we start the first request
  	 * immediately, even if we have more pending.
  	 */

-- 
Jens Axboe

