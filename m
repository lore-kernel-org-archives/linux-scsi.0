From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2a/3] Expose Power Management Policy option to users
Date: Thu, 14 Jun 2007 13:44:23 -0400
Message-ID: <46717E77.3050706@garzik.org>
References: <20070611184146.448266229@intel.com>	<20070611114820.5290a903.kristen.c.accardi@intel.com>	<466DA9DD.8080004@garzik.org>	<20070612104631.44dab4a3.kristen.c.accardi@intel.com>	<1181748408.3421.7.camel@mulgrave.il.steeleye.com> <20070614093952.c8ebef17.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXFNRo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 13:44:27 -0400
In-Reply-To: <20070614093952.c8ebef17.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com

Kristen Carlson Accardi wrote:
> Ok - sorry for my ignorance about SCSI - but my sources (i.e. Arjan) tell 
> me that the problem is that Link in ATA land means something different than 
> Link in SCSI land, and that what I really need to do is leave this code under
> the Host class, but rename it to something that more accurately reflects
> what it means under SCSI.

James' analogy holds, and is even more true once SATA Port Multipliers 
are in the picture.  Then you have remote SATA phys.  And James has 
essentially stated a long term libata problem:  libata wants its own ATA 
transport class, and perhaps a cleaning-up and coalescing of the 
in-kernel SATA phy objects and processes.

The main difference is that SATA doesn't have to worry about target phys 
and initiator phys, largely just the initiator phy.  And phys in SATA 
don't have unique identifiers (WWNs).

I don't think we should delay ALPM in order to complete phy objects and 
an ATA transport class.  But OTOH a transport class may be the best 
place to put these new sysfs nodes.  But#2, that train of logic leads 
one down the road of implementing a minimal ATA transport class across 
all supported ATA devices, which is something that probably only James 
is an expert at (transport classes that is, not ATA).


> Should I rename the file to "segment_power_management_policy"?

No.

	Jeff



