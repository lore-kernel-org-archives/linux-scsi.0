From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH 2/2] qla2xxx: Query FC4 type during RSCN processing
Date: Fri, 13 Oct 2017 15:43:23 -0700
Message-ID: <20171013224323.14863-3-himanshu.madhani@cavium.com>
References: <20171013224323.14863-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0076.outbound.protection.outlook.com ([104.47.38.76]:61952
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752919AbdJMWnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 18:43:35 -0400
In-Reply-To: <20171013224323.14863-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@cavium.com>

Based on the FC4 type, login will proceed to either
FCP or FC-NVMe remote ports.

Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0cfce0486b70..4b9a7f1711c7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4762,7 +4762,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		if (pla)
 			qlt_plogi_ack_unref(vha, pla);
 		else
-			qla24xx_async_gnl(vha, fcport);
+			qla24xx_async_gffid(vha, fcport);
 	}
 
 	if (free_fcport) {
-- 
2.12.0
