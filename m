From: Linas Vepstas <linas@austin.ibm.com>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH + SCSI recovery (IPR only)]
Date: Thu, 31 Mar 2005 14:14:09 -0600
Message-ID: <20050331201409.GH15596@austin.ibm.com>
References: <20050223002409.GA10909@austin.ibm.com> <20050223174356.GH13081@kroah.com> <1109207532.5384.32.camel@gaston> <20050224013137.GF2088@austin.ibm.com> <20050226063609.GC7036@colo.lackof.org> <20050321231028.GV498@austin.ibm.com> <4240581C.1000906@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:54988 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261750AbVCaUOU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 15:14:20 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j2VKEI4I545174
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 15:14:18 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2VKEBru160426
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 13:14:11 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j2VKEA9C015836
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 13:14:10 -0700
Content-Disposition: inline
In-Reply-To: <4240581C.1000906@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, matthew@wil.cx, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org

On Tue, Mar 22, 2005 at 11:38:36AM -0600, Brian King was heard to remark:
> Linas Vepstas wrote:
> > 
> > My current hardware will halt all i/o to/from the symbios controller
> > upon detection of a PCI error.  The recovery proceedure that I am
> > currently using is to call system firmware (aka 'bios') to raise
> > and then lower the #RST pci signal line for 1/4 second, then wait 2
> > seconds for the  PCI bus to settle, then restore the PCI config space
> > registers (BARs, interrupt line, etc) to what they used to be. Then,
> > I call sym_start_up() in an attempt to get the symbios card working
> > again.  And that's where I get stuck ... 
> > 
> > My assumption is that after the #RST, that the symbios card will sit
> > there, dumb and stupid, with no scripts running.  But sometimes I find 
> > that the card has done something to make the PCI error hardware trip
> > again.  Typically, this means that the card attempted to DMA to some
> > address that its not allowed to touch, or raised #SERR or possibly 
> > #PERR (I can't tell which). 
> 
> What config registers are you restoring? 

BAR's, grant, latency, interrupt, cacheline size. 

> Is it possible symbios does not
> like something in your config restore?

possibly...

> Another possiblity is that asserting PCI reset is not cleanly resetting
> the card. Does PCI reset force BIST to be run on these cards? You could
> try to manually run BIST on the card after the PCI reset to see if that

I didn't see bist in the code, but I wasn't looking for it either.  I
could try that.

> helps, or you could try power cycling the slot instead of using PCI reset.

yes I could :(  I'll try that next.  Problem is, not all slots are
power-cyclable, only the hotplug slots are.  I've discoverd that 
for example, the ethernet chips are soldered to the motherboard, and
can't be power-cycled (but fortunately, those don't give me trouble).


--linas
