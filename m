From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Help - sd vs. sg Devices, and Low-level Driver.
Date: Tue, 20 Apr 2004 11:31:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFB3@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:43303 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S263582AbUDTQbf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 12:31:35 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi@vger.kernel.org

I really appreciate the information and your help.  It makes sense and
helps a lot!

Follow up questions:

Q1:
Can we say:
- if the "Peripheral device type" (bit 0-4 of byte 0) of INQUIRY data is
Direct-access device (00h), then this device will be presented as a sd
device, and
- if the "Peripheral device type" of INQUIRY data is Scanner device
(06h), then this device will be presented as a sg device.

Q2:
Sounds like the low-level driver just passes the INQUIRY data received
from the physical device to the mid-level driver.  The mid-level driver
then picks up a right upper-level driver (sd, sg, sr or st) depending on
the "Peripheral device type" field of INQUIRY data.  The physical device
is presented as the type of the upper-level driver being used.  Is it
right?

Q3:
Suppose the physical device is a FC disk but we (low-level driver) still
want to present it as a sg device (because sg can support up to 256
physical devices while sd can only support 128).  Can low-level driver
fool the SCSI sub-system by sending it a fake "Peripheral device type"
such as Scanner device (06h)?  Are there any potential problems by doing
this?  If I remember right, all types of SCSI devices are accessible via
the sg driver, right?

Many thanks,


Lee


-----Original Message-----
From: Matthew Dharm [mailto:mdharm-scsi@one-eyed-alien.net]
Sent: Monday, April 19, 2004 7:06 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: Help - sd vs. sg Devices, and Low-level Driver.


On Mon, Apr 19, 2004 at 06:39:53PM -0500, Lee Xing wrote:
> Hi,
> 
> These are newbi questions on sd and sg devices and low-level SCSI
driver.  Any information would be appreciated.
> 
> Q1:
> When the low-level SCSI driver registers a physical disk, which
parameters (in scsi_device or some other structs?) decide this physical
disk will be registered/presented as a sd or sg device and how?  I
presume the low-level driver makes the decision which type of device (sd
or sg) the physical disk is registered/presented as, but I can be wrong.
> 

The device type code in the INQUIRY response is used to determine this.
The low-level driver doesn't have to do anything to make this happen.

Also, 'sg' can attach to any type of device _at_the_same_time_ as 'sd'.
'sg' is "generic", after all.

> Q2:
> >From low-level driver coding/maintenance point of view, which one is
easier, registering/presenting a physical disk as a sd or sg device?

Like I said, it's a non-issue for a low-level driver.

Matt

-- 
Matthew Dharm                              Home:
mdharm-usb@one-eyed-alien.net 
Maintainer, Linux USB Mass Storage Driver

Okay, this isn't funny anymore! Let me down!  I'll tell Bill on you!!
					-- Microsoft Salesman
User Friendly, 4/1/1998
