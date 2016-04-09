From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 10/16] iscsi-target: use conn->network_transport in text rsp
Date: Sat,  9 Apr 2016 18:41:20 +0530
Message-ID: <03c8c334724e05198a48d7534eb2cd3fabeb3ea0.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Use conn->network_transport instead of
ISCSI_TCP to build text response.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b655f0c..e61249d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3546,7 +3546,8 @@ static int iscsit_send_text_rsp(
 	if (unlikely(!hdr))
 		return -ENOMEM;
 
-	text_length = iscsit_build_text_rsp(cmd, conn, hdr, ISCSI_TCP);
+	text_length = iscsit_build_text_rsp(cmd, conn, hdr,
+					    conn->network_transport);
 	if (text_length < 0) {
 		if (conn->conn_transport->iscsit_free_pdu)
 			conn->conn_transport->iscsit_free_pdu(conn, cmd);
-- 
2.0.2
