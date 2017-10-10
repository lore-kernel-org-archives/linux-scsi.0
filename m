From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix uninitialize work element
Date: Tue, 10 Oct 2017 12:08:22 -0700
Message-ID: <20171010190822.26976-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0078.outbound.protection.outlook.com ([104.47.41.78]:26612
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751168AbdJJTI2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Oct 2017 15:08:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Fixes following stack trace

kernel: Call Trace:
kernel: dump_stack+0x63/0x84
kernel: __warn+0xd1/0xf0
kernel: warn_slowpath_null+0x1d/0x20
kernel: __queue_work+0x37a/0x420
kernel: queue_work_on+0x27/0x40
kernel: queue_work+0x14/0x20 [qla2xxx]
kernel: schedule_work+0x13/0x20 [qla2xxx]
kernel: qla2x00_post_work+0xab/0xb0 [qla2xxx]
kernel: qla2x00_post_aen_work+0x3b/0x50 [qla2xxx]
kernel: qla2x00_async_event+0x20d/0x15d0 [qla2xxx]
kernel: ? lock_timer_base+0x7d/0xa0
kernel: qla24xx_intr_handler+0x1da/0x310 [qla2xxx]
kernel: qla2x00_poll+0x36/0x60 [qla2xxx]
kernel: qla2x00_mailbox_command+0x659/0xec0 [qla2xxx]
kernel: ? proc_create_data+0x7a/0xd0
kernel: qla25xx_init_rsp_que+0x15b/0x240 [qla2xxx]
kernel: ? request_irq+0x14/0x20 [qla2xxx]
kernel: qla25xx_create_rsp_que+0x256/0x3c0 [qla2xxx]
kernel: qla2xxx_create_qpair+0x2af/0x5b0 [qla2xxx]
kernel: qla2x00_probe_one+0x1107/0x1c30 [qla2xxx]

Fixes: ec7193e26055 ("qla2xxx: Fix delayed response to command for loop mode/direct connect.")
Cc: <stable@vger.kernel.org> # 4.13
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
Hi Martin,

Please apply this patch to 4.14.0-rc5.  User will see call stack everytime 
qla2xxx driver is loaded with kernel where original patch was added. 

Thanks,
Himanshu
---
 drivers/scsi/qla2xxx/qla_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b2437a5ea44..937209805baf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3175,6 +3175,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
+	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
@@ -3223,7 +3225,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	qla2xxx_wake_dpc(base_vha);
 
-	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
 	INIT_WORK(&ha->board_disable, qla2x00_disable_board_on_pci_error);
 
 	if (IS_QLA8031(ha) || IS_MCTP_CAPABLE(ha)) {
-- 
2.12.0
