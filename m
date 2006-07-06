From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 14/15] lpfc 8.1.7 : Misc Fixes
Date: Thu, 06 Jul 2006 15:50:50 -0400
Message-ID: <1152215450.23158.31.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33420 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750785AbWGFTue
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:34 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JoXtW006998
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Misc Fixes:
 - Fix some sparse warnings - casts of address space
 - Fix handling of the adapter registration string. Each invocation
   was byteswapping, so every other adapter init attempt failed.
 - Correct comments and default value for the lpfc_max_luns parameter

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 15:04:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-07-06 15:09:56.000000000 -0400
@@ -706,12 +706,12 @@ LPFC_ATTR(discovery_threads, 32, 1, 64, 
 		 "during discovery");
 
 /*
-# lpfc_max_luns: maximum number of LUNs per target driver will support
-# Value range is [1,32768]. Default value is 256.
-# NOTE: The SCSI layer will scan each target for this many luns
+# lpfc_max_luns: maximum allowed LUN.
+# Value range is [0,65535]. Default value is 255.
+# NOTE: The SCSI layer might probe all allowed LUN on some old targets.
 */
-LPFC_ATTR_R(max_luns, 256, 1, 32768,
-	     "Maximum number of LUNs per target driver will support");
+LPFC_ATTR_R(max_luns, 255, 0, 65535,
+	     "Maximum allowed LUN");
 
 /*
 # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 15:07:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 15:09:56.000000000 -0400
@@ -71,6 +71,7 @@ lpfc_config_port_prep(struct lpfc_hba * 
 	uint16_t offset = 0;
 	static char licensed[56] =
 		    "key unlock for use with gnu public licensed code only\0";
+	static int init_key = 1;
 
 	pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
@@ -82,10 +83,13 @@ lpfc_config_port_prep(struct lpfc_hba * 
 	phba->hba_state = LPFC_INIT_MBX_CMDS;
 
 	if (lpfc_is_LC_HBA(phba->pcidev->device)) {
-		uint32_t *ptext = (uint32_t *) licensed;
+		if (init_key) {
+			uint32_t *ptext = (uint32_t *) licensed;
 
-		for (i = 0; i < 56; i += sizeof (uint32_t), ptext++)
-			*ptext = cpu_to_be32(*ptext);
+			for (i = 0; i < 56; i += sizeof (uint32_t), ptext++)
+				*ptext = cpu_to_be32(*ptext);
+			init_key = 0;
+		}
 
 		lpfc_read_nv(phba, pmb);
 		memset((char*)mb->un.varRDnvp.rsvd3, 0,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-07-06 15:07:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-07-06 15:09:56.000000000 -0400
@@ -1547,8 +1547,8 @@ lpfc_sli_brdready(struct lpfc_hba * phba
 
 void lpfc_reset_barrier(struct lpfc_hba * phba)
 {
-	uint32_t * resp_buf;
-	uint32_t * mbox_buf;
+	uint32_t __iomem *resp_buf;
+	uint32_t __iomem *mbox_buf;
 	volatile uint32_t mbox;
 	uint32_t hc_copy;
 	int  i;
@@ -1564,7 +1564,7 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	 * Tell the other part of the chip to suspend temporarily all
 	 * its DMA activity.
 	 */
-	resp_buf =  (uint32_t *)phba->MBslimaddr;
+	resp_buf = phba->MBslimaddr;
 
 	/* Disable the error attention */
 	hc_copy = readl(phba->HCregaddr);
@@ -1582,7 +1582,7 @@ void lpfc_reset_barrier(struct lpfc_hba 
 	((MAILBOX_t *)&mbox)->mbxOwner = OWN_CHIP;
 
 	writel(BARRIER_TEST_PATTERN, (resp_buf + 1));
-	mbox_buf = (uint32_t *)phba->MBslimaddr;
+	mbox_buf = phba->MBslimaddr;
 	writel(mbox, mbox_buf);
 
 	for (i = 0;
@@ -1782,7 +1782,7 @@ lpfc_sli_brdrestart(struct lpfc_hba * ph
 		skip_post = 0;
 		word0 = 0;	/* This is really setting up word1 */
 	}
-	to_slim = (uint8_t *) phba->MBslimaddr + sizeof (uint32_t);
+	to_slim = phba->MBslimaddr + sizeof (uint32_t);
 	writel(*(uint32_t *) mb, to_slim);
 	readl(to_slim); /* flush */
 


