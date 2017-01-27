From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] target: Add WRITE_VERIFY_16 Support
Date: Fri, 27 Jan 2017 14:49:12 -0600
Message-ID: <1485550152-18623-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart.VanAssche@sandisk.com
Cc: nab@linux-iscsi.org, mikecyr@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

For clients who want to utilize more than 2GB you need
WRITE AND VERIFY 16 support.

Reported-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_sbc.c | 1 +
 include/scsi/scsi_proto.h        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 04f616b..e26acf2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -918,6 +918,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
+	case WRITE_VERIFY_16:
 	case WRITE_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index d1defd1..b39c321 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -112,6 +112,7 @@
 #define WRITE_16              0x8a
 #define READ_ATTRIBUTE        0x8c
 #define WRITE_ATTRIBUTE	      0x8d
+#define WRITE_VERIFY_16	      0x8e
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
-- 
2.5.4 (Apple Git-61)
