From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - sd vs. sg Devices, and Low-level Driver.
Date: Wed, 21 Apr 2004 11:12:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFBA@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:7827 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263464AbUDUQMk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:12:40 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org

Thanks so much for the detail information.  It helps a lot!

I didn't realize that both sg and sd will be attached to the same SCSI
disk at the same time after boot.  However, I checked my system, "fdisk
-l" and Hardware Browser->Hard Drives only show /dev/sda but not
/dev/sg0.  How can we check /dev/sg0 is also attached to a SCSI disk?

Besides 'mount' and 'dd', can normal SCSI passthrough ioctl calls
(INQUIRY, READ/WRITE, RESERVE/RELEASE, MODE SELECT/SENSE, PERSISTENT
RESERVATION, etc.) apply to both sd and sg devices?

Best Regards,


Lee


-----Original Message-----
From: Matthew Dharm [mailto:mdharm-scsi@one-eyed-alien.net]
Sent: Tuesday, April 20, 2004 12:56 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - sd vs. sg Devices, and Low-level Driver.


On Tue, Apr 20, 2004 at 11:31:32AM -0500, Lee Xing wrote:
> I really appreciate the information and your help.  It makes sense and
> helps a lot!
> 
> Follow up questions:
> 
> Q1:
> Can we say:
> - if the "Peripheral device type" (bit 0-4 of byte 0) of INQUIRY data
is
> Direct-access device (00h), then this device will be presented as a sd
> device, and
> - if the "Peripheral device type" of INQUIRY data is Scanner device
> (06h), then this device will be presented as a sg device.

No, this is incorrect.

First, 'sg' is not specific to SCANNER devices.  It is the 'generic'
interface, which is compatible for ALL device types.  Thus, the sg
driver
will attach to any device.  Note that sg can be attached to a device at
the
same time as another driver (sg, sr, st, osst, etc.) is attached.

'sg' is used to communicate with scanners because sg provides an
interface
which user-level programs can use to communicate with devices.

> Q2:
> Sounds like the low-level driver just passes the INQUIRY data received
> from the physical device to the mid-level driver.  The mid-level
driver
> then picks up a right upper-level driver (sd, sg, sr or st) depending
on
> the "Peripheral device type" field of INQUIRY data.  The physical
device
> is presented as the type of the upper-level driver being used.  Is it
> right?

This is _basically_ correct.

> Q3:
> Suppose the physical device is a FC disk but we (low-level driver)
still
> want to present it as a sg device (because sg can support up to 256
> physical devices while sd can only support 128).  Can low-level driver
> fool the SCSI sub-system by sending it a fake "Peripheral device type"
> such as Scanner device (06h)?  Are there any potential problems by
doing
> this?  If I remember right, all types of SCSI devices are accessible
via
> the sg driver, right?

First, see my above comments -- sg will attach to anything, regardless
of
PDT code.

Also, while sg will attach to the device, you can't use block-operations
on
an sg device.  That is, programs like 'mount', 'dd', etc. will not
function
on a sg device.  This is likely not what you want to do.

My understanding is that there are patches available to make sg support
a
large number of disks.

Matt

-- 
Matthew Dharm                              Home:
mdharm-usb@one-eyed-alien.net 
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998
