From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Adaptec 7XXX/DPT SmartRAID V
Date: Thu, 31 Oct 2002 18:28:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF7F8933F7.64694C72-ONC1256C63.005F0612@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: gnu_is_not_unix <gnu_is_not_unix@wp.pl>
Cc: linux-scsi@vger.kernel.org


Hello,

you are missing the scsihosts boot parameter which a limited mean
for defining the order of your HBAs, e.g.

scsihosts=3Daic7xxx,dpt

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


gnu_is_not_unix <gnu_is_not_unix@wp.pl>@vger.kernel.org on 10/30/2002
09:45:59 PM

Please respond to gnu_is_not_unix <gnu_is_not_unix@wp.pl>

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    Adaptec 7XXX/DPT SmartRAID V



Hello dear linux-scsi subscribers,

I got machine with squid and apache. It is a normal PC (2x550PIII, 400M=
B
ram, SCSI adaptec 2940,
DPT SmartRAID V Controller, network card ...) - nothing special.

[root@bishop root]# lspci
00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridg=
e
(rev 03)
00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge =
(rev
03)
00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:08.0 VGA compatible controller: ATI Technologies Inc 215CT [Mach64 C=
T]
(rev 09)
00:09.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
00:0a.0 PCI bridge: Distributed Processing Technology PCI Bridge (rev 0=
3)
00:0a.1 I2O: Distributed Processing Technology SmartRAID V Controller (=
rev
03)
00:0b.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (=
rev
08)
00:0c.0 SCSI storage controller: Adaptec AHA-2940U/UW / AHA-39xx / AIC-=
7895
(rev 04)
00:0c.1 SCSI storage controller: Adaptec AHA-2940U/UW / AHA-39xx / AIC-=
7895
(rev 04)

[root@bishop root]# lsmod
Module                  Size  Used by    Not tainted
eepro100               20816   1
reiserfs              189824   1  (autoclean)
usb-uhci               25604   0  (unused)
usbcore                77024   1  [usb-uhci]
dpt_i2o                28768   1
aic7xxx               125440   6
sd_mod                 12896  14
scsi_mod              112272   3  [dpt_i2o aic7xxx sd_mod]

System is rh 7.3 with updates and rh kernel (2.4.18 not compiled by my =
self
i mean).
Partitions with system are on the disk on adaptec, directory for squid
cache
on DPT SmartRAID V Controller (raid 0 - 4 x 18 GB)

I got one problem with this configuration. When I try to boot from "my
self" compiled kernel (2.4.18), as first controller, linux recognize DP=
T,
so my root partitions can not be mounted (can not find root fs etc./etc=
=2E).

Booting from rh kernel gives good results:

[root@bishop root]# mount
/dev/sda7 on / type ext2 (rw,nosuid)
none on /proc type proc (rw)
usbdevfs on /proc/bus/usb type usbdevfs (rw)
/dev/sda1 on /boot type ext2 (rw,nosuid,nodev,noexec)
/dev/sdb1 on /cache type reiserfs (rw)
none on /dev/pts type devpts (rw,gid=3D5,mode=3D620)
none on /dev/shm type tmpfs (rw)
/dev/sda8 on /tmp type ext2 (rw,nosuid,nodev,noexec)
/dev/sda6 on /usr type ext2 (rw,nosuid,nodev)
/dev/sda5 on /var type ext2 (rw,nosuid,nodev,noexec)

BIOS shows good order - adaptec is the first, dpt - second.

I know that i can do some workarounds with lilo but it is not good solu=
tion
i think.

Am i missing something ?

ps. sorry for my poor english.

greetz
boka

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
