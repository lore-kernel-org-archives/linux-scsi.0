From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] hpsa: consolidate status variables
Date: Tue,  8 Aug 2017 10:35:10 +0200
Message-ID: <1502181315-102499-2-git-send-email-hare@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51875 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751464AbdHHIfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:18 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Consolidate several boolean variable into one field.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1c49741..bd16f38 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -246,7 +246,6 @@ struct ctlr_info {
 	struct delayed_work monitor_ctlr_work;
 	struct delayed_work rescan_ctlr_work;
 	struct delayed_work event_monitor_work;
-	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
 	char intrname[MAX_REPLY_QUEUES][16];	/* "hpsa0-msix00" names */
@@ -289,18 +288,19 @@ struct ctlr_info {
 		CTLR_STATE_CHANGE_EVENT_AIO_CONFIG_CHANGE)
 	spinlock_t offline_device_lock;
 	struct list_head offline_device_list;
-	int	acciopath_status;
-	int	drv_req_rescan;
+	unsigned int acciopath_status:1;
+	unsigned int drv_req_rescan:1;
+	unsigned int discovery_polling:1;
+	unsigned int reset_in_progress:1;
+	unsigned int needs_abort_tags_swizzled:1;
+	unsigned int remove_in_progress:1;
 	int	raid_offload_debug;
-	int     discovery_polling;
 	struct  ReportLUNdata *lastlogicals;
-	int	needs_abort_tags_swizzled;
 	struct workqueue_struct *resubmit_wq;
 	struct workqueue_struct *rescan_ctlr_wq;
 	atomic_t abort_cmds_available;
 	wait_queue_head_t event_sync_wait_queue;
 	struct mutex reset_mutex;
-	u8 reset_in_progress;
 	struct hpsa_sas_node *sas_host;
 	spinlock_t reset_lock;
 };
-- 
1.8.5.6
