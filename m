From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: improve unsupported opcode message
Date: Wed, 22 Jul 2015 15:01:36 -0700
Message-ID: <1437602500-3793-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Joern Engel <joern@purestorage.com>

Make the warning about unsupported SCSI opcode more useful:

 - Add in the initiator name so we know who's sending it.
 - Print the warning even for opcodes that spc_parse_cdb() knows about
   but that we don't handle.

Signed-off-by: Joern Engel <joern@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_spc.c       | 3 ---
 drivers/target/target_core_transport.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index b074443..87d4adb 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1405,9 +1405,6 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		}
 		break;
 	default:
-		pr_warn("TARGET_CORE[%s]: Unsupported SCSI Opcode"
-			" 0x%02x, sending CHECK_CONDITION.\n",
-			cmd->se_tfo->get_fabric_name(), cdb[0]);
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce8574b..ac002a7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1246,6 +1246,11 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 	}
 
 	ret = dev->transport->parse_cdb(cmd);
+	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
+		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
+				    cmd->se_tfo->get_fabric_name(),
+				    cmd->se_sess->se_node_acl->initiatorname,
+				    cmd->t_task_cdb[0]);
 	if (ret)
 		return ret;
 
-- 
2.5.0.rc3
