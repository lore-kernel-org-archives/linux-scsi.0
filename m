From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] driverfs scsi for 2.5.24
Date: Wed, 03 Jul 2002 10:34:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207031434.g63EYCv01985@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA07913
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jul 2002 07:34:16 -0700
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Wed, 03 Jul 2002 00:29:38 EDT." <3D227DB2.FD3D151@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: sullivan <sullivan@austin.ibm.com>, Patrick Mochel <mochel@osdl.org>, Martin Dalecki <dalecki@evision-ventures.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

Actually, the patch already went into Linus' BK tree and will be in 2.5.25.

dougg@torque.net said:
> It will probably take a few iterations before we get close to an
> "approved" naming model :-) 

That's part of the reason for putting it in early...

> I'll start with one suggestion: perhaps "kdev" could be replaced by
> two files: "major" and "minor". 

I think kdev belongs in the (not yet implemented) class driver, doesn't it? 
(Pat?), so we shouldn't be doing anything to expose it in SCSI.  If it's done 
at the class level, the kdev policy will be set globally.

I think the partition `name' file should reflect the partition UUID if one 
exists, and that the disc `name' file should be mutable by root so we can do 
fixups (from hotplug) for the exceptional devices that don't have a proper 
unique name.

As far as numeric enumerations go, I think we can begin to move away from 
them.  Everything that has a parent bus no longer needs a host number since it 
has a unique position in the device tree.  The mid-layer itself thinks of host 
enumerations in terms of a linked list, so it doesn't need the number either.  
This way, we should be able to finesse all our complex host addition/removal 
numbering issues that plague 2.4.

I also think that target numbers only make sense when they exist in reality 
(like on a parallel bus).  quite a few fibre channel drivers do internal 
remapping to real target identifiers; I see no reason why they can't just 
expose the ASCII representation of what they use for the device on the bus to 
driverfs now.

LUNs are probably still usefully numeric, but it would be nice to use the 
filesystem hierarchy to represent the SCSI-3 LUN hierarchy.

The key to using driverfs efficiently is to remember that it simply exposes to 
the user how the SCSI subsystem sees the device tree.  Therefore, once we have 
the simplest useful device tree inside SCSI, that will be the way the user 
sees it as well.

James


