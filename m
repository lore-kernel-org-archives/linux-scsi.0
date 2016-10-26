From: Omar Sandoval <osandov@osandov.com>
Subject: Re: Device or HBA level QD throttling creates randomness in
 sequetial workload
Date: Wed, 26 Oct 2016 13:56:00 -0700
Message-ID: <20161026205600.GA16627@vader>
References: <2d656e9c9fbde7206e40a635c61a6084@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2d656e9c9fbde7206e40a635c61a6084@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2016 at 12:24:24AM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Omar Sandoval [mailto:osandov@osandov.com]
> > Sent: Monday, October 24, 2016 9:11 PM
> > To: Kashyap Desai
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> > block@vger.kernel.org; axboe@kernel.dk; Christoph Hellwig;
> > paolo.valente@linaro.org
> > Subject: Re: Device or HBA level QD throttling creates randomness in
> sequetial
> > workload
> >
> > On Mon, Oct 24, 2016 at 06:35:01PM +0530, Kashyap Desai wrote:
> > > >
> > > > On Fri, Oct 21, 2016 at 05:43:35PM +0530, Kashyap Desai wrote:
> > > > > Hi -
> > > > >
> > > > > I found below conversation and it is on the same line as I wanted
> > > > > some input from mailing list.
> > > > >
> > > > > http://marc.info/?l=linux-kernel&m=147569860526197&w=2
> > > > >
> > > > > I can do testing on any WIP item as Omar mentioned in above
> > > discussion.
> > > > > https://github.com/osandov/linux/tree/blk-mq-iosched
> > >
> > > I tried build kernel using this repo, but looks like it is not allowed
> > > to reboot due to some changes in <block> layer.
> >
> > Did you build the most up-to-date version of that branch? I've been
> force
> > pushing to it, so the commit id that you built would be useful.
> > What boot failure are you seeing?
> 
> Below  is latest commit on repo.
> commit b077a9a5149f17ccdaa86bc6346fa256e3c1feda
> Author: Omar Sandoval <osandov@fb.com>
> Date:   Tue Sep 20 11:20:03 2016 -0700
> 
>     [WIP] blk-mq: limit bio queue depth
> 
> I have latest repo from 4.9/scsi-next maintained by Martin which boots
> fine.  Only Delta is  " CONFIG_SBITMAP" is enabled in WIP blk-mq-iosched
> branch. I could not see any meaningful data on boot hang, so going to try
> one more time tomorrow.

The blk-mq-bio-queueing branch has the latest work there separated out.
Not sure that it'll help in this case.

> >
> > > >
> > > > Are you using blk-mq for this disk? If not, then the work there
> > > > won't
> > > affect you.
> > >
> > > YES. I am using blk-mq for my test. I also confirm if use_blk_mq is
> > > disable, Sequential work load issue is not seen and <cfq> scheduling
> > > works well.
> >
> > Ah, okay, perfect. Can you send the fio job file you're using? Hard to
> tell exactly
> > what's going on without the details. A sequential workload with just one
> > submitter is about as easy as it gets, so this _should_ be behaving
> nicely.
> 
> <FIO script>
> 
> ; setup numa policy for each thread
> ; 'numactl --show' to determine the maximum numa nodes
> [global]
> ioengine=libaio
> buffered=0
> rw=write
> bssplit=4K/100
> iodepth=256
> numjobs=1
> direct=1
> runtime=60s
> allow_mounted_write=0
> 
> [job1]
> filename=/dev/sdd
> ..
> [job24]
> filename=/dev/sdaa

Okay, so you have one high-iodepth job per disk, got it.

> When I tune /sys/module/scsi_mod/parameters/use_blk_mq = 1, below is a
> ioscheduler detail. (It is in blk-mq mode. )
> /sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host10/target10:2:13/10:
> 2:13:0/block/sdq/queue/scheduler:none
> 
> When I have set /sys/module/scsi_mod/parameters/use_blk_mq = 0,
> ioscheduler picked by SML is <cfq>.
> /sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/host10/target10:2:13/10:
> 2:13:0/block/sdq/queue/scheduler:noop deadline [cfq]
> 
> I see in blk-mq performance is very low for Sequential Write work load and
> I confirm that blk-mq convert Sequential work load into random stream due
> to  io-scheduler change in blk-mq vs legacy block layer.

Since this happens when the fio iodepth exceeds the per-device QD, my
best guess is that this is that requests are getting requeued and
scrambled when that happens. Do you have the blktrace lying around?

> > > > > Is there any workaround/alternative in latest upstream kernel, if
> > > > > user wants to see limited penalty  for Sequential Work load on HDD
> ?
> > > > >
> > > > > ` Kashyap
> > > > >
> >
> > P.S., your emails are being marked as spam by Gmail. Actually, Gmail
> seems to
> > mark just about everything I get from Broadcom as spam due to failed
> DMARC.
> >
> > --
> > Omar

-- 
Omar
