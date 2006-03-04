From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [RFC] first cut at infrastructure for handling different devicetypes in the sas class
Date: Sat, 4 Mar 2006 11:17:42 -0700
Message-ID: <004201c63fb7$ee8b4ef0$1e1015ac@ericmoore>
References: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42642 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932276AbWCDSRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2006 13:17:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Friday, March 03, 2006 9:05 PM, James Bottomley wrote:


> This one actually does the end devices, since that's all I really have
> to work with in my setup.  However, I can do the expanders in the same
> way.  The idea is to make the rphy embedded in the enveloping device
> structure, so the code which doesn't care about type can still treat the
> code as a simple rphy, and the code that does care can cast out to the
> device type.

I'm not clear what your intent is here.  All the info is there, so I'm not sure
why this change is needed.  The sas_transport implementation Christoph
has layed out is a flat model.  In /sys/class/sas_phy, you will see all the
phys for both hba and expander all togeather in the tree.The rphy is at the 
end of  a phy link, where it the target protocol could be SMP, STP, SATA, 
or SAS; e.g. you can see that in rphy->identify.target_port_protocols.  
You can figure out whether its an end device by the attribute by 
rphy->indentify.device_type, which could be SAS_END_DEVICE, 
SAS_EDGE_EXPANDER,  SAS_FANOUT_EXPANDER, or 
SAS_PHY_UNUSED.  

> 
> Temporarily, because mptsas doesn't do this, I've put a flag in to
> indicate whether the rphy is enveloped or not, however, if we enforce
> this for everything, then eventually that would go away.
> 

Ok, I'm not sure what this comment means, in respect to mptsas.
The mptsas driver is reporting all device types to the transport class, 
as defined in the SAS spec.

> If everyone's OK with this, I'll do expanders next.

Ok, the mptsas driver is already reporing expanders to transport class.  
This is handled from mptsas.c, in mptsas_probe_one_phy(), when
we call sas_phy_add().  When there is any attached devices  at
the end of a phy, we call  sas_rphy_add().  Both these functions 
exported from sas_transport, work well for both hba, and expanders.

The patch I sent yesterday is adding support when someone needs to 
add a expander after the start of day, or reomove one.  Its responding
to the firmware DISCOVERY event.

Eric Moore



