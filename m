From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 32/41] hpsa: skip free_irq calls if irqs are not allocated
Date: Fri, 06 Mar 2015 17:48:36 -0600
Message-ID: <20150306234836.29973.81474.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50534 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbbCFXuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:50:06 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 6DFBC66E4E
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2015 23:50:06 +0000 (UTC)
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
index eb9945b..5bf89a9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7804,7 +7804,12 @@ reinit_after_soft_reset:
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

