From: Phil Dibowitz <phil@ipom.com>
Subject: 2.6.0-test8: scsi_sysfs.c still not detaching properly
Date: Sun, 19 Oct 2003 12:16:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F92E2F0.2090003@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=------------enig3F7A6A251199834DE5160482;
 protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postal.usc.edu ([128.125.253.6]:11160 "EHLO postal.usc.edu")
	by vger.kernel.org with ESMTP id S262183AbTJSTRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Oct 2003 15:17:17 -0400
Received: from ipom.com (dsl81-phil3.usc.edu [128.125.81.146])
 by postal.usc.edu
 (iPlanet Messaging Server 5.2 HotFix 1.21 (built Sep  8 2003))
 with ESMTPS id <0HN000CHVQURW8@postal.usc.edu> for linux-scsi@vger.kernel.org;
 Sun, 19 Oct 2003 12:16:03 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F7A6A251199834DE5160482
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I'm experiencing a bug similar to the one referenced here:

http://sourceforge.net/mailarchive/message.php?msg_id=6252693

But the patch in that thread has been applied to 2.6.0-test8, which I'm 
running, and I'm still having the same problem - albeit with a different 
device.

The device in question is a Digital Camera (Casio Exilim) that uses the 
usb-storage driver. Basically device files do not get unallocated upon 
disconnect, and thus successive connections get different device files 
associated with them.

When attached, I get the following (and it attaches to sda1):

Oct 19 12:12:20 rider kernel: hub 1-0:1.0: new USB device on port 2, 
assigned address 3
Oct 19 12:12:20 rider kernel: scsi1 : SCSI emulation for USB Mass 
Storage devices
Oct 19 12:12:20 rider kernel:   Vendor: Casio     Model: QV 
DigitalCamera  Rev: 5010
Oct 19 12:12:20 rider kernel:   Type:   Direct-Access 
    ANSI SCSI revision: 02
Oct 19 12:12:21 rider scsi.agent[9314]: how to add device type= at 
/devices/pci0000:00/0000:00:07.2/usb1/1-2/1-2:1.0/host1/1:0:0:0 ??
Oct 19 12:12:21 rider kernel: SCSI device sda: 20208 512-byte hdwr 
sectors (10 MB)
Oct 19 12:12:21 rider kernel: sda: Write Protect is off
Oct 19 12:12:21 rider kernel: sda: cache data unavailable
Oct 19 12:12:21 rider kernel:  sda: sda1
Oct 19 12:12:21 rider kernel: Attached scsi removable disk sda at scsi1, 
channel 0, id 0, lun 0


When unattached, I get:

Oct 19 12:13:14 rider kernel: usb 1-2: USB disconnect, address 3


And the next time I attach, it attaches to sdb1.

Any help would be greatly appreciated.

-- 
Phil Dibowitz                             phil@ipom.com
Freeware and Technical Pages              Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"They that can give up essential liberty to obtain a little temporary
safety deserve neither liberty nor safety."
  - Benjamin Franklin, 1759


--------------enig3F7A6A251199834DE5160482
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)
Comment: Using GnuPG with Debian - http://enigmail.mozdev.org

iD8DBQE/kuLwN5XoxaHnMrsRArqRAKCFVtwWYS9Hko24tQ4qkHMdC+FeGACggOKs
NuunVlD7zXj37W/iGD8BcSA=
=17ZC
-----END PGP SIGNATURE-----

--------------enig3F7A6A251199834DE5160482--

