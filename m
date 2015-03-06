From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 39/41] hpsa: propagate the error code in
 hpsa_kdump_soft_reset
Date: Fri, 06 Mar 2015 17:49:13 -0600
Message-ID: <20150306234913.29973.66270.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:41141 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbbCFXum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:50:42 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If hpsa_wait_for_board_state fails, hpsa_kdump_soft_reset
should propagate its return value (e.g., -ENODEV) rather
than just returning -1.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9d6f95c..11581b4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7485,19 +7485,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 
 static int hpsa_kdump_soft_reset(struct ctlr_info *h)
 {
+	int rc;
 	hpsa_send_host_reset(h, RAID_CTLR_LUNID, HPSA_RESET_TYPE_CONTROLLER);
 
 	dev_info(&h->pdev->dev, "Waiting for board to soft reset.\n");
-	if (hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_NOT_READY)) {
+	rc = hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_NOT_READY);
+	if (rc) {
 		dev_warn(&h->pdev->dev, "Soft reset had no effect.\n");
-		return -1;
+		return rc;
 	}
 
 	dev_info(&h->pdev->dev, "Board reset, awaiting READY status.\n");
-	if (hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY)) {
+	rc = hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY);
+	if (rc) {
 		dev_warn(&h->pdev->dev, "Board failed to become ready "
 			"after soft reset.\n");
-		return -1;
+		return rc;
 	}
 
 	return 0;

