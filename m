From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 1/4: fix struct length and remove dead code
Date: Thu, 6 Feb 2003 13:14:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03773B@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2CE0B.93260620"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h16IEQD24503
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:14:26 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA08540
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:14:25 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2CE0B.93260620
Content-Type: text/plain;
	charset="iso-8859-1"

This small patch fixes the length of the IPS_ENQ
struct.  It was too short which can cause the adapter
to write beyond the the end of the struct during
driver initialization and corrupt part of memory.

The patch was made against 2.5.59.

David Jeffery

 ips.c |    7 -------
 ips.h |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)


------_=_NextPart_000_01C2CE0B.93260620
Content-Type: application/octet-stream;
	name="ips.patch1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips.patch1"

diff -ur linux-2.5.59_p0/drivers/scsi/ips.c =
linux-2.5.59_p1/drivers/scsi/ips.c=0A=
--- linux-2.5.59_p0/drivers/scsi/ips.c	Mon Jan 20 09:32:57 2003=0A=
+++ linux-2.5.59_p1/drivers/scsi/ips.c	Mon Jan 20 09:44:35 2003=0A=
@@ -1155,13 +1155,6 @@=0A=
 =0A=
    ips_next(ha, IPS_INTR_IORL);=0A=
    =0A=
-   /* If We were using the CD Boot Flash Buffer, Restore the Old =
Values */=0A=
-   if ( ips_FlashData =3D=3D ha->ioctl_data ) {                        =
       =0A=
-      ha->ioctl_data =3D ha->flash_data;                           =0A=
-      ha->ioctl_order =3D ha->flash_order;                          =
=0A=
-      ha->ioctl_datasize =3D ha->flash_datasize;                       =
=0A=
-      ips_FlashDataInUse =3D 0;                                        =
     =0A=
-   }=0A=
    return (0);=0A=
 }=0A=
 =0A=
diff -ur linux-2.5.59_p0/drivers/scsi/ips.h =
linux-2.5.59_p1/drivers/scsi/ips.h=0A=
--- linux-2.5.59_p0/drivers/scsi/ips.h	Mon Jan 20 09:32:57 2003=0A=
+++ linux-2.5.59_p1/drivers/scsi/ips.h	Mon Jan 20 09:45:04 2003=0A=
@@ -714,7 +714,7 @@=0A=
    uint16_t usConfigUpdateCount;=0A=
    uint8_t  ucBlkFlag;=0A=
    uint8_t  reserved;=0A=
-   uint16_t usAddrDeadDisk[IPS_MAX_CHANNELS * IPS_MAX_TARGETS];=0A=
+   uint16_t usAddrDeadDisk[IPS_MAX_CHANNELS * (IPS_MAX_TARGETS + =
1)];=0A=
 } IPS_ENQ, *PIPS_ENQ;=0A=
 =0A=
 typedef struct {=0A=

------_=_NextPart_000_01C2CE0B.93260620--
