From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 04/21] qla2xxx: Remove unused and obsolete #define's.
Date: Thu,  3 Apr 2008 13:13:15 -0700
Message-ID: <1207253612-15538-4-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761719AbYDCUNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:37 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h      |    2 --
 drivers/scsi/qla2xxx/qla_mbx.c      |    2 --
 drivers/scsi/qla2xxx/qla_os.c       |    9 ---------
 drivers/scsi/qla2xxx/qla_settings.h |   14 --------------
 4 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 70af950..97625d4 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -151,10 +151,8 @@ qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
 extern int
 qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
 
-#if USE_ABORT_TGT
 extern int
 qla2x00_abort_target(fc_port_t *);
-#endif
 
 extern int
 qla2x00_get_adapter_id(scsi_qla_host_t *, uint16_t *, uint8_t *, uint8_t *,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9d92c02..898847e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -776,7 +776,6 @@ qla2x00_abort_command(scsi_qla_host_t *ha, srb_t *sp)
 	return rval;
 }
 
-#if USE_ABORT_TGT
 /*
  * qla2x00_abort_target
  *	Issue abort target mailbox command.
@@ -834,7 +833,6 @@ qla2x00_abort_target(fc_port_t *fcport)
 
 	return rval;
 }
-#endif
 
 /*
  * qla2x00_get_adapter_id
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2d28937..661a159 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -816,15 +816,6 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
 		if (qla2x00_device_reset(ha, fcport) == 0)
 			ret = SUCCESS;
-
-#if defined(LOGOUT_AFTER_DEVICE_RESET)
-		if (ret == SUCCESS) {
-			if (fcport->flags & FC_FABRIC_DEVICE) {
-				ha->isp_ops->fabric_logout(ha, fcport->loop_id);
-				qla2x00_mark_device_lost(ha, fcport, 0, 0);
-			}
-		}
-#endif
 	} else {
 		DEBUG2(printk(KERN_INFO
 		    "%s failed: loop not ready\n",__func__));
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index 4406948..2801c26 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -4,23 +4,9 @@
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-/*
- * Compile time Options:
- *     0 - Disable and 1 - Enable
- */
-#define DEBUG_QLA2100		0	/* For Debug of qla2x00 */
-
-#define USE_ABORT_TGT		1	/* Use Abort Target mbx cmd */
-
 #define MAX_RETRIES_OF_ISP_ABORT	5
 
 /* Max time to wait for the loop to be in LOOP_READY state */
 #define MAX_LOOP_TIMEOUT	(60 * 5)
 
-/*
- * Some vendor subsystems do not recover properly after a device reset.  Define
- * the following to force a logout after a successful device reset.
- */
-#undef LOGOUT_AFTER_DEVICE_RESET
-
 #include "qla_version.h"
-- 
1.5.5.rc2

