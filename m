From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] qla2xxx - perform proper SNS scans with ISP2200 HBAs.
Date: Thu, 22 Jan 2004 16:49:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E5D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3E14A.CAB87AF6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:42826 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265053AbUAWAt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 19:49:27 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3E14A.CAB87AF6
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, January 22, 2004 4:18 PM, Anton Blanchard wrote:
> Hi Andrew,
>=20
> > The 2200 firmware doesn't support the MS IOCB interface the driver
> > uses to issue CT commands to the SNS.  Basically, I had to
> > forward-port some code from the 6.x driver to get the SNS calls
> > to go through.  I've had several machines (mixture of 2200s/
> > 2300s/others with loop and fabric connections) running with this
> > patch for the past few days.
>=20
> I applied your patch to 2.6.2-rc1 and tested it on my ppc64 box. Looks
> like its not happy :) Maybe a 64bit or big endian issue?
>=20
> scsi0 : qla2xxx qla2200 0003:41:01.0:
>  QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8 =20
>   QLogic QLA22xx - ISP2200: PCI (66 MHz) @ 0003:41:01.0 hdma-,
> host#=3D0, fw=3D2.02.06 TP
> qla2200 0003:41:01.0: Invalid ISP SCSI completion handle=20
>

Hmm, I think I know what the problem is.  Could you try the attached
small patch.  The handles that get passed down to the firmware should
be opaque.  Unfortuantely when using RIO mode 3 (as is done with the
2100 and 2200s) the handle is truncated down from 32bits to 16bits.=20

Looks like I need to add the ppc64 machine to my test ring.  BTW: any
quick doc-pointers or suggestions on how to get 2.6 running on a ppc64
machine. =20

diff -Nurd -X /root/Drivers/8.x/dontdiff-bk qla2xxx-orig/qla_init.c =
qla2xxx-ppc64/qla_init.c
--- qla2xxx-orig/qla_init.c	2004-01-22 08:45:20.000000000 -0800
+++ qla2xxx-ppc64/qla_init.c	2004-01-22 16:23:18.531894544 -0800
@@ -1414,7 +1414,7 @@
 		icb->firmware_options[0] &=3D ~BIT_3;
 		icb->add_firmware_options[0] &=3D
 		    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0);
-		icb->add_firmware_options[0] |=3D (BIT_1 | BIT_0);
+		icb->add_firmware_options[0] |=3D BIT_1;
 		icb->response_accumulation_timer =3D 3;
 		icb->interrupt_delay_timer =3D 5;
=20

------_=_NextPart_001_01C3E14A.CAB87AF6
Content-Type: application/octet-stream;
	name="QL5_ppc64_fix_1.diff"
Content-Transfer-Encoding: base64
Content-Description: QL5_ppc64_fix_1.diff
Content-Disposition: attachment;
	filename="QL5_ppc64_fix_1.diff"

ZGlmZiAtTnVyZCAtWCAvcm9vdC9Ecml2ZXJzLzgueC9kb250ZGlmZi1iayBxbGEyeHh4LW9yaWcv
cWxhX2luaXQuYyBxbGEyeHh4LXBwYzY0L3FsYV9pbml0LmMKLS0tIHFsYTJ4eHgtb3JpZy9xbGFf
aW5pdC5jCTIwMDQtMDEtMjIgMDg6NDU6MjAuMDAwMDAwMDAwIC0wODAwCisrKyBxbGEyeHh4LXBw
YzY0L3FsYV9pbml0LmMJMjAwNC0wMS0yMiAxNjoyMzoxOC41MzE4OTQ1NDQgLTA4MDAKQEAgLTE0
MTQsNyArMTQxNCw3IEBACiAJCWljYi0+ZmlybXdhcmVfb3B0aW9uc1swXSAmPSB+QklUXzM7CiAJ
CWljYi0+YWRkX2Zpcm13YXJlX29wdGlvbnNbMF0gJj0KIAkJICAgIH4oQklUXzMgfCBCSVRfMiB8
IEJJVF8xIHwgQklUXzApOwotCQlpY2ItPmFkZF9maXJtd2FyZV9vcHRpb25zWzBdIHw9IChCSVRf
MSB8IEJJVF8wKTsKKwkJaWNiLT5hZGRfZmlybXdhcmVfb3B0aW9uc1swXSB8PSBCSVRfMTsKIAkJ
aWNiLT5yZXNwb25zZV9hY2N1bXVsYXRpb25fdGltZXIgPSAzOwogCQlpY2ItPmludGVycnVwdF9k
ZWxheV90aW1lciA9IDU7CiAK

------_=_NextPart_001_01C3E14A.CAB87AF6--
