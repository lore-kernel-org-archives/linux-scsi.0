From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: make minimum and maximum linkratesettable quantities
Date: Thu, 7 Sep 2006 08:16:44 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D702E36E6@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:16791 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932152AbWIGOQw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 10:16:52 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, September 06, 2006 10:11 PM, James Bottomley wrote: 
> 
> On Wed, 2006-09-06 at 23:38 -0400, Douglas Gilbert wrote:
> > James Bottomley wrote:
> > > According to SPEC, the minimum_linkrate and 
> maximum_linkrate should be
> >                         ^                    ^
> >                     programmable       programmable
> > > settable by the user.  This patch introduces a callback 
> that allows the
> > > sas class to pass these settings on to the driver.
> > 
> > There are also "hardware" variants of min/max_linkrate.
> 
> hardware rates represent the max and min capabilities of the hw ...
> they're not settable.

Here is info regarding mptfusion.  The min/max linkrate only applies to
the phys, not end devices.   For expanders, we need to use smp_passthru.

For hba phys, we provide config pages.  You can gather linkrate
info by looking in sysfs; e.g. /sys/class/sas_phy/phy-x:y

We provide hardware min/max linkrate for hba via config page
sas_phy_page_0->HwLinkRate.  

We provide programmed min/max linkrate for hba via config page
sas_phy_page_0->ProgrammedLinkRate.

We provide negoiated link rate for hba via config page
sas_iounit_page_0->phy_info[i].NegotiatedLinkRate, where i
is the phy identifier

We provide mechinism to change the max/min linkrate in config page
sas_iounit_page_1->phy_info[i].MaxMinLinkRate, where i 
is the phy identifier.


> That would be why this is implemented with a callback into 
> the HBA.  At
> the moment, the expander functions are done with the SMP functions of
> libsas.  Hopefully, when the mptsas gets an SMP execution function, we
> can move this up into the transport class.
> 

I hope to do this soon, as well as implementing a internal smp
passthru so we can handle the other cases, such as phy link/hard reset,
and link errors for expanders via the same callback handler for hba's
phys.
Right now I'm trying to get caught up on sles10 issues and
enahancements.
I hope things to be caught up in the next week.

Eric
