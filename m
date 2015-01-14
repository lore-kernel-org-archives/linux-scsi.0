From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 04/48] hpsa: change how SA controllers are reset
Date: Wed, 14 Jan 2015 15:59:55 -0600
Message-ID: <20150114215955.21325.47215.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55197 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbbANWAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:00:42 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 3C4ED44A2
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:00:42 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
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

