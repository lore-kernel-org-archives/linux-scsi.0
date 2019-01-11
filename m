From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: advansys: use struct_size() in kzalloc()
Date: Fri, 11 Jan 2019 09:23:26 -0800
Message-ID: <1547227406.2793.24.camel@linux.ibm.com>
References: <20190104212209.GA15250@embeddedor>
         <05420a5c-c268-b87d-9d75-f5d18a4b7f7a@suse.de>
         <1547224903.2793.10.camel@linux.ibm.com>
         <20190111165449.GG6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111165449.GG6310@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2019-01-11 at 08:54 -0800, Matthew Wilcox wrote:
> On Fri, Jan 11, 2019 at 08:41:43AM -0800, James Bottomley wrote:
> > On Fri, 2019-01-11 at 16:46 +0100, Hannes Reinecke wrote:
> > > > -		asc_sg_head = kzalloc(sizeof(asc_scsi_q-
> > > > >sg_head)
> > > > +
> > > > -			use_sg * sizeof(struct asc_sg_list),
> > > > GFP_ATOMIC);
> > > > +		asc_sg_head = kzalloc(struct_size(asc_sg_head,
> > > > sg_list, use_sg),
> > > > +				      GFP_ATOMIC);
> > > 
> > > If you want ...
> > 
> > Are we sure there's a benefit to this?  It's obvious that the
> > current
> > code is correct but no-one's likely to test the new code for quite
> > some
> > time, so changing the code introduces risk. What's the benefit of
> > making the change in legacy drivers?  Just because we have a new,
> > shiny
> > macro doesn't mean we have to force its use everywhere.
> > 
> > I would recommend we have a rational needs test: so run the
> > coccinelle
> > script over all the drivers to find out where this construct is
> > used,
> > but only update those that are actually buggy with the new macro.
> 
> It's hard to tell whether they're buggy.  The problem being defended
> against here is integer overflow.  So can 'use_sg' ever get large
> enough that sizeof(asc_scsi_q->sg_head) + use_sg * sizeof(struct
> asc_sg_list) is larger than 4 billion?  Probably not; I imagine
> there's some rational sane limit elsewhere that says "No more than
> 256 SG elements" or something.

OK so firstly describing why we're doing this would have been
enormously useful.

Secondly, as you say, even with the enhanced rationale I'm not sure it
provides any benefit:  he advansys is two drivers squashed together:
the asc_ and adv_ prefixes.  It looks like the adv_ variant does check
the number of sg elements against the max, but asc_ doesn't; it relies
on the host limit sg_tablesize.  In both cases the actual limit is
somewhere around 255, so if the user can control the value they can
definitely cause corruption long before we get to mathematical
overflow.

The limit should be enforced by blk_queue_max_segments() and I think
this is done in all cases (including SG_IO).

> But I don't know without checking.  Is there some device-specific
> ioctl where the user can specify 2^31 scatterlist entries and
> somebody forgot to check?  This macro is a defense-in-depth strategy,
> so using it as widely as possible makes more sense than arguing about
> whether there are already adequate safeguards in place.

OK, so this is a question worth asking (I believe the answer to be "no"
but I could be wrong) because if there is some way of getting the value
over the driver internal table max (which is fixed for quite a few
drivers) we can induce corruption which this macro won't defend against
and if we need to, we should probably defend in sg_map_dma().

James
