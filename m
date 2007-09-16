From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 17/17] advansys: Remove DvcGetPhyAddr
Date: Sun, 16 Sep 2007 09:37:48 -0600
Message-ID: <11899570693213-git-send-email-matthew@wil.cx>
References: <1189867145.3339.3.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:52633 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXIPPhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 11:37:39 -0400
In-Reply-To: <1189867145.3339.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

This rather complex function boiled down to calling virt_to_bus().
Also get rid of some obsolete defines and variables that could never vary.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   73 ++---------------------------------------------
 1 files changed, 3 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2b50aa1..bd5bbc9 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -992,19 +992,6 @@ typedef struct asc_mc_saved {
 #define ADV_MAX_SG_LIST         255
 #define NO_OF_SG_PER_BLOCK              15
 
-/* Number of SG blocks needed. */
-#define ADV_NUM_SG_BLOCK \
-    ((ADV_MAX_SG_LIST + (NO_OF_SG_PER_BLOCK - 1))/NO_OF_SG_PER_BLOCK)
-
-/* Total contiguous memory needed for SG blocks. */
-#define ADV_SG_TOTAL_MEM_SIZE \
-    (sizeof(ADV_SG_BLOCK) *  ADV_NUM_SG_BLOCK)
-
-#define ADV_PAGE_SIZE PAGE_SIZE
-
-#define ADV_NUM_PAGE_CROSSING \
-    ((ADV_SG_TOTAL_MEM_SIZE + (ADV_PAGE_SIZE - 1))/ADV_PAGE_SIZE)
-
 #define ADV_EEP_DVC_CFG_BEGIN           (0x00)
 #define ADV_EEP_DVC_CFG_END             (0x15)
 #define ADV_EEP_DVC_CTL_BEGIN           (0x16)	/* location of OEM name */
@@ -1792,8 +1779,7 @@ typedef struct adv_carr_t {
 #define ASC_GET_CARRP(carrp) ((carrp) & ASC_NEXT_VPA_MASK)
 
 #define ADV_CARRIER_NUM_PAGE_CROSSING \
-    (((ADV_CARRIER_COUNT * sizeof(ADV_CARR_T)) + \
-        (ADV_PAGE_SIZE - 1))/ADV_PAGE_SIZE)
+    (((ADV_CARRIER_COUNT * sizeof(ADV_CARR_T)) + (PAGE_SIZE - 1))/PAGE_SIZE)
 
 #define ADV_CARRIER_BUFSIZE \
     ((ADV_CARRIER_COUNT + ADV_CARRIER_NUM_PAGE_CROSSING) * sizeof(ADV_CARR_T))
@@ -2174,16 +2160,6 @@ do { \
 #define QHSTA_M_FROZEN_TIDQ         0x46	/* TID Queue frozen. */
 #define QHSTA_M_SGBACKUP_ERROR      0x47	/* Scatter-Gather backup error */
 
-/*
- * DvcGetPhyAddr() flag arguments
- */
-#define ADV_IS_SCSIQ_FLAG       0x01	/* 'addr' is ASC_SCSI_REQ_Q pointer */
-#define ADV_ASCGETSGLIST_VADDR  0x02	/* 'addr' is AscGetSGList() virtual addr */
-#define ADV_IS_SENSE_FLAG       0x04	/* 'addr' is sense virtual pointer */
-#define ADV_IS_DATA_FLAG        0x08	/* 'addr' is data virtual pointer */
-#define ADV_IS_SGLIST_FLAG      0x10	/* 'addr' is sglist virtual pointer */
-#define ADV_IS_CARRIER_FLAG     0x20	/* 'addr' is ADV_CARR_T pointer */
-
 /* Return the address that is aligned at the next doubleword >= to 'addr'. */
 #define ADV_8BALIGN(addr)      (((ulong) (addr) + 0x7) & ~0x7)
 #define ADV_16BALIGN(addr)     (((ulong) (addr) + 0xF) & ~0xF)
@@ -6483,29 +6459,6 @@ static int AdvLoadMicrocode(AdvPortAddr iop_base, unsigned char *buf, int size,
 	return 0;
 }
 
-/*
- * DvcGetPhyAddr()
- *
- * Return the physical address of 'vaddr' and set '*lenp' to the
- * number of physically contiguous bytes that follow 'vaddr'.
- * 'flag' indicates the type of structure whose physical address
- * is being translated.
- *
- * Note: Because Linux currently doesn't page the kernel and all
- * kernel buffers are physically contiguous, leave '*lenp' unchanged.
- */
-ADV_PADDR
-DvcGetPhyAddr(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq,
-	      uchar *vaddr, ADV_SDCNT *lenp, int flag)
-{
-	ADV_PADDR paddr = virt_to_bus(vaddr);
-
-	ASC_DBG(4, "vaddr 0x%p, lenp 0x%p *lenp %lu, paddr 0x%lx\n",
-		 vaddr, lenp, (ulong)*((ulong *)lenp), (ulong)paddr);
-
-	return paddr;
-}
-
 static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 {
 	ADV_CARR_T *carrp;
@@ -6522,24 +6475,10 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_var *asc_dvc)
 
 	do {
 		/* Get physical address of the carrier 'carrp'. */
-		ADV_DCNT contig_len = sizeof(ADV_CARR_T);
-		carr_paddr = cpu_to_le32(DvcGetPhyAddr(asc_dvc, NULL,
-						       (uchar *)carrp,
-						       (ADV_SDCNT *)&contig_len,
-						       ADV_IS_CARRIER_FLAG));
+		carr_paddr = cpu_to_le32(virt_to_bus(carrp));
 
 		buf_size -= sizeof(ADV_CARR_T);
 
-		/*
-		 * If the current carrier is not physically contiguous, then
-		 * maybe there was a page crossing. Try the next carrier
-		 * aligned start address.
-		 */
-		if (contig_len < sizeof(ADV_CARR_T)) {
-			carrp++;
-			continue;
-		}
-
 		carrp->carr_pa = carr_paddr;
 		carrp->carr_va = cpu_to_le32(ADV_VADDR_TO_U32(carrp));
 
@@ -10915,7 +10854,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 {
 	AdvPortAddr iop_base;
-	ADV_DCNT req_size;
 	ADV_PADDR req_paddr;
 	ADV_CARR_T *new_carrp;
 
@@ -10953,13 +10891,8 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	 */
 	scsiq->a_flag &= ~ADV_SCSIQ_DONE;
 
-	req_size = sizeof(ADV_SCSI_REQ_Q);
-	req_paddr = DvcGetPhyAddr(asc_dvc, scsiq, (uchar *)scsiq,
-				  (ADV_SDCNT *)&req_size, ADV_IS_SCSIQ_FLAG);
-
+	req_paddr = virt_to_bus(scsiq);
 	BUG_ON(req_paddr & 31);
-	BUG_ON(req_size < sizeof(ADV_SCSI_REQ_Q));
-
 	/* Wait for assertion before making little-endian */
 	req_paddr = cpu_to_le32(req_paddr);
 
-- 
1.5.2.4

