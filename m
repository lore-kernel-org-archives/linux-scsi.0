From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 12/23] advansys: remove AscCompareString()
Date: Mon, 30 Jul 2007 10:56:57 -0600
Message-ID: <1185814628436-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx> <11858146283924-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43702 "EHLO
	smtp-04.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936837AbXG3Q5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:10 -0400
In-Reply-To: <11858146283924-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

AscCompareString() is just another name for strncmp

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 424549d..277002a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1911,7 +1911,6 @@ static int AscIsrChipHalted(ASC_DVC_VAR *);
 static uchar _AscCopyLramScsiDoneQ(PortAddr, ushort,
 				   ASC_QDONE_INFO *, ASC_DCNT);
 static int AscIsrQDone(ASC_DVC_VAR *);
-static int AscCompareString(uchar *, uchar *, int);
 #ifdef CONFIG_ISA
 static ushort AscGetEisaChipCfg(PortAddr);
 #endif /* CONFIG_ISA */
@@ -10998,8 +10997,7 @@ AscAsyncFix(ASC_DVC_VAR *asc_dvc, uchar tid_no, ASC_SCSI_INQUIRY *inq)
 	if (asc_dvc->bug_fix_cntl & ASC_BUG_FIX_ASYN_USE_SYN) {
 		if (!(asc_dvc->init_sdtr & tid_bits)) {
 			if ((dvc_type == TYPE_ROM) &&
-			    (AscCompareString((uchar *)inq->vendor_id,
-					      (uchar *)"HP ", 3) == 0)) {
+			    (strncmp(inq->vendor_id, "HP ", 3) == 0)) {
 				asc_dvc->pci_fix_asyn_xfer_always |= tid_bits;
 			}
 			asc_dvc->pci_fix_asyn_xfer |= tid_bits;
@@ -11022,10 +11020,8 @@ AscAsyncFix(ASC_DVC_VAR *asc_dvc, uchar tid_no, ASC_SCSI_INQUIRY *inq)
 static int AscTagQueuingSafe(ASC_SCSI_INQUIRY *inq)
 {
 	if ((inq->add_len >= 32) &&
-	    (AscCompareString((uchar *)inq->vendor_id,
-			      (uchar *)"QUANTUM XP34301", 15) == 0) &&
-	    (AscCompareString((uchar *)inq->product_rev_level,
-			      (uchar *)"1071", 4) == 0)) {
+	    (strncmp(inq->vendor_id, "QUANTUM XP34301", 15) == 0) &&
+	    (strncmp(inq->product_rev_level, "1071", 4) == 0)) {
 		return 0;
 	}
 	return 1;
@@ -11076,19 +11072,6 @@ AscInquiryHandling(ASC_DVC_VAR *asc_dvc, uchar tid_no, ASC_SCSI_INQUIRY *inq)
 	return;
 }
 
-static int AscCompareString(uchar *str1, uchar *str2, int len)
-{
-	int i;
-	int diff;
-
-	for (i = 0; i < len; i++) {
-		diff = (int)(str1[i] - str2[i]);
-		if (diff != 0)
-			return (diff);
-	}
-	return (0);
-}
-
 static uchar AscReadLramByte(PortAddr iop_base, ushort addr)
 {
 	uchar byte_data;
-- 
1.4.4.4

