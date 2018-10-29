From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 04/14] blk-mq: pass in request/bio flags to queue mapping
Date: Mon, 29 Oct 2018 10:30:36 -0700
Message-ID: <1540834236.196084.61.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-5-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-5-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 +AEAAQA -400,9 +-402,15 +AEAAQA void blk+AF8-mq+AF8-sched+AF8-insert+AF8-requests(struct request+AF8-queue +ACo-q,
+AD4  				  struct blk+AF8-mq+AF8-ctx +ACo-ctx,
+AD4  				  struct list+AF8-head +ACo-list, bool run+AF8-queue+AF8-async)
+AD4  +AHs
+AD4 -	struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-hctx +AD0 blk+AF8-mq+AF8-map+AF8-queue(q, ctx-+AD4-cpu)+ADs
+AD4 -	struct elevator+AF8-queue +ACo-e +AD0 hctx-+AD4-queue-+AD4-elevator+ADs
+AD4 +-	struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-hctx+ADs
+AD4 +-	struct elevator+AF8-queue +ACo-e+ADs
+AD4 +-	struct request +ACo-rq+ADs
+AD4 +-
+AD4 +-	/+ACo For list inserts, requests better be on the same hw queue +ACo-/
+AD4 +-	rq +AD0 list+AF8-first+AF8-entry(list, struct request, queuelist)+ADs
+AD4 +-	hctx +AD0 blk+AF8-mq+AF8-map+AF8-queue(q, rq-+AD4-cmd+AF8-flags, ctx-+AD4-cpu)+ADs

Passing all request cmd+AF8-flags bits to blk+AF8-mq+AF8-map+AF8-queue() makes it possible
for that function to depend on every single cmd+AF8-flags bit even if different
requests have different cmd+AF8-flags. Have you considered to pass the hw+AF8-ctx
type only to blk+AF8-mq+AF8-map+AF8-queue() to avoid that that function would start
depending on other cmd+AF8-flags?

Additionally, what guarantees that all requests in queuelist have the same
hw+AF8-ctx type? If a later patch will guarantee that, please mention that in
the comment about list+AF8-first+AF8-entry().

Thanks,

Bart.
