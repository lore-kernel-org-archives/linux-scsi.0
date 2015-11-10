From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 11:43:31 -0800
Message-ID: <1447184611.2187.45.camel@HansenPartnership.com>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
	 <5349261.sTnZTFhKWB@wuerfel> <56421610.50005@codeaurora.org>
	 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
	 <1447180034.2187.20.camel@HansenPartnership.com>
	 <56424200.9080406@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <56424200.9080406@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-11-10 at 14:14 -0500, Sinan Kaya wrote:
> 
> On 11/10/2015 1:27 PM, James Bottomley wrote:
> > On Tue, 2015-11-10 at 12:19 -0500, Sinan Kaya wrote:
> >> On 11/10/2015 11:47 AM, Arnd Bergmann wrote:
> >>> On Tuesday 10 November 2015 11:06:40 Sinan Kaya wrote:
> >>>> On 11/10/2015 3:38 AM, Arnd Bergmann wrote:
> >>>>    From the email thread, it looks like this was introduced to support
> >>>> some legacy card that has 64 bit addressing limitations and is being
> >>>> carried around ("rotted") since then.
> >>>>
> >>>> I'm the second guy after the powerpc architecture complaining about the
> >>>> very same issue. Any red flags?
> >>>
> >>> What BenH was worried about here is that the driver sets different masks
> >>> for streaming and coherent mappings, which is indeed a worry that
> >>> could hit us on ARM as well, but I suppose we'll have to deal with
> >>> that in platform code.
> >>>
> >>> Setting both masks to 32-bit is something that a lot of drivers do,
> >>> and without IOMMU enabled, you'd hit the same bug on all of them.
> >>>
> >>
> >> Maybe, maybe not. This is the only card that I had problems with.
> >
> > Your characterisation of "some legacy card" isn't entirely correct.
> > Just to clarify how this happens, most I/O cards today are intelligent
> > offload engines which means they have some type of embedded CPU (it can
> > even be a specially designed asic).  This CPU is driven by firmware
> > which is mostly (but not always) in the machine language of the CPU.
> > DMA transfers are sometimes run by this CPU, but mostly handed off to a
> > separate offload engine.  When the board gets revised, it's often easier
> > to update the offload engine to 64 bits and keep the CPU at 32 (or even
> > 16) bits.  This means that all the internal addresses in the firmware
> > are 32 bit only.  As I read the comments in the original thread, it
> > looks like the mpt people tried to mitigate this by using segment
> > registers for external addresses firmware uses ... that's why they say
> > that they don't have to have all the addresses in DMA32 ... they just
> > need the upper 32 bits to be constant so they can correctly program the
> > segment register.  Unfortunately, we have no way to parametrise this to
> > the DMA allocation code.
> >
> > You'll find the same thing with Adaptec SPI cards.  Their route to 64
> > bits was via an initial 39 bit extension that had them layering the
> > additional 7 bits into the unused lower region of the page descriptors
> > for the firmware (keeping the actual pointers to DMA at 32 bits because
> > they're always parametrised as address, offset, length and the address
> > is always a 4k page).
> >
> > Eventually, everything will rev to 64 bits and this problem will go
> > away, but, as I suspect you know, it takes time for the embedded world
> > to get to where everyone else already is.
> >
> > As Arnd said, if you failed to allow for this in your platform, then
> > oops, just don't use the card.  I think this solution would be better
> > than trying to get the driver to work out which cards can support 64 bit
> > firmware descriptors and only failing on your platform for those that
> > can't.
> >
> > James
> >
> >
> 
> James,
> I was referring to this conversation here.
> 
> https://lkml.org/lkml/2015/2/20/31
> 
> "The aic79xx hardware problem was that the DMA engine could address the 
> whole of memory (it had two address modes, a 39 bit one and a 64 bit 
> one) but the script engine that runs the mailboxes only had a 32 bit 
> activation register (the activating write points at the physical address 
> of the script to begin executing)."
> 
> The fact that LSI SAS 92118i is working with 64 bit addresses suggests 
> me that this problem is already solved.  I have not hit any kind of 
> regressions with 93xx and 92xx families under load in a true 64 bit 
> environment. I am only mentioning this based on my testing exposure.

The Issue, as stated by LSI is

        Initially set the consistent DMA mask to 32 bit and then change
        it
        to 64 bit mask after allocating RDPQ pools by calling the
        function
        _base_change_consistent_dma_mask. This is to ensure that all the
        upper 32 bits of RDPQ entries's base address to be same.

If you set a 64 bit coherent mask before this point, you're benefiting
from being lucky that all the upper 32 bits of the allocations are the
same ... we can't code a driver to rely on luck.  Particularly not when
the failure mode looks like it would be silent and deadly.

> Another comment here from you.
> https://lkml.org/lkml/2015/4/2/28
> 
> "Well, it was originally a hack for altix, because they had no regions
> below 4GB and had to specifically manufacture them.  As you know, in
> Linux, if Intel doesn't need it, no-one cares and the implementation
> bitrots."
> 
> Maybe, it is time to fix the code for more recent (even decent) hardware?

What do you mean "fix the code"?  The code isn't broken, it's
parametrising issues with particular hardware.  There's no software work
around (except allocating memory with the correct characteristics).

James
