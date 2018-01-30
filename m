From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 11:31:19 +0800
Message-ID: <20180130033118.GF17176@ming.t460p>
References: <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
 <20180127234151.GA21710@ming.t460p>
 <1517244510.2687.10.camel@wdc.com>
 <20180130010701.GC17176@ming.t460p>
 <1517274681.2687.68.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517274681.2687.68.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 30, 2018 at 01:11:22AM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 09:07 +0800, Ming Lei wrote:
> > On Mon, Jan 29, 2018 at 04:48:31PM +0000, Bart Van Assche wrote:
> > > - It is easy to fix this race inside the block layer, namely by using
> > >   call_rcu() inside the blk_mq_delay_run_hw_queue() implementation to
> > >   postpone the queue rerunning until after the request has been added back to
> > >   the dispatch list.
> > 
> > It is just easy to say, can you cook a patch and fix all drivers first?
> 
> Please reread what I wrote. I proposed to change the blk_mq_delay_run_hw_queue()
> IMPLEMENTATION such that the callers do not have to be modified.

Please take a look at drivers, when BLK_STS_RESOURCE is returned, who
will call blk_mq_delay_run_hw_queue() for drivers?

> 
> > [ ... ] Later, you admitted you understood the patch wrong. [ ... ]
> 
> That's nonsense. I never wrote that.

Believe it or not, follows the link and your reply:

	https://marc.info/?l=dm-devel&m=151672694508389&w=2

> So what is wrong with this way?

>Sorry, I swapped BLK_STS_DEV_RESOURCE and BLK_STS_RESOURCE accidentally in my
>reply. What I meant is that changing a blk_mq_delay_run_hw_queue() call followed
>by return BLK_STS_RESOURCE into BLK_STS_DEV_RESOURCE is wrong and introduces a
>race condition in code where there was no race condition.
>
>Bart.


-- 
Ming
