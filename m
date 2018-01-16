From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/8] qla2xxx: Fix NULL pointer crash due to probe failure
Date: Mon, 15 Jan 2018 20:46:46 -0800
Message-ID: <20180116044653.20696-2-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0075.outbound.protection.outlook.com ([104.47.37.75]:7968
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751284AbeAPErA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:00 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes regression added by commit d74595278f4ab
("scsi: qla2xxx: Add multiple queue pair functionality.").

When driver is not able to get reqeusted IRQs from the system, driver
will attempt tp clean up memory before failing hardware probe. During
this cleanup, driver assigns NULL value to the pointer which has not
been allocated by driver yet. This results in a NULL pointer access.

Log file will show following message and stack trace

qla2xxx [0000:a3:00.1]-00c7:21: MSI-X: Failed to enable support, giving up -- 32/-1.
qla2xxx [0000:a3:00.1]-0037:21: Falling back-to MSI mode --1.
qla2xxx [0000:a3:00.1]-003a:21: Failed to reserve interrupt 821 already in use.
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffc010c4b6>] qla2x00_probe_one+0x18b6/0x2730 [qla2xxx]
PGD 0
Oops: 0002 [#1] SMP

Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionality.").
Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b21878a70f6e..12ee6e02d146 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3035,9 +3035,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	base_vha = qla2x00_create_host(sht, ha);
 	if (!base_vha) {
 		ret = -ENOMEM;
-		qla2x00_mem_free(ha);
-		qla2x00_free_req_que(ha, req);
-		qla2x00_free_rsp_que(ha, rsp);
 		goto probe_hw_failed;
 	}
 
@@ -3098,7 +3095,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
-		goto probe_init_failed;
+		goto probe_hw_failed;
 
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha, req, rsp)) {
@@ -3415,6 +3412,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	scsi_host_put(base_vha->host);
 
 probe_hw_failed:
+	qla2x00_mem_free(ha);
+	qla2x00_free_req_que(ha, req);
+	qla2x00_free_rsp_que(ha, rsp);
 	qla2x00_clear_drv_active(ha);
 
 iospace_config_failed:
-- 
2.12.0
