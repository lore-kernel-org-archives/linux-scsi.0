From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips 2.5 driver update [2/4] missing kfree and static init
	s
Date: Tue, 6 May 2003 13:34:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0377A4@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C313F5.B41DE840"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:36514 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263992AbTEFRVw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:21:52 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h46HUwZ31982
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:30:58 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id KAA07592
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:34:17 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C313F5.B41DE840
Content-Type: text/plain;
	charset="iso-8859-1"

This patch adds a missing kfree on an error path
and removes some cases where static variables
were being explicitly initiated to 0.

David Jeffery

 ips.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


------_=_NextPart_000_01C313F5.B41DE840
Content-Type: text/plain;
	name="patch2.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2.txt"

diff -urN linux-2.5.69_p1/drivers/scsi/ips.c =
linux-2.5.69_p2/drivers/scsi/ips.c=0A=
--- linux-2.5.69_p1/drivers/scsi/ips.c	2003-05-06 13:18:49.000000000 =
-0400=0A=
+++ linux-2.5.69_p2/drivers/scsi/ips.c	2003-05-06 13:20:52.000000000 =
-0400=0A=
@@ -238,18 +238,18 @@=0A=
 static const char   ips_name[] =3D "ips";=0A=
 static struct Scsi_Host *ips_sh[IPS_MAX_ADAPTERS];   /* Array of host =
controller structures */=0A=
 static ips_ha_t    *ips_ha[IPS_MAX_ADAPTERS];        /* Array of HA =
structures */=0A=
-static unsigned int ips_next_controller =3D 0;=0A=
-static unsigned int ips_num_controllers =3D 0;=0A=
-static unsigned int ips_released_controllers =3D 0;=0A=
+static unsigned int ips_next_controller;=0A=
+static unsigned int ips_num_controllers;=0A=
+static unsigned int ips_released_controllers;=0A=
 static int          ips_hotplug;=0A=
 static int          ips_cmd_timeout =3D 60;=0A=
 static int          ips_reset_timeout =3D 60 * 5;=0A=
 static int          ips_force_memio =3D 1;             /* Always use =
Memory Mapped I/O    */=0A=
 static int          ips_force_i2o =3D 1;               /* Always use =
I2O command delivery */=0A=
 static int          ips_ioctlsize =3D IPS_IOCTL_SIZE;  /* Size of the =
ioctl buffer        */=0A=
-static int          ips_cd_boot =3D 0;                 /* Booting from =
Manager CD         */=0A=
+static int          ips_cd_boot;                     /* Booting from =
Manager CD         */=0A=
 static char        *ips_FlashData =3D NULL;            /* CD Boot - =
Flash Data Buffer      */=0A=
-static long         ips_FlashDataInUse =3D 0;          /* CD Boot - =
Flash Data In Use Flag */=0A=
+static long         ips_FlashDataInUse;              /* CD Boot - =
Flash Data In Use Flag */=0A=
 static uint32_t     MaxLiteCmds =3D 32;                /* Max Active =
Cmds for a Lite Adapter */  =0A=
 static Scsi_Host_Template ips_driver_template =3D IPS;=0A=
 =0A=
@@ -562,8 +562,6 @@=0A=
          printk( KERN_WARNING "ERROR: Can't Allocate Large Buffer for =
Flashing\n" );=0A=
       }=0A=
    }                                                                   =
            =0A=
-   if (!pci_present())=0A=
-      return (0);=0A=
 =0A=
    SHT->proc_info =3D ips_proc_info;=0A=
    SHT->proc_name =3D "ips";=0A=
@@ -2403,6 +2401,7 @@=0A=
          minor    =3D buffer[0x1fe + 0xC0];  /* Offset 0x1fe after the =
header (0xc0) */=0A=
          subminor =3D buffer[0x1fd + 0xC0];  /* Offset 0x1fd after the =
header (0xc0) */=0A=
       } else {=0A=
+         kfree(buffer);=0A=
          return;=0A=
       }=0A=
 =0A=

------_=_NextPart_000_01C313F5.B41DE840--
