From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/17] hpsa: do aborts two ways
Date: Tue, 01 May 2012 11:42:56 -0500
Message-ID: <20120501164256.11705.10285.stgit@beardog.cce.hp.com>
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

When aborting a command, the tag is supposed to be
specified as 64-bit little endian.  However, some smart
arrays expect the tag of the command to be aborted to be
specified in a strange byte order.  How to tell which sort
of Smart Array firmware we're dealing with is not obvious.
However, because of the way we construct our tags, the values
of any outstanding tag when specified with the "strange" byte
order will not collide with the value specified in the correct
order.  That means we can safely attempt the abort both ways.

Signed-off-by: Stephen M. Cameron <stephenmcameron@gmail.com>
---
 drivers/scsi/hpsa.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index abf5c7e..3eda5f7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2355,8 +2355,23 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	return FAILED;
 }
 
+static void swizzle_abort_tag(u8 *tag)
+{
+	u8 original_tag[8];
+
+	memcpy(original_tag, tag, 8);
+	tag[0] = original_tag[3];
+	tag[1] = original_tag[2];
+	tag[2] = original_tag[1];
+	tag[3] = original_tag[0];
+	tag[4] = original_tag[7];
+	tag[5] = original_tag[6];
+	tag[6] = original_tag[5];
+	tag[7] = original_tag[4];
+}
+
 static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
-	struct CommandList *abort)
+	struct CommandList *abort, int swizzle)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
@@ -2369,6 +2384,8 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	}
 
 	fill_cmd(c, HPSA_ABORT_MSG, h, abort, 0, 0, scsi3addr, TYPE_MSG);
+	if (swizzle)
+		swizzle_abort_tag(&c->Request.CDB[4]);
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd_core completed.\n",
 		__func__, abort->Header.Tag.upper, abort->Header.Tag.lower);
@@ -2428,6 +2445,59 @@ static struct CommandList *hpsa_find_cmd_in_queue(struct ctlr_info *h,
 	return NULL;
 }
 
+static struct CommandList *hpsa_find_cmd_in_queue_by_tag(struct ctlr_info *h,
+					u8 *tag, struct list_head *queue_head)
+{
+	unsigned long flags;
+	struct CommandList *c;
+
+	spin_lock_irqsave(&h->lock, flags);
+	list_for_each_entry(c, queue_head, list) {
+		if (memcmp(&c->Header.Tag, tag, 8) != 0)
+			continue;
+		spin_unlock_irqrestore(&h->lock, flags);
+		return c;
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+	return NULL;
+}
+
+/* Some Smart Arrays need the abort tag swizzled, and some don't.  It's hard to
+ * tell which kind we're dealing with, so we send the abort both ways.  There
+ * shouldn't be any collisions between swizzled and unswizzled tags due to the
+ * way we construct our tags but we check anyway in case the assumptions which
+ * make this true someday become false.
+ */
+static int hpsa_send_abort_both_ways(struct ctlr_info *h,
+	unsigned char *scsi3addr, struct CommandList *abort)
+{
+	u8 swizzled_tag[8];
+	struct CommandList *c;
+	int rc = 0, rc2 = 0;
+
+	/* we do not expect to find the swizzled tag in our queue, but
+	 * check anyway just to be sure the assumptions which make this
+	 * the case haven't become wrong.
+	 */
+	memcpy(swizzled_tag, &abort->Request.CDB[4], 8);
+	swizzle_abort_tag(swizzled_tag);
+	c = hpsa_find_cmd_in_queue_by_tag(h, swizzled_tag, &h->cmpQ);
+	if (c != NULL) {
+		dev_warn(&h->pdev->dev, "Unexpectedly found byte-swapped tag in completion queue.\n");
+		return hpsa_send_abort(h, scsi3addr, abort, 0);
+	}
+	rc = hpsa_send_abort(h, scsi3addr, abort, 0);
+
+	/* if the command is still in our queue, we can't conclude that it was
+	 * aborted (it might have just completed normally) but in any case
+	 * we don't need to try to abort it another way.
+	 */
+	c = hpsa_find_cmd_in_queue(h, abort->scsi_cmd, &h->cmpQ);
+	if (c)
+		rc2 = hpsa_send_abort(h, scsi3addr, abort, 1);
+	return rc && rc2;
+}
+
 /* Send an abort for the specified command.
  *	If the device and controller support it,
  *		send a task abort request.
@@ -2512,7 +2582,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 * by the firmware (but not to the scsi mid layer) but we can't
 	 * distinguish which.  Send the abort down.
 	 */
-	rc = hpsa_send_abort(h, dev->scsi3addr, abort);
+	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort);
 	if (rc != 0) {
 		dev_dbg(&h->pdev->dev, "%s Request FAILED.\n", msg);
 		dev_warn(&h->pdev->dev, "FAILED abort on device C%d:B%d:T%d:L%d\n",
