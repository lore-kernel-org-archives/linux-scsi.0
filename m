From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 09:20:30 -0600
Message-ID: <1226071230.8030.9.camel@localhost.localdomain>
References: <4913028B.6010405@redhat.com>
	 <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk>  <49143142.4010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57397 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbYKGPUi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:20:38 -0500
In-Reply-To: <49143142.4010809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

On Fri, 2008-11-07 at 07:14 -0500, Ric Wheeler wrote:
> Jens Axboe wrote:
> > On Thu, Nov 06 2008, David Woodhouse wrote:
> >   
> >> On Thu, 6 Nov 2008, James Bottomley wrote:
> >>     
> >>> The way to do this properly would be to run a chequerboard of partials,
> >>> but this would effectively have trim region tracking done in the block
> >>> layer ... is this worth it?
> >>>
> >>> By the way, the latest (from 2 days ago) version of the Thin
> >>> Provisioning proposal is here:
> >>>
> >>> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
> >>>
> >>> I skimmed it but don't see any update implying that trim might be
> >>> ineffective if we align wrongly ... where is this?
> >>>       
> >> I think we should be content to declare such devices 'broken'.
> >>
> >> They have to keep track of individual sectors _anyway_, and dropping 
> >> information for small discard requests is just careless.
> >>     
> >
> > I agree, seems pretty pointless. Lets let evolution take care of this
> > issue. I have to say I'm surprised that it really IS an issue to begin
> > with, are array firmwares really that silly?
> >
> > It's not that it would be hard to support (and it would eliminate the
> > need to do discard merging in the block layer), but it seems like one of
> > those things that will be of little use in even in the near future.
> > Discard merging should be useful, I have no problem merging something
> > like that.
> >
> >   
> I think that discard merging would be helpful (especially for devices 
> with more reasonable sized unmap chunks).

One of the ways the unmap command is set up is with a disjoint
scatterlist, so we can send a large number of unmaps together.  Whether
they're merged or not really doesn't matter.

The probable way a discard system would work if we wanted to endure the
complexity would be to have the discard system in the underlying device
driver (or possibly just above it in block, but different devices like
SCSI or ATA have different discard characteristics).  It would just
accumulate block discard requests as ranges (and it would have to poke
holes in the ranges as it sees read/write requests) which it flushes
periodically.

The reason for doing it this way is that discards are "special" as long
as we don't discard a rewritten sector, the time at which they're sent
down is irrelevant to integrity and thus we can potentially accumulate
over vastly different timescales than the regular block merging.  If
we're really going to respect this discard block size, we could
accumulate the irrelevant discards the array would ignore anyway for
virtually infinite time.

Note, I'm not saying we *should* do this ... I think something like this
would be much better done in the device ... but if we *are* going to do
it, then at least lets get it right.

James


