From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 19 Jan 2017 10:13:08 +0100
Message-ID: <20170119091308.GL5054@linux-x5ow.site>
References: <53a3fb6c-c75a-519a-f669-2bcab404e01d@grimberg.me>
 <20170117162752.GE6067@linux-x5ow.site>
 <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
 <20170118135156.GG3514@linux-x5ow.site>
 <e3438024-e0f2-db96-5122-4508863be603@grimberg.me>
 <20170118145816.GI3514@linux-x5ow.site>
 <c7eabe1c-5dcd-9859-2b41-9683f68a0534@grimberg.me>
 <20170118151643.GJ3514@linux-x5ow.site>
 <aaf5c35f-7e81-fa44-d467-53b574debdd4@suse.de>
 <97a3f3d3-3619-871d-55f3-75449b0c34cf@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97a3f3d3-3619-871d-55f3-75449b0c34cf@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 10:12:17AM +0200, Sagi Grimberg wrote:
> 
> >>>I think you missed:
> >>>http://git.infradead.org/nvme.git/commit/49c91e3e09dc3c9dd1718df85112a8cce3ab7007
> >>
> >>I indeed did, thanks.
> >>
> >But it doesn't help.
> >
> >We're still having to wait for the first interrupt, and if we're really
> >fast that's the only completion we have to process.
> >
> >Try this:
> >
> >
> >diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> >index b4b32e6..e2dd9e2 100644
> >--- a/drivers/nvme/host/pci.c
> >+++ b/drivers/nvme/host/pci.c
> >@@ -623,6 +623,8 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
> >        }
> >        __nvme_submit_cmd(nvmeq, &cmnd);
> >        spin_unlock(&nvmeq->sq_lock);
> >+       disable_irq_nosync(nvmeq_irq(irq));
> >+       irq_poll_sched(&nvmeq->iop);
> 
> a. This would trigger a condition that we disable irq twice which
> is wrong at least because it will generate a warning.
> 
> b. This would cause a way-too-much triggers of ksoftirqd. In order for
> it to be effective we need to to run only when it should and optimally
> when the completion queue has a batch of completions waiting.
> 
> After a deeper analysis, I agree with Bart that interrupt coalescing is
> needed for it to work. The problem with nvme coalescing as Jens said, is
> a death penalty of 100us granularity. Hannes, Johannes, how does it look
> like with the devices you are testing with?

I haven't had a look at AHCI's Command Completion Coalescing yet but hopefully
I find the time today (+SSD testing!!!).

Don't know if Hannes did (but I _think_ no). The problem is we've already
maxed out our test HW w/o irq_poll and so the only changes we're seeing
currently is an increase of wasted CPU cycles. Not what we wanted to have.

> 
> Also, I think that adaptive moderation is needed in order for it to
> work well. I know that some networking drivers implemented adaptive
> moderation in SW before having HW support for it. It can be done by
> maintaining stats and having a periodic work that looks at it and
> changes the moderation parameters.
> 
> Does anyone think that this is something we should consider?

Yes we've been discussing this internally as well and it sounds good but thats
still all pure theory and nothing actually implemented and tested.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
