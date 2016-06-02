From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH] scsi: device_handler: Remove create_workqueue
Date: Thu, 2 Jun 2016 14:24:42 +0530
Message-ID: <20160602085441.GA14104@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

alloc_workqueue() replaces deprecated create_workqueue().

A dedicated workqueue has been used since the workqueue kaluad_sync_wq
was created with the purpose of STPGs to be submitted synchronously. The
workitem (viz  &pg->rtpg_work which maps to alua_rtpg_work) is involved
in normal device operation and requires forward progress under memory
pressure.

alloc_workqueue() parameters for kaluad_sync_wq are similar to kaluad_wq.
if (pg->flags & ALUA_SYNC_STPG) are set then kaluad_sync_wq is used
else kaluad_wq.

create_workqueue has been replaced with alloc_workqueue with max_active
as 0 since there is no need for throttling the number of active work
items.

Lastly, WQ_MEM_RECLAIM flag has been added to guarantee forward progress
in memory reclaim path.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 752b5c9..193b28f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1152,7 +1152,7 @@ static int __init alua_init(void)
 		/* Temporary failure, bypass */
 		return SCSI_DH_DEV_TEMP_BUSY;
 	}
-	kaluad_sync_wq = create_workqueue("kaluad_sync");
+	kaluad_sync_wq = alloc_workqueue("kaluad_sync", WQ_MEM_RECLAIM, 0);
 	if (!kaluad_sync_wq) {
 		destroy_workqueue(kaluad_wq);
 		return SCSI_DH_DEV_TEMP_BUSY;
