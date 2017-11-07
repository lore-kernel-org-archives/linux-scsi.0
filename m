From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 10:11:26 +0800
Message-ID: <20171107021125.GB15090@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509997522.2409.58.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2017 at 07:45:23PM +0000, Bart Van Assche wrote:
> On Sat, 2017-11-04 at 08:19 -0600, Jens Axboe wrote:
> > On 11/03/2017 07:55 PM, Ming Lei wrote:
> > > It is very expensive to atomic_inc/atomic_dec the host wide counter of
> > > host->busy_count, and it should have been avoided via blk-mq's mechanism
> > > of getting driver tag, which uses the more efficient way of sbitmap queue.
> > > 
> > > Also we don't check atomic_read(&sdev->device_busy) in scsi_mq_get_budget()
> > > and don't run queue if the counter becomes zero, so IO hang may be caused
> > > if all requests are completed just before the current SCSI device
> > > is added to shost->starved_list.
> > 
> > This looks like an improvement. I have added it for 4.15.
> > 
> > Bart, does this fix your hang?
> 
> No, it doesn't. After I had reduced starget->can_queue in the SRP initiator I
> ran into the following hang while running the srp-test software:
> 
> sysrq: SysRq : Show Blocked State
>   task                        PC stack   pid father
> systemd-udevd   D    0 19882    467 0x80000106
> Call Trace:
>  __schedule+0x2fa/0xbb0
>  schedule+0x36/0x90
>  io_schedule+0x16/0x40
>  __lock_page+0x10a/0x140
>  truncate_inode_pages_range+0x4ff/0x800
>  truncate_inode_pages+0x15/0x20
>  kill_bdev+0x35/0x40
>  __blkdev_put+0x6d/0x1f0
>  blkdev_put+0x4e/0x130
>  blkdev_close+0x25/0x30
>  __fput+0xed/0x1f0
>  ____fput+0xe/0x10
>  task_work_run+0x8b/0xc0
>  do_exit+0x38d/0xc70
>  do_group_exit+0x50/0xd0
>  get_signal+0x2ad/0x8c0
>  do_signal+0x28/0x680
>  exit_to_usermode_loop+0x5a/0xa0
>  do_syscall_64+0x12e/0x170
>  entry_SYSCALL64_slow_path+0x25/0x25

I can't reproduce your issue on IB/SRP any more against V4.14-RC4 with
the following patches, and without any hang after running your 6
srp-test:

88022d7201e9 blk-mq: don't handle failure in .get_budget
826a70a08b12 SCSI: don't get target/host busy_count in scsi_mq_get_budget()
1f460b63d4b3 blk-mq: don't restart queue when .get_budget returns BLK_STS_RESOURCE
358a3a6bccb7 blk-mq: don't handle TAG_SHARED in restart
0df21c86bdbf scsi: implement .get_budget and .put_budget for blk-mq
aeec77629a4a scsi: allow passing in null rq to scsi_prep_state_check()
b347689ffbca blk-mq-sched: improve dispatching from sw queue
de1482974080 blk-mq: introduce .get_budget and .put_budget in blk_mq_ops
63ba8e31c3ac block: kyber: check if there are requests in ctx in kyber_has_work()
7930d0a00ff5 sbitmap: introduce __sbitmap_for_each_set()
caf8eb0d604a blk-mq-sched: move actual dispatching into one helper
5e3d02bbafad blk-mq-sched: dispatch from scheduler IFF progress is made in ->dispatch


If you can reproduce, please provide me at least the following log
first:

	find /sys/kernel/debug/block -name tags | xargs cat | grep busy

If any pending requests arn't completed, please provide the related
info in dbgfs about where is the request.

-- 
Ming
