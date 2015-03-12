From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/7] blk-mq: fix use of incorrect goto label in
 blk_mq_init_queue error path
Date: Thu, 12 Mar 2015 15:48:32 +0800
Message-ID: <CACVXFVN7zpb3+wcOdsa5yyrRJ-EDw7EcMNJOao45UgRZO3rpcQ@mail.gmail.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
	<1426132602-34331-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426132602-34331-2-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2015 at 11:56 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> If percpu_ref_init() fails the 'err_hctxs' label should be used instead
> of 'err_map'.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-mq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4f4bea2..459840c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1938,7 +1938,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
>          */
>         if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
>                             PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
> -               goto err_map;
> +               goto err_hctxs;

If it is changed to 'goto err_hctxs', percpu_ref_init() need to
move before blk_alloc_queue_node(), otherwise just 'goto err_hw'
is enough, but the former is better.

Thanks,
