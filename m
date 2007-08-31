From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
Date: Fri, 31 Aug 2007 11:03:39 -0700
Message-ID: <1188583419.6353.9.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:45282 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965753AbXHaSKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Aug 2007 14:10:20 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id B92F31E3C9C
	for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2007 10:50:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source devic=
e
driver to fix smartctl utility problem.

Contribution:
   Gilbert Wu <gilbert_wu@adaptec.com>

Change Log:


1. Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
   does not work on aic94xx device drive with SATA devices.
   The smartctl utility send down ATA smart command to aic94xx
   driver and fail to get the result which is stored on ATA output
   register.=20
   In normal case, Aic94xx=E2=80=99s firmware does not return the value=
 of
   ATA output register to device driver due to performance reason.
   To solve this issue then the driver need to turn on internal
   flag (CSMI_TASK) for particular ATA command to enable firmware
   to return the value of ATA output register.




Patch: apply to aic94xx-sas-2.6.git development tree

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>




diff -urN old/drivers/scsi/aic94xx/aic94xx_task.c
new/drivers/scsi/aic94xx/aic94xx_task.c
--- old/drivers/scsi/aic94xx/aic94xx_task.c	2007-08-30 16:32:12.0000000=
00 -0700
+++ new/drivers/scsi/aic94xx/aic94xx_task.c	2007-08-30 16:31:50.0000000=
00 -0700
@@ -33,6 +33,11 @@
 static void asd_unbuild_smp_ascb(struct asd_ascb *a);
 static void asd_unbuild_ssp_ascb(struct asd_ascb *a);
=20
+#define ATA_SMART_COMMAND       0xb0
+#define ATA_DEVICE_DIAGNOSTIC   0x90
+#define ATA_CHECK_POWER_MODE    0xe5
+#define ATA_SMART_STATUS        0xda
+
 static inline void asd_can_dequeue(struct asd_ha_struct *asd_ha, int n=
um)
 {
 	unsigned long flags;
@@ -253,6 +258,7 @@
 		break;
 	case TC_SSP_RESP:
 	case TC_ATA_RESP:
+	case TC_CSMI:
 		ts->resp =3D SAS_TASK_COMPLETE;
 		ts->stat =3D SAS_PROTO_RESPONSE;
 		asd_get_response_tasklet(ascb, dl);
@@ -427,6 +433,15 @@
 			flags |=3D STP_AFFIL_POLICY;
 		scb->ata_task.flags =3D flags;
 	}
+
+	if ((scb->ata_task.fis.command =3D=3D ATA_SMART_COMMAND &&
+		scb->ata_task.fis.features =3D=3D ATA_SMART_STATUS)
+		|| scb->ata_task.fis.command =3D=3D ATA_DEVICE_DIAGNOSTIC
+		|| scb->ata_task.fis.command =3D=3D ATA_CHECK_POWER_MODE)
+	{
+		scb->ata_task.ata_flags|=3DCSMI_TASK;
+	}
+
 	ascb->tasklet_complete =3D asd_task_tasklet_complete;
=20
 	if (likely(!task->ata_task.device_control_reg_update))


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
