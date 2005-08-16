From: James.Smart@Emulex.Com
Subject: RE: [PATCH] add transport class symlink to device object
Date: Mon, 15 Aug 2005 20:52:53 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD39@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47243 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S965051AbVHPAxc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 20:53:32 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, matthew@wil.cx
Cc: greg@kroah.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk

Actually, I view this as being a little odd...

What is "0000:00:04:0" in this case ? The "device" is not a serial
port, which is what the ttyXX back link would lead you to believe.
Thus, it's a serial port multiplexer that supports up to N ports,
right ? and wouldn't the more correct representation have been to
enumerate a device for each serial port ? (e.g. 0000:00:04.0/line0,
0000:00:04.0/line1, or similar)

Think if SCSI used this same style of representation. For example,
if there was no scsi target device entity, but class entities did
exist and they just pointed back to the scsi host device entry.

My vote is to make the multiplexor instantiate each serial line
as a separate device.

-- james s

> On Sun, 2005-08-14 at 16:02 +0100, Matthew Wilcox wrote:
> > /sys/class/tty/ttyS0/device -> 
> ../../../devices/parisc/0/0:0/pci0000:00/0000:00:04.0
> > /sys/class/tty/ttyS1/device -> 
> ../../../devices/parisc/0/0:0/pci0000:00/0000:00:04.0
> > /sys/class/tty/ttyS2/device -> 
> ../../../devices/parisc/0/0:0/pci0000:00/0000:00:04.0
> > /sys/class/tty/ttyS3/device -> 
> ../../../devices/parisc/0/0:0/pci0000:00/0000:00:05.0
> > /sys/class/tty/ttyS4/device -> 
> ../../../devices/parisc/0/0:0/pci0000:00/0000:00:05.0
> 
> Actually, isn't the fix to all of this to combine Greg and James'
> patches?
> 
> The Greg one fails in SCSI because we don't have unique class device
> names (by convention we use the same name as the device bus_id) and
> James' one fails for ttys because the class name isn't 
> unique.  However,
> if the link were derived from something like
> 
> <class name>:<class device name>
> 
> Then is would be unique in both cases.
> 
> Unless anyone can think of any more failing cases?
> 
> James
> 
> 
> 
