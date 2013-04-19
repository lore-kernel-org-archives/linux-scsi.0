From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: SATA DVD probing failed with 64bit adapter
Date: Thu, 18 Apr 2013 21:32:48 -0500
Message-ID: <20130419023422.044330124@linux.vnet.ibm.com>
References: <20130419023247.599912727@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:58654 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S967724Ab3DSChP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Apr 2013 22:37:15 -0400
Content-Disposition: inline; filename=fix_ipr_sata_dvd
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Driver passed the wrong IOADL address to IOA adapter. The patch
fixes the issue.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    4 ++--
 drivers/scsi/ipr.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-04-18 14:10:44.000000000 -0500
+++ b/drivers/scsi/ipr.c	2013-04-18 14:15:08.767887656 -0500
@@ -6421,7 +6421,7 @@ static void ipr_build_ata_ioadl64(struct
 {
 	u32 ioadl_flags = 0;
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
-	struct ipr_ioadl64_desc *ioadl64 = ipr_cmd->i.ioadl64;
+	struct ipr_ioadl64_desc *ioadl64 = ipr_cmd->i.ata_ioadl.ioadl64;
 	struct ipr_ioadl64_desc *last_ioadl64 = NULL;
 	int len = qc->nbytes;
 	struct scatterlist *sg;
@@ -6441,7 +6441,7 @@ static void ipr_build_ata_ioadl64(struct
 	ioarcb->ioadl_len =
 		cpu_to_be32(sizeof(struct ipr_ioadl64_desc) * ipr_cmd->dma_use_sg);
 	ioarcb->u.sis64_addr_data.data_ioadl_addr =
-		cpu_to_be64(dma_addr + offsetof(struct ipr_cmnd, i.ata_ioadl));
+		cpu_to_be64(dma_addr + offsetof(struct ipr_cmnd, i.ata_ioadl.ioadl64));
 
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		ioadl64->flags = cpu_to_be32(ioadl_flags);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-04-18 14:08:22.000000000 -0500
+++ b/drivers/scsi/ipr.h	2013-04-18 14:12:50.677887864 -0500
@@ -552,7 +552,7 @@ struct ipr_ioarcb_ata_regs {	/* 22 bytes
 	u8 hob_lbam;
 	u8 hob_lbah;
 	u8 ctl;
-}__attribute__ ((packed, aligned(4)));
+}__attribute__ ((packed, aligned(2)));
 
 struct ipr_ioadl_desc {
 	__be32 flags_and_data_len;

-- 
