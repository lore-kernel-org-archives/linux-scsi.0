From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 09/10] aacraid: Fix character device re-initialization
Date: Tue, 1 Dec 2015 04:39:47 -0800
Message-ID: <1448973589-9216-10-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55993 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbbLATeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:23 -0500
In-Reply-To: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

During EEH PCI hotplug activity kernel unloads and loads the driver,
causing character device to be unregistered(aac_remove_one).When the
driver is loaded back using aac_probe_one the character device needs
to be registered again for the AIF management tools to work.

Fixed by adding code to register character device in aac_probe_one if
it is unregistered in aac_remove_one.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2094842..7142578 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1123,6 +1123,13 @@ static void __aac_shutdown(struct aac_dev * aac)
 	else if (aac->max_msix > 1)
 		pci_disable_msix(aac->pdev);
 }
+static void aac_init_char(void)
+{
+	aac_cfg_major = register_chrdev(0, "aac", &aac_cfg_fops);
+	if (aac_cfg_major < 0) {
+		pr_err("aacraid: unable to register \"aac\" device.\n");
+	}
+}
 
 static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -1185,6 +1192,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_cmd_len = 16;
 	shost->use_cmd_list = 1;
 
+	if (aac_cfg_major == -2)
+		aac_init_char();
+
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->base_start = pci_resource_start(pdev, 0);
 	aac->scsi_host_ptr = shost;
@@ -1536,7 +1546,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	if (list_empty(&aac_devices)) {
 		unregister_chrdev(aac_cfg_major, "aac");
-		aac_cfg_major = -1;
+		aac_cfg_major = -2;
 	}
 }
 
@@ -1697,11 +1707,8 @@ static int __init aac_init(void)
 	if (error < 0)
 		return error;
 
-	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
-	if (aac_cfg_major < 0) {
-		printk(KERN_WARNING
-			"aacraid: unable to register \"aac\" device.\n");
-	}
+	aac_init_char();
+
 
 	return 0;
 }
-- 
1.9.1

