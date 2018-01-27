From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sat, 27 Jan 2018 14:09:20 -0500
Message-ID: <20180127190920.GA24759@redhat.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbeA0TJ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jan 2018 14:09:26 -0500
Content-Disposition: inline
In-Reply-To: <20180124033109.GA15945@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Jan 23 2018 at 10:31pm -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Jan 23, 2018 at 04:57:34PM +0000, Bart Van Assche wrote:
> > On Wed, 2018-01-24 at 00:37 +0800, Ming Lei wrote:
> > > On Tue, Jan 23, 2018 at 04:24:20PM +0000, Bart Van Assche wrote:
> > > > My opinion about this patch is as follows:
> > > > * Changing a blk_mq_delay_run_hw_queue() call followed by return
> > > >   BLK_STS_DEV_RESOURCE into return BLK_STS_RESOURCE is wrong because it changes
> > > >   a guaranteed queue rerun into a queue rerun that may or may not happen
> > > >   depending on whether or not multiple queue runs happen simultaneously.
> > > 
> > > You may not understand the two:
> > > 
> > > 1) it is always safe to return BLK_STS_RESOURCE, which will make sure to
> > > avoid IO hang by blk_mq_delay_run_hw_queue() or blk_mq_run_hw_queue(),
> > > and using which one depends on SCHED_RESTART.
> > > 
> > > 2) if driver can make sure the queue will be rerun after some resource
> > > is available, either by itself or by blk-mq, it will return BLK_STS_DEV_RESOURCE
> > > 
> > > So what is wrong with this way?
> > 
> > Sorry, I swapped BLK_STS_DEV_RESOURCE and BLK_STS_RESOURCE accidentally in my
> > reply. What I meant is that changing a blk_mq_delay_run_hw_queue() call followed
> > by return BLK_STS_RESOURCE into BLK_STS_DEV_RESOURCE is wrong and introduces a
> > race condition in code where there was no race condition.
> 
> OK, then no such race you worried about in this patch.
> 
> Jens, could you take a look at this patch?

Hi Jens,

Ming let me know that he successfully tested this V3 patch using both
your test (fio to both mpath and underlying path) and Bart's (02-mq with
can_queue in guest).

Would be great if you'd review and verify this fix works for you too.

Ideally we'd get a fix for this regression staged for 4.16 inclusion.
This V3 patch seems like the best option we have at this point.

Mike
