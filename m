From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 1/7] qla2xxx: Fix recursive loop during target mode configuration for ISP25XX leaving system unresponsive.
Date: Wed, 24 May 2017 18:06:18 -0700
Message-ID: <20170525010624.8886-2-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0071.outbound.protection.outlook.com ([104.47.36.71]:16096
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162163AbdEYBGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:31 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Following messages are seen into system logs

qla2xxx [0000:09:00.0]-00af:9: Performing ISP error recovery -
ha=ffff98315ee30000.
qla2xxx [0000:09:00.0]-504b:9: RISC paused -- HCCR=40, Dumping firmware.
qla2xxx [0000:09:00.0]-d009:9: Firmware has been previously dumped
(ffffba488c001000) -- ignoring request.
qla2xxx [0000:09:00.0]-504b:9: RISC paused -- HCCR=40, Dumping firmware.

See Bugzilla for details
https://bugzilla.kernel.org/show_bug.cgi?id=195285

Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: <stable@vger.kernel.org> # 4.10
Reported-by: Laurence Oberman <loberman@redhat.com>
Reported-by: Anthony Bloodoff <anthony.bloodoff@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Tested-by: Anthony Bloodoff <anthony.bloodoff@gmail.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index aac03504d9a3..2572121b765b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3282,7 +3282,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	}
 
 	/* Enable MSI-X vector for response queue update for queue 0 */
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
+	if (IS_QLA25XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
 		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
 		     ql2xmqsupport))
-- 
2.12.0
