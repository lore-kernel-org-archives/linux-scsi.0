From: Eric GAUDET <eric@rti-zone.org>
Subject: 2.4.20 scsi problem
Date: Sun, 01 Dec 2002 22:58:45 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <XFMail.20021201225845.eric@rti-zone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr, axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Dear sir,

I'm writing to you since you're in the linux kernel maintainers list as=
 the
SCSI and block device subsystem guys.
I'm not sure you guys are really maintainers anymore, so I take the ris=
k of
cc-ing the mailing list.

I just downloaded linux kernel 2.4.20 sources and compiled them to upgr=
ade from
2.4.18.

I'm seeing a problem with the scsi subsystem: there is no block-major-8=
 device
registered. I am using a laptop with scsi-pcmcia adapter, and usb-stora=
ge scsi
emulation, but no low-level driver. I can use my usb cdrom drive (sr de=
vice
used by usb-storage).
But, after inserting my pcmcia adapter or pluging in my usb-storage dev=
ive, I
cannot mount the disk (/dev/sda1 in my case) as I used to with 2.4.18.
The only error message is:
modprobe: modprobe: Can't locate module block-major-8

Here's the information I think is relevant to the problem. If you need =
more,
please let me know.

My configuration file shows the following:
#
# SCSI support
#
CONFIG_SCSI=3Dy
#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
CONFIG_SD_EXTRA_DEVS=3D40
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dy
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_SR_EXTRA_DEVS=3D4
CONFIG_CHR_DEV_SG=3Dm  =20
#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_DEBUG_QUEUES=3Dy
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
#
# SCSI low-level drivers
#
(none set)

A cat /proc/devices gives me:
Block devices:
  2 fd
  3 ide0
  7 loop
 11 sr
 43 nbd

A lsmod:
Module                  Size  Used by    Not tainted
sg                     28796   0  (unused)
usb-storage            22968   0=20

Dmesg gives:
=2E..
SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2
Linux Kernel Card Services 3.1.22
  options:  [pci] [cardbus] [pm]
=2E..

A cat /proc/scsi/scsi gives me;
Attached devices:=20
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: PHILIPS  Model: PCRW406          Rev: I2,2
  Type:   CD-ROM                           ANSI SCSI revision: 02

When pluging my usb-storage hard drive, it=B4s recognized by usb-storag=
e just
fine and shows as scsi1.

Compiling sd as a module instead of in the kernel does not seem to chan=
ge
anything. Nor compiling with a scsi low-level driver. It seems that I n=
eed an
actual scsi device at boot time in order to see block device 8 (not tes=
ted, I
don=B4t have such a device)

Thanks,
-----------------------------------------------------------------------=
-
Eric GAUDET <eric@rti-zone.org>
Le 01-Dec-2002 a 18:32:24
-----------------------------------------------------------------------=
-

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
