From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 1 Sep 2009 10:13:06 -0600
Message-ID: <20090901161306.GN22870@parisc-linux.org>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251739735.16169.20.camel@ank32.eng.vmware.com> <1251741624.18828.83.camel@mulgrave.site> <1251755593.16169.51.camel@ank32.eng.vmware.com> <1251815012.3864.55.camel@mulgrave.site> <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41167 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZIAQNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2009 12:13:06 -0400
Content-Disposition: inline
In-Reply-To: <35f686220909010908k24f0164nc09b1158b6841ff3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alok Kataria <alokkataria1@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, akataria@vmware.com, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>

On Tue, Sep 01, 2009 at 09:08:48AM -0700, Alok Kataria wrote:
> Hi James,
> 
> On Tue, Sep 1, 2009 at 7:23 AM, James Bottomley<James.Bottomley@suse.de> wrote:
> > On Mon, 2009-08-31 at 14:53 -0700, Alok Kataria wrote:
> >> Hi James,
> >>
> >> Thanks for your comments.
> >>
> >> On Mon, 2009-08-31 at 11:00 -0700, James Bottomley wrote:
> >> > On Mon, 2009-08-31 at 10:28 -0700, Alok Kataria wrote:
> >> > > VMware PVSCSI driver - v2.
> >> >
> >> > OK, so the first thing that springs to mind is that we already have one
> >> > of these things: the ibmvscsi ... is there no way we can share code
> >> > between this and the other PV drivers?
> >>
> >> I took a quick look at the ibmvscsi driver, and there are lot of
> >> differences between the two, mainly the ABI that is shared between the
> >> hypervisor and driver differ.
> >
> > Well, that's pretty abstractable, surely? ?However, there is an
> > interesting question of what the best hypervisor interface actually is.
> >
> >> ?Also the ibmvscsi driver seems to offer a
> >> lot of other features as well, like the SRP.
> >
> > SRP is the protocol transfer abstraction. ?It's just a way of packaging
> > up SCSI commands for transfer over a DMA protocol (OK, so it was
> > envisaged that the DMA protocol would be RDMA, but a hypervisor
> > interface is also a DMA protocol).
> >
> >> The pvscsi driver is a simple SCSI adapter driver and is basically no
> >> different than any other SCSI driver written for a particular HBA.
> >
> > Well, it is really ... hopefully all the hypervisor interfaces won't
> > decide to be completely incompatible, so there's a good chance of code
> > sharing between them.
> 
> Well, going by that theory every SCSI driver can share some code with
> any other SCSI driver, In short we can come up with an low level SCSI
> driver interface which every SCSI driver can make use of, to reduce
> code duplicity.  We don't do that, and the reason being, that its a
> device and we shouldn't expect every device to share common features
> or design decisions.

Umm, we do share code between SCSI drivers.  We have the ULDs (sg, sd,
sr, etc), we have the midlayer, and we have the transport classes (spi,
iscsi, fc, etc).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
