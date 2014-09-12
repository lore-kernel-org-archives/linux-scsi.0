From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: add missing pci_set_master in kdump path
Date: Fri, 12 Sep 2014 14:44:15 +0200
Message-ID: <5412EA9F.4060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaILMol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 08:44:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: elliott@hp.com, steve.cameron@hp.com, Christoph Hellwig <hch@infradead.org>, "Handzik, Joe" <joseph.t.handzik@hp.com>

Add a call to pci_set_master(...)  missing in the previous
patch "hpsa: refine the pci enable/disable handling".
Found thanks to Rob Elliot.
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7828834..cef5d49 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6544,7 +6544,7 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "failed to enable device.\n");
 		return -ENODEV;
 	}
-
+	pci_set_master(pdev);
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 
-- 
1.8.3.1


