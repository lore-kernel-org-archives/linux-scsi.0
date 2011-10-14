From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 08/37] iscsi-target: always call transport_handle_cdb_direct
Date: Fri, 14 Oct 2011 00:41:40 +0000
Message-ID: <1318552929-13341-9-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

iscsit_task_reassign_complete is always called from the TX thread, so
handle the CDB directly instead of offloading it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_tmr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index db1fe1e..c3617d8 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -318,7 +318,7 @@ static int iscsit_task_reassign_complete_read(
 		pr_debug("READ ITT: 0x%08x: t_state: %d never sent to"
 			" transport\n", cmd->init_task_tag,
 			cmd->se_cmd.t_state);
-		transport_generic_handle_cdb(se_cmd);
+		transport_handle_cdb_direct(se_cmd);
 		return 0;
 	}
 
-- 
1.5.6.5
