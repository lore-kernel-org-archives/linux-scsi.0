From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/6] lpfc 8.3.22: T10-DIF corrections
Date: Fri, 11 Mar 2011 16:05:52 -0500
Message-ID: <1299877566.31589.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23191 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632Ab1CKVGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2011 16:06:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

T10-DIF corrections
- Add selective reset jump table entry
- Split T10-DIF BDEs that cross 4K boundary


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 ++
 lpfc_attr.c |    4 ++--
 lpfc_crtn.h |    4 ++--
 lpfc_hw.h   |   11 +++++++++++
 lpfc_init.c |    1 +
 lpfc_scsi.c |   41 ++++++++++++++++++++++++++++++-----------
 6 files changed, 48 insertions(+), 15 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-03-11 12:13:40.000000000 -0500
@@ -685,7 +685,7 @@ lpfc_do_offline(struct lpfc_hba *phba, u
  * -EIO reset not configured or error posting the event
  * zero for success
  **/
-static int
+int
 lpfc_selective_reset(struct lpfc_hba *phba)
 {
 	struct completion online_compl;
@@ -746,7 +746,7 @@ lpfc_issue_reset(struct device *dev, str
 	int status = -EINVAL;
 
 	if (strncmp(buf, "selective", sizeof("selective") - 1) == 0)
-		status = lpfc_selective_reset(phba);
+		status = phba->lpfc_selective_reset(phba);
 
 	if (status == 0)
 		return strlen(buf);
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-03-11 12:13:40.000000000 -0500
@@ -254,8 +254,8 @@ uint16_t lpfc_sli_next_iotag(struct lpfc
 void lpfc_sli_cancel_iocbs(struct lpfc_hba *, struct list_head *, uint32_t,
 			   uint32_t);
 void lpfc_sli_wake_mbox_wait(struct lpfc_hba *, LPFC_MBOXQ_t *);
-
-void lpfc_reset_barrier(struct lpfc_hba * phba);
+int lpfc_selective_reset(struct lpfc_hba *);
+void lpfc_reset_barrier(struct lpfc_hba *);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
 int lpfc_sli_brdkill(struct lpfc_hba *);
 int lpfc_sli_brdreset(struct lpfc_hba *);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-03-11 12:13:40.000000000 -0500
@@ -539,6 +539,8 @@ struct lpfc_hba {
 		(struct lpfc_hba *, uint32_t);
 	int (*lpfc_hba_down_link)
 		(struct lpfc_hba *, uint32_t);
+	int (*lpfc_selective_reset)
+		(struct lpfc_hba *);
 
 	/* SLI4 specific HBA data structure */
 	struct lpfc_sli4_hba sli4_hba;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2011-03-11 12:13:40.000000000 -0500
@@ -1713,6 +1713,17 @@ struct lpfc_pde6 {
 #define pde6_apptagval_WORD	word2
 };
 
+struct lpfc_pde7 {
+	uint32_t word0;
+#define pde7_type_SHIFT		24
+#define pde7_type_MASK		0x000000ff
+#define pde7_type_WORD		word0
+#define pde7_rsvd0_SHIFT	0
+#define pde7_rsvd0_MASK		0x00ffffff
+#define pde7_rsvd0_WORD		word0
+	uint32_t addrHigh;
+	uint32_t addrLow;
+};
 
 /* Structure for MB Command LOAD_SM and DOWN_LOAD */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-03-11 12:13:40.000000000 -0500
@@ -4474,6 +4474,7 @@ lpfc_init_api_table_setup(struct lpfc_hb
 {
 	phba->lpfc_hba_init_link = lpfc_hba_init_link;
 	phba->lpfc_hba_down_link = lpfc_hba_down_link;
+	phba->lpfc_selective_reset = lpfc_selective_reset;
 	switch (dev_grp) {
 	case LPFC_PCI_DEV_LP:
 		phba->lpfc_hba_down_post = lpfc_hba_down_post_s3;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-03-09 14:41:22.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-03-11 12:13:40.000000000 -0500
@@ -1514,10 +1514,11 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 	struct scatterlist *sgpe = NULL; /* s/g prot entry */
 	struct lpfc_pde5 *pde5 = NULL;
 	struct lpfc_pde6 *pde6 = NULL;
-	struct ulp_bde64 *prot_bde = NULL;
+	struct lpfc_pde7 *pde7 = NULL;
 	dma_addr_t dataphysaddr, protphysaddr;
 	unsigned short curr_data = 0, curr_prot = 0;
-	unsigned int split_offset, protgroup_len;
+	unsigned int split_offset;
+	unsigned int protgroup_len, protgroup_offset = 0, protgroup_remainder;
 	unsigned int protgrp_blks, protgrp_bytes;
 	unsigned int remainder, subtotal;
 	int status;
@@ -1585,23 +1586,33 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bpl++;
 
 		/* setup the first BDE that points to protection buffer */
-		prot_bde = (struct ulp_bde64 *) bpl;
-		protphysaddr = sg_dma_address(sgpe);
-		prot_bde->addrHigh = le32_to_cpu(putPaddrLow(protphysaddr));
-		prot_bde->addrLow = le32_to_cpu(putPaddrHigh(protphysaddr));
-		protgroup_len = sg_dma_len(sgpe);
+		protphysaddr = sg_dma_address(sgpe) + protgroup_offset;
+		protgroup_len = sg_dma_len(sgpe) - protgroup_offset;
 
 		/* must be integer multiple of the DIF block length */
 		BUG_ON(protgroup_len % 8);
 
+		pde7 = (struct lpfc_pde7 *) bpl;
+		memset(pde7, 0, sizeof(struct lpfc_pde7));
+		bf_set(pde7_type, pde7, LPFC_PDE7_DESCRIPTOR);
+
+		pde7->addrHigh = le32_to_cpu(putPaddrLow(protphysaddr));
+		pde7->addrLow = le32_to_cpu(putPaddrHigh(protphysaddr));
+
 		protgrp_blks = protgroup_len / 8;
 		protgrp_bytes = protgrp_blks * blksize;
 
-		prot_bde->tus.f.bdeSize = protgroup_len;
-		prot_bde->tus.f.bdeFlags = LPFC_PDE7_DESCRIPTOR;
-		prot_bde->tus.w = le32_to_cpu(bpl->tus.w);
+		/* check if this pde is crossing the 4K boundary; if so split */
+		if ((pde7->addrLow & 0xfff) + protgroup_len > 0x1000) {
+			protgroup_remainder = 0x1000 - (pde7->addrLow & 0xfff);
+			protgroup_offset += protgroup_remainder;
+			protgrp_blks = protgroup_remainder / 8;
+			protgrp_bytes = protgroup_remainder * blksize;
+		} else {
+			protgroup_offset = 0;
+			curr_prot++;
+		}
 
-		curr_prot++;
 		num_bde++;
 
 		/* setup BDE's for data blocks associated with DIF data */
@@ -1653,6 +1664,13 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 
 		}
 
+		if (protgroup_offset) {
+			/* update the reference tag */
+			reftag += protgrp_blks;
+			bpl++;
+			continue;
+		}
+
 		/* are we done ? */
 		if (curr_prot == protcnt) {
 			alldone = 1;
@@ -1675,6 +1693,7 @@ out:
 
 	return num_bde;
 }
+
 /*
  * Given a SCSI command that supports DIF, determine composition of protection
  * groups involved in setting up buffer lists


