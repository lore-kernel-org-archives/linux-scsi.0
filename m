From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 2/4: 2.4 compatability code
Date: Thu, 13 Feb 2003 09:35:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03774F@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2D36D.25DC8460"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h1DEXqD27678
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:52 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id GAA14512
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 06:33:51 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2D36D.25DC8460
Content-Type: text/plain;
	charset="iso-8859-1"

This adds a few bits of code and couple #ifdefs that
are needed to enable this driver to work for 2.4 as
well as 2.5.

David Jeffery

 ips.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)


------_=_NextPart_000_01C2D36D.25DC8460
Content-Type: text/plain;
	name="ipspatch2.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ipspatch2.txt"

diff -ur linux-2.5.60_p1/drivers/scsi/ips.c =
linux-2.5.60_p2/drivers/scsi/ips.c=0A=
--- linux-2.5.60_p1/drivers/scsi/ips.c	Tue Feb 11 11:47:05 2003=0A=
+++ linux-2.5.60_p2/drivers/scsi/ips.c	Tue Feb 11 11:47:23 2003=0A=
@@ -1136,17 +1136,21 @@=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
 static int=0A=
+#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
+ips_biosparam(Disk *disk, kdev_t dev, int geom[]) {=0A=
+   ips_ha_t         *ha =3D (ips_ha_t *) =
disk->device->host->hostdata;=0A=
+   unsigned long     capacity =3D disk->capacity;=0A=
+#else=0A=
 ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,=0A=
 		sector_t capacity, int geom[]) {=0A=
-   ips_ha_t         *ha;=0A=
+   ips_ha_t         *ha =3D (ips_ha_t *) sdev->host->hostdata;=0A=
+#endif=0A=
    int               heads;=0A=
    int               sectors;=0A=
    int               cylinders;=0A=
 =0A=
    METHOD_TRACE("ips_biosparam", 1);=0A=
 =0A=
-   ha =3D (ips_ha_t *) sdev->host->hostdata;=0A=
-=0A=
    if (!ha)=0A=
       /* ?!?! host adater info invalid */=0A=
       return (0);=0A=
@@ -1178,7 +1182,7 @@=0A=
 =0A=
    return (0);=0A=
 }=0A=
-=0A=
+#if LINUX_VERSION_CODE < LinuxVersionCode(2,5,0)=0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
 /* Routine Name: ips_select_queue_depth                                =
     */=0A=
@@ -1188,7 +1192,7 @@=0A=
 /*   Select queue depths for the devices on the contoller              =
     */=0A=
 /*                                                                     =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
-/*static void=0A=
+static void=0A=
 ips_select_queue_depth(struct Scsi_Host *host, Scsi_Device *scsi_devs) =
{=0A=
    Scsi_Device *device;=0A=
    ips_ha_t    *ha;=0A=
@@ -1221,8 +1225,8 @@=0A=
       }=0A=
    }=0A=
 }=0A=
-*/=0A=
 =0A=
+#else=0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
 /* Routine Name: ips_slave_configure                                   =
     */=0A=
@@ -1247,6 +1251,7 @@=0A=
    }=0A=
    return 0;=0A=
 }=0A=
+#endif=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=

------_=_NextPart_000_01C2D36D.25DC8460--
