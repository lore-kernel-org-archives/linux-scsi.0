From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
 4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 15:49:28 +0800
Message-ID: <77932f7b-08ba-7ece-3778-d7da82772057@oracle.com>
References: <201806091606.51078.randrianasulu@gmail.com>
 <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org>
 <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com>
 <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
 <20180613140411.GA32701@lst.de>
 <09e8bd7605febd091679172d68ca1e9ca3990c91.camel@wdc.com>
 <20180613143558.GA1163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613143558.GA1163@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph

On 06/13/2018 10:35 PM, hch@lst.de wrote:
> On Wed, Jun 13, 2018 at 02:08:12PM +0000, Bart Van Assche wrote:
>> __blk_mq_complete_request() is already called today by blk_mq_complete_request().
>> However, it's not clear to me why that function is exported by Jianchao's patch.
> 
> True.  I had missed that the patch also started calling the new
> mark_rq_complete function from the error handler.
> 
>> The SCSI error handler already waits until all pending requests have finished
>> before it starts handling timed out commands. This e-mail thread started with a
>> report of a crash in the SCSI error handler, which is a regression introduced in
>> the v4.18 merge window.
> 
> ut-requests-again-that-are-in-the.patch
> Yeah.  I've read back a bit.  If your theory of a double invocation of
> the timeout handler is correct something like the patch below should sort
> it out, right?

Yes, it will work for this issue.
But we should also clear the RQF_TIMED_OUT in __blk_mq_requeue_request and blk_mq_rq_ctx_init.

Thanks
Jianchao

> 
> ---
>>From d408928360f087c0ad24e31d1d25533c698b8b35 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 13 Jun 2018 16:25:40 +0200
> Subject: blk-mq: don't time out requests again that are in the timeout handler
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c         | 4 ++++
>  include/linux/blkdev.h | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e9da5e6a8526..8a2895fed078 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -770,6 +770,7 @@ EXPORT_SYMBOL(blk_mq_tag_to_rq);
>  
>  static void blk_mq_rq_timed_out(struct request *req, bool reserved)
>  {
> +	req->rq_flags |= RQF_TIMED_OUT;
>  	if (req->q->mq_ops->timeout) {
>  		enum blk_eh_timer_return ret;
>  
> @@ -779,6 +780,7 @@ static void blk_mq_rq_timed_out(struct request *req, bool reserved)
>  		WARN_ON_ONCE(ret != BLK_EH_RESET_TIMER);
>  	}
>  
> +	req->rq_flags &= ~RQF_TIMED_OUT;
>  	blk_add_timer(req);
>  }
>  
> @@ -788,6 +790,8 @@ static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
>  
>  	if (blk_mq_rq_state(rq) != MQ_RQ_IN_FLIGHT)
>  		return false;
> +	if (rq->rq_flags & RQF_TIMED_OUT)
> +		return false;
>  
>  	deadline = blk_rq_deadline(rq);
>  	if (time_after_eq(jiffies, deadline))
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index bca3a92eb55f..fa6f11751430 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -127,6 +127,8 @@ typedef __u32 __bitwise req_flags_t;
>  #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
>  /* already slept for hybrid poll */
>  #define RQF_MQ_POLL_SLEPT	((__force req_flags_t)(1 << 20))
> +/* ->timeout has been called, don't expire again */
> +#define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
>  
>  /* flags that prevent us from merging requests: */
>  #define RQF_NOMERGE_FLAGS \
> 
