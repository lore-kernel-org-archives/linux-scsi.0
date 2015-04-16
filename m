From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 39/43] hpsa: propagate the error code in
 hpsa_kdump_soft_reset
Date: Thu, 16 Apr 2015 08:50:14 -0500
Message-ID: <20150416135014.30238.10423.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:35379 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134AbbDPNvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:51:15 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
index f65333d..f36ab70 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7458,19 +7458,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 
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

