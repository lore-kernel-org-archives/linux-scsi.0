From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 1/4: missing reboot notifier and Mode Sense P8
Date: Thu, 13 Feb 2003 09:35:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03774E@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2D36D.23AC36E0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h1DEXnD27664
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:49 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id GAA14498
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:48 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D36D.23AC36E0
Content-Type: text/plain;
	charset="iso-8859-1"

All of these patches were created against 2.5.60.

This small patch adds back the reboot_notifier hook
that was accidentally removed in the last set of
patches.  It also adds support handle a Mode Page 8
command so the scsi layer won't complain anymore.
And the movement to using ->device to get scsi
numbers resulted in 2 typos in debug code.  These
are also fixed.

David Jeffery

 ips.c |   12 +++++++++---
 ips.h |   15 +++++++++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)


------_=_NextPart_000_01C2D36D.23AC36E0
Content-Type: text/plain;
	name="ipspatch1.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipspatch1.txt"

diff -ur linux-2.5.60_p0/drivers/scsi/ips.c =
linux-2.5.60_p1/drivers/scsi/ips.c=0A=
--- linux-2.5.60_p0/drivers/scsi/ips.c	Mon Feb 10 16:34:22 2003=0A=
+++ linux-2.5.60_p1/drivers/scsi/ips.c	Tue Feb 11 11:47:05 2003=0A=
@@ -3375,8 +3375,8 @@=0A=
                 ips_name,=0A=
                 ha->host_num,=0A=
                 scb->scsi_cmd->device->channel,=0A=
-                scb->scsi_cmd->channel->id,=0A=
-                scb->scsi_cmd->channel->lun,=0A=
+                scb->scsi_cmd->device->id,=0A=
+                scb->scsi_cmd->device->lun,=0A=
                 scb->basic_status,=0A=
                 scb->extended_status,=0A=
                 scb->extended_status =3D=3D IPS_ERR_CKCOND ? =
scb->dcdb.sense_info[2] & 0xf : 0,=0A=
@@ -4223,6 +4223,12 @@=0A=
       mdata.pdata.pg4.RotationalOffset =3D 0;=0A=
       mdata.pdata.pg4.MediumRotationRate =3D 0;=0A=
       break;=0A=
+   case 0x8:=0A=
+      mdata.pdata.pg8.PageCode =3D 8;=0A=
+      mdata.pdata.pg8.PageLength =3D sizeof(IPS_SCSI_MODE_PAGE8);=0A=
+      mdata.hdr.DataLength =3D 3 + mdata.hdr.BlockDescLength + =
mdata.pdata.pg8.PageLength;=0A=
+      /* everything else is left set to 0 */=0A=
+      break;=0A=
 =0A=
    default:=0A=
       return (0);=0A=
@@ -6797,7 +6803,7 @@=0A=
 		pci_unregister_driver(&ips_pci_driver);=0A=
 		return -ENODEV;=0A=
 	}=0A=
-=0A=
+	register_reboot_notifier(&ips_notifier);=0A=
 	return 0;=0A=
 }=0A=
 =0A=
diff -ur linux-2.5.60_p0/drivers/scsi/ips.h =
linux-2.5.60_p1/drivers/scsi/ips.h=0A=
--- linux-2.5.60_p0/drivers/scsi/ips.h	Mon Feb 10 16:34:22 2003=0A=
+++ linux-2.5.60_p1/drivers/scsi/ips.h	Tue Feb 11 08:26:38 2003=0A=
@@ -959,6 +959,20 @@=0A=
 } IPS_SCSI_MODE_PAGE4;=0A=
 =0A=
 /*=0A=
+ * Sense Data Format - Page 8=0A=
+ */=0A=
+typedef struct {=0A=
+   uint8_t  PageCode;=0A=
+   uint8_t  PageLength;=0A=
+   uint8_t  flags;=0A=
+   uint8_t  RetentPrio;=0A=
+   uint16_t DisPrefetchLen;=0A=
+   uint16_t MinPrefetchLen;=0A=
+   uint16_t MaxPrefetchLen;=0A=
+   uint16_t MaxPrefetchCeiling;=0A=
+} IPS_SCSI_MODE_PAGE8;=0A=
+=0A=
+/*=0A=
  * Sense Data Format - Block Descriptor (DASD)=0A=
  */=0A=
 typedef struct {=0A=
@@ -985,6 +999,7 @@=0A=
    union {=0A=
       IPS_SCSI_MODE_PAGE3 pg3;=0A=
       IPS_SCSI_MODE_PAGE4 pg4;=0A=
+      IPS_SCSI_MODE_PAGE8 pg8;=0A=
    } pdata;=0A=
 } IPS_SCSI_MODE_PAGE_DATA;=0A=
 =0A=

------_=_NextPart_000_01C2D36D.23AC36E0--
