From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/9] hpsa: factor out the code to reset controllers on driver
	load
Date: Wed, 16 Jun 2010 13:51:35 -0500
Message-ID: <20100616185135.22798.82149.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:3404 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0FPSqh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:37 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out the code to reset controllers on driver load
for kdump support

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 67439c1..54b7fda 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3571,33 +3571,44 @@ static void __devinit hpsa_hba_inquiry(struct ctlr_info *h)
 	}
 }
 
+static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
+{
+	int i;
+
+	if (!reset_devices)
+		return 0;
+
+	/* Reset the controller with a PCI power-cycle */
+	if (hpsa_hard_reset_controller(pdev) || hpsa_reset_msi(pdev))
+		return -ENODEV;
+
+	/* Some devices (notably the HP Smart Array 5i Controller)
+	   need a little pause here */
+	msleep(HPSA_POST_RESET_PAUSE_MSECS);
+
+	/* Now try to get the controller to respond to a no-op */
+	for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
+		if (hpsa_noop(pdev) == 0)
+			break;
+		else
+			dev_warn(&pdev->dev, "no-op failed%s\n",
+					(i < 11 ? "; re-trying" : ""));
+	}
+	return 0;
+}
+
 static int __devinit hpsa_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
-	int i, rc;
-	int dac;
+	int dac, rc;
 	struct ctlr_info *h;
 
 	if (number_of_controllers == 0)
 		printk(KERN_INFO DRIVER_NAME "\n");
-	if (reset_devices) {
-		/* Reset the controller with a PCI power-cycle */
-		if (hpsa_hard_reset_controller(pdev) || hpsa_reset_msi(pdev))
-			return -ENODEV;
-
-		/* Some devices (notably the HP Smart Array 5i Controller)
-		   need a little pause here */
-		msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
-		/* Now try to get the controller to respond to a no-op */
-		for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
-			if (hpsa_noop(pdev) == 0)
-				break;
-			else
-				dev_warn(&pdev->dev, "no-op failed%s\n",
-						(i < 11 ? "; re-trying" : ""));
-		}
-	}
+	rc = hpsa_init_reset_devices(pdev);
+	if (rc)
+		return rc;
 
 	/* Command structures must be aligned on a 32-byte boundary because
 	 * the 5 lower bits of the address are used by the hardware. and by

