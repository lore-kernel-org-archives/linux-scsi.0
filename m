From: Alok Kataria <akataria@vmware.com>
Subject: Re: [Pv-drivers] [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Sun, 13 Sep 2009 20:05:21 -0700
Message-ID: <1252897521.28095.46.camel@ank32.eng.vmware.com>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
	 <4AA8177A.2020606@codemonkey.ws>
	 <1252533093.24633.40.camel@ank32.eng.vmware.com>
	 <4AA8284A.3010908@codemonkey.ws>
	 <1252626223.3899.64.camel@ank32.eng.vmware.com>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60546 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbZINDFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Sep 2009 23:05:17 -0400
In-Reply-To: <1252626223.3899.64.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, LKML <linux-kernel@vger.kernel.org>, virtualization <virtualization@lists.linux-foundation.org>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, Brian King <brking@linux.vnet.ibm.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Andrew Morton <akpm@linux-foundation.org>, Anthony Liguori <anthony@codemonkey.ws>

On Thu, 2009-09-10 at 16:43 -0700, Alok Kataria wrote:
> Hi Anthony,
> 
> On Wed, 2009-09-09 at 15:12 -0700, Anthony Liguori wrote:
> > Alok Kataria wrote:
> > > I see your point, but the ring logic or the ABI that we use to
> > > communicate between the hypervisor and guest is not shared between our
> > > storage and network drivers. As a result, I don't see any benefit of
> > > separating out this ring handling mechanism, on the contrary it might
> > > just add some overhead of translating between various layers for our
> > > SCSI driver.
> > >   
> > 
> > But if you separate out the ring logic, it allows the scsi logic to be 
> > shared by other paravirtual device drivers.  This is significant and 
> > important from a Linux point of view.
> > 
> > There is almost nothing vmware specific about the vast majority of your 
> > code.  If you split out the scsi logic, then you will receive help 
> > debugging, adding future features, and improving performance from other 
> > folks interested in this.  In the long term, it will make your life 
> > much, much easier by making the driver relevant to a wider audience :-)
> 
> >From what you are saying, it seems that for that matter any physical
> SCSI HBA's driver could be converted to use the virtio interface;
> doesn't each and every driver have something like a ring/queue & I/O
> register mechanism to talk to the device ?
> 
> Also, why would you add overhead for translation layers between APIs or
> data structures just for the sake of it ? I guess you would say it helps
> code re-usability, but I fail to see how much of a benefit that is. The
> vast majority of the 1500 odd lines of the driver are still very
> specific and tied to our PCI device and register interface.
> 
> I will just like to re-iterate this once again, this driver should be  
> treated no different than a hardware SCSI HBA driver, albeit a very  
> simple HBA. We export a PCI device as any other physical HBA, also the
> driver talks to the device (emulation) through device IO regisers
> without any hypercalls.
> 
> As for the virt_scsi layer, we can evaluate it whenever it is ready for
> upstream and then take a more informed decision whether we should switch
> to using it.
> 
> > 
> > > Having said that, I will like to add that yes if in some future
> > > iteration of our paravirtualized drivers, if we decide to share this
> > > ring mechanism for our various device drivers this might be an
> > > interesting proposition. 
> > >   
> > 
> > I am certainly not the block subsystem maintainer, but I'd hate to see 
> > this merged without any attempt at making the code more reusable.  If 
> > adding the virtio layering is going to somehow hurt performance, break 
> > your ABI, or in some way limit you, then that's something to certainly 
> > discuss and would be valid concerns.  That said, I don't think it's a 
> > huge change to your current patch and I don't see any obvious problems 
> > it would cause.
> > 
> 
> I will also like to add that, this is just a driver and is isolated from
> the rest of the core of the kernel. The driver is not doing anything
> improper either and is using the SCSI stack the way that any other SCSI
> driver would use it. 
> In earlier cases, when there were changes to the core kernel parts (e.g.
> VMI, hypervisor_init- the tsc freq part) VMware did work with the
> community to come up with generic interfaces. 
> 
> In this case though, I don't think the advantages of using the virtio
> interfaces are justified as yet. As and when the virt-scsi layer is
> implemented we can re-evaluate our design and use that layer instead.
> 
> Holding inclusion of pvscsi driver until the development of virt-scsi
> interface is completed doesn't sound right to me. 
> 

Hi James, 

Please let us know your views on how should we proceed on this ? In my
previous mail, I have tried to state my reservations against going the
virt-scsi way just as yet. Also please note that we emulate a pure PCI
device hence I don't see a reason why our driver should be treated any
different than a driver for a physical HBA. 

Thanks,
Alok


