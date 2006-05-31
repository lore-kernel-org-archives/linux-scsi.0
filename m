From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 15:30:19 -0700
Message-ID: <1149114619.7543.93.camel@localhost.localdomain>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
	 <447E0B78.5050700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:26337 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751584AbWEaWaY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 18:30:24 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VMUNee029996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 18:30:24 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VMUNie148126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 16:30:23 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VMUNRa022266
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 16:30:23 -0600
In-Reply-To: <447E0B78.5050700@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 17:32 -0400, Douglas Gilbert wrote:
> Alexis Bruemmer wrote:
> > These patches look good and are running on our x260 and the ppc64
> > (power).  I was just wondering about a few things under the sys/class/:
> > 
> > there is a sas_device, sas_end_device, and a sas_expander dir.
> > sas_device contains the same info as sas_end_device, and a sas_expander
> > can we eliminate one or the other?  Or was this a design choice?
> > 
> > Also during the boot process on the x260 with an expander we see these
> > printk's:
> > sas: phy[n] matched wide port0
> > If we are going to print this then we better be sure that this is truly
> > a wide port.  It seems under the sys/class/ we have both a single
> > port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
> > although each phy seems to have the same sas_address the end_device
> > attached to that phy have unique addresses.  My understanding is that a
> > wide port has multiple phys with the same sas address and are attached
> > to one end device.
> 
> A wide port is an abstraction just above the link
> layer in which two or more links running between
> the same two devices have phys with the same SAS
> addresses associated with them.
> 
> Assume we have two phys on a HBA connected to two
> phys on an expander, then two other phys on the
> expander connected to a dual ported SAS disk.
> That is one wide port connection (between the
> at HBA and the expander) and two narrow
> port connections (between the expander and each
> port on the SAS disk).
> 
> This comes about because phys on a HBA share a
> SAS address, phys on a expander share a SAS address
> but phys of a dual ported SAS disk have distinct
> SAS addresses.
> [Could someone suggest an instructive diagram url
> of this as the sas drafts are a bit complex.]

This would be assume!

> 
> You are probably aware of this distinction but my
> guess is a lot of other people aren't.
> 
> Put another way, seen from a LLD or discover process when
> multiple phys on the same device have this tuple
> <SAS_address, attached_SAS_address> equal then there is
> a wide port connection.

If this is the case then according to the below print out we do not have
a wide port on this machine:

sas: phy0 added to port0, phy_mask:0x1
[  155.328494] sas: phy1 matched wide port0
[  155.328499] sas: phy1 added to port0, phy_mask:0x3
[  155.328516] sas: phy2 matched wide port0
[  155.328520] sas: phy2 added to port0, phy_mask:0x7
[  155.328541] sas: phy3 matched wide port0
[  155.328548] sas: phy3 added to port0, phy_mask:0xf
[  155.328578] sas: DOING DISCOVERY on port 0, pid:1785
[  155.328917] sas: ex 5005076a00000a40 phy00:T attached: 50010b9000021585
[  155.328996] sas: ex 5005076a00000a40 phy01:T attached: 50010b9000021575
[  155.329081] sas: ex 5005076a00000a40 phy02:T attached: 50010b900004b87e
[  155.329169] sas: ex 5005076a00000a40 phy03:S attached: 5005076a011061c0

The sas_address and the sas_attached_address are different

> 
> This also means that it is possible to talk about
> a narrow port in the absence of an established
> link but not possible to talk about a wide port
> until there are two or more established links.
> 
> It may also be worth pointing out that there is not data
> aggregation on a wide port, but there is command aggregation.
> So a 2 phy wide port connection will not run a single SCSI
> command twice as fast, but can run two co-incident SCSI
> commands at full link speed (i.e. up to 3 Gbps currently).
> 
>   I believe that the expander situation is not the
> > same as wide port.  If this is the case then it is as simple as changing
> > the printk statement to not say "wide port"
> > 
> > I am more than happy to make these changes if everyone agrees that they
> > should be made.
> 
> It may also be useful to use the term "narrow"
> sometimes, especially if there is a transition
> from wide to narrow (e.g. due to a faulty cable
> or a link reset on one of the links).
> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

