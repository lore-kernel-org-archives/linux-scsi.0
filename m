From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Fri, 22 Feb 2013 06:08:29 -0500
Message-ID: <20130222110829.GA30269@redhat.com>
References: <51274C2F.6070500@acm.org>
 <51274CC3.9070204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab3BVLIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 06:08:45 -0500
Content-Disposition: inline
In-Reply-To: <51274CC3.9070204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

On Fri, Feb 22 2013 at  5:47am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> As the comment above rq_completed() explains, md members must
> not be touched after the dm_put() at the end of that function
> has been invoked. Avoid that the md->queue can be run
> asynchronously after the last md reference has been dropped by
> running that queue synchronously. This patch fixes the
> following kernel oops:
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

Your commit header should probably reference commit
a8c32a5c98943d370ea606a2e7dc04717eb92206 ("dm: fix deadlock with request
based dm and queue request_fn recursion") and cc: stable with "v3.7+"
guidance.

Acked-by: Mike Snitzer <snitzer@redhat.com>
