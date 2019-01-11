From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] scsi: advansys: use struct_size() in kzalloc()
Date: Fri, 11 Jan 2019 08:54:49 -0800
Message-ID: <20190111165449.GG6310@bombadil.infradead.org>
References: <20190104212209.GA15250@embeddedor>
 <05420a5c-c268-b87d-9d75-f5d18a4b7f7a@suse.de>
 <1547224903.2793.10.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547224903.2793.10.camel@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 11, 2019 at 08:41:43AM -0800, James Bottomley wrote:
> On Fri, 2019-01-11 at 16:46 +0100, Hannes Reinecke wrote:
> > > -		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head)
> > > +
> > > -			use_sg * sizeof(struct asc_sg_list),
> > > GFP_ATOMIC);
> > > +		asc_sg_head = kzalloc(struct_size(asc_sg_head,
> > > sg_list, use_sg),
> > > +				      GFP_ATOMIC);
> > If you want ...
> 
> Are we sure there's a benefit to this?  It's obvious that the current
> code is correct but no-one's likely to test the new code for quite some
> time, so changing the code introduces risk. What's the benefit of
> making the change in legacy drivers?  Just because we have a new, shiny
> macro doesn't mean we have to force its use everywhere.
> 
> I would recommend we have a rational needs test: so run the coccinelle
> script over all the drivers to find out where this construct is used,
> but only update those that are actually buggy with the new macro.

It's hard to tell whether they're buggy.  The problem being defended
against here is integer overflow.  So can 'use_sg' ever get large enough
that sizeof(asc_scsi_q->sg_head) + use_sg * sizeof(struct asc_sg_list)
is larger than 4 billion?  Probably not; I imagine there's some
rational sane limit elsewhere that says "No more than 256 SG elements"
or something.

But I don't know without checking.  Is there some device-specific ioctl
where the user can specify 2^31 scatterlist entries and somebody forgot
to check?  This macro is a defense-in-depth strategy, so using it as
widely as possible makes more sense than arguing about whether there
are already adequate safeguards in place.
