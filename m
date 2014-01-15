From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/41] hpsa: fix task management for mode-1 ioaccell path
Date: Wed, 15 Jan 2014 16:37:19 -0600
Message-ID: <20140115223719.5061.13462.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40379 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaAOVhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:20 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

For "mode 1" io accelerated commands, the command tag is in
a different location than for commands that go down the normal
RAID path, so the abort handler needs to take this into account.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81545a7..9b4f5ff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2602,12 +2602,27 @@ static void swizzle_abort_tag(u8 *tag)
 	tag[7] = original_tag[4];
 }
 
+static void hpsa_get_tag(struct ctlr_info *h,
+	struct CommandList *c, u32 *taglower, u32 *tagupper)
+{
+	if (c->cmd_type == CMD_IOACCEL1) {
+		struct io_accel1_cmd *cm1 = (struct io_accel1_cmd *)
+			&h->ioaccel_cmd_pool[c->cmdindex];
+		*tagupper = cm1->Tag.upper;
+		*taglower = cm1->Tag.lower;
+	} else {
+		*tagupper = c->Header.Tag.upper;
+		*taglower = c->Header.Tag.lower;
+	}
+}
+
 static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	struct CommandList *abort, int swizzle)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
 	struct ErrorInfo *ei;
+	u32 tagupper, taglower;
 
 	c = cmd_special_alloc(h);
 	if (c == NULL) {	/* trouble... */
@@ -2621,8 +2636,9 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	if (swizzle)
 		swizzle_abort_tag(&c->Request.CDB[4]);
 	hpsa_scsi_do_simple_cmd_core(h, c);
+	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd_core completed.\n",
-		__func__, abort->Header.Tag.upper, abort->Header.Tag.lower);
+		__func__, tagupper, taglower);
 	/* no unmap needed here because no data xfer. */
 
 	ei = c->err_info;
@@ -2634,8 +2650,7 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 		break;
 	default:
 		dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: interpreting error.\n",
-			__func__, abort->Header.Tag.upper,
-			abort->Header.Tag.lower);
+			__func__, tagupper, taglower);
 		hpsa_scsi_interpret_error(c);
 		rc = -1;
 		break;
@@ -2747,6 +2762,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	struct scsi_cmnd *as;	/* ptr to scsi cmd inside aborted command. */
 	char msg[256];		/* For debug messaging. */
 	int ml = 0;
+	u32 tagupper, taglower;
 
 	/* Find the controller of the command to be aborted */
 	h = sdev_to_hba(sc->device);
@@ -2779,9 +2795,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 				msg);
 		return FAILED;
 	}
-
-	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ",
-		abort->Header.Tag.upper, abort->Header.Tag.lower);
+	hpsa_get_tag(h, abort, &taglower, &tagupper);
+	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
 	as  = (struct scsi_cmnd *) abort->scsi_cmd;
 	if (as != NULL)
 		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",

