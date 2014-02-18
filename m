From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 23/35] hpsa: rescan devices on ioaccel2 error
Date: Tue, 18 Feb 2014 13:57:05 -0600
Message-ID: <20140218195705.15787.87376.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57080 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBRT6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:32 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 25D3E1246
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:25 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Allow driver to schedule a rescan whenever a request fails on the ioaccel2 path.
This eliminates the possibility of driver getting stuck in non-ioaccel mode.

IOaccel mode (HP SSD Smart Path) is disabled by driver upon error detection.
Driver relied on idea that request would be retried through normal path, and
a subsequent error would occur on that path, and be processed by controller firmware.
As part of that process, controller disables ioaccel mode and later reinstates it,
signalling driver to change modes.

In some error cases, the error will not duplicate on the standard path,
so the driver could get stuck in non-ioaccel mode.
To avoid that, we allow driver to request a rescan during the next run of the
rescan thread.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   12 ++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 295c5da..76e7ae9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1457,6 +1457,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 				"%s: Error 0x%02x, Retrying on standard path.\n",
 				"HP SSD Smart Path", c2->error_data.status);
 		dev->offload_enabled = 0;
+		h->drv_req_rescan = 1;	/* schedule controller for a rescan */
 		cmd->result = DID_SOFT_ERROR << 16;
 		cmd_free(h, c);
 		cmd->scsi_done(cmd);
@@ -6135,6 +6136,9 @@ static int hpsa_kickoff_rescan(struct ctlr_info *h)
 	int i;
 	char *event_type;
 
+	/* Clear the driver-requested rescan flag */
+	h->drv_req_rescan = 0;
+
 	/* Ask the controller to clear the events we're handling. */
 	if ((h->transMethod & (CFGTBL_Trans_io_accel1
 			| CFGTBL_Trans_io_accel2)) &&
@@ -6182,7 +6186,9 @@ static int hpsa_kickoff_rescan(struct ctlr_info *h)
 
 /* Check a register on the controller to see if there are configuration
  * changes (added/changed/removed logical drives, etc.) which mean that
- * we should rescan the controller for devices.  If so, add the controller
+ * we should rescan the controller for devices.
+ * Also check flag for driver-initiated rescan.
+ * If either flag or controller event indicate rescan, add the controller
  * to the list of controllers needing to be rescanned, and gets a
  * reference to the associated scsi_host.
  */
@@ -6192,7 +6198,7 @@ static void hpsa_ctlr_needs_rescan(struct ctlr_info *h)
 		return;
 
 	h->events = readl(&(h->cfgtable->event_notify));
-	if (!h->events)
+	if (!h->events && !h->drv_req_rescan)
 		return;
 
 	/*
@@ -6366,6 +6372,8 @@ reinit_after_soft_reset:
 	/* Enable Accelerated IO path at driver layer */
 	h->acciopath_status = 1;
 
+	h->drv_req_rescan = 0;
+
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1d3340d..2e7521f 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -182,6 +182,7 @@ struct ctlr_info {
 #define HPSATMF_LOG_QRY_ASYNC   (1 << 25)
 	u32 events;
 	int	acciopath_status;
+	int	drv_req_rescan;	/* flag for driver to request rescan event */
 };
 #define HPSA_ABORT_MSG 0
 #define HPSA_DEVICE_RESET_MSG 1

