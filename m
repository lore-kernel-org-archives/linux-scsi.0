From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/5] hpsa: Return SCSI_MLQUEUE_HOST_BUSY on command allocation
	failure.
Date: Tue, 08 Dec 2009 15:38:22 -0600
Message-ID: <20091208213822.23493.376.stgit@beardog.cce.hp.com>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30447 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966324AbZLHVgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 16:36:25 -0500
In-Reply-To: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa:  Return SCSI_MLQUEUE_HOST_BUSY on command allocation failure.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8b8ddfc..0e696ee 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1842,9 +1842,7 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
-		cmd->result = DID_NO_CONNECT << 16;
-		done(cmd);
-		return 0;
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Fill in the command list header */

