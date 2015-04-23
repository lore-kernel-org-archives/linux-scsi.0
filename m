From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 24/42] hpsa: clean up some error reporting output in
 abort handler
Date: Thu, 23 Apr 2015 09:33:54 -0500
Message-ID: <20150423143354.18832.78447.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46905 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966081AbbDWOfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:35:03 -0400
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 341B9631F0
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 14:35:03 +0000 (UTC)
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

report more useful information on aborts

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index df2c825..224fc48 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5102,10 +5102,10 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu %s",
+	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu %s %p",
 		h->scsi_host->host_no, sc->device->channel,
 		sc->device->id, sc->device->lun,
-		"Aborting command");
+		"Aborting command", sc);
 
 	/* Get SCSI command to be aborted */
 	abort = (struct CommandList *) sc->host_scribble;
@@ -5131,10 +5131,13 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
 	as  = abort->scsi_cmd;
 	if (as != NULL)
-		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
-			as->cmnd[0], as->serial_number);
-	dev_dbg(&h->pdev->dev, "%s\n", msg);
+		ml += sprintf(msg+ml,
+			"CDBLen: %d CDB: 0x%02x%02x... SN: 0x%lx ",
+			as->cmd_len, as->cmnd[0], as->cmnd[1],
+			as->serial_number);
+	dev_warn(&h->pdev->dev, "%s BEING SENT\n", msg);
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, "Aborting command");
+
 	/*
 	 * Command is in flight, or possibly already completed
 	 * by the firmware (but not to the scsi mid layer) but we can't
@@ -5142,7 +5145,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 	if (wait_for_available_abort_cmd(h)) {
 		dev_warn(&h->pdev->dev,
-			"Timed out waiting for an abort command to become available.\n");
+			"%s FAILED, timeout waiting for an abort command to become available.\n",
+			msg);
 		cmd_free(h, abort);
 		return FAILED;
 	}
@@ -5150,14 +5154,16 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	atomic_inc(&h->abort_cmds_available);
 	wake_up_all(&h->abort_cmd_wait_queue);
 	if (rc != 0) {
+		dev_warn(&h->pdev->dev, "%s SENT, FAILED\n", msg);
 		hpsa_show_dev_msg(KERN_WARNING, h, dev,
-					"FAILED to abort command");
+				"FAILED to abort command");
 		cmd_free(h, abort);
 		return FAILED;
 	}
-	dev_info(&h->pdev->dev, "%s REQUEST SUCCEEDED.\n", msg);
+	dev_info(&h->pdev->dev, "%s SENT, SUCCESS\n", msg);
 
-	/* If the abort(s) above completed and actually aborted the
+	/*
+	 * If the abort(s) above completed and actually aborted the
 	 * command, then the command to be aborted should already be
 	 * completed.  If not, wait around a bit more to see if they
 	 * manage to complete normally.

