From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix uses of dma_max_pfn() when converting to a limiting
 address
Date: Thu, 13 Feb 2014 10:07:01 -0800
Message-ID: <1392314821.2175.16.camel@dabdike.int.hansenpartnership.com>
References: <E1WDH7v-00038J-2k@rmk-PC.arm.linux.org.uk>
	 <1392310690.2175.13.camel@dabdike.int.hansenpartnership.com>
	 <20140213171117.GA30257@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20140213171117.GA30257@n2100.arm.linux.org.uk>
Sender: linux-mmc-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-02-13 at 17:11 +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 13, 2014 at 08:58:10AM -0800, James Bottomley wrote:
> > This doesn't really look like the right fix.  You replaced dev->dma_mask
> > with a calculation on dev_max_pfn().  Since dev->dma_mask is always u64
> > and dev_max_pfn is supposed to be returning the pfn of the dma_mask, it
> > should unconditionally be 64 bits as well.  Either that or it should
> > return dma_addr_t.
> 
> My reasoning is that PFNs in the system are always of type "unsigned long"
> and therefore a function returning a pfn should have that type.  If we
> overflow a PFN fitting in an unsigned long, we have lots of places which
> need fixing.

It's not intuitive to people who need the dma mask that they're supposed
to use dma_max_pfn() << PAGE_SHIFT but now they have to worry about the
casting and, if they don't get it right, nothing will warn or tell them.
what about a new macro, say dma_max_mask(dev) that just returns
(u64)dma_max_pfn() << PAGE_SHIFT?

James


