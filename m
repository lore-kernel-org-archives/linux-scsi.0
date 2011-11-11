From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/6] scsi/hpsa: Disable ASPM
Date: Fri, 11 Nov 2011 11:05:10 -0500
Message-ID: <1321027511-31229-6-git-send-email-mjg@redhat.com>
References: <1321027511-31229-1-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004Ab1KKQGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 11:06:21 -0500
In-Reply-To: <1321027511-31229-1-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, scameron@beardog.cce.hp.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org

The Windows driver .inf disables ASPM on hpsa devices. Do the same.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: scameron@beardog.cce.hp.com
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e76107b..fc2f4c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3922,6 +3922,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
+
+	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");
-- 
1.7.7.1

