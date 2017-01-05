From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [v1] scsi: qla2xxx: qla_mr:- Release and Unmap memory regions when an error occurred.
Date: Thu,  5 Jan 2017 13:13:16 +0530
Message-ID: <1483602196-25605-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36369 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967180AbdAEHn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 02:43:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Free memory regions, if qlafx00_iospace_config is not successful.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/qla2xxx/qla_mr.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 02f1de1..2861df8 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -770,7 +770,7 @@
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x014e,
 		    "Failed to reserve PIO/MMIO regions (%s), aborting.\n",
 		    pci_name(ha->pdev));
-		goto iospace_error_exit;
+		return -ENOMEM;
 	}
 
 	/* Use MMIO operations for all accesses. */
@@ -799,13 +799,13 @@
 		ql_log_pci(ql_log_warn, ha->pdev, 0x0129,
 		    "region #2 not an MMIO resource (%s), aborting\n",
 		    pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto iounmap_error_exit;
 	}
 	if (pci_resource_len(ha->pdev, 2) < BAR2_LEN_FX00) {
 		ql_log_pci(ql_log_warn, ha->pdev, 0x012a,
 		    "Invalid PCI mem BAR2 region size (%s), aborting\n",
 			pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto iounmap_error_exit;
 	}
 
 	ha->iobase =
@@ -813,7 +813,7 @@
 	if (!ha->iobase) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x012b,
 		    "cannot remap MMIO (%s), aborting\n", pci_name(ha->pdev));
-		goto iospace_error_exit;
+		goto iounmap_error_exit;
 	}
 
 	/* Determine queue resources */
@@ -825,7 +825,10 @@
 
 	return 0;
 
+iounmap_error_exit:
+	iounmap(ha->cregbase);
 iospace_error_exit:
+	pci_release_selected_regions(ha->pdev, ha->bars);
 	return -ENOMEM;
 }
 
-- 
1.9.1

