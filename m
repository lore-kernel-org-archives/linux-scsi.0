From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/41] hpsa: do not rescan controllers known to be locked up
Date: Wed, 15 Jan 2014 16:37:40 -0600
Message-ID: <20140115223740.5061.51489.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9372 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaAOVhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:41 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

* Do not check event bits on locked up controllers to
  see if they need to be rescanned.
* Do not initiate any device rescans on controllers
  which are known to be locked up.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1383169..f88bb73 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2875,11 +2875,38 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 
 static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
 
+static int do_not_scan_if_controller_locked_up(struct ctlr_info *h)
+{
+	unsigned long flags;
+
+	/*
+	 * Don't let rescans be initiated on a controller known
+	 * to be locked up.  If the controller locks up *during*
+	 * a rescan, that thread is probably hosed, but at least
+	 * we can prevent new rescan threads from piling up on a
+	 * locked up controller.
+	 */
+	spin_lock_irqsave(&h->lock, flags);
+	if (unlikely(h->lockup_detected)) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		spin_lock_irqsave(&h->scan_lock, flags);
+		h->scan_finished = 1;
+		wake_up_all(&h->scan_wait_queue);
+		spin_unlock_irqrestore(&h->scan_lock, flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(&h->lock, flags);
+	return 0;
+}
+
 static void hpsa_scan_start(struct Scsi_Host *sh)
 {
 	struct ctlr_info *h = shost_to_hba(sh);
 	unsigned long flags;
 
+	if (do_not_scan_if_controller_locked_up(h))
+		return;
+
 	/* wait until any scan already in progress is finished. */
 	while (1) {
 		spin_lock_irqsave(&h->scan_lock, flags);
@@ -2896,6 +2923,9 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	h->scan_finished = 0; /* mark scan as in progress */
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 
+	if (do_not_scan_if_controller_locked_up(h))
+		return;
+
 	hpsa_update_scsi_devices(h, h->scsi_host->host_no);
 
 	spin_lock_irqsave(&h->scan_lock, flags);
@@ -5389,7 +5419,7 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
-static void detect_controller_lockup(struct ctlr_info *h)
+static int detect_controller_lockup(struct ctlr_info *h)
 {
 	u64 now;
 	u32 heartbeat;
@@ -5399,7 +5429,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	/* If we've received an interrupt recently, we're ok. */
 	if (time_after64(h->last_intr_timestamp +
 				(h->heartbeat_sample_interval), now))
-		return;
+		return 0;
 
 	/*
 	 * If we've already checked the heartbeat recently, we're ok.
@@ -5408,7 +5438,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	 */
 	if (time_after64(h->last_heartbeat_timestamp +
 				(h->heartbeat_sample_interval), now))
-		return;
+		return 0;
 
 	/* If heartbeat has not changed since we last looked, we're not ok. */
 	spin_lock_irqsave(&h->lock, flags);
@@ -5416,12 +5446,13 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (h->last_heartbeat == heartbeat) {
 		controller_lockup_detected(h);
-		return;
+		return 1;
 	}
 
 	/* We're ok. */
 	h->last_heartbeat = heartbeat;
 	h->last_heartbeat_timestamp = now;
+	return 0;
 }
 
 static int hpsa_kickoff_rescan(struct ctlr_info *h)

