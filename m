From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Fix sendpage breakage with proper padding+DataDigest iovec offsets
Date: Fri, 16 Sep 2011 23:45:55 +0000
Message-ID: <1316216755-21371-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50645 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab1IQAMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 20:12:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in the iscsit_fe_sendpage_sg() transmit codepath that
was originally introduced with the v3.1 iscsi-target merge that incorrectly
uses hardcoded cmd->iov_data_count values to determine cmd->iov_data[] offsets
for extra outgoing padding and DataDigest payload vectors.

This code is obviously incorrect for the DataDigest enabled case with sendpage
offload, and this fix ensures correct operation for padding + DataDigest,
padding only, and DataDigest only cases.  The bug was introduced during a
pre-merge change in iscsit_fe_sendpage_sg() to natively use struct scatterlist
instead of the legacy v3.0 struct se_mem logic.

Cc: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 93e4b68..60da77f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1256,7 +1256,7 @@ int iscsit_fe_sendpage_sg(
 	struct kvec iov;
 	u32 tx_hdr_size, data_len;
 	u32 offset = cmd->first_data_sg_off;
-	int tx_sent;
+	int tx_sent, iov_off;
 
 send_hdr:
 	tx_hdr_size = ISCSI_HDR_LEN;
@@ -1276,9 +1276,19 @@ send_hdr:
 	}
 
 	data_len = cmd->tx_size - tx_hdr_size - cmd->padding;
-	if (conn->conn_ops->DataDigest)
+	/*
+	 * Set iov_off used by padding and data digest tx_data() calls below
+	 * in order to determine proper offset into cmd->iov_data[]
+	 */
+	if (conn->conn_ops->DataDigest) {
 		data_len -= ISCSI_CRC_LEN;
-
+		if (cmd->padding)
+			iov_off = (cmd->iov_data_count - 2);
+		else
+			iov_off = (cmd->iov_data_count - 1);
+	} else {
+		iov_off = (cmd->iov_data_count - 1);
+	}
 	/*
 	 * Perform sendpage() for each page in the scatterlist
 	 */
@@ -1307,8 +1317,7 @@ send_pg:
 
 send_padding:
 	if (cmd->padding) {
-		struct kvec *iov_p =
-			&cmd->iov_data[cmd->iov_data_count-1];
+		struct kvec *iov_p = &cmd->iov_data[iov_off++];
 
 		tx_sent = tx_data(conn, iov_p, 1, cmd->padding);
 		if (cmd->padding != tx_sent) {
@@ -1322,8 +1331,7 @@ send_padding:
 
 send_datacrc:
 	if (conn->conn_ops->DataDigest) {
-		struct kvec *iov_d =
-			&cmd->iov_data[cmd->iov_data_count];
+		struct kvec *iov_d = &cmd->iov_data[iov_off];
 
 		tx_sent = tx_data(conn, iov_d, 1, ISCSI_CRC_LEN);
 		if (ISCSI_CRC_LEN != tx_sent) {
-- 
1.7.2.5

