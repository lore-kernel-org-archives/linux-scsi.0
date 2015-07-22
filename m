From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: allow underflow/overflow for PR OUT etc. commands
Date: Wed, 22 Jul 2015 15:08:18 -0700
Message-ID: <1437602898-15229-4-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

It's not necessarily a fatal error if a command with a data-out phase
has a data length that differs from the transport data length (e.g.
PERSISTENT RESERVE OUT might have a parameter list length in the CDB
that's smaller than the FC_DL field), so allow these commands.  The
Windows compliance test sends them.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ac002a7..f6626bb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1087,9 +1087,9 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
 				cmd->data_length, size, cmd->t_task_cdb[0]);
 
-		if (cmd->data_direction == DMA_TO_DEVICE) {
-			pr_err("Rejecting underflow/overflow"
-					" WRITE data\n");
+		if (cmd->data_direction == DMA_TO_DEVICE &&
+		    cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
+			pr_err("Rejecting underflow/overflow WRITE data\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 		/*
-- 
2.5.0.rc3
