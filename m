From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 34/42] hpsa: fix try_soft_reset error handling
Date: Thu, 23 Apr 2015 09:34:48 -0500
Message-ID: <20150423143448.18832.69117.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:46725 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbbDWOfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:35:55 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If registering the special interrupt handlers in hpsa_init_one
before a soft reset fails, the error exit needs to deallocate
everything that was allocated before.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d2d3a43..e685b86 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7769,9 +7769,15 @@ reinit_after_soft_reset:
 			dev_warn(&h->pdev->dev,
 				"Failed to request_irq after soft reset.\n");
 			/*
-			 * clean4 starts with free_irqs, but that was just
-			 * done. Then, request_irqs_failed, so there is
-			 * nothing to free. So, goto the next label.
+			 * cannot goto clean7 or free_irqs will be called
+			 * again. Instead, do its work
+			 */
+			hpsa_free_performant_mode(h);	/* clean7 */
+			hpsa_free_sg_chain_blocks(h);	/* clean6 */
+			hpsa_free_cmd_pool(h);		/* clean5 */
+			/*
+			 * skip hpsa_free_irqs(h) clean4 since that
+			 * was just called before request_irqs failed
 			 */
 			goto clean3;
 		}
@@ -7779,7 +7785,7 @@ reinit_after_soft_reset:
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean4;
+			goto clean7;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -7800,7 +7806,7 @@ reinit_after_soft_reset:
 		hpsa_undo_allocations_after_kdump_soft_reset(h);
 		try_soft_reset = 0;
 		if (rc)
-			/* don't go to clean4, we already unallocated */
+			/* don't goto clean, we already unallocated */
 			return -ENODEV;
 
 		goto reinit_after_soft_reset;

