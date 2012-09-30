From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/6] iscsi-target: Convert incoming PDU payload checks to MaxXmitDataSegmentLength
Date: Sun, 30 Sep 2012 05:58:14 +0000
Message-ID: <1348984696-30992-5-git-send-email-nab@linux-iscsi.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that iscsi-target supports a local configurable MaxXmitDataSegmentLength,
go ahead and make ISCSI_OP_SCSI_CMD, ISCSI_OP_SCSI_DATA_OUT, ISCSI_OP_NOOP_OUT
and ISCSI_OP_TEXT PDU payload checks honor conn_ops->MaxXmitDataSegmentLength.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andy Grover <agrover@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 30842e1..632a5ae 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -869,10 +869,10 @@ done:
 				buf, conn);
 	}
 
-	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
 		pr_err("DataSegmentLength: %u is greater than"
-			" MaxRecvDataSegmentLength: %u, protocol error.\n",
-			payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+			" MaxXmitDataSegmentLength: %u, protocol error.\n",
+			payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 				buf, conn);
 	}
@@ -1216,10 +1216,10 @@ static int iscsit_handle_data_out(struct iscsi_conn *conn, unsigned char *buf)
 	}
 	spin_unlock_bh(&conn->sess->session_stats_lock);
 
-	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
 		pr_err("DataSegmentLength: %u is greater than"
-			" MaxRecvDataSegmentLength: %u\n", payload_length,
-			conn->conn_ops->MaxRecvDataSegmentLength);
+			" MaxXmitDataSegmentLength: %u\n", payload_length,
+			conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
@@ -1437,11 +1437,11 @@ static int iscsit_handle_nop_out(
 					buf, conn);
 	}
 
-	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
 		pr_err("NOPOUT Ping Data DataSegmentLength: %u is"
-			" greater than MaxRecvDataSegmentLength: %u, protocol"
+			" greater than MaxXmitDataSegmentLength: %u, protocol"
 			" error.\n", payload_length,
-			conn->conn_ops->MaxRecvDataSegmentLength);
+			conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
@@ -1874,10 +1874,10 @@ static int iscsit_handle_text_cmd(
 	hdr->cmdsn		= be32_to_cpu(hdr->cmdsn);
 	hdr->exp_statsn		= be32_to_cpu(hdr->exp_statsn);
 
-	if (payload_length > conn->conn_ops->MaxRecvDataSegmentLength) {
+	if (payload_length > conn->conn_ops->MaxXmitDataSegmentLength) {
 		pr_err("Unable to accept text parameter length: %u"
-			"greater than MaxRecvDataSegmentLength %u.\n",
-		       payload_length, conn->conn_ops->MaxRecvDataSegmentLength);
+			"greater than MaxXmitDataSegmentLength %u.\n",
+		       payload_length, conn->conn_ops->MaxXmitDataSegmentLength);
 		return iscsit_add_reject(ISCSI_REASON_PROTOCOL_ERROR, 1,
 					buf, conn);
 	}
-- 
1.7.2.5
