From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 05/13] iscsi-target: add int (*iscsit_validate_params)()
Date: Wed, 20 Apr 2016 00:00:12 +0530
Message-ID: <892e2ba2fad9aea5ad87763d56428007258df920.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Add int (*iscsit_validate_params)() to
struct iscsit_transport, iscsi-target
uses this callback for validating
conn operational parameters.

cxgbit.ko needs this callback to check
and update the value of
MAXXMITDATASEGMENTLENGTH.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 ++++++++++
 include/target/iscsi/iscsi_transport.h    |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 8436d56..83574eea 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1387,6 +1387,16 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
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
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index ccc68a0..46aa219 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -26,6 +26,7 @@ struct iscsit_transport {
 			       struct iscsi_datain_req *, const void *, u32);
 	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
+	int (*iscsit_validate_params)(struct iscsi_conn *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2
