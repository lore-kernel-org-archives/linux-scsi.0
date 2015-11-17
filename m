From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 39/52] atp870u: Remove useless and broken card counting
Date: Tue, 17 Nov 2015 19:24:15 +0100
Message-ID: <1447784668-23713-40-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56549 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540AbbKQSh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:28 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a06a0a4..0b349bc 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1250,7 +1250,6 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct Scsi_Host *shpnt = NULL;
 	struct atp_unit *atpdev, *p;
 	unsigned char setupdata[2][16];
-	int count = 0;
 
 	atpdev = kzalloc(sizeof(*atpdev), GFP_KERNEL);
 	if (!atpdev)
@@ -1298,8 +1297,8 @@ static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		host_id = atp_readb_base(atpdev, 0x39);
 		host_id >>= 0x04;
 
-		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter: %d"
-			"    IO:%x, IRQ:%d.\n", count, base_io, pdev->irq);
+		printk(KERN_INFO "   ACARD AEC-67160 PCI Ultra3 LVD Host Adapter:"
+			"    IO:%x, IRQ:%d.\n", base_io, pdev->irq);
 		atpdev->dev_id = ent->device;
 		atpdev->host_id[0] = host_id;
 
@@ -1546,8 +1545,8 @@ flash_ok_885:
 	} else {
 		error = pci_read_config_byte(pdev, 0x49, &host_id);
 
-		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: %d "
-			"IO:%x, IRQ:%d.\n", count, base_io, pdev->irq);
+		printk(KERN_INFO "   ACARD AEC-671X PCI Ultra/W SCSI-2/3 Host Adapter: "
+			"IO:%x, IRQ:%d.\n", base_io, pdev->irq);
 
 		atpdev->ioport[0] = base_io;
 		atpdev->pciport[0] = base_io + 0x20;
@@ -1612,7 +1611,6 @@ flash_ok_885:
 		spin_unlock_irqrestore(shpnt->host_lock, flags);
 		if (!request_region(base_io, shpnt->n_io_port, "atp870u"))
 			goto request_io_fail;
-		count++;
 		if (scsi_add_host(shpnt, &pdev->dev))
 			goto scsi_add_fail;
 		scsi_scan_host(shpnt);
-- 
Ondrej Zary

