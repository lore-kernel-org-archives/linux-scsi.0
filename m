From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH RFC] target: Use scsi helpers to build the sense data correctly
Date: Mon, 29 Jun 2015 18:05:25 +0300
Message-ID: <1435590325-23381-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [193.47.165.129] ([193.47.165.129]:52082 "EHLO mellanox.co.il"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753382AbbF2PFx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 11:05:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>

Instead of open coding the sense buffer construction, use
scsi scsi_build_sense_buffer() and scsi_set_sense_information()
helpers.

This patch also fixes wrong setting of descriptor format sense data
for t10-pi integrity errors.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_spc.c       |  30 +----
 drivers/target/target_core_transport.c | 202 ++++-----------------------------
 include/target/target_core_base.h      |   9 +-
 3 files changed, 30 insertions(+), 211 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index a2b377e..08114bf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1156,32 +1156,10 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	if (!rbuf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq)) {
-		/*
-		 * CURRENT ERROR, UNIT ATTENTION
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
-
-		/*
-		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = ua_asc;
-		buf[SPC_ASCQ_KEY_OFFSET] = ua_ascq;
-		buf[7] = 0x0A;
-	} else {
-		/*
-		 * CURRENT ERROR, NO SENSE
-		 */
-		buf[0] = 0x70;
-		buf[SPC_SENSE_KEY_OFFSET] = NO_SENSE;
-
-		/*
-		 * NO ADDITIONAL SENSE INFORMATION
-		 */
-		buf[SPC_ASC_KEY_OFFSET] = 0x00;
-		buf[7] = 0x0A;
-	}
+	if (!core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))
+		scsi_build_sense_buffer(0, buf, UNIT_ATTENTION, ua_asc, ua_ascq);
+	else
+		scsi_build_sense_buffer(0, buf, NO_SENSE, 0x0, 0x0);
 
 	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
 	transport_kunmap_data_sg(cmd);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ea83dd26..33ade5f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2708,18 +2708,6 @@ static int transport_get_sense_codes(
 	return 0;
 }
 
-static
-void transport_err_sector_info(unsigned char *buffer, sector_t bad_sector)
-{
-	/* Place failed LBA in sense data information descriptor 0. */
-	buffer[SPC_DESC_TYPE_OFFSET] = 0; /* Information */
-	buffer[SPC_ADDITIONAL_DESC_LEN_OFFSET] = 0xa;
-	buffer[SPC_VALIDITY_OFFSET] = 0x80;
-
-	/* Descriptor Information: failing sector */
-	put_unaligned_be64(bad_sector, &buffer[12]);
-}
-
 int
 transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		sense_reason_t reason, int from_transport)
@@ -2742,227 +2730,87 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 	if (!from_transport)
 		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 
-	/*
-	 * Actual SENSE DATA, see SPC-3 7.23.2  SPC_SENSE_KEY_OFFSET uses
-	 * SENSE KEY values from include/scsi/scsi.h
-	 */
+	/* Actual SENSE DATA, see SPC-3 7.23.2 */
 	switch (reason) {
 	case TCM_NO_SENSE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* Not Ready */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		/* NO ADDITIONAL SENSE INFORMATION */
-		buffer[SPC_ASC_KEY_OFFSET] = 0;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0;
+		scsi_build_sense_buffer(0, buffer, NOT_READY, 0x0, 0x0);
 		break;
 	case TCM_NON_EXISTENT_LUN:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT NOT SUPPORTED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x25;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x25, 0x0);
 		break;
 	case TCM_UNSUPPORTED_SCSI_OPCODE:
 	case TCM_SECTOR_COUNT_TOO_MANY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID COMMAND OPERATION CODE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x20;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x20, 0x0);
 		break;
 	case TCM_UNKNOWN_MODE_PAGE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID FIELD IN CDB */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x24;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x24, 0x0);
 		break;
 	case TCM_CHECK_CONDITION_ABORT_CMD:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* BUS DEVICE RESET FUNCTION OCCURRED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x29;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
+		scsi_build_sense_buffer(0, buffer, ABORTED_COMMAND, 0x29, 0x03);
 		break;
 	case TCM_INCORRECT_AMOUNT_OF_DATA:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* WRITE ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x0c;
-		/* NOT ENOUGH UNSOLICITED DATA */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x0d;
+		scsi_build_sense_buffer(0, buffer, ABORTED_COMMAND, 0x0c, 0x0d);
 		break;
 	case TCM_INVALID_CDB_FIELD:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID FIELD IN CDB */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x24;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x24, 0x0);
 		break;
 	case TCM_INVALID_PARAMETER_LIST:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* INVALID FIELD IN PARAMETER LIST */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x26;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x26, 0x0);
 		break;
 	case TCM_PARAMETER_LIST_LENGTH_ERROR:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* PARAMETER LIST LENGTH ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x1a;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x1a, 0x0);
 		break;
 	case TCM_UNEXPECTED_UNSOLICITED_DATA:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* WRITE ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x0c;
-		/* UNEXPECTED_UNSOLICITED_DATA */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x0c;
+		scsi_build_sense_buffer(0, buffer, ABORTED_COMMAND, 0x0c, 0x0c);
 		break;
 	case TCM_SERVICE_CRC_ERROR:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* PROTOCOL SERVICE CRC ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x47;
-		/* N/A */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x05;
+		scsi_build_sense_buffer(0, buffer, ABORTED_COMMAND, 0x47, 0x05);
 		break;
 	case TCM_SNACK_REJECTED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
-		/* READ ERROR */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x11;
-		/* FAILED RETRANSMISSION REQUEST */
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x13;
+		scsi_build_sense_buffer(0, buffer, ABORTED_COMMAND, 0x11, 0x13);
 		break;
 	case TCM_WRITE_PROTECTED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* DATA PROTECT */
-		buffer[SPC_SENSE_KEY_OFFSET] = DATA_PROTECT;
-		/* WRITE PROTECTED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x27;
+		scsi_build_sense_buffer(0, buffer, DATA_PROTECT, 0x27, 0x0);
 		break;
 	case TCM_ADDRESS_OUT_OF_RANGE:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK ADDRESS OUT OF RANGE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x21;
+		scsi_build_sense_buffer(0, buffer, ILLEGAL_REQUEST, 0x21, 0x0);
 		break;
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* UNIT ATTENTION */
-		buffer[SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
 		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
-		buffer[SPC_ASC_KEY_OFFSET] = asc;
-		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+		scsi_build_sense_buffer(0, buffer, UNIT_ATTENTION, asc, ascq);
 		break;
 	case TCM_CHECK_CONDITION_NOT_READY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* Not Ready */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
 		transport_get_sense_codes(cmd, &asc, &ascq);
-		buffer[SPC_ASC_KEY_OFFSET] = asc;
-		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
+		scsi_build_sense_buffer(0, buffer, NOT_READY, asc, ascq);
 		break;
 	case TCM_MISCOMPARE_VERIFY:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		buffer[SPC_SENSE_KEY_OFFSET] = MISCOMPARE;
-		/* MISCOMPARE DURING VERIFY OPERATION */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
+		scsi_build_sense_buffer(0, buffer, MISCOMPARE, 0x1d, 0x0);
 		break;
 	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		/* ADDITIONAL SENSE LENGTH */
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 0xc;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK GUARD CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x01;
-		transport_err_sector_info(buffer, cmd->bad_sector);
+		scsi_build_sense_buffer(1, buffer, ABORTED_COMMAND, 0x10, 0x01);
+		scsi_set_sense_information(buffer, cmd->bad_sector);
 		break;
 	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		/* ADDITIONAL SENSE LENGTH */
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 0xc;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x02;
-		transport_err_sector_info(buffer, cmd->bad_sector);
+		scsi_build_sense_buffer(1, buffer, ABORTED_COMMAND, 0x10, 0x02);
+		scsi_set_sense_information(buffer, cmd->bad_sector);
 		break;
 	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		/* ADDITIONAL SENSE LENGTH */
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 0xc;
-		/* ILLEGAL REQUEST */
-		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
-		/* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
-		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
-		transport_err_sector_info(buffer, cmd->bad_sector);
+		scsi_build_sense_buffer(1, buffer, ABORTED_COMMAND, 0x10, 0x03);
+		scsi_set_sense_information(buffer, cmd->bad_sector);
 		break;
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
-		/* CURRENT ERROR */
-		buffer[0] = 0x70;
-		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/*
 		 * Returning ILLEGAL REQUEST would cause immediate IO errors on
 		 * Solaris initiators.  Returning NOT READY instead means the
 		 * operations will be retried a finite number of times and we
 		 * can survive intermittent errors.
 		 */
-		buffer[SPC_SENSE_KEY_OFFSET] = NOT_READY;
-		/* LOGICAL UNIT COMMUNICATION FAILURE */
-		buffer[SPC_ASC_KEY_OFFSET] = 0x08;
+		scsi_build_sense_buffer(0, buffer, NOT_READY, 0x08, 0x00);
 		break;
 	}
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9524c97..b237c1a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -7,6 +7,7 @@
 #include <linux/blkdev.h>
 #include <linux/percpu_ida.h>
 #include <linux/t10-pi.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -31,14 +32,6 @@
  * defined 96, but the real limit is 252 (or 260 including the header)
  */
 #define TRANSPORT_SENSE_BUFFER			SCSI_SENSE_BUFFERSIZE
-/* Used by transport_send_check_condition_and_sense() */
-#define SPC_SENSE_KEY_OFFSET			2
-#define SPC_ADD_SENSE_LEN_OFFSET		7
-#define SPC_DESC_TYPE_OFFSET			8
-#define SPC_ADDITIONAL_DESC_LEN_OFFSET		9
-#define SPC_VALIDITY_OFFSET			10
-#define SPC_ASC_KEY_OFFSET			12
-#define SPC_ASCQ_KEY_OFFSET			13
 #define TRANSPORT_IQN_LEN			224
 /* Used by target_core_store_alua_lu_gp() and target_core_alua_lu_gp_show_attr_members() */
 #define LU_GROUP_NAME_BUF			256
-- 
1.8.4.3

