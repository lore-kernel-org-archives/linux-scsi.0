From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Sun, 31 Mar 2019 11:11:33 +0800
Message-ID: <CACVXFVNRd7+C9ASNex8DY5eK+Cq4Y4d+hd-rhvLcLcWn9whh4Q@mail.gmail.com>
References: <20181114082551.12141-1-ming.lei@redhat.com> <63c063ad-7d74-4268-bfd4-2de89908949e@kernel.dk>
 <4e24ace9-c83f-5311-5419-18f4a0fb5148@kernel.dk> <20181122010034.GA20814@ming.t460p>
 <dc374ec8-2ea2-0792-4677-0ae81fa7826e@kernel.dk> <baba41b1-8495-8bd1-0bea-341d207852a7@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <baba41b1-8495-8bd1-0bea-341d207852a7@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 30, 2019 at 4:21 AM James Smart <james.smart@broadcom.com> wrote:
>
>
>
> On 11/21/2018 5:42 PM, Jens Axboe wrote:
> > On 11/21/18 6:00 PM, Ming Lei wrote:
> >> On Wed, Nov 21, 2018 at 02:47:35PM -0700, Jens Axboe wrote:
> >>> On 11/14/18 8:20 AM, Jens Axboe wrote:
> >>>> On 11/14/18 1:25 AM, Ming Lei wrote:
> >>>>> c2856ae2f315d ("blk-mq: quiesce queue before freeing queue") has
> >>>>> already fixed this race, however the implied synchronize_rcu()
> >>>>> in blk_mq_quiesce_queue() can slow down LUN probe a lot, so caused
> >>>>> performance regression.
> >>>>>
> >>>>> Then 1311326cf4755c7 ("blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()")
> >>>>> tried to quiesce queue for avoiding unnecessary synchronize_rcu()
> >>>>> only when queue initialization is done, because it is usual to see
> >>>>> lots of inexistent LUNs which need to be probed.
> >>>>>
> >>>>> However, turns out it isn't safe to quiesce queue only when queue
> >>>>> initialization is done. Because when one SCSI command is completed,
> >>>>> the user of sending command can be waken up immediately, then the
> >>>>> scsi device may be removed, meantime the run queue in scsi_end_request()
> >>>>> is still in-progress, so kernel panic can be caused.
> >>>>>
> >>>>> In Red Hat QE lab, there are several reports about this kind of kernel
> >>>>> panic triggered during kernel booting.
> >>>>>
> >>>>> This patch tries to address the issue by grabing one queue usage
> >>>>> counter during freeing one request and the following run queue.
> >>>> Thanks applied, this bug was elusive but ever present in recent
> >>>> testing that we did internally, it's been a huge pain in the butt.
> >>>> The symptoms were usually a crash in blk_mq_get_driver_tag() with
> >>>> hctx->tags == NULL, or a crash inside deadline request insert off
> >>>> requeue.
>
> All,
>
> We are seeing errors with the following error:
>
> [44492.814347] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [44492.814383] IP: [<ffffffff8135a10b>] sbitmap_any_bit_set+0xb/0x30
> ...
> [44492.815634] Call Trace:
> [44492.815652]  [<ffffffff81303a88>] blk_mq_run_hw_queues+0x48/0x90
> [44492.819755]  [<ffffffff813053cc>] blk_mq_requeue_work+0x10c/0x120
> [44492.819777]  [<ffffffff81098cb4>] process_one_work+0x154/0x410
> [44492.819781]  [<ffffffff81099896>] worker_thread+0x116/0x4a0
> [44492.819784]  [<ffffffff8109edb9>] kthread+0xc9/0xe0
> [44492.819790]  [<ffffffff81619b05>] ret_from_fork+0x55/0x80
> [44492.822798] DWARF2 unwinder stuck at ret_from_fork+0x55/0x80
> [44492.822798]
> [44492.822799] Leftover inexact backtrace:
>
> [44492.822802]  [<ffffffff8109ecf0>] ? kthread_park+0x50/0x50
> [44492.822818] Code: c6 44 0f 46 ce 83 c2 01 45 89 ca 4c 89 54 01 08 48
> 8b 4f
> 10 2b 74 01 08 39 57 08 77 d8 f3 c3 90 8b 4f 08 85 c9 74 1f 48 8b 57 10
> <48> 83
> 3a 00 75 18 31 c0 eb 0a 48 83 c2 40 48 83 3a 00 75 0a 83
> [44492.822820] RIP  [<ffffffff8135a10b>] sbitmap_any_bit_set+0xb/0x30
> [44492.822821]  RSP <ffff8807219ffdd8>
> [44492.822821] CR2: 0000000000000000
>
> It appears the queue has been freed thus the bitmap is bad.
>
> Looking at the commit relative to this email thread:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/scsi_lib.c?id=8dc765d438f1e42b3e8227b3b09fad7d73f4ec9a
>
> It's interesting that the queue reference taken was released after the
> kblockd_schedule_work() call was made, and it's this work element that
> is hitting the issue. So perhaps the patch missed keeping the reference
> until the requeue_work item finished ?

Hi James,

Please test the following patchset:

https://lore.kernel.org/linux-block/20190331030954.22320-1-ming.lei@redhat.com/T/#u


Thanks.
Ming Lei
