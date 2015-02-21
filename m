From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 24/43] hpsa: clean up some error reporting output in abort
 handler
Date: Sat, 21 Feb 2015 16:19:40 -0600
Message-ID: <20150221221940.21954.16937.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49424 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBUWU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:58 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

report more useful information on aborts

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e76fa03..4641cc8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5155,9 +5155,9 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "Aborting command on scsi %d:%d:%d:%llu ",
+	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu scmd %p ABORT ",
 		h->scsi_host->host_no, sc->device->channel,
-		sc->device->id, sc->device->lun);
+		sc->device->id, sc->device->lun, sc);
 
 	/* Find the device of the command to be aborted */
 	dev = sc->device->hostdata;
@@ -5191,11 +5191,12 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
 	as  = abort->scsi_cmd;
 	if (as != NULL)
-		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
-			as->cmnd[0], as->serial_number);
-	dev_dbg(&h->pdev->dev, "%s\n", msg);
-	dev_warn(&h->pdev->dev, "Aborting command on scsi %d:%d:%d:%d\n",
-		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
+		ml += sprintf(msg+ml,
+			"CDBLen: %d CDB: 0x%02x%02x... SN: 0x%lx ",
+			as->cmd_len, as->cmnd[0], as->cmnd[1],
+			as->serial_number);
+	dev_warn(&h->pdev->dev, "%s BEING SENT\n", msg);
+
 	/*
 	 * Command is in flight, or possibly already completed
 	 * by the firmware (but not to the scsi mid layer) but we can't
@@ -5203,7 +5204,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 	if (wait_for_available_abort_cmd(h)) {
 		dev_warn(&h->pdev->dev,
-			"Timed out waiting for an abort command to become available.\n");
+			"%s FAILED, timeout waiting for an abort command to become available.\n",
+			msg);
 		cmd_free(h, abort);
 		return FAILED;
 	}
@@ -5211,15 +5213,14 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	atomic_inc(&h->abort_cmds_available);
 	wake_up_all(&h->abort_cmd_wait_queue);
 	if (rc != 0) {
-		dev_warn(&h->pdev->dev, "FAILED abort command on scsi %d:%d:%d:%d\n",
-			h->scsi_host->host_no,
-			dev->bus, dev->target, dev->lun);
+		dev_warn(&h->pdev->dev, "%s SENT, FAILED\n", msg);
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

