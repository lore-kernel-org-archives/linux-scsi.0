From: Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [PATCH] [SCSI] qla2xxx: qla2x00_probe_one kernel panic.
Date: Wed,  2 May 2012 10:17:25 -0600
Message-ID: <1335975445-14595-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hp.com>
List-Id: linux-scsi@vger.kernel.org

When qla2x00_probe_one fails, its back-out logic tries to free up
resources already allocated.

When qla2x00_probe_one fails at the steps for qla2x00_request_irqs
or qla2x00_alloc_queues, it will call qla2x00_free_device.  This
path eventually calls qla2x00_free_irqs which accesses ha->rsp_q_map.
However, the rsp_q_map pointer hasn't been initialized yet.

This causes a "NULL pointer dereference" panic.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a2f9992..7aeb5aa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2420,7 +2420,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
-		goto probe_init_failed;
+		goto probe_hw_failed;
 
 	pci_save_state(pdev);
 
@@ -2429,7 +2429,7 @@ que_init:
 	if (!qla2x00_alloc_queues(ha)) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
 		    "Failed to allocate memory for queue pointers.. aborting.\n");
-		goto probe_init_failed;
+		goto probe_hw_failed;
 	}
 
 	ha->rsp_q_map[0] = rsp;
@@ -2579,11 +2579,6 @@ skip_dpc:
 
 	return 0;
 
-probe_init_failed:
-	qla2x00_free_req_que(ha, req);
-	qla2x00_free_rsp_que(ha, rsp);
-	ha->max_req_queues = ha->max_rsp_queues = 0;
-
 probe_failed:
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
-- 
1.7.7.6
