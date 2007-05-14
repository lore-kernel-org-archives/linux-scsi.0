From: James Smart <James.Smart@Emulex.Com>
Subject: `
Date: Mon, 14 May 2007 11:56:38 -0400
Message-ID: <464886B6.8050509@emulex.com>
References: <1176408091.19824.20.camel@localhost.localdomain> <20070514121239.GA23620@schmichrtp>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62683 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbXENP4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 11:56:51 -0400
In-Reply-To: <20070514121239.GA23620@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, duane.grigsby@qlogic.com


Christof Schmitt wrote:
> James,
> 
> i try to understand what the introduction of the vports means for zfcp, since
> this driver also supports NPIV. The documentation for the fc transport class
> describes a driver that would fully control the adapter and the creation of
> virtual address. Since you mentioned Xen, i assume that this could be a dom0.

All true.  But, there is the notion that there is a driver that thinks it's
controlling the adapter, but it's actually talking to a virtual thing, that
traps the driver's FLOGI's and turns it into FDISCs...

> With zfcp, the hardware FCP adapter does NPIV and only hands out the virtual
> address to individual Linux instances. zfcp gets the assigned virtual address
> for the Linux instance. This address is used for allocating the scsi_host
> structure. Basically, the whole system uses NPIV, but each Linux only uses one
> assigned virtual WWPN.

Yes - I understand. For all intents and purposes, that virtual address is
treated as an adapter.

> My current understanding is that the vports introduced in the fc transport
> class do not affect the Linux systems that only use one virtual address.  To
> map this to Xen, the dom0 would use the vports to show all virtual address, and
> each domU would use the assigned virtual address without showing the vport in
> sysfs. Is this correct?
> 
> Christof

Agreed. It should mean nothing to the zfcp driver.  Nothing changes in the driver
if it will always be a single address.

Although - if your hardware-to-driver interface had the ability to instantiate
a new address, you could augment your driver to support the vport calls. That's
a choice for you though.

-- james

PS: One thing I didn't call out in the vport patches was the expectation that
   the vport-supporting driver had to set the PPN attribute appropriately.
   And... did you see that T11 is trying to change what the PPN is set to - the
   fabric port_name not the physical N_Port port_name.
