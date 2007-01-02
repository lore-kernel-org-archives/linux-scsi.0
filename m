From: Andreas Heiduk <Andreas.Heiduk@web.de>
Subject: [sym53c8xx] problem: dropping back to 5MB/s with 2.6.18+
Date: Tue, 02 Jan 2007 23:20:44 +0100
Message-ID: <1305561378@web.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=-------------11677764444645398248"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate09.web.de ([217.72.192.184]:57846 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbXABWUp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 17:20:45 -0500
Received: from web.de
	by fmmailgate09.web.de (Postfix) with SMTP id 6F63522857D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jan 2007 23:20:44 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--=-------------11677764444645398248
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hello!

I'm trying to upgrade my kernel from 2.6.15, but my external RAID drops ba=
ck to 5 MB/s due to domain validation errors. With my current kernel 2.6.1=
5 the performance is OK.

Here are the details:

 - kernel: 2.6.15-1-686 i686 GNU/Linux
 - kernel driver: sym53c8xx - 2.2.1
 - hostadapter: LSI Logic / Symbios Logic 53c1010 66MHz Ultra3 SCSI (rev 0=
1)
 - external RAID: Transtec BR-1600U3p=20

Please note, that the hostadapter is a 66MHz/32bit device stuffed into a p=
lain 33MHz/32bit socket. (I'm not sure it that matters.)


With kernel 2.6.20-rc3 the following kind of error are logged while iterat=
ing down to FAST-5:

         target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
        sym0: unexpected disconnect
        scsi 0:0:0:0: illegal scsi phase (4/5).
         target0:0:0: Domain Validation detected failure, dropping back
        sym0:0: No MSG OUT phase after selection with ATN.
        sym0:0: ERROR (0:48) (8-ae-0) (1f/38/80) @ (scripta 70:9e030000).
        sym0: script cmd =3D 80000000
        sym0: regdump: da 10 80 38 47 1f 00 0e 00 08 00 ae 80 01 06 02 00 =
3c 53$
        08 00 00 00.
        sym0: SCSI BUS reset detected.
        sym0: SCSI BUS has been reset.
=20
I have tried kernels 2.6.18, 2.6.19.1 and 2.6.20-rc3. They all show the sa=
me pattern. With kernel 2.6.15 no such errors are printed (see both attach=
ed logfiles).


Do you have any ideas how to fix this problem=3F


Best Regards
Andreas Heiduk

=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
Viren-Scan f=FCr Ihren PC! Jetzt f=FCr jeden. Sofort, online und kostenlos.
Gleich testen! http://www.pc-sicherheit.web.de/freescan/=3Fmc=3D022222


--=-------------11677764444645398248
Content-Type: text/plain;
 name="logfile-2.6.15.txt"
Content-Disposition: attachment;
 filename="logfile-2.6.15.txt"
Content-Transfer-Encoding: 7bit

sym0: <1010-66> rev 0x1 at pci 0000:02:08.0 irq 209
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCAN AT BOOT disabled for targets 1 2 3 4 5 6 8 9 10 11 12 13 14 15.
sym0: SCSI BUS has been reset.
scsi1 : sym-2.2.1
  Vendor: transtec  Model:                   Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target1:0:0: tagged command queuing enabled, command queue depth 16.
 target1:0:0: Beginning Domain Validation
 target1:0:0: asynchronous.
 target1:0:0: wide asynchronous.
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target1:0:0: Domain Validation skipping write tests
 target1:0:0: Ending Domain Validation
SCSI device sda: 3418750976 512-byte hdwr sectors (1750400 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 3418750976 512-byte hdwr sectors (1750400 MB)
SCSI device sda: drive cache: write back
 sda: unknown partition table
sd 1:0:0:0: Attached scsi disk sda

--=-------------11677764444645398248
Content-Type: text/plain;
 name="logfile-2.6.20-rc3.txt"
Content-Disposition: attachment;
 filename="logfile-2.6.20-rc3.txt"
Content-Transfer-Encoding: 7bit

sym0: <1010-66> rev 0x1 at pci 0000:02:08.0 irq 21
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
 target0:0:1: Scan at boot disabled in NVRAM
 target0:0:2: Scan at boot disabled in NVRAM
 target0:0:3: Scan at boot disabled in NVRAM
 target0:0:4: Scan at boot disabled in NVRAM
 target0:0:5: Scan at boot disabled in NVRAM
 target0:0:6: Scan at boot disabled in NVRAM
 target0:0:8: Scan at boot disabled in NVRAM
 target0:0:9: Scan at boot disabled in NVRAM
 target0:0:10: Scan at boot disabled in NVRAM
 target0:0:11: Scan at boot disabled in NVRAM
 target0:0:12: Scan at boot disabled in NVRAM
 target0:0:13: Scan at boot disabled in NVRAM
 target0:0:14: Scan at boot disabled in NVRAM
 target0:0:15: Scan at boot disabled in NVRAM
scsi 0:0:0:0: Direct-Access     transtec                  0001 PQ: 0 ANSI: 3
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s DT (25 ns, offset 31)
sym0: unexpected disconnect
scsi 0:0:0:0: illegal scsi phase (4/5).
 target0:0:0: Domain Validation detected failure, dropping back
sym0:0: No MSG OUT phase after selection with ATN.
sym0:0: ERROR (0:48) (8-ae-0) (1f/38/80) @ (scripta 70:9e030000).
sym0: script cmd = 80000000
sym0: regdump: da 10 80 38 47 1f 00 0e 00 08 00 ae 80 01 06 02 00 3c 53 37
08 00 00 00.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
 target0:0:0: Domain Validation detected failure, dropping back
 target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s DT (50 ns, offset 31)
sym0: unexpected disconnect
scsi 0:0:0:0: illegal scsi phase (4/5).
 target0:0:0: Domain Validation detected failure, dropping back
sym0:0: No MSG OUT phase after selection with ATN.
sym0:0: ERROR (0:48) (8-ae-0) (1f/58/80) @ (scripta 70:9e030000).
sym0: script cmd = 80000000
sym0: regdump: da 10 80 58 47 1f 00 0e 00 08 00 ae 80 01 06 02 00 3c 53 37
08 00 00 00.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
 target0:0:0: Domain Validation detected failure, dropping back
 target0:0:0: FAST-10 WIDE SCSI 20.0 MB/s DT (100 ns, offset 31)
sym0: unexpected disconnect
scsi 0:0:0:0: illegal scsi phase (4/5).
 target0:0:0: Domain Validation detected failure, dropping back
sym0:0: No MSG OUT phase after selection with ATN.
sym0:0: ERROR (0:48) (8-ae-0) (1f/78/80) @ (scripta 70:9e030000).
sym0: script cmd = 80000000
sym0: regdump: da 10 80 78 47 1f 00 0e 00 08 00 ae 80 01 06 02 00 3c 53 37
08 00 00 00.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
 target0:0:0: Domain Validation detected failure, dropping back
 target0:0:0: FAST-5 WIDE SCSI 10.0 MB/s DT (200 ns, offset 31)
sym0: unexpected disconnect
scsi 0:0:0:0: illegal scsi phase (4/5).
 target0:0:0: Domain Validation detected failure, dropping back
sym0:0: No MSG OUT phase after selection with ATN.
sym0:0: ERROR (0:48) (8-ae-0) (1f/78/8f) @ (scripta 70:9e030000).
sym0: script cmd = 80000000
sym0: regdump: da 10 80 78 47 1f 00 0e 00 08 00 ae 80 01 06 02 00 3c 53 37
08 00 00 00.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
 target0:0:0: Domain Validation detected failure, dropping back
 target0:0:0: FAST-5 WIDE SCSI 10.0 MB/s DT (200 ns, offset 31)
sym0: unexpected disconnect
scsi 0:0:0:0: illegal scsi phase (4/5).
 target0:0:0: Domain Validation detected failure, dropping back
sym0:0: No MSG OUT phase after selection with ATN.
sym0:0: ERROR (0:48) (8-ae-0) (1f/78/8f) @ (scripta 70:9e030000).
sym0: script cmd = 80000000
sym0: regdump: da 10 80 78 47 1f 00 0e 00 08 00 ae 80 01 06 0a 00 3c 53 37
08 00 00 00.
sym0: SCSI BUS reset detected.
sym0: SCSI BUS has been reset.
 target0:0:0: Domain Validation Failure, dropping back to Asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
SCSI device sda: 3418750976 512-byte hdwr sectors (1750400 MB)
sda: Write Protect is off
sda: Mode Sense: ad 00 00 08
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: unknown partition table
sd 0:0:0:0: Attached scsi disk sda

--=-------------11677764444645398248--
