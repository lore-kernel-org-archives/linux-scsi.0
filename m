From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: aic7xxx support for >2TB volumes?
Date: Wed, 16 Nov 2005 12:08:02 +0100
Message-ID: <200511161208.02374.kilian.cavalotti@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:39819 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S1030278AbVKPLIE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 06:08:04 -0500
Received: from poleia.lip6.fr (poleia.lip6.fr [132.227.205.24])
          by isis.lip6.fr (8.13.1/jtpda-5.4+victor) with ESMTP id jAGB82LT006635
          for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 12:08:02 +0100
Received: from spip.lip6.fr (mailia [127.0.0.1])
          by poleia.lip6.fr (8.13.3/jtpda-5.4+CB) with ESMTP id jAGB81xv031492
          for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 12:08:01 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,=20

After some searching through newgroups and mailing lists, I haven't rea=
lly=20
found an answer to the question: is the aic7xxx driver capable of suppo=
rting=20
larger than 2 terabytes volumes? I have read some success reports, but =
some=20
failed attempts too...

I actually have an external RAID array, hosting a 6TB virtual disk, plu=
gged on=20
an Adaptec 39160 SCSI card. I'm using a 2.6.14 kernel, with  CONFIG_LBD=
=3Dy,=20
and thus, the aic7xxx (ver 7.0) module.

My dmesg show the following:

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=3D7, 32/253 SCBs
  Vendor: transtec  Model: T6100S16R1-D      Rev: 342J
  Type:   Direct-Access                      ANSI SCSI revision: 05
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous.
 target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target1:0:0: Ending Domain Validation
sdb : very big device. try to use READ CAPACITY(16).
sdb : READ CAPACITY(16) failed.
sdb : status=3D0, message=3D00, host=3D5, driver=3D00
sdb : use 0xffffffff as device size
SCSI device sdb: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdb: drive cache: write back
sdb : very big device. try to use READ CAPACITY(16).
sdb : READ CAPACITY(16) failed.
sdb : status=3D0, message=3D00, host=3D5, driver=3D00
sdb : use 0xffffffff as device size
SCSI device sdb: 4294967296 512-byte hdwr sectors (2199023 MB)
SCSI device sdb: drive cache: write back
 sdb: unknown partition table
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg2 at scsi1, channel 0, id 0, lun 0,  type 0

Whatever the real size of the volume, it always give a "4294967296 512-=
byte=20
hdwr sectors (2199023 MB)" device...

Is there a way to support a >2TB volume on this SCSI controler? I know =
I could=20
split my volume in smaller ones and use LVM to reassemble them, but I'd=
 like=20
to avoid adding overhead to the storage stack, and keep it the simplest=
=2E

Thanks in advance for any hint/advice,
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
