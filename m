From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 11/12] ipr: Faster sg list fetch
Date: Thu, 29 Mar 2007 12:43:50 -0500
Message-ID: <200703291743.l2THhpqp027513@d03av03.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:49361 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030474AbXC2Rnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:43:53 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhqx6013359
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:52 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhqae104448
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:52 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhpaE027546
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:52 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Improve overall command performance by embedding the scatterlist
in the command block used by the adapter. This decreases
the overall number of DMAs required for a single command.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   28 +++++++++++++++++++++++-----
 linux-2.6-bjking1/drivers/scsi/ipr.h |   31 ++++++++++++++++---------------
 2 files changed, 39 insertions(+), 20 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_embedded_ioadl2 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_embedded_ioadl2	2007-03-26 09:52:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-03-26 09:52:41.000000000 -0500
@@ -422,9 +422,25 @@ struct ipr_ioarcb_ata_regs {
 	u8 ctl;
 }__attribute__ ((packed, aligned(4)));
 
+struct ipr_ioadl_desc {
+	__be32 flags_and_data_len;
+#define IPR_IOADL_FLAGS_MASK		0xff000000
+#define IPR_IOADL_GET_FLAGS(x) (be32_to_cpu(x) & IPR_IOADL_FLAGS_MASK)
+#define IPR_IOADL_DATA_LEN_MASK		0x00ffffff
+#define IPR_IOADL_GET_DATA_LEN(x) (be32_to_cpu(x) & IPR_IOADL_DATA_LEN_MASK)
+#define IPR_IOADL_FLAGS_READ		0x48000000
+#define IPR_IOADL_FLAGS_READ_LAST	0x49000000
+#define IPR_IOADL_FLAGS_WRITE		0x68000000
+#define IPR_IOADL_FLAGS_WRITE_LAST	0x69000000
+#define IPR_IOADL_FLAGS_LAST		0x01000000
+
+	__be32 address;
+}__attribute__((packed, aligned (8)));
+
 struct ipr_ioarcb_add_data {
 	union {
 		struct ipr_ioarcb_ata_regs regs;
+		struct ipr_ioadl_desc ioadl[5];
 		__be32 add_cmd_parms[10];
 	}u;
 }__attribute__ ((packed, aligned(4)));
@@ -456,21 +472,6 @@ struct ipr_ioarcb {
 	struct ipr_ioarcb_add_data add_data;
 }__attribute__((packed, aligned (4)));
 
-struct ipr_ioadl_desc {
-	__be32 flags_and_data_len;
-#define IPR_IOADL_FLAGS_MASK		0xff000000
-#define IPR_IOADL_GET_FLAGS(x) (be32_to_cpu(x) & IPR_IOADL_FLAGS_MASK)
-#define IPR_IOADL_DATA_LEN_MASK		0x00ffffff
-#define IPR_IOADL_GET_DATA_LEN(x) (be32_to_cpu(x) & IPR_IOADL_DATA_LEN_MASK)
-#define IPR_IOADL_FLAGS_READ		0x48000000
-#define IPR_IOADL_FLAGS_READ_LAST	0x49000000
-#define IPR_IOADL_FLAGS_WRITE		0x68000000
-#define IPR_IOADL_FLAGS_WRITE_LAST	0x69000000
-#define IPR_IOADL_FLAGS_LAST		0x01000000
-
-	__be32 address;
-}__attribute__((packed, aligned (8)));
-
 struct ipr_ioasa_vset {
 	__be32 failing_lba_hi;
 	__be32 failing_lba_lo;
diff -puN drivers/scsi/ipr.c~ipr_embedded_ioadl2 drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_embedded_ioadl2	2007-03-26 09:52:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-26 09:52:41.000000000 -0500
@@ -480,12 +480,16 @@ static void ipr_reinit_ipr_cmnd(struct i
 {
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
+	dma_addr_t dma_addr = be32_to_cpu(ioarcb->ioarcb_host_pci_addr);
 
 	memset(&ioarcb->cmd_pkt, 0, sizeof(struct ipr_cmd_pkt));
 	ioarcb->write_data_transfer_length = 0;
 	ioarcb->read_data_transfer_length = 0;
 	ioarcb->write_ioadl_len = 0;
 	ioarcb->read_ioadl_len = 0;
+	ioarcb->write_ioadl_addr =
+		cpu_to_be32(dma_addr + offsetof(struct ipr_cmnd, ioadl));
+	ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 	ioasa->ioasc = 0;
 	ioasa->residual_data_len = 0;
 	ioasa->u.gata.status = 0;
@@ -4230,6 +4234,14 @@ static int ipr_build_ioadl(struct ipr_io
 
 		sglist = scsi_cmd->request_buffer;
 
+		if (ipr_cmd->dma_use_sg <= ARRAY_SIZE(ioarcb->add_data.u.ioadl)) {
+			ioadl = ioarcb->add_data.u.ioadl;
+			ioarcb->write_ioadl_addr =
+				cpu_to_be32(be32_to_cpu(ioarcb->ioarcb_host_pci_addr) +
+					    offsetof(struct ipr_ioarcb, add_data));
+			ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
+		}
+
 		for (i = 0; i < ipr_cmd->dma_use_sg; i++) {
 			ioadl[i].flags_and_data_len =
 				cpu_to_be32(ioadl_flags | sg_dma_len(&sglist[i]));
@@ -4260,6 +4272,11 @@ static int ipr_build_ioadl(struct ipr_io
 						     scsi_cmd->sc_data_direction);
 
 		if (likely(!pci_dma_mapping_error(ipr_cmd->dma_handle))) {
+			ioadl = ioarcb->add_data.u.ioadl;
+			ioarcb->write_ioadl_addr =
+				cpu_to_be32(be32_to_cpu(ioarcb->ioarcb_host_pci_addr) +
+					    offsetof(struct ipr_ioarcb, add_data));
+			ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 			ipr_cmd->dma_use_sg = 1;
 			ioadl[0].flags_and_data_len =
 				cpu_to_be32(ioadl_flags | length | IPR_IOADL_FLAGS_LAST);
@@ -4346,11 +4363,9 @@ static void ipr_erp_done(struct ipr_cmnd
  **/
 static void ipr_reinit_ipr_cmnd_for_erp(struct ipr_cmnd *ipr_cmd)
 {
-	struct ipr_ioarcb *ioarcb;
-	struct ipr_ioasa *ioasa;
-
-	ioarcb = &ipr_cmd->ioarcb;
-	ioasa = &ipr_cmd->ioasa;
+	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
+	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
+	dma_addr_t dma_addr = be32_to_cpu(ioarcb->ioarcb_host_pci_addr);
 
 	memset(&ioarcb->cmd_pkt, 0, sizeof(struct ipr_cmd_pkt));
 	ioarcb->write_data_transfer_length = 0;
@@ -4359,6 +4374,9 @@ static void ipr_reinit_ipr_cmnd_for_erp(
 	ioarcb->read_ioadl_len = 0;
 	ioasa->ioasc = 0;
 	ioasa->residual_data_len = 0;
+	ioarcb->write_ioadl_addr =
+		cpu_to_be32(dma_addr + offsetof(struct ipr_cmnd, ioadl));
+	ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
 }
 
 /**
_
