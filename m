From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] qla2xxx: Drop legacy target mode MODIFY_LUN_TYPE usage
Date: Thu,  9 Feb 2012 02:45:34 +0000
Message-ID: <1328755534-8668-3-git-send-email-nab@linux-iscsi.org>
References: <1328755534-8668-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1328755534-8668-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes remaining legacy IOCB Type Code MODIFY_LUN_TYPE 0x0C
and it's usage in qla_tgt_response_pkt() and other reponse handling.
Also drop modify_lun_t and other related defines.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Madhuranath Iyengar <mni@risingtidesystems.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_isr.c    |    1 -
 drivers/scsi/qla2xxx/qla_target.c |   25 -------------------------
 drivers/scsi/qla2xxx/qla_target.h |   30 ------------------------------
 3 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index accbf08..ed214b8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1377,7 +1377,6 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		case CTIO_A64_TYPE:
 		case IMMED_NOTIFY_TYPE:
 		case NOTIFY_ACK_TYPE:
-		case MODIFY_LUN_TYPE:
 			qla_tgt_response_pkt_all_vps(vha, (response_t *)pkt);
 			break;
 		case STATUS_TYPE:
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 90bb55e..c814205 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3808,31 +3808,6 @@ static void qla_tgt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		}
 		break;
 
-	case MODIFY_LUN_TYPE:
-		if (tgt->modify_lun_expected > 0) {
-			modify_lun_t *entry = (modify_lun_t *)pkt;
-			ql_dbg(ql_dbg_tgt, vha, 0xe030, "MODIFY_LUN %x, imm %c%d, cmd %c%d",
-				  entry->status,
-				  (entry->operators & MODIFY_LUN_IMM_ADD) ? '+'
-				  : (entry->operators & MODIFY_LUN_IMM_SUB) ? '-'
-				  : ' ',
-				  entry->immed_notify_count,
-				  (entry->operators & MODIFY_LUN_CMD_ADD) ? '+'
-				  : (entry->operators & MODIFY_LUN_CMD_SUB) ? '-'
-				  : ' ',
-				  entry->command_count);
-			tgt->modify_lun_expected--;
-			if (entry->status != MODIFY_LUN_SUCCESS) {
-				printk(KERN_ERR "qla_target(%d): MODIFY_LUN "
-					    "failed %x\n", vha->vp_idx,
-					    entry->status);
-			}
-		} else {
-			printk(KERN_ERR "qla_target(%d): Unexpected MODIFY_LUN "
-			    "received\n", (ha != NULL) ? vha->vp_idx : -1);
-		}
-		break;
-
 	default:
 		printk(KERN_ERR "qla_target(%d): Received unknown response pkt "
 		     "type %x\n", vha->vp_idx, pkt->entry_type);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 343fc1e..b98b923 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -108,36 +108,6 @@
 #define QLA_TGT_MAX_SG_24XX(ql) \
    (min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-
-#define MODIFY_LUN_TYPE 0x0C	  /* Modify LUN entry. */
-/*
- * ISP queue - modify LUN entry structure definition.
- */
-typedef struct {
-	uint8_t	 entry_type;		    /* Entry type. */
-	uint8_t	 entry_count;		    /* Entry count. */
-	uint8_t	 sys_define;		    /* System defined. */
-	uint8_t	 entry_status;		    /* Entry Status. */
-	uint32_t sys_define_2;		    /* System defined. */
-	uint8_t	 reserved_8;
-	uint8_t	 reserved_1;
-	uint8_t	 operators;
-	uint8_t	 reserved_2;
-	uint32_t reserved_3;
-	uint8_t	 status;
-	uint8_t	 reserved_4;
-	uint8_t	 command_count;		    /* Number of ATIOs allocated. */
-	uint8_t	 immed_notify_count;	    /* Number of Immediate Notify */
-	/* entries allocated. */
-	uint16_t reserved_5;
-	uint16_t timeout;		    /* 0 = 30 seconds, 0xFFFF = disable */
-	uint16_t reserved_7[20];
-} __attribute__((packed)) modify_lun_t;
-#define MODIFY_LUN_SUCCESS	0x01
-#define MODIFY_LUN_CMD_ADD BIT_0
-#define MODIFY_LUN_CMD_SUB BIT_1
-#define MODIFY_LUN_IMM_ADD BIT_2
-#define MODIFY_LUN_IMM_SUB BIT_3
 #endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))				\
-- 
1.7.2.5
