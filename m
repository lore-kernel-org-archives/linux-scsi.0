From: Feng Li <li.feng@oracle.com>
Subject: [PATCH] iscsi-target: fix panic when add the second TCP connection to iSCSI session
Date: Tue, 12 Jul 2016 06:15:44 +0800
Message-ID: <20160711221544.42291-1-li.feng@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org, agrover@redhat.com, varun@chelsio.com, herbert@gondor.apana.org.au, roland@purestorage.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Feng Li <lifeng1519@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Feng Li <lifeng1519@gmail.com>

In MC/S scenario, the conn->sess has been set NULL in
iscsi_login_non_zero_tsih_s1 when the second connection comes here,
then kernel panic.

The conn->sess will be assigned in iscsi_login_non_zero_tsih_s2. So
we should check whether it's NULL before calling.

Signed-off-by: Feng Li <lifeng1519@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index b5212f0..adf419f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1371,8 +1371,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	login->zero_tsih = zero_tsih;
 
-	conn->sess->se_sess->sup_prot_ops =
-		conn->conn_transport->iscsit_get_sup_prot_ops(conn);
+	if (conn->sess)
+		conn->sess->se_sess->sup_prot_ops =
+			conn->conn_transport->iscsit_get_sup_prot_ops(conn);
 
 	tpg = conn->tpg;
 	if (!tpg) {
-- 
2.9.0
