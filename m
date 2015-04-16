From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 32/43] hpsa: skip free_irq calls if irqs are not allocated
Date: Thu, 16 Apr 2015 08:49:36 -0500
Message-ID: <20150416134936.30238.72827.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:34563 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965096AbbDPNuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:50:37 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
index 8aeef06..dc8299c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7773,7 +7773,12 @@ reinit_after_soft_reset:
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

