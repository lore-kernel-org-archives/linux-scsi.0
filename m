From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] hpsa: remove a needless call - pci_get_drvdata
Date: Tue, 27 Jan 2015 17:56:39 +0100
Message-ID: <1422377799-14696-3-git-send-email-thenzl@redhat.com>
References: <1422377799-14696-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbbA0Q4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 11:56:47 -0500
In-Reply-To: <1422377799-14696-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, Justin.Lindley@pmcs.com

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af32962259..6e4abba285 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7102,14 +7102,13 @@ static void hpsa_free_device_info(struct ctlr_info *h)
 
 static void hpsa_remove_one(struct pci_dev *pdev)
 {
-	struct ctlr_info *h;
 	unsigned long flags;
+	struct ctlr_info *h = pci_get_drvdata(pdev);
 
-	if (pci_get_drvdata(pdev) == NULL) {
+	if (!h) {
 		dev_err(&pdev->dev, "unable to remove device\n");
 		return;
 	}
-	h = pci_get_drvdata(pdev);
 
 	/* Get rid of any controller monitoring work items */
 	spin_lock_irqsave(&h->lock, flags);
-- 
1.9.3

