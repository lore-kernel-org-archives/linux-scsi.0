From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 15:57:53 -0500
Message-ID: <1149109073.22134.105.camel@mulgrave.il.steeleye.com>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5828 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964967AbWEaU6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 16:58:00 -0400
In-Reply-To: <1149104797.7543.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 12:46 -0700, Alexis Bruemmer wrote:
> there is a sas_device, sas_end_device, and a sas_expander dir.
> sas_device contains the same info as sas_end_device, and a sas_expander
> can we eliminate one or the other?  Or was this a design choice?

Not really.  This is a design choice given to us by the interface.
Everything that's connected to a port is a sas_device.  As such, they
all share a set of characteristics (initiator and target roles, sas
address and so forth).  The specific devices (sas_expander and
sas_end_device) contain only parameters that are specific to the device,
so the expander shows the manufacturer and component info.  The
end_device shows the SAS mandated parameters like ready led and nexus
loss timeout).

> Also during the boot process on the x260 with an expander we see these
> printk's:
> sas: phy[n] matched wide port0
> If we are going to print this then we better be sure that this is truly
> a wide port.  It seems under the sys/class/ we have both a single
> port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
> although each phy seems to have the same sas_address the end_device
> attached to that phy have unique addresses.  My understanding is that a
> wide port has multiple phys with the same sas address and are attached
> to one end device.  I believe that the expander situation is not the
> same as wide port.  If this is the case then it is as simple as changing
> the printk statement to not say "wide port"

As I read the code, it only prints that when it actually finds a wide
port (as in a port that already has a phy attached) ... do an ls -R of
your tree and I'll see if I can figure out what your topology is.

James


