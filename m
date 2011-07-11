From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only register
Date: Mon, 11 Jul 2011 14:04:50 -0700
Message-ID: <20110711140450.a6f3e8be.akpm@linux-foundation.org>
References: <20110708195926.3623.30375.stgit@beardog.cce.hp.com>
	<20110711131911.31789ee0.akpm@linux-foundation.org>
	<20110711205124.GB25366@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110711205124.GB25366@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Jul 2011 15:51:24 -0500
scameron@beardog.cce.hp.com wrote:

> On Mon, Jul 11, 2011 at 01:19:11PM -0700, Andrew Morton wrote:
> > On Fri, 08 Jul 2011 14:59:26 -0500
> > "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> > 
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > 
> > > Most smartarrays tolerate it, but a few new ones don't.
> > > 
> > > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > ---
> > >  drivers/scsi/hpsa.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> > > index 6d8dcd4..7f53cea 100644
> > > --- a/drivers/scsi/hpsa.h
> > > +++ b/drivers/scsi/hpsa.h
> > > @@ -214,7 +214,7 @@ static void SA5_submit_command(struct ctlr_info *h,
> > >  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
> > >  		c->Header.Tag.lower);
> > >  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> > > -	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> > > +	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
> > >  	h->commands_outstanding++;
> > >  	if (h->commands_outstanding > h->max_outstanding)
> > >  		h->max_outstanding = h->commands_outstanding;
> > 
> > The changelog forgot to tell us the user-visible effects of the bug. 
> > That was really really bad of it.  Bad changelog.  No bone for you.
> 
> Oh, sorry.  When the controller doesn't tolerate the bug, the firmware
> on it locks up.  No interrupts are received, no commands complete. I/o
> on that controller grinds to a halt.

OK, that was important.

Presumably you'd like those newer controllers to work with older
kernels?  In which case we should mark the patch for -stable
backporting?

I've done that to my copy and have updated the changelog.

> I can resubmit if you like.

I have two other needed-in-3.0 scsi patches.  I'll send all three
Jameswards now.
