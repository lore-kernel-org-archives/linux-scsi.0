From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 20 Jul 2016 10:37:01 -0700
Message-ID: <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
	<20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160720142727.GA57399@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/20/2016 07:27 AM, Mike Snitzer wrote:
> On Wed, Jul 20 2016 at 10:08am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> [ ... ]
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 7a96618..347ff25 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -414,7 +414,7 @@ static void dm_complete_request(struct request *rq, int error)
>  	if (!rq->q->mq_ops)
>  		blk_complete_request(rq);
>  	else
> -		blk_mq_complete_request(rq, error);
> +		blk_mq_complete_request(rq, 0);
>  }
>
>  /*

Hello Mike,

Thanks for the patch. But unfortunately even with this patch applied I 
see fio reporting I/O errors when run on top of dm-mq after a 
(simulated) cable pull. I think these errors occur because 
dm_softirq_done() fails requests if clone == NULL and tio->error != 
NULL. Adding WARN_ON_ONCE(error && !tio->clone) in dm_complete_request() 
produced the following call stack:

Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
  [<ffffffff8132aa27>] dump_stack+0x68/0xa1
  [<ffffffff81061ed6>] __warn+0xc6/0xe0
  [<ffffffff81061fa8>] warn_slowpath_null+0x18/0x20
  [<ffffffffa0253fda>] dm_complete_request+0x8a/0xb0 [dm_mod]
  [<ffffffffa0255200>] map_request+0x70/0x2e0 [dm_mod]
  [<ffffffffa025771d>] dm_mq_queue_rq+0x7d/0x120 [dm_mod]
  [<ffffffff8131195a>] __blk_mq_run_hw_queue+0x1da/0x350
  [<ffffffff813120a0>] blk_mq_run_work_fn+0x10/0x20
  [<ffffffff8107f279>] process_one_work+0x1f9/0x6a0
  [<ffffffff8107f769>] worker_thread+0x49/0x490
  [<ffffffff81085f7a>] kthread+0xea/0x100
  [<ffffffff8162faff>] ret_from_fork+0x1f/0x40

Please let me know if you need more information.

Thanks,

Bart.
