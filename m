From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 4/4: error messages
Date: Thu, 6 Feb 2003 13:15:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03773E@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2CE0B.C9491FD0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h16IFvD24910
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:15:57 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA09024
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:15:56 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2CE0B.C9491FD0
Content-Type: text/plain;
	charset="iso-8859-1"

This small patch does 2 things.  It reworks the firmware/driver
versioning messages to make them more understandable, and it
fixes one case where the 64bit addressing changes caused
error/success to not be properly reported to the serveraid tools.

The patch was made against 2.5.59.

David Jeffery


 ips.c |   43 +++++++++++++++++++++++++++----------------
 ips.h |    1 +
 2 files changed, 28 insertions(+), 16 deletions(-)


------_=_NextPart_000_01C2CE0B.C9491FD0
Content-Type: application/octet-stream;
	name="ips.patch4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips.patch4"

diff -ur linux-2.5.59_p3/drivers/scsi/ips.c =
linux-2.5.59_p4/drivers/scsi/ips.c=0A=
--- linux-2.5.59_p3/drivers/scsi/ips.c	Mon Jan 20 11:43:56 2003=0A=
+++ linux-2.5.59_p4/drivers/scsi/ips.c	Wed Jan 22 14:42:53 2003=0A=
@@ -1445,7 +1445,8 @@=0A=
    bp =3D &buffer[0];=0A=
    memset(bp, 0, sizeof(buffer));=0A=
 =0A=
-   sprintf(bp, "%s%s%s", "IBM PCI ServeRAID ", IPS_VERSION_HIGH, =
IPS_VERSION_LOW );=0A=
+   sprintf(bp, "%s%s%s Build %d", "IBM PCI ServeRAID ",=0A=
+               IPS_VERSION_HIGH, IPS_VERSION_LOW, IPS_BUILD_IDENT =
);=0A=
 =0A=
    if (ha->ad_type > 0 &&=0A=
        ha->ad_type <=3D MAX_ADAPTER_NAME) {=0A=
@@ -1590,6 +1591,7 @@=0A=
 ips_make_passthru(ips_ha_t *ha, Scsi_Cmnd *SC, ips_scb_t *scb, int =
intr) {=0A=
    ips_passthru_t *pt;=0A=
    int length =3D 0;=0A=
+   int ret;=0A=
 =0A=
    METHOD_TRACE("ips_make_passthru", 1);=0A=
 =0A=
@@ -1656,9 +1658,11 @@=0A=
          }=0A=
 =0A=
          if(ha->device_id =3D=3D IPS_DEVICEID_COPPERHEAD &&=0A=
-            pt->CoppCP.cmd.flashfw.op_code =3D=3D =
IPS_CMD_RW_BIOSFW)=0A=
-            return ips_flash_copperhead(ha, pt, scb);=0A=
-=0A=
+            pt->CoppCP.cmd.flashfw.op_code =3D=3D IPS_CMD_RW_BIOSFW) =
{=0A=
+            ret =3D ips_flash_copperhead(ha, pt, scb);=0A=
+            ips_scmd_buf_write(SC, ha->ioctl_data, =
sizeof(ips_passthru_t));=0A=
+            return ret;=0A=
+         }=0A=
          if (ips_usrcmd(ha, pt, scb))=0A=
             return (IPS_SUCCESS);=0A=
          else=0A=
@@ -2082,6 +2086,9 @@=0A=
    copy_info(&info, "\tDriver Version                    : %s%s\n",=0A=
              IPS_VERSION_HIGH, IPS_VERSION_LOW);=0A=
 =0A=
+   copy_info(&info, "\tDriver Build                      : %d\n",=0A=
+             IPS_BUILD_IDENT);=0A=
+=0A=
    copy_info(&info, "\tMax Physical Devices              : %d\n",=0A=
              ha->enq->ucMaxPhysicalDevices);=0A=
    copy_info(&info, "\tMax Active Commands               : %d\n",=0A=
@@ -6464,6 +6471,8 @@=0A=
  uint8_t  BiosVersion[ IPS_COMPAT_ID_LENGTH + 1];=0A=
  int      MatchError;=0A=
  int      rc;=0A=
+ char     BiosString[10];=0A=
+ char     FirmwareString[10];=0A=
 =0A=
  METHOD_TRACE("ips_version_check", 1);=0A=
 =0A=
@@ -6496,28 +6505,30 @@=0A=
  MatchError =3D 0;=0A=
 =0A=
  if  (strncmp(FirmwareVersion, Compatable[ ha->nvram->adapter_type ], =
IPS_COMPAT_ID_LENGTH) !=3D 0)=0A=
- {=0A=
-     if (ips_cd_boot =3D=3D 0)                                         =
                                     =0A=
-       printk(KERN_WARNING "Warning: Adapter %d Firmware Compatible =
Version is %s, but should be %s\n", =0A=
-              ha->host_num, FirmwareVersion, Compatable[ =
ha->nvram->adapter_type ]);                    =0A=
      MatchError =3D 1;=0A=
- }=0A=
 =0A=
  if  (strncmp(BiosVersion, IPS_COMPAT_BIOS, IPS_COMPAT_ID_LENGTH) !=3D =
0)=0A=
- {=0A=
-     if (ips_cd_boot =3D=3D 0)                                         =
                                 =0A=
-       printk(KERN_WARNING "Warning: Adapter %d BIOS Compatible =
Version is %s, but should be %s\n", =0A=
-              ha->host_num, BiosVersion, IPS_COMPAT_BIOS);             =
                             =0A=
      MatchError =3D 1;=0A=
- }=0A=
 =0A=
  ha->nvram->versioning =3D 1;          /* Indicate the Driver Supports =
Versioning */=0A=
 =0A=
  if  (MatchError)=0A=
  {=0A=
      ha->nvram->version_mismatch =3D 1;=0A=
-     if (ips_cd_boot =3D=3D 0)                                         =
      =0A=
-       printk(KERN_WARNING "Warning ! ! ! ServeRAID Version =
Mismatch\n");=0A=
+     if (ips_cd_boot =3D=3D 0)=0A=
+     {=0A=
+         strncpy(&BiosString[0], ha->nvram->bios_high, 4);=0A=
+         strncpy(&BiosString[4], ha->nvram->bios_low, 4);=0A=
+         BiosString[8] =3D 0;=0A=
+=0A=
+         strncpy(&FirmwareString[0], ha->enq->CodeBlkVersion, 8);=0A=
+         FirmwareString[8] =3D 0;=0A=
+=0A=
+         printk(KERN_WARNING "Warning ! ! ! ServeRAID Version =
Mismatch\n");=0A=
+         printk(KERN_WARNING "Bios =3D %s, Firmware =3D %s, Device =
Driver =3D %s%s\n",=0A=
+                              BiosString, FirmwareString, =
IPS_VERSION_HIGH, IPS_VERSION_LOW );=0A=
+         printk(KERN_WARNING "These levels should match to avoid =
possible compatibility problems.\n" );=0A=
+     }=0A=
  }=0A=
  else=0A=
  {=0A=
diff -ur linux-2.5.59_p3/drivers/scsi/ips.h =
linux-2.5.59_p4/drivers/scsi/ips.h=0A=
--- linux-2.5.59_p3/drivers/scsi/ips.h	Mon Jan 20 11:43:56 2003=0A=
+++ linux-2.5.59_p4/drivers/scsi/ips.h	Wed Jan 22 14:42:53 2003=0A=
@@ -1221,6 +1221,7 @@=0A=
 #define IPS_VER_BUILD 00=0A=
 #define IPS_VER_BUILD_STRING "00"=0A=
 #define IPS_VER_STRING "5.99.00"=0A=
+#define IPS_BUILD_IDENT 1132=0A=
 =0A=
 /* Version numbers for various adapters */=0A=
 #define IPS_VER_SERVERAID1 "2.25.01"=0A=

------_=_NextPart_000_01C2CE0B.C9491FD0--
