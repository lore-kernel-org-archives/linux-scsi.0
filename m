From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] driverfs scsi for 2.5.24
Date: Thu, 04 Jul 2002 21:45:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D24FA36.72553709@torque.net>
References: <200207031434.g63EYCv01985@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: sullivan <sullivan@austin.ibm.com>, Patrick Mochel <mochel@osdl.org>, Martin Dalecki <dalecki@evision-ventures.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> 
> Actually, the patch already went into Linus' BK tree and will be in 2.5.25.
> 
> dougg@torque.net said:
> > It will probably take a few iterations before we get close to an
> > "approved" naming model :-)
> 
> That's part of the reason for putting it in early...
> 
> > I'll start with one suggestion: perhaps "kdev" could be replaced by
> > two files: "major" and "minor".
> 
> I think kdev belongs in the (not yet implemented) class driver, doesn't it?
> (Pat?), so we shouldn't be doing anything to expose it in SCSI.  If it's done
> at the class level, the kdev policy will be set globally.
> 
> I think the partition `name' file should reflect the partition UUID if one
> exists, and that the disc `name' file should be mutable by root so we can do
> fixups (from hotplug) for the exceptional devices that don't have a proper
> unique name.

So will partitions only be visible in the "class" subtree?
I still want to see an example of what disks (and their
partitions) will look like in the "class" subtree.

Patrick Mochel's 3rd July class.txt file gave a networking example:
	/devices/class/net/eth
	/devices/class/net/eth/eth1
	/devices/class/net/eth/eth1/physical  # symlink
	/devices/class/net/eth/eth0
	/devices/class/net/eth/eth0/physical
So "net" is the class and "eth" is the subclass under which
there is an enumeration. Given a "disk" class does it have
any subclasses? [Answering "scsi" and "ata" would probably not 
be politically correct.]
 
> As far as numeric enumerations go, I think we can begin to move away from
> them.  Everything that has a parent bus no longer needs a host number since it
> has a unique position in the device tree.  The mid-layer itself thinks of host
> enumerations in terms of a linked list, so it doesn't need the number either.
> This way, we should be able to finesse all our complex host addition/removal
> numbering issues that plague 2.4.

Enumerations seem to be moving to a different level.
 
> I also think that target numbers only make sense when they exist in reality
> (like on a parallel bus).  quite a few fibre channel drivers do internal
> remapping to real target identifiers; I see no reason why they can't just
> expose the ASCII representation of what they use for the device on the bus to
> driverfs now.

According to SAM-2, Annex A, Table A.3 an FCP-2 target
identifier is 3 bytes of binary. The problems arise with
SRP (infiniband), iSCSI and SBP-3 (iee1394). That table
suggests that 262 bytes of UTF-8 (ascii) is the worst case
for an iSCSI initiator port identifier.
In SAM-2 parlance this would suggest an array like:
	uint8_t port_id[262];

> LUNs are probably still usefully numeric, but it would be nice to use the
> filesystem hierarchy to represent the SCSI-3 LUN hierarchy.

Patrick Mansfield seemed uncomfortable about foregoing
the existing numeric luns. So perhaps we could keep the
existing:
	uint32_t lun;
and add
	uint8_t lu_id[8];

That way we keep what REPORT LUNS tells us, and for the
vast majority of cases are able to generate a numeric
lun from it.

> The key to using driverfs efficiently is to remember that it simply exposes to
> the user how the SCSI subsystem sees the device tree.  Therefore, once we have
> the simplest useful device tree inside SCSI, that will be the way the user
> sees it as well.

When I tried to place some of the scsi_debug lower level driver
parameters into driverfs I found nowhere to put them. It seems
that the Scsi_Host_Template structure should have a
"struct device_driver scsi_driverfs_lldriver" entry in it.
The Scsi_Device_Template structure has a "struct device_driver"
entry, why not Scsi_Host_Template?

>From an OO perspective, "struct device" is a base class from
which Scsi_Device and Scsi_Host are derived while
"struct device_driver" is a base class from which
Scsi_Device_Template and Scsi_Host_Template are derived.
Patrick Mochel's documents seem to be explaning a virtual
destructor mechanism as well.

Doug Gilbert
