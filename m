From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] qla2xxx: Suppress a kernel complaint in qla_init_base_qpair()
Date: Mon, 6 Nov 2017 11:59:05 -0800
Message-ID: <20171106195905.5139-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:46394 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753698AbdKFT7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2017 14:59:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Quinn Tran <quinn.tran@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org

Avoid that the following is reported while loading the qla2xxx
kernel module:

BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/783
caller is debug_smp_processor_id+0x17/0x20
CPU: 7 PID: 783 Comm: modprobe Not tainted 4.14.0-rc8-dbg+ #2
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0x8e/0xce
 check_preemption_disabled+0xe3/0xf0
 debug_smp_processor_id+0x17/0x20
 qla2x00_probe_one+0xf43/0x26c0 [qla2xxx]
 pci_device_probe+0xca/0x140
 driver_probe_device+0x2e2/0x440
 __driver_attach+0xa3/0xe0
 bus_for_each_dev+0x5f/0x90
 driver_attach+0x19/0x20
 bus_add_driver+0x1c0/0x260
 driver_register+0x5b/0xd0
 __pci_register_driver+0x63/0x70
 qla2x00_module_init+0x1d6/0x222 [qla2xxx]
 do_one_initcall+0x3c/0x163
 do_init_module+0x55/0x1eb
 load_module+0x20a2/0x2890
 SYSC_finit_module+0xd7/0xf0
 SyS_finit_module+0x9/0x10
 entry_SYSCALL_64_fastpath+0x23/0xc2

Fixes: commit 8abfa9e22683 ("scsi: qla2xxx: Add function call to qpair for door bell")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3bd956d3bc5d..b514bd5d2ac5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -388,7 +388,7 @@ static void qla_init_base_qpair(struct scsi_qla_host *vha, struct req_que *req,
 	INIT_LIST_HEAD(&ha->base_qpair->nvme_done_list);
 	ha->base_qpair->enable_class_2 = ql2xenableclass2;
 	/* init qpair to this cpu. Will adjust at run time. */
-	qla_cpu_update(rsp->qpair, smp_processor_id());
+	qla_cpu_update(rsp->qpair, raw_smp_processor_id());
 	ha->base_qpair->pdev = ha->pdev;
 
 	if (IS_QLA27XX(ha) || IS_QLA83XX(ha))
-- 
2.14.3
