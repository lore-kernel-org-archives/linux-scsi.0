From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device driver for new sequence firmware.
Date: Tue, 30 Jan 2007 15:31:25 -0800
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B0F59B6@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:53636 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXA3Xb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 18:31:26 -0500
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 7732B12BEF2
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 15:31:25 -0800 (PST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
driver for new sequence firmware.

 

Contribution:

   Ed Chim <ed_chim@adaptec.com>
   Gilbert Wu <gilbert_wu@adaptec.com>

Change Log:
 
1.    Use dword instead of qword to display the value of Connection
State register for debug purpose.

2.    There are some registers location of AIC94xx chip has been changed
according to the new V28 firmware. The patch has redefined the register
location and provided initialization.

3.    The new sequencer firmware v28 for Aic94xx SAS/SATA Linux open
source device driver can be downloaded from
http://www.adaptec.com/NR/exeres/35B611BC-9789-4B5B-82C6-85A2CCA8A46A.ht
m

 

Patch: apply to scsi-misc-2.6.git development tree

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>



diff -urN a/drivers/scsi/aic94xx/aic94xx_dump.c
b/drivers/scsi/aic94xx/aic94xx_dump.c
--- a/drivers/scsi/aic94xx/aic94xx_dump.c	2007-01-29
10:20:44.000000000 -0800
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c	2007-01-29
10:31:44.000000000 -0800
@@ -556,7 +556,7 @@
 	PRINT_LMIP_word(asd_ha, lseq, Q_TGTXFR_TAIL);
 	PRINT_LMIP_byte(asd_ha, lseq, LINK_NUMBER);
 	PRINT_LMIP_byte(asd_ha, lseq, SCRATCH_FLAGS);
-	PRINT_LMIP_qword(asd_ha, lseq, CONNECTION_STATE);
+	PRINT_LMIP_dword(asd_ha, lseq, CONNECTION_STATE);
 	PRINT_LMIP_word(asd_ha, lseq, CONCTL);
 	PRINT_LMIP_byte(asd_ha, lseq, CONSTAT);
 	PRINT_LMIP_byte(asd_ha, lseq, CONNECTION_MODES);
diff -urN a/drivers/scsi/aic94xx/aic94xx_reg_def.h
b/drivers/scsi/aic94xx/aic94xx_reg_def.h
--- a/drivers/scsi/aic94xx/aic94xx_reg_def.h	2007-01-29
10:21:14.000000000 -0800
+++ b/drivers/scsi/aic94xx/aic94xx_reg_def.h	2007-01-29
10:35:54.000000000 -0800
@@ -2226,9 +2226,10 @@
 #define LmSEQ_SAS_RESET_MODE(LinkNum)		(LmSCRATCH(LinkNum) +
0x0074)
 #define LmSEQ_LINK_RESET_RETRY_COUNT(LinkNum)	(LmSCRATCH(LinkNum) +
0x0075)
 #define LmSEQ_NUM_LINK_RESET_RETRIES(LinkNum)	(LmSCRATCH(LinkNum) +
0x0076)
-#define LmSEQ_OOB_INT_ENABLES(LinkNum)		(LmSCRATCH(LinkNum) +
0x007A)
+#define LmSEQ_OOB_INT_ENABLES(LinkNum)		(LmSCRATCH(LinkNum) +
0x0078)
+#define LmSEQ_NOTIFY_TIMER_DOWN_COUNT(LinkNum)	(LmSCRATCH(LinkNum) +
0x007A)
 #define LmSEQ_NOTIFY_TIMER_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) +
0x007C)
-#define LmSEQ_NOTIFY_TIMER_DOWN_COUNT(LinkNum)	(LmSCRATCH(LinkNum) +
0x007E)
+#define LmSEQ_NOTIFY_TIMER_INITIAL_COUNT(LinkNum) (LmSCRATCH(LinkNum) +
0x007E)
 
 /* Mode dependent scratch page 1, mode 0 and mode 1 */
 #define LmSEQ_SG_LIST_PTR_ADDR0(LinkNum)        (LmSCRATCH(LinkNum) +
0x0020)
diff -urN a/drivers/scsi/aic94xx/aic94xx_seq.c
b/drivers/scsi/aic94xx/aic94xx_seq.c
--- a/drivers/scsi/aic94xx/aic94xx_seq.c	2007-01-29
10:21:28.000000000 -0800
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c	2007-01-29
10:42:55.000000000 -0800
@@ -810,6 +810,8 @@
 	/* No delay for the first NOTIFY to be sent to the attached
target. */
 	asd_write_reg_word(asd_ha, LmSEQ_NOTIFY_TIMER_DOWN_COUNT(lseq),
 			   ASD_NOTIFY_DOWN_COUNT);
+	asd_write_reg_word(asd_ha,
LmSEQ_NOTIFY_TIMER_INITIAL_COUNT(lseq),
+			   ASD_NOTIFY_DOWN_COUNT);
 
 	/* LSEQ Mode dependent, mode 0 and 1, page 1 setup. */
 	for (i = 0; i < 2; i++)	{
