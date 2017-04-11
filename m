From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing
 stalls sporadically
Date: Tue, 11 Apr 2017 12:09:58 -0400
Message-ID: <20170411160958.GA19222@redhat.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
	<20170407181654.27836-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170407181654.27836-7-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 07 2017 at  2:16pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> While running the srp-test software I noticed that request
> processing stalls sporadically at the beginning of a test, namely
> when mkfs is run against a dm-mpath device. Every time when that
> happened the following command was sufficient to resume request
> processing:
> 
>     echo run >/sys/kernel/debug/block/dm-0/state
> 
> This patch avoids that such request processing stalls occur. The
> test I ran is as follows:
> 
>     while srp-test/run_tests -d -r 30 -t 02-mq; do :; done
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> ---
>  drivers/md/dm-rq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 6886bf160fb2..d19af1d21f4c 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -755,6 +755,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		/* Undo dm_start_request() before requeuing */
>  		rq_end_stats(md, rq);
>  		rq_completed(md, rq_data_dir(rq), false);
> +		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
>  		return BLK_MQ_RQ_QUEUE_BUSY;
>  	}
>  
> -- 
> 2.12.0
> 

I really appreciate your hard work Bart but this looks like a cheap
hack.

I'm clearly too late to stop this from going in (given Jens got it
merged for -rc6) but: this has no place in dm-mq (or any blk-mq
driver).  If it is needed it should be elevated to blk-mq core to
trigger blk_mq_delay_run_hw_queue() when BLK_MQ_RQ_QUEUE_BUSY is
returned from blk_mq_ops' .queue_rq.

If this dm-mq specific commit is justified the case certainly is spelled
out in the commit header.
