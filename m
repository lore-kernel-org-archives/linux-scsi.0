From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 15:40:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211540.32554.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10449 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268019AbUIUTla (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 15:41:30 -0400
In-Reply-To: <20040921190625.GB11708@colo.lackof.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 3:06 pm, Grant Grundler wrote:
> The qla example Jeremy gave earlier wasn't clear on where the
> mmio write reordering was taking place.  Based on my understanding
> (and I've been wrong before) of ia64 .rel/.acq semantics the reordering
> didn't happen in the CPU coherency - ie writes are ordered WRT
> to each other out to the Mckinley bus. That really only leaves
> the chipset suspect - ie anything between Mckinley bus and PCI bus.

Yep, that's where the reordering occurs for us.

> Or hurt them.
> We haven't talked about the flip side of this workaround much.
>
> Normally, I expect the chipset is responsible for maintaining
> order of MMIO writes - though that sounds near impossible on
> a large fabric where the spinlock transactions may take a different
> path than the IO transactions.

I think it is.  I wouldn't be surprised if your hw guys told you the same 
thing for your large machines.

> But allowing out of order MMIO 
> write transactions is a big deal if we want high performance
> devices that can operate correctly by only consuming MMIO
> writes and doing DMA for everything else. Adding the MMIO
> reads to enforcing MMIO write ordering will set us all back
> a few years in terms of performance.

But *only* prior to releasing a lock.  Writes in program order will arrive in 
order, it's just that writes from some other CPU may beat them to the device.  
So you'll only have one read for every so many writes.  And if your chipset 
supports it, you don't have to do a full read out to the target bus, but just 
to the local chipset.

> This behavior (bug?) essentially means drivers that only do MMIO
> writes during normal operation (and MMIO reads during set up) will
> not operate correctly on Altix (or similar if they exist) boxes.

It's a pretty hard bug to hit, as Jeremy mentioned.  You'll only see it on 
large boxes.  The performance gain for us comes from not doing a full read 
from the device, but just making sure our local hub has sent the write to its 
destination hub, where ordering is guaranteed.  Of course, it's only a gain 
if one assumes that the necessary full reads are already in place.  If not, 
then the hardware is already imposing I/O space write penalties anyway, 
except for all writes.  I'd think that's worse than just flushing the ones 
you care about, and only when you need to.

Jesse
