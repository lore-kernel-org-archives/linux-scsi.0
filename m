From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 17:32:40 -0400
Message-ID: <447E0B78.5050700@torque.net>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com> <1149104797.7543.64.camel@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6344 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965168AbWEaVcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 17:32:46 -0400
In-Reply-To: <1149104797.7543.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Alexis Bruemmer wrote:
> These patches look good and are running on our x260 and the ppc64
> (power).  I was just wondering about a few things under the sys/class/:
> 
> there is a sas_device, sas_end_device, and a sas_expander dir.
> sas_device contains the same info as sas_end_device, and a sas_expander
> can we eliminate one or the other?  Or was this a design choice?
> 
> Also during the boot process on the x260 with an expander we see these
> printk's:
> sas: phy[n] matched wide port0
> If we are going to print this then we better be sure that this is truly
> a wide port.  It seems under the sys/class/ we have both a single
> port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
> although each phy seems to have the same sas_address the end_device
> attached to that phy have unique addresses.  My understanding is that a
> wide port has multiple phys with the same sas address and are attached
> to one end device.

A wide port is an abstraction just above the link
layer in which two or more links running between
the same two devices have phys with the same SAS
addresses associated with them.

Assume we have two phys on a HBA connected to two
phys on an expander, then two other phys on the
expander connected to a dual ported SAS disk.
That is one wide port connection (between the
at HBA and the expander) and two narrow
port connections (between the expander and each
port on the SAS disk).

This comes about because phys on a HBA share a
SAS address, phys on a expander share a SAS address
but phys of a dual ported SAS disk have distinct
SAS addresses.
[Could someone suggest an instructive diagram url
of this as the sas drafts are a bit complex.]

You are probably aware of this distinction but my
guess is a lot of other people aren't.

Put another way, seen from a LLD or discover process when
multiple phys on the same device have this tuple
<SAS_address, attached_SAS_address> equal then there is
a wide port connection.

This also means that it is possible to talk about
a narrow port in the absence of an established
link but not possible to talk about a wide port
until there are two or more established links.

It may also be worth pointing out that there is not data
aggregation on a wide port, but there is command aggregation.
So a 2 phy wide port connection will not run a single SCSI
command twice as fast, but can run two co-incident SCSI
commands at full link speed (i.e. up to 3 Gbps currently).

  I believe that the expander situation is not the
> same as wide port.  If this is the case then it is as simple as changing
> the printk statement to not say "wide port"
> 
> I am more than happy to make these changes if everyone agrees that they
> should be made.

It may also be useful to use the term "narrow"
sometimes, especially if there is a transition
from wide to narrow (e.g. due to a faulty cable
or a link reset on one of the links).

Doug Gilbert
