From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Mon, 21 Nov 2005 11:09:18 +0100
Message-ID: <200511211109.19490.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <437E5E1E.2080902@torque.net> <438152BC.3060505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:33765 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S932254AbVKUKJf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 05:09:35 -0500
In-Reply-To: <438152BC.3060505@us.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Monday 21 November 2005 05:53, you wrote:
> I don't think slave_configure is the right place to be modifying
> a scsi_host attribute. How about this patch instead? Only compile
> tested.

Patch applied on 2.6.15-rc2, and gives no better result:

# sg_readcap -16 -vv /dev/sdb
    read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 0=
0 00
READ CAPACITY 16 command error: Host_status=3D0x0b [DID_SOFT_ERROR]

dmesg output:
-----------------------------------------------------------------------=
---
ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 106 (level, low) -> IRQ 25
scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs

  Vendor: IFT       Model: A16U-G1410        Rev: 342J
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi3:A:4:0: Tagged Queuing enabled.  Depth 32
 target3:0:4: Beginning Domain Validation
 target3:0:4: wide asynchronous.
 target3:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target3:0:4: Ending Domain Validation
sdc : very big device. try to use READ CAPACITY(16).
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
sdc : READ CAPACITY(16) failed.
sdc : status=3D0, message=3D00, host=3D7, driver=3D00
sdc : use 0xffffffff as device size
SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdc: drive cache: write back
sdc : very big device. try to use READ CAPACITY(16).
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 3 - Abort Tag Completed.
(scsi3:A:4:0): No or incomplete CDB sent to device.
(scsi3:A:4:0): Protocol violation in Message-in phase.  Attempting to a=
bort.
(scsi3:A:4:0): Abort Tag Message Sent
(scsi3:A:4:0): SCB 2 - Abort Tag Completed.
sdc : READ CAPACITY(16) failed.
sdc : status=3D0, message=3D00, host=3D7, driver=3D00
sdc : use 0xffffffff as device size
SCSI device sdc: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1
sd 3:0:4:0: Attached scsi disk sdc
sd 3:0:4:0: Attached scsi generic sg3 type 0
-----------------------------------------------------------------------=
---

Does this mean the HBA has an hardware limit?

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
