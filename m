From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: Symbios PCI error recovery [Was: Re: [PATCH/RFC] ppc64: EEH + SCSI recovery (IPR only)]
Date: Thu, 31 Mar 2005 23:15:08 -0700
Message-ID: <20050401061508.GC29734@colo.lackof.org>
References: <20050223002409.GA10909@austin.ibm.com> <20050223174356.GH13081@kroah.com> <1109207532.5384.32.camel@gaston> <20050224013137.GF2088@austin.ibm.com> <20050226063609.GC7036@colo.lackof.org> <20050321231028.GV498@austin.ibm.com> <4240581C.1000906@us.ibm.com> <20050331201409.GH15596@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:17335 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S261688AbVDAGNP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 01:13:15 -0500
Content-Disposition: inline
In-Reply-To: <20050331201409.GH15596@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Brian King <brking@us.ibm.com>, matthew@wil.cx, linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org

On Thu, Mar 31, 2005 at 02:14:09PM -0600, Linas Vepstas wrote:
> > What config registers are you restoring? 
> 
> BAR's, grant, latency, interrupt, cacheline size. 

"grant" is PCI_COMMAND?

If so, I think you have all of them.
You may want to leave BUS_MASTER disabled until you think
the driver is in a state where it needs to do DMA again.
E.g. before kicking off the scripts engine.

> > helps, or you could try power cycling the slot instead of using PCI reset.
> 
> yes I could :(  I'll try that next.  Problem is, not all slots are
> power-cyclable, only the hotplug slots are.  I've discoverd that 
> for example, the ethernet chips are soldered to the motherboard, and
> can't be power-cycled (but fortunately, those don't give me trouble).

They can if the NIC driver doesn't deal with programming the phy
properly. We had a problem with tg3 because of that in the past.
The phy doesn't get reset as part of the PCI Bus RESET.

grant
