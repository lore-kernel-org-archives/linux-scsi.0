From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Mon, 25 Feb 2013 18:49:14 +0900
Message-ID: <512B339A.7010606@ce.jp.nec.com>
References: <51274C2F.6070500@acm.org> <51274CC3.9070204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:45492 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3BYJ46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 04:56:58 -0500
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r1P9tv5N007891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 18:56:56 +0900 (JST)
In-Reply-To: <51274CC3.9070204@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>Jens Axboe <axboe@kernel.dk>

Hello Bart,

On 02/22/13 19:47, Bart Van Assche wrote:
> As the comment above rq_completed() explains, md members must
> not be touched after the dm_put() at the end of that function
> has been invoked. Avoid that the md->queue can be run
> asynchronously after the last md reference has been dropped by
> running that queue synchronously. This patch fixes the
> following kernel oops:

Calling blk_run_queue_async() there should be ok.
After dm_put(), the dm device may be removed. But free_dev() in dm.c
calls blk_queue_cleanup() and it should solve the race vs. delayed work.

And I could reproduce very similar oops without removing dm device
by following procedure:
(please replace "mpathX" with your dm-multipath map name)

  # t=`dmsetup table mpathX`
  # while sleep 1; do \
      echo "$t" | dmsetup load mpathX; dmsetup resume mpathX; done

Looking at the following back trace:

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

it seems that the bioset was removed while being referenced.

c0820cf5 "dm: introduce per_bio_data" started to replace dm bioset
during table replacement because the size of bioset front_pad might
change for bio-based dm.
However, for request-based dm, it is not necessary because the size
of front_pad is static. Also we can't simply replace bioset because
prep-ed requests in queue have reference to the old bioset.

The patch below changes it not to replace bioset for request-based dm.
(Brings back to the same behavior with v3.7)
With this patch, I could not reproduce the problem.
Could you try this?

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 314a0e2..51fefb5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1973,15 +1973,27 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs) {
-		/*
-		 * The md already has necessary mempools. Reload just the
-		 * bioset because front_pad may have changed because
-		 * a different table was loaded.
-		 */
-		bioset_free(md->bs);
-		md->bs = p->bs;
-		p->bs = NULL;
+	if (md->io_pool && md->bs) {
+		/* The md already has necessary mempools. */
+		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
+			/*
+			 * Reload bioset because front_pad may have changed
+			 * because a different table was loaded.
+			 */
+			bioset_free(md->bs);
+			md->bs = p->bs;
+			p->bs = NULL;
+		} else if (dm_table_get_type(t) == DM_TYPE_REQUEST_BASED) {
+			BUG_ON(!md->tio_pool);
+			/*
+			 * No need to reload in case of request-based dm
+			 * because of fixed size front_pad.
+			 * Note for future: if you are to reload bioset,
+			 * prep-ed requests in queue may have reference
+			 * to bio from the old bioset.
+			 * So you must walk through the queue to unprep.
+			 */
+		}
 		goto out;
 	}
 
