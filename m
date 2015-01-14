From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 25/48] hpsa: do not request device rescan on every ioaccel
 path error
Date: Wed, 14 Jan 2015 16:01:50 -0600
Message-ID: <20150114220149.21325.3404.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37375 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbbANWCg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:02:36 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

The original reasoning behind doing this was faulty.  An error
of some sort would be encountered, accelerated i/o would be
disabled for that logical drive, the command would be kicked
back out to the SCSI midlayer for a retry, and since i/o accelerator
mode was disabled, it would get retried down the RAID path.
However, something needs to turn ioaccellerator mode back on,
and this rescan request was what did that.  However, it was racy,
and extremely bad for performance to rescan all devices, so,
don't do that.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   14 ++------------
 drivers/scsi/hpsa.h |    1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 70f07af..94a82e3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1637,21 +1637,19 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
 		dev->offload_enabled = 0;
-		h->drv_req_rescan = 1;	/* schedule controller for a rescan */
 		cmd->result = DID_SOFT_ERROR << 16;
 		cmd_free(h, c);
 		cmd->scsi_done(cmd);
 		return;
 	}
 	raid_retry = handle_ioaccel_mode2_error(h, c, cmd, c2);
-	/* If error found, disable Smart Path, schedule a rescan,
-	 * and force a retry on the standard path.
+	/* If error found, disable Smart Path,
+	 * force a retry on the standard path.
 	 */
 	if (raid_retry) {
 		dev_warn(&h->pdev->dev, "%s: Retrying on standard path.\n",
 			"HP SSD Smart Path");
 		dev->offload_enabled = 0; /* Disable Smart Path */
-		h->drv_req_rescan = 1;	  /* schedule controller rescan */
 		cmd->result = DID_SOFT_ERROR << 16;
 	}
 	cmd_free(h, c);
@@ -6478,9 +6476,6 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
 	int i;
 	char *event_type;
 
-	/* Clear the driver-requested rescan flag */
-	h->drv_req_rescan = 0;
-
 	/* Ask the controller to clear the events we're handling. */
 	if ((h->transMethod & (CFGTBL_Trans_io_accel1
 			| CFGTBL_Trans_io_accel2)) &&
@@ -6526,9 +6521,6 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
  */
 static int hpsa_ctlr_needs_rescan(struct ctlr_info *h)
 {
-	if (h->drv_req_rescan)
-		return 1;
-
 	if (!(h->fw_support & MISC_FW_EVENT_NOTIFY))
 		return 0;
 
@@ -6574,7 +6566,6 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 
 	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
 		scsi_host_get(h->scsi_host);
-		h->drv_req_rescan = 0;
 		hpsa_ack_ctlr_events(h);
 		hpsa_scan_start(h->scsi_host);
 		scsi_host_put(h->scsi_host);
@@ -6743,7 +6734,6 @@ reinit_after_soft_reset:
 		/* Enable Accelerated IO path at driver layer */
 		h->acciopath_status = 1;
 
-	h->drv_req_rescan = 0;
 
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index e7d7eaa..06a3e81 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -235,7 +235,6 @@ struct ctlr_info {
 	spinlock_t offline_device_lock;
 	struct list_head offline_device_list;
 	int	acciopath_status;
-	int	drv_req_rescan;	/* flag for driver to request rescan event */
 	int	raid_offload_debug;
 };
 

