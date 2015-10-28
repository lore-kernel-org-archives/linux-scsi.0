From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 05/25] hpsa: allow driver requested rescans
Date: Wed, 28 Oct 2015 17:05:00 -0500
Message-ID: <20151028220500.5323.89941.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48803 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbbJ1WIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:08:46 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   17 +++++++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3fe8a18..a3f671c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1819,6 +1819,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		 * since it didn't get added to scsi mid layer
 		 */
 		fixup_botched_add(h, added[i]);
+		h->drv_req_rescan = 1;
 	}
 
 free_and_out:
@@ -3760,9 +3761,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	}
 	memset(lunzerobits, 0, sizeof(lunzerobits));
 
+	h->drv_req_rescan = 0; /* cancel scheduled rescan - we're doing it. */
+
 	if (hpsa_gather_lun_info(h, physdev_list, &nphysicals,
-			logdev_list, &nlogicals))
+			logdev_list, &nlogicals)) {
+		h->drv_req_rescan = 1;
 		goto out;
+	}
 
 	/* We might see up to the maximum number of logical and physical disks
 	 * plus external target devices, and a device for the local RAID
@@ -3783,6 +3788,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		if (!currentsd[i]) {
 			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
 				__FILE__, __LINE__);
+			h->drv_req_rescan = 1;
 			goto out;
 		}
 		ndev_allocated++;
@@ -3810,8 +3816,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 
 		/* Get device type, vendor, model, device id */
 		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
-							&is_OBDR))
+							&is_OBDR)) {
+			h->drv_req_rescan = 1;
 			continue; /* skip it if we can't talk to it. */
+		}
 		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
 		this_device = currentsd[ncurrent];
@@ -7871,6 +7879,11 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
  */
 static int hpsa_ctlr_needs_rescan(struct ctlr_info *h)
 {
+	if (h->drv_req_rescan) {
+		h->drv_req_rescan = 0;
+		return 1;
+	}
+
 	if (!(h->fw_support & MISC_FW_EVENT_NOTIFY))
 		return 0;
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index d6c4ebf..b173c0e 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -262,6 +262,7 @@ struct ctlr_info {
 	spinlock_t offline_device_lock;
 	struct list_head offline_device_list;
 	int	acciopath_status;
+	int	drv_req_rescan;
 	int	raid_offload_debug;
 	int	needs_abort_tags_swizzled;
 	struct workqueue_struct *resubmit_wq;

