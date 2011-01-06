From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/11] hpsa: take the adapter lock in
	hpsa_wait_for_mode_change_ack
Date: Thu, 06 Jan 2011 14:48:24 -0600
Message-ID: <20110106204824.10753.16210.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35549 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1AFUsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 15:48:25 -0500
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Need to take the lock while accessing the register to check to
see if config table changes have taken effect.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5b9cd41..4fb62c2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3553,13 +3553,18 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
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
@@ -3731,6 +3736,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->busy_initializing = 1;
 	INIT_HLIST_HEAD(&h->cmpQ);
 	INIT_HLIST_HEAD(&h->reqQ);
+	spin_lock_init(&h->lock);
+	spin_lock_init(&h->scan_lock);
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
@@ -3790,8 +3797,6 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	}
 	if (hpsa_allocate_sg_chain_blocks(h))
 		goto clean4;
-	spin_lock_init(&h->lock);
-	spin_lock_init(&h->scan_lock);
 	init_waitqueue_head(&h->scan_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
 

