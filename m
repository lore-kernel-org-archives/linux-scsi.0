From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 02/22] advansys: Create AdvBuildCarrierFreelist
Date: Sun,  9 Sep 2007 08:56:27 -0600
Message-ID: <11893498071264-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44507 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbXIIO4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:47 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Split AdvBuildCarrierFreelist out of AdvInitAsc3550Driver,
AdvInitAsc38C0800Driver and AdvInitAsc38C1600Driver.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  219 +++++++++++-----------------------------------
 1 files changed, 53 insertions(+), 166 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 27b3e95..c216d6a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -12881,6 +12881,56 @@ AdvInitGetConfig(struct pci_dev *pdev, ADV_DVC_VAR *asc_dvc)
 	return warn_code;
 }
 
+static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
+{
+	ADV_CARR_T *carrp;
+	ADV_SDCNT buf_size;
+	ADV_PADDR carr_paddr;
+
+	BUG_ON(!asc_dvc->carrier_buf);
+
+	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
+	asc_dvc->carr_freelist = NULL;
+	if (carrp == asc_dvc->carrier_buf) {
+		buf_size = ADV_CARRIER_BUFSIZE;
+	} else {
+		buf_size = ADV_CARRIER_BUFSIZE - sizeof(ADV_CARR_T);
+	}
+
+	do {
+		/* Get physical address of the carrier 'carrp'. */
+		ADV_DCNT contig_len = sizeof(ADV_CARR_T);
+		carr_paddr = cpu_to_le32(DvcGetPhyAddr(asc_dvc, NULL,
+						       (uchar *)carrp,
+						       (ADV_SDCNT *)&contig_len,
+						       ADV_IS_CARRIER_FLAG));
+
+		buf_size -= sizeof(ADV_CARR_T);
+
+		/*
+		 * If the current carrier is not physically contiguous, then
+		 * maybe there was a page crossing. Try the next carrier
+		 * aligned start address.
+		 */
+		if (contig_len < sizeof(ADV_CARR_T)) {
+			carrp++;
+			continue;
+		}
+
+		carrp->carr_pa = carr_paddr;
+		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
+
+		/*
+		 * Insert the carrier at the beginning of the freelist.
+		 */
+		carrp->next_vpa =
+			cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
+		asc_dvc->carr_freelist = carrp;
+
+		carrp++;
+	} while (buf_size > 0);
+}
+
 /*
  * Initialize the ASC-3550.
  *
@@ -12902,10 +12952,6 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	int word;
 	int j;
 	int adv_asc3550_expanded_size;
-	ADV_CARR_T *carrp;
-	ADV_DCNT contig_len;
-	ADV_SDCNT buf_size;
-	ADV_PADDR carr_paddr;
 	int i;
 	ushort scsi_cfg1;
 	uchar tid;
@@ -13307,57 +13353,7 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	AdvWriteWordLram(iop_base, ASC_MC_DEFAULT_SEL_MASK,
 			 ADV_TID_TO_TIDMASK(asc_dvc->chip_scsi_id));
 
-	/*
-	 * Build carrier freelist.
-	 *
-	 * Driver must have already allocated memory and set 'carrier_buf'.
-	 */
-	ASC_ASSERT(asc_dvc->carrier_buf != NULL);
-
-	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
-	asc_dvc->carr_freelist = NULL;
-	if (carrp == (ADV_CARR_T *) asc_dvc->carrier_buf) {
-		buf_size = ADV_CARRIER_BUFSIZE;
-	} else {
-		buf_size = ADV_CARRIER_BUFSIZE - sizeof(ADV_CARR_T);
-	}
-
-	do {
-		/*
-		 * Get physical address of the carrier 'carrp'.
-		 */
-		contig_len = sizeof(ADV_CARR_T);
-		carr_paddr =
-		    cpu_to_le32(DvcGetPhyAddr
-				(asc_dvc, NULL, (uchar *)carrp,
-				 (ADV_SDCNT *)&contig_len,
-				 ADV_IS_CARRIER_FLAG));
-
-		buf_size -= sizeof(ADV_CARR_T);
-
-		/*
-		 * If the current carrier is not physically contiguous, then
-		 * maybe there was a page crossing. Try the next carrier aligned
-		 * start address.
-		 */
-		if (contig_len < sizeof(ADV_CARR_T)) {
-			carrp++;
-			continue;
-		}
-
-		carrp->carr_pa = carr_paddr;
-		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
-
-		/*
-		 * Insert the carrier at the beginning of the freelist.
-		 */
-		carrp->next_vpa =
-		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
-		asc_dvc->carr_freelist = carrp;
-
-		carrp++;
-	}
-	while (buf_size > 0);
+	AdvBuildCarrierFreelist(asc_dvc);
 
 	/*
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
@@ -13471,10 +13467,6 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	int word;
 	int j;
 	int adv_asc38C0800_expanded_size;
-	ADV_CARR_T *carrp;
-	ADV_DCNT contig_len;
-	ADV_SDCNT buf_size;
-	ADV_PADDR carr_paddr;
 	int i;
 	ushort scsi_cfg1;
 	uchar byte;
@@ -13920,57 +13912,7 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	AdvWriteWordLram(iop_base, ASC_MC_DEFAULT_SEL_MASK,
 			 ADV_TID_TO_TIDMASK(asc_dvc->chip_scsi_id));
 
-	/*
-	 * Build the carrier freelist.
-	 *
-	 * Driver must have already allocated memory and set 'carrier_buf'.
-	 */
-	ASC_ASSERT(asc_dvc->carrier_buf != NULL);
-
-	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
-	asc_dvc->carr_freelist = NULL;
-	if (carrp == (ADV_CARR_T *) asc_dvc->carrier_buf) {
-		buf_size = ADV_CARRIER_BUFSIZE;
-	} else {
-		buf_size = ADV_CARRIER_BUFSIZE - sizeof(ADV_CARR_T);
-	}
-
-	do {
-		/*
-		 * Get physical address for the carrier 'carrp'.
-		 */
-		contig_len = sizeof(ADV_CARR_T);
-		carr_paddr =
-		    cpu_to_le32(DvcGetPhyAddr
-				(asc_dvc, NULL, (uchar *)carrp,
-				 (ADV_SDCNT *)&contig_len,
-				 ADV_IS_CARRIER_FLAG));
-
-		buf_size -= sizeof(ADV_CARR_T);
-
-		/*
-		 * If the current carrier is not physically contiguous, then
-		 * maybe there was a page crossing. Try the next carrier aligned
-		 * start address.
-		 */
-		if (contig_len < sizeof(ADV_CARR_T)) {
-			carrp++;
-			continue;
-		}
-
-		carrp->carr_pa = carr_paddr;
-		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
-
-		/*
-		 * Insert the carrier at the beginning of the freelist.
-		 */
-		carrp->next_vpa =
-		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
-		asc_dvc->carr_freelist = carrp;
-
-		carrp++;
-	}
-	while (buf_size > 0);
+	AdvBuildCarrierFreelist(asc_dvc);
 
 	/*
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
@@ -14087,10 +14029,6 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	long word;
 	int j;
 	int adv_asc38C1600_expanded_size;
-	ADV_CARR_T *carrp;
-	ADV_DCNT contig_len;
-	ADV_SDCNT buf_size;
-	ADV_PADDR carr_paddr;
 	int i;
 	ushort scsi_cfg1;
 	uchar byte;
@@ -14544,58 +14482,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	AdvWriteWordLram(iop_base, ASC_MC_DEFAULT_SEL_MASK,
 			 ADV_TID_TO_TIDMASK(asc_dvc->chip_scsi_id));
 
-	/*
-	 * Build the carrier freelist.
-	 *
-	 * Driver must have already allocated memory and set 'carrier_buf'.
-	 */
-
-	ASC_ASSERT(asc_dvc->carrier_buf != NULL);
-
-	carrp = (ADV_CARR_T *) ADV_16BALIGN(asc_dvc->carrier_buf);
-	asc_dvc->carr_freelist = NULL;
-	if (carrp == (ADV_CARR_T *) asc_dvc->carrier_buf) {
-		buf_size = ADV_CARRIER_BUFSIZE;
-	} else {
-		buf_size = ADV_CARRIER_BUFSIZE - sizeof(ADV_CARR_T);
-	}
-
-	do {
-		/*
-		 * Get physical address for the carrier 'carrp'.
-		 */
-		contig_len = sizeof(ADV_CARR_T);
-		carr_paddr =
-		    cpu_to_le32(DvcGetPhyAddr
-				(asc_dvc, NULL, (uchar *)carrp,
-				 (ADV_SDCNT *)&contig_len,
-				 ADV_IS_CARRIER_FLAG));
-
-		buf_size -= sizeof(ADV_CARR_T);
-
-		/*
-		 * If the current carrier is not physically contiguous, then
-		 * maybe there was a page crossing. Try the next carrier aligned
-		 * start address.
-		 */
-		if (contig_len < sizeof(ADV_CARR_T)) {
-			carrp++;
-			continue;
-		}
-
-		carrp->carr_pa = carr_paddr;
-		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
-
-		/*
-		 * Insert the carrier at the beginning of the freelist.
-		 */
-		carrp->next_vpa =
-		    cpu_to_le32(ADV_VADDR_TO_U32(asc_dvc->carr_freelist));
-		asc_dvc->carr_freelist = carrp;
-
-		carrp++;
-	}
-	while (buf_size > 0);
+	AdvBuildCarrierFreelist(asc_dvc);
 
 	/*
 	 * Set-up the Host->RISC Initiator Command Queue (ICQ).
-- 
1.5.2.4

