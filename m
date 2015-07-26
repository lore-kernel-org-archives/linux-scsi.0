From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 39/52] atp870u: Remove useless and broken card counting
Date: Sun, 26 Jul 2015 22:24:46 +0200
Message-ID: <1437942299-26674-40-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56677 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbbGZU5N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:57:13 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTz-0003IN-Uu
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:16 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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

