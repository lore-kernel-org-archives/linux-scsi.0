From: Jens Axboe <axboe@suse.de>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Thu, 12 Dec 2002 18:38:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212173818.GA6481@suse.de>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1313340000.1039622906@aslan.scsiguy.com> <20021211162318.A24958@infradead.org> <20021212071636.GA4318@suse.de> <261670000.1039713623@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <261670000.1039713623@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Dec 12 2002, Justin T. Gibbs wrote:
> > On Wed, Dec 11 2002, Christoph Hellwig wrote:
> >> > I have no problem with interfaces changing for good reason, but, for
> >> > example,
> >> > a driver that alread sets unchecked_isa_dma to 0 and uses the PCI dma
> >> > mask shouldn't have to set addition flags (with different names in
> >> > different vendor's trees) to enable HIGHIO.  It's yet-another *stupid*
> >> > interface change.
> >> 
> >> Maybe you could have complained about that more than one year ago when
> >> the patch came up first?
> > 
> > And I still dont see a better way to do it. Remember that this is 2.4
> > and we must be able to toggle the highmem io capability on a per-driver
> > basis easily and default to off until a given piece of hardware (and
> > driver) has been verified.
> 
> >From the perspective of a driver that already meets the requirements
> for highio, it is simply frustrating that:
> 
> 1) You have to set a flag when you've already told the system you
>    dma capabilities.

All drivers blindly copy the setting of the dma mask, typically means
nothing.

> 2) That flag is not documented in hosts.h or in the Documentation directory.

That is true. Name of the member is a good clue, though.

> 3) No warning is given if you use pci_set_dma_mask without setting
> highmem_io so that you know that your driver needs to be updated.

Two different layers. One is the block layer entry, other deals with the
hardware.

> 4) highio requires that all SCSI drivers support single length S/G lists,
>    but since single buffers are still allowed by the interfaces, even
>    compliant SCSI drivers cannot strip out this code.

This is not a new requirement, it's just spelled out now. The special
casing of an sg request with one entry was silly, imho. And yes you do
have to support both single entry sg requests and non-sg requests. I
wouldn't mind getting rid of that, but this is the 2.4 series and
changes must be kept small(ish).

> > Saying the high io stuff could have been done with zero impact to
> > drivers just shows that you have no idea what you are talking about
> > here and are living in your Justin world again. Tons of drivers needed
> > to be changed to be able to deal with highmem pages sanely.
> 
> I'm not doubting that "lots of drivers needed to be updated", but since you
> had to touch these drivers anyway, you could have deprecated all of these
> older stupid interfaces and effected a real cleanup without needing a
> positive "highmem enabled" flag.  The subset of devices that used

If I had done that, there was no way we could have had this feature for
2.4. It is just too invasive.

> pci_set_dma_mask() and were not compliant was probably small.  Fixing
> them with your initial patch set would have made the proper use of the
> PCI dma API the "marker" for a highmem enabled device. Instead,

Again, way too much work. The concept of the highmem_io flag is simple.
If your driver complies with the pci dma api, set the flag and you are
now handed pages for io up to your pci dma mask. If you either don't
know about the flag or don't use the pci dma api, behaviour is
unchanged.

See this way I didn't need to touch _any_ drivers, and I didn't break
_any_ drivers. Drivers that are compliant just have to set the flag.

> drivers that already were compliant to the PCI dma spec silently
> started bouncing pages again unless you knew about this poorly
> documented flag.  <ARGGGGHHHH>

What are you talking about? If you didn't set the flag, behaviour is
*unchanged* from before. You always got highmem pages bounced.

As Christoph said, if you want to influence changes made to the kernel
it doesn't help to whine about them years after they were developed. If
you want to take the back seat to the linux kernel, fine, just dont come
complaining when you miss out on something. Your timing is just
excellent, too. You've even had months of 2.4.20-pre time (highmem stuff
was merged in 2.4.20-pre2, iirc), and the block-highmem patch had
existed in the public and in vendor kernels about a year before that.

-- 
Jens Axboe

