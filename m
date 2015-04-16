From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 24/43] hpsa: clean up some error reporting output in
 abort handler
Date: Thu, 16 Apr 2015 08:48:54 -0500
Message-ID: <20150416134853.30238.53473.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:34005 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681AbbDPNtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:49:55 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c7a5655..15c5b81 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5110,10 +5110,10 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 
 	memset(msg, 0, sizeof(msg));
-	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu %s",
+	ml += sprintf(msg+ml, "scsi %d:%d:%d:%llu %s %p",
 		h->scsi_host->host_no, sc->device->channel,
 		sc->device->id, sc->device->lun,
-		"Aborting command");
+		"Aborting command", sc);
 
 	/* Find the device of the command to be aborted */
 	dev = sc->device->hostdata;
@@ -5147,12 +5147,12 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
 	as  = abort->scsi_cmd;
 	if (as != NULL)
-		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
-			as->cmnd[0], as->serial_number);
-	dev_dbg(&h->pdev->dev, "%s\n", msg);
-	dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
-		h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
-		"Aborting command");
+		ml += sprintf(msg+ml,
+			"CDBLen: %d CDB: 0x%02x%02x... SN: 0x%lx ",
+			as->cmd_len, as->cmnd[0], as->cmnd[1],
+			as->serial_number);
+	dev_warn(&h->pdev->dev, "%s BEING SENT\n", msg);
+
 	/*
 	 * Command is in flight, or possibly already completed
 	 * by the firmware (but not to the scsi mid layer) but we can't
@@ -5160,7 +5160,8 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 */
 	if (wait_for_available_abort_cmd(h)) {
 		dev_warn(&h->pdev->dev,
-			"Timed out waiting for an abort command to become available.\n");
+			"%s FAILED, timeout waiting for an abort command to become available.\n",
+			msg);
 		cmd_free(h, abort);
 		return FAILED;
 	}
@@ -5168,16 +5169,14 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	atomic_inc(&h->abort_cmds_available);
 	wake_up_all(&h->abort_cmd_wait_queue);
 	if (rc != 0) {
-		dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
-			h->scsi_host->host_no,
-			dev->bus, dev->target, dev->lun,
-			"FAILED to abort command");
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

