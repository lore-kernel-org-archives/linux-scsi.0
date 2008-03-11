From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [0/20] Remove isa_unchecked_dma and some more GFP_DMAs
 in the mid layer v3
Date: Tue, 11 Mar 2008 19:55:16 +0200
Message-ID: <47D6C784.50408@panasas.com>
References: <20080307653.720459648@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:46081 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYCKRzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 13:55:37 -0400
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, Jeff Garzik <jeff@garzik.org>

On Fri, Mar 07 2008 at 19:53 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> v2: various cleanups, use dma_alloc_coherent instead of naked GFP_DMA
>     add blk_* allocators to avoid bouncing in SCSI scan
> v3: Remove cmnd/sense buffer bouncing in advansys. 
>     Replace sense_buffer_mask with a single bit
> 
> Original description:
> 
> This patchkit fixes all existing drivers that used isa_unchecked_dma
> to not need that anymore.  I have some upcoming infrastructure changes 
> for DMA memory management and isa_unchecked_dma was in the way.
> 
> Enabling isa_unchecked_dma had several effects:
> - All incoming scsi_cmnds were in GFP_DMA memory.
> Only one driver relied on that actually (advansys), the others all accessed
> the scsi_cmnds only with the CPU.
> - scsi hostdata is allocated with GFP_DMA
> A lot of drivers relied on that. I converted them all to allocate hostdata
> in a separate buffer linked to rom the scsi host structure.
> - Enabling block layer bouncing for all data. That's the most important one.
> I changed all drivers to do that directly instead of relying on the mid
> layer for it.
> - sense_buffer is allocated with GFP_DMA. That was also commonly
> required and not easy to fix so I created a separate host template
> field that enables sense_buffer bouncing.
> 
> Also while I was it I removed also a lot of GFP_DMAs in the frontend
> drivers which are not needed anymore because the block layer does
> the bouncing for all data anyways. Or rather we ask the block layer
> now to bounce.
> 
> The main problem of the patchkit is that is that I wasn't able
> to test the drivers because I don't have any of the hardware. All
> changes (except perhaps advansys) were relatively simple and straight
> forward so I don't expect many problems though.
> 
> If anybody has any of these ISA SCSI adapters and would be willing to test
> them with these patches that would be appreciated.
> I suspect actually that some of the ISA drivers are actually already
> bitrotted independently of these changes. Hopefully they won't make
> anything worse though. 
> 
> Patches against 2.6.25rc4
> 
> These are a lot of patches. I can set up a git tree if that makes
> merging easier. Please let me now if I should do that.
> 
> -Andi

Andi hi.

First let me start by saying that your "remove of ISA cruft from
scsi land" patchset was like the smell of flowers on that first 
spring morning.

It perfectly fits with two parallel efforts I'm perusing.

- First is with regard to scsi_cmnd->cmnd cleanup:
  http://www.spinics.net/lists/linux-scsi/msg23676.html

  You have just done my job where I needed to audit all uses of 
  scsi_cmnd->cmnd with regard to the isa_unchecked_dma.
  (see: http://www.spinics.net/lists/linux-scsi/msg23747.html)

- Second, with my sense buffer effort:
  (http://www.spinics.net/lists/linux-scsi/msg23231.html)
  The second effort might help in also eliminating the use of the new 
  .sense_buffer_isa by streamlining the use of the sense_buffer to use 
  the same bounce buffer mechanism used for regular IO. Though farther 
  cleaning what you have already started.
  (I will have some questions regarding this later)

The "scan-and-change of all scsi LLDS that..." is a very unrewarding and sure to 
encounter-hidden-ghosts effort. As I should know freshly. Reviewing few of the
drivers in this patchset I've spotted some minor problems. Mainly two things
right now. For instance aha152x.c is a file used for both ISA and a PCMCIA
devices, your change unnecessarily restricts the PCMCIA device. That driver, as 
well as other drivers in the patchset, are currently allocated low by the 
isa_unchecked_dma, but from a closer inspection, none of the host_data is actually 
used for DMA and the allocation can stay embedded. I think it is worth it to do
that now in one go. One more thing is the EISA devices that are now pushed to
behave like ISA because they do not have a device, like gdth, For that particular
driver Jeff Garzik has a patch in Q that might help. I will try to rebase your
patch on top of his series.

I will put all your patches on a local git tree and try to stare at them deeper.
Do you have these (And all the dma patches sent to lkml) on a public git tree
somewhere? I would like to study and test them.

(The ftp url you specified in lkml returns an alphabetical order of patches and
I'm not sure which subdirectory has the latest set)

Thanks for doing this and the all effort looks commendable.

Boaz
