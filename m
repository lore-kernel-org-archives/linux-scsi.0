From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] hpsa: Disable ASPM
Date: Wed,  9 Feb 2011 13:07:10 -0500
Message-ID: <1297274831-10405-1-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1BISJX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2011 13:09:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mjg@redhat.com
Cc: iss_storagedev@hp.com, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, linux-scsi@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=618612 indicates that current
hpsa hardware has problems if ASPM is enabled. Disable it to avoid crashes.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: iss_storagedev@hp.com
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 12deffc..30fb46a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -3733,6 +3734,9 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	if (number_of_controllers == 0)
 		printk(KERN_INFO DRIVER_NAME "\n");
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	rc = hpsa_init_reset_devices(pdev);
 	if (rc)
 		return rc;
-- 
1.7.4

