From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/19] hpsa: Rearrange start_io to avoid one unlock/lock
	sequence in main io path
Date: Thu, 08 May 2014 14:28:30 -0500
Message-ID: <20140508192830.13481.28812.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31414 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaEHT3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:21 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ad73017..c6ed5ea 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -194,7 +194,8 @@ static int number_of_controllers;
 static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
 static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id);
 static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
-static void start_io(struct ctlr_info *h);
+static void lock_and_start_io(struct ctlr_info *h);
+static void start_io(struct ctlr_info *h, unsigned long *flags);
 
 #ifdef CONFIG_COMPAT
 static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
@@ -845,8 +846,8 @@ static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
+	start_io(h, &flags);
 	spin_unlock_irqrestore(&h->lock, flags);
-	start_io(h);
 }
 
 static inline void removeQ(struct CommandList *c)
@@ -5452,13 +5453,12 @@ static void __iomem *remap_pci_mem(ulong base, ulong size)
 
 /* Takes cmds off the submission queue and sends them to the hardware,
  * then puts them on the queue of cmds waiting for completion.
+ * Assumes h->lock is held
  */
-static void start_io(struct ctlr_info *h)
+static void start_io(struct ctlr_info *h, unsigned long *flags)
 {
 	struct CommandList *c;
-	unsigned long flags;
 
-	spin_lock_irqsave(&h->lock, flags);
 	while (!list_empty(&h->reqQ)) {
 		c = list_entry(h->reqQ.next, struct CommandList, list);
 		/* can't do anything if fifo is full */
@@ -5483,10 +5483,18 @@ static void start_io(struct ctlr_info *h)
 		h->commands_outstanding++;
 
 		/* Tell the controller execute command */
-		spin_unlock_irqrestore(&h->lock, flags);
+		spin_unlock_irqrestore(&h->lock, *flags);
 		h->access.submit_command(h, c);
-		spin_lock_irqsave(&h->lock, flags);
+		spin_lock_irqsave(&h->lock, *flags);
 	}
+}
+
+static void lock_and_start_io(struct ctlr_info *h)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&h->lock, flags);
+	start_io(h, &flags);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
@@ -5554,7 +5562,7 @@ static inline void finish_cmd(struct CommandList *c)
 	else if (c->cmd_type == CMD_IOCTL_PEND)
 		complete(c->waiting);
 	if (unlikely(io_may_be_stalled))
-		start_io(h);
+		lock_and_start_io(h);
 }
 
 static inline u32 hpsa_tag_contains_index(u32 tag)

