From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 10:06:18 +0800
Message-ID: <20171108020611.GA22219@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
 <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
 <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
 <1510076077.2656.24.camel@wdc.com>
 <20171108005338.GD20599@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751960AbdKHCGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 21:06:33 -0500
Content-Disposition: inline
In-Reply-To: <20171108005338.GD20599@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>

On Wed, Nov 08, 2017 at 08:53:38AM +0800, Ming Lei wrote:
> On Tue, Nov 07, 2017 at 05:34:38PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-11-07 at 09:29 -0700, Jens Axboe wrote:
> > > On 11/07/2017 09:20 AM, Bart Van Assche wrote:
> > > > On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
> > > > > If you can reproduce, please provide me at least the following log
> > > > > first:
> > > > > 
> > > > > 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
> > > > > 
> > > > > If any pending requests arn't completed, please provide the related
> > > > > info in dbgfs about where is the request.
> > > > 
> > > > Every time I ran the above or a similar command its output was empty. I
> > > > assume that's because the hang usually occurs in a phase where these debugfs
> > > > attributes either have not yet been created or have already disappeared.
> > > 
> > > Bart, do you still see a hang with the patch that fixes the tag leak when
> > > we fail to get a dispatch budget?
> > > 
> > > https://marc.info/?l=linux-block&m=151004881411480&w=2
> > > 
> > > I've run a lot of stability testing here, and I haven't run into any
> > > issues. This is with shared tags as well. So if you still see the failure
> > > case with the current tree AND the above patch, then I'll try and get
> > > a test case setup that hits it too so we can get to the bottom of this.
> > 
> > It took a little longer than expected but I just ran into the following
> > lockup with your for-next branch of this morning (commit e8fa44bb8af9) and
> > Ming's patch "blk-mq: put driver tag if dispatch budget can't be got"
> > applied on top of it:
> > 
> > [ 2575.324678] sysrq: SysRq : Show Blocked State
> > [ 2575.332336]   task                        PC stack   pid father
> > [ 2575.345239] systemd-udevd   D    0 47577    518 0x00000106
> > [ 2575.353821] Call Trace:
> > [ 2575.358805]  __schedule+0x28b/0x890
> > [ 2575.364906]  schedule+0x36/0x80
> > [ 2575.370436]  io_schedule+0x16/0x40
> > [ 2575.376287]  __lock_page+0xfc/0x140
> > [ 2575.382061]  ? page_cache_tree_insert+0xc0/0xc0
> > [ 2575.388943]  truncate_inode_pages_range+0x5e8/0x830
> > [ 2575.396083]  truncate_inode_pages+0x15/0x20
> > [ 2575.402398]  kill_bdev+0x2f/0x40
> > [ 2575.407538]  __blkdev_put+0x74/0x1f0
> > [ 2575.413010]  ? kmem_cache_free+0x197/0x1c0
> > [ 2575.418986]  blkdev_put+0x4c/0xd0
> > [ 2575.424040]  blkdev_close+0x34/0x70
> > [ 2575.429216]  __fput+0xe7/0x220
> > [ 2575.433863]  ____fput+0xe/0x10
> > [ 2575.438490]  task_work_run+0x76/0x90
> > [ 2575.443619]  do_exit+0x2e0/0xaf0
> > [ 2575.448311]  do_group_exit+0x43/0xb0
> > [ 2575.453386]  get_signal+0x299/0x5e0
> > [ 2575.458303]  do_signal+0x37/0x740
> > [ 2575.462976]  ? blkdev_read_iter+0x35/0x40
> > [ 2575.468425]  ? new_sync_read+0xde/0x130
> > [ 2575.473620]  ? vfs_read+0x115/0x130
> > [ 2575.478388]  exit_to_usermode_loop+0x80/0xd0
> > [ 2575.484002]  do_syscall_64+0xb3/0xc0
> > [ 2575.488813]  entry_SYSCALL64_slow_path+0x25/0x25
> > [ 2575.494759] RIP: 0033:0x7efd829cbd11
> > [ 2575.499506] RSP: 002b:00007ffff984f978 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> > [ 2575.508741] RAX: 0000000000022000 RBX: 000055f19f902ca0 RCX: 00007efd829cbd11
> > [ 2575.517455] RDX: 0000000000040000 RSI: 000055f19f902cc8 RDI: 0000000000000007
> > [ 2575.526163] RBP: 000055f19f7fb9d0 R08: 0000000000000000 R09: 000055f19f902ca0
> > [ 2575.534860] R10: 000055f19f902cb8 R11: 0000000000000246 R12: 0000000000000000
> > [ 2575.544250] R13: 0000000000040000 R14: 000055f19f7fba20 R15: 0000000000040000
> 
> Again please show us the output of 'tags' to see if there is pending
> requests not completed.
> 
> Please run this test on linus tree(V4.14-rc7) to see if the same issue
> can be reproduced.
> 
> Also if possible, please provide us the way for reproducing.

BTW, please apply the following patch before your further test:

	https://marc.info/?l=linux-block&m=150988386406050&w=2

Since you don't see busy tag in 'tags' and queue may have been frozen.
And the in-progress dispatch after queue DEAD might corrupt memory.

-- 
Ming
