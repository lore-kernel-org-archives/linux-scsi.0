From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] [MEGARAID_SAS]: Use pr_info
Date: Wed, 8 Aug 2007 20:14:59 -0300
Message-ID: <20070808231459.GB3375@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:38322 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759536AbXHHXPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 19:15:07 -0400
Received: by nz-out-0506.google.com with SMTP id s18so160070nze
        for <linux-scsi@vger.kernel.org>; Wed, 08 Aug 2007 16:15:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@steeleye.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 drivers/scsi/megaraid/megaraid_sas.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 59099da..4a8cf06 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1341,8 +1341,7 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 	fw_state = instance->instancet->read_fw_status_reg(instance->reg_set) & MFI_STATE_MASK;
 
 	if (fw_state != MFI_STATE_READY)
- 		printk(KERN_INFO "megasas: Waiting for FW to come to ready"
- 		       " state\n");
+ 		pr_info("megasas: Waiting for FW to come to ready state\n");
 
 	while (fw_state != MFI_STATE_READY) {
 
@@ -1444,7 +1443,7 @@ megasas_transition_to_ready(struct megasas_instance* instance)
 			return -ENODEV;
 		}
 	};
- 	printk(KERN_INFO "megasas: FW now in Ready state\n");
+ 	pr_info("megasas: FW now in Ready state\n");
 
 	return 0;
 }
@@ -2277,9 +2276,9 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/*
 	 * Announce PCI information
 	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
+	pr_info("megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
+		pdev->vendor, pdev->device, pdev->subsystem_vendor,
+		pdev->subsystem_device);
 
 	printk("bus %d:slot %d:func %d\n",
 	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
@@ -3030,8 +3029,7 @@ static int __init megasas_init(void)
 	/*
 	 * Announce driver version and other information
 	 */
-	printk(KERN_INFO "megasas: %s %s\n", MEGASAS_VERSION,
-	       MEGASAS_EXT_VERSION);
+	pr_info("megasas: %s %s\n", MEGASAS_VERSION, MEGASAS_EXT_VERSION);
 
 	/*
 	 * Register character device node
-- 
1.5.2.2

