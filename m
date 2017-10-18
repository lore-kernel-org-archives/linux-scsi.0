From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/2] block/SCSI MQ: two RESTART related patches
Date: Wed, 18 Oct 2017 09:30:00 +0800
Message-ID: <20171018012954.GB3026@ming.t460p>
References: <20171017050418.22555-1-ming.lei@redhat.com>
 <20171017051209.GF15996@ming.t460p>
 <8e604f28-dd20-7818-a25b-985ab537bf70@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e604f28-dd20-7818-a25b-985ab537bf70@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 04:47:23PM +0100, John Garry wrote:
> On 17/10/2017 06:12, Ming Lei wrote:
> > On Tue, Oct 17, 2017 at 01:04:16PM +0800, Ming Lei wrote:
> > > Hi Jens,
> > > 
> > > The 1st patch runs idle hctx after dealy in scsi_mq_get_budget(),
> > > so that we can keep same behaviour with before, and it can be
> > > thought as a fix.
> > > 
> > > The 2nd patch cleans up RESTART, and removes handling for TAG_SHARED
> > > from current blk-mq's RESTART mechanism because SCSI_MQ can covers its
> > > restart by itself, so that no need to handle TAG_SHARED in blk-mq
> > > RESTART. And >20% IOPS boost is observed in my rand read test over
> > > scsi_debug.
> > > 
> > > John, please test this two patches and see if it may improve your SAS
> > > IO performance, and you can find the two patches in the following branch:
> > > 
> > > 	https://github.com/ming1/linux/commits/blk_mq_improve_restart_V1
> > 
> 
> Hi Ming,
> 
> As requested, here's my figures for blk_mq_improve_restart_V1:
> without default SCSI_MQ, deadline scheduler, CONFIG PREEMPT off
> read, rw, write IOPS	
> 989K, 113K/113K, 835K
> 
> with default SCSI_MQ, mq-deadline scheduler, CONFIG PREEMPT off
> read, rw, write IOPS	
> 738K, 130K/130K, 686K
> 
> For axboe for-next tip (21ed538):
> without default SCSI_MQ, deadline scheduler, CONFIG PREEMPT off
> read, rw, write IOPS	
> 977K, 117K/117K, 821K
> 
> with default SCSI_MQ, mq-deadline scheduler, CONFIG PREEMPT off
> read, rw, write IOPS	
> 733K, 128K/128K, 676K
> 
> All cases do not have LLDD mq exposed/enabled. So unfortunately not much
> difference with your branch.

That looks a bit strange, this patchset should cut half of
blk_mq_run_hw_queues() since SCSI-MQ does it by itself in
scsi_end_request().

So looks your issue is related with neither IO merge nor RESTART.
just wondering what the possible reason is?

But this patchset is still correct thing to do, even though your
issue can't be addressed.


Thanks,
Ming
