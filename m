From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 33/42] hpsa: cleanup for init_one step 2 in kdump
Date: Tue, 17 Mar 2015 15:05:21 -0500
Message-ID: <20150317200521.19856.35779.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38637 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbbCQUHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:07:01 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
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
index f26e6bc..0afc48b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7422,6 +7422,16 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
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
 

