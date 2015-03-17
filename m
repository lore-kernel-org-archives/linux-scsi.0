From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 32/42] hpsa: skip free_irq calls if irqs are not allocated
Date: Tue, 17 Mar 2015 15:05:16 -0500
Message-ID: <20150317200516.19856.97942.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42563 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbCQUG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:56 -0400
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id F3E5964340
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:06:55 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If try_soft_reset fails to re-allocate irqs, the error exit
starts with free_irq calls, which generate kernel WARN
messages since they were already freed a few lines earlier.

Jump to the next exit label to skip the free_irq calls.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 33aca38..f26e6bc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7799,7 +7799,12 @@ reinit_after_soft_reset:
 		if (rc) {
 			dev_warn(&h->pdev->dev,
 				"Failed to request_irq after soft reset.\n");
-			goto clean4;
+			/*
+			 * clean4 starts with free_irqs, but that was just
+			 * done. Then, request_irqs_failed, so there is
+			 * nothing to free. So, goto the next label.
+			 */
+			goto clean3;
 		}
 
 		rc = hpsa_kdump_soft_reset(h);

