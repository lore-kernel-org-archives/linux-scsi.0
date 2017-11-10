From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 04/17] lpfc: Fix crash after bad bar setup on driver attachment
Date: Thu,  9 Nov 2017 17:08:21 -0800
Message-ID: <20171110010834.4542-5-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:47614 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755266AbdKJBIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:47 -0500
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

In test cases where an instance of the driver is detached and
reattached, the driver will crash on reattachment. There is a
compound if statement that will skip over the bar setup if
the pci_resource_start call is not successful. The driver
erroneously returns success to its bar setup in this scenario
even though the bars aren't properly configured.

Rework the offending code segment for proper initialization steps.
If the pci_resource_start call fails, -ENOMEM is now returned.

Sample stack:

rport-5:0-10: blocked FC remote port time out: removing rport
BUG: unable to handle kernel NULL pointer dereference at           (null)
... lpfc_sli4_wait_bmbx_ready+0x32/0x70 [lpfc]
...
...  RIP: 0010:...  ... lpfc_sli4_wait_bmbx_ready+0x32/0x70 [lpfc]
 Call Trace:
  ... lpfc_sli4_post_sync_mbox+0x106/0x4d0 [lpfc]
  ... ? __alloc_pages_nodemask+0x176/0x420
  ... ? __kmalloc+0x2e/0x230
  ... lpfc_sli_issue_mbox_s4+0x533/0x720 [lpfc]
  ... ? mempool_alloc+0x69/0x170
  ... ? dma_generic_alloc_coherent+0x8f/0x140
  ... lpfc_sli_issue_mbox+0xf/0x20 [lpfc]
  ... lpfc_sli4_driver_resource_setup+0xa6f/0x1130 [lpfc]
  ... ? lpfc_pci_probe_one+0x23e/0x16f0 [lpfc]
  ... lpfc_pci_probe_one+0x445/0x16f0 [lpfc]
  ... local_pci_probe+0x45/0xa0
  ... work_for_cpu_fn+0x14/0x20
  ... process_one_work+0x17a/0x440

Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 84 ++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 745aff753396..fc9f91327724 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9437,44 +9437,62 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	}
 
-	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
-	    (pci_resource_start(pdev, PCI_64BIT_BAR2))) {
-		/*
-		 * Map SLI4 if type 0 HBA Control Register base to a kernel
-		 * virtual address and setup the registers.
-		 */
-		phba->pci_bar1_map = pci_resource_start(pdev, PCI_64BIT_BAR2);
-		bar1map_len = pci_resource_len(pdev, PCI_64BIT_BAR2);
-		phba->sli4_hba.ctrl_regs_memmap_p =
-				ioremap(phba->pci_bar1_map, bar1map_len);
-		if (!phba->sli4_hba.ctrl_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLI4 HBA control registers.\n");
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_0) {
+		if (pci_resource_start(pdev, PCI_64BIT_BAR2)) {
+			/*
+			 * Map SLI4 if type 0 HBA Control Register base to a
+			 * kernel virtual address and setup the registers.
+			 */
+			phba->pci_bar1_map = pci_resource_start(pdev,
+								PCI_64BIT_BAR2);
+			bar1map_len = pci_resource_len(pdev, PCI_64BIT_BAR2);
+			phba->sli4_hba.ctrl_regs_memmap_p =
+					ioremap(phba->pci_bar1_map,
+						bar1map_len);
+			if (!phba->sli4_hba.ctrl_regs_memmap_p) {
+				dev_err(&pdev->dev,
+					   "ioremap failed for SLI4 HBA "
+					    "control registers.\n");
+				error = -ENOMEM;
+				goto out_iounmap_conf;
+			}
+			phba->pci_bar2_memmap_p =
+					 phba->sli4_hba.ctrl_regs_memmap_p;
+			lpfc_sli4_bar1_register_memmap(phba);
+		} else {
+			error = -ENOMEM;
 			goto out_iounmap_conf;
 		}
-		phba->pci_bar2_memmap_p = phba->sli4_hba.ctrl_regs_memmap_p;
-		lpfc_sli4_bar1_register_memmap(phba);
 	}
 
-	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
-	    (pci_resource_start(pdev, PCI_64BIT_BAR4))) {
-		/*
-		 * Map SLI4 if type 0 HBA Doorbell Register base to a kernel
-		 * virtual address and setup the registers.
-		 */
-		phba->pci_bar2_map = pci_resource_start(pdev, PCI_64BIT_BAR4);
-		bar2map_len = pci_resource_len(pdev, PCI_64BIT_BAR4);
-		phba->sli4_hba.drbl_regs_memmap_p =
-				ioremap(phba->pci_bar2_map, bar2map_len);
-		if (!phba->sli4_hba.drbl_regs_memmap_p) {
-			dev_printk(KERN_ERR, &pdev->dev,
-			   "ioremap failed for SLI4 HBA doorbell registers.\n");
-			goto out_iounmap_ctrl;
-		}
-		phba->pci_bar4_memmap_p = phba->sli4_hba.drbl_regs_memmap_p;
-		error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
-		if (error)
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_0) {
+		if (pci_resource_start(pdev, PCI_64BIT_BAR4)) {
+			/*
+			 * Map SLI4 if type 0 HBA Doorbell Register base to
+			 * a kernel virtual address and setup the registers.
+			 */
+			phba->pci_bar2_map = pci_resource_start(pdev,
+								PCI_64BIT_BAR4);
+			bar2map_len = pci_resource_len(pdev, PCI_64BIT_BAR4);
+			phba->sli4_hba.drbl_regs_memmap_p =
+					ioremap(phba->pci_bar2_map,
+						bar2map_len);
+			if (!phba->sli4_hba.drbl_regs_memmap_p) {
+				dev_err(&pdev->dev,
+					   "ioremap failed for SLI4 HBA"
+					   " doorbell registers.\n");
+				error = -ENOMEM;
+				goto out_iounmap_ctrl;
+			}
+			phba->pci_bar4_memmap_p =
+					phba->sli4_hba.drbl_regs_memmap_p;
+			error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
+			if (error)
+				goto out_iounmap_all;
+		} else {
+			error = -ENOMEM;
 			goto out_iounmap_all;
+		}
 	}
 
 	return 0;
-- 
2.13.1
