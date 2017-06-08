From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Reject immediate data underflow larger than SCSI transfer length
Date: Thu,  8 Jun 2017 04:21:25 +0000
Message-ID: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

When iscsi WRITE underflow occurs there are two different scenarios
that can happen.

Normally in practice, when an EDTL vs. SCSI CDB TRANSFER LENGTH
underflow is detected, the iscsi immediate data payload is the
smaller SCSI CDB TRANSFER LENGTH.

That is, when a host fabric LLD is using a fixed size EDTL for
a specific control CDB, the SCSI CDB TRANSFER LENGTH and actual
SCSI payload ends up being smaller than EDTL.  In iscsi, this
means the received iscsi immediate data payload matches the
smaller SCSI CDB TRANSFER LENGTH, because there is no more
SCSI payload to accept beyond SCSI CDB TRANSFER LENGTH.

However, it's possible for a malicous host to send a WRITE
underflow where EDTL is larger than SCSI CDB TRANSFER LENGTH,
but incoming iscsi immediate data actually matches EDTL.

In the wild, we've never had a iscsi host environment actually
try to do this.

For this special case, it's wrong to truncate part of the
control CDB payload and continue to process the command during
underflow when immediate data payload received was larger than
SCSI CDB TRANSFER LENGTH, so go ahead and reject and drop the
bogus payload as a defensive action.

Note this potential bug was originally relaxed by the following
for allowing WRITE underflow in MSFT FCP host environments:

   commit c72c5250224d475614a00c1d7e54a67f77cd3410
   Author: Roland Dreier <roland@purestorage.com>
   Date:   Wed Jul 22 15:08:18 2015 -0700

      target: allow underflow/overflow for PR OUT etc. commands

Cc: Roland Dreier <roland@purestorage.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c025451..3fdca2c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1279,6 +1279,18 @@ int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 */
 	if (dump_payload)
 		goto after_immediate_data;
+	/*
+	 * Check for underflow case where both EDTL and immediate data payload
+	 * exceeds what is presented by CDB's TRANSFER LENGTH, and what has
+	 * already been set in target_cmd_size_check() as se_cmd->data_length.
+	 *
+	 * For this special case, fail the command and dump the immediate data
+	 * payload.
+	 */
+	if (cmd->first_burst_len > cmd->se_cmd.data_length) {
+		cmd->sense_reason = TCM_INVALID_CDB_FIELD;
+		goto after_immediate_data;
+	}
 
 	immed_ret = iscsit_handle_immediate_data(cmd, hdr,
 					cmd->first_burst_len);
-- 
1.9.1
