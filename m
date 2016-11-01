From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: Device or HBA level QD throttling creates randomness in sequetial workload
Date: Tue, 1 Nov 2016 11:10:59 +0530
Message-ID: <7a9b012d8c7c456e9ec87d1ba5866a9d@mail.gmail.com>
References: <2d656e9c9fbde7206e40a635c61a6084@mail.gmail.com> <298b6ff6-9feb-4b70-ec4c-d1295a0e1f41@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <298b6ff6-9feb-4b70-ec4c-d1295a0e1f41@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

Jens- Replied inline.


Omar -  I tested your WIP repo and figure out System hangs only if I pass "
scsi_mod.use_blk_mq=Y". Without this, your WIP branch works fine, but I am
looking for scsi_mod.use_blk_mq=Y.

Also below is snippet of blktrace. In case of higher per device QD, I see
Requeue request in blktrace.

65,128 10     6268     2.432404509 18594  P   N [fio]
 65,128 10     6269     2.432405013 18594  U   N [fio] 1
 65,128 10     6270     2.432405143 18594  I  WS 148800 + 8 [fio]
 65,128 10     6271     2.432405740 18594  R  WS 148800 + 8 [0]
 65,128 10     6272     2.432409794 18594  Q  WS 148808 + 8 [fio]
 65,128 10     6273     2.432410234 18594  G  WS 148808 + 8 [fio]
 65,128 10     6274     2.432410424 18594  S  WS 148808 + 8 [fio]
 65,128 23     3626     2.432432595 16232  D  WS 148800 + 8 [kworker/23:1H]
 65,128 22     3279     2.432973482     0  C  WS 147432 + 8 [0]
 65,128  7     6126     2.433032637 18594  P   N [fio]
 65,128  7     6127     2.433033204 18594  U   N [fio] 1
 65,128  7     6128     2.433033346 18594  I  WS 148808 + 8 [fio]
 65,128  7     6129     2.433033871 18594  D  WS 148808 + 8 [fio]
 65,128  7     6130     2.433034559 18594  R  WS 148808 + 8 [0]
 65,128  7     6131     2.433039796 18594  Q  WS 148816 + 8 [fio]
 65,128  7     6132     2.433040206 18594  G  WS 148816 + 8 [fio]
 65,128  7     6133     2.433040351 18594  S  WS 148816 + 8 [fio]
 65,128  9     6392     2.433133729     0  C  WS 147240 + 8 [0]
 65,128  9     6393     2.433138166   905  D  WS 148808 + 8 [kworker/9:1H]
 65,128  7     6134     2.433167450 18594  P   N [fio]
 65,128  7     6135     2.433167911 18594  U   N [fio] 1
 65,128  7     6136     2.433168074 18594  I  WS 148816 + 8 [fio]
 65,128  7     6137     2.433168492 18594  D  WS 148816 + 8 [fio]
 65,128  7     6138     2.433174016 18594  Q  WS 148824 + 8 [fio]
 65,128  7     6139     2.433174282 18594  G  WS 148824 + 8 [fio]
 65,128  7     6140     2.433174613 18594  S  WS 148824 + 8 [fio]
CPU0 (sdy):
 Reads Queued:           0,        0KiB  Writes Queued:          79,
316KiB
 Read Dispatches:        0,        0KiB  Write Dispatches:       67,
18,446,744,073PiB
 Reads Requeued:         0               Writes Requeued:        86
 Reads Completed:        0,        0KiB  Writes Completed:       98,
392KiB
 Read Merges:            0,        0KiB  Write Merges:            0,
0KiB
 Read depth:             0               Write depth:             5
 IO unplugs:            79               Timer unplugs:           0



` Kashyap

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Monday, October 31, 2016 10:54 PM
> To: Kashyap Desai; Omar Sandoval
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> block@vger.kernel.org; Christoph Hellwig; paolo.valente@linaro.org
> Subject: Re: Device or HBA level QD throttling creates randomness in
> sequetial
> workload
>
> Hi,
>
> One guess would be that this isn't around a requeue condition, but rather
> the
> fact that we don't really guarantee any sort of hard FIFO behavior between
> the
> software queues. Can you try this test patch to see if it changes the
> behavior for
> you? Warning: untested...

Jens - I tested the patch, but I still see random IO pattern for expected
Sequential Run. I am intentionally running case of Re-queue  and seeing
issue at the time of Re-queue.
If there is no Requeue, I see no issue at LLD.


>
> diff --git a/block/blk-mq.c b/block/blk-mq.c index
> f3d27a6dee09..5404ca9c71b2
> 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -772,6 +772,14 @@ static inline unsigned int queued_to_index(unsigned
> int
> queued)
>   	return min(BLK_MQ_MAX_DISPATCH_ORDER - 1, ilog2(queued) + 1);
>   }
>
> +static int rq_pos_cmp(void *priv, struct list_head *a, struct list_head
> +*b) {
> +	struct request *rqa = container_of(a, struct request, queuelist);
> +	struct request *rqb = container_of(b, struct request, queuelist);
> +
> +	return blk_rq_pos(rqa) < blk_rq_pos(rqb); }
> +
>   /*
>    * Run this hardware queue, pulling any software queues mapped to it in.
>    * Note that this function currently has various problems around
> ordering @@ -
> 812,6 +820,14 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx
> *hctx)
>   	}
>
>   	/*
> +	 * If the device is rotational, sort the list sanely to avoid
> +	 * unecessary seeks. The software queues are roughly FIFO, but
> +	 * only roughly, there are no hard guarantees.
> +	 */
> +	if (!blk_queue_nonrot(q))
> +		list_sort(NULL, &rq_list, rq_pos_cmp);
> +
> +	/*
>   	 * Start off with dptr being NULL, so we start the first request
>   	 * immediately, even if we have more pending.
>   	 */
>
> --
> Jens Axboe
