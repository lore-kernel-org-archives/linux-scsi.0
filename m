From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2] add a warning when wait_for_mode_change_ack timeouts
Date: Fri, 31 Oct 2014 15:17:33 +0100
Message-ID: <1414765053-23792-3-git-send-email-thenzl@redhat.com>
References: <1414765053-23792-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbaJaORu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2014 10:17:50 -0400
In-Reply-To: <1414765053-23792-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Elliott@hp.com, brace77070@gmail.com

and remove a redundant call to pci_get_drvdata in hpsa_remove_one

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f60ce7e5bb..59ea37d175 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6416,6 +6416,8 @@ static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		if (h->remove_in_progress)
 			return;
 	}
+	if (MAX_CONFIG_WAIT == i)
+		dev_warn(&h->pdev->dev, "waiting for mode change timed out\n");
 }
 
 static int hpsa_enter_simple_mode(struct ctlr_info *h)
@@ -7210,14 +7212,12 @@ static void hpsa_free_device_info(struct ctlr_info *h)
 
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
-
 	/* Get rid of any controller monitoring work items */
 	h->remove_in_progress = 1;
 	cancel_delayed_work_sync(&h->monitor_ctlr_work);
-- 
1.9.3

