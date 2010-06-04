From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 3/5] cciss: move next_command function from ifdef
Date: Fri, 4 Jun 2010 15:12:48 -0500
Message-ID: <20100604201248.GC30870@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:41339 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0FDUIB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2010 16:08:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, dab@hp.com, scameron@beardog.cce.hp.com, gerry.morong@hp.com, mike.miller@hp.com, scott.benesh@hp.com, scott.stacy.teel@hp.com, tom.lawler@hp.com, mikem@beardog.cce.hp.com

Patch 3 of 5
cciss: the definition of next_command also ended up in wrong place
It ended up inside an "#ifdef CONFIG_PROCFS". Already caught by Randy Dunlap
and a couple others. Tried to put it somewhere that made sense.

Thanks, Randy.

From: Mike Miller <mike.miller@hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com
---
 drivers/block/cciss.c |   45 +++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 156ea36..10a0268 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -213,6 +213,7 @@ static void cciss_hba_release(struct device *dev);
 static void cciss_device_release(struct device *dev);
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
+static inline u32 next_command(ctlr_info_t *h);
 
 /* performant mode helper functions */
 static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
@@ -374,28 +375,6 @@ static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 
 #ifdef CONFIG_PROC_FS
 
-static inline u32 next_command(ctlr_info_t *h)
-{
-	u32 a;
-
-	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
-		return h->access.command_completed(h);
-
-	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
-		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
-		(h->reply_pool_head)++;
-		h->commands_outstanding--;
-	} else {
-		a = FIFO_EMPTY;
-	}
-	/* Check for wraparound */
-	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
-		h->reply_pool_head = h->reply_pool;
-		h->reply_pool_wraparound ^= 1;
-	}
-	return a;
-}
-
 /*
  * Report information about this controller.
  */
@@ -3411,6 +3390,28 @@ static inline void finish_cmd(ctlr_info_t *h, CommandList_struct *c,
 #endif
 }
 
+static inline u32 next_command(ctlr_info_t *h)
+{
+	u32 a;
+
+	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+		return h->access.command_completed(h);
+
+	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
+		a = *(h->reply_pool_head); /* Next cmd in ring buffer */
+		(h->reply_pool_head)++;
+		h->commands_outstanding--;
+	} else {
+		a = FIFO_EMPTY;
+	}
+	/* Check for wraparound */
+	if (h->reply_pool_head == (h->reply_pool + h->max_commands)) {
+		h->reply_pool_head = h->reply_pool;
+		h->reply_pool_wraparound ^= 1;
+	}
+	return a;
+}
+
 /* process completion of an indexed ("direct lookup") command */
 static inline u32 process_indexed_cmd(ctlr_info_t *h, u32 raw_tag)
 {
