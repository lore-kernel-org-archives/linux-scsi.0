From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.6.0-test8: scsi_sysfs.c still not detaching properly
Date: Sun, 19 Oct 2003 17:15:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031019171535.A16583@beaverton.ibm.com>
References: <3F92E2F0.2090003@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:33002 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262337AbTJTAQK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2003 20:16:10 -0400
Content-Disposition: inline
In-Reply-To: <3F92E2F0.2090003@ipom.com>; from phil@ipom.com on Sun, Oct 19, 2003 at 12:16:00PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Phil Dibowitz <phil@ipom.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 19, 2003 at 12:16:00PM -0700, Phil Dibowitz wrote:
> I'm experiencing a bug similar to the one referenced here:
> 
> http://sourceforge.net/mailarchive/message.php?msg_id=6252693

That page gives me "Message Not Found".

> But the patch in that thread has been applied to 2.6.0-test8, which I'm 
> running, and I'm still having the same problem - albeit with a different 
> device.

> The device in question is a Digital Camera (Casio Exilim) that uses the 
> usb-storage driver. Basically device files do not get unallocated upon 
> disconnect, and thus successive connections get different device files 
> associated with them.
> 
> When attached, I get the following (and it attaches to sda1):
> 
> Oct 19 12:12:20 rider kernel: hub 1-0:1.0: new USB device on port 2, 
> assigned address 3
> Oct 19 12:12:20 rider kernel: scsi1 : SCSI emulation for USB Mass 
> Storage devices
> Oct 19 12:12:20 rider kernel:   Vendor: Casio     Model: QV 
> DigitalCamera  Rev: 5010
> Oct 19 12:12:20 rider kernel:   Type:   Direct-Access 
>     ANSI SCSI revision: 02
> Oct 19 12:12:21 rider scsi.agent[9314]: how to add device type= at 
> /devices/pci0000:00/0000:00:07.2/usb1/1-2/1-2:1.0/host1/1:0:0:0 ??
> Oct 19 12:12:21 rider kernel: SCSI device sda: 20208 512-byte hdwr 
> sectors (10 MB)
> Oct 19 12:12:21 rider kernel: sda: Write Protect is off
> Oct 19 12:12:21 rider kernel: sda: cache data unavailable
> Oct 19 12:12:21 rider kernel:  sda: sda1
> Oct 19 12:12:21 rider kernel: Attached scsi removable disk sda at scsi1, 
> channel 0, id 0, lun 0
> 
> 
> When unattached, I get:
> 
> Oct 19 12:13:14 rider kernel: usb 1-2: USB disconnect, address 3
> 
> 
> And the next time I attach, it attaches to sdb1.
> 
> Any help would be greatly appreciated.

Can you delete it prior to physical removal via the sysfs attribute (echo
foo > /sysfs/bus/scsi/devices/1:0:0:0/delete)? If that doesn't work, you
might be running an older kernel.

Is the device umounted (not open) when you disconnect it? If not, try
Mike's recent patch (or try his patch anyway). But I would expect to see
an oops or other odd behaviour in that case.

-- Patrick Mansfield
