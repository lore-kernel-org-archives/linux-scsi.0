From: michaelc@cs.wisc.edu
Subject: [PATCH 24/25] Replace __FUNCTION__ with __func__ in iscsi_tcp.
Date: Wed, 21 May 2008 15:54:19 -0500
Message-ID: <1211403260-5487-25-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-23-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-24-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937127AbYEUUyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:39 -0400
In-Reply-To: <1211403260-5487-24-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

(Update diff by Mike Christie)

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index af7ee45..c7803c3 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -544,7 +544,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 
 	if (tcp_task->exp_datasn != datasn) {
 		debug_tcp("%s: task->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __FUNCTION__, tcp_task->exp_datasn, datasn);
+		          __func__, tcp_task->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
 	}
 
@@ -553,7 +553,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	tcp_task->data_offset = be32_to_cpu(rhdr->offset);
 	if (tcp_task->data_offset + tcp_conn->in.datalen > total_in_length) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __FUNCTION__, tcp_task->data_offset,
+		          __func__, tcp_task->data_offset,
 		          tcp_conn->in.datalen, total_in_length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
@@ -646,7 +646,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 
 	if (tcp_task->exp_datasn != r2tsn){
 		debug_tcp("%s: task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __FUNCTION__, tcp_task->exp_datasn, r2tsn);
+		          __func__, tcp_task->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
 	}
 
@@ -1193,7 +1193,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
-	debug_tcp("%s(%p%s)\n", __FUNCTION__, tcp_conn,
+	debug_tcp("%s(%p%s)\n", __func__, tcp_conn,
 			conn->hdrdgst_en? ", digest enabled" : "");
 
 	/* Clear the data segment - needs to be filled in by the
@@ -1234,7 +1234,7 @@ iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __FUNCTION__,
+	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __func__,
 			tcp_conn, offset, len,
 			conn->datadgst_en? ", digest enabled" : "");
 
@@ -1259,7 +1259,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, datalen=%d%s)\n", __FUNCTION__, tcp_conn, len,
+	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
 		  conn->datadgst_en? ", digest enabled" : "");
 
 	/* Make sure the datalen matches what the caller
-- 
1.5.4.1

