From: Kristian Eide <kreide@online.no>
Subject: FW: RE: [Linux-usb-users] USB and iPod detection problem
Date: Mon, 8 Sep 2003 17:17:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F5F8EA0@epostleser.online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail41-s.fg.online.no ([148.122.161.41]:31619 "EHLO
	mail41.fg.online.no") by vger.kernel.org with ESMTP id S262566AbTIHPR1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2003 11:17:27 -0400
Received: from epostleser.online.no (epostleser14.frisurf.no [148.122.3.22])
	by mail41.fg.online.no (8.9.3p2/8.9.3) with ESMTP id RAA26834
	for <linux-scsi@vger.kernel.org>; Mon, 8 Sep 2003 17:17:14 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>===== Original Message From Matthew Dharm <mdharm-usb@one-eyed-alien.net> 
=====
> Additional sense indicates Logical unit is in process of becoming ready

The SCSI layer should wait in response to the sense data that indicates LUN
becoming ready.

I suggest taking this up with the SCSI folks.

Matt

On Mon, Sep 08, 2003 at 12:32:31AM +0200, Kristian Eide wrote:
> I recently aquired a 30GB iPod and tried to connect it to my portable Dell
> X200 running Mandrake 9.1. It works, but it seems there is a problem with 
the
> iPod HD not spinning up fast enough for proper detection to take place. The
> following is from the output of 'dmesg' when I plug in my iPod:
>
> usb-uhci.c: interrupt, status 2, frame# 1601
> usb.c: USB device not accepting new address=3 (error=-110)
> hub.c: new USB device 00:1d.0-1, assigned address 4
> usb.c: USB device not accepting new address=4 (error=-110)
> hub.c: new USB device 00:1d.0-1, assigned address 5
> scsi0 : SCSI emulation for USB Mass Storage devices
>   Vendor: Apple     Model: iPod              Rev: 1.40
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> WARNING: USB Mass Storage data integrity not assured
> USB Mass Storage device found at 5
> Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
> usb-uhci.c: interrupt, status 3, frame# 52
> sda : READ CAPACITY failed.
> sda : status = 1, message = 00, host = 0, driver = 08
> Current sd00:00: sense key Not Ready
> Additional sense indicates Logical unit is in process of becoming ready
> sda : block size assumed to be 512 bytes, disk size 1GB.
>  /dev/scsi/host0/bus0/target0/lun0: I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 2097144
>  I/O error: dev 08:00, sector 2097144
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 0
> ldm_validate_partition_table(): Disk read failed.
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 2
>  unable to read partition table
> VFS: Disk change detected on device 08:00
> sda : READ CAPACITY failed.
> sda : status = 1, message = 00, host = 0, driver = 08
> Current sd00:00: sense key Not Ready
> Additional sense indicates Logical unit is in process of becoming ready
> sda : block size assumed to be 512 bytes, disk size 1GB.
> sda: test WP failed, assume Write Enabled
>  /dev/scsi/host0/bus0/target0/lun0: I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 2097144
>  I/O error: dev 08:00, sector 2097144
>  I/O error: dev 08:00, sector 0
>  I/O error: dev 08:00, sector 0
> ldm_validate_partition_table(): Disk read failed.
>  I/O error: dev 08:00, sector 0
> VFS: Disk change detected on device 08:00
> SCSI device sda: 58595040 512-byte hdwr sectors (30001 MB)
> sda: Write Protect is off
>  /dev/scsi/host0/bus0/target0/lun0: p1 p2
>
> Especially the "sda : block size assumed to be 512 bytes, disk size 1GB." is 
a
> problem as the kernel only thinks the HD is 1GB while the partition table of
> course says 30GB. I can solve it by disconnecting and quickly reconnecting 
the
> iPod as the HD will then already be spun up and it is detected correctly as
> seen above.
>
> Perhaps the USB drivers can be made to wait a bit in case the device does 
not
> seem ready, or perhaps an exception with extra waiting time in the case of 
the
> iPod?
>
> Thanks.
>
> --
> Kristian
>
>
>
> -------------------------------------------------------
> This sf.net email is sponsored by:ThinkGeek
> Welcome to geek heaven.
> http://thinkgeek.com/sf
> _______________________________________________
> Linux-usb-users@lists.sourceforge.net
> To unsubscribe, use the last form field at:
> https://lists.sourceforge.net/lists/listinfo/linux-usb-users

--
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.net
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/W8XDIjReC7bSPZARAlEYAKDKJf4eQ7jSc3T0reG9cKWE5SIk3gCdEKAf
fFeu/2If18tC1M15N1TcxUo=xS/y
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

