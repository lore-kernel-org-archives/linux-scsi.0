From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 34/42] hpsa: fix try_soft_reset error handling
Date: Tue, 17 Mar 2015 15:05:27 -0500
Message-ID: <20150317200527.19856.80414.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42571 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbCQUHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:07:07 -0400
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B8A1E61EE8
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:07:06 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
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
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0afc48b..fdf36a7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7810,9 +7810,15 @@ reinit_after_soft_reset:
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
@@ -7820,7 +7826,7 @@ reinit_after_soft_reset:
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean4;
+			goto clean7;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -7841,7 +7847,7 @@ reinit_after_soft_reset:
 		hpsa_undo_allocations_after_kdump_soft_reset(h);
 		try_soft_reset = 0;
 		if (rc)
-			/* don't go to clean4, we already unallocated */
+			/* don't goto clean, we already unallocated */
 			return -ENODEV;
 
 		goto reinit_after_soft_reset;

