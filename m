From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 44/48] hpsa: refactor duplicated scan completion code into a
 new routine
Date: Wed, 14 Jan 2015 16:03:30 -0600
Message-ID: <20150114220330.21325.24802.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:38509 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbbANWEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:04:16 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Hoist the conditional out of do_not_scan_if_controller_locked_up() and
place it in the caller (this improves the code structure, making it
more consistent with other uses and enabling tail-call optimization);
rename the function to hpsa_scan_complete(), and use it at the end of
hpsa_scan_start() as well.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7915dc4..a92653a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4149,25 +4149,14 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	return hpsa_ciss_submit(h, c, cmd, scsi3addr);
 }
 
-static int do_not_scan_if_controller_locked_up(struct ctlr_info *h)
+static void hpsa_scan_complete(struct ctlr_info *h)
 {
 	unsigned long flags;
 
-	/*
-	 * Don't let rescans be initiated on a controller known
-	 * to be locked up.  If the controller locks up *during*
-	 * a rescan, that thread is probably hosed, but at least
-	 * we can prevent new rescan threads from piling up on a
-	 * locked up controller.
-	 */
-	if (unlikely(lockup_detected(h))) {
-		spin_lock_irqsave(&h->scan_lock, flags);
-		h->scan_finished = 1;
-		wake_up_all(&h->scan_wait_queue);
-		spin_unlock_irqrestore(&h->scan_lock, flags);
-		return 1;
-	}
-	return 0;
+	spin_lock_irqsave(&h->scan_lock, flags);
+	h->scan_finished = 1;
+	wake_up_all(&h->scan_wait_queue);
+	spin_unlock_irqrestore(&h->scan_lock, flags);
 }
 
 static void hpsa_scan_start(struct Scsi_Host *sh)
@@ -4175,8 +4164,14 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	struct ctlr_info *h = shost_to_hba(sh);
 	unsigned long flags;
 
-	if (do_not_scan_if_controller_locked_up(h))
-		return;
+	/*
+	 * Don't let rescans be initiated on a controller known to be locked
+	 * up.  If the controller locks up *during* a rescan, that thread is
+	 * probably hosed, but at least we can prevent new rescan threads from
+	 * piling up on a locked up controller.
+	 */
+	if (unlikely(lockup_detected(h)))
+		return hpsa_scan_complete(h);
 
 	/* wait until any scan already in progress is finished. */
 	while (1) {
@@ -4194,15 +4189,12 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	h->scan_finished = 0; /* mark scan as in progress */
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 
-	if (do_not_scan_if_controller_locked_up(h))
-		return;
+	if (unlikely(lockup_detected(h)))
+		return hpsa_scan_complete(h);
 
 	hpsa_update_scsi_devices(h, h->scsi_host->host_no);
 
-	spin_lock_irqsave(&h->scan_lock, flags);
-	h->scan_finished = 1; /* mark scan as finished. */
-	wake_up_all(&h->scan_wait_queue);
-	spin_unlock_irqrestore(&h->scan_lock, flags);
+	hpsa_scan_complete(h);
 }
 
 static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth)

