From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 04/48] hpsa: change how SA controllers are reset
Date: Fri, 23 Jan 2015 16:41:25 -0600
Message-ID: <20150123224125.14919.942.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30127 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbAWWmT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:19 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Change how SA controllers are reset by changing PCI power levels.
The hpsa driver was finding the PCI_PM_CTRL_STATE_MASK offset
then reading/writing a bitmask to change the power state. There
are kernel functions that do the same operations. Better to use
the kernel functions.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 drivers/scsi/hpsa.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9edacff..371d0a8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5689,30 +5689,22 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		 * the controller, place the interface device in D3 then to D0,
 		 * this causes a secondary PCI reset which will reset the
 		 * controller." */
-		int pos;
-		u16 pmcsr;
-
-		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
-		if (pos == 0) {
-			dev_err(&pdev->dev,
-				"hpsa_reset_controller: "
-				"PCI PM not supported\n");
-			return -ENODEV;
-		}
+
+		int rc = 0;
+
 		dev_info(&pdev->dev, "using PCI PM to reset controller\n");
+
 		/* enter the D3hot power management state */
-		pci_read_config_word(pdev, pos + PCI_PM_CTRL,
-					(__force u16 *)&pmcsr);
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= (__force u16) PCI_D3hot;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		rc = pci_set_power_state(pdev, PCI_D3hot);
+		if (rc)
+			return rc;
 
 		msleep(500);
 
 		/* enter the D0 power management state */
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= (__force u16) PCI_D0;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		rc = pci_set_power_state(pdev, PCI_D0);
+		if (rc)
+			return rc;
 
 		/*
 		 * The P600 requires a small delay when changing states.

