From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] first cut at infrastructure for handling different
	devicetypes in the sas class
Date: Mon, 06 Mar 2006 10:39:12 -0600
Message-ID: <1141663153.3167.20.camel@mulgrave.il.steeleye.com>
References: <1141445103.5397.19.camel@mulgrave.il.steeleye.com>
	 <004201c63fb7$ee8b4ef0$1e1015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63432 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751882AbWCFQjT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 11:39:19 -0500
In-Reply-To: <004201c63fb7$ee8b4ef0$1e1015ac@ericmoore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2006-03-04 at 11:17 -0700, Moore, Eric wrote:
> I'm not clear what your intent is here.  All the info is there, so I'm not sure
> why this change is needed.  The sas_transport implementation Christoph
> has layed out is a flat model.  In /sys/class/sas_phy, you will see all the
> phys for both hba and expander all togeather in the tree.The rphy is at the 
> end of  a phy link, where it the target protocol could be SMP, STP, SATA, 
> or SAS; e.g. you can see that in rphy->identify.target_port_protocols.  
> You can figure out whether its an end device by the attribute by 
> rphy->indentify.device_type, which could be SAS_END_DEVICE, 
> SAS_EDGE_EXPANDER,  SAS_FANOUT_EXPANDER, or 
> SAS_PHY_UNUSED.  

Well, it's not ... the nexus loss timeout parameters weren't available.
The intent is to embed the rphys into more representative structures
that can have different parameters (an expander has parameters than an
end device doesn't and vice versa).  Eventually, when the whole lot is
converted, the ability to alloc a plain rphy will be revoked and
everything will be done via the real device type.

The aic94xx needs a full tree representation for this, so I'm planning
to add this to the sas transport class.  We really need to work out a
way for mptsas to display the tree too.  Having different topology views
for the same physical SAS topology show up when you change HBA is a bit
undesirable.

> > Temporarily, because mptsas doesn't do this, I've put a flag in to
> > indicate whether the rphy is enveloped or not, however, if we enforce
> > this for everything, then eventually that would go away.
> > 
> 
> Ok, I'm not sure what this comment means, in respect to mptsas.
> The mptsas driver is reporting all device types to the transport class, 
> as defined in the SAS spec.

It means I couldn't be bothered to add the end device allocations to
mptsas, so the code currently understands that there's a separate flag
that says whether it can be cast out to the end device or not.

> > If everyone's OK with this, I'll do expanders next.
> 
> Ok, the mptsas driver is already reporing expanders to transport class.  
> This is handled from mptsas.c, in mptsas_probe_one_phy(), when
> we call sas_phy_add().  When there is any attached devices  at
> the end of a phy, we call  sas_rphy_add().  Both these functions 
> exported from sas_transport, work well for both hba, and expanders.
> 
> The patch I sent yesterday is adding support when someone needs to 
> add a expander after the start of day, or reomove one.  Its responding
> to the firmware DISCOVERY event.

Yes, I know.  However, I need expander devices that contain the
necessary information to be able to perform discovery in the sas
transport class, so they'll appear eventually in the same way that this
patch adds end devices ... as objects with embedded rphys.

James


