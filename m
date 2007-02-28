From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] rename DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH
Date: Wed, 28 Feb 2007 17:32:17 -0600
Message-ID: <1172705543740-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu> <11727055433394-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXB1Xcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:36 -0500
In-Reply-To: <11727055433394-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch renames DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH to avoid
confusion with the drivers default values (DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH
is the iscsi RFC specific default).
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 drivers/scsi/iscsi_tcp.c                     |    6 +++---
 drivers/scsi/libiscsi.c                      |    2 +-
 include/scsi/iscsi_proto.h                   |   12 +++++++++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 89e3728..3261bb3 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -201,7 +201,7 @@ static int iser_post_receive_control(str
 	 * what's common for both schemes is that the connection is not started
 	 */
 	if (conn->c_stage != ISCSI_CONN_STARTED)
-		rx_data_size = DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH;
+		rx_data_size = ISCSI_DEF_MAX_RECV_SEG_LEN;
 	else /* FIXME till user space sets conn->max_recv_dlength correctly */
 		rx_data_size = 128;
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8f55e14..6fd0845 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -527,12 +527,12 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 		 * than 8K, but there are no targets that currently do this.
 		 * For now we fail until we find a vendor that needs it
 		 */
-		if (DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH <
+		if (ISCSI_DEF_MAX_RECV_SEG_LEN <
 		    tcp_conn->in.datalen) {
 			printk(KERN_ERR "iscsi_tcp: received buffer of len %u "
 			      "but conn buffer is only %u (opcode %0x)\n",
 			      tcp_conn->in.datalen,
-			      DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH, opcode);
+			      ISCSI_DEF_MAX_RECV_SEG_LEN, opcode);
 			rc = ISCSI_ERR_PROTO;
 			break;
 		}
@@ -1762,7 +1762,7 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	 * due to strange issues with iser these are not set
 	 * in iscsi_conn_setup
 	 */
-	conn->max_recv_dlength = DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH;
+	conn->max_recv_dlength = ISCSI_DEF_MAX_RECV_SEG_LEN;
 
 	tcp_conn = kzalloc(sizeof(*tcp_conn), GFP_KERNEL);
 	if (!tcp_conn)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5c176ab..6913466 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1520,7 +1520,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	}
 	spin_unlock_bh(&session->lock);
 
-	data = kmalloc(DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH, GFP_KERNEL);
+	data = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
 	if (!data)
 		goto login_mtask_data_alloc_fail;
 	conn->login_mtask->data = conn->data = data;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 4a44278..8d1e4e8 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -588,7 +588,17 @@ #define KEY_MAXLEN		64
 #define VALUE_MAXLEN		255
 #define TARGET_NAME_MAXLEN	VALUE_MAXLEN
 
-#define DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH	8192
+#define ISCSI_DEF_MAX_RECV_SEG_LEN		8192
+#define ISCSI_MIN_MAX_RECV_SEG_LEN		512
+#define ISCSI_MAX_MAX_RECV_SEG_LEN		16777215
+
+#define ISCSI_DEF_FIRST_BURST_LEN		65536
+#define ISCSI_MIN_FIRST_BURST_LEN		512
+#define ISCSI_MAX_FIRST_BURST_LEN		16777215
+
+#define ISCSI_DEF_MAX_BURST_LEN			262144
+#define ISCSI_MIN_MAX_BURST_LEN			512
+#define ISCSI_MAX_MAX_BURST_LEN			16777215
 
 /************************* RFC 3720 End *****************************/
 
-- 
1.4.1.1

