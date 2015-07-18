From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 11/11] hpsa: fix rmmod issues
Date: Sat, 18 Jul 2015 11:13:15 -0500
Message-ID: <20150718161315.31955.98302.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2353.austin.hp.com ([15.217.128.52]:55152 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbGRQPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:15:31 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

The driver is calling hpsa_shutdown before calling scsi_remove_host.
hpsa_shutdown is disabling interrupts.

scsi_remove_host can trigger I/O operations, such as
SYNCHRONIZE CACHE when multipath is enabled which hang the system.

Call scsi_remove_host before calling hpsa_shutdown.

Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a3077e9..0f8acfb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8269,6 +8269,14 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
 
+	/*
+	 * Call before disabling interrupts.
+	 * scsi_remove_host can trigger I/O operations especially
+	 * when multipath is enabled. There can be SYNCHRONIZE CACHE
+	 * operations which cannot complete and will hang the system.
+	 */
+	if (h->scsi_host)
+		scsi_remove_host(h->scsi_host);		/* init_one 8 */
 	/* includes hpsa_free_irqs - init_one 4 */
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
 	hpsa_shutdown(pdev);
@@ -8277,8 +8285,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
 	kfree(h->hba_inquiry_data);			/* init_one 10 */
 	h->hba_inquiry_data = NULL;			/* init_one 10 */
-	if (h->scsi_host)
-		scsi_remove_host(h->scsi_host);		/* init_one 8 */
 	hpsa_free_ioaccel2_sg_chain_blocks(h);
 	hpsa_free_performant_mode(h);			/* init_one 7 */
 	hpsa_free_sg_chain_blocks(h);			/* init_one 6 */

