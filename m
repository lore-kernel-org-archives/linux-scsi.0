From: Philip Hands <phil@hands.com>
Subject: need help diagnosing sym53c1010-33/Fujitstu MAN3367MP/raid1 lockups
Date: 03 Jul 2002 11:53:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1025693615.1259.42717.camel@palm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-j6BvS8j0tcBT3HsSyxgQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-j6BvS8j0tcBT3HsSyxgQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've had a problem with SCSI locking up on one of my systems.  It seems
to be related to the load, and most of the time it just resets the bus,
sometimes taking several minutes to do so, but occasionally locks up
completely.

The setup is as follows:

  Kernel:       2.4.17 (several earlier kernels gave similar symptoms)
  Controller:   TEKRAM DC-390U3W ULTRA160 (sym53c1010-33)
  Drives:       FUJITSU SCSI160 36.7GB MAN3367MP
                   Two of these (ID 0 & 1) each with 4 partitions,
                   which are used to make 4 software RAID1 devices

  The CPU is an AMD K6 (500Mhz according to /proc/cpuinfo) and the
  motherboard is some VIA chipset thing by the looks of it, probably a
  Jetway board (I can find out if it's important, but the machine is
  currently 30 miles away from me)

The most reliable way to provoke problems is to make the software RAID1
get out of sync (i.e. by hitting the reset button) and then letting it
resync the raid.  This starts generating bus resets within seconds, and
generally locks up in minutes.  If I impose a speed limit of 5000 in
/proc/sys/dev/raid/speed_limit_max, it still does the occasional bus
reset, but doesn't lock up, although that could just be that asking it
to do less work makes it much less likely to lock up.

Yesterday I tried switching off TCQ, which allowed the RAID rebuild to
work at full speed without bus resets (about 32MB/s, which given that
both drives are on the same SCSI bus seems pretty good to me), so
thought I'd found a work-around of sorts, but it has since failed when
copying data from the network to the RAID partitions.

Most recently, it has locked up solid a couple of times, and then
declared one of the drives to be dead.  Here are the logs running up to
that:

Jul  3 09:18:54 comet kernel: sym0:0: ERROR (0:48) (a-2c-0) (27/18/c0) @ (s=
cripta 220:84000000).
Jul  3 09:18:54 comet kernel: sym0: script cmd =3D f31c0004
Jul  3 09:18:54 comet kernel: sym0: regdump: da 10 80 18 47 27 00 0e 04 0a =
81 2c 80 00 0c 08 00 68 00 00 0a 00 00 00.
Jul  3 09:18:54 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:18:54 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:18:59 comet kernel: sym0: SCSI parity error detected: SCR1=3D1 DB=
C=3Df000000 SBCL=3D6f
Jul  3 09:18:59 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:18:59 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:19:07 comet kernel: sym0:0: ERROR (0:48) (a-2c-0) (27/18/a8) @ (s=
cripta 220:84000000).
Jul  3 09:19:07 comet kernel: sym0: script cmd =3D f31c0004
Jul  3 09:19:07 comet kernel: sym0: regdump: da 10 80 18 47 27 00 0e 04 0a =
81 2c 80 00 0c 08 00 6c 00 00 2a 00 00 00.
Jul  3 09:19:07 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:19:07 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:21:50 comet kernel: sym0: script cmd =3D f31c0004
Jul  3 09:21:50 comet kernel: sym0: regdump: da 10 80 18 47 27 00 0e 04 0a =
80 2c 80 00 0c 08 00 80 2b 00 2a 00 00 00.
Jul  3 09:21:50 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:21:50 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:23:08 comet kernel: sym0:0: ERROR (0:48) (a-2c-0) (27/18/90) @ (s=
cripta 220:84000000).
Jul  3 09:23:08 comet kernel: sym0: script cmd =3D f31c0004
Jul  3 09:23:08 comet kernel: sym0: regdump: da 10 80 18 47 27 00 0e 04 0a =
81 2c 80 00 0c 08 00 3c f9 07 0a 00 00 00.
Jul  3 09:23:08 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:23:08 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:24:07 comet kernel: sym0: SCSI parity error detected: SCR1=3D1 DB=
C=3Df000000 SBCL=3D6f
Jul  3 09:24:07 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:24:07 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:25:23 comet kernel: sym0:1: ERROR (81:0) (e-ae-0) (3e/18/80) @ (s=
cripta 80:1e000000).
Jul  3 09:25:23 comet kernel: sym0: script cmd =3D 82030000
Jul  3 09:25:23 comet kernel: sym0: regdump: da 10 80 18 47 3e 01 0e 04 0e =
80 ae 80 01 0e 08 00 3c f9 07 08 00 00 00.
Jul  3 09:25:23 comet kernel: sym0: SCSI BUS reset detected.
Jul  3 09:25:23 comet kernel: sym0: SCSI BUS has been reset.
Jul  3 09:26:36 comet kernel: sym0:0: message c sent on bad reselection.
Jul  3 09:27:06 comet kernel: sym0:1:0: ABORT operation started.
Jul  3 09:27:06 comet kernel: sym0:1:control msgout: 80 6.
Jul  3 09:27:06 comet kernel: sym0:1:0: ABORT operation complete.
Jul  3 09:27:06 comet kernel: sym0:1:0: ABORT operation started.
Jul  3 09:27:06 comet kernel: sym0:1:0: ABORT operation failed.
Jul  3 09:27:06 comet kernel: sym0:1:0: DEVICE RESET operation started.
Jul  3 09:27:06 comet kernel: sym0:1:0: DEVICE RESET operation failed.
Jul  3 09:27:06 comet kernel: sym0:1:0: BUS RESET operation started.
Jul  3 09:27:06 comet kernel: sym0:1:0: BUS RESET operation failed.
Jul  3 09:27:11 comet kernel: sym0:1:0: HOST RESET operation started.
Jul  3 09:27:11 comet kernel: sym0:1:0: HOST RESET operation failed.
Jul  3 09:27:21 comet kernel: scsi: device set offline - command error reco=
ver failed: host 0 channel 0 id 1 lun 0
Jul  3 09:27:21 comet kernel: SCSI disk error : host 0 channel 0 id 1 lun 0=
 return code =3D 6000000
Jul  3 09:27:21 comet kernel:  I/O error: dev 08:14, sector 6615648
Jul  3 09:27:21 comet kernel: raid1: Disk failure on scsi/host0/bus0/target=
1/lun0/part4, disabling device.=20
Jul  3 09:27:21 comet kernel: ^IOperation continuing on 1 devices
Jul  3 09:27:21 comet kernel: raid1: mirror resync was not fully finished, =
resta

>From previous experience, if I reboot the machine, and raidhotadd the
drive back into the array, it will cheerfully rebuild it, which makes me
think that the drive is not actually dead, but any suggestions on how to
prove it one way or the other would be helpful.

Of course, now that it's running off of a single disk, I'm getting no
errors at all.

BTW I've tried swapping cables & terminators, but I don't have spares
for the drives or controller at present.

While I'm about it, I'll include some edited highlights from before I
switched off TCQ in the controler's setup.

Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:0:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation started.
Jun 26 20:06:26 comet kernel: sym0:1:0: ABORT operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:0:0: DEVICE RESET operation started.
Jun 26 20:06:26 comet kernel: sym0:0:0: DEVICE RESET operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:1:0: DEVICE RESET operation started.
Jun 26 20:06:26 comet kernel: sym0:1:0: DEVICE RESET operation timed-out.
Jun 26 20:06:26 comet kernel: sym0:0:0: BUS RESET operation started.
Jun 26 20:06:26 comet kernel: sym0: SCSI BUS reset detected.
Jun 26 20:06:26 comet kernel: sym0: SCSI BUS has been reset.
Jun 26 20:06:26 comet kernel: sym0:0:0: BUS RESET operation complete.

Jun 27 17:37:32 comet kernel: sym0: SCSI parity error detected: SCR1=3D1 DB=
C=3Df000000 SBCL=3D6f
Jun 27 17:37:32 comet kernel: sym0: SCSI BUS reset detected.
Jun 27 17:37:32 comet kernel: sym0: SCSI BUS has been reset.

Jun 27 21:50:48 comet kernel: sym0:0: message d sent on bad reselection.
Jun 27 21:50:48 comet kernel: sym0: SCSI phase error fixup: CCB already deq=
ueued.
Jun 27 21:50:48 comet kernel: sym0: SCSI BUS reset detected.
Jun 27 21:50:48 comet kernel: sym0: SCSI BUS has been reset.

Jun 30 01:10:01 comet kernel: sym0:0:0:illegal scsi phase (4/5).
Jun 30 01:10:01 comet kernel: sym0:0:0:COMMAND FAILED (87 0 2).

Jul  1 12:54:17 comet kernel: sym0: SCSI phase error fixup: CCB already deq=
ueued.
Jul  1 12:54:17 comet kernel: sym0: SCSI BUS reset detected.
Jul  1 12:54:17 comet kernel: sym0: SCSI BUS has been reset.

Jul  2 06:30:01 comet kernel: sym0:0:0:illegal scsi phase (4/5).
Jul  2 06:30:01 comet kernel: sym0:0:0:COMMAND FAILED (87 0 2).

And just in case it's important, this is the boot-up detection (also
from before disabling TCQ):

Jul  2 17:19:14 comet kernel: SCSI subsystem driver Revision: 1.00
Jul  2 17:19:14 comet kernel: PCI: Found IRQ 15 for device 00:0a.0
Jul  2 17:19:14 comet kernel: IRQ routing conflict for 00:0a.0, have irq 11=
, want irq 15
Jul  2 17:19:14 comet kernel: IRQ routing conflict for 00:0a.1, have irq 11=
, want irq 15
Jul  2 17:19:14 comet kernel: sym.0.10.0: setting PCI_COMMAND_PARITY...
Jul  2 17:19:14 comet kernel: sym.0.10.0: setting PCI_COMMAND_INVALIDATE.
Jul  2 17:19:14 comet kernel: PCI: Found IRQ 15 for device 00:0a.1
Jul  2 17:19:14 comet kernel: IRQ routing conflict for 00:0a.0, have irq 11=
, want irq 15
Jul  2 17:19:14 comet kernel: IRQ routing conflict for 00:0a.1, have irq 11=
, want irq 15
Jul  2 17:19:14 comet kernel: sym.0.10.1: setting PCI_COMMAND_PARITY...
Jul  2 17:19:14 comet kernel: sym.0.10.1: setting PCI_COMMAND_INVALIDATE.
Jul  2 17:19:14 comet kernel: sym0: <1010-33> rev 0x1 on pci bus 0 device 1=
0 function 0 irq 11
Jul  2 17:19:14 comet kernel: sym0: using 64 bit DMA addressing
Jul  2 17:19:14 comet kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, pari=
ty checking
Jul  2 17:19:14 comet kernel: sym0: open drain IRQ line driver, using on-ch=
ip SRAM
Jul  2 17:19:14 comet kernel: sym0: using LOAD/STORE-based firmware.
Jul  2 17:19:14 comet kernel: sym0: handling phase mismatch from SCRIPTS.
Jul  2 17:19:14 comet kernel: sym0: SCSI BUS has been reset.
Jul  2 17:19:14 comet kernel: sym1: <1010-33> rev 0x1 on pci bus 0 device 1=
0 function 1 irq 11
Jul  2 17:19:14 comet kernel: sym1: using 64 bit DMA addressing
Jul  2 17:19:14 comet kernel: sym1: Symbios NVRAM, ID 7, Fast-80, SE, parit=
y checking
Jul  2 17:19:14 comet kernel: sym1: open drain IRQ line driver, using on-ch=
ip SRAM
Jul  2 17:19:14 comet kernel: sym1: using LOAD/STORE-based firmware.
Jul  2 17:19:14 comet kernel: sym1: handling phase mismatch from SCRIPTS.
Jul  2 17:19:14 comet kernel: sym1: SCSI BUS has been reset.
Jul  2 17:19:14 comet kernel: scsi0 : sym-2.1.17a
Jul  2 17:19:14 comet kernel: scsi1 : sym-2.1.17a
Jul  2 17:19:14 comet kernel:   Vendor: FUJITSU   Model: MAN3367MP         =
Rev: 0107
Jul  2 17:19:14 comet kernel:   Type:   Direct-Access                      =
ANSI SCSI revision: 03
Jul  2 17:19:14 comet kernel:   Vendor: FUJITSU   Model: MAN3367MP         =
Rev: 0107
Jul  2 17:19:14 comet kernel:   Type:   Direct-Access                      =
ANSI SCSI revision: 03
Jul  2 17:19:14 comet kernel: sym0:0:0: tagged command queuing enabled, com=
mand queue depth 16.
Jul  2 17:19:14 comet kernel: sym0:1:0: tagged command queuing enabled, com=
mand queue depth 16.
Jul  2 17:19:14 comet kernel:   Vendor: ARCHIVE   Model: Python 04106-XXX  =
Rev: 7550
Jul  2 17:19:14 comet kernel:   Type:   Sequential-Access                  =
ANSI SCSI revision: 02
Jul  2 17:19:14 comet kernel: Attached scsi disk sda at scsi0, channel 0, i=
d 0, lun 0
Jul  2 17:19:14 comet kernel: Attached scsi disk sdb at scsi0, channel 0, i=
d 1, lun 0
Jul  2 17:19:14 comet kernel: sym0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5=
 ns, offset 62)
Jul  2 17:19:14 comet kernel: SCSI device sda: 71771688 512-byte hdwr secto=
rs (36747 MB)
Jul  2 17:19:14 comet kernel: Partition check:
Jul  2 17:19:14 comet kernel:  /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3 =
p4
Jul  2 17:19:14 comet kernel: sym0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5=
 ns, offset 62)
Jul  2 17:19:14 comet kernel: SCSI device sdb: 71771688 512-byte hdwr secto=
rs (36747 MB)
Jul  2 17:19:14 comet kernel:  /dev/scsi/host0/bus0/target1/lun0: p1 p2 p3 =
p4

having disabled TCQ, it's no longer mentioned.

According to smartctl, the drives are not running particularly hot
(around 46 C).

That's pretty much everything that seems even slightly relevant.

Cheers, Phil.
--=20
Say no to software patents!  http://petition.eurolinux.org/

|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-j6BvS8j0tcBT3HsSyxgQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9IteuYgOKS92bmRARAq+XAJ938iBgPacrt5NC/9h/TaPJrmf//wCcCUH7
PemHvYBawbuE7mby5BMVdOc=
=LpiE
-----END PGP SIGNATURE-----

--=-j6BvS8j0tcBT3HsSyxgQ--
