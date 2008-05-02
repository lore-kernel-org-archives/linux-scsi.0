From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: scsi_scan: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
Date: Fri, 2 May 2008 12:13:12 +0200
Message-ID: <9a8748490805020313gb5f4d65obd7258d9bd9170d6@mail.gmail.com>
References: <alpine.LNX.1.00.0805020043130.1489@dragon.funnycrock.com>
	 <20080502111652T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:40952 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbYEBKNN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 06:13:13 -0400
Received: by rv-out-0506.google.com with SMTP id l9so77579rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 03:13:12 -0700 (PDT)
In-Reply-To: <20080502111652T.tomof@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

2008/5/2 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
>
> On Fri, 2 May 2008 00:43:30 +0200 (CEST)
>  Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
>  > Hi,
>  >
>  > For your information;
>  >
>  > I just build and booted the tip of Linus' git tree (HEAD at
>  > 886c35fbcf6fb2eee15687efc2d64d99b6ad9a4a) and got this in dmesg during
>  > bootup :
>  >
>  > ------------[ cut here ]------------
>  > WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
>  > Modules linked in:
>  > Pid: 432, comm: scsi_scan_0 Not tainted 2.6.25-07351-g886c35f #1
>  >  [<c0129684>] warn_on_slowpath+0x54/0x70
>  >  [<c017a7c3>] ? check_object+0xe3/0x1f0
>  >  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  >  [<c014b1e7>] ? mark_held_locks+0x47/0x80
>  >  [<c017cbeb>] ? __kmalloc+0x6b/0x100
>  >  [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
>  >  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  >  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  >  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  >  [<c0200c34>] ? __blk_queue_init_tags+0x24/0x70
>  >  [<c0200c45>] ? __blk_queue_init_tags+0x35/0x70
>  >  [<c0200e57>] blk_queue_init_tags+0x107/0x120
>  >  [<c02b5a91>] ahc_platform_set_tags+0x191/0x1d0
>  >  [<c02b5bd3>] ahc_linux_slave_configure+0x103/0x170
>  >  [<c02a1f65>] scsi_probe_and_add_lun+0x6e5/0x920
>  >  [<c02a2468>] __scsi_scan_target+0xe8/0x5d0
>  >  [<c0108e17>] ? native_sched_clock+0x87/0xd0
>  >  [<c0148c89>] ? get_lock_stats+0x29/0x50
>  >  [<c0148cbd>] ? put_lock_stats+0xd/0x30
>  >  [<c014b1e7>] ? mark_held_locks+0x47/0x80
>  >  [<c035e247>] ? mutex_lock_nested+0x1b7/0x2a0
>  >  [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
>  >  [<c035e23a>] ? mutex_lock_nested+0x1aa/0x2a0
>  >  [<c02a2a1a>] ? scsi_scan_host_selected+0x3a/0xf0
>  >  [<c02a29c0>] scsi_scan_channel+0x70/0x90
>  >  [<c02a2a9d>] scsi_scan_host_selected+0xbd/0xf0
>  >  [<c02a2b50>] ? do_scan_async+0x0/0x140
>  >  [<c02a2b48>] do_scsi_scan_host+0x78/0x80
>  >  [<c02a2b64>] do_scan_async+0x14/0x140
>  >  [<c011f6e8>] ? complete+0x48/0x60
>  >  [<c02a2b50>] ? do_scan_async+0x0/0x140
>  >  [<c013c8d2>] kthread+0x42/0x70
>  >  [<c013c890>] ? kthread+0x0/0x70
>  >  [<c0103ceb>] kernel_thread_helper+0x7/0x1c
>
>  The problem is that the commit 75ad23b expects that we hold the queue
>  lock for __blk_queue_free_tags, blk_queue_free_tags and
>  blk_queue_init_tags but we haven't.
>
>  The simple fix is using queue_flag_set/clear_unlocked for them, then
>  it should work as before. However, it would be better to hold the
>  queue lock for blk_queue_free_tags and blk_queue_init_tags (we can
>  hold the queue lock in scsi_activate_tcq and scsi_deactivate_tcq).
>
>
>  diff --git a/block/blk-tag.c b/block/blk-tag.c
>  index de64e04..d4e21cd 100644
>  --- a/block/blk-tag.c
>  +++ b/block/blk-tag.c
>  @@ -70,7 +70,7 @@ void __blk_queue_free_tags(struct request_queue *q)
>         __blk_free_tags(bqt);
>
>         q->queue_tags = NULL;
>  -       queue_flag_clear(QUEUE_FLAG_QUEUED, q);
>  +       queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
>   }
>
>   /**
>  @@ -98,7 +98,7 @@ EXPORT_SYMBOL(blk_free_tags);
>   **/
>   void blk_queue_free_tags(struct request_queue *q)
>   {
>  -       queue_flag_clear(QUEUE_FLAG_QUEUED, q);
>  +       queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
>   }
>   EXPORT_SYMBOL(blk_queue_free_tags);
>
>  @@ -197,7 +197,7 @@ int blk_queue_init_tags(struct request_queue *q, int depth,
>          * assign it, all done
>          */
>         q->queue_tags = tags;
>  -       queue_flag_set(QUEUE_FLAG_QUEUED, q);
>  +       queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, q);
>         INIT_LIST_HEAD(&q->tag_busy_list);
>         return 0;
>   fail:
>

Thanks Fujita,

Just tested this patch and it does make the WARNING and trace go away.
If there's a better fix and you want me to test more patches, please
just send them my way :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
