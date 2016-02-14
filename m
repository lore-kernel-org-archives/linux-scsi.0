From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 24/34] iscsi-target: validate conn operational parameters
Date: Sun, 14 Feb 2016 23:15:31 +0530
Message-ID: <940698fdb1ca47d8c392fa687f971842d215d083.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

call validate params function if registered
by transport driver before starting negotiation,
so that transport driver can validate and update
the value of parameters.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 616ec9e..83c3643 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1375,6 +1375,16 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			goto old_sess_out;
 	}
 
+	if (conn->conn_transport->iscsit_validate_params) {
+		ret = conn->conn_transport->iscsit_validate_params(conn);
+		if (ret < 0) {
+			if (zero_tsih)
+				goto new_sess_out;
+			else
+				goto old_sess_out;
+		}
+	}
+
 	ret = iscsi_target_start_negotiation(login, conn);
 	if (ret < 0)
 		goto new_sess_out;
-- 
2.0.2
