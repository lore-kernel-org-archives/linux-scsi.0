From: James.Smart@Emulex.Com
Subject: [PATCH 6 of 7] lpfc driver 8.0.30 :  convert to use of int_to_scsilun()
Date: Wed, 10 Aug 2005 15:03:09 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F43A2@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9102 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1030200AbVHJTDL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:03:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ3Ar7000780
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:03:10 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Replace use of lpfc_put_lun with midlayer's int_to_scsilun

Remove driver's local definition of lpfc_put_lun (which converts an
int back to a 64-bit LUN) and replace it's use with the recently added
int_to_scsilun function provided by the midlayer.

Note: Embedding midlayer structure in our structure caused
need for more files to include midlayer headers.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -24,6 +24,7 @@
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -40,11 +40,6 @@
 #define LPFC_RESET_WAIT  2
 #define LPFC_ABORT_WAIT  2
 
-static inline void lpfc_put_lun(struct fcp_cmnd *fcmd, unsigned int lun)
-{
-	fcmd->fcpLunLsl = 0;
-	fcmd->fcpLunMsl = swab16((uint16_t)lun);
-}
 
 /*
  * This routine allocates a scsi buffer, which contains all the necessary
@@ -453,7 +448,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 	/* clear task management bits */
 	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
 
-	lpfc_put_lun(lpfc_cmd->fcp_cmnd, lpfc_cmd->pCmd->device->lun);
+	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
+			&lpfc_cmd->fcp_cmnd->fcp_lun);
 
 	memcpy(&fcp_cmnd->fcpCdb[0], scsi_cmnd->cmnd, 16);
 
@@ -552,7 +548,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	piocb = &piocbq->iocb;
 
 	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	lpfc_put_lun(lpfc_cmd->fcp_cmnd, lpfc_cmd->pCmd->device->lun);
+	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
+			&lpfc_cmd->fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
 
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -26,6 +26,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include <scsi/scsi.h>
+
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_disc.h"
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -78,18 +78,7 @@ struct fcp_rsp {
 };
 
 struct fcp_cmnd {
-	uint32_t fcpLunMsl;	/* most  significant lun word (32 bits) */
-	uint32_t fcpLunLsl;	/* least significant lun word (32 bits) */
-	/* # of bits to shift lun id to end up in right
-	 * payload word, little endian = 8, big = 16.
-	 */
-#ifdef __BIG_ENDIAN
-#define FC_LUN_SHIFT         16
-#define FC_ADDR_MODE_SHIFT   24
-#else	/*  __LITTLE_ENDIAN */
-#define FC_LUN_SHIFT         8
-#define FC_ADDR_MODE_SHIFT   0
-#endif
+	struct scsi_lun  fcp_lun;
 
 	uint8_t fcpCntl0;	/* FCP_CNTL byte 0 (reserved) */
 	uint8_t fcpCntl1;	/* FCP_CNTL byte 1 task codes */
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -26,6 +26,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
 
+#include <scsi/scsi.h>
+
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_disc.h"
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
+#include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
