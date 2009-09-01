From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 13:15:50 -0500
Message-ID: <1251828950.13303.31.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	 <200909010933.50571.dtor@vmware.com>
	 <1251823925.3864.216.camel@mulgrave.site>
	 <1251824374.16169.128.camel@ank32.eng.vmware.com>
	 <1251825949.12482.34.camel@mulgrave.site>
	 <1251826877.16169.141.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZIASQA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 14:16:00 -0400
In-Reply-To: <1251826877.16169.141.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On Tue, 2009-09-01 at 10:41 -0700, Alok Kataria wrote:
> > lguest uses the sg_ring abstraction.  Xen and KVM were certainly looking
> > at this too.
> 
> I don't see the sg_ring abstraction that you are talking about. Can you
> please give me some pointers. 

it's in drivers/lguest ... apparently it's vring now and the code is in
driver/virtio

> Also regarding Xen and KVM I think they are using the xenbus/vbus
> interface, which is quite different than what we do here. 

Not sure about Xen ... KVM uses virtio above.

> > 
> > > And anyways how large is the DMA code that we are worrying about here ?
> > > Only about 300-400 LOC ? I don't think we might want to over-design for
> > > such small gains.
> > 
> > So even if you have different DMA code, the remaining thousand or so
> > lines would be in common.  That's a worthwhile improvement.
> 
> And not just that, different HV-vendors can have different features,
> like say XYZ can come up tomorrow and implement the multiple rings
> interface so the feature set doesn't remain common and we will have less
> code to share in the not so distant future.

Multiple rings is really just a multiqueue abstraction.  That's fine,
but it needs a standard multiqueue control plane.

The desire to one up the competition by adding a new whiz bang feature
to which you code a special interface is very common in the storage
industry.  The counter pressure is that consumers really like these
things standardised.  That's what the transport class abstraction is all
about.

We also seem to be off on a tangent about hypervisor interfaces.  I'm
actually more interested in the utility of an SRP abstraction or at
least something SAM based.  It seems that in your driver you don't quite
do the task management functions as SAM requests, but do them over your
own protocol abstractions.

James


