From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 4/9] blk-mq: only run hw queues for blk-mq
Date: Fri, 1 Sep 2017 20:33:40 +0800
Message-ID: <20170901123339.GA20709@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-5-ming.lei@redhat.com>
 <20170901081634.gliggrnp3wlrysrv@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170901081634.gliggrnp3wlrysrv@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Oleksandr Natalenko <oleksandr@natalenko.name>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 01, 2017 at 10:16:34AM +0200, Johannes Thumshirn wrote:
> Hi Ming,
> 
> On Fri, Sep 01, 2017 at 01:27:23AM +0800, Ming Lei wrote:
> > -		blk_mq_run_hw_queues(q, false);
> > +		if (q->mq_ops)
> > +			blk_mq_run_hw_queues(q, false);
> 
> What speaks against putting the if (q->mq_ops) directly into
> blk_mq_run_hw_queues() so we can't accidently call it from the sq path?
> 
> Just an idea, no hard preferences here.

Given it is the only case that blk_mq_run_hw_queues() is run on
!q->mq_ops now, I suggest to check q->mq_ops outside, otherwise
it can be a bit overkill.

-- 
Ming
