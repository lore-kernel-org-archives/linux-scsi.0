From: Tejun Heo <htejun@gmail.com>
Subject: Re: Boot failure with block/for-next
Date: Fri, 24 Dec 2010 12:03:27 +0100
Message-ID: <20101224110327.GB8781@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
 <20101223100956.GA15625@htj.dyndns.org>
 <1293118041.3029.3.camel@mulgrave.site>
 <20101223155239.GB18482@htj.dyndns.org>
 <1293120614.7776.0.camel@mulgrave.site>
 <20101223161312.GC18482@htj.dyndns.org>
 <1293128717.7776.68.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1293128717.7776.68.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On Thu, Dec 23, 2010 at 12:25:17PM -0600, James Bottomley wrote:
> On Thu, 2010-12-23 at 17:13 +0100, Tejun Heo wrote:
> > On Thu, Dec 23, 2010 at 10:10:14AM -0600, James Bottomley wrote:
> > > > Can you please apply the debug patch I posted in the other message and
> > > > post the boot log?  Let's see how the partition read is failing.
> > > 
> > > That's actually a red herring ... the disk isn't spinning up, so the
> > > partition read is getting a not ready.
> > 
> > Oh, yay, but at any rate I think the don't-clear-media-presence patch
> > is probably a good idea just in case UA gets reported somehow.
> 
> Well, it wasn't this either.  It turns out that this disk alone reports
> UNIT_ATTENTION RESET_OCCURRED on the first TEST UNIT READY of spin up.
> Ordinarily this is harmless, but the new medium change code wrongly
> interprets any UNIT_ATTENTION as medium changed (and then refuses to
> talk to the disk).  This is actually a change from the previous code, so
> the fix is to put it back the way it was.

I see.  I wonder why the previous patch didn't work.  It should have
had about the same effect.  I think the UA change went in there while
trying to bring sr and sd behaviors closer to each other, but yes it
seems the original code didn't have that.  That said, now there are
paths where UA would be consumed without setting ->changed and thus sd
may miss media change events.  This has been like this for quite some
time and there aren't many removable sd devices these days, so maybe
this doesn't matter too much.

Anyways, for now, the change looks good to me too.  Thanks.

-- 
tejun
