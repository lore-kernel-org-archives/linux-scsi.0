From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 04/22] qla2xxx: Skip IRQ affinity for Target QPairs
Date: Tue, 28 Nov 2017 11:34:45 -0800
Message-ID: <20171128193503.13695-5-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:4638
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752410AbdK1TfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:14 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Fix co-existence between Block MQ and Target Mode. Block MQ
and initiator mode requires midlayer queue mapping to check
for IRQ to be affinitize. For target mode, it's not the case.

Fixes: 09620eeb62c41 ("scsi: qla2xxx: Add debug knob for user control workload")
Cc: <stable@vger.kernel.org> # 4.12+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dfbf82e716b0..428e1bfaa83b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6609,9 +6609,14 @@ qla83xx_disable_laser(scsi_qla_host_t *vha)
 
 static int qla2xxx_map_queues(struct Scsi_Host *shost)
 {
+	int rc;
 	scsi_qla_host_t *vha = (scsi_qla_host_t *)shost->hostdata;
 
-	return blk_mq_pci_map_queues(&shost->tag_set, vha->hw->pdev);
+	if (USER_CTRL_IRQ(vha->hw))
+		rc = blk_mq_map_queues(&shost->tag_set);
+	else
+		rc = blk_mq_pci_map_queues(&shost->tag_set, vha->hw->pdev);
+	return rc;
 }
 
 static const struct pci_error_handlers qla2xxx_err_handler = {
-- 
2.12.0
