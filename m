From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [RESEND][PATCH] qla2xxx: use t10_pi_tuple
Date: Sun, 12 Jul 2015 16:06:31 +0200
Message-ID: <20150712160631.000059ca@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57627 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbGLOGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 10:06:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, Sebastian Herbszt <herbszt@gmx.de>

Drop unused scsi_dif_tuple and use t10_pi_tuple instead of own sd_dif_tuple copy.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>

diff -urp linux/drivers/scsi/qla2xxx-orig/qla_def.h linux/drivers/scsi/qla2xxx/qla_def.h
--- linux/drivers/scsi/qla2xxx-orig/qla_def.h	2015-04-15 06:18:24.681045138 +0200
+++ linux/drivers/scsi/qla2xxx/qla_def.h	2015-07-09 09:45:44.285703687 +0200
@@ -25,6 +25,7 @@
 #include <linux/firmware.h>
 #include <linux/aer.h>
 #include <linux/mutex.h>
+#include <linux/t10-pi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -276,16 +277,6 @@
 struct req_que;
 
 /*
- * (sd.h is not exported, hence local inclusion)
- * Data Integrity Field tuple.
- */
-struct sd_dif_tuple {
-	__be16 guard_tag;	/* Checksum */
-	__be16 app_tag;		/* Opaque storage */
-	__be32 ref_tag;		/* Target LBA or indirect LBA */
-};
-
-/*
  * SCSI Request Block
  */
 struct srb_cmd {
diff -urp linux/drivers/scsi/qla2xxx-orig/qla_isr.c linux/drivers/scsi/qla2xxx/qla_isr.c
--- linux/drivers/scsi/qla2xxx-orig/qla_isr.c	2015-07-05 22:18:44.157739160 +0200
+++ linux/drivers/scsi/qla2xxx/qla_isr.c	2015-07-09 09:45:44.289703687 +0200
@@ -1711,12 +1711,6 @@ qla2x00_handle_sense(srb_t *sp, uint8_t
 	}
 }
 
-struct scsi_dif_tuple {
-	__be16 guard;       /* Checksum */
-	__be16 app_tag;         /* APPL identifier */
-	__be32 ref_tag;         /* Target LBA or indirect LBA */
-};
-
 /*
  * Checks the guard or meta-data for the type of error
  * detected by the HBA. In case of errors, we set the
@@ -1779,7 +1773,7 @@ qla2x00_handle_dif_error(srb_t *sp, stru
 		if (scsi_prot_sg_count(cmd)) {
 			uint32_t i, j = 0, k = 0, num_ent;
 			struct scatterlist *sg;
-			struct sd_dif_tuple *spt;
+			struct t10_pi_tuple *pi;
 
 			/* Patch the corresponding protection tags */
 			scsi_for_each_prot_sg(cmd, sg,
@@ -1801,12 +1795,12 @@ qla2x00_handle_dif_error(srb_t *sp, stru
 				return 1;
 			}
 
-			spt = page_address(sg_page(sg)) + sg->offset;
-			spt += j;
+			pi = page_address(sg_page(sg)) + sg->offset;
+			pi += j;
 
-			spt->app_tag = 0xffff;
+			pi->app_tag = 0xffff;
 			if (scsi_get_prot_type(cmd) == SCSI_PROT_DIF_TYPE3)
-				spt->ref_tag = 0xffffffff;
+				pi->ref_tag = 0xffffffff;
 		}
 
 		return 0;
diff -urp linux/drivers/scsi/qla2xxx-orig/qla_target.c linux/drivers/scsi/qla2xxx/qla_target.c
--- linux/drivers/scsi/qla2xxx-orig/qla_target.c	2015-07-05 22:18:44.177739161 +0200
+++ linux/drivers/scsi/qla2xxx/qla_target.c	2015-07-09 09:45:44.293703687 +0200
@@ -2589,17 +2589,17 @@ qlt_handle_dif_error(struct scsi_qla_hos
 			}
 
 #if 0
-			struct sd_dif_tuple *spt;
+			struct t10_pi_tuple *pi;
 			/* TODO:
 			 * This section came from initiator. Is it valid here?
 			 * should ulp be override with actual val???
 			 */
-			spt = page_address(sg_page(sg)) + sg->offset;
-			spt += j;
+			pi = page_address(sg_page(sg)) + sg->offset;
+			pi += j;
 
-			spt->app_tag = 0xffff;
+			pi->app_tag = 0xffff;
 			if (cmd->se_cmd.prot_type == SCSI_PROT_DIF_TYPE3)
-				spt->ref_tag = 0xffffffff;
+				pi->ref_tag = 0xffffffff;
 #endif
 		}
 
