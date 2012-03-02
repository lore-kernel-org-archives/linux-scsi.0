From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/21] lpfc 8.3.30: Flush reset register write
Date: Thu, 1 Mar 2012 22:37:18 -0500
Message-ID: <1330659442.18500.41.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38861 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757511Ab2CBDhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:37:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Used PCI configure space read to flush PCI function reset register write


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-03-01 17:33:50.000000000 -0500
@@ -7232,6 +7232,7 @@ lpfc_pci_function_reset(struct lpfc_hba 
 	uint32_t rdy_chk, num_resets = 0, reset_again = 0;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_register reg_data;
+	uint16_t devid;
 
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
 	switch (if_type) {
@@ -7279,7 +7280,8 @@ lpfc_pci_function_reset(struct lpfc_hba 
 			writel(reg_data.word0, phba->sli4_hba.u.if_type2.
 			       CTRLregaddr);
 			/* flush */
-			readl(phba->sli4_hba.u.if_type2.STATUSregaddr);
+			pci_read_config_word(phba->pcidev,
+					     PCI_DEVICE_ID, &devid);
 			/*
 			 * Poll the Port Status Register and wait for RDY for
 			 * up to 10 seconds.  If the port doesn't respond, treat



