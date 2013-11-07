From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/11] hpsa: prevent stalled i/o
Date: Thu, 07 Nov 2013 10:46:10 -0600
Message-ID: <20131107164610.3504.12563.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45908 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3KGQqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:46:11 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

If a fifo full condition is encountered, i/o requests will stack
up in the h->reqQ queue.  The only thing which empties this queue
is start_io, which only gets called when new i/o requests come in.
If none are forthcoming, i/o in h->reqQ will be stalled.

To fix this, whenever fifo full condition is encountered, this
is recorded, and the interrupt handler examines this to see
if a fifo full condition was recently encountered when a
command completes and will call start_io to prevent i/o's in
h->reqQ from getting stuck.

I've only ever seen this problem occur when running specialized
test programs that pound on the the CCISS_PASSTHRU ioctl.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   32 ++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ebb7144..7256b29 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3479,9 +3479,11 @@ static void start_io(struct ctlr_info *h)
 		c = list_entry(h->reqQ.next, struct CommandList, list);
 		/* can't do anything if fifo is full */
 		if ((h->access.fifo_full(h))) {
+			h->fifo_recently_full = 1;
 			dev_warn(&h->pdev->dev, "fifo full\n");
 			break;
 		}
+		h->fifo_recently_full = 0;
 
 		/* Get the first entry from the Request Q */
 		removeQ(c);
@@ -3535,15 +3537,41 @@ static inline int bad_tag(struct ctlr_info *h, u32 tag_index,
 static inline void finish_cmd(struct CommandList *c)
 {
 	unsigned long flags;
+	int io_may_be_stalled = 0;
+	struct ctlr_info *h = c->h;
 
-	spin_lock_irqsave(&c->h->lock, flags);
+	spin_lock_irqsave(&h->lock, flags);
 	removeQ(c);
-	spin_unlock_irqrestore(&c->h->lock, flags);
+
+	/*
+	 * Check for possibly stalled i/o.
+	 *
+	 * If a fifo_full condition is encountered, requests will back up
+	 * in h->reqQ.  This queue is only emptied out by start_io which is
+	 * only called when a new i/o request comes in.  If no i/o's are
+	 * forthcoming, the i/o's in h->reqQ can get stuck.  So we call
+	 * start_io from here if we detect such a danger.
+	 *
+	 * Normally, we shouldn't hit this case, but pounding on the
+	 * CCISS_PASSTHRU ioctl can provoke it.  Only call start_io if
+	 * commands_outstanding is low.  We want to avoid calling
+	 * start_io from in here as much as possible, and esp. don't
+	 * want to get in a cycle where we call start_io every time
+	 * through here.
+	 */
+	if (unlikely(h->fifo_recently_full) &&
+		h->commands_outstanding < 5)
+		io_may_be_stalled = 1;
+
+	spin_unlock_irqrestore(&h->lock, flags);
+
 	dial_up_lockup_detection_on_fw_flash_complete(c->h, c);
 	if (likely(c->cmd_type == CMD_SCSI))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
 		complete(c->waiting);
+	if (unlikely(io_may_be_stalled))
+		start_io(h);
 }
 
 static inline u32 hpsa_tag_contains_index(u32 tag)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fd9910a..01c3283 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -137,6 +137,7 @@ struct ctlr_info {
 	u32 lockup_detected;
 	struct delayed_work monitor_ctlr_work;
 	int remove_in_progress;
+	u32 fifo_recently_full;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */

