From: Douglas Gilbert <dougg@torque.net>
Subject: SCSI, MMC, SAS and SATA power management
Date: Thu, 11 Aug 2005 16:24:46 +1000
Message-ID: <42FAEF2E.3090102@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

While looking into implementing the START STOP UNIT
SCSI command for SATA disks, I spent some time looking
at power management state machines in various standards.
It is pretty confusing stuff so I have made a web page to
summarise the various states. See:
http://www.torque.net/sg/power.html


One linux (or device) problem I noticed while looking
at this was how lk 2.6.13-rc6 reacts when an ATAPI
cd/dvd drive is placed into SLEEP state. This isn't
a normal thing to do but can be done thus:
   sg_start -pc=5 /dev/hdd
where sg_start is found in the sg3_utils package. The
ATA8-ACS draft says that the device should first respond
to a SLEEP ATA command and thereafter not respond to
any commands until a reset occurs. One would think that
the MMC equivalent (i.e. START STOP UNIT command
[power_condition=5]) should react the same way. What I
observed on my laptop was about 10 minutes of timeouts
(with a message about lost interrupts every minute)
before things stabilised. Same thing occurred on a desktop
with a recent LG DVD+-R DL drive. I don't think kscd
polling the drive was helping.

Doug Gilbert
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFC+u8unayo+9E+FQIRAknJAJ9wGSGIuhK7Hhd5gTd4bIj08GD+jACgovDm
q+/tSP5uo2LIFbQwENqc2j4=
=43KH
-----END PGP SIGNATURE-----
