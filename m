From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 12/48] hpsa: propagate return value from board ID lookup
Date: Wed, 14 Jan 2015 16:00:37 -0600
Message-ID: <20150114220037.21325.80301.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57950 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbANWBY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:01:24 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If the board ID lookup function fails, return the return
code rather than return -ENODEV.

The only board ID failure reason right now is -ENODEV,
so this just provides more informative prints in kdump
and adapts to future changes.

Tested with error injection while booting with
	reset_devices
on the kernel command line:
[   62.804324]  injecting error in inj_hpsa_lookup_board_id: 1 11
[   62.804423] hpsa 0000:04:00.0: Board ID not found

(the pci probe layer does not print an additional
message if -ENODEV is the reason)

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 92ac76a..85b3d73 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5812,8 +5812,12 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 */
 
 	rc = hpsa_lookup_board_id(pdev, &board_id);
-	if (rc < 0 || !ctlr_is_resettable(board_id)) {
-		dev_warn(&pdev->dev, "Not resetting device.\n");
+	if (rc < 0) {
+		dev_warn(&pdev->dev, "Board ID not found\n");
+		return rc;
+	}
+	if (!ctlr_is_resettable(board_id)) {
+		dev_warn(&pdev->dev, "Controller not resettable\n");
 		return -ENODEV;
 	}
 
@@ -6295,7 +6299,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
 
 	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
 	if (prod_index < 0)
-		return -ENODEV;
+		return prod_index;
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
 

