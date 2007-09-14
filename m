From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 14 Sep 2007 05:30:08 -0700
Message-ID: <1189773008.5949.10.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:53301 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752827AbXINRXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 13:23:13 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 9B94C205522
	for <linux-scsi@vger.kernel.org>; Fri, 14 Sep 2007 10:23:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
not work on SATA device. ( The smartctl v5.38 does need "-d ata"
option.)
  The aic94xx need to return ATA output register for all ATA commands
except ATA Read/Write commands.
  The aic94xx also mark out the DRQ bit from status register which is
treated as AC_ERR_HSM (host state machine violation) error by top layer
if it set to one.
 The firmware of aic94xx chip handle all ATA handshaking, data transfer
and return ATA output register which is sent by the device.  So the DRQ
bit may not reflect the last state of device when the command finished
and it is no meaning for the caller.

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>


diff -urN a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
--- a/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-13 04:46:00.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_task.c	2007-09-13 04:46:31.000000000 -0700
@@ -25,6 +25,7 @@
  */
 
 #include <linux/spinlock.h>
+#include <linux/ata.h>
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
 #include "aic94xx_hwi.h"
@@ -220,6 +221,7 @@
 			memcpy(&resp->ending_fis[0], r+16, 24);
 			ts->buf_valid_size = sizeof(*resp);
 		}
+		resp->ending_fis[2] &= ~ATA_DRQ;
 	}
 
 	asd_invalidate_edb(escb, edb_id);
@@ -257,6 +259,11 @@
 		ts->stat = SAS_PROTO_RESPONSE;
 		asd_get_response_tasklet(ascb, dl);
 		break;
+	case TC_CSMI:
+		ts->resp = SAS_TASK_COMPLETE;
+		ts->stat = SAM_GOOD;
+		asd_get_response_tasklet(ascb, dl);
+		break;
 	case TF_OPEN_REJECT:
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_OPEN_REJECT;
@@ -374,7 +381,32 @@
 }
 
 /* ---------- ATA ---------- */
+int is_ata_rw_cmd(u8 ata_cmd)
+{
 
+	switch (ata_cmd) {
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_FUA_EXT:
+	case ATA_CMD_FPDMA_READ:
+	case ATA_CMD_FPDMA_WRITE:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	case ATA_CMD_READ_MULTI:
+	case ATA_CMD_READ_MULTI_EXT:
+	case ATA_CMD_WRITE_MULTI:
+	case ATA_CMD_WRITE_MULTI_EXT:
+	case ATA_CMD_WRITE_MULTI_FUA_EXT:
+	case ATA_CMD_VERIFY:
+	case ATA_CMD_VERIFY_EXT:
+		return 1;
+	}
+	return 0;
+}
 static int asd_build_ata_ascb(struct asd_ascb *ascb, struct sas_task *task,
 			      gfp_t gfp_flags)
 {
@@ -427,6 +459,9 @@
 			flags |= STP_AFFIL_POLICY;
 		scb->ata_task.flags = flags;
 	}
+	if (!is_ata_rw_cmd(scb->ata_task.fis.command))
+		scb->ata_task.ata_flags|=CSMI_TASK;
+
 	ascb->tasklet_complete = asd_task_tasklet_complete;
 
 	if (likely(!task->ata_task.device_control_reg_update))



