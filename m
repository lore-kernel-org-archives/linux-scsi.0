From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: Strange Diamond Fireport 20 (53c875J Rev4) problems
Date: Tue, 30 Apr 2002 02:39:29 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020430021726.V1554-100000@localhost.my.domain>
References: <000101c1f059$8ef1a040$0700a8c0@JESTER>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000101c1f059$8ef1a040$0700a8c0@JESTER>
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Csaba_Hal=E1sz?= <hcs@ics2.ics.tvnet.hu>
Cc: linux-scsi@vger.kernel.org



On Tue, 30 Apr 2002, Csaba Hal=E1sz wrote:

> Hi!
>
> I am experiencing strange behaviour with my scsi card.
>
> With SYM-1 I have to use the specf:0 option, otherwise the driver
> gets into an endless loop while downloading scsi scripts during
> initialization. (interrupted script address not found)
>
> With 2.2.20 and SYM-1, when I run the the command
> 	dd if=3D/dev/sr0 of=3D/dev/null bs=3Dx count=3D1000
> the following happens:
> 	if x <=3D 54k then everything is OK
> 	if 54k < x <=3D 56k then I get scsi timeout
> 	if 56k < x then I get interrupted script address not found
>
> With 2.4.18 and SYM-1, I get the interrupted script address message
> for all values of x.
>
> With 2.4.18 and SYM-2 none of my devices are detected.
>
> The errors occur both with a MSI K7T Turbo (VIA KT133A chipset)
> and an ASUS A7N-266C (nVidia nForce 420) motherboard, using AMD
> Thunderbird 850 and Athlon XP 1700+ respectively. The IRQ is not
> shared.
>
> The only thing I have been able to figure out is that the error
> code indicates an illegal instruction. I have tried to disable
> some chip features in the source code, but without any success.
>
> Any help would be appreciated.

My immediate idea is that your HBA may well be just broken.

I highly suspect the on-chip RAM to be one of the part that doesn't
function properly (at least). This let me suggest you to check that.

The following simple patch against SYM-2 will ensure that the driver wi=
ll
not use the on-chip RAM of your controller for SCSI SCRIPTS.

--- sym_hipd.c.orig	Sat Dec 29 22:58:58 2001
+++ sym_hipd.c	Tue Apr 30 02:30:19 2002
@@ -1332,7 +1332,7 @@
  ,
  {PCI_ID_SYM53C875_2, 0xff, "875", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN=
|
- FE_RAM|FE_DIFF|FE_VARCLK}
+ FE_DIFF|FE_VARCLK}
  ,
  {PCI_ID_SYM53C885, 0xff, "885", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN=
|
------ < CUT HERE > --------------

Just apply it to 2.4.18/driver/scsi/sym53c8xx_2 and rebuild the driver
and/or the kernel. You may let me know if this makes any noticeable
difference.

Regards,
  G=E9rard.

> Thanks,
> 	Csaba Halasz
>
> Here are some syslog snippets:
>
> 2.4.18 SYM-1:
>
> Apr 25 02:34:22 defiant kernel: sym53c8xx: at PCI bus 1, device 7, fu=
nction
> 0
> Apr 25 02:34:22 defiant kernel: sym53c8xx: 53c875J detected with Symb=
ios
> NVRAM
> Apr 25 02:34:22 defiant kernel: sym53c875J-0: rev 0x4 on pci bus 1 de=
vice 7
> function 0 irq 5
> Apr 25 02:34:22 defiant kernel: sym53c875J-0: Symbios format NVRAM, I=
D 7,
> Fast-20, Parity Checking
> Apr 25 02:34:22 defiant kernel: sym53c875J-0: restart (scsi reset).
> Apr 25 02:34:22 defiant kernel: scsi0 : sym53c8xx-1.7.3c-20010512
> Apr 25 02:34:24 defiant kernel:   Vendor: SANKYO    Model: CP525
> Rev: 6.64
> Apr 25 02:34:24 defiant kernel:   Type:   Sequential-Access
> ANSI SCSI revision: 02
> Apr 25 02:34:24 defiant kernel:   Vendor: MATSHITA  Model: CD-ROM CR-=
506
> Rev: 8S05
> Apr 25 02:34:24 defiant kernel:   Type:   CD-ROM
> ANSI SCSI revision: 02
> Apr 25 02:34:24 defiant kernel:   Vendor: YAMAHA    Model: CRW4260
> Rev: 1.0q
> Apr 25 02:34:24 defiant kernel:   Type:   CD-ROM
> ANSI SCSI revision: 02
> Apr 25 02:34:24 defiant kernel: Attached scsi CD-ROM sr0 at scsi0, ch=
annel
> 0, id 5, lun 0
> Apr 25 02:34:24 defiant kernel: Attached scsi CD-ROM sr1 at scsi0, ch=
annel
> 0, id 6, lun 0
> Apr 25 02:34:24 defiant kernel: sym53c875J-0-<5,*>: asynchronous.
> Apr 25 02:34:24 defiant kernel: sr0: scsi-1 drive
> Apr 25 02:34:24 defiant kernel: sym53c875J-0-<6,*>: target did not re=
port
> SYNC.
> Apr 25 02:34:24 defiant kernel: sym53c875J-0-<6,*>: target did not re=
port
> SYNC.
> Apr 25 02:34:24 defiant kernel: sr1: scsi3-mmc drive: 6x/6x writer cd=
/rw
> xa/form2 cdda tray
> Apr 25 02:34:43 defiant kernel: sym53c875J-0-<6,*>: target did not re=
port
> SYNC.
> Apr 25 02:34:43 defiant kernel: sym53c875J-0-<6,*>: target did not re=
port
> SYNC.
> Apr 25 02:34:56 defiant kernel: sym53c875J-0: interrupted SCRIPT addr=
ess not
> found.
> Apr 25 02:34:56 defiant kernel: sym53c875J-0: restart (scsi reset).
> Apr 25 02:34:58 defiant kernel: sym53c875J-0-<6,*>: target did not re=
port
> SYNC.
> Apr 25 02:34:58 defiant kernel:  I/O error: dev 0b:01, sector 102460
> Apr 25 02:34:58 defiant kernel:  I/O error: dev 0b:01, sector 102460
> Apr 25 02:34:58 defiant kernel:  I/O error: dev 0b:01, sector 102712
>
> 2.4.18 SYM-2:
>
> Apr 25 23:21:23 defiant kernel: sym0: <875> rev 0x4 on pci bus 1 devi=
ce 7
> function 0 irq 5
> Apr 25 23:21:23 defiant kernel: sym0: Symbios NVRAM, ID 7, Fast-20, S=
E,
> parity checking
> Apr 25 23:21:23 defiant kernel: sym0: open drain IRQ line driver, usi=
ng
> on-chip SRAM
> Apr 25 23:21:23 defiant kernel: sym0: using LOAD/STORE-based firmware=
=2E
> Apr 25 23:21:23 defiant kernel: sym0: SCAN AT BOOT disabled for targe=
ts 0 1
> 2 4 8 9 10 11 12 13 14 15.
> Apr 25 23:21:23 defiant kernel: sym0: SCAN FOR LUNS disabled for targ=
ets 0 1
> 2 3 4 5 6 8 9 10 11 12 13 14 15.
> Apr 25 23:21:23 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:21:26 defiant kernel: sym0:3: ERROR (81:0) (8-28-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:21:26 defiant kernel: sym0: regdump: da 10 80 05 47 00 03 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:21:26 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:21:26 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:21:29 defiant kernel: sym0:3: ERROR (81:0) (8-28-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:21:29 defiant kernel: sym0: regdump: da 10 80 05 47 00 03 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:21:29 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:21:29 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:21:29 defiant kernel: sym0:3:0: DEVICE RESET operation star=
ted.
> Apr 25 23:21:29 defiant kernel: sym0:3:0: DEVICE RESET operation fail=
ed.
> Apr 25 23:21:29 defiant kernel: sym0:3:0: BUS RESET operation started=
=2E
> Apr 25 23:21:29 defiant kernel: sym0:3:0: BUS RESET operation failed.
> Apr 25 23:21:34 defiant kernel: sym0:3:0: HOST RESET operation starte=
d.
> Apr 25 23:21:34 defiant kernel: sym0:3:0: HOST RESET operation failed=
=2E
> Apr 25 23:21:44 defiant kernel: sym0:5: ERROR (81:0) (8-ae-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:21:44 defiant kernel: sym0: regdump: da 10 80 05 47 00 05 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:21:44 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:21:44 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:21:48 defiant kernel: sym0:5: ERROR (81:0) (8-ae-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:21:48 defiant kernel: sym0: regdump: da 10 80 05 47 00 05 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:21:48 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:21:48 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:21:48 defiant kernel: sym0:5:0: DEVICE RESET operation star=
ted.
> Apr 25 23:21:48 defiant kernel: sym0:5:0: DEVICE RESET operation fail=
ed.
> Apr 25 23:21:48 defiant kernel: sym0:5:0: BUS RESET operation started=
=2E
> Apr 25 23:21:48 defiant kernel: sym0:5:0: BUS RESET operation failed.
> Apr 25 23:21:53 defiant kernel: sym0:5:0: HOST RESET operation starte=
d.
> Apr 25 23:21:53 defiant kernel: sym0:5:0: HOST RESET operation failed=
=2E
> Apr 25 23:22:03 defiant kernel: sym0:6: ERROR (81:0) (8-28-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:22:03 defiant kernel: sym0: regdump: da 10 80 05 47 00 06 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:22:03 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:22:03 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:22:06 defiant kernel: sym0:6: ERROR (81:0) (8-28-0) (0/5/0)=
 @ (mem
> 8c0068:ffffbfff).
> Apr 25 23:22:06 defiant kernel: sym0: regdump: da 10 80 05 47 00 06 0=
e 00 08
> 00 ae 80 00 0e 02 00 cc 8c 1a 08 ff ff ff.
> Apr 25 23:22:06 defiant kernel: sym0: SCSI BUS reset detected.
> Apr 25 23:22:06 defiant kernel: sym0: SCSI BUS has been reset.
> Apr 25 23:22:06 defiant kernel: sym0:6:0: DEVICE RESET operation star=
ted.
> Apr 25 23:22:06 defiant kernel: sym0:6:0: DEVICE RESET operation fail=
ed.
> Apr 25 23:22:06 defiant kernel: sym0:6:0: BUS RESET operation started=
=2E
> Apr 25 23:22:06 defiant kernel: sym0:6:0: BUS RESET operation failed.
> Apr 25 23:22:11 defiant kernel: sym0:6:0: HOST RESET operation starte=
d.
> Apr 25 23:22:11 defiant kernel: sym0:6:0: HOST RESET operation failed=
=2E
>
> (The memory locations vary, I don't remember seeing the same twice.)
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
