From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 32/42] hpsa: skip free_irq calls if irqs are not allocated
Date: Thu, 23 Apr 2015 09:34:37 -0500
Message-ID: <20150423143437.18832.50571.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2353.austin.hp.com ([15.217.128.52]:36460 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966081AbbDWOfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:35:45 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
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
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 83f91c5..c5fbee7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7758,7 +7758,12 @@ reinit_after_soft_reset:
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

