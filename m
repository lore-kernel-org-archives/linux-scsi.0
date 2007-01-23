From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ipr: Tolerate not finding PCI-X registers
Date: Tue, 23 Jan 2007 11:25:30 -0600
Message-ID: <200701231725.l0NHPUau011798@d03av04.boulder.ibm.com>
References: <1169573123318-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:51718 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbXAWRZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 12:25:33 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0NHPWbD007704
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:25:32 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0NHPW6b466646
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:32 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0NHPV8m011830
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:31 -0700
In-Reply-To: <1169573123318-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brazilnut@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Don't fail initialization of an adapter if the PCI-X registers
cannot be found since it may be a PCI-E adapter.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_pcie_sas drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_pcie_sas	2007-01-17 17:21:10.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-01-17 17:21:10.000000000 -0600
@@ -595,10 +595,8 @@ static int ipr_save_pcix_cmd_reg(struct 
 {
 	int pcix_cmd_reg = pci_find_capability(ioa_cfg->pdev, PCI_CAP_ID_PCIX);
 
-	if (pcix_cmd_reg == 0) {
-		dev_err(&ioa_cfg->pdev->dev, "Failed to save PCI-X command register\n");
-		return -EIO;
-	}
+	if (pcix_cmd_reg == 0)
+		return 0;
 
 	if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg + PCI_X_CMD,
 				 &ioa_cfg->saved_pcix_cmd_reg) != PCIBIOS_SUCCESSFUL) {
@@ -627,10 +625,6 @@ static int ipr_set_pcix_cmd_reg(struct i
 			dev_err(&ioa_cfg->pdev->dev, "Failed to setup PCI-X command register\n");
 			return -EIO;
 		}
-	} else {
-		dev_err(&ioa_cfg->pdev->dev,
-			"Failed to setup PCI-X command register\n");
-		return -EIO;
 	}
 
 	return 0;
_
