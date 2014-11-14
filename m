From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 13/13] hpsa: remove spin lock around command allocation
Date: Fri, 14 Nov 2014 17:27:29 -0600
Message-ID: <20141114232729.20808.72735.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13521 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:55 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <stephenmcameron@gmail.com>

It is already using atomic test_and_set_bit to do the
allocation.

There is some microscopic chance of starvation, but it is
so microscopic that it should never happen in reality.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 drivers/scsi/hpsa.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 72daca9..8a3d0de 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4607,19 +4607,32 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	int i;
 	union u64bit temp64;
 	dma_addr_t cmd_dma_handle, err_dma_handle;
-	unsigned long flags;
+	int loopcount;
+
+	/* There is some *extremely* small but non-zero chance that that
+	 * multiple threads could get in here, and one thread could
+	 * be scanning through the list of bits looking for a free
+	 * one, but the free ones are always behind him, and other
+	 * threads sneak in behind him and eat them before he can
+	 * get to them, so that while there is always a free one, a
+	 * very unlucky thread might be starved anyway, never able to
+	 * beat the other threads.  In reality, this happens so
+	 * infrequently as to be indistinguishable from never.
+	 */
 
-	spin_lock_irqsave(&h->lock, flags);
+	loopcount = 0;
 	do {
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-		if (i == h->nr_cmds) {
-			spin_unlock_irqrestore(&h->lock, flags);
-			return NULL;
-		}
-	} while (test_and_set_bit
-		 (i & (BITS_PER_LONG - 1),
-		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
-	spin_unlock_irqrestore(&h->lock, flags);
+		if (i == h->nr_cmds)
+			i = 0;
+		loopcount++;
+	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
+		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0 &&
+		loopcount < 10);
+
+	/* Thread got starved?  We do not expect this to ever happen. */
+	if (loopcount >= 10)
+		return NULL;
 
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(*c));
@@ -4679,13 +4692,10 @@ static struct CommandList *cmd_special_alloc(struct ctlr_info *h)
 static void cmd_free(struct ctlr_info *h, struct CommandList *c)
 {
 	int i;
-	unsigned long flags;
 
 	i = c - h->cmd_pool;
-	spin_lock_irqsave(&h->lock, flags);
 	clear_bit(i & (BITS_PER_LONG - 1),
 		  h->cmd_pool_bits + (i / BITS_PER_LONG));
-	spin_unlock_irqrestore(&h->lock, flags);
 }
 
 static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)

