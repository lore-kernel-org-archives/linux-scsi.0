From: akpm@linux-foundation.org
Subject: [patch 1/4] scsi: megaraid_sas: add the dumy readl to force PCI flush
Date: Sun, 10 Aug 2008 12:42:37 -0700
Message-ID: <200808101942.m7AJgblW029514@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYHJTnK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 15:43:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Bo.Yang@lsi.com, bo.yang@lsi.com

From: "Yang, Bo" <Bo.Yang@lsi.com>

MegaRAID SAS Driver get unexpected Interrupt.  Add the dumy readl to force
PCI flush will fix this issue.

Signed-off-by: Bo Yang<bo.yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-add-the-dumy-readl-to-force-pci-flush
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -198,6 +198,9 @@ megasas_clear_intr_xscale(struct megasas
 	 */
 	writel(status, &regs->outbound_intr_status);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_status);
+
 	return 0;
 }
 
@@ -293,6 +296,9 @@ megasas_clear_intr_ppc(struct megasas_re
 	 */
 	writel(status, &regs->outbound_doorbell_clear);
 
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_doorbell_clear);
+
 	return 0;
 }
 /**
_
