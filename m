From: James.Smart@Emulex.Com
Subject: [PATCH 2/11]  lpfc 8.1.1 : Correct some 8bit to 16bit field conversions/comparisons
Date: Mon, 28 Nov 2005 11:41:24 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C46@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:30453 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751289AbVK1Ql0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:41:26 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGfPs3014097
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:41:25 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Correct some 8bit to 16bit field conversions/comparisons


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2005-11-24 10:07:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2005-11-28 09:49:30.000000000 -0500
@@ -55,55 +55,76 @@ lpfc_check_adisc(struct lpfc_hba * phba,
 	return (1);
 }
 
-
 int
 lpfc_check_sparm(struct lpfc_hba * phba,
 		 struct lpfc_nodelist * ndlp, struct serv_parm * sp,
 		 uint32_t class)
 {
 	volatile struct serv_parm *hsp = &phba->fc_sparam;
-	/* First check for supported version */
+	uint16_t hsp_value, ssp_value = 0;
 
-	/* Next check for class validity */
+	/*
+	 * The receive data field size and buffer-to-buffer receive data field
+	 * size entries are 16 bits but are represented as two 8-bit fields in
+	 * the driver data structure to account for rsvd bits and other control
+	 * bits.  Reconstruct and compare the fields as a 16-bit values before
+	 * correcting the byte values.
+	 */
 	if (sp->cls1.classValid) {
-
-		if (sp->cls1.rcvDataSizeMsb > hsp->cls1.rcvDataSizeMsb)
-			sp->cls1.rcvDataSizeMsb = hsp->cls1.rcvDataSizeMsb;
-		if (sp->cls1.rcvDataSizeLsb > hsp->cls1.rcvDataSizeLsb)
+		hsp_value = (hsp->cls1.rcvDataSizeMsb << 8) |
+				hsp->cls1.rcvDataSizeLsb;
+		ssp_value = (sp->cls1.rcvDataSizeMsb << 8) |
+				sp->cls1.rcvDataSizeLsb;
+		if (ssp_value > hsp_value) {
 			sp->cls1.rcvDataSizeLsb = hsp->cls1.rcvDataSizeLsb;
+			sp->cls1.rcvDataSizeMsb = hsp->cls1.rcvDataSizeMsb;
+		}
 	} else if (class == CLASS1) {
-		return (0);
+		return 0;
 	}
 
 	if (sp->cls2.classValid) {
-
-		if (sp->cls2.rcvDataSizeMsb > hsp->cls2.rcvDataSizeMsb)
-			sp->cls2.rcvDataSizeMsb = hsp->cls2.rcvDataSizeMsb;
-		if (sp->cls2.rcvDataSizeLsb > hsp->cls2.rcvDataSizeLsb)
+		hsp_value = (hsp->cls2.rcvDataSizeMsb << 8) |
+				hsp->cls2.rcvDataSizeLsb;
+		ssp_value = (sp->cls2.rcvDataSizeMsb << 8) |
+				sp->cls2.rcvDataSizeLsb;
+		if (ssp_value > hsp_value) {
 			sp->cls2.rcvDataSizeLsb = hsp->cls2.rcvDataSizeLsb;
+			sp->cls2.rcvDataSizeMsb = hsp->cls2.rcvDataSizeMsb;
+		}
 	} else if (class == CLASS2) {
-		return (0);
+		return 0;
 	}
 
 	if (sp->cls3.classValid) {
-
-		if (sp->cls3.rcvDataSizeMsb > hsp->cls3.rcvDataSizeMsb)
-			sp->cls3.rcvDataSizeMsb = hsp->cls3.rcvDataSizeMsb;
-		if (sp->cls3.rcvDataSizeLsb > hsp->cls3.rcvDataSizeLsb)
+		hsp_value = (hsp->cls3.rcvDataSizeMsb << 8) |
+				hsp->cls3.rcvDataSizeLsb;
+		ssp_value = (sp->cls3.rcvDataSizeMsb << 8) |
+				sp->cls3.rcvDataSizeLsb;
+		if (ssp_value > hsp_value) {
 			sp->cls3.rcvDataSizeLsb = hsp->cls3.rcvDataSizeLsb;
+			sp->cls3.rcvDataSizeMsb = hsp->cls3.rcvDataSizeMsb;
+		}
 	} else if (class == CLASS3) {
-		return (0);
+		return 0;
 	}
 
-	if (sp->cmn.bbRcvSizeMsb > hsp->cmn.bbRcvSizeMsb)
-		sp->cmn.bbRcvSizeMsb = hsp->cmn.bbRcvSizeMsb;
-	if (sp->cmn.bbRcvSizeLsb > hsp->cmn.bbRcvSizeLsb)
+	/*
+	 * Preserve the upper four bits of the MSB from the PLOGI response.
+	 * These bits contain the Buffer-to-Buffer State Change Number
+	 * from the target and need to be passed to the FW.
+	 */
+	hsp_value = (hsp->cmn.bbRcvSizeMsb << 8) | hsp->cmn.bbRcvSizeLsb;
+	ssp_value = (sp->cmn.bbRcvSizeMsb << 8) | sp->cmn.bbRcvSizeLsb;
+	if (ssp_value > hsp_value) {
 		sp->cmn.bbRcvSizeLsb = hsp->cmn.bbRcvSizeLsb;
+		sp->cmn.bbRcvSizeMsb = (sp->cmn.bbRcvSizeMsb & 0xF0) |
+				       (hsp->cmn.bbRcvSizeMsb & 0x0F);
+	}
 
-	/* If check is good, copy wwpn wwnn into ndlp */
 	memcpy(&ndlp->nlp_nodename, &sp->nodeName, sizeof (struct lpfc_name));
 	memcpy(&ndlp->nlp_portname, &sp->portName, sizeof (struct lpfc_name));
-	return (1);
+	return 1;
 }
 
 static void *
