From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 13/15] tcm_qla2xxx: Set TARGET_PROT_ALL for sup_prot_ops
Date: Mon, 30 Mar 2015 03:28:22 +0000
Message-ID: <1427686104-14231-14-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing TARGET_PROT_ALL when initializing a new
session and declaring the capable se_sess->sup_prot_ops for T10-PI.

This is required in order to function with existing qla_target.c
DIF protection offload support.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c4f66f5..57346ab 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1570,7 +1570,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 
 	se_sess = transport_init_session_tags(num_tags,
 					      sizeof(struct qla_tgt_cmd),
-					      TARGET_PROT_NORMAL);
+					      TARGET_PROT_ALL);
 	if (IS_ERR(se_sess)) {
 		pr_err("Unable to initialize struct se_session\n");
 		return PTR_ERR(se_sess);
-- 
1.9.1
