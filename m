From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 07/27] hpsa: allow driver requested rescans
Date: Wed, 04 Nov 2015 15:50:37 -0600
Message-ID: <20151104215037.15472.7031.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53362 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:30 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by; Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   17 +++++++++++++++--
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4468166..f010b8e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1810,6 +1810,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 		 * since it didn't get added to scsi mid layer
 		 */
 		fixup_botched_add(h, added[i]);
+		h->drv_req_rescan = 1;
 	}
 
 free_and_out:
@@ -3751,9 +3752,13 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
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
@@ -3774,6 +3779,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		if (!currentsd[i]) {
 			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
 				__FILE__, __LINE__);
+			h->drv_req_rescan = 1;
 			goto out;
 		}
 		ndev_allocated++;
@@ -3801,8 +3807,10 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 
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
@@ -7862,6 +7870,11 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
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

