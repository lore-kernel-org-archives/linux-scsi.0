From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Mon, 21 Nov 2005 11:40:48 +0100
Message-ID: <200511211140.49250.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <200511191557.15533.kilian.cavalotti@lip6.fr> <437FD278.2080807@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:51178 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S932266AbVKUKlA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 05:41:00 -0500
In-Reply-To: <437FD278.2080807@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Sunday 20 November 2005 02:33, Douglas Gilbert wrote:
> The READ CAPACITY (10) command can report a maximum size
> of ((2**32 - 1) * blk_size) bytes. As shown above, /dev/sdg
> is reporting a block (sector) size of 1024 rather than
> the more normal 512 bytes that most production SCSI disks
> use. With a 1024 byte block size, just under 4 TB can be
> represented before READ CAPACITY (16) is needed.

Understood.

> I rechecked my patch and its seems correct for lk 2.6.15-rc1 .
> Does 'head <kernel_src_dir>/Makefile' confirm the kernel
> source version?

# head /usr/src/linux-2.6.15-rc2/Makefile
VERSION =3D 2
PATCHLEVEL =3D 6
SUBLEVEL =3D 15
EXTRAVERSION =3D-rc2
NAME=3DAffluent Albatross

> It is easy to apply by hand to drivers/scsi/aic7xxx/aic7xxx_osm.c
> and drivers/scsi/aic7xxx/aic79xx_osm.c . Before the patch my
> ahc_linux_slave_configure function starts like this:

Actually, what confused me is that aic79xx_osm.c has no=20
ahc_linux_slave_configure function. Whatever, as I only use aic7xxx U16=
0=20
adapter, I modified aic7xxx_osm.c and gave it a try. But with no luck:

# sg_readcap -16 -vv /dev/sdc
    read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 0=
0 00
READ CAPACITY 16 command error: Host_status=3D0x07 [DID_ERROR]

dmesg output:
-----------------------------------------------------------------------=
---
ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 106 (level, low) -> IRQ 25
scsi5 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs

  Vendor: IFT       Model: A16U-G1410        Rev: 342J
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi5:A:4:0: Tagged Queuing enabled.  Depth 32
 target5:0:4: Beginning Domain Validation
 target5:0:4: wide asynchronous.
 target5:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target5:0:4: Ending Domain Validation
sdc : very big device. try to use READ CAPACITY(16).
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
sdc : READ CAPACITY(16) failed.
sdc : status=3D0, message=3D00, host=3D7, driver=3D00
sdc : use 0xffffffff as device size
SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdc: drive cache: write back
sdc : very big device. try to use READ CAPACITY(16).
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 3 - Abort Tag Completed.
(scsi5:A:4:0): No or incomplete CDB sent to device.
(scsi5:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi5:A:4:0): Abort Tag Message Sent
(scsi5:A:4:0): SCB 2 - Abort Tag Completed.
sdc : READ CAPACITY(16) failed.
sdc : status=3D0, message=3D00, host=3D7, driver=3D00
sdc : use 0xffffffff as device size
SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1
sd 5:0:4:0: Attached scsi disk sdc
sd 5:0:4:0: Attached scsi generic sg3 type 0
-----------------------------------------------------------------------=
---

What's next? Throw the adapter out of the window? ;)

Thanks and regards,

--=20
Kilian CAVALOTTI                      Administrateur r=E9seaux et syst=E8=
mes
UPMC / CNRS - LIP6 (C870)
8, rue du Capitaine Scott                          Tel. : 01 44 27 88 5=
4
75015 Paris - France                               Fax. : 01 44 27 70 0=
0
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
