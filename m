From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 16:44:03 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921224403.GA20053@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <200409211540.32554.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:3975 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S266703AbUIUWoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 18:44:12 -0400
Content-Disposition: inline
In-Reply-To: <200409211540.32554.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 03:40:32PM -0400, Jesse Barnes wrote:
> > Normally, I expect the chipset is responsible for maintaining
> > order of MMIO writes - though that sounds near impossible on
> > a large fabric where the spinlock transactions may take a different
> > path than the IO transactions.
> 
> I think it is.  I wouldn't be surprised if your hw guys told you the same 
> thing for your large machines.

I was told Superdome chipsets (SX1000) do NOT have this problem.
AFAIK, it only scales to 16 nodes (4 sockets/node) and the fabric
may not have the multiple paths SGI Altix (or other interconnects)
may have. (And I'd like the "other chipsets" better defined if anyone
knows of other chipsets).


I was also told likely *all* larger PCI-E systems will have this problem.
Ie any time the fabric allows multiple pathes to the same device.

And as usual, I was wrong. Someone educated me on HP V-class systems (PARISC)
having the same problem when running in NUMA config (4 node cluster).
Of course parisc-linux doesn't run on V-class...and HP didn't sell that
many V-class clusters...but here's the story anyway.

Despite strongly ordered CPU accesses, the chipset couldn't preserve
ordering across the NUMA links.  The NIC drivers exposed this problem
when writing descriptors to remote shared memory.  This shared memory
is implemented on each Host PCI bus controller for that bus segment.
ie some MMIO writes had to cross both a NUMA Link and X-bar compared
to local nodes only crossing the X-bar.
Result was some of the descriptors picked up by NICs would contain garbage.
The workaround was adding MMIO Reads after each descriptor was
updated - exactly what SGI wants to do for qla driver.

...
> So you'll only have one read for every so many writes.  And if your chipset 
> supports it, you don't have to do a full read out to the target bus, but just 
> to the local chipset.

Yes - agreed - not every MMIO write and we really only need to guarantee
the writes have reach the targeted PCI segment.
But it's still alot more reads and will measureably affect performance
on smaller boxes if it's done unconditionally.

Large scale NUMA is going to suffer under RDMA.
RDMA using smaller boxes will be much faster with at
least 10000-2000 cycles less overhead and latency per packet.

> It's a pretty hard bug to hit, as Jeremy mentioned.  You'll only see it on 
> large boxes.

Yes - a fabric that can't preserve ordering is the key bit here.

> If not, 
> then the hardware is already imposing I/O space write penalties anyway, 
> except for all writes.  I'd think that's worse than just flushing the ones 
> you care about, and only when you need to.

I have the impression it's not feasible for HW to enforce ordering on large
fabrics.  And the "standard" PCI programming model clearly can't deal
with out of order MMIO writes. You guys just have the misfortune of
pushing the "envelope" right now.

I don't want to overload an interface that deals with write posting
with MMIO write ordering workarounds. The cases we need to enforce
write posting are different from the cases which need to enforce
MMIO write ordering. I think I understand both well enough now
and hope you do too. :^) 

hth,
grant
