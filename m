From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in
 case of BLK_STS_RESOURCE
Date: Sun, 17 Sep 2017 20:40:01 +0800
Message-ID: <20170917124000.GB6289@ming.t460p>
References: <20170915164456.9803-1-ming.lei@redhat.com>
 <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdIQMkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Sep 2017 08:40:24 -0400
Content-Disposition: inline
In-Reply-To: <1505498249.3420.15.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@fb.com" <axboe@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>

On Fri, Sep 15, 2017 at 05:57:31PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-16 at 00:44 +0800, Ming Lei wrote:
> > If .queue_rq() returns BLK_STS_RESOURCE, blk-mq will rerun
> > the queue in the three situations:
> > 
> > 1) if BLK_MQ_S_SCHED_RESTART is set
> > - queue is rerun after one rq is completed, see blk_mq_sched_restart()
> > which is run from blk_mq_free_request()
> > 
> > 2) BLK_MQ_S_TAG_WAITING is set
> > - queue is rerun after one tag is freed
> > 
> > 3) otherwise
> > - queue is run immediately in blk_mq_dispatch_rq_list()
> > 
> > So calling blk_mq_delay_run_hw_queue() inside .queue_rq() doesn't make
> > sense because no matter it is called or not, the queue still will be
> > rerun soon in above three situations, and the busy req can be dispatched
> > again.
> 
> NAK
> 
> Block drivers call blk_mq_delay_run_hw_queue() if it is known that the queue
> has to be rerun later even if no request has completed before the delay has
> expired. This patch breaks at least the SCSI core and the dm-mpath drivers.

"if no request has completed before the delay has expired" can't be a
reason to rerun the queue, because the queue can still be busy.

The only reason is that there isn't any requests in-flight and
queue is still busy, but I'd rather understand what the exact
situation is, instead of using this kind of workaround. If no
such situation, we should remove that.

For SCSI, it might be reasonable to run the hw queue after
a random time when atomic_read(&sdev->device_busy) is zero,
that means the queue may be busy even when there isn't any
requests in-flight in this queue. Could you or someone share
what the case is? Then we can avoid to use this workaround.

For dm-mpath, it might be related with path, but I have to say
it is still a workaround.

I suggest to understand the root cause, instead of keeping this
ugly random delay because run hw queue after 100ms may be useless
in 99.99% times.

-- 
Ming
