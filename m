From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Sysfs does not recognise tape devices ?
Date: Sun, 9 Nov 2003 23:23:17 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311092302440.2506@kai.makisara.local>
References: <018f01c3a397$e093d600$a0074d0a@apac.cisco.com>
 <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local> <3FAAD28D.4050803@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:59035 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262797AbTKIVXT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2003 16:23:19 -0500
In-Reply-To: <3FAAD28D.4050803@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org

On Fri, 7 Nov 2003, Douglas Gilbert wrote:

> Kai Makisara wrote:
...
> > The tapes should be visible as SCSI devices in, e.g.,
> > /sys/bus/scsi/devices/. You can find disks in /sys/block. The tapes belong
> > to /sys/cdev but it is a very new addition to sysfs and the code to show
> > the tapes there has not been done yet. It should be very easy based on
> > Doug Gilberts code for sg but the feature freeze will prevent adding it
> > to the official kernel for some time.
>
> Kai,
> It would be interesting to see what model you propose for
> /sys/cdev and st. I felt that the cdev mechanism
> was "three-quarter baked" when I used it for sg. It is flat
> with no obvious support for driver parameters (unless I set
> up a dummy "device" like /sys/cdev/major/sg/<driver_params>).
>
One possibility might be to add a link from each device to the driver
directory in /sys/bus/scsi/drivers/. I guess the correct kobject could be
found following pointers from struct scsi_device.

I would like to see a little more structure in /sys/cdev. The flat layout
makes the directory very crowded when more drivers start using it. My
understanding, ba is that the current layout may not be the final one.

> For a tape device the /sys/class/scsi_device/<h:c:t:l>/device
> directory should have a symlink called "tape" but what to?
> The st driver has a one to many mapping here; multiple
> symlinks?
>
In the first version of cdev support (just sent to linux-scsi) I made the
link "tape" to point to the non-rewind mode 0 tape. It leads to the
correct directory but the user must then generate the names leading to the
other devices using the same drive. Multiple links would be another
possibility but I think it would only move generating the different names
to the SCSI device directory.

All of these problems would be solved if the character device model would
allow collections of devices. Each tape drive would be a subdirectory
containing the entries for the different devices corresponding to this
drive. I think there are other character devices that would benefit from
this, too.

On the other hand, the character devices contain a very diverse set of
devices. Maybe it is not useful to try to define any structure among them.

-- 
Kai
