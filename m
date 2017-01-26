From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Thu, 26 Jan 2017 13:54:50 -0700
Message-ID: <4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 01:47 PM, Bart Van Assche wrote:
> On 01/26/2017 11:01 AM, Jens Axboe wrote:
>> On 01/26/2017 11:59 AM, hch@lst.de wrote:
>>> On Thu, Jan 26, 2017 at 11:57:36AM -0700, Jens Axboe wrote:
>>>> It's against my for-4.11/block, which you were running under Christoph's
>>>> patches. Maybe he's using an older version? In any case, should be
>>>> pretty trivial for you to hand apply. Just ensure that .flags is set to
>>>> 0 for the common cases, and inherit 'flags' when it is passed in.
>>>
>>> No, the flush op cleanups you asked for last round create a conflict
>>> with your patch.  They should be trivial to fix, though.
>>
>> Ah, makes sense. And yes, as I said, should be trivial to hand apply the
>> hunk that does fail.
> 
> Hello Jens and Christoph,
> 
> With the below patch applied the test got a little further but did not
> pass unfortunately. I tried to analyze the new call stack but it's not yet
> clear to me what is going on.
>  
> The patch I had applied on Christoph's tree:
> 
> ---
>  block/blk-mq-sched.c | 2 +-
>  block/blk-mq.c       | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 3bd66e50ec84..7c9318755fab 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -116,7 +116,7 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
>  	ctx = blk_mq_get_ctx(q);
>  	hctx = blk_mq_map_queue(q, ctx->cpu);
>  
> -	blk_mq_set_alloc_data(data, q, 0, ctx, hctx);
> +	blk_mq_set_alloc_data(data, q, data->flags, ctx, hctx);
>  
>  	if (e) {
>  		data->flags |= BLK_MQ_REQ_INTERNAL;
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 83640869d9e4..6697626e5d32 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -248,7 +248,7 @@ EXPORT_SYMBOL_GPL(__blk_mq_alloc_request);
>  struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
>  		unsigned int flags)
>  {
> -	struct blk_mq_alloc_data alloc_data;
> +	struct blk_mq_alloc_data alloc_data = { .flags = flags };
>  	struct request *rq;
>  	int ret;
>  
> @@ -1369,7 +1369,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  {
>  	const int is_sync = op_is_sync(bio->bi_opf);
>  	const int is_flush_fua = op_is_flush(bio->bi_opf);
> -	struct blk_mq_alloc_data data;
> +	struct blk_mq_alloc_data data = { };
>  	struct request *rq;
>  	unsigned int request_count = 0, srcu_idx;
>  	struct blk_plug *plug;
> @@ -1491,7 +1491,7 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
>  	const int is_flush_fua = op_is_flush(bio->bi_opf);
>  	struct blk_plug *plug;
>  	unsigned int request_count = 0;
> -	struct blk_mq_alloc_data data;
> +	struct blk_mq_alloc_data data = { };
>  	struct request *rq;
>  	blk_qc_t cookie;
>  	unsigned int wb_acct;

Looks correct to me. Your call path has blk_get_request() in it, I don't have
that in my tree. Is it passing in the right mask?

-- 
Jens Axboe
