From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 2/2] scsi:qla2xxx: Use PTR_ERR_OR_ZERO to replace the open code
Date: Mon, 13 Aug 2018 19:10:40 +0800
Message-ID: <1534158640-24353-3-git-send-email-zhongjiang@huawei.com>
References: <1534158640-24353-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1534158640-24353-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

PTR_ERR_OR_ZERO has implemented the if(IS_ERR(...)) + PTR_ERR, So
just replace them rather than duplicating its implement.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index e03d12a..616f139 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1542,10 +1542,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 				       sizeof(struct qla_tgt_cmd),
 				       TARGET_PROT_ALL, port_name,
 				       qlat_sess, tcm_qla2xxx_session_cb);
-	if (IS_ERR(se_sess))
-		return PTR_ERR(se_sess);
-
-	return 0;
+	
+	return PTR_ERR_OR_ZERO(se_sess);
 }
 
 static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
-- 
1.7.12.4
