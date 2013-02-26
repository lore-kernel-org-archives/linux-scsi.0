From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm: do not replace bioset for request-based dm
Date: Tue, 26 Feb 2013 16:20:48 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302261619570.5243@file.rdu.redhat.com>
References: <512C3EF2.80204@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924Ab3BZVVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2013 16:21:06 -0500
In-Reply-To: <512C3EF2.80204@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@acm.org>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

On Tue, 26 Feb 2013, Jun'ichi Nomura wrote:

> This patch fixes a regression introduced in v3.8, which causes oops
> like this when dm-multipath is used:
> 
> general protection fault: 0000 [#1] SMP
> RIP: 0010:[<ffffffff810fe754>]  [<ffffffff810fe754>] mempool_free+0x24/0xb0
> Call Trace:
>   <IRQ>
>   [<ffffffff81187417>] bio_put+0x97/0xc0
>   [<ffffffffa02247a5>] end_clone_bio+0x35/0x90 [dm_mod]
>   [<ffffffff81185efd>] bio_endio+0x1d/0x30
>   [<ffffffff811f03a3>] req_bio_endio.isra.51+0xa3/0xe0
>   [<ffffffff811f2f68>] blk_update_request+0x118/0x520
>   [<ffffffff811f3397>] blk_update_bidi_request+0x27/0xa0
>   [<ffffffff811f343c>] blk_end_bidi_request+0x2c/0x80
>   [<ffffffff811f34d0>] blk_end_request+0x10/0x20
>   [<ffffffffa000b32b>] scsi_io_completion+0xfb/0x6c0 [scsi_mod]
>   [<ffffffffa000107d>] scsi_finish_command+0xbd/0x120 [scsi_mod]
>   [<ffffffffa000b12f>] scsi_softirq_done+0x13f/0x160 [scsi_mod]
>   [<ffffffff811f9fd0>] blk_done_softirq+0x80/0xa0
>   [<ffffffff81044551>] __do_softirq+0xf1/0x250
>   [<ffffffff8142ee8c>] call_softirq+0x1c/0x30
>   [<ffffffff8100420d>] do_softirq+0x8d/0xc0
>   [<ffffffff81044885>] irq_exit+0xd5/0xe0
>   [<ffffffff8142f3e3>] do_IRQ+0x63/0xe0
>   [<ffffffff814257af>] common_interrupt+0x6f/0x6f
>   <EOI>
>   [<ffffffffa021737c>] srp_queuecommand+0x8c/0xcb0 [ib_srp]
>   [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
>   [<ffffffffa000a38e>] scsi_request_fn+0x31e/0x520 [scsi_mod]
>   [<ffffffff811f1e57>] __blk_run_queue+0x37/0x50
>   [<ffffffff811f1f69>] blk_delay_work+0x29/0x40
>   [<ffffffff81059003>] process_one_work+0x1c3/0x5c0
>   [<ffffffff8105b22e>] worker_thread+0x15e/0x440
>   [<ffffffff8106164b>] kthread+0xdb/0xe0
>   [<ffffffff8142db9c>] ret_from_fork+0x7c/0xb0
> 
> The regression was introduced by the change
> c0820cf5 "dm: introduce per_bio_data", where dm started to replace
> bioset during table replacement.
> For bio-based dm, it is good because clone bios do not exist during the
> table replacement.
> For request-based dm, however, (not-yet-mapped) clone bios may stay in
> request queue and survive during the table replacement.
> So freeing the old bioset could cause the oops in bio_put().
> 
> Since the size of front_pad may change only with bio-based dm,
> it is not necessary to replace bioset for request-based dm.
> 
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Tested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/md/dm.c |   30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 314a0e2..51fefb5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1973,15 +1973,27 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
>  {
>  	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
>  
> -	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs) {
> -		/*
> -		 * The md already has necessary mempools. Reload just the
> -		 * bioset because front_pad may have changed because
> -		 * a different table was loaded.
> -		 */
> -		bioset_free(md->bs);
> -		md->bs = p->bs;
> -		p->bs = NULL;
> +	if (md->io_pool && md->bs) {
> +		/* The md already has necessary mempools. */
> +		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
> +			/*
> +			 * Reload bioset because front_pad may have changed
> +			 * because a different table was loaded.
> +			 */
> +			bioset_free(md->bs);
> +			md->bs = p->bs;
> +			p->bs = NULL;
> +		} else if (dm_table_get_type(t) == DM_TYPE_REQUEST_BASED) {
> +			BUG_ON(!md->tio_pool);
> +			/*
> +			 * No need to reload in case of request-based dm
> +			 * because of fixed size front_pad.
> +			 * Note for future: if you are to reload bioset,
> +			 * prep-ed requests in queue may have reference
> +			 * to bio from the old bioset.
> +			 * So you must walk through the queue to unprep.
> +			 */
> +		}
>  		goto out;
>  	}
>  
> 
