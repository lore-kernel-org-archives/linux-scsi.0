From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] FC Transport support for vports based on NPIV
Date: Mon, 21 May 2007 17:27:19 +0200
Message-ID: <20070521152718.GA15212@schmichrtp>
References: <1176408091.19824.20.camel@localhost.localdomain> <20070514121239.GA23620@schmichrtp> <464886B6.8050509@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:60114 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763902AbXEUP1W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 11:27:22 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate8.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l4LFRKgE419606
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2007 15:27:20 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4LFRKjW1978562
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2007 16:27:20 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4LFRJXC012659
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2007 16:27:20 +0100
Content-Disposition: inline
In-Reply-To: <464886B6.8050509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, duane.grigsby@qlogic.com

On Mon, May 14, 2007 at 11:56:38AM -0400, James Smart wrote:

> All true.  But, there is the notion that there is a driver that thinks
> it's controlling the adapter, but it's actually talking to a virtual
> thing, that traps the driver's FLOGI's and turns it into FDISCs...
> 
> >With zfcp, the hardware FCP adapter does NPIV and only hands out the
> >virtual address to individual Linux instances. zfcp gets the assigned
> >virtual address for the Linux instance. This address is used for
> >allocating the scsi_host structure. Basically, the whole system uses
> >NPIV, but each Linux only uses one assigned virtual WWPN.
> 
> Yes - I understand. For all intents and purposes, that virtual address
> is treated as an adapter.
> 
> >My current understanding is that the vports introduced in the fc
> >transport class do not affect the Linux systems that only use one
> >virtual address.  To map this to Xen, the dom0 would use the vports
> >to show all virtual address, and each domU would use the assigned
> >virtual address without showing the vport in sysfs. Is this correct?
> >
> >Christof
> 
> Agreed. It should mean nothing to the zfcp driver.  Nothing changes in
> the driver if it will always be a single address.
> 
> Although - if your hardware-to-driver interface had the ability to
> instantiate a new address, you could augment your driver to support
> the vport calls.  That's a choice for you though.

Thanks for your input.

I looked at the interface between the FCP hardware adapter and zfcp
again. The Linux guest only sees a subchannel device. This subchannel
device is already a virtualized interface. The FCP adapter assigns a
unique WWPN to each subchannel device (which is done by NPIV).

zfcp only sees the subchannel device and knows that this device has
only one WWPN. So this "virtual" device is used as SCSI/FC adapter
in Linux and will always have one single address. So, i think
reporting this subchannel device as a simple HBA without vports
makes sense, since the virtualization part is handled by the FCP
adapter, and not zfcp in Linux.

> PS: One thing I didn't call out in the vport patches was the
> expectation that the vport-supporting driver had to set the PPN
> attribute appropriately.  And... did you see that T11 is trying to
> change what the PPN is set to - the fabric port_name not the physical
> N_Port port_name.

No, i did not follow the T11 change. Do you have a link to a
draft document or something similar?

zfcp uses the FC tranport class attributes port_name and
permanent_port_name. PPN is the fixed WWPN of the physical
adapter, while PN is the one virtual one used by each Linux
guest and is assigned via NPIV. Both WWPNs are passed back
via the "virtual" device, so i guess this would be only
a matter of reporting the correct one in zfcp.

Christof
