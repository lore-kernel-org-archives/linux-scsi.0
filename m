From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 9 Aug 2013 18:46:32 +0200
Message-ID: <20130809164632.GC25306@dhcp-26-207.brq.redhat.com>
References: <1374527436.7397.1145.camel@haakon3.risingtidesystems.com>
 <20130725101641.GB31994@dhcp-26-207.brq.redhat.com>
 <1374790082.7397.1411.camel@haakon3.risingtidesystems.com>
 <20130726020928.GL29296@kernel.dk>
 <1374873276.7397.1512.camel@haakon3.risingtidesystems.com>
 <20130729114653.GB20951@mtj.dyndns.org>
 <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
 <5204FBA6.6040001@kernel.dk>
 <20130809150744.GB25306@dhcp-26-207.brq.redhat.com>
 <52051033.8050605@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52051033.8050605@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 09, 2013 at 09:52:19AM -0600, Jens Axboe wrote:
> On 08/09/2013 09:07 AM, Alexander Gordeev wrote:
> > diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> > index dcbc2a4..b131a48 100644
> > --- a/block/blk-mq-tag.c
> > +++ b/block/blk-mq-tag.c
> > @@ -468,10 +468,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags,
> >  	 * Rest of the tags start at the queue list
> >  	 */
> >  	tags->nr_free = 0;
> > -	while (nr_tags - tags->nr_reserved) {
> > +	while (nr_tags--) {
> >  		tags->freelist[tags->nr_free] = tags->nr_free +
> >  							tags->nr_reserved;
> > -		nr_tags--;
> >  		tags->nr_free++;
> >  	}
> 
> I misremembered, just checked the code. I think I used to have it like I
> described, but changed it since I thought it would be more logical to
> pass in full depth, and then what part of that is reserved. Looking at
> the current code, your patch looks correct as-is.

Ok, then a whole series "[PATCH 0/3] blk-mq: Avoid effects of a weird queue
depth" (I posted earlier in a separate thread) should make sense. Besides
the hunk above it limits the per-cpu cache size and sanity-checks total vs
reserved length. I can resubmit if you want.

> 
> -- 
> Jens Axboe
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
