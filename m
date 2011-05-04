From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
	ensure commands don't get lost.
Date: Wed, 4 May 2011 11:37:35 -0600
Message-ID: <20110504173735.GB22953@parisc-linux.org>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com> <10639.1304530101@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10639.1304530101@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: scameron@beardog.cce.hp.com, Tomas Henzl <thenzl@redhat.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 04, 2011 at 01:28:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 04 May 2011 07:52:12 CDT, scameron@beardog.cce.hp.com said:
> > On Wed, May 04, 2011 at 01:15:50PM +0200, Tomas Henzl wrote:
> > > On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
> > > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> > > >  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
> > > >  		c->Header.Tag.lower);
> > > >  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> > > > +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);
> 
> > I just put it there to make it clear that it ignoring the return of readl is 
> > done intentionally, not accidentally.  If this goes against some coding convention,
> > whatever, I'm not super attached to the (void), but I did put it there on purpose,
> > and would have done it in cciss as well, had I thought of it at the time.
> 
> This probably needs a comment like
> 	/* don't care - dummy read just to force write posting to chipset */
> or similar.  I'm assuming it's just functioning as a barrier-type flush of some sort?

It's a PCI write flush.  It's not clear to me why it's needed here,
though.  The write will eventually get to the device; why we need to
make the CPU wait around for it to actually get there doesn't make sense.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
