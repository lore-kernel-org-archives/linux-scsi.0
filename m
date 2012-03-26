From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 26 Mar 2012 16:45:08 -0700
Message-ID: <CAA6KcBAAcmFF3Qs9qtfyXn6Pao4r-muh_bjiV1tqcoPukNMqEg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1203261007290.1384-100000@iolanthe.rowland.org> <224002.28941.qm@web100019.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57221 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2CZXpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2012 19:45:30 -0400
Received: by vcqp1 with SMTP id p1so4777702vcq.19
        for <linux-scsi@vger.kernel.org>; Mon, 26 Mar 2012 16:45:29 -0700 (PDT)
In-Reply-To: <224002.28941.qm@web100019.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: n0diamond@yahoo.co.jp
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Norman --

On Mon, Mar 26, 2012 at 4:30 PM, Norman Diamond <n0diamond@yahoo.co.jp>=
 wrote:
> Executive summary:
> It is probably sd_mod which is too aggressive in failing reads, and w=
hich needs the same fix that libata and linux-ide received a few years =
ago. =A0Now adding the linux-scsi mailing list and quoting my original =
(faulty) report at the bottom of this message.
>
> Matthew Dharm corrected me:
>> Actually, ehci_hcd has nothing to do with this. =A0The problem in li=
kely in sd_mod or the scsi core. =A0Those are the modules that translat=
e your userspace request for a single block into a scsi request, which =
is then processed by usb-storage and passed to the usb core
>
> OK. =A0Since libata and linux-ide had been fixed some years ago, and =
I saw ehci_hcd assigned to the interface I was using yesterday, I blame=
d the wrong victim. =A0I understand it's likely to be sd_mod or usb-sto=
rage.

usb-storage simply translates the requests it gets from the scsi core
(originating in sd_mod or sr_mod or sg or wherever) into a format the
the USB device can understand.  It has no readahead logic in it at
all, and thus is not at fault here.

>
>> So, the problem is that sd_mod is turning your request for a single =
block into a request for several blocks.
>
> That's part of the problem. =A0Readahead is not a bad thing to do. =A0=
The problem is that sd_mod or whoever is too aggressive. =A0Instead of =
marking buffers for nearby blocks as not having valid data available, i=
t further refuses to supply valid data for the good block and errors ou=
t a call that should have succeeded. =A0libata and linux-ide used to ha=
ve the same defect before they were fixed.

Likely, the usb-to-ide bridge can't handle this case well.  The drive
is probably reporting a few blocks of data and then an error, but the
bridge device probably can't handle that case.  This is a pretty
common shortcoming of usb-to-ide bridges.


>> As for needing unplug and replug, likely the firmware in your device=
 is crashing when it encounters a bad block. So there is nothing which =
can be done to recover aside from resetting the device with an unplug/r=
eplug cycle.
>
> The disk's firmware correctly reports a read error when reading the b=
ad block and correctly proceeds to obey later commands to read good blo=
cks if so ordered. =A0This is the same drive that I mounted on a mother=
board's IDE connector a few years ago when testing linux-ide and libata=
=2E =A0However, if you blame the usb-to-ide bridge's firmware, I'll try=
 to find a way to test it.

When Alan and I refer to the 'firmware of the device', we both mean
the usb-to-ide bridge chip (in this case).  If your device happened to
be a usb flash drive, there would be no separate "disk" firmware to
confuse the issue.


> Alan Stern also corrected me:
>> This has nothing at all to do with ehci-hcd. =A0You can prove this (=
assuming your computer has a UHCI or OHCI controller) by unloading ehci=
-hcd and running the test again.
>
> I understand that ehci-hcd can be unloaded and reloaded (well, someti=
mes I can't rmmod some other drivers, but I understand how to try). =A0=
I don't see how that would prove anything though.

Your original report blamed ehci-hcd, but that's just another "glue"
layer.  To establish that it is not at fault, you can use a different
(lower-speed) glue layer, in the form of uhci-hcd or ohci-hcd.  And
EHCI controller almost always has a companion UHCI or OHCI controller,
tho on newer chipsets this isn't necessarily true (Intel now ships
chipsets with a rate-matching TT-capable EHCI hub in them, and thus no
"companion" controller).

>> ehci_hcd does not try to reassign anything. =A0Rather, it is usb-sto=
rage which resets the non-working device.
>
> OK. =A0I have a feeling that usb-storage is overly aggressive in rese=
tting a device and trying to assign a new address. =A0The drive does no=
t need resetting; I mentioned above that it correctly reports a bad blo=
ck and correctly continues operating. =A0Though if the USB-to-IDE bridg=
e is to blame, I'll try to find a way to test it.

Again, we are referring to the bridge firmware. usb-storage will only
attempt to reset the device if the device has failed to respond
properly in a "reasonable" amount of time (as defined in the original
request from the SCSI layer).  That is often 30-seconds or so.

>> If the device were working properly, unplugging and replugging it wo=
uldn't be necessary. =A0The failure is entirely the device's fault.
>
> I do not believe that. =A0The drive's report of failure to read a bad=
 block is correct operation by the drive. =A0Mishandling of a correct e=
rror report is the fault of the driver that mishandles the report.

The drive's report of failure is likely getting totally lost by the
usb-to-ide bridge.  Again, this is pretty common among usb-to-ide
bridges.

Matt

--=20
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
