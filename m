From: Matt_Domsch@Dell.com
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 11:11:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <71714C04806CD51193520090272892170452B5C5@ausxmrr502.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
List-Id: linux-scsi@vger.kernel.org
To: sullivan@austin.ibm.com, linux-scsi@vger.kernel.org

> I have been working on a prototype to allow the persistent 
> naming of scsi devices across boots. The prototype attempts 
> to address the namespace slippage that occurs when names are 
> assigned based on discovery order or topology, and a hardware 
> configuration change occurs. It does this by assigning names 
> based on the characteristics of the device.

> I think we should rather get people
> to actually use the UUID= option to mount..

Agreed.  Andreas' swap partition patches are needed here too.

The only other case this is tricky is at clean-disk install time, before any
UUIDs are available, when you've got disks on multiple controllers.  Here,
the BIOS and Linux have no way to communicate which device they each think
is the boot device.  Some BIOSs (like on Adaptec 39160 add-in cards, and
7890/7899 embedded controllers on Dell servers) provide BIOS Enhanced Disk
Device Services 3.0 (EDD 3.0), which provides an extension to BIOS int13
AX=48 which specifies, for BIOS's idea of device 80, 81, ..., the PCI
bus/dev/fn and type (SCSI/IDE,...) Not all BIOSs yet provide such. :-(  But,
having that, Linux could then compare its similar mapping, and get right
without manual intervention what disk is the boot disk.

-Matt
--
Matt Domsch
Sr. Software Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
#1 US Linux Server provider for 2001!
