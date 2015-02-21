From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 33/43] hpsa: cleanup for init_one step 2 in kdump
Date: Sat, 21 Feb 2015 16:20:28 -0600
Message-ID: <20150221222028.21954.85329.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:56107 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbBUWWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:15 -0500
Received: from g6t1526.atlanta.hp.com (g6t1526.atlanta.hp.com [15.193.200.69])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 3BEBE556
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:21:47 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

In hpsa_undo_allocations_after_kdump_soft_reset,
the things allocated in hpsa_init_one step 2 -
h->resubmit_wq and h->lockup_detected  need to
be freed, in the right order.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 35fdf1f..3071089 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7438,6 +7438,16 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	hpsa_free_cmd_pool(h);			/* init_one 5 */
 	hpsa_free_irqs(h);			/* init_one 4 */
 	hpsa_free_pci_init(h);			/* init_one 3 */
+	free_percpu(h->lockup_detected);	/* init_one 2 */
+	h->lockup_detected = NULL;		/* init_one 2 */
+	if (h->resubmit_wq) {
+		destroy_workqueue(h->resubmit_wq);	/* init_one 1 */
+		h->resubmit_wq = NULL;
+	}
+	if (h->rescan_ctlr_wq) {
+		destroy_workqueue(h->rescan_ctlr_wq);
+		h->rescan_ctlr_wq = NULL;
+	}
 	kfree(h);				/* init_one 1 */
 }
 

