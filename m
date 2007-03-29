From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 07/12] ipr: PCI unblock config access fix
Date: Thu, 29 Mar 2007 12:43:23 -0500
Message-ID: <200703291743.l2THhOHF013606@d01av02.pok.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60279 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934302AbXC2Rn1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2007 13:43:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THiCEK007782
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:44:12 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhPZV281918
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhPeA013648
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:25 -0400
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Fix to make sure user config accesses get re-enabled if the
PCI config write to start BIST fails.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/ipr.c~ipr_unblock_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_unblock_fix	2007-03-29 09:15:40.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-29 09:15:40.000000000 -0500
@@ -6390,6 +6390,7 @@ static int ipr_reset_start_bist(struct i
 	rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
 
 	if (rc != PCIBIOS_SUCCESSFUL) {
+		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
 		ipr_cmd->ioasa.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
 		rc = IPR_RC_JOB_CONTINUE;
 	} else {
_
