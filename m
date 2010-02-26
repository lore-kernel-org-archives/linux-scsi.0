From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 7/9] cciss: do not use void pointer for scsi hba data
Date: Fri, 26 Feb 2010 16:01:42 -0600
Message-ID: <20100226220142.11979.77215.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: do not use void pointer for scsi hba data
and get rid of related unnecessary type casting
and delete some superfluous and misleading comments nearby.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.h      |    4 +---
 drivers/block/cciss_scsi.c |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index ac454fd..c5d4111 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -131,9 +131,7 @@ struct ctlr_info
 	/* Disk structures we need to pass back */
 	struct gendisk   *gendisk[CISS_MAX_LUN];
 #ifdef CONFIG_CISS_SCSI_TAPE
-	void *scsi_ctlr; /* ptr to structure containing scsi related stuff */
-	/* list of block side commands the scsi error handling sucked up */
-	/* and saved for later processing */
+	struct cciss_scsi_adapter_data_t *scsi_ctlr;
 #endif
 	unsigned char alive;
 	struct list_head scan_list;
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index f203606..c458232 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -127,11 +127,9 @@ struct cciss_scsi_adapter_data_t {
 };
 
 #define CPQ_TAPE_LOCK(ctlr, flags) spin_lock_irqsave( \
-	&(((struct cciss_scsi_adapter_data_t *) \
-	hba[ctlr]->scsi_ctlr)->lock), flags);
+	&hba[ctlr]->scsi_ctlr->lock, flags);
 #define CPQ_TAPE_UNLOCK(ctlr, flags) spin_unlock_irqrestore( \
-	&(((struct cciss_scsi_adapter_data_t *) \
-	hba[ctlr]->scsi_ctlr)->lock), flags);
+	&hba[ctlr]->scsi_ctlr->lock, flags);
 
 static CommandList_struct *
 scsi_cmd_alloc(ctlr_info_t *h)
@@ -147,7 +145,7 @@ scsi_cmd_alloc(ctlr_info_t *h)
 	struct cciss_scsi_cmd_stack_t *stk;
 	u64bit temp64;
 
-	sa = (struct cciss_scsi_adapter_data_t *) h->scsi_ctlr;
+	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
 	if (stk->top < 0) 
@@ -186,7 +184,7 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct *cmd)
 	struct cciss_scsi_adapter_data_t *sa;
 	struct cciss_scsi_cmd_stack_t *stk;
 
-	sa = (struct cciss_scsi_adapter_data_t *) h->scsi_ctlr;
+	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 	if (stk->top >= CMD_STACK_SIZE) {
 		printk("cciss: scsi_cmd_free called too many times.\n");
@@ -233,7 +231,7 @@ scsi_cmd_stack_free(int ctlr)
 	struct cciss_scsi_cmd_stack_t *stk;
 	size_t size;
 
-	sa = (struct cciss_scsi_adapter_data_t *) hba[ctlr]->scsi_ctlr;
+	sa = hba[ctlr]->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 	if (stk->top != CMD_STACK_SIZE-1) {
 		printk( "cciss: %d scsi commands are still outstanding.\n",
@@ -534,8 +532,7 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 	CPQ_TAPE_LOCK(ctlr, flags);
 
 	if (hostno != -1)  /* if it's not the first time... */
-		sh = ((struct cciss_scsi_adapter_data_t *)
-			hba[ctlr]->scsi_ctlr)->scsi_host;
+		sh = hba[ctlr]->scsi_ctlr->scsi_host;
 
 	/* find any devices in ccissscsi[] that are not in 
 	   sd[] and remove them from ccissscsi[] */
@@ -706,7 +703,7 @@ cciss_scsi_setup(int cntl_num)
 		kfree(shba);
 		shba = NULL;
 	}
-	hba[cntl_num]->scsi_ctlr = (void *) shba;
+	hba[cntl_num]->scsi_ctlr = shba;
 	return;
 }
 
@@ -853,7 +850,7 @@ cciss_scsi_detect(int ctlr)
 	sh->this_id = SELF_SCSI_ID;  
 
 	((struct cciss_scsi_adapter_data_t *) 
-		hba[ctlr]->scsi_ctlr)->scsi_host = (void *) sh;
+		hba[ctlr]->scsi_ctlr)->scsi_host = sh;
 	sh->hostdata[0] = (unsigned long) hba[ctlr];
 	sh->irq = hba[ctlr]->intr[SIMPLE_MODE_INT];
 	sh->unique_id = sh->irq;
@@ -1518,7 +1515,7 @@ cciss_unregister_scsi(int ctlr)
 	/* we are being forcibly unloaded, and may not refuse. */
 
 	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	sa = (struct cciss_scsi_adapter_data_t *) hba[ctlr]->scsi_ctlr;
+	sa = hba[ctlr]->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
 	/* if we weren't ever actually registered, don't unregister */ 
@@ -1545,7 +1542,7 @@ cciss_engage_scsi(int ctlr)
 	unsigned long flags;
 
 	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	sa = (struct cciss_scsi_adapter_data_t *) hba[ctlr]->scsi_ctlr;
+	sa = hba[ctlr]->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
 	if (sa->registered) {
