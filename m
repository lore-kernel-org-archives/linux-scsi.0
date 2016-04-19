From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v3 06/13] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Wed, 20 Apr 2016 00:00:13 +0530
Message-ID: <b238cd259f86ff9140a5712d879514618b0df986.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:64552 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932248AbcDSSbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2016 14:31:03 -0400
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
In-Reply-To: <cover.1461088672.git.varun@chelsio.com>
References: <cover.1461088672.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

Add void (*iscsit_get_r2t_ttt)() to
struct iscsit_transport, iscsi-target
uses this callback to get
r2t->targ_xfer_tag.

cxgbit.ko needs this callback
for Direct Data Placement of Data Out
pdus, adapter uses ttt in Data Out pdus
for placing data directly in to the host
buffers.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target.c    | 5 ++++-
 include/target/iscsi/iscsi_transport.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a827b7a..a28eb87 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3039,7 +3039,10 @@ static int iscsit_send_r2t(
 	int_to_scsilun(cmd->se_cmd.orig_fe_lun,
 			(struct scsi_lun *)&hdr->lun);
 	hdr->itt		= cmd->init_task_tag;
-	r2t->targ_xfer_tag	= session_get_next_ttt(conn->sess);
+	if (conn->conn_transport->iscsit_get_r2t_ttt)
+		conn->conn_transport->iscsit_get_r2t_ttt(conn, cmd, r2t);
+	else
+		r2t->targ_xfer_tag = session_get_next_ttt(conn->sess);
 	hdr->ttt		= cpu_to_be32(r2t->targ_xfer_tag);
 	hdr->statsn		= cpu_to_be32(conn->stat_sn);
 	hdr->exp_cmdsn		= cpu_to_be32(conn->sess->exp_cmd_sn);
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 46aa219..32704b2 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -27,6 +27,8 @@ struct iscsit_transport {
 	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
 	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
 	int (*iscsit_validate_params)(struct iscsi_conn *);
+	void (*iscsit_get_r2t_ttt)(struct iscsi_conn *, struct iscsi_cmd *,
+				   struct iscsi_r2t *);
 	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
 };
 
-- 
2.0.2

