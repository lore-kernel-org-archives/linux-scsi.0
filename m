From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Thu, 12 Dec 2002 10:20:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <261670000.1039713623@aslan.btc.adaptec.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1313340000.1039622906@aslan.scsiguy.com>
 <20021211162318.A24958@infradead.org> <20021212071636.GA4318@suse.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021212071636.GA4318@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> On Wed, Dec 11 2002, Christoph Hellwig wrote:
>> > I have no problem with interfaces changing for good reason, but, for
>> > example,
>> > a driver that alread sets unchecked_isa_dma to 0 and uses the PCI dma
>> > mask shouldn't have to set addition flags (with different names in
>> > different vendor's trees) to enable HIGHIO.  It's yet-another *stupid*
>> > interface change.
>> 
>> Maybe you could have complained about that more than one year ago when
>> the patch came up first?
> 
> And I still dont see a better way to do it. Remember that this is 2.4
> and we must be able to toggle the highmem io capability on a per-driver
> basis easily and default to off until a given piece of hardware (and
> driver) has been verified.

>From the perspective of a driver that already meets the requirements
for highio, it is simply frustrating that:

1) You have to set a flag when you've already told the system you
   dma capabilities.

2) That flag is not documented in hosts.h or in the Documentation directory.

3) No warning is given if you use pci_set_dma_mask without setting
highmem_io
   so that you know that your driver needs to be updated.

4) highio requires that all SCSI drivers support single length S/G lists,
   but since single buffers are still allowed by the interfaces, even
   compliant SCSI drivers cannot strip out this code.
 
> Saying the high io stuff could have been done with zero impact to
> drivers just shows that you have no idea what you are talking about
> here and are living in your Justin world again. Tons of drivers needed
> to be changed to be able to deal with highmem pages sanely.

I'm not doubting that "lots of drivers needed to be updated", but since you
had to touch these drivers anyway, you could have deprecated all of these
older stupid interfaces and effected a real cleanup without needing a
positive "highmem enabled" flag.  The subset of devices that used
pci_set_dma_mask() and were not compliant was probably small.  Fixing
them with your initial patch set would have made the proper use of the
PCI dma API the "marker" for a highmem enabled device. Instead, drivers
that already were compliant to the PCI dma spec silently started bouncing
pages again unless you knew about this poorly documented flag.  <ARGGGGHHHH>

--
Justin
