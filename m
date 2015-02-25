From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] lpfc: missing curly brace in lpfc_online()
Date: Wed, 25 Feb 2015 16:24:19 +0300
Message-ID: <20150225132419.GK19745@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbBYNYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 08:24:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This is harmless because we do the same thing either way but, from the
indenting, then it seems like lpfc_destroy_vport_work_array() was meant
to be inside the if statement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
The static checker complains about some of the other indents as well.

drivers/scsi/lpfc/lpfc_init.c:708 lpfc_hba_init_link_fc_topology() warn: bad indenting.
drivers/scsi/lpfc/lpfc_init.c:1978 lpfc_parse_vpd() warn: bad indenting.
drivers/scsi/lpfc/lpfc_init.c:8116 lpfc_sli4_pci_mem_setup() warn: bad indenting.

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0b2c53a..f8fd364 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2822,7 +2822,7 @@ lpfc_online(struct lpfc_hba *phba)
 	}
 
 	vports = lpfc_create_vport_work_array(phba);
-	if (vports != NULL)
+	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			struct Scsi_Host *shost;
 			shost = lpfc_shost_from_vport(vports[i]);
@@ -2840,6 +2840,7 @@ lpfc_online(struct lpfc_hba *phba)
 			spin_unlock_irq(shost->host_lock);
 		}
 		lpfc_destroy_vport_work_array(phba, vports);
+	}
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
