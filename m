From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 11/48] hpsa: propagate hard_reset failures in
 reset_devices mode
Date: Fri, 23 Jan 2015 16:42:01 -0600
Message-ID: <20150123224201.14919.72729.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38687 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbAWWmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:55 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Return the real reason for kdump_hard_reset failure rather
than change them all to -ENODEV.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fbeef5b..92ac76a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6416,11 +6416,8 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 	 * "performant mode".  Or, it might be 640x, which can't reset
 	 * due to concerns about shared bbwc between 6402/6404 pair.
 	 */
-	if (rc) {
-		if (rc != -ENOTSUPP) /* just try to do the kdump anyhow. */
-			rc = -ENODEV;
+	if (rc)
 		goto out_disable;
-	}
 
 	/* Now try to get the controller to respond to a no-op */
 	dev_warn(&pdev->dev, "Waiting for controller to respond to no-op\n");

