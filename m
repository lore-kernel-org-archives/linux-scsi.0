From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Fri, 15 Sep 2017 00:18:54 +0800
Message-ID: <20170914161848.GA16763@ming.t460p>
References: <20170911111021.25810-1-ming.lei@redhat.com>
 <20170911111021.25810-9-ming.lei@redhat.com>
 <1505145834.2802.17.camel@wdc.com>
 <20170912034057.GC31533@ming.t460p>
 <20170913164803.GB10407@ming.t460p>
 <1505323703.2654.3.camel@wdc.com>
 <20170913174759.GB24862@ming.t460p>
 <1505329670.2404.10.camel@wdc.com>
 <20170914011532.GA16105@ming.t460p>
 <1505396232.2898.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdINQTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Sep 2017 12:19:12 -0400
Content-Disposition: inline
In-Reply-To: <1505396232.2898.13.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "cavery@redhat.com" <cavery@redhat.com>

On Thu, Sep 14, 2017 at 01:37:14PM +0000, Bart Van Assche wrote:
> On Thu, 2017-09-14 at 09:15 +0800, Ming Lei wrote:
> > On Wed, Sep 13, 2017 at 07:07:53PM +0000, Bart Van Assche wrote:
> > > On Thu, 2017-09-14 at 01:48 +0800, Ming Lei wrote:
> > > > No, that patch only changes blk_insert_cloned_request() which is used
> > > > by dm-rq(mpath) only, nothing to do with the reported issue during
> > > > suspend and sending SCSI Domain validation.
> > > 
> > > There may be other ways to fix the SCSI domain validation code.
> > 
> > Again the issue isn't in domain validation, it is in quiesce,
> > so we need to fix quiesce, instead of working around transport_spi.
> > 
> > Also What is the other way? Why not this patchset?
> 
> Sorry if I had not made this clear enough but I don't like the approach of
> this patch series so please do not expect any "Reviewed-by" tags from me.
> As the discussion about v4 of this patch series made clear the interaction
> between blk_cleanup_queue() and the changes introduced by this patch series
> in blk_get_request() is subtle and hard to analyze. The blk-mq core is

No, it isn't subtle at all, as I explained, queue dying can be
set during allocating request in both legacy and blk-mq, and driver
is required to handle requests after queue becomes dying, this way
has been there for long time.

Is that really hard to analyze?

> already complicated. In my view patches that make the blk-mq core simpler
> are much more welcome than patches that make the blk-mq core more
> complicated.

Sorry, I can't agree this patchset is too complicated, this patchset just
touches quiesce interface. For other change such as holding queue usage
counter, it follows blk-mq's way, and we can reuse this way for
legacy too.

> 
> Since I expect that any fix for the interaction between blk-mq and power
> management will be integrated in kernel v4.15 at earliest there is no reason

Again, it isn't not related PM only, it is actually related with
SCSI quiesce.

> to rush. My proposal is to wait a few weeks and to see whether anyone comes
> up with a better solution.

I am open for any solution and happy to review them if someone posts
them out, but it should cover at least the two kind of reported issues.

However I won't wait for that, since people have been troubled with this
stuff much, like Oleksandr's case, the system is simple dead after
one susend. And the I/O hang in sending SCSI domain validation was
actually reported from a production system too.


-- 
Ming
