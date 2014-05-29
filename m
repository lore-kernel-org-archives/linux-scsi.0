From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 12/24] hpsa: avoid unnecessary readl on every command
	submission
Date: Thu, 29 May 2014 10:53:23 -0500
Message-ID: <20140529155323.8180.77181.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37892 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934314AbaE2PzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:15 -0400
Received: from g5t1626.atlanta.hp.com (g5t1626.atlanta.hp.com [15.192.137.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 86FDC60CAF
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:55:15 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

for controllers which support either of the ioaccel transport methods.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
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

