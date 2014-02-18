From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/35] hpsa: fix task management for mode-1 ioaccell path
Date: Tue, 18 Feb 2014 13:55:28 -0600
Message-ID: <20140218195528.15787.6639.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:56798 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaBRT45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:56:57 -0500
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 00F561C45
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:56:47 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

For "mode 1" io accelerated commands, the command tag is in
a different location than for commands that go down the normal
RAID path, so the abort handler needs to take this into account.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Mike Miller <michael.miller@canonical.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f1ebb8c..0377692 100644
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

