From: Jonas Schwertfeger <jschwertfeger@gmail.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 13:39:25 +0200
Message-ID: <h2n59ca64281003310439z2f317661xf1d501a5f21c64b3@mail.gmail.com>
References: <Pine.LNX.4.44L0.1003261705340.23253-100000@netrider.rowland.org>
	<4BAD275A.7050903@interlog.com> <59ca64281003300044g53ae5170xaf198bf99964fc36@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51634 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0CaLjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2010 07:39:47 -0400
In-Reply-To: <59ca64281003300044g53ae5170xaf198bf99964fc36@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-hotplug@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Since this seems to have become a udev issue I'm brining the
hotplug/udev list into the loop.

A brief recap for the hotplug list readers: I'm experiencing issues
with a USB 3.0 hard drive (Buffalo HD-HXU3) on kernel 2.6.32.9 with
udev 151. When connected the device seems to be recognized and
registered with xHCI and USB core correctly but then responds to a
bulk transfer with a stall. We narrowed the issue down to udev by
stopping the udev daemon, connecting the device and mounting it
manually. If done this way the drive works fine. However, if udevd is
running the device stalls. Below is an excerpt of the conversation
involving the USB core, the USB storage and the SCSI list.

Any idea what command (most likely coming from udev) could cause the
drive to stall and what could be done about it?

-Jonas

On Fri, Mar 26, 2010 at 7:40 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> I think the amount of information is fine, but I'm not sure why the
> device would respond with a stall to this particular command, so I'm
> CC'ing the USB storage list and SCSI list. =A0Does anyone know what t=
he
> third command is? =A0The USB storage driver reports it as an "unknown
> command". =A0I can see from scsi.h that 0x85 is the code for ATA_16, =
but
> I'm not sure what that command actually does.
>
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403792] usb-storage: =
Command BLANK (12 bytes)
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403794] usb-storage: =
=A0a1 08 2e 00 01 00 00 00 00 ec 00 00
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403800] usb-storage: =
Bulk Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403802] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 31 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403969] usb-storage: =
Status code 0; transferred 31/31
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403972] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403973] usb-storage: =
Bulk command transfer result=3D0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.403975] usb-storage: =
usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409708] usb-storage: =
Status code 0; transferred 512/512
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409709] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409710] usb-storage: =
Bulk data transfer result 0x0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409711] usb-storage: =
Attempting to get CSW...
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409712] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 13 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409854] usb-storage: =
Status code 0; transferred 13/13
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409855] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409856] usb-storage: =
Bulk status result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409858] usb-storage: =
Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409859] usb-storage: =
scsi cmd done, result=3D0x0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.409861] usb-storage: =
*** thread sleeping.
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413870] usb-storage: =
queuecommand called
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413874] usb-storage: =
*** thread awakened.
>
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413876] usb-storage: =
Command (unknown command) (16 bytes)
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413877] usb-storage: =
=A085 06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413882] usb-storage: =
Bulk Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 16
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414229] usb-storage: =
Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.413883] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 31 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414031] usb-storage: =
Status code 0; transferred 31/31
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414032] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414033] usb-storage: =
Bulk command transfer result=3D0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414034] usb-storage: =
Attempting to get CSW...
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414035] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 13 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414179] usb-storage: =
Status code 0; transferred 13/13
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414180] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414181] usb-storage: =
Bulk status result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414182] usb-storage: =
Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414183] usb-storage: =
scsi cmd done, result=3D0x0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414186] usb-storage: =
*** thread sleeping.
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414217] usb-storage: =
queuecommand called
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414222] usb-storage: =
*** thread awakened.
>
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414223] usb-storage: =
Command (unknown command) (16 bytes)
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414224] usb-storage: =
=A085 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414229] usb-storage: =
Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414230] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 31 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414378] usb-storage: =
Status code 0; transferred 31/31
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414379] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414380] usb-storage: =
Bulk command transfer result=3D0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414381] usb-storage: =
usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414458] xhci_hcd 0000=
:03:00.0: WARN: Stalled endpoint
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414529] usb-storage: =
Status code -32; transferred 0/512
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414530] usb-storage: =
clearing endpoint halt for pipe 0xc0008280
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414532] usb-storage: =
usb_stor_control_msg: rq=3D01 rqtype=3D02 value=3D0000 index=3D81 len=3D=
0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414894] usb-storage: =
usb_stor_clear_halt: result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414895] usb-storage: =
Bulk data transfer result 0x2
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414896] usb-storage: =
Attempting to get CSW...
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414897] usb-storage: =
usb_stor_bulk_transfer_buf: xfer 13 bytes
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.414902] xhci_hcd 0000=
:03:00.0: WARN halted endpoint, queueing URB anyway.
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415168] usb-storage: =
Status code 0; transferred 13/13
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415169] usb-storage: =
-- transfer complete
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415170] usb-storage: =
Bulk status result =3D 0
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415171] usb-storage: =
Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415172] usb-storage: =
-- transport indicates error, resetting
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415174] usb-storage: =
usb_stor_pre_reset
> Mar 24 18:53:36 js-workstation kernel: [ =A0253.415204] usb-storage: =
usb_stor_post_reset


On Tue, Mar 30, 2010 at 9:44 AM, Jonas Schwertfeger
<jschwertfeger@gmail.com> wrote:
> On Fri, Mar 26, 2010 at 11:30 PM, Douglas Gilbert <dgilbert@interlog.=
com> wrote:
>>> Booting into a minimal userspace environment (for example, with
>>> init=3D/bin/bash) might prove this.
>>>
>>> No doubt the reason the drive fails to respond is because it can't =
handle
>>> these commands and gets fatally confused.
>>
>> The ATA commands seem to be:
>> =A0 IDENTIFY DEVICE =A0(via the ATA_12 tunnel)
>> =A0 SET FEATURES =A0 =A0 (via the ATA_16 tunnel)
>> =A0 IDENTIFY DEVICE =A0(via the ATA_16 tunnel)
>>
>> The last one fails but that could be caused by
>> the second last one. Doesn't look like smartd.
>> My money would be on udev.
>
> Doug was right. I switched into runlevel 1 and connected the drive.
> Same errors as before. Then, I unplugged it, stopped the udev daemon
> and plugged it back in. Voila, I was able to manually mount the drive
> with no issues.
>
> Where do we go from here? Does anyone know how to debug udev?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
