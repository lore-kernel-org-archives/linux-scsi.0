From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Wed, 02 Sep 2009 10:16:29 -0700
Message-ID: <1251911789.23106.25.camel@ank32.eng.vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	 <200909010933.50571.dtor@vmware.com>
	 <1251823925.3864.216.camel@mulgrave.site>
	 <1251824374.16169.128.camel@ank32.eng.vmware.com>
	 <1251825949.12482.34.camel@mulgrave.site>
	 <1251826877.16169.141.camel@ank32.eng.vmware.com>
	 <1251828950.13303.31.camel@mulgrave.site>
	 <1251860141.8844.20.camel@ank32.eng.vmware.com>
	 <1251903967.3892.177.camel@mulgrave.site>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:40825 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZIBRQ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 13:16:26 -0400
In-Reply-To: <1251903967.3892.177.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>


On Wed, 2009-09-02 at 08:06 -0700, James Bottomley wrote:
> On Tue, 2009-09-01 at 19:55 -0700, Alok Kataria wrote:
> > On Tue, 2009-09-01 at 11:15 -0700, James Bottomley wrote:
> > > On Tue, 2009-09-01 at 10:41 -0700, Alok Kataria wrote:
> > > > > lguest uses the sg_ring abstraction.  Xen and KVM were certainly looking
> > > > > at this too.
> > > > 
> > > > I don't see the sg_ring abstraction that you are talking about. Can you
> > > > please give me some pointers. 
> > > 
> > > it's in drivers/lguest ... apparently it's vring now and the code is in
> > > driver/virtio
> > > 
> > > > Also regarding Xen and KVM I think they are using the xenbus/vbus
> > > > interface, which is quite different than what we do here. 
> > > 
> > > Not sure about Xen ... KVM uses virtio above.
> > > 
> > > > > 
> > > > > > And anyways how large is the DMA code that we are worrying about here ?
> > > > > > Only about 300-400 LOC ? I don't think we might want to over-design for
> > > > > > such small gains.
> > > > > 
> > > > > So even if you have different DMA code, the remaining thousand or so
> > > > > lines would be in common.  That's a worthwhile improvement.
> > 
> > I don't see how, the rest of the code comprises of IO/MMIO  space & ring
> > processing which is very different in each of the implementations. What
> > is left is the setup and initialization code which obviously depends on
> > the implementation of the driver data structures. 
> 
> Are there benchmarks comparing the two approaches?

Benchmarks comparing what ? 

> 
> > > > And not just that, different HV-vendors can have different features,
> > > > like say XYZ can come up tomorrow and implement the multiple rings
> > > > interface so the feature set doesn't remain common and we will have less
> > > > code to share in the not so distant future.
> > > 
> > > Multiple rings is really just a multiqueue abstraction.  That's fine,
> > > but it needs a standard multiqueue control plane.
> > > 
> > > The desire to one up the competition by adding a new whiz bang feature
> > > to which you code a special interface is very common in the storage
> > > industry.  The counter pressure is that consumers really like these
> > > things standardised.  That's what the transport class abstraction is all
> > > about.
> > > 
> > > We also seem to be off on a tangent about hypervisor interfaces.  I'm
> > > actually more interested in the utility of an SRP abstraction or at
> > > least something SAM based.  It seems that in your driver you don't quite
> > > do the task management functions as SAM requests, but do them over your
> > > own protocol abstractions.
> > 
> > Okay,  I think I need to take a step back here and understand what
> > actually are you asking for.
> > 
> > 1. What do you mean by the "transport class abstraction" ? 
> > Do you mean that the way we communicate with the hypervisor needs to be
> > standardized ?
> 
> Not really.  Transport classes are designed to share code and provide a
> uniform control plane when the underlying implementation is different.
> 
> > 2. Are you saying that we should use the virtio ring mechanism to handle
> > our request and completion rings ? 
> 
> That's an interesting question.  Virtio is currently the standard linux
> guest<=>hypervisor communication mechanism, but if you have comparative
> benchmarks showing that virtual hardware emulation is faster, it doesn't
> need to remain so.

It is a standard that KVM and lguest are using. I don't think it needs
any benchamrks to show if a particular approach is faster or not. 
VMware has supported paravirtualized devices in backend for more than an
year now (may be more, don't quote me on this), and the backend is
common across different guest OS's. Virtual hardware emulation helps us
give a common interface to different GOS's, whereas virtio binds this
heavily to Linux usage. And please note that the backend implementation
for our virtual device was done before virtio was integrated in
mainline.

Also, from your statements above it seems that you think we are
proposing to change the standard communication mechanism (between guest
& hypervisor) for Linux. For the record that's not the case, the
standard that the Linux based VM's are using does not need to be
changed. This pvscsi driver is used for a new SCSI HBA, how does it
matter if this SCSI HBA is actually a virtual HBA and implemented by the
hypervisor in software. 

> 
> >   We can not do that. Our backend expects that each slot on the ring is
> > in a particular format. Where as vring expects that each slot on the
> > vring is in the vring_desc format.
> 
> Your backend is a software server, surely?

Yes it is, but the backend is as good as written in stone, as it is
being supported by our various products which are out in the market. The
pvscsi driver that I proposed for mainlining has also been in existence
for some time now and was being used/tested heavily. Earlier we used to
distribute it as part of our open-vm-tools project, and it is now that
we are proposing to integrate it with mainline.

So if you are hinting that since the backend is software, it can be
changed the answer is no. The reason being, their are existing
implementations that have that device support and we still want newer
guests to make use of that backend implementation. 

> > 3. Also, the way we communicate with the hypervisor backend is that the
> > driver writes to our device IO registers in a particular format. The
> > format that we follow is to first write the command on the
> > COMMAND_REGISTER and then write a stream of data words in the
> > DATA_REGISTER, which is a normal device interface.
> > The reason I make this point is to highlight we are not making any
> > hypercalls instead we communicate with the hypervisor by writing to
> > IO/Memory mapped regions.  So from that perspective the driver has no
> > knowledge that its is talking to a software backend (aka device
> > emulation) instead it is very similar to how a driver talks to a silicon
> > device.  The backend expects things in a certain way and we cannot
> > really change that interface ( i.e. the ABI shared between Device driver
> > and Device Emulation).
> > 
> > So sharing code with vring or virtio is not something that works well
> > with our backend. The VMware PVSCSI driver is simply a virtual HBA and
> > shouldn't be looked at any differently.
> > 
> > Is their anything else that you are asking us to standardize ?
> 
> I'm not really asking you to standardise anything (yet).  I was more
> probing for why you hadn't included any of the SCSI control plane
> interfaces and what lead you do produce a different design from the
> current patterns in virtual I/O.  I think what I'm hearing is "Because
> we didn't look at how modern SCSI drivers are constructed" and "Because
> we didn't look at how virtual I/O is currently done in Linux".  That's
> OK (it's depressingly familiar in drivers),

I am sorry that's not the case, the reason we have different design as I
have mentioned above is because we want a generic mechanism which works
for all/most of the GOS's out their and doesn't need to be specific to
Linux.

>  but now we get to figure out
> what, if anything, makes sense from a SCSI control plane to a hypervisor
> interface and whether this approach to hypervisor interfaces is better
> or worse than virtio.

I guess these points are answered above. Let me know if their is still
something amiss. 

Thanks,
Alok

> 
> James
> 
> 

