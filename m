From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 15/16] iscsi-target: fix seq_end_offset calculation
Date: Sat,  9 Apr 2016 18:41:25 +0530
Message-ID: <b89edcdd177e4d6f13bb1a565f837c3d79a10651.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:22467 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754734AbcDINOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Apr 2016 09:14:03 -0400
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
In-Reply-To: <cover.1460204441.git.varun@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com

In case of unsolicited data, seq end offset for first
sequence must be equal to the min of firstburstlength
and data length.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/iscsi_target_erl0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 210f6e4..a0fb5a8 100644
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

