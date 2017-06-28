From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/5] target: Use macro for WRITE_VERIFY_xx operation codes
Date: Wed, 28 Jun 2017 14:58:56 +0900
Message-ID: <20170628055900.22889-2-damien.lemoal@wdc.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39551 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdF1F7i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 01:59:38 -0400
In-Reply-To: <20170628055900.22889-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A . Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

Add WRITE_VERIFY_32 definition to scsi prototypes and use this macro
definition isntead of the hard coded value. Same for the already defined
WRITE_VERIFY_16 command code.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_device.c | 4 ++--
 include/scsi/scsi_proto.h           | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8add07f38..15dcbb9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1126,7 +1126,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	case WRITE_16:
 	case WRITE_VERIFY:
 	case WRITE_VERIFY_12:
-	case 0x8e: /* WRITE_VERIFY_16 */
+	case WRITE_VERIFY_16:
 	case COMPARE_AND_WRITE:
 	case XDWRITEREAD_10:
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -1135,7 +1135,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 		switch (get_unaligned_be16(&cdb[8])) {
 		case READ_32:
 		case WRITE_32:
-		case 0x0c: /* WRITE_VERIFY_32 */
+		case WRITE_VERIFY_32:
 		case XDWRITEREAD_32:
 			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 			break;
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index ce78ec8..5e3fe03 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -161,6 +161,7 @@
 #define READ_32		      0x09
 #define VERIFY_32	      0x0a
 #define WRITE_32	      0x0b
+#define WRITE_VERIFY_32	      0x0c
 #define WRITE_SAME_32	      0x0d
 
 /* Values for T10/04-262r7 */
-- 
2.9.4
