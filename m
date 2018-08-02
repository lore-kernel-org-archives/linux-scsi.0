From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] blk-mq: fix blk_mq_tagset_busy_iter
Date: Thu, 02 Aug 2018 09:54:06 -0700
Message-ID: <1533228846.3915.17.camel@HansenPartnership.com>
References: <20180802164329.11900-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802164329.11900-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-08-03 at 00:43 +0800, Ming Lei wrote:
> Commit d250bf4e776ff09d5("blk-mq: only iterate over inflight requests
> in blk_mq_tagset_busy_iter") uses 'blk_mq_rq_state(rq) ==
> MQ_RQ_IN_FLIGHT'
> to replace 'blk_mq_request_started(req)', this way is wrong, and
> causes
> lots of test system hang during booting.
> 
> Fix the issue by using blk_mq_request_started(req) inside
> bt_tags_iter().
> 
> Fixes: d250bf4e776ff09d5 ("blk-mq: only iterate over inflight
> requests in blk_mq_tagset_busy_iter")
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Matt Hart <matthew.hart@linaro.org>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-tag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 09b2ee6694fb..3de0836163c2 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -271,7 +271,7 @@ static bool bt_tags_iter(struct sbitmap *bitmap,
> unsigned int bitnr, void *data)
>  	 * test and set the bit before assining ->rqs[].
>  	 */
>  	rq = tags->rqs[bitnr];
> -	if (rq && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
> +	if (rq && blk_mq_request_started(rq))

So now we have dueling versions of this patch:

https://marc.info/?l=linux-scsi&m=153322802207688

Can we at least make sure we've root caused the problem and confirmed
we've got it fixed before we start the formal patch process?  When we
do start the formal patch process, please give appropriate credit to
the reporter(s) since this has been a royal pain for them to help us
track down.

James
