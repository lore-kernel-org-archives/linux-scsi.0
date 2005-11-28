From: James.Smart@Emulex.Com
Subject: [PATCH 1/11]  lpfc 8.1.1: Miscellaneous Cleanups
Date: Mon, 28 Nov 2005 11:41:15 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C45@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28405 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751288AbVK1QlR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:17 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGfGs3014091
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:16 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Miscellaneous Cleanups:
- Remove ProgType READ_REV mailbox command value check in lpfc_config_port_prep.
- Convert simple printk to an lpfc_printf_log in queuecommand.
- Modify lpfc_abort_handler message 0749 to display more accurate text and data.
- Minor style cleanup: fix 3 long lines in lpfc_hw.h


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2005-11-28 11:14:21.000000000 -0500
@@ -266,9 +266,11 @@ struct lpfc_name {
 		struct {
 #ifdef __BIG_ENDIAN_BITFIELD
 			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
-			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
+			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit
+						   8:11 of IEEE ext */
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
-			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
+			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit
+						   8:11 of IEEE ext */
 			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
 #endif
 
@@ -278,7 +280,8 @@ struct lpfc_name {
 #define NAME_IP_TYPE        0x4	/* IP address */
 #define NAME_CCITT_TYPE     0xC
 #define NAME_CCITT_GR_TYPE  0xE
-			uint8_t IEEEextLsb;	/* FC Word 0, bit 16:23, IEEE extended Lsb */
+			uint8_t IEEEextLsb;	/* FC Word 0, bit 16:23, IEEE
+						   extended Lsb */
 			uint8_t IEEE[6];	/* FC IEEE address */
 		} s;
 		uint8_t wwn[8];
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-11-28 11:13:45.000000000 -0500
@@ -126,34 +126,26 @@ lpfc_config_port_prep(struct lpfc_hba * 
 		return -ERESTART;
 	}
 
-	/* The HBA's current state is provided by the ProgType and rr fields.
-	 * Read and check the value of these fields before continuing to config
-	 * this port.
+	/*
+	 * The value of rr must be 1 since the driver set the cv field to 1.
+	 * This setting requires the FW to set all revision fields.
 	 */
-	if (mb->un.varRdRev.rr == 0 || mb->un.varRdRev.un.b.ProgType != 2) {
-		/* Old firmware */
+	if (mb->un.varRdRev.rr == 0) {
 		vp->rev.rBit = 0;
-		lpfc_printf_log(phba,
-				KERN_ERR,
-				LOG_INIT,
-				"%d:0440 Adapter failed to init, mbxCmd x%x "
-				"READ_REV detected outdated firmware"
-				"Data: x%x\n",
-				phba->brd_no,
-				mb->mbxCommand, 0);
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0440 Adapter failed to init, READ_REV has "
+				"missing revision information.\n",
+				phba->brd_no);
 		mempool_free(pmb, phba->mbox_mem_pool);
 		return -ERESTART;
-	} else {
-		vp->rev.rBit = 1;
-		vp->rev.sli1FwRev = mb->un.varRdRev.sli1FwRev;
-		memcpy(vp->rev.sli1FwName,
-			(char*)mb->un.varRdRev.sli1FwName, 16);
-		vp->rev.sli2FwRev = mb->un.varRdRev.sli2FwRev;
-		memcpy(vp->rev.sli2FwName,
-					(char *)mb->un.varRdRev.sli2FwName, 16);
 	}
 
 	/* Save information as VPD data */
+	vp->rev.rBit = 1;
+	vp->rev.sli1FwRev = mb->un.varRdRev.sli1FwRev;
+	memcpy(vp->rev.sli1FwName, (char*) mb->un.varRdRev.sli1FwName, 16);
+	vp->rev.sli2FwRev = mb->un.varRdRev.sli2FwRev;
+	memcpy(vp->rev.sli2FwName, (char *) mb->un.varRdRev.sli2FwName, 16);
 	vp->rev.biuRev = mb->un.varRdRev.biuRev;
 	vp->rev.smRev = mb->un.varRdRev.smRev;
 	vp->rev.smFwRev = mb->un.varRdRev.un.smFwRev;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-24 10:07:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 11:13:53.000000000 -0500
@@ -721,8 +721,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	}
 	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL) {
-		printk(KERN_WARNING "%s: No buffer available - list empty, "
-		       "total count %d\n", __FUNCTION__, phba->total_scsi_bufs);
+		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+				"%d:0707 driver's buffer pool is empty, "
+				"IO busied\n", phba->brd_no);
 		goto out_host_busy;
 	}
 
@@ -844,8 +845,8 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 
  out:
 	lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-			"%d:0749 SCSI layer issued abort device: ret %#x, "
-			"ID %d, LUN %d, snum %#lx\n",
+			"%d:0749 SCSI Layer I/O Abort Request "
+			"Status x%x ID %d LUN %d snum %#lx\n",
 			phba->brd_no, ret, cmnd->device->id,
 			cmnd->device->lun, cmnd->serial_number);
 
