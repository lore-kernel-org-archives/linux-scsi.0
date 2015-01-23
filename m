From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] hpsa: remove a needless call - pci_get_drvdata
Date: Fri, 23 Jan 2015 17:16:26 +0100
Message-ID: <1422029786-15046-3-git-send-email-thenzl@redhat.com>
References: <1422029786-15046-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbbAWQQd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 11:16:33 -0500
In-Reply-To: <1422029786-15046-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, Justin.Lindley@pmcs.com

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 909562c09f..7fdc4d2a91 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7069,13 +7069,12 @@ static void hpsa_free_device_info(struct ctlr_info *h)
 
 static void hpsa_remove_one(struct pci_dev *pdev)
 {
-	struct ctlr_info *h;
+	struct ctlr_info *h = pci_get_drvdata(pdev);
 
-	if (pci_get_drvdata(pdev) == NULL) {
+	if (!h) {
 		dev_err(&pdev->dev, "unable to remove device\n");
 		return;
 	}
-	h = pci_get_drvdata(pdev);
 
 	/* Get rid of any controller monitoring work items */
 	h->remove_in_progress = 1;
-- 
1.9.3

