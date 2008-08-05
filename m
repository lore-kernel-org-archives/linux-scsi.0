From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Tue, 05 Aug 2008 15:22:20 +0300
Message-ID: <489845FC.4080104@panasas.com>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de> <1217877676.3318.32.camel@localhost.localdomain> <48975F5F.90906@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3925 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759512AbYHEMXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 08:23:08 -0400
In-Reply-To: <48975F5F.90906@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> James Bottomley wrote:
>> On Mon, 2008-08-04 at 20:08 +0200, Stefan Richter wrote:
>>> As a discussion reminded me today, I believe I should merge the
>>> following patch (could have done so much earlier in fact).  Or is there
>>> anything speaking against it?
>> The value 255 is chosen because it worked before.  What you need to do
>> is establish what the upper limit for firewire is (or indeed if it has
>> one).
> 
> The limit is 65535, following from SBP-2 clause 5.1.2, definition of 
> data_size.
> 
> [Side note:  The SBP-2 s/g list (a.k.a. page table) consists of 64bit 
> wide entries and needs to be contiguous in memory from the POV of the 
> FireWire PCI or PCIe controller, and the SBP-2 target reads the table 
> from the initiator's memory.  The (fw-)sbp2 driver builds this table as 
> a copy of the kernel's s/g list; but this was certainly already to the 
> reader clear from the context in the diff.]
> 

Does the above mean you need contiguous physical memory to hold the   
sbp2's sg table. If so then it should be allocated with alloc_coherent and
maybe total size up to a PAGE_SIZE.

>>> Meanwhile, SG_ALL has been redefined from 255 to SCSI_MAX_SG_SEGMENTS =
>>> 128 without me noticing it.  But since several popular architectures
>>> define ARCH_HAS_SG_CHAIN, we may want to go back to 255 in (fw-)sbp2.
>>> (Besides, we should also do some tests to figure out an actual optimum.
>>> And fw-sbp2.c's struct sbp2_command_orb should become variably sized.)
>> Don't bother with optmium ... that's block's job based on what it sees
>> from the completions.  All we need to know is maximum.
> 

>From my tests, the block layer will, very fast, send you chained commands.
if you set it to 255 you'll see two chained fragments. In iscsi we have
4096 and it is very good for performance. However since you are pre-allocating
the memory per can_queue commands, this can get big, and the memory overhead
can be an impact on performance.

> OK, with the small caveat that the current (fw-)sbp2 driver code is 
> somewhat simplistic WRT page table handling and geared towards rather 
> short page tables.  But this may be possible to enhance without too much 
> difficulty.
> 
>>> Does the most relevant user of large transfers with SBP-2 devices,
>>> sd-mod, use chained s/g lists?
>> pass, but firewire is a reasonably slow bus by modern standards, and you
> 
> A 3200 Mb/s spec exists :-) (though no silicon yet, to my knowledge).
> 

As you said above and since bitrate is increasing, a 255 is a good 
preallocated value, but perhaps it could also be a module parameter so
fast cards can have a bigger pre-allocated sg table. (per canQ command).
Also for embedded systems, they might want to lower this value.

>> have the protocol overhead for each ORB, so I'd guess there's a point at
>> which increasing the transaction size doesn't buy anything.
>>
>> James
> 

>From re-inspecting the code I can see that the struct sbp2_command_orb
might have problems with none DMA coherent ARCHs. I think for safety
and flexibility the sbp2_command_orb.page_table array should be
dynamically allocated at init time with even maybe alloc_coherent.

Do you need that I send you a sketch of what I mean?

Boaz
