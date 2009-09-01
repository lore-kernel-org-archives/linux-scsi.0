From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 12:25:49 -0500
Message-ID: <1251825949.12482.34.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <adaws4iod8k.fsf@cisco.com> <20090901161651.GO22870@parisc-linux.org>
	 <200909010933.50571.dtor@vmware.com>
	 <1251823925.3864.216.camel@mulgrave.site>
	 <1251824374.16169.128.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754193AbZIARZ7@vger.kernel.org>
In-Reply-To: <1251824374.16169.128.camel@ank32.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akataria@vmware.com
Cc: Dmitry Torokhov <dtor@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-09-01 at 09:59 -0700, Alok Kataria wrote:
> On Tue, 2009-09-01 at 09:52 -0700, James Bottomley wrote:
> > On Tue, 2009-09-01 at 09:33 -0700, Dmitry Torokhov wrote:
> > > On Tuesday 01 September 2009 09:16:51 am Matthew Wilcox wrote:
> > > > On Tue, Sep 01, 2009 at 09:12:43AM -0700, Roland Dreier wrote:
> > > > > I'm not really sure we should be trying to force drivers to share just
> > > > > because they are paravirtualized -- if there is real commonality, then
> > > > > sure put it in common code, but different hypervisors are probably as
> > > > > different as different hardware.
> > > > 
> > > > I really disagree.  This kind of virtualised drivers are pretty much
> > > > communication protocols, and not hardware.  As such, why design a new one?
> > > > If there's an infelicity in the ibmvscsi protocol, it makes sense to
> > > > design a new one.  But being different for the sake of being different
> > > > is just a way to generate a huge amount of make-work.
> > > > 
> > > 
> > > The same thing can be said about pretty much anything. We don't have
> > > single SCSI, network, etc driver handling every devices in their
> > > respective class, I don't see why it would be different here.
> > > A hypervisor presents the same interface to the guest OS (whether
> > > it is Linux, Solaris or another OS) much like a piece of silicone
> > > does and it may very well be different form other hypervisors.
> > 
> > Nobody said you had to have the exact same driver for every hypervisor.
> > What people are suggesting is that we look at commonalities in the
> > interfaces both from a control plane point of view (transport class) and
> > from a code sharing point of view (libscsivirt).  However, all the
> > hypervisor interfaces I've seen are basically DMA rings ... they really
> > do seem to be very similar across hypervisors, so it does seem there
> > could be a lot of shared commonality.  I'm not going to insist on RDMA
> > emulation, but perhaps you lot should agree on what a guest to
> > hypervisor DMA interface looks like.
> 
> Which is this other hypervisor driver that you are talking about,
> ibmvscsi is using RDMA emulation and I don't think you mean that. 

lguest uses the sg_ring abstraction.  Xen and KVM were certainly looking
at this too.

> And anyways how large is the DMA code that we are worrying about here ?
> Only about 300-400 LOC ? I don't think we might want to over-design for
> such small gains.

So even if you have different DMA code, the remaining thousand or so
lines would be in common.  That's a worthwhile improvement.

The benefit to users would be a common control plane and interface from
the transport class, plus common code means more testers regardless of
virtualisation technology chosen.

James
