From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 17:54:36 +0000
Message-ID: <1251827676.16169.152.camel@ank32.eng.vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	 <200909010933.50571.dtor@vmware.com>
	 <1251823925.3864.216.camel@mulgrave.site>  <adaocpuo9vs.fsf@cisco.com>
	 <1251826804.12482.47.camel@mulgrave.site>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47170 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751395AbZIARyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 13:54:33 -0400
In-Reply-To: <1251826804.12482.47.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Roland Dreier <rdreier@cisco.com>, Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>


On Tue, 2009-09-01 at 10:40 -0700, James Bottomley wrote:
> On Tue, 2009-09-01 at 10:25 -0700, Roland Dreier wrote:
> > > Nobody said you had to have the exact same driver for every hypervisor.
> >  > What people are suggesting is that we look at commonalities in the
> >  > interfaces both from a control plane point of view (transport class) and
> >  > from a code sharing point of view (libscsivirt).  However, all the
> >  > hypervisor interfaces I've seen are basically DMA rings ...
> > 
> > I don't think that's anything special about hypervisors though -- pretty
> > much all modern device interfaces are basically DMA rings, aren't they?
> > I'm definitely in favor of common code to handle commonality but on the
> > other hand I don't see what's so special about virtual devices vs. real
> > HW devices.  One the one side we have VMware's closed hypervisor code
> > and on the other side we have vendor XYZ's closed RTL and firmware code.
> 
> But the main difference between actual hardware and hypervisors is the
> fact that to set up a DMA transfer you have to poke registers on the
> card, set up a mailbox and manage queues of commands to the card.  For a
> hypervisor, sending a DMA transaction is a hypercall.

Not really, it depends on how you see it, VMware exports different IO
registers too which need to be bit banged to start some IO. So starting
an IO is not just a hypercall but a series of commands. Look at
pvscsi_kick_io, also the driver and the hypervisor code share the
request rings and completion rings which is quite similar to how a
command-queue is managed for a card. 

Also note that, the way all these things are implemented for each of the
hypervisor devices will differ and getting every hv-vendor to agree on a
common set of things is not very attractive proposition ( atleast, this
I can say from my past experiences).


> 
> Now for most physical drivers, take for example FCP ones, we have a
> common control plane interface (fc transport class), we're evolving a
> frame handling library (libfc) so all the drivers really have are
> specific codes to bit bang the hardware.  Some of the libfc handling is
> actually done in intelligent offload firmware on the HBAs, so some will
> use more or less of the libfc handling (same is true for SAS and
> libsas).  When there's no actual hardware to be bit banged, and no real
> firmware offload, it does make one wonder what would be left unique to
> the driver.
> 
> James
> 

Alok

