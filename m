From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 41/43] hpsa: propagate the error code in
 hpsa_kdump_soft_reset
Date: Sat, 21 Feb 2015 16:21:10 -0600
Message-ID: <20150221222110.21954.37936.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1886 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbBUWW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:28 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
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
index 8a4c3f2..ea66c1d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7527,19 +7527,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 
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

