From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/6] iscsi-target: Fix non-immediate TMR reference leak
Date: Wed,  8 Nov 2017 04:31:52 +0000
Message-ID: <1510115512-15617-7-git-send-email-nab@linux-iscsi.org>
References: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54052 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdKHEVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 23:21:41 -0500
In-Reply-To: <1510115512-15617-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a se_cmd->cmd_kref reference leak that can
occur when a non immediate TMR is proceeded our of command
sequence number order, and CMDSN_LOWER_THAN_EXP is returned
by iscsit_sequence_cmd().

To address this bug, call target_put_sess_cmd() during this
special case following what iscsit_process_scsi_cmd() does
upon CMDSN_LOWER_THAN_EXP.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 048d422..3b7bb58 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2094,12 +2094,14 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 
 	if (!(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
 		int cmdsn_ret = iscsit_sequence_cmd(conn, cmd, buf, hdr->cmdsn);
-		if (cmdsn_ret == CMDSN_HIGHER_THAN_EXP)
+		if (cmdsn_ret == CMDSN_HIGHER_THAN_EXP) {
 			out_of_order_cmdsn = 1;
-		else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
+		} else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
+			target_put_sess_cmd(&cmd->se_cmd);
 			return 0;
-		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+		} else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) {
 			return -1;
+		}
 	}
 	iscsit_ack_from_expstatsn(conn, be32_to_cpu(hdr->exp_statsn));
 
-- 
1.9.1
