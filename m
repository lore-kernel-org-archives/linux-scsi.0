From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 6/8] block: allow to allocate req with REQF_PREEMPT
 when queue is frozen
Date: Sat, 2 Sep 2017 10:52:54 +0800
Message-ID: <20170902025253.GA20047@ming.t460p>
References: <20170901184958.19452-1-ming.lei@redhat.com>
 <20170901184958.19452-8-ming.lei@redhat.com>
 <1504296423.14386.62.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbdIBCxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Sep 2017 22:53:09 -0400
Content-Disposition: inline
In-Reply-To: <1504296423.14386.62.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

On Fri, Sep 01, 2017 at 08:07:04PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-02 at 02:49 +0800, Ming Lei wrote:
> > +	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_freezing(q))
> > +		blk_queue_enter_live(q);
> > +	else
> > +		ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
> 
> Why did you repost this patch series without trying to reach an agreement
> about the approach?
> 
> Anyway, because of the unsafe blk_queue_enter_live() call introduced by this
> patch, please add the following to the description of this patch whenever you
> repost it:
> 
> NAK-ed-by: Bart Van Assche <bart.vanassche@wdc.com>

Did you take a look at the patch 7 or cover letter? In that patch,
if preempt freezing is on-progressing, any other freeze can't be
started at all, so that is definitely safe to use blk_queue_enter_live()
here, isn't it?

-- 
Ming
