From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/19] hpsa: avoid unnecessary readl on every command
	submission
Date: Thu, 08 May 2014 14:28:25 -0500
Message-ID: <20140508192825.13481.65829.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44132 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaEHT3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:15 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: root <root@rhel6u2e-s1.ldev.net>

for controllers which support either of the ioaccel transport methods.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 drivers/scsi/hpsa.h |   15 ++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index acb88e5..ad73017 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7323,6 +7323,13 @@ static void hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 	 * 10 = 6 s/g entry or 24k
 	 */
 
+	/* If the controller supports either ioaccel method then
+	 * we can also use the RAID stack submit path that does not
+	 * perform the superfluous readl() after each command submission.
+	 */
+	if (trans_support & (CFGTBL_Trans_io_accel1 | CFGTBL_Trans_io_accel2))
+		access = SA5_performant_access_no_read;
+
 	/* Controller spec: zero out this buffer. */
 	for (i = 0; i < h->nreply_queues; i++)
 		memset(h->reply_queue[i].head, 0, h->reply_queue_size);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 8e8310e..1855469 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -345,6 +345,12 @@ static void SA5_submit_command(struct ctlr_info *h,
 	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 }
 
+static void SA5_submit_command_no_read(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+}
+
 static void SA5_submit_command_ioaccel2(struct ctlr_info *h,
 	struct CommandList *c)
 {
@@ -352,7 +358,6 @@ static void SA5_submit_command_ioaccel2(struct ctlr_info *h,
 		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
 	else
 		writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
-	(void) readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 }
 
 /*
@@ -563,6 +568,14 @@ static struct access_method SA5_performant_access = {
 	SA5_performant_completed,
 };
 
+static struct access_method SA5_performant_access_no_read = {
+	SA5_submit_command_no_read,
+	SA5_performant_intr_mask,
+	SA5_fifo_full,
+	SA5_performant_intr_pending,
+	SA5_performant_completed,
+};
+
 struct board_type {
 	u32	board_id;
 	char	*product_name;

