From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/17] hpsa: factor out tail calls to next_command() in
	process_(non)indexed_cmd()
Date: Tue, 01 May 2012 11:43:01 -0500
Message-ID: <20120501164301.11705.23182.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is in order to smooth the way for upcoming changes to allow use of
multiple reply queues for command completions.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Matt Gates <matthew.gates@hp.com>
---
 drivers/scsi/hpsa.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3eda5f7..7bf0327 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3379,22 +3379,21 @@ static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
 }
 
 /* process completion of an indexed ("direct lookup") command */
-static inline u32 process_indexed_cmd(struct ctlr_info *h,
+static inline void process_indexed_cmd(struct ctlr_info *h,
 	u32 raw_tag)
 {
 	u32 tag_index;
 	struct CommandList *c;
 
 	tag_index = hpsa_tag_to_index(raw_tag);
-	if (bad_tag(h, tag_index, raw_tag))
-		return next_command(h);
-	c = h->cmd_pool + tag_index;
-	finish_cmd(c);
-	return next_command(h);
+	if (!bad_tag(h, tag_index, raw_tag)) {
+		c = h->cmd_pool + tag_index;
+		finish_cmd(c);
+	}
 }
 
 /* process completion of a non-indexed command */
-static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
+static inline void process_nonindexed_cmd(struct ctlr_info *h,
 	u32 raw_tag)
 {
 	u32 tag;
@@ -3404,11 +3403,10 @@ static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
 	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
 			finish_cmd(c);
-			return next_command(h);
+			return;
 		}
 	}
 	bad_tag(h, h->nr_cmds + 1, raw_tag);
-	return next_command(h);
 }
 
 /* Some controllers, like p400, will give us one interrupt
@@ -3483,10 +3481,11 @@ static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id)
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h);
 		while (raw_tag != FIFO_EMPTY) {
-			if (hpsa_tag_contains_index(raw_tag))
-				raw_tag = process_indexed_cmd(h, raw_tag);
+			if (likely(hpsa_tag_contains_index(raw_tag)))
+				process_indexed_cmd(h, raw_tag);
 			else
-				raw_tag = process_nonindexed_cmd(h, raw_tag);
+				process_nonindexed_cmd(h, raw_tag);
+			raw_tag = next_command(h);
 		}
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -3503,10 +3502,11 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id)
 	h->last_intr_timestamp = get_jiffies_64();
 	raw_tag = get_next_completion(h);
 	while (raw_tag != FIFO_EMPTY) {
-		if (hpsa_tag_contains_index(raw_tag))
-			raw_tag = process_indexed_cmd(h, raw_tag);
+		if (likely(hpsa_tag_contains_index(raw_tag)))
+			process_indexed_cmd(h, raw_tag);
 		else
-			raw_tag = process_nonindexed_cmd(h, raw_tag);
+			process_nonindexed_cmd(h, raw_tag);
+		raw_tag = next_command(h);
 	}
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
