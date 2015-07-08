From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v4 2/5] target: Split transport_send_check_condition_and_sense()
Date: Wed,  8 Jul 2015 17:58:51 +0300
Message-ID: <1436367534-15995-3-git-send-email-sagig@mellanox.com>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

Move the code for translating a sense_reason_t code into a SCSI status
ASC and ASCQ codes from transport_send_check_condition_and_sense() into
the new function translate_sense_reason(). Convert the switch statement
that performs the translation into table-driven code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 383 +++++++++++++--------------------
 1 file changed, 148 insertions(+), 235 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e895156..31373f3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2633,13 +2633,155 @@ void transport_err_sector_info(unsigned char *buffer, sector_t bad_sector)
 	put_unaligned_be64(bad_sector, &buffer[12]);
 }
 
+struct sense_info {
+	u8 key;
+	u8 asc;
+	u8 ascq;
+	bool add_sector_info;
+};
+
+static const struct sense_info sense_info_table[] = {
+	[TCM_NO_SENSE] = {
+		.key = NOT_READY
+	},
+	[TCM_NON_EXISTENT_LUN] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x25 /* LOGICAL UNIT NOT SUPPORTED */
+	},
+	[TCM_UNSUPPORTED_SCSI_OPCODE] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x20, /* INVALID COMMAND OPERATION CODE */
+	},
+	[TCM_SECTOR_COUNT_TOO_MANY] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x20, /* INVALID COMMAND OPERATION CODE */
+	},
+	[TCM_UNKNOWN_MODE_PAGE] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x24, /* INVALID FIELD IN CDB */
+	},
+	[TCM_CHECK_CONDITION_ABORT_CMD] = {
+		.key = ABORTED_COMMAND,
+		.asc = 0x29, /* BUS DEVICE RESET FUNCTION OCCURRED */
+		.ascq = 0x03,
+	},
+	[TCM_INCORRECT_AMOUNT_OF_DATA] = {
+		.key = ABORTED_COMMAND,
+		.asc = 0x0c, /* WRITE ERROR */
+		.ascq = 0x0d, /* NOT ENOUGH UNSOLICITED DATA */
+	},
+	[TCM_INVALID_CDB_FIELD] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x24, /* INVALID FIELD IN CDB */
+	},
+	[TCM_INVALID_PARAMETER_LIST] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x26, /* INVALID FIELD IN PARAMETER LIST */
+	},
+	[TCM_PARAMETER_LIST_LENGTH_ERROR] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x1a, /* PARAMETER LIST LENGTH ERROR */
+	},
+	[TCM_UNEXPECTED_UNSOLICITED_DATA] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x0c, /* WRITE ERROR */
+		.ascq = 0x0c, /* UNEXPECTED_UNSOLICITED_DATA */
+	},
+	[TCM_SERVICE_CRC_ERROR] = {
+		.key = ABORTED_COMMAND,
+		.asc = 0x47, /* PROTOCOL SERVICE CRC ERROR */
+		.ascq = 0x05, /* N/A */
+	},
+	[TCM_SNACK_REJECTED] = {
+		.key = ABORTED_COMMAND,
+		.asc = 0x11, /* READ ERROR */
+		.ascq = 0x13, /* FAILED RETRANSMISSION REQUEST */
+	},
+	[TCM_WRITE_PROTECTED] = {
+		.key = DATA_PROTECT,
+		.asc = 0x27, /* WRITE PROTECTED */
+	},
+	[TCM_ADDRESS_OUT_OF_RANGE] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x21, /* LOGICAL BLOCK ADDRESS OUT OF RANGE */
+	},
+	[TCM_CHECK_CONDITION_UNIT_ATTENTION] = {
+		.key = UNIT_ATTENTION,
+	},
+	[TCM_CHECK_CONDITION_NOT_READY] = {
+		.key = NOT_READY,
+	},
+	[TCM_MISCOMPARE_VERIFY] = {
+		.key = MISCOMPARE,
+		.asc = 0x1d, /* MISCOMPARE DURING VERIFY OPERATION */
+		.ascq = 0x00,
+	},
+	[TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x10,
+		.ascq = 0x01, /* LOGICAL BLOCK GUARD CHECK FAILED */
+		.add_sector_info = true,
+	},
+	[TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x10,
+		.ascq = 0x02, /* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
+		.add_sector_info = true,
+	},
+	[TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED] = {
+		.key = ILLEGAL_REQUEST,
+		.asc = 0x10,
+		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
+		.add_sector_info = true,
+	},
+	[TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE] = {
+		/*
+		 * Returning ILLEGAL REQUEST would cause immediate IO errors on
+		 * Solaris initiators.  Returning NOT READY instead means the
+		 * operations will be retried a finite number of times and we
+		 * can survive intermittent errors.
+		 */
+		.key = NOT_READY,
+		.asc = 0x08, /* LOGICAL UNIT COMMUNICATION FAILURE */
+	},
+};
+
+static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
+{
+	const struct sense_info *si;
+	u8 *buffer = cmd->sense_buffer;
+	int r = (__force int)reason;
+	u8 asc, ascq;
+
+	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
+		si = &sense_info_table[r];
+	else
+		si = &sense_info_table[(__force int)
+				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
+
+	buffer[SPC_SENSE_KEY_OFFSET] = si->key;
+	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
+		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
+		WARN_ON_ONCE(asc == 0);
+	} else if (si->asc == 0) {
+		WARN_ON_ONCE(cmd->scsi_asc == 0);
+		asc = cmd->scsi_asc;
+		ascq = cmd->scsi_ascq;
+	} else {
+		asc = si->asc;
+		ascq = si->ascq;
+	}
+	buffer[SPC_ASC_KEY_OFFSET] = asc;
+	buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+	if (si->add_sector_info)
+		transport_err_sector_info(cmd->sense_buffer, cmd->bad_sector);
+}
+
 int
 transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		sense_reason_t reason, int from_transport)
 {
-	unsigned char *buffer = cmd->sense_buffer;
 	unsigned long flags;
-	u8 asc = 0, ascq = 0;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
@@ -2649,242 +2791,13 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 	cmd->se_cmd_flags |= SCF_SENT_CHECK_CONDITION;
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	if (!reason && from_transport)
-		goto after_reason;
-
-	if (!from_transport)
+	if (!from_transport) {
 		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
-
-	/*
-	 * Actual SENSE DATA, see SPC-3 7.23.2  SPC_SENSE_KEY_OFFSET uses
-	 * SENSE KEY values from include/scsi/scsi.h
-	 */
-	switch (reason) {
-	case TCM_NO_SENSE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* Not Ready */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		/* NO ADDITIONAL SENSE INFORMATION */
-		buffer[SPC_ASC_KEY_OFFSET] = 0;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0;
-		break;
-	case TCM_NON_EXISTENT_LUN:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL UNIT NOT SUPPORTED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x25;
-		break;
-	case TCM_UNSUPPORTED_SCSI_OPCODE:
-	case TCM_SECTOR_COUNT_TOO_MANY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID COMMAND OPERATION CODE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x20;
-		break;
-	case TCM_UNKNOWN_MODE_PAGE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID FIELD IN CDB */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x24;
-		break;
-	case TCM_CHECK_CONDITION_ABORT_CMD:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* BUS DEVICE RESET FUNCTION OCCURRED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x29;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
-		break;
-	case TCM_INCORRECT_AMOUNT_OF_DATA:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* WRITE ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x0c;
-		/* NOT ENOUGH UNSOLICITED DATA */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x0d;
-		break;
-	case TCM_INVALID_CDB_FIELD:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID FIELD IN CDB */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x24;
-		break;
-	case TCM_INVALID_PARAMETER_LIST:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID FIELD IN PARAMETER LIST */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x26;
-		break;
-	case TCM_PARAMETER_LIST_LENGTH_ERROR:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* PARAMETER LIST LENGTH ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x1a;
-		break;
-	case TCM_UNEXPECTED_UNSOLICITED_DATA:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* WRITE ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x0c;
-		/* UNEXPECTED_UNSOLICITED_DATA */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x0c;
-		break;
-	case TCM_SERVICE_CRC_ERROR:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* PROTOCOL SERVICE CRC ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x47;
-		/* N/A */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x05;
-		break;
-	case TCM_SNACK_REJECTED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* READ ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x11;
-		/* FAILED RETRANSMISSION REQUEST */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x13;
-		break;
-	case TCM_WRITE_PROTECTED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* DATA PROTECT */
-		buffer[SPC_SENSE_KEY_OFFSET] = DATA_PROTECT;
-		/* WRITE PROTECTED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x27;
-		break;
-	case TCM_ADDRESS_OUT_OF_RANGE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK ADDRESS OUT OF RANGE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x21;
-		break;
-	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* UNIT ATTENTION */
-		buffer[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
-		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
-		buffer[SPC_ASC_KEY_OFFSET] = asc;
-		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
-		break;
-	case TCM_CHECK_CONDITION_NOT_READY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* Not Ready */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		buffer[SPC_ASC_KEY_OFFSET] = cmd->scsi_asc;
-		buffer[SPC_ASCQ_KEY_OFFSET] = cmd->scsi_ascq;
-		break;
-	case TCM_MISCOMPARE_VERIFY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		buffer[SPC_SENSE_KEY_OFFSET] = MISCOMPARE;
-		/* MISCOMPARE DURING VERIFY OPERATION */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
-		break;
-	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK GUARD CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x01;
-		transport_err_sector_info(buffer, cmd->bad_sector);
-		break;
-	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x02;
-		transport_err_sector_info(buffer, cmd->bad_sector);
-		break;
-	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
-		transport_err_sector_info(buffer, cmd->bad_sector);
-		break;
-	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
-	default:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/*
-		 * Returning ILLEGAL REQUEST would cause immediate IO errors on
-		 * Solaris initiators.  Returning NOT READY instead means the
-		 * operations will be retried a finite number of times and we
-		 * can survive intermittent errors.
-		 */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x08;
-		break;
+		translate_sense_reason(cmd, reason);
+		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	}
-	/*
-	 * This code uses linux/include/scsi/scsi.h SAM status codes!
-	 */
-	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
-	/*
-	 * Automatically padded, this value is encoded in the fabric's
-	 * data_length response PDU containing the SCSI defined sense data.
-	 */
-	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 
-after_reason:
 	trace_target_cmd_complete(cmd);
 	return cmd->se_tfo->queue_status(cmd);
 }
-- 
1.8.4.3
