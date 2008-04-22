From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch 05/10] scsi: replace remaining __FUNCTION__ occurrences
Date: Tue, 22 Apr 2008 17:20:55 -0500
Message-ID: <480E64C7.9090400@cs.wisc.edu>
References: <200804182057.m3IKvNTN015375@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040705010501060402000605"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54989 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYDVWVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 18:21:12 -0400
In-Reply-To: <200804182057.m3IKvNTN015375@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

This is a multi-part message in MIME format.
--------------040705010501060402000605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 

>  drivers/scsi/iscsi_tcp.c              |   12 +++---

Sorry about this. I forgot to send the updated patch with my update for 
2.6.26. Attached is the updated patch built over James's scsi-misc tree. 
If Andrew or James was going to send these for 2.6.26, then take it. If 
not then I promise I will send it when the 2.6.27 window opens with the 
iscsi update for that kernel.

--------------040705010501060402000605
Content-Type: text/x-patch;
 name="iscsi-replace-FUNCTION-with-func.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iscsi-replace-FUNCTION-with-func.patch"

Replace __FUNCTION__ with __func__ in iscsi_tcp.

From: Harvey Harrison <harvey.harrison@gmail.com>
 
__FUNCTION__ is gcc-specific, use __func__

(Update diff for scsi-misc by Mike Christie)

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..6c4b17f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -536,7 +536,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	if (tcp_ctask->exp_datasn != datasn) {
 		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->datasn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, datasn);
+		          __func__, tcp_ctask->exp_datasn, datasn);
 		return ISCSI_ERR_DATASN;
 	}
 
@@ -545,7 +545,7 @@ iscsi_data_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	tcp_ctask->data_offset = be32_to_cpu(rhdr->offset);
 	if (tcp_ctask->data_offset + tcp_conn->in.datalen > total_in_length) {
 		debug_tcp("%s: data_offset(%d) + data_len(%d) > total_length_in(%d)\n",
-		          __FUNCTION__, tcp_ctask->data_offset,
+		          __func__, tcp_ctask->data_offset,
 		          tcp_conn->in.datalen, total_in_length);
 		return ISCSI_ERR_DATA_OFFSET;
 	}
@@ -638,7 +638,7 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	if (tcp_ctask->exp_datasn != r2tsn){
 		debug_tcp("%s: ctask->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
-		          __FUNCTION__, tcp_ctask->exp_datasn, r2tsn);
+		          __func__, tcp_ctask->exp_datasn, r2tsn);
 		return ISCSI_ERR_R2TSN;
 	}
 
@@ -1176,7 +1176,7 @@ iscsi_tcp_send_hdr_prep(struct iscsi_conn *conn, void *hdr, size_t hdrlen)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
-	debug_tcp("%s(%p%s)\n", __FUNCTION__, tcp_conn,
+	debug_tcp("%s(%p%s)\n", __func__, tcp_conn,
 			conn->hdrdgst_en? ", digest enabled" : "");
 
 	/* Clear the data segment - needs to be filled in by the
@@ -1217,7 +1217,7 @@ iscsi_tcp_send_data_prep(struct iscsi_conn *conn, struct scatterlist *sg,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __FUNCTION__,
+	debug_tcp("%s(%p, offset=%d, datalen=%d%s)\n", __func__,
 			tcp_conn, offset, len,
 			conn->datadgst_en? ", digest enabled" : "");
 
@@ -1242,7 +1242,7 @@ iscsi_tcp_send_linear_data_prepare(struct iscsi_conn *conn, void *data,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, datalen=%d%s)\n", __FUNCTION__, tcp_conn, len,
+	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
 		  conn->datadgst_en? ", digest enabled" : "");
 
 	/* Make sure the datalen matches what the caller

--------------040705010501060402000605--
