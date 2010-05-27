From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 19/24] hpsa: factor out hpsa_enter_performant_mode
Date: Thu, 27 May 2010 15:14:19 -0500
Message-ID: <20100527201418.3116.40851.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27708 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:39 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_enter_performant_mode

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   54 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bd2e0c6..3fb4322 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3816,36 +3816,16 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
+static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h)
 {
-	u32 trans_support;
+	int i;
+	unsigned long register_value;
+	int bft[8] = {5, 6, 8, 10, 12, 20, 28, 35}; /* for scatter/gathers */
 	/*  5 = 1 s/g entry or 4k
 	 *  6 = 2 s/g entry or 8k
 	 *  8 = 4 s/g entry or 16k
 	 * 10 = 6 s/g entry or 24k
 	 */
-	int bft[8] = {5, 6, 8, 10, 12, 20, 28, 35}; /* for scatter/gathers */
-	int i = 0;
-	unsigned long register_value;
-
-	trans_support = readl(&(h->cfgtable->TransportSupport));
-	if (!(trans_support & PERFORMANT_MODE))
-		return;
-
-	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
-	h->max_sg_entries = 32;
-	/* Performant mode ring buffer and supporting data structures */
-	h->reply_pool_size = h->max_commands * sizeof(u64);
-	h->reply_pool = pci_alloc_consistent(h->pdev, h->reply_pool_size,
-				&(h->reply_pool_dhandle));
-
-	/* Need a block fetch table for performant mode */
-	h->blockFetchTable = kmalloc(((h->max_sg_entries+1) *
-				sizeof(u32)), GFP_KERNEL);
-
-	if ((h->reply_pool == NULL)
-		|| (h->blockFetchTable == NULL))
-		goto clean_up;
 
 	h->reply_pool_wraparound = 1; /* spec: init to 1 */
 
@@ -3875,6 +3855,32 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 					" performant mode\n");
 		return;
 	}
+}
+
+static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
+{
+	u32 trans_support;
+
+	trans_support = readl(&(h->cfgtable->TransportSupport));
+	if (!(trans_support & PERFORMANT_MODE))
+		return;
+
+	h->max_commands = readl(&(h->cfgtable->MaxPerformantModeCommands));
+	h->max_sg_entries = 32;
+	/* Performant mode ring buffer and supporting data structures */
+	h->reply_pool_size = h->max_commands * sizeof(u64);
+	h->reply_pool = pci_alloc_consistent(h->pdev, h->reply_pool_size,
+				&(h->reply_pool_dhandle));
+
+	/* Need a block fetch table for performant mode */
+	h->blockFetchTable = kmalloc(((h->max_sg_entries+1) *
+				sizeof(u32)), GFP_KERNEL);
+
+	if ((h->reply_pool == NULL)
+		|| (h->blockFetchTable == NULL))
+		goto clean_up;
+
+	hpsa_enter_performant_mode(h);
 
 	/* Change the access methods to the performant access methods */
 	h->access = SA5_performant_access;

