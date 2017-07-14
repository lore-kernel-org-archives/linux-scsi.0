From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.14 RFC PATCH 1/2] dm rq: avoid deadlock if dm-mq is
 stacked on old .request_fn device(s)
Date: Fri, 14 Jul 2017 17:15:39 -0400
Message-ID: <20170714211539.GB19238@redhat.com>
References: <20170713211217.52361-1-snitzer@redhat.com>
 <20170713211217.52361-2-snitzer@redhat.com>
 <20170714072250.GC17046@lst.de>
 <20170714141929.GB18245@redhat.com>
 <1500052673.10198.174.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500052673.10198.174.camel@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 14 2017 at  1:17pm -0400,
Ewan D. Milne <emilne@redhat.com> wrote:

> On Fri, 2017-07-14 at 10:19 -0400, Mike Snitzer wrote:
> > 
> > Do you see a benefit to extracting that portion of your WIP patch
> > (removing the ->complete handler entirely)?
> > 
> > Or leave well enough alone and just continue to disable dm-mq's ability
> > to stack on .request_fn paths?
> > 
> > Given SCSI's switch to scsi-mq by default I cannot see value in propping
> > up stacking on the old .request_fn devices.
> 
> So, the dm_mod.use_blk_mq flag is global, right?  I guess the question
> is whether all of the block device types used on a system under DM are
> supported under MQ.  If that is the case then we would be OK.

I didn't quite understand Ewan's question so we talked in person.  His
concern was whether other DM targets needed to be worried about blk-mq
vs not.  I clarified that DM multipath is the only target that is
request-based and that it is fine with stacking on scsi-mq.  And all the
bio-based targets obviously stack just fine on scsi-mq devices.

> The other question is whether there are negative performance
> consequences in any (corner?) cases with MQ that would result in it
> being preferable to run in non-MQ mode (e.g. tag space with lpfc, did
> we ever resolve that?) but the right approach there is to put the effort
> into the MQ path going forward, as has been the case.

Yeap.
