From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/35] hpsa: do not rescan controllers known to be locked up
Date: Tue, 18 Feb 2014 13:55:48 -0600
Message-ID: <20140218195548.15787.12023.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43511 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaBRT5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:08 -0500
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 5B94C60962
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:57:08 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

* Do not check event bits on locked up controllers to
  see if they need to be rescanned.
* Do not initiate any device rescans on controllers
  which are known to be locked up.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b34a355..f882b18 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2868,11 +2868,38 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 
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
@@ -2889,6 +2916,9 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	h->scan_finished = 0; /* mark scan as in progress */
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 
+	if (do_not_scan_if_controller_locked_up(h))
+		return;
+
 	hpsa_update_scsi_devices(h, h->scsi_host->host_no);
 
 	spin_lock_irqsave(&h->scan_lock, flags);

