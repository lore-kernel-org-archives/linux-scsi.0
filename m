From: Mikael Pettersson <mikpe@csd.uu.se>
Subject: Re: 2.6.8.1-mm3
Date: Sat, 21 Aug 2004 20:38:30 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408211838.i7LIcUdl025108@harpo.it.uu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aun.it.uu.se ([130.238.12.36]:24037 "EHLO aun.it.uu.se")
	by vger.kernel.org with ESMTP id S267631AbUHUSil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 14:38:41 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I wrote:
> > > This one is broken. It causes the kernel to emit a bogus
> > > "program $PROG is using a deprecated SCSI ioctl, please convert it to SG_IO"
> > > message whenever user-space open(2)s a SCSI block device, even
> > > though user-space never did any ioctl() on it.
> > 
> > A simple open of /dev/sda from userland doesn't exhibit this behaviour
> > for me.  What sort of device is this?  And what is the program?
> 
> It happens on my USB flash memory stick, which uses USB_STORAGE and BLK_DEV_SD.
> A simple open(2) is enough to trigger the message. I'm about to try -mm3 on a
> different machine which has a "true" SCSI controller/disk combo. (I should
> have checked that first, sorry.)

I checked now, and I can also trigger the message on ide-scsi + sr
(CD writer), but not on ide-scsi + st (ATAPI tape drive) or on
a SCSI disk on a SYM53C8XX controller.

So it seems both usb storage and ide-scsi (or the cdrom module)
generate these ioctls.
