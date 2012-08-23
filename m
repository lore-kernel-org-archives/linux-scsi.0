From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix ->data_length re-assignment bug with SCSI overflow
Date: Thu, 23 Aug 2012 22:26:11 +0000
Message-ID: <1345760771-17996-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60529 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2HWWaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2012 18:30:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, Boaz Harrosh <bharrosh@panasas.com>, stable@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a long-standing bug with SCSI overflow handling
where se_cmd->data_length was incorrectly being re-assigned to
the larger CDB extracted allocation length, resulting in a number
of fabric level errors that would end up causing a session reset
in most cases.  So instead now:

 - Only re-assign se_cmd->data_length durining UNDERFLOW (to use the
   smaller value)
 - Use existing se_cmd->data_length for OVERFLOW (to use the smaller
   value)

This fix has been tested with the following CDB to generate an
SCSI overflow:

  sg_raw -r512 /dev/sdc 28 0 0 0 0 0 0 0 9 0

Tested using iscsi-target, tcm_qla2xxx, loopback and tcm_vhost fabric
ports.  Here is a bit more detail on each case:

 - iscsi-target: Bug with open-iscsi with overflow, sg_raw returns
                 -3584 bytes of data.
 - tcm_qla2xxx: Working as expected, returnins 512 bytes of data
 - loopback: sg_raw returns CHECK_CONDITION, from overflow rejection
             in transport_generic_map_mem_to_cmd()
 - tcm_vhost: Same as loopback

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4de3186..3425098 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1181,15 +1181,20 @@ int target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
 			goto out_invalid_cdb_field;
 		}
-
+		/*
+		 * For the overflow case keep the existing fabric provided
+		 * ->data_length.  Otherwise for the underflow case, reset
+		 * ->data_length to the smaller SCSI expected data transfer
+		 * length.
+		 */
 		if (size > cmd->data_length) {
 			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
 			cmd->residual_count = (size - cmd->data_length);
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
 			cmd->residual_count = (cmd->data_length - size);
+			cmd->data_length = size;
 		}
-		cmd->data_length = size;
 	}
 
 	return 0;
-- 
1.7.2.5

