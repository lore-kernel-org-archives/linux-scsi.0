From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: refine the pci enble/disable handling
Date: Thu, 12 Jun 2014 17:29:31 +0200
Message-ID: <5399C75B.6020607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbaFLP3h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jun 2014 11:29:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: stephenmcameron@gmail.com, michael.miller@canonical.com, "Handzik, Joe" <joseph.t.handzik@hp.com>

When a second(kdump) kernel starts and the hard reset method is used
the driver calls pci_disable_device without previously enabling it,
so the kernel shows a warning -
[   16.876248] WARNING: at drivers/pci/pci.c:1431 pci_disable_device+0x84/0x90()
[   16.882686] Device hpsa
disabling already-disabled device
...
This patch fixes it, in addition to this I tried to balance also some other pairs
of enable/disable device in the driver.
Unfortunately I wasn't able to verify the functionality for the case of a sw reset,
because of a lack of proper hw.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5858600..67c41b9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5983,7 +5983,6 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	/* Turn the board off.  This is so that later pci_restore_state()
 	 * won't turn the board on before the rest of config space is ready.
 	 */
-	pci_disable_device(pdev);
 	pci_save_state(pdev);
 
 	/* find the first memory BAR, so we can find the cfg table */
@@ -6031,11 +6030,6 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 		goto unmap_cfgtable;
 
 	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		dev_warn(&pdev->dev, "failed to enable device.\n");
-		goto unmap_cfgtable;
-	}
 	pci_write_config_word(pdev, 4, command_register);
 
 	/* Some devices (notably the HP Smart Array 5i Controller)
@@ -6548,6 +6542,12 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 	if (!reset_devices)
 		return 0;
 
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_warn(&pdev->dev, "failed to enable device.\n");
+		return -ENODEV;
+	}
+
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 
@@ -6556,10 +6556,11 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 	 * "performant mode".  Or, it might be 640x, which can't reset
 	 * due to concerns about shared bbwc between 6402/6404 pair.
 	 */
-	if (rc == -ENOTSUPP)
-		return rc; /* just try to do the kdump anyhow. */
-	if (rc)
-		return -ENODEV;
+	if (rc) {
+		if (rc != -ENOTSUPP) /* just try to do the kdump anyhow. */
+			rc = -ENODEV;
+		goto out_disable; 
+	}
 
 	/* Now try to get the controller to respond to a no-op */
 	dev_warn(&pdev->dev, "Waiting for controller to respond to no-op\n");
@@ -6570,7 +6571,11 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 			dev_warn(&pdev->dev, "no-op failed%s\n",
 					(i < 11 ? "; re-trying" : ""));
 	}
-	return 0;
+
+out_disable:
+
+	pci_disable_device(pdev);
+	return rc;
 }
 
 static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
@@ -6722,6 +6727,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		iounmap(h->transtable);
 	if (h->cfgtable)
 		iounmap(h->cfgtable);
+	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	kfree(h);
 }
-- 
1.8.3.1

