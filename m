From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 10 Oct 2003 17:16:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065827781.2877.1.camel@patehci2>
References: <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
	 <20031007000018.B11937@one-eyed-alien.net>  <20031007070404.GU972@suse.de>
	 <1065818209.7434.11.camel@patehci2>  <1065819846.7434.35.camel@patehci2>
	 <1065821134.7434.46.camel@patehci2>  <1065825799.2867.38.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:18165 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263229AbTJJXQh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 19:16:37 -0400
In-Reply-To: <1065825799.2867.38.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

I have a new guess of precisely when we want cdrom to probe for
capabilities beyond those discovered by ide-cd and sr.

I'm now guessing we want to author additional cdb's at the end of
register_cdrom, just after such optional messages as 'cdrom: drive
"/dev/sr0" registered'.

To leap to that conclusion, I reasoned as follows.  Somebody tell me how
wrong I am?

Pat LaVarre

1)

I found cdrom.c ERRLOGMASK.  I see our default is to pass thru just the
CD_WARNING cdrom: messages.  I see the last commented-out #define means
pass thru all the defined types of cdrom: messages.

2)

I see with usb cdb's unmasked, hot plug spews the dmesg:

Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
x 12 00 00 00 24 00
x 12 00 00 00 C0 00
  Vendor: Iomega    Model: RRD               Rev: 36.D
  Type:   CD-ROM                             ANSI SCSI revision: 02
WARNING: USB Mass Storage data integrity not assured
USB Mass Storage device found at 2
drivers/usb/core/usb.c: registered new driver usb-storage
USB Mass Storage support registered.
updfstab: numerical sysctl 1 23 is obsolete.

3)

I see with cdrom messages also unmasked, the one block write `sudo dd
of=/dev/scd0 bs=2K count=1 if=/dev/zero` provokes the spew:

x 00 00 00 00 00 00
x 03 00 00 00 12 00
x 00 00 00 00 00 00
x 5A 00 2A 00 00 00 00 00 80 00
sr0: scsi3-mmc drive: 125x/125x caddy
cdrom: entering register_cdrom
Uniform CD-ROM driver Revision: 3.12
cdrom: drive "/dev/sr0" registered
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
cdrom: entering cdrom_open
cdrom_cdc_mmc_wr
cdrom: entering open_for_data
x 00 00 00 00 00 00
cdrom: drive_status=4
cdrom: entering cdrom_count_tracks
x 43 00 00 00 00 00 00 00 0C 00
x 43 02 00 00 00 00 01 00 0C 00
cdrom: track 1: format=2, ctrl=4
cdrom: disc has 1 tracks: 0=audio 1=data 0=Cd-I 0=XA
cdrom: all seems well, opening the device.
x 25 00 00 00 00 00 00 00 00 00
cdrom: opening the device gave me 0.
x 1E 00 00 00 01 00
cdrom: door locked.
cdrom: device opened successfully.
cdrom: Use count for "/dev/sr0" now 1
x 00 00 00 00 00 00
x 43 00 00 00 00 00 00 00 0C 40
x 43 00 00 00 00 00 00 00 0C 00
x 43 00 00 00 00 00 01 00 0C 00
x 28 00 00 00 00 00 00 00 02 00
x 2A 00 00 00 00 00 00 00 02 00
cdrom: entering cdrom_release
cdrom: Use count for "/dev/sr0" now zero
cdrom: Unlocking door!
x 1E 00 00 00 00 00


