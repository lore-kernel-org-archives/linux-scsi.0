From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 32/43] hpsa: skip free_irq calls if irqs are not allocated
Date: Sat, 21 Feb 2015 16:20:23 -0600
Message-ID: <20150221222023.21954.62738.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55805 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbBUWVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:21:42 -0500
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id B130085D
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:21:41 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
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
index b66a7cd..35fdf1f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7815,7 +7815,12 @@ reinit_after_soft_reset:
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

