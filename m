From: brking@us.ibm.com
Subject: [PATCH 2/6] ipr: PCI-X capabilities setup fix
Date: Tue, 14 Dec 2004 17:09:49 -0600
Message-ID: <200412142309.iBEN9orG001665@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:53432 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261743AbULNXJ4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:09:56 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBEN9pFJ543518
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:09:51 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBEN9pkx200104
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:09:51 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBEN9ovG001696
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:09:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, andrew.vasquez@qlogic.com


From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Brian,

While performing some PCI-X command register tuning with some of
QLogic's cards, I stumbled upon some suspect code in ipr.c.  It appears
the two functions ipr_save_pcix_cmd_reg() and ipr_set_pcix_cmd_reg() are
actually reading/updating the PCI-X capabilities register and not in
fact the PCI-X command register -- some code from
ipr_save_pcix_cmd_reg():

	...	
        int pcix_cmd_reg = pci_find_capability(ioa_cfg->pdev, PCI_CAP_ID_PCIX);

        if (pcix_cmd_reg == 0) {
                dev_err(&ioa_cfg->pdev->dev, "Failed to save PCI-X command register\n");
                return -EIO;
        }

pcix_cmd_reg points to the PCI-X capabilities register.  Yet, the read:

        if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg,
                                 &ioa_cfg->saved_pcix_cmd_reg) != PCIBIOS_SUCCESSFUL) {
                dev_err(&ioa_cfg->pdev->dev, "Failed to save PCI-X command register\n");
                return -EIO;
        }

and subsequent update of the bits:

        ioa_cfg->saved_pcix_cmd_reg |= PCI_X_CMD_DPERR_E | PCI_X_CMD_ERO;

should actually apply to the PCI-X Command register 2 bytes further into
config space.  So, the following:

        if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg,

should actually read as:

        if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg + PCI_X_CMD,

The same is true for the 'save' case.

Luckily, most devices hardwire the PCI-X capabilities register so the
write is effectively a NOOP.

Hopefully, the attached patch helps.

Regards,
Andrew Vasquez

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_pcix_rd_wr drivers/scsi/ipr.c
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.c~ipr_pcix_rd_wr	2004-12-14 17:06:30.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.c	2004-12-14 17:06:30.000000000 -0600
@@ -542,7 +542,7 @@ static int ipr_save_pcix_cmd_reg(struct 
 		return -EIO;
 	}
 
-	if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg,
+	if (pci_read_config_word(ioa_cfg->pdev, pcix_cmd_reg + PCI_X_CMD,
 				 &ioa_cfg->saved_pcix_cmd_reg) != PCIBIOS_SUCCESSFUL) {
 		dev_err(&ioa_cfg->pdev->dev, "Failed to save PCI-X command register\n");
 		return -EIO;
@@ -564,7 +564,7 @@ static int ipr_set_pcix_cmd_reg(struct i
 	int pcix_cmd_reg = pci_find_capability(ioa_cfg->pdev, PCI_CAP_ID_PCIX);
 
 	if (pcix_cmd_reg) {
-		if (pci_write_config_word(ioa_cfg->pdev, pcix_cmd_reg,
+		if (pci_write_config_word(ioa_cfg->pdev, pcix_cmd_reg + PCI_X_CMD,
 					  ioa_cfg->saved_pcix_cmd_reg) != PCIBIOS_SUCCESSFUL) {
 			dev_err(&ioa_cfg->pdev->dev, "Failed to setup PCI-X command register\n");
 			return -EIO;
_
