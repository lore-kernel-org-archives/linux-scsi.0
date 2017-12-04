From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 09/22] qla2xxx: Fix NPIV host cleanup in target mode
Date: Mon, 4 Dec 2017 14:45:04 -0800
Message-ID: <20171204224517.3409-10-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0077.outbound.protection.outlook.com ([104.47.37.77]:37524
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752283AbdLDWpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:41 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

Add check to make sure we are cleaning up global target host
list only for NPIV hosts

Fixes: bdbe24de281e2 ("scsi: qla2xxx: Cleanup NPIV host in target mode during config teardown")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 924d58f5408f..1bec8aebb7b6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1561,8 +1561,11 @@ static void qlt_release(struct qla_tgt *tgt)
 
 	btree_destroy64(&tgt->lun_qpair_map);
 
-	if (ha->tgt.tgt_ops && ha->tgt.tgt_ops->remove_target)
-		ha->tgt.tgt_ops->remove_target(vha);
+	if (vha->vp_idx)
+		if (ha->tgt.tgt_ops &&
+		    ha->tgt.tgt_ops->remove_target &&
+		    vha->vha_tgt.target_lport_ptr)
+			ha->tgt.tgt_ops->remove_target(vha);
 
 	vha->vha_tgt.qla_tgt = NULL;
 
-- 
2.12.0
