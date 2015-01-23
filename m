From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 41/48] hpsa: do not use function pointers in fast path
 command submission
Date: Fri, 23 Jan 2015 16:44:40 -0600
Message-ID: <20150123224440.14919.5776.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40458 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbAWWpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:34 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Performance tweak, avoid unnecessary function calls.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    8 +++++---
 drivers/scsi/hpsa.h |    5 +----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 18bcba9..a23277d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -821,19 +821,21 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
 static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c)
 {
+	dial_down_lockup_detection_during_fw_flash(h, c);
+	atomic_inc(&h->commands_outstanding);
 	switch (c->cmd_type) {
 	case CMD_IOACCEL1:
 		set_ioaccel1_performant_mode(h, c);
+		writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 		break;
 	case CMD_IOACCEL2:
 		set_ioaccel2_performant_mode(h, c);
+		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
 		break;
 	default:
 		set_performant_mode(h, c);
+		h->access.submit_command(h, c);
 	}
-	dial_down_lockup_detection_during_fw_flash(h, c);
-	atomic_inc(&h->commands_outstanding);
-	h->access.submit_command(h, c);
 }
 
 static inline int is_hba_lunid(unsigned char scsi3addr[])
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 239ecea..62c50c3 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -367,10 +367,7 @@ static void SA5_submit_command_no_read(struct ctlr_info *h,
 static void SA5_submit_command_ioaccel2(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	if (c->cmd_type == CMD_IOACCEL2)
-		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
-	else
-		writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
+	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 }
 
 /*

