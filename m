From: akpm@linux-foundation.org
Subject: [patch 01/17] git-scsi-misc: arcmsr build fix
Date: Tue, 02 Oct 2007 14:37:59 -0700
Message-ID: <200710022137.l92LbxEw023552@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950AbXJBViE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/arcmsr/arcmsr_hba.c:129: error: 'arcmsr_pci_error_detected' undeclared here (not in a function)
drivers/scsi/arcmsr/arcmsr_hba.c:130: error: 'arcmsr_pci_slot_reset' undeclared here (not in a function)

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/arcmsr/arcmsr_hba.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~git-scsi-misc-arcmsr-build-fix drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~git-scsi-misc-arcmsr-build-fix
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -125,6 +125,10 @@ static struct scsi_host_template arcmsr_
 	.shost_attrs		= arcmsr_host_attrs,
 };
 #ifdef CONFIG_SCSI_ARCMSR_AER
+static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,
+						pci_channel_state_t state);
+
 static struct pci_error_handlers arcmsr_pci_error_handlers = {
 	.error_detected		= arcmsr_pci_error_detected,
 	.slot_reset		= arcmsr_pci_slot_reset,
_
