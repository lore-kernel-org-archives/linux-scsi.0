From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Tue, 05 Aug 2008 17:01:41 +0200
Message-ID: <48986B55.80403@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de> <1217877676.3318.32.camel@localhost.localdomain> <48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53981 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYHEPCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 11:02:42 -0400
In-Reply-To: <489845FC.4080104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> Stefan Richter wrote:
>> James Bottomley wrote:
>>> On Mon, 2008-08-04 at 20:08 +0200, Stefan Richter wrote:
>>>> As a discussion reminded me today, I believe I should merge the
>>>> following patch (could have done so much earlier in fact).  Or is there
>>>> anything speaking against it?
>>> The value 255 is chosen because it worked before.  What you need to do
>>> is establish what the upper limit for firewire is (or indeed if it has
>>> one).
>> 
>> The limit is 65535, following from SBP-2 clause 5.1.2, definition of 
>> data_size.
>> 
>> [Side note:  The SBP-2 s/g list (a.k.a. page table) consists of 64bit 
>> wide entries and needs to be contiguous in memory from the POV of the 
>> FireWire PCI or PCIe controller, and the SBP-2 target reads the table 
>> from the initiator's memory.  The (fw-)sbp2 driver builds this table as 
>> a copy of the kernel's s/g list; but this was certainly already to the 
>> reader clear from the context in the diff.]
> 
> Does the above mean you need contiguous physical memory to hold the   
> sbp2's sg table. If so then it should be allocated with alloc_coherent and
> maybe total size up to a PAGE_SIZE.

It doesn't have to be cache-coherent but it indeed needs to be memory
which can be DMA-mapped in one piece.

(DMA direction is DMA_TO_DEVICE.  Lifetime of the mapping is from before
the ORB is committed until after we received completion status, or the
request timed out and its ORB was aborted.  fw-sbp2 implements exactly
this lifetime, while sbp2 keeps the DMA mapping around from before login
to the target until after logout.)


>>>> Meanwhile, SG_ALL has been redefined from 255 to SCSI_MAX_SG_SEGMENTS =
>>>> 128 without me noticing it.  But since several popular architectures
>>>> define ARCH_HAS_SG_CHAIN, we may want to go back to 255 in (fw-)sbp2.
>>>> (Besides, we should also do some tests to figure out an actual optimum.
>>>> And fw-sbp2.c's struct sbp2_command_orb should become variably sized.)
>>> Don't bother with optmium ... that's block's job based on what it sees
>>> from the completions.  All we need to know is maximum.
> 
> From my tests, the block layer will, very fast, send you chained commands.
> if you set it to 255 you'll see two chained fragments. In iscsi we have
> 4096 and it is very good for performance. However since you are pre-allocating
> the memory per can_queue commands, this can get big, and the memory overhead
> can be an impact on performance.

OK.  This gives me a better picture.


>> OK, with the small caveat that the current (fw-)sbp2 driver code is 
>> somewhat simplistic WRT page table handling and geared towards rather 
>> short page tables.  But this may be possible to enhance without too much 
>> difficulty.
>> 
>>>> Does the most relevant user of large transfers with SBP-2 devices,
>>>> sd-mod, use chained s/g lists?
>>> pass, but firewire is a reasonably slow bus by modern standards, and you
>> 
>> A 3200 Mb/s spec exists :-) (though no silicon yet, to my knowledge).
> 
> As you said above and since bitrate is increasing, a 255 is a good 
> preallocated value, but perhaps it could also be a module parameter so
> fast cards can have a bigger pre-allocated sg table. (per canQ command).
> Also for embedded systems, they might want to lower this value.

A preset according to connection speed could also be done by the driver
without user intervention.


>>> have the protocol overhead for each ORB, so I'd guess there's a point at
>>> which increasing the transaction size doesn't buy anything.
>>>
>>> James
>> 
> 
> From re-inspecting the code I can see that the struct sbp2_command_orb
> might have problems with none DMA coherent ARCHs.

Hmm.  This would be a bug.  But from what I see while scrolling through
fw-sbp2 and through sbp2, they both do it right.  Well, to be very
strict, sbp2 should dma_sync_single_for_cpu() at a slightly different
place than it does now.  I shall patch this.


> I think for safety
> and flexibility the sbp2_command_orb.page_table array should be
> dynamically allocated at init time

The older driver sbp2 uses a fixed-size pool of ORBs and s/g tables for
the whole time that it is logged in into a target.  The author of the
newer fw-sbp2 driver chose to keep ORB and s/g table only around for the
lifetime of a request, and I think it's a valid approach.

> with even maybe alloc_coherent.

alloc_coherent isn't necessary.  Even code simplicity wouldn't profit
too much IMO; we already have to DMA-map the data buffer for each
request anyway.
-- 
Stefan Richter
-=====-==--- =--- --=-=
http://arcgraph.de/sr/
