From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Wed, 19 Nov 2008 21:46:25 +0100
Message-ID: <20081119204624.GW26308@kernel.dk>
References: <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net> <49232232.10604@oracle.com> <4923237B.9090707@xenotime.net> <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77884EACB7986A@GVW0547EXC.americas.hpqcorp.net> <49244B69.80903@oracle.com> <0F5B06BAB751E047AB5C87D1F77A77884EACB798C4@GVW0547EXC.americas.hpqcorp.net> <20081119172919.GT26308@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77884EACB799CC@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:42837 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbYKSUsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 15:48:14 -0500
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884EACB799CC@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>

On Wed, Nov 19 2008, Miller, Mike (OS Dev) wrote:
> Jens wrote:
> 
> >
> > Yeah, kexec is definitely a clue. My guess is that we got
> > some sort of left over completion. Regardless of the status
> > of this particular bug or not, I think it would be a good
> > idea to add some checks for when a command is attempted
> > removed from a queue it isn't currently on.
> >
> 
> I agree, I'll fix.

I'd propose just converting it to list_head instead of doing it
manually. Heck, that should be a 5 minute job, let me just do it...

OK, here it is, totally untested (it compiles, must be golden...)

 3 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 12de1fd..d2923de 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -215,30 +215,17 @@ static struct block_device_operations cciss_fops = {
 /*
  * Enqueuing and dequeuing functions for cmdlists.
  */
-static inline void addQ(CommandList_struct **Qptr, CommandList_struct *c)
+static inline void addQ(struct list_head *list, CommandList_struct *c)
 {
-	if (*Qptr == NULL) {
-		*Qptr = c;
-		c->next = c->prev = c;
-	} else {
-		c->prev = (*Qptr)->prev;
-		c->next = (*Qptr);
-		(*Qptr)->prev->next = c;
-		(*Qptr)->prev = c;
-	}
+	list_add(&c->list, list);
 }
 
-static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
-					  CommandList_struct *c)
+static inline CommandList_struct *removeQ(CommandList_struct *c)
 {
-	if (c && c->next != c) {
-		if (*Qptr == c)
-			*Qptr = c->next;
-		c->prev->next = c->next;
-		c->next->prev = c->prev;
-	} else {
-		*Qptr = NULL;
-	}
+	if (WARN_ON(list_empty(&c->list)))
+		return NULL;
+
+	list_del_init(&c->list);
 	return c;
 }
 
@@ -506,6 +493,7 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool)
 		c->cmdindex = i;
 	}
 
+	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (__u32) cmd_dma_handle;
 	temp64.val = (__u64) err_dma_handle;
 	c->ErrDesc.Addr.lower = temp64.val32.lower;
@@ -2543,7 +2531,8 @@ static void start_io(ctlr_info_t *h)
 {
 	CommandList_struct *c;
 
-	while ((c = h->reqQ) != NULL) {
+	while (!list_empty(&h->reqQ)) {
+		c = list_entry(h->reqQ.next, CommandList_struct, list);
 		/* can't do anything if fifo is full */
 		if ((h->access.fifo_full(h))) {
 			printk(KERN_WARNING "cciss: fifo full\n");
@@ -2551,7 +2540,7 @@ static void start_io(ctlr_info_t *h)
 		}
 
 		/* Get the first entry from the Request Q */
-		removeQ(&(h->reqQ), c);
+		removeQ(c);
 		h->Qdepth--;
 
 		/* Tell the controller execute command */
@@ -2981,15 +2970,8 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 
 			} else {
 				a &= ~3;
-				if ((c = h->cmpQ) == NULL) {
-					printk(KERN_WARNING
-					       "cciss: Completion of %08x ignored\n",
-					       a1);
-					continue;
-				}
-				while (c->busaddr != a) {
-					c = c->next;
-					if (c == h->cmpQ)
+				list_for_each_entry(c, &h->cmpQ, list) {
+					if (c->busaddr == a)
 						break;
 				}
 			}
@@ -2998,7 +2980,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 			 * completion Q and free it
 			 */
 			if (c->busaddr == a) {
-				removeQ(&h->cmpQ, c);
+				removeQ(c);
 				if (c->cmd_type == CMD_RWREQ) {
 					complete_command(h, c, 0);
 				} else if (c->cmd_type == CMD_IOCTL_PEND) {
@@ -3417,6 +3399,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		return -1;
 
 	hba[i]->busy_initializing = 1;
+	INIT_LIST_HEAD(&hba[i]->cmpQ);
+	INIT_LIST_HEAD(&hba[i]->reqQ);
 
 	if (cciss_pci_init(hba[i], pdev) != 0)
 		goto clean1;
@@ -3724,15 +3708,16 @@ static void fail_all_cmds(unsigned long ctlr)
 	pci_disable_device(h->pdev);	/* Make sure it is really dead. */
 
 	/* move everything off the request queue onto the completed queue */
-	while ((c = h->reqQ) != NULL) {
-		removeQ(&(h->reqQ), c);
+	while (!list_empty(&h->reqQ)) {
+		c = list_entry(h->reqQ.next, CommandList_struct, list);
+		removeQ(c);
 		h->Qdepth--;
 		addQ(&(h->cmpQ), c);
 	}
 
 	/* Now, fail everything on the completed queue with a HW error */
-	while ((c = h->cmpQ) != NULL) {
-		removeQ(&h->cmpQ, c);
+	while (!list_empty(&h->cmpQ)) {
+		removeQ(c);
 		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
 		if (c->cmd_type == CMD_RWREQ) {
 			complete_command(h, c, 0);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 24a7efa..5a9806a 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -89,8 +89,8 @@ struct ctlr_info
 	struct access_method access;
 
 	/* queue and queue Info */ 
-	CommandList_struct *reqQ;
-	CommandList_struct  *cmpQ;
+	struct list_head reqQ;
+	struct list_head cmpQ;
 	unsigned int Qdepth;
 	unsigned int maxQsinceinit;
 	unsigned int maxSG;
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 43bf559..899cc0e 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -265,8 +265,7 @@ typedef struct _CommandList_struct {
   int			   ctlr;
   int			   cmd_type; 
   long			   cmdindex;
-  struct _CommandList_struct *prev;
-  struct _CommandList_struct *next;
+  struct list_head list;
   struct request *	   rq;
   struct completion *waiting;
   int	 retry_count;
 

-- 
Jens Axboe

