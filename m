From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 26/34] iscsi-target: fix seq_end_offset calculation
Date: Sun, 14 Feb 2016 23:15:33 +0530
Message-ID: <8e459f0479d704dbe7693a06a4c51162cecec457.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:44711 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751485AbcBNRqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:46:06 -0500
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

In case of unsolicited data, seq end offset for first
sequence must be equal to the min of firstburstlength
and data length.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 4a66317..9345cc2 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -44,10 +44,10 @@ void iscsit_set_dataout_sequence_values(
 	 */
 	if (cmd->unsolicited_data) {
 		cmd->seq_start_offset = cmd->write_data_done;
-		cmd->seq_end_offset = (cmd->write_data_done +
-			((cmd->se_cmd.data_length >
+		cmd->seq_end_offset = (cmd->se_cmd.data_length >
 			  conn->sess->sess_ops->FirstBurstLength) ?
-			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length));
+			 conn->sess->sess_ops->FirstBurstLength :
+			 cmd->se_cmd.data_length;
 		return;
 	}
 
-- 
2.0.2

