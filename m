From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] aic94xx: fix smartctl utility problem
Date: Wed, 05 Sep 2007 15:25:55 -0700
Message-ID: <1189031155.6108.8.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:41963 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756755AbXIEUop (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2007 16:44:45 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id BF6221F24F7
	for <Linux-scsi@vger.kernel.org>; Wed,  5 Sep 2007 13:44:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

   Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does not work on SATA device.
   ( The smartctl v5.38 does need "-d ata" option.)
   The root cause is the aic94xx driver does not return ATA output register due to performance reason.
   The aic94xx need check ATA command which need ATA output register and turn on internal flag to
   enable firmware to return ATA output register to top layer.
   It also add new ATA commands to ata.h sush as ATA_CMD_CHK_MEDIA_TYPE and ATA_CMD_SMART.

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

diff -urN a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-04 14:55:57.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-05 14:55:45.000000000 -0700
@@ -25,6 +25,7 @@
  */
 
 #include <linux/spinlock.h>
+#include <linux/hdreg.h>
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
 #include "aic94xx_hwi.h"
@@ -152,6 +153,22 @@
 		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
 			     task->data_dir);
 }
+static const struct ata_command_table {
+	u8 command;
+	u8 sub_command;
+} ata_command_tbl[] = {
+	{ATA_CMD_CHK_MEDIA_TYPE,         0},
+	{ATA_CMD_DEV_RESET,              0},
+	{ATA_CMD_EDD,                    0},
+	{ATA_CMD_IDLEIMMEDIATE,          0},
+	{ATA_CMD_READ_NATIVE_MAX,        0},
+	{ATA_CMD_READ_NATIVE_MAX_EXT,    0},
+	{ATA_CMD_SET_MAX,                0},
+	{ATA_CMD_SET_MAX_EXT,            0},
+	{ATA_CMD_SMART,                  SMART_STATUS},
+	{ATA_CMD_SMART,                  SMART_IMMEDIATE_OFFLINE}, 
+	{0,0} /* terminate list */
+};
 
 /* ---------- Task complete tasklet ---------- */
 
@@ -253,6 +270,7 @@
 		break;
 	case TC_SSP_RESP:
 	case TC_ATA_RESP:
+	case TC_CSMI:
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_PROTO_RESPONSE;
 		asd_get_response_tasklet(ascb, dl);
@@ -375,6 +393,21 @@
 
 /* ---------- ATA ---------- */
 
+int need_ata_output_reg(u8 command, u8 sub_command)
+{
+
+	int i;
+		
+	for (i = 0; ata_command_tbl[i].command != 0 ; i++) {
+
+		if (ata_command_tbl[i].command == command &&
+			(!ata_command_tbl[i].sub_command || 
+			  ata_command_tbl[i].sub_command == sub_command )) 
+		return 1;
+	}
+	return 0;
+}
+
 static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 			      gfp_t gfp_flags)
 {
@@ -427,6 +460,9 @@
 			flags |= STP_AFFIL_POLICY;
 		scb->ata_task.flags = flags;
 	}
+	if (need_ata_output_reg(scb->ata_task.fis.command,scb->ata_task.fis.features))
+		scb->ata_task.ata_flags|=CSMI_TASK;
+
 	ascb->tasklet_complete = asd_task_tasklet_complete;
 
 	if (likely(!task->ata_task.device_control_reg_update))
diff -urN a/include/linux/ata.h b/include/linux/ata.h
--- a/include/linux/ata.h	2007-09-04 14:48:44.000000000 -0700
+++ b/include/linux/ata.h	2007-09-04 19:28:05.000000000 -0700
@@ -175,6 +175,8 @@
 	ATA_CMD_READ_LOG_EXT	= 0x2f,
 	ATA_CMD_PMP_READ	= 0xE4,
 	ATA_CMD_PMP_WRITE	= 0xE8,
+	ATA_CMD_CHK_MEDIA_TYPE	= 0xD1,
+	ATA_CMD_SMART		= 0xB0,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,


