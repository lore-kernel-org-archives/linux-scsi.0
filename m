From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Tue, 19 Sep 2017 13:43:13 +0800
Message-ID: <20170919054308.GA2517@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
 <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750910AbdISFne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 01:43:34 -0400
Content-Disposition: inline
In-Reply-To: <1505747894.2685.6.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>

On Mon, Sep 18, 2017 at 03:18:16PM +0000, Bart Van Assche wrote:
> On Sun, 2017-09-17 at 20:40 +0800, Ming Lei wrote:
> > "if no request has completed before the delay has expired" can't be a
> > reason to rerun the queue, because the queue can still be busy.
> 
> That statement of you shows that there are important aspects of the SCSI
> core and dm-mpath driver that you don't understand.

Then can you tell me why blk-mq's SCHED_RESTART can't cover
the rerun when there are in-flight requests? What is the case
in which dm-rq can return BUSY and there aren't any in-flight
requests meantime?

Also you are the author of adding 'blk_mq_delay_run_hw_queue(
hctx, 100/*ms*/)' in dm-rq, you never explain in commit
6077c2d706097c0(dm rq: Avoid that request processing stalls
sporadically) what the root cause is for your request stall
and why this patch fixes your issue. Even you don't explain
why is the delay 100ms?

So it is a workaound, isn't it?

My concern is that it isn't good to add blk_mq_delay_run_hw_queue(hctx, 100/*ms*/)
in the hot path since it should been covered by SCHED_RESTART
if there are in-flight requests.

> 
> > I suggest to understand the root cause, instead of keeping this
> > ugly random delay because run hw queue after 100ms may be useless
> > in 99.99% times.
> 
> If you are still looking at removing the blk_mq_delay_run_hw_queue() calls
> then I think you are looking in the wrong direction. What kind of problem
> are you trying to solve? Is it perhaps that there can be a delay between

Actually the improvement on dm-rq IO schedule(the patch 2 ~ 5) doesn't
need this patch.


-- 
Ming
