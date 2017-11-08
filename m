From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 09:03:46 +0800
Message-ID: <20171108010345.GF20599@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
 <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
 <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
 <49b5c202-0303-85f7-102a-fcc013e7256e@kernel.dk>
 <292e3f7d-cfe3-840a-5a5e-d00e01239152@kernel.dk>
 <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 07, 2017 at 03:06:31PM -0700, Jens Axboe wrote:
> On 11/07/2017 10:36 AM, Jens Axboe wrote:
> > On 11/07/2017 10:10 AM, Jens Axboe wrote:
> >> On 11/07/2017 09:29 AM, Jens Axboe wrote:
> >>> On 11/07/2017 09:20 AM, Bart Van Assche wrote:
> >>>> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
> >>>>> If you can reproduce, please provide me at least the following log
> >>>>> first:
> >>>>>
> >>>>> 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
> >>>>>
> >>>>> If any pending requests arn't completed, please provide the related
> >>>>> info in dbgfs about where is the request.
> >>>>
> >>>> Every time I ran the above or a similar command its output was empty. I
> >>>> assume that's because the hang usually occurs in a phase where these debugfs
> >>>> attributes either have not yet been created or have already disappeared.
> >>>
> >>> Bart, do you still see a hang with the patch that fixes the tag leak when
> >>> we fail to get a dispatch budget?
> >>>
> >>> https://marc.info/?l=linux-block&m=151004881411480&w=2
> >>>
> >>> I've run a lot of stability testing here, and I haven't run into any
> >>> issues. This is with shared tags as well. So if you still see the failure
> >>> case with the current tree AND the above patch, then I'll try and get
> >>> a test case setup that hits it too so we can get to the bottom of this.
> >>
> >> Ming, I managed to reproduce the hang using null_blk. Note this is
> >> WITHOUT the patch mentioned above, running with that now.
> >>
> >> # modprobe null_blk queue_mode=2 nr_devices=4 shared_tags=1 submit_queues=1 hw_queue_depth=1
> >>
> >> and using this fio file:
> >>
> >> [global]
> >> bs=4k
> >> rw=randread
> >> norandommap
> >> direct=1
> >> ioengine=libaio
> >> iodepth=4
> >>
> >> [nullb0]
> >> filename=/dev/nullb0
> >> [nullb1]
> >> filename=/dev/nullb1
> >> [nullb2]
> >> filename=/dev/nullb2
> >> [nullb3]
> >> filename=/dev/nullb3
> >>
> >> it seemed to keep running, but it hung when exiting. The troublesome
> >> device was nullb1:
> >>
> >> [  492.513374] INFO: task fio:3263 blocked for more than 120 seconds.
> >> [  492.520782]       Not tainted 4.14.0-rc7+ #499
> >> [  492.526247] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> [  492.535904] fio             D13208  3263   3211 0x00000000
> >> [  492.542535] Call Trace:
> >> [  492.545764]  __schedule+0x279/0x720
> >> [  492.550151]  schedule+0x33/0x90
> >> [  492.554145]  io_schedule+0x16/0x40
> >> [  492.558435]  blk_mq_get_tag+0x148/0x250
> >> [  492.563211]  ? finish_wait+0x90/0x90
> >> [  492.567693]  blk_mq_get_request+0xf0/0x3e0
> >> [  492.572760]  blk_mq_make_request+0xe2/0x690
> >> [  492.577913]  generic_make_request+0xfc/0x2f0
> >> [  492.583177]  submit_bio+0x64/0x120
> >> [  492.587475]  ? set_page_dirty_lock+0x4b/0x60
> >> [  492.592736]  ? submit_bio+0x64/0x120
> >> [  492.597309]  ? bio_set_pages_dirty+0x55/0x60
> >> [  492.602570]  blkdev_direct_IO+0x388/0x3c0
> >> [  492.607546]  ? free_ioctx_users+0xe0/0xe0
> >> [  492.612511]  ? blk_mq_dispatch_rq_list+0x238/0x3a0
> >> [  492.618353]  ? _raw_spin_unlock+0xe/0x20
> >> [  492.623227]  generic_file_read_iter+0xb3/0xa00
> >> [  492.628682]  ? generic_file_read_iter+0xb3/0xa00
> >> [  492.634334]  ? security_file_permission+0x9b/0xc0
> >> [  492.640114]  blkdev_read_iter+0x35/0x40
> >> [  492.644877]  aio_read+0xc5/0x120
> >> [  492.648973]  ? aio_read_events+0x24c/0x340
> >> [  492.654124]  ? __might_sleep+0x4a/0x80
> >> [  492.658800]  do_io_submit+0x47c/0x5e0
> >> [  492.663373]  ? do_io_submit+0x47c/0x5e0
> >> [  492.668234]  SyS_io_submit+0x10/0x20
> >> [  492.672715]  ? SyS_io_submit+0x10/0x20
> >> [  492.677394]  entry_SYSCALL_64_fastpath+0x13/0x94
> >> [  492.683039] RIP: 0033:0x7f83d1871717
> >> [  492.687521] RSP: 002b:00007ffd38fe5a88 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
> >> [  492.696969] RAX: ffffffffffffffda RBX: 00007f83b6972b50 RCX: 00007f83d1871717
> >> [  492.705423] RDX: 0000000001f41418 RSI: 0000000000000001 RDI: 00007f83e4d36000
> >> [  492.713889] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000001f3f2e0
> >> [  492.722352] R10: 0000000000001000 R11: 0000000000000202 R12: 00007ffd38fe5be0
> >> [  492.730827] R13: 00007f83b6972b01 R14: 00007f83b69824b8 R15: 00007f83b6982368
> >>
> >> and if we look at the debug entries, it's waiting on a scheduler tag:
> >>
> >> sched_tags:nr_tags=2
> >> sched_tags:nr_reserved_tags=0
> >> sched_tags:active_queues=0
> >> sched_tags:bitmap_tags:
> >> sched_tags:depth=2
> >> sched_tags:busy=2
> >> sched_tags:bits_per_word=64
> >> sched_tags:map_nr=1
> >> sched_tags:alloc_hint={0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0}
> >> sched_tags:wake_batch=1
> >> sched_tags:wake_index=4
> >> sched_tags:ws={
> >> sched_tags:	{.wait_cnt=-102, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-126, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-72, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-96, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-134, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-116, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-90, .wait=inactive},
> >> sched_tags:	{.wait_cnt=-115, .wait=active},
> >> sched_tags:}
> >> sched_tags:round_robin=0
> >> sched_tags_bitmap:00000000: 03
> >>
> >> with SCHED_RESTART being set:
> >>
> >> state:SCHED_RESTART
> >>
> >> and with the driver tags being idle:
> >>
> >> tags:nr_tags=1
> >> tags:nr_reserved_tags=0
> >> tags:active_queues=0
> >> tags:bitmap_tags:
> >> tags:depth=1
> >> tags:busy=0
> >> tags:bits_per_word=64
> >> tags:map_nr=1
> >> tags:alloc_hint={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
> >> tags:wake_batch=1
> >> tags:wake_index=3
> >> tags:ws={
> >> tags:	{.wait_cnt=-48, .wait=inactive},
> >> tags:	{.wait_cnt=-39, .wait=inactive},
> >> tags:	{.wait_cnt=-50, .wait=inactive},
> >> tags:	{.wait_cnt=-47, .wait=inactive},
> >> tags:	{.wait_cnt=-25, .wait=inactive},
> >> tags:	{.wait_cnt=-24, .wait=inactive},
> >> tags:	{.wait_cnt=-47, .wait=inactive},
> >> tags:	{.wait_cnt=-47, .wait=inactive},
> >> tags:}
> > 
> > Unsurprisingly (since this is sched_tags starvation) this still happens
> > with the patch. Same trace as above. Note that dispatch has two requests
> > sitting ready:
> > 
> > ffff881ff5ab1000 {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, .atomic_flags=COMPLETE, .tag=-1, .internal_tag=0}
> > ffff881ff5ab1240 {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, .atomic_flags=COMPLETE, .tag=-1, .internal_tag=1}
> > 
> > while we're blocked trying to get a new sched tag off the regular
> > blk_mq_make_request() path. It looks like a missing restart of the hctx.
> 
> Just to keep everyone in the loop, this bug is not new to
> for-4.15/block, nor is it new to the current 4.41-rc or 4.13. So it's
> probably different to what Bart is hitting, but it's a bug none the
> less...

Thanks for running this test ans share us the result.

> 
> To me, this looks like a race between marking the queue as needing a
> restart, and the driver tag being released and re-running the queue. If
> I do:
> 
> # echo run > /sys/kernel/debug/block/nullb1/state
> 
> then it starts just fine. So there must be a race between marking the
> need for a restart (when getting the driver tag fails), and when one of
> the shared tag queues finishes a request and releases the driver tag.

Just one hint, blk-mq's RESTART won't work if no requests are pending,
but looks no efficient/reliable way to handle that.

-- 
Ming
