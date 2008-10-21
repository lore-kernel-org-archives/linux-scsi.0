From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/22] pata_sch: use ata_pci_sff_init_one()
Date: Tue, 21 Oct 2008 18:17:39 +0900
Message-ID: <1224580680-13698-2-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

pata_sch is standard SFF.  No reason to open code init.  Use
ata_pci_sff_init_one() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/pata_sch.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index c8cc027..4c77d63 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -174,22 +174,12 @@ static int __devinit sch_init_one(struct pci_dev *pdev,
 {
 	static int printed_version;
 	const struct ata_port_info *ppi[] = { &sch_port_info, NULL };
-	struct ata_host *host;
-	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* enable device and prepare host */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &sch_sht);
+	return ata_pci_sff_init_one(pdev, ppi, &sch_sht, NULL);
 }
 
 static int __init sch_init(void)
-- 
1.5.4.5

