From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] fcoe cleanups and fcoe TODO
Date: Thu, 03 Jul 2008 12:18:13 -0500
Message-ID: <486D09D5.4030406@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu> <BD524EA7912ED5469DFD0BAEF6BC752F03E0A410@orsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37522 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYGCRS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 13:18:26 -0400
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F03E0A410@orsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leech, Christopher" <christopher.leech@intel.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org

Leech, Christopher wrote:
> michaelc@cs.wisc.edu wrote:
> 
>> - How much of the drivers/scsi/fcoe driver should be common? The
>> start and stop interface seems like it should be common for all fc
>> drivers. But will some things like passing in the network device to
>> use be fcoe module specific? Will other drivers load like a more
>> traditional driver with a pci_driver, 
>> or will this be a mess like iscsi where some do, but others bind to
>> network devices (netdevs) that also have fcoe engines. The pci_driver
>> case would mean that we do not need a common interface for this,
>> but for the netdev with fcoe engine then it seems like we want a
>> common inteface like we have with iscsi.
> 
> I think we're going to end up needing to support a mix of HBA PCI
> drivers and network interfaces with offloads.
> 
> I've started thinking about supporting FCoE offloading devices, with the
> libfc callouts as the main point to plug device specific functionality
> into the stack, I've come to think of the fcoe module as 3 things in 1.
> 
> 1) A library of reusable FCoE functionality.  So I'd like to clean up
> the FCoE encapsulation stuff and export it so it can be used by other
> drivers.
> 
> 2) The generic non-offload FCoE running on an Ethernet device
> implementation.  The glue code to setup a transport_fc/libfc instance on
> an Ethernet port.
> 
> 3) The communications endpoint for starting and stopping FCoE on an
> Ethernet port.  Today we only support the generic implementation, but
> for offload devices the fcoe module should still handle taking commands
> from userspace.  That way you don't end up with a new userspace tool for
> every vendor.  This is for converged networking device that will wait

Yeah, I do not think the tool per driver will be acceptable to distros 
anymore. On the target side there is one tool for all drivers, and for 
iscsi there is one tool for all initiator drivers. qla4xxx is the 
exception and they do not have any tool for upstream and are behind in 
the iscsi class integration, but they will hook in completely one day 
(only some operations are supported today).

One of the purposes of the transport classes is to provide a common 
interface to userspace, so it is just natural that a new tool support 
all the drivers hooking in the class.

In the end it would be nice if there was one tool for fcoe and fc, or 
one tool for any block driver.

> until told to start FCoE.  The driver for an HBA like device, where the
> PCI driver automatically starts FCoE when it loads, would bypass this.
> 
> I'm proposing that the fcoe module support device specific transports,
> which will handle setting up the libfc callouts for that device.  If no
> device specific support is found then the non-offload code in the fcoe
> module will be used.  The device support could a module that stacks on
> top of the base Ethernet driver, avoiding dependencies between the
> driver and fcoe/libfc until it is loaded.  I also think we can auto-load
> the device transport modules as needed using aliases derived from the
> PCI identifiers.
> 
> The device specific module would need to be able to match on network
> interfaces, and create an FC instance using functionality in itself,
> libfc, fcoe and the Ethernet driver.
> 
> With this mechanism in place, creating an FCoE instance on top of an
> Ethernet port would look something like:
> 1) create command comes into the fcoe module from user space, with an
> ethX name
> 2) lookup network interface by name
> 3) find parent PCI device for network interface
> 4) attempt to load device specific support module via alias
> fcoe-pci:vXXXXdXXXX
> 5) if module was loaded, it registers with fcoe module
> 6) call the list of fcoe transports match functions for the device
> 7) if a match is found, call the setup routine, otherwise create a
> non-offload instance
> 

So we have

[fc class]
[libfc]
[fcoe] will load offload driver?
[offload driver]
[ethernet driver]

right?

For iscsi what are doing is:

[iscsi class]
[lib iscsi]
[iscsi_tcp (software iscsi)] [ib_iser (iser)] [bnx2i (broadcom offload)]
[network stuff (depending on if it is software or offload this can look 
different]

When the lower level drivers (iscsi_tcp, iser, etc) load they will 
register/attach themselves with the class (like how fcoe does a 
fc_attach_transport). The offload engine low level drivers then create a 
host per network device (if the network device is created after the 
module load the hotplug code handles this). For software iscsi/iser we 
have to do a host per session (I_T Nexus), but that is just a odd case 
in general and for reasons you guys probably do not care about - we will 
just ignore this weird case :)

There are things I do not like about what we did, but it was done so it 
works like normal HBA/pci driver loading, and so we have a common path 
and both drivers present themselves to userspace the same way. So if you 
wanted to configure some host setting for a driver that did partial 
offload and hooked into the lib it was the same as if configuring a 
normal HBA's setting.

I am not tied to one way or the other. It seems weird with how the fc 
class does the fc attach and how we might want to present host level 
attrs though. With your model you probably want to make the fcoe module 
just do the non offload fcoe processing. It would then normally be best 
to put common interface stuff in the fc class, because the module 
loading stuff you described seems generic enough for fcoe or fc (I guess 
we probably will not see a fc driver like that though). Or maybe it 
could be even more generic and be put in scsi-ml since iscsi could use 
the same thing one day. If your model ends up working better I would 
like to steal it :)

And then with your model you will probably want to separate the binding 
of the module to hardware from the fc discovery, or add in some way to 
configure the host level settings before fc discovery is done (was not 
sure if #7's setup reference meant that it would do something like 
fcoe's fc_fabric_login or just the hardware/firmware bring up).
