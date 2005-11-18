From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Fri, 18 Nov 2005 13:55:17 +0100
Message-ID: <200511181355.17911.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437D97E9.8020709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:62088 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S1161099AbVKRMza convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 07:55:30 -0500
In-Reply-To: <437D97E9.8020709@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

=46irst of all, thanks for highlighting this.

On Friday 18 November 2005 09:59, Douglas Gilbert wrote:
> From the log output above, /dev/sdb seems to reject
> the READ CAPACITY (16) command. I think that it is
> unlikely that the aic7xxx driver is filtering out that
> particular command (why should it?) and a simple grep
> in that driver for READ_CAP finds no matches.
>
> As an extra check of the linux sd driver you could fetch
> sg3_utils, build it and try:
>   sg_readcap -16 /dev/sdb

As expected:
# sg_readcap -v -16 /dev/sdb
    read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 0=
0 00
READ CAPACITY 16 command error: Host_status=3D0x05 [DID_ABORT]

Moreover, I omitted to mention that point earlier, but the HBA BIOS doe=
s not=20
correctly detect the volume size. It reports a "Capacity: 0MB"

> If that fails than I think you need to speak to the vendor
> of /dev/sdb . Perhaps there is newer firmware.

Sure, I contacted them, and they told me that currently, the only=20
known-to-work-over-2TB HBA vendor was LSI Logic.
So I tried to plug the same external array on a U320 LSI Logic adapter =
(using=20
the Fusion MPT kernel module), and it actually worked:=20

ioc0: 53C1030: Capabilities=3D{Initiator,Target}
scsi1 : ioc0: LSI53C1030, FwRev=3D01032300h, Ports=3D1, MaxQ=3D255, IRQ=
=3D23
ACPI: PCI Interrupt 0000:02:05.1[B] -> GSI 33 (level, low) -> IRQ 24
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities=3D{Initiator,Target}
scsi2 : ioc1: LSI53C1030, FwRev=3D01032300h, Ports=3D1, MaxQ=3D255, IRQ=
=3D24
PCI: Enabling device 0000:06:02.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 96 (level, low) -> IRQ 25
mptbase: Initiating ioc2 bringup
ioc2: 53C1030: Capabilities=3D{Initiator}
mptbase: Initiating ioc2 recovery
scsi3 : ioc2: LSI53C1030, FwRev=3D01011800h, Ports=3D1, MaxQ=3D222, IRQ=
=3D25
  Vendor: IFT       Model: A16U-G1410        Rev: 342J
  Type:   Direct-Access                      ANSI SCSI revision: 05
sdb : very big device. try to use READ CAPACITY(16).
SCSI device sdb: 12494209024 512-byte hdwr sectors (6397035 MB)
SCSI device sdb: drive cache: write back
sdb : very big device. try to use READ CAPACITY(16).
SCSI device sdb: 12494209024 512-byte hdwr sectors (6397035 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1
Attached scsi disk sdb at scsi3, channel 0, id 3, lun 0
Attached scsi generic sg2 at scsi3, channel 0, id 3, lun 0,  type 0
ACPI: PCI Interrupt 0000:06:02.1[B] -> GSI 97 (level, low) -> IRQ 26
mptbase: Initiating ioc3 bringup
ioc3: 53C1030: Capabilities=3D{Initiator}
mptbase: Initiating ioc3 recovery

What I can't really understand is how a device could fail on a READ CAP=
ACITY=20
16 if plugged on an HBA, but work if plugged on another one...=20

Best regards,

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
