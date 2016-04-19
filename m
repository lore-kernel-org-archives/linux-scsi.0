From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 02/13] iscsi-target: add void (*iscsit_release_cmd)()
Date: Wed, 20 Apr 2016 00:00:09 +0530
Message-ID: <5cd6e587f8c539c20dc9d2383121360d59b46ab1.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add void (*iscsit_release_cmd)() to
struct iscsit_transport, iscsi-target
uses this callback to release transport
driver resources associated with an iSCSI cmd.

cxgbit.ko needs this callback to release DDP
resource and sg page in case of
PASSTHROUGH_SG_TO_MEM_NOALLOC.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 3 +++
 include/target/iscsi/iscsi_transport.h   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 428b0d9..a533017 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -725,6 +725,9 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool scsi_cmd,
 		iscsit_remove_cmd_from_immediate_queue(cmd, conn);
 		iscsit_remove_cmd_from_response_queue(cmd, conn);
 	}
+
+	if (conn && conn->conn_transport->iscsit_release_cmd)
+		conn->conn_transport->iscsit_release_cmd(conn, cmd);
 }
 
 void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 24b613a..3b0053e 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -24,6 +24,7 @@ struct iscsit_transport {
 	void (*iscsit_aborted_task)(struct iscsi_conn *, struct iscsi_cmd *);
 	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
 			       struct iscsi_datain_req *, const void *, u32);
+	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2
