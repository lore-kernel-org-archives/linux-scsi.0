From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH v2 8/9] aacraid: Fix character device re-initialization
Date: Thu, 10 Dec 2015 10:45:58 -0800
Message-ID: <1449773159-25058-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:32808 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbbLKBk3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2015 20:40:29 -0500
In-Reply-To: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

During EEH PCI hotplug activity kernel unloads and loads the driver,
causing character device to be unregistered(aac_remove_one).When the
driver is loaded back using aac_probe_one the character device needs
to be registered again for the AIF management tools to work.

Fixed by adding code to register character device in aac_probe_one if
it is unregistered in aac_remove_one.

Changes in V2:
Added macros to track character device state

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h |  7 +++++++
 drivers/scsi/aacraid/linit.c   | 21 ++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 2916288..a440840 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -94,6 +94,13 @@ enum {
 #define aac_phys_to_logical(x)  ((x)+1)
 #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
 
+/*
+ * These macros are for keeping track of
+ * character device state.
+ */
+#define AAC_CHARDEV_UNREGISTERED	(-1)
+#define AAC_CHARDEV_NEEDS_REINIT	(-2)
+
 /* #define AAC_DETAILED_STATUS_INFO */
 
 struct diskparm
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 6944560..fea1ba1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -80,7 +80,7 @@ MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
 
 static DEFINE_MUTEX(aac_mutex);
 static LIST_HEAD(aac_devices);
-static int aac_cfg_major = -1;
+static int aac_cfg_major = AAC_CHARDEV_UNREGISTERED;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
 /*
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
@@ -1180,6 +1187,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_cmd_len = 16;
 	shost->use_cmd_list = 1;
 
+	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
+		aac_init_char();
+
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->base_start = pci_resource_start(pdev, 0);
 	aac->scsi_host_ptr = shost;
@@ -1517,7 +1527,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	if (list_empty(&aac_devices)) {
 		unregister_chrdev(aac_cfg_major, "aac");
-		aac_cfg_major = -1;
+		aac_cfg_major = AAC_CHARDEV_NEEDS_REINIT;
 	}
 }
 
@@ -1680,11 +1690,8 @@ static int __init aac_init(void)
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

