From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 09:17:53 -0500
Message-ID: <1251814673.3864.44.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbZIAOSB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 10:18:01 -0400
In-Reply-To: <e2e108260909010412p41fae86ckb6df5cd8a81e3c37@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tue, 2009-09-01 at 13:12 +0200, Bart Van Assche wrote:
> On Mon, Aug 31, 2009 at 8:00 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> >
> > On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
> > > VMware PVSCSI driver - v2.
> >
> > OK, so the first thing that springs to mind is that we already have one
> > of these things: the ibmvscsi ... is there no way we can share code
> > between this and the other PV drivers?
> 
> Good question. But shouldn't the ibmvscsi driver be refactored before
> considering sharing ibmvscsi code with other paravirtualized drivers ?

Not really, that would make it a chicken and egg problem.  The question
was meant to direct attention to the issue of whether we should share
code for PV drivers or not. I think the answer to this one is yes; the
next thing is how to do it.

The one thing I'm not really keen on having is half a dozen totally
different virtual SCSI drivers for our half a dozen virtualisation
solutions.  Apart from the coding waste, each will have new and
different bugs and a much smaller pool of users to find them.

The IBM vscsi operates slightly differently from the way newer PV
drivers may be expected to operate, but the SRP abstraction does look
like a reasonable one for a PV driver.

> A quote from the ibmvscsi.c source code:
> 
>  * TODO: This is currently pretty tied to the IBM i/pSeries hypervisor
>  * interfaces.  It would be really nice to abstract this above an RDMA
>  * layer.
> 
> Splitting the ibmvscsi.c driver in an SRP initiator and an RDMA driver
> would make the following possible:
> - Reuse the existing SRP initiator (ib_srp). Currently there are two
> SRP initiators present in the Linux kernel -- one that uses the RDMA
> verbs API (ib_srp) and one that only works with IBM's i/pSeries
> hypervisor (ibmvscsi).
> - Reuse the ib_ipoib kernel module to provide an IP stack on top of
> the new RDMA driver instead of having to maintain a separate network
> driver for this hardware (ibmveth).

So the RDMA piece is what I'm not sure about.  For a protocol
abstraction, SRP makes a lot of sense.  For a hypervisor interface, it's
not really clear that RDMA is the best way to go.  In fact, some more
minimal DMA ring implementation seems to be the way most hypervisors are
set up, but it's still possible to run a nice SRP abstraction over them.

> More information about the architecture the ibmvscsi and the ibmveth
> drivers have been developed for can be found in the following paper:
> D. Boutcher and D. Engebretsen, Linux Virtualization on IBM POWER5
> Systems, Proceedings of the Linux Symposium, Vol. 1, July 2004, pp.
> 113-120 (http://www.kernel.org/doc/mirror/ols2004v1.pdf).

The other piece of this is that it's not clear that SCSI is actually the
best layer for this abstration.  For a simple, fast storage interface,
nbd is probably the easiest abstraction to do (the disadvantage being
the lack of ioctl support, so it really only does storage).

James


