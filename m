From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] driverfs scsi for 2.5.24
Date: Fri, 5 Jul 2002 11:50:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0207051132340.8496-100000@geena.pdx.osdl.net>
References: <3D24FA36.72553709@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D24FA36.72553709@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, sullivan <sullivan@austin.ibm.com>, Martin Dalecki <dalecki@evision-ventures.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


> So will partitions only be visible in the "class" subtree?
> I still want to see an example of what disks (and their
> partitions) will look like in the "class" subtree.

Do you need partitions visible from driverfs at all? They are simply
logical entities on the physical device. What do they get in driverfs,
direcetories? (Sorry, I still haven't looked at the patch; I don't
actually have any SCSI devices any more. But, I will look at it soon. I 
promise.) 

> Patrick Mochel's 3rd July class.txt file gave a networking example:
> 	/devices/class/net/eth
> 	/devices/class/net/eth/eth1
> 	/devices/class/net/eth/eth1/physical  # symlink
> 	/devices/class/net/eth/eth0
> 	/devices/class/net/eth/eth0/physical
> So "net" is the class and "eth" is the subclass under which
> there is an enumeration. Given a "disk" class does it have
> any subclasses? [Answering "scsi" and "ata" would probably not 
> be politically correct.]

I wouldn't think that you would need subclasses for disks. You may have 
multiple interfaces for each disk (there's a few recent messages on lkml 
about this), but that's another story. 

> > LUNs are probably still usefully numeric, but it would be nice to use the
> > filesystem hierarchy to represent the SCSI-3 LUN hierarchy.
> 
> Patrick Mansfield seemed uncomfortable about foregoing
> the existing numeric luns. So perhaps we could keep the
> existing:
> 	uint32_t lun;
> and add
> 	uint8_t lu_id[8];

Out of curiosity, why do you guys use types and not u32, u8, etc? 

> > The key to using driverfs efficiently is to remember that it simply exposes to
> > the user how the SCSI subsystem sees the device tree.  Therefore, once we have
> > the simplest useful device tree inside SCSI, that will be the way the user
> > sees it as well.
...
> >From an OO perspective, "struct device" is a base class from
> which Scsi_Device and Scsi_Host are derived while
> "struct device_driver" is a base class from which
> Scsi_Device_Template and Scsi_Host_Template are derived.
> Patrick Mochel's documents seem to be explaning a virtual
> destructor mechanism as well.

Yes. Both statements are right on. You SCSI guys are so good.

	-pat

