From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 24 Jan 2018 10:31:05 +0800
Message-ID: <20180124023104.GB15056@ming.t460p>
References: <20180123005728.GB4411@ming.t460p>
 <54f0c19c-38aa-e788-f476-492e5a5734c9@wdc.com>
 <20180123162605.GD13277@ming.t460p>
 <4cdb2b42-0097-c64a-d9c0-b7a1727c80de@wdc.com>
 <20180123164109.GF13277@ming.t460p>
 <1516726030.3339.14.camel@wdc.com>
 <20180123164951.GG13277@ming.t460p>
 <1516726441.3339.16.camel@wdc.com>
 <20180123165914.GH13277@ming.t460p>
 <1516744896.3339.41.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbeAXCbb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jan 2018 21:31:31 -0500
Content-Disposition: inline
In-Reply-To: <1516744896.3339.41.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Jan 23, 2018 at 10:01:37PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 00:59 +0800, Ming Lei wrote:
> > How is that enough to fix the IO hang when driver returns STS_RESOURCE
> > and the queue is idle? If you want to follow previous dm-rq's way of
> > call blk_mq_delay_run_hw_queue() in .queue_rq(), the same trick need
> > to be applied to other drivers too, right?
> > 
> > Unfortunately most of STS_RESOURCE don't use this trick, but they need
> > to be handled.
> > 
> > The patch of 'blk-mq: introduce BLK_STS_DEV_RESOURCE' can fix all these
> > cases.
> 
> The goal of my proposal was to address the race between running the queue and
> adding requests back to the dispatch queue only. Regarding the I/O hangs that
> can occur if a block driver returns BLK_STS_RESOURCE: since all of these can
> be addressed by inserting blk_mq_delay_run_hw_queue() calls in the affected
> block drivers I prefer to modify the block drivers instead of making the
> blk-mq core even more complicated.

IMO, this change doesn't make blk-mq code more complicated, also it is
well documented, see the change in block layer:

 block/blk-core.c             |  1 +
 block/blk-mq.c               | 19 +++++++++++++++----
 include/linux/blk_types.h    | 18 ++++++++++++++++++

Also 21 lines of them are comment, so only 17 lines code change needed
in block layer.

If inserting blk_mq_delay_run_hw_queue() to driver, the change can be
a bit complicated, since call_rcu has to be used, you need to figure out
one way to provide callback and the parameter. Even you have to document
the change in each driver.

[ming@ming linux]$ git grep -n BLK_STS_RESOURCE drivers/ | wc -l
42

There are at least 42 uses of BLK_STS_RESOURCE in drivers, in theory
you should insert call_rcu(blk_mq_delay_run_hw_queue) in every BLK_STS_RESOURCE
of drivers.

I leave the decisions to Jens and drivers maintainers.

Thanks,
Ming
