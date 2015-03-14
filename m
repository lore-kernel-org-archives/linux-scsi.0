From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] hpsa: cleanup bitops usage
Date: Sat, 14 Mar 2015 10:12:53 +0900
Message-ID: <1426295577-10836-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove unnecessary adjustment for bit number and address of bitmask,
and use BITS_TO_LONGS macro to calculate bitmap size.  This change
just simplifies the code a bit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Brace <don.brace@pmcs.com>
Cc: iss_storagedev@hp.com
Cc: storagedev@pmcs.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1cfbd3..73a282b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4697,8 +4697,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 			offset = (i + 1) % h->nr_cmds;
 			continue;
 		}
-		set_bit(i & (BITS_PER_LONG - 1),
-			h->cmd_pool_bits + (i / BITS_PER_LONG));
+		set_bit(i, h->cmd_pool_bits);
 		break; /* it's ours now. */
 	}
 	h->last_allocation = i; /* benignly racy */
@@ -4729,8 +4728,7 @@ static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 		int i;
 
 		i = c - h->cmd_pool;
-		clear_bit(i & (BITS_PER_LONG - 1),
-			  h->cmd_pool_bits + (i / BITS_PER_LONG));
+		clear_bit(i, h->cmd_pool_bits);
 	}
 }
 
@@ -6410,8 +6408,7 @@ out_disable:
 
 static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
 {
-	h->cmd_pool_bits = kzalloc(
-		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
+	h->cmd_pool_bits = kcalloc(BITS_TO_LONGS(h->nr_cmds),
 		sizeof(unsigned long), GFP_KERNEL);
 	h->cmd_pool = pci_alloc_consistent(h->pdev,
 		    h->nr_cmds * sizeof(*h->cmd_pool),
-- 
1.9.1
