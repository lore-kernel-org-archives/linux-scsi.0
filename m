From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm + blk-mq soft lockup complaint
Date: Tue, 13 Jan 2015 11:20:52 -0500
Message-ID: <20150113162052.GA30837@redhat.com>
References: <54B3FFAE.4070609@kernel.dk>
 <alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
 <54B40E8A.6010005@kernel.dk>
 <alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
 <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
 <20150112191138.GC21518@redhat.com>
 <20150112202113.GA23234@redhat.com>
 <54B50F9D.2040000@sandisk.com>
 <20150113141746.GA30411@redhat.com>
 <54B52B73.7040807@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbbAMQVY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2015 11:21:24 -0500
Content-Disposition: inline
In-Reply-To: <54B52B73.7040807@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 13 2015 at  9:28am -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 01/13/15 15:18, Mike Snitzer wrote:
> > On Tue, Jan 13 2015 at  7:29am -0500,
> > Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >> However, I hit another issue while running I/O on top of a multipath
> >> device (on a kernel with lockdep and SLUB memory poisoning enabled):
> >>
> >> NMI watchdog: BUG: soft lockup - CPU#7 stuck for 23s! [kdmwork-253:0:3116]
> >> CPU: 7 PID: 3116 Comm: kdmwork-253:0 Tainted: G        W      3.19.0-rc4-debug+ #1
> >> Call Trace:
> >>  [<ffffffff8118e4be>] kmem_cache_alloc+0x28e/0x2c0
> >>  [<ffffffff81346aca>] alloc_iova_mem+0x1a/0x20
> >>  [<ffffffff81342c8e>] alloc_iova+0x2e/0x250
> >>  [<ffffffff81344b65>] intel_alloc_iova+0x95/0xd0
> >>  [<ffffffff81348a15>] intel_map_sg+0xc5/0x260
> >>  [<ffffffffa07e0661>] srp_queuecommand+0xa11/0xc30 [ib_srp]
> >>  [<ffffffffa001698e>] scsi_dispatch_cmd+0xde/0x5a0 [scsi_mod]
> >>  [<ffffffffa0017480>] scsi_queue_rq+0x630/0x700 [scsi_mod]
> >>  [<ffffffff8125683d>] __blk_mq_run_hw_queue+0x1dd/0x370
> >>  [<ffffffff81256aae>] blk_mq_alloc_request+0xde/0x150
> >>  [<ffffffff8124bade>] blk_get_request+0x2e/0xe0
> >>  [<ffffffffa07ebd0f>] __multipath_map.isra.15+0x1cf/0x210 [dm_multipath]
> >>  [<ffffffffa07ebd6a>] multipath_clone_and_map+0x1a/0x20 [dm_multipath]
> >>  [<ffffffffa044abb5>] map_tio_request+0x1d5/0x3a0 [dm_mod]
> >>  [<ffffffff81075d16>] kthread_worker_fn+0x86/0x1b0
> >>  [<ffffffff81075c0f>] kthread+0xef/0x110
> >>  [<ffffffff814db42c>] ret_from_fork+0x7c/0xb0
> > 
> > Unfortunate.  Is this still with a 16MB backing device or is it real
> > hardware?  Can you share the workload so that myself and/or Keith could
> > try to reproduce?
>  
> Hello Mike,
> 
> This is still with a 16MB RAM disk as backing device. The fio job I
> used to trigger this was as follows:
> 
> dev=/dev/sdc
> fio --bs=4K --ioengine=libaio --rw=randread --buffered=0 --numjobs=12   \
>     --iodepth=128 --iodepth_batch=64 --iodepth_batch_complete=64        \
>     --thread --norandommap --loops=$((2**31)) --runtime=60              \
>     --group_reporting --gtod_reduce=1 --name=$dev --filename=$dev       \
>     --invalidate=1

OK, I assume you specified the mpath device for the test that failed.

This test works fine on my 100MB scsi_debug device with 4 paths exported
over virtio-blk to a guest that assembles the mpath device.

Could be a hang that is unique to scsi-mq.

Any chance you'd be willing to provide a HOWTO for setting up your
SRP/iscsi configuration?

Are you carrying any related changes that are not upstream?  (I can hunt
down the email in this thread where you describe your kernel tree...)

I'll try to reproduce but this info could be useful to others that are
more scsi-mq inclined who might need to chase this too.
