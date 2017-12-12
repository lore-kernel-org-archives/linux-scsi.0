From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] target: cxgbit: Combine substrings for 11 messages
Date: Tue, 12 Dec 2017 13:23:28 +0100
Message-ID: <5cb63750-250e-2eff-c06e-7c9083dd4919@users.sourceforge.net>
References: <77d06f1c-a650-644f-7364-55bb52aeb6ac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <77d06f1c-a650-644f-7364-55bb52aeb6ac@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Johannes Berg <johannes.berg@intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 12:57:47 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 50 +++++++++--------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 9163152b6d0b..e4a0dbc8fb9d 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -881,9 +881,7 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		pr_err("ImmediateData CRC32C DataDigest error\n");
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " Immediate Data digest failure while"
-			       " in ERL=0.\n");
+			pr_err("Unable to recover from Immediate Data digest failure while in ERL=0.\n");
 			iscsit_reject_cmd(cmd, ISCSI_REASON_DATA_DIGEST_ERROR,
 					  (unsigned char *)hdr);
 			return IMMEDIATE_DATA_CANNOT_RECOVER;
@@ -1054,19 +1052,14 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 	}
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
-		pr_err("ITT: 0x%08x, Offset: %u, Length: %u,"
-		       " DataSN: 0x%08x\n",
-		       hdr->itt, hdr->offset, data_len,
-		       hdr->datasn);
-
+		pr_err("ITT: 0x%08x, Offset: %u, Length: %u, DataSN: 0x%08x\n",
+		       hdr->itt, hdr->offset, data_len, hdr->datasn);
 		dcrc_err = true;
 		goto check_payload;
 	}
 
-	pr_debug("DataOut data_len: %u, "
-		"write_data_done: %u, data_length: %u\n",
-		  data_len,  cmd->write_data_done,
-		  cmd->se_cmd.data_length);
+	pr_debug("DataOut data_len: %u, write_data_done: %u, data_length: %u\n",
+		 data_len, cmd->write_data_done, cmd->se_cmd.data_length);
 
 	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
 		u32 skip = data_offset % PAGE_SIZE;
@@ -1102,9 +1095,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " NOPOUT Ping DataCRC failure while in"
-			       " ERL=0.\n");
+			pr_err("Unable to recover from NOPOUT Ping DataCRC failure while in ERL=0.\n");
 			ret = -1;
 			goto out;
 		} else {
@@ -1112,9 +1103,8 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			pr_info("Dropping NOPOUT"
-				" Command CmdSN: 0x%08x due to"
-				" DataCRC error.\n", hdr->cmdsn);
+			pr_info("Dropping NOPOUT Command CmdSN: 0x%08x due to DataCRC error.\n",
+				hdr->cmdsn);
 			ret = 0;
 			goto out;
 		}
@@ -1139,9 +1129,7 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 		 */
 		cmd->buf_ptr = ping_data;
 		cmd->buf_ptr_size = payload_length;
-
-		pr_debug("Got %u bytes of NOPOUT ping"
-			" data.\n", payload_length);
+		pr_debug("Got %u bytes of NOPOUT ping data.\n", payload_length);
 		pr_debug("Ping Data: \"%s\"\n", ping_data);
 	}
 
@@ -1168,18 +1156,15 @@ cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 
 	if (pdu_cb->flags & PDUCBF_RX_DCRC_ERR) {
 		if (!conn->sess->sess_ops->ErrorRecoveryLevel) {
-			pr_err("Unable to recover from"
-			       " Text Data digest failure while in"
-			       " ERL=0.\n");
+			pr_err("Unable to recover from Text Data digest failure while in ERL=0.\n");
 			goto reject;
 		} else {
 			/*
 			 * drop this PDU and let the
 			 * initiator plug the CmdSN gap.
 			 */
-			pr_info("Dropping Text"
-				" Command CmdSN: 0x%08x due to"
-				" DataCRC error.\n", hdr->cmdsn);
+			pr_info("Dropping Text Command CmdSN: 0x%08x due to DataCRC error.\n",
+				hdr->cmdsn);
 			return 0;
 		}
 	}
@@ -1302,8 +1287,8 @@ static int cxgbit_rx_opcode(struct cxgbit_sock *csk)
 	if (conn->sess->sess_ops->SessionType &&
 	    ((!(opcode & ISCSI_OP_TEXT)) ||
 	     (!(opcode & ISCSI_OP_LOGOUT)))) {
-		pr_err("Received illegal iSCSI Opcode: 0x%02x"
-			" while in Discovery Session, rejecting.\n", opcode);
+		pr_err("Received illegal iSCSI Opcode: 0x%02x while in Discovery Session, rejecting.\n",
+		       opcode);
 		iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
 				  (unsigned char *)hdr);
 		goto transport_err;
@@ -1327,9 +1312,7 @@ static int cxgbit_rx_login_pdu(struct cxgbit_sock *csk)
 
 	login_req = (struct iscsi_login_req *)login->req;
 	memcpy(login_req, pdu_cb->hdr, sizeof(*login_req));
-
-	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x, CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
 		login_req->flags, login_req->itt, login_req->cmdsn,
 		login_req->exp_statsn, login_req->cid, pdu_cb->dlen);
 	/*
@@ -1394,8 +1377,7 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 		skb, lro_cb->csk, lro_cb->pdu_idx, lro_cb->pdu_totallen);
 
 	for (i = 0; i < lro_cb->pdu_idx; i++, pdu_cb++)
-		pr_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, "
-			"frags %u.\n",
+		pr_info("skb 0x%p, pdu %d, %u, f 0x%x, seq 0x%x, dcrc 0x%x, frags %u.\n",
 			skb, i, pdu_cb->pdulen, pdu_cb->flags, pdu_cb->seq,
 			pdu_cb->ddigest, pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
-- 
2.15.1

