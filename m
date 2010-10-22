From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/10] hpsa: take the adapter lock in
	hpsa_wait_for_mode_change_ack
Date: Fri, 22 Oct 2010 14:27:45 -0500
Message-ID: <20101022192745.25694.48612.stgit@beardog.cce.hp.com>
References: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5594 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266Ab0JVT1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 15:27:50 -0400
In-Reply-To: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Need to take the lock while accessing the register to check to
see if config table changes have taken effect.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d618432..ffc5f74 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3576,13 +3576,18 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 {
 	int i;
+	u32 doorbell_value;
+	unsigned long flags;
 
 	/* under certain very rare conditions, this can take awhile.
 	 * (e.g.: hot replace a failed 144GB drive in a RAID 5 set right
 	 * as we enter this code.)
 	 */
 	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
-		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
+		spin_lock_irqsave(&h->lock, flags);
+		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
+		spin_unlock_irqrestore(&h->lock, flags);
+		if (!doorbell_value & CFGTBL_ChangeReq)
 			break;
 		/* delay and try again */
 		msleep(10);
@@ -3754,6 +3759,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->busy_initializing = 1;
 	INIT_HLIST_HEAD(&h->cmpQ);
 	INIT_HLIST_HEAD(&h->reqQ);
+	spin_lock_init(&h->lock);
+	spin_lock_init(&h->scan_lock);
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
@@ -3813,8 +3820,6 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	}
 	if (hpsa_allocate_sg_chain_blocks(h))
 		goto clean4;
-	spin_lock_init(&h->lock);
-	spin_lock_init(&h->scan_lock);
 	init_waitqueue_head(&h->scan_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
 

