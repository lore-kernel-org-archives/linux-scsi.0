From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH V2] hpsa: refine the pci enable/disable handling
Date: Thu, 14 Aug 2014 16:12:39 +0200
Message-ID: <53ECC3D7.90303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbaHNONq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Aug 2014 10:13:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "Handzik, Joe" <joseph.t.handzik@hp.com>, michael.miller@canonical.com

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

Changes in v2:
- fixed a checkpatch issue
- removed a no more valid comment
- added pci_enable/disable pair when kdump kernel starts
- fixed a typo in subject line

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b35d0d..cf793c3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5971,10 +5971,6 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 
 	/* Save the PCI command register */
 	pci_read_config_word(pdev, 4, &command_register);
-	/* Turn the board off.  This is so that later pci_restore_state()
-	 * won't turn the board on before the rest of config space is ready.
-	 */
-	pci_disable_device(pdev);
 	pci_save_state(pdev);
 
 	/* find the first memory BAR, so we can find the cfg table */
@@ -6022,11 +6018,6 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 		goto unmap_cfgtable;
 
 	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		dev_warn(&pdev->dev, "failed to enable device.\n");
-		goto unmap_cfgtable;
-	}
 	pci_write_config_word(pdev, 4, command_register);
 
 	/* Some devices (notably the HP Smart Array 5i Controller)
@@ -6541,6 +6532,23 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 	if (!reset_devices)
 		return 0;
 
+	/* kdump kernel is loading, we don't know in which state is
+	 * the pci interface. The dev->enable_cnt is equal zero
+	 * so we call enable+disable, wait a while and switch it on.
+	 */
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_warn(&pdev->dev, "Failed to enable PCI device\n");
+		return -ENODEV;
+	}
+	pci_disable_device(pdev);
+	msleep(260);			/* a randomly chosen number */
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_warn(&pdev->dev, "failed to enable device.\n");
+		return -ENODEV;
+	}
+
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 
@@ -6549,10 +6557,11 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
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
@@ -6563,7 +6572,11 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
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
@@ -6743,6 +6756,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		iounmap(h->transtable);
 	if (h->cfgtable)
 		iounmap(h->cfgtable);
+	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	kfree(h);
 }
-- 
1.8.3.1

