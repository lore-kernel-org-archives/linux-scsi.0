From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 37/48] hpsa: check for ctlr lockup after command
 allocation in main io path
Date: Fri, 23 Jan 2015 16:44:19 -0600
Message-ID: <20150123224419.14919.79108.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30952 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbAWWpN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:13 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Command allocation is the thing that takes the longest in the main i/o
path, so check for controller lockup immediately after this to prevent
submitting commands to locked up controller as much as possible.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 03fae8a..834ac78 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4097,8 +4097,15 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
+	if (unlikely(lockup_detected(h))) {
+		cmd->result = DID_ERROR << 16;
+		cmd_free(h, c);
+		cmd->scsi_done(cmd);
+		return 0;
+	}
 
-	/* Call alternate submit routine for I/O accelerated commands.
+	/*
+	 * Call alternate submit routine for I/O accelerated commands.
 	 * Retries always go down the normal I/O path.
 	 */
 	if (likely(cmd->retries == 0 &&

