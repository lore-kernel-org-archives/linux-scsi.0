From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: How to find which (physical) SCSI HBA corresponds to which ho	st n umber?
Date: Sat, 2 Apr 2005 08:31:33 -0600
Message-ID: <20050402143133.GA21096@lists.us.dell.com>
References: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com> <1112389623.5776.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:29206 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S261516AbVDBObd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 09:31:33 -0500
Content-Disposition: inline
In-Reply-To: <1112389623.5776.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, "Rajat Jain, Noida" <rajatj@noida.hcltech.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 01, 2005 at 03:07:02PM -0600, James Bottomley wrote:
> On Fri, 2005-04-01 at 09:47 -0800, Bryan Henderson wrote:
> > If you and Linux could identify the host in common terms, you wouldn't 
> > have to do this.  But the question is open as to in what terms you 
> > personally identify the host to which you attached the device.  Is it the 
> > controller to the west?  The red one?  The new one?  The one with serial 
> > number 8436547?  The one at PCI address X:Y:Z?  The one that has your disk 
> > drives on it?
> 
> I'm not very good on 2.4, but I believe it has a SCSI_IOCTL_GET_PCI.

Yes, but that only works when called on a Scsi_Device attached to the
controller.  So each controller needs at least one scsi device (disk,
cdrom, whatever) attached, such that there's a /dev/sd* file to open
and call this ioctl.  That'll get you the pci bus:dev.fn tuple.  Then
on x86 systems at least, the PCI IRQ Routing Table ($PIR table in
BIOS) can tell you if your device is embedded or add-in, and which
slot number BIOS calls it.  A copy of David A. Hinds' dump_pirq script
can be found here:  http://linux.dell.com/files/tools/dump_pirq

Device 00:04.0 (slot 0): Ethernet controller
Device 00:06.0 (slot 0):
Device 00:08.0 (slot 1): Class ff00
Device 00:0f.0 (slot 0): Host bridge
Device 01:08.0 (slot 0): PCI bridge
Device 01:06.0 (slot 0): Ethernet controller
Device 02:06.0 (slot 0): SCSI storage controller
Device 03:06.0 (slot 2):
Device 03:08.0 (slot 3):
Device 08:06.0 (slot 4):
Device 08:08.0 (slot 5):
Device 0d:06.0 (slot 6): RAID bus controller
Device 0d:08.0 (slot 7):

Slot 0 lines are embedded, the other values should pretty closely
correspond to the silkscreen text on the motherboards.


That's about as close as you get.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
