From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] iscsi-target: Improve size determinations in four
 functions
Date: Sun, 9 Apr 2017 16:28:42 +0200
Message-ID: <b2f306db-d191-67bb-1e9b-0e91cd540481@users.sourceforge.net>
References: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f573fbbe-aef2-7b68-1540-ceb2f30a6aa6@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 16:00:39 +0200

Replace the specification of four data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 196e9dd138ca..5ef6eb238174 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -128,7 +128,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 		return ERR_PTR(-EINVAL);
 	}
 
-	tiqn = kzalloc(sizeof(struct iscsi_tiqn), GFP_KERNEL);
+	tiqn = kzalloc(sizeof(*tiqn), GFP_KERNEL);
 	if (!tiqn)
 		return ERR_PTR(-ENOMEM);
 
@@ -360,7 +360,7 @@ struct iscsi_np *iscsit_add_np(
 		return np;
 	}
 
-	np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
+	np = kzalloc(sizeof(*np), GFP_KERNEL);
 	if (!np) {
 		mutex_unlock(&np_lock);
 		return ERR_PTR(-ENOMEM);
@@ -694,8 +694,7 @@ static int __init iscsi_target_init_module(void)
 	int ret = 0, size;
 
 	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
-
-	iscsit_global = kzalloc(sizeof(struct iscsit_global), GFP_KERNEL);
+	iscsit_global = kzalloc(sizeof(*iscsit_global), GFP_KERNEL);
 	if (!iscsit_global)
 		return -1;
 
@@ -1987,8 +1986,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		hdr->refcmdsn = cpu_to_be32(ISCSI_RESERVED_TAG);
 
 	cmd->data_direction = DMA_NONE;
-
-	cmd->tmr_req = kzalloc(sizeof(struct iscsi_tmr_req), GFP_KERNEL);
+	cmd->tmr_req = kzalloc(sizeof(*cmd->tmr_req), GFP_KERNEL);
 	if (!cmd->tmr_req)
 		return iscsit_add_reject_cmd(cmd,
 					     ISCSI_REASON_BOOKMARK_NO_RESOURCES,
-- 
2.12.2
