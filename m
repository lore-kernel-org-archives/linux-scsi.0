From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/13] scsi: arcmsr: redefine ACB_ADAPTER_TYPE_A, _B, _C, _D
 and subsequent changes.
Date: Thu, 09 Nov 2017 07:26:58 +0800
Message-ID: <1510183618.4523.56.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:52071 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbdKIH1G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 02:27:06 -0500
Received: by mail-io0-f193.google.com with SMTP id b186so8773420iof.8
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 23:27:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

redefine ACB_ADAPTER_TYPE_A, _B, _C, _D and subsequent changes.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-07-31 11:50:44.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-08-03 18:54:46.000000000 +0800
@@ -621,10 +621,10 @@ struct MessageUnit_D {
 struct AdapterControlBlock
 {
 	uint32_t  adapter_type;                /* adapter A,B..... */
-	#define ACB_ADAPTER_TYPE_A            0x00000001	/* hba I IOP */
-	#define ACB_ADAPTER_TYPE_B            0x00000002	/* hbb M IOP */
-	#define ACB_ADAPTER_TYPE_C            0x00000004	/* hbc P IOP */
-	#define ACB_ADAPTER_TYPE_D            0x00000008	/* hbd A IOP */
+	#define ACB_ADAPTER_TYPE_A	0x00000000	/* hba I IOP */
+	#define ACB_ADAPTER_TYPE_B	0x00000001	/* hbb M IOP */
+	#define ACB_ADAPTER_TYPE_C	0x00000002	/* hbc L IOP */
+	#define ACB_ADAPTER_TYPE_D	0x00000003	/* hbd M IOP */
 	u32				roundup_ccbsize;
 	struct pci_dev *		pdev;
 	struct Scsi_Host *		host;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-07-31 11:50:16.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:46:42.000000000 +0800
@@ -1789,7 +1789,7 @@ arcmsr_Read_iop_rqbuffer_data(struct Ada
 	uint8_t __iomem *iop_data;
 	uint32_t iop_len;
 
-	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D))
+	if (acb->adapter_type > ACB_ADAPTER_TYPE_B)
 		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
 	iop_data = (uint8_t __iomem *)prbuffer->data;
 	iop_len = readl(&prbuffer->data_len);
@@ -1875,7 +1875,7 @@ arcmsr_write_ioctldata2iop(struct Adapte
 	uint8_t __iomem *iop_data;
 	int32_t allxfer_len = 0;
 
-	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {
+	if (acb->adapter_type > ACB_ADAPTER_TYPE_B) {
 		arcmsr_write_ioctldata2iop_in_DWORD(acb);
 		return;
 	}
