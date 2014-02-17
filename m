From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] Fix uses of dma_max_pfn() when converting to a
	limiting address
Date: Mon, 17 Feb 2014 12:43:42 +0000
Message-ID: <20140217124342.GP30257@n2100.arm.linux.org.uk>
References: <E1WDH7v-00038J-2k@rmk-PC.arm.linux.org.uk> <1392310690.2175.13.camel@dabdike.int.hansenpartnership.com> <20140213171117.GA30257@n2100.arm.linux.org.uk> <1392314821.2175.16.camel@dabdike.int.hansenpartnership.com> <20140213200112.GF30257@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140213200112.GF30257@n2100.arm.linux.org.uk>
Sender: linux-mmc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-mmc@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>, Chris Ball <chris@printf.net>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2014 at 08:01:12PM +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 13, 2014 at 10:07:01AM -0800, James Bottomley wrote:
> > On Thu, 2014-02-13 at 17:11 +0000, Russell King - ARM Linux wrote:
> > > On Thu, Feb 13, 2014 at 08:58:10AM -0800, James Bottomley wrote:
> > > > This doesn't really look like the right fix.  You replaced dev->dma_mask
> > > > with a calculation on dev_max_pfn().  Since dev->dma_mask is always u64
> > > > and dev_max_pfn is supposed to be returning the pfn of the dma_mask, it
> > > > should unconditionally be 64 bits as well.  Either that or it should
> > > > return dma_addr_t.
> > > 
> > > My reasoning is that PFNs in the system are always of type "unsigned long"
> > > and therefore a function returning a pfn should have that type.  If we
> > > overflow a PFN fitting in an unsigned long, we have lots of places which
> > > need fixing.
> > 
> > It's not intuitive to people who need the dma mask that they're supposed
> > to use dma_max_pfn() << PAGE_SHIFT but now they have to worry about the
> > casting and, if they don't get it right, nothing will warn or tell them.
> > what about a new macro, say dma_max_mask(dev) that just returns
> > (u64)dma_max_pfn() << PAGE_SHIFT?
> 
> This sounds like a good idea.
> 
> I've just been looking at places which do this << PAGE_SHIFT, and we
> have other places which suffer from this same bug all over the kernel,
> so maybe we actually need a pfn_to_addr() macro or similar so that
> people get this right in these other places too?  It appears to be
> quite a widespread problem.
> 
> I'm surprised none of the below haven't already caused a problem.
> 
> Thoughts?

Okay, as there's been no response to this, I'm going to push the patch
as-is to Linus this evening.

Nevertheless, your point is valid, but it is more of a general problem in
the kernel than with this specific change - and it's more important to fix
the existing problem here than to try and work out a new way of sorting
this out to fix the general case in the middle of the -rc series.

It is arguable that people _should_ know that shifting an unsigned long
left and assigning it to a u64 doesn't automatically get any of the high
bits set - the promotion happens at assignment, not while the expression
is being evaluated.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
