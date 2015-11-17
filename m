From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 46/52] atp870u: Use pci_request_regions
Date: Tue, 17 Nov 2015 19:24:22 +0100
Message-ID: <1447784668-23713-47-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56556 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbbKQShl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:41 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Use pci_request_regions and do it before accessing the I/O ports.
Also add missing pci_disable_device() call to atp870u_remove().

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 4bb0f4f..87dd886 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1276,10 +1276,15 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
                 goto disable_device;
         }
 
+	err = pci_request_regions(pdev, "atp870u");
+	if (err)
+		goto disable_device;
+	pci_set_master(pdev);
+
         err = -ENOMEM;
 	shpnt = scsi_host_alloc(&atp870u_template, sizeof(struct atp_unit));
 	if (!shpnt)
-		goto disable_device;
+		goto release_region;
 
 	atpdev = shost_priv(shpnt);
 
@@ -1582,10 +1587,6 @@ flash_ok_885:
 
 	} 
 		spin_unlock_irqrestore(shpnt->host_lock, flags);
-		if (!request_region(shpnt->io_port, shpnt->n_io_port, "atp870u")) {
-			err = -EBUSY;
-			goto request_io_fail;
-		}
 		err = scsi_add_host(shpnt, &pdev->dev);
 		if (err)
 			goto scsi_add_fail;
@@ -1596,16 +1597,13 @@ flash_ok_885:
 		return 0;
 
 scsi_add_fail:
-	printk("atp870u_prob:scsi_add_fail\n");
-	release_region(shpnt->io_port, shpnt->n_io_port);
-request_io_fail:
-	printk("atp870u_prob:request_io_fail\n");
 	free_irq(shpnt->irq, shpnt);
 free_tables:
-	printk("atp870u_prob:free_table\n");
 	atp870u_free_tables(shpnt);
 unregister:
 	scsi_host_put(shpnt);
+release_region:
+	pci_release_regions(pdev);
 disable_device:
 	pci_disable_device(pdev);
 fail:
@@ -1696,7 +1694,8 @@ static void atp870u_remove (struct pci_dev *pdev)
 	
 	scsi_remove_host(pshost);
 	free_irq(pshost->irq, pshost);
-	release_region(pshost->io_port, pshost->n_io_port);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
 	atp870u_free_tables(pshost);
 	scsi_host_put(pshost);
 }
-- 
Ondrej Zary

