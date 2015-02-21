From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 38/43] hpsa: clean up new block layer tag error handling
Date: Sat, 21 Feb 2015 16:20:55 -0600
Message-ID: <20150221222055.21954.2960.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:51792 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbBUWWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:13 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

clean up new block layer tag error handling

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8f1b0e6..c491bed 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4854,18 +4854,23 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	sh->unique_id = sh->irq;
 	if (!shost_use_blk_mq(sh)) {
 		error = scsi_init_shared_tag_map(sh, sh->can_queue);
-		if (error)
+		if (error) {
+			dev_err(&h->pdev->dev,
+				"%s: scsi_init_shared_tag_map failed for controller %d\n",
+				__func__, h->ctlr);
 			goto fail_host_put;
+		}
 	}
 	error = scsi_add_host(sh, &h->pdev->dev);
-	if (error)
+	if (error) {
+		dev_err(&h->pdev->dev, "%s: scsi_add_host failed for controller %d\n",
+			__func__, h->ctlr);
 		goto fail_host_put;
+	}
 	scsi_scan_host(sh);
 	return 0;
 
  fail_host_put:
-	dev_err(&h->pdev->dev, "%s: scsi_add_host"
-		" failed for controller %d\n", __func__, h->ctlr);
 	scsi_host_put(sh);
 	return error;
  fail:

