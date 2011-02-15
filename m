From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/6] hpsa: do not re-order commands in internal queues
Date: Tue, 15 Feb 2011 15:32:48 -0600
Message-ID: <20110215213248.5407.68204.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Driver's internal queues should be FIFO, not LIFO.
This is a port of an almost identical patch from cciss by Jens Axboe.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   23 +++++++++++------------
 drivers/scsi/hpsa.h     |    4 ++--
 drivers/scsi/hpsa_cmd.h |    2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 959eeb2..0f40de2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -314,9 +314,9 @@ static ssize_t host_show_commands_outstanding(struct device *dev,
 }
 
 /* Enqueuing and dequeuing functions for cmdlists. */
-static inline void addQ(struct hlist_head *list, struct CommandList *c)
+static inline void addQ(struct list_head *list, struct CommandList *c)
 {
-	hlist_add_head(&c->list, list);
+	list_add_tail(&c->list, list);
 }
 
 static inline u32 next_command(struct ctlr_info *h)
@@ -366,9 +366,9 @@ static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 
 static inline void removeQ(struct CommandList *c)
 {
-	if (WARN_ON(hlist_unhashed(&c->list)))
+	if (WARN_ON(list_empty(&c->list)))
 		return;
-	hlist_del_init(&c->list);
+	list_del_init(&c->list);
 }
 
 static inline int is_hba_lunid(unsigned char scsi3addr[])
@@ -2228,7 +2228,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 
 	c->cmdindex = i;
 
-	INIT_HLIST_NODE(&c->list);
+	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (u32) cmd_dma_handle;
 	temp64.val = (u64) err_dma_handle;
 	c->ErrDesc.Addr.lower = temp64.val32.lower;
@@ -2266,7 +2266,7 @@ static struct CommandList *cmd_special_alloc(struct ctlr_info *h)
 	}
 	memset(c->err_info, 0, sizeof(*c->err_info));
 
-	INIT_HLIST_NODE(&c->list);
+	INIT_LIST_HEAD(&c->list);
 	c->busaddr = (u32) cmd_dma_handle;
 	temp64.val = (u64) err_dma_handle;
 	c->ErrDesc.Addr.lower = temp64.val32.lower;
@@ -2837,8 +2837,8 @@ static void start_io(struct ctlr_info *h)
 {
 	struct CommandList *c;
 
-	while (!hlist_empty(&h->reqQ)) {
-		c = hlist_entry(h->reqQ.first, struct CommandList, list);
+	while (!list_empty(&h->reqQ)) {
+		c = list_entry(h->reqQ.next, struct CommandList, list);
 		/* can't do anything if fifo is full */
 		if ((h->access.fifo_full(h))) {
 			dev_warn(&h->pdev->dev, "fifo full\n");
@@ -2929,10 +2929,9 @@ static inline u32 process_nonindexed_cmd(struct ctlr_info *h,
 {
 	u32 tag;
 	struct CommandList *c = NULL;
-	struct hlist_node *tmp;
 
 	tag = hpsa_tag_discard_error_bits(raw_tag);
-	hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
+	list_for_each_entry(c, &h->cmpQ, list) {
 		if ((c->busaddr & 0xFFFFFFE0) == (tag & 0xFFFFFFE0)) {
 			finish_cmd(c, raw_tag);
 			return next_command(h);
@@ -3761,8 +3760,8 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 
 	h->pdev = pdev;
 	h->busy_initializing = 1;
-	INIT_HLIST_HEAD(&h->cmpQ);
-	INIT_HLIST_HEAD(&h->reqQ);
+	INIT_LIST_HEAD(&h->cmpQ);
+	INIT_LIST_HEAD(&h->reqQ);
 	spin_lock_init(&h->lock);
 	spin_lock_init(&h->scan_lock);
 	rc = hpsa_pci_init(h);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 074d237..e898193 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -75,8 +75,8 @@ struct ctlr_info {
 	struct access_method access;
 
 	/* queue and queue Info */
-	struct hlist_head reqQ;
-	struct hlist_head cmpQ;
+	struct list_head reqQ;
+	struct list_head cmpQ;
 	unsigned int Qdepth;
 	unsigned int maxQsinceinit;
 	unsigned int maxSG;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 7910c14..785abdd 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -292,7 +292,7 @@ struct CommandList {
 	struct ctlr_info	   *h;
 	int			   cmd_type;
 	long			   cmdindex;
-	struct hlist_node list;
+	struct list_head list;
 	struct request *rq;
 	struct completion *waiting;
 	void   *scsi_cmd;
