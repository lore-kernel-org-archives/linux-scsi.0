From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: SCSI errors with multipath IO
Date: Thu, 18 May 2006 18:25:57 +0200
Message-ID: <200605181825.57547.kilian.cavalotti@lip6.fr>
References: <200605172026.26745.kilian.cavalotti@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:30159 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S1751373AbWERQZ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 12:25:58 -0400
Received: from poleia.lip6.fr (poleia.lip6.fr [132.227.205.24])
          by isis.lip6.fr (8.13.6/jtpda-5.4+mv) with ESMTP id k4IGPtc1004531
          for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 18:25:55 +0200
Received: from spip.lip6.fr (mailia [127.0.0.1])
          by poleia.lip6.fr (8.13.3/jtpda-5.4+CB) with ESMTP id k4IGPjlg030101
          for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 18:25:45 +0200
In-Reply-To: <200605172026.26745.kilian.cavalotti@lip6.fr>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wednesday 17 May 2006 20:26, you wrote:
> sd 3:0:0:0: SCSI error: return code =3D 0xb0000
> end_request: I/O error, dev sdc, sector 439427200
> device-mapper: dm-multipath: Failing path 8:32.
> end_request: I/O error, dev sdc, sector 439427208
> mptbase: ioc2: LogInfo(0x11070000): F/W: DMA Error
> mptbase: ioc2: IOCStatus(0x004b): SCSI IOC Terminated
> mptbase: ioc2: LogInfo(0x11070000): F/W: DMA Error
> mptbase: ioc2: IOCStatus(0x004b): SCSI IOC Terminated

I forgot to include the following error, which I get each time:
mptbase: ioc2: IOCStatus(0x0003): Invalid SGL
mptbase: ioc2: LogInfo(0x11070000): F/W: DMA Error

> This error appears randomly on both interfaces, under heavy I/O. And =
it
> does not seems to occur when using only one interface (/dev/sdb direc=
tly,
> rather than /dev/md0 or /dev/mapper/<id>.

Actually, that's not true. ;) It just took more time to appear : I get =
the=20
same errors when only using one of the two interfaces (only one SCSI li=
nk). So=20
it's probably not a MD-related issue. It seems to be more related to th=
e mpt=20
driver (I currently use the 2.6.16-1-em64t-p4-smp debian kernel).=20

Does that ring a bell anywhere?=20

ioc0: 53C1030: Capabilities=3D{Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=3D01030a00h, Ports=3D1, MaxQ=3D222, IRQ=
=3D201
  Vendor: IFT       Model: A16U-G1410        Rev: 342J
  Type:   Direct-Access                      ANSI SCSI revision: 05
GSI 21 sharing vector 0xD1 and IRQ 21
ACPI: PCI Interrupt 0000:03:0b.1[B] -> GSI 38 (level, low) -> IRQ 209
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities=3D{Initiator}
scsi1 : ioc1: LSI53C1030, FwRev=3D01030a00h, Ports=3D1, MaxQ=3D222, IRQ=
=3D209
GSI 22 sharing vector 0xD9 and IRQ 22
ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 106 (level, low) -> IRQ 217
mptbase: Initiating ioc2 bringup
ioc2: 53C1030: Capabilities=3D{Initiator}
scsi2 : ioc2: LSI53C1030, FwRev=3D01030a00h, Ports=3D1, MaxQ=3D222, IRQ=
=3D217
GSI 23 sharing vector 0xE1 and IRQ 23
ACPI: PCI Interrupt 0000:05:04.1[B] -> GSI 107 (level, low) -> IRQ 225
mptbase: Initiating ioc3 bringup
ioc3: 53C1030: Capabilities=3D{Initiator}
scsi3 : ioc3: LSI53C1030, FwRev=3D01030a00h, Ports=3D1, MaxQ=3D222, IRQ=
=3D225
GSI 24 sharing vector 0xE9 and IRQ 24
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 233
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
sda : very big device. try to use READ CAPACITY(16).
SCSI device sda: 5466216448 512-byte hdwr sectors (2798703 MB)
sda: Write Protect is off
sda: Mode Sense: 9b 00 00 08
SCSI device sda: drive cache: write through
sda : very big device. try to use READ CAPACITY(16).
SCSI device sda: 5466216448 512-byte hdwr sectors (2798703 MB)
sda: Write Protect is off
sda: Mode Sense: 9b 00 00 08
SCSI device sda: drive cache: write through
 sda: unknown partition table
sd 0:0:1:0: Attached scsi disk sda
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216320
Buffer I/O error on device sda, logical block 683277040
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216320
Buffer I/O error on device sda, logical block 683277040
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216440
Buffer I/O error on device sda, logical block 683277055
sd 0:0:1:0: SCSI error: return code =3D 0xb0000
end_request: I/O error, dev sda, sector 5466216384
Buffer I/O error on device sda, logical block 683277048

What do I have to check? The RAID array seems in good shape, the cables=
 are=20
brand new, as are the HBAs. I'm running out of ideas, so I'd really=20
appreciate any clue.

Thanks in advance,
--=20
Kilian CAVALOTTI                      Administrateur r=C3=A9seaux et sy=
st=C3=A8mes
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
