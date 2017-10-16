From: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Subject: [PATCH 1/1] qla2xxx: Initialize Work element before requesting IRQs
Date: Mon, 16 Oct 2017 11:26:05 -0700
Message-ID: <20171016182605.22174-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0078.outbound.protection.outlook.com ([104.47.34.78]:59520
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754947AbdJPS0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 14:26:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

commit a9e170e28636 ("scsi: qla2xxx: Fix uninitialized work element")
moved initialziation of work element earlier in the probe to fix call
stack. However, it still leaves a window where interrupt can be generated
before work element is initialized. Fix that window by Initializing work
element before we are requesting IRQs.

Fixes: a9e170e28636 ("scsi: qla2xxx: Fix uninitialized work element")
Cc: <stable@vger.kernel.org> # 4.13
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
---
Hi Martin,

Please apply this patch to 4.14.0-rc6. This patch fixes a small window where 
user will see call stack with qla2xxx driver. 

Thanks,
Himanshu

 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 937209805baf..3bd956d3bc5d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3061,6 +3061,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
 
+	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -3175,8 +3177,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
-	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
-
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
-- 
2.12.0
