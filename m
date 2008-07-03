From: "Leech, Christopher" <christopher.leech@intel.com>
Subject: RE: [Open-FCoE] fcoe cleanups and fcoe TODO
Date: Wed, 2 Jul 2008 17:13:20 -0700
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F03E0A410@orsmsx411.amr.corp.intel.com>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40609 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbYGCANY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 20:13:24 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, devel@open-fcoe.org

michaelc@cs.wisc.edu wrote:

> - How much of the drivers/scsi/fcoe driver should be common? The
> start and stop interface seems like it should be common for all fc
> drivers. But will some things like passing in the network device to
> use be fcoe module specific? Will other drivers load like a more
> traditional driver with a pci_driver, 
> or will this be a mess like iscsi where some do, but others bind to
> network devices (netdevs) that also have fcoe engines. The pci_driver
> case would mean that we do not need a common interface for this,
> but for the netdev with fcoe engine then it seems like we want a
> common inteface like we have with iscsi.

I think we're going to end up needing to support a mix of HBA PCI
drivers and network interfaces with offloads.

I've started thinking about supporting FCoE offloading devices, with the
libfc callouts as the main point to plug device specific functionality
into the stack, I've come to think of the fcoe module as 3 things in 1.

1) A library of reusable FCoE functionality.  So I'd like to clean up
the FCoE encapsulation stuff and export it so it can be used by other
drivers.

2) The generic non-offload FCoE running on an Ethernet device
implementation.  The glue code to setup a transport_fc/libfc instance on
an Ethernet port.

3) The communications endpoint for starting and stopping FCoE on an
Ethernet port.  Today we only support the generic implementation, but
for offload devices the fcoe module should still handle taking commands
from userspace.  That way you don't end up with a new userspace tool for
every vendor.  This is for converged networking device that will wait
until told to start FCoE.  The driver for an HBA like device, where the
PCI driver automatically starts FCoE when it loads, would bypass this.

I'm proposing that the fcoe module support device specific transports,
which will handle setting up the libfc callouts for that device.  If no
device specific support is found then the non-offload code in the fcoe
module will be used.  The device support could a module that stacks on
top of the base Ethernet driver, avoiding dependencies between the
driver and fcoe/libfc until it is loaded.  I also think we can auto-load
the device transport modules as needed using aliases derived from the
PCI identifiers.

The device specific module would need to be able to match on network
interfaces, and create an FC instance using functionality in itself,
libfc, fcoe and the Ethernet driver.

With this mechanism in place, creating an FCoE instance on top of an
Ethernet port would look something like:
1) create command comes into the fcoe module from user space, with an
ethX name
2) lookup network interface by name
3) find parent PCI device for network interface
4) attempt to load device specific support module via alias
fcoe-pci:vXXXXdXXXX
5) if module was loaded, it registers with fcoe module
6) call the list of fcoe transports match functions for the device
7) if a match is found, call the setup routine, otherwise create a
non-offload instance

I'd be interested to hear what you think.

- Chris
