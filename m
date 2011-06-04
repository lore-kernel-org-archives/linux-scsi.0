From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/7] iscsi-target: Fix iscsit_fe_sendpage_sg breakage
Date: Fri,  3 Jun 2011 18:18:17 -0700
Message-ID: <1307150298-23921-7-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm21.access.bullet.mail.mud.yahoo.com ([66.94.237.222]:25946
	"HELO nm21.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754192Ab1FDBTK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:19:10 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

The patch fixes iscsit_fe_sendpage_sg() to follow iscsit_map_iovec() usage of
cmd->first_data_sg_off for the iSCSI data sequence offset into the first page,
along with individual sg->offset set for SCF_SCSI_CONTROL_NONSG_IO_CDB in
iscsit_alloc_buffs().

It also fixes the padding and DataDigest iovec offsets to use the updated
cmd->iov_data_count in iscsit_allocate_iovecs().

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index c6219e5..7eeddd2 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1277,12 +1277,11 @@ int iscsit_fe_sendpage_sg(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
 {
-	int tx_sent;
-	u32 tx_hdr_size;
-	u32 data_len;
-	struct kvec iov;
 	struct scatterlist *sg = cmd->first_data_sg;
+	struct kvec iov;
+	u32 tx_hdr_size, data_len;
 	u32 offset = cmd->first_data_sg_off;
+	int tx_sent;
 
 send_hdr:
 	tx_hdr_size = ISCSI_HDR_LEN;
@@ -1313,7 +1312,7 @@ send_hdr:
 		u32 sub_len = min_t(u32, data_len, space);
 send_pg:
 		tx_sent = conn->sock->ops->sendpage(conn->sock,
-						    sg_page(sg), offset, sub_len, 0);
+					sg_page(sg), sg->offset + offset, sub_len, 0);
 		if (tx_sent != sub_len) {
 			if (tx_sent == -EAGAIN) {
 				printk(KERN_ERR "tcp_sendpage() returned"
@@ -1328,13 +1327,13 @@ send_pg:
 
 		data_len -= sub_len;
 		offset = 0;
-		sg++;
+		sg = sg_next(sg);
 	}
 
 send_padding:
 	if (cmd->padding) {
 		struct kvec *iov_p =
-			&cmd->iov_data[cmd->iov_data_count-2];
+			&cmd->iov_data[cmd->iov_data_count-1];
 
 		tx_sent = tx_data(conn, iov_p, 1, cmd->padding);
 		if (cmd->padding != tx_sent) {
@@ -1349,7 +1348,7 @@ send_padding:
 send_datacrc:
 	if (conn->conn_ops->DataDigest) {
 		struct kvec *iov_d =
-			&cmd->iov_data[cmd->iov_data_count-1];
+			&cmd->iov_data[cmd->iov_data_count];
 
 		tx_sent = tx_data(conn, iov_d, 1, ISCSI_CRC_LEN);
 		if (ISCSI_CRC_LEN != tx_sent) {
-- 
1.7.2.5

