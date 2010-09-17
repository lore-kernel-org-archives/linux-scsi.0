From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm: Add VARIABLE_LENGTH_CMD support w/ XDWRITE_READ_32 emulation
Date: Thu, 16 Sep 2010 22:34:55 -0700
Message-ID: <1284701695-18367-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:44283 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754171Ab0IQFe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 01:34:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mi
Cc: Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates transport_generic_cmd_sequencer() to properly support
VARIABLE_LENGTH_CMD w/ service action XDWRITE_READ_32 emulation.  This
patch follows the original XDWRITE_READ_10 patch, and uses the new 32-byte
CDB extraction callers from commit 39a347ca2d88.  Note this patch uses the
same transport_xor_callback() assignment callback as XDWRITE_READ_10.

Also note that this patch enforces the following > TCM_MAX_COMMAND_SIZE check
for VARIABLE_LENGTH_CMD CDBs in transport_generic_cmd_sequencer():

	<SNIP>
        /*
         * Check the additional CDB length (+ 8 bytes for header) does
         * not exceed our TCM_MAX_COMMAND_SIZE.
         */
         if ((cdb[7] + 8) > TCM_MAX_COMMAND_SIZE) {
                printk(KERN_INFO "Only %u-byte extended CDBs currently"
                         " supported for VARIABLE_LENGTH_CMD, received:"
                         " %d for service action: 0x%04x\n",
                         TCM_MAX_COMMAND_SIZE, cdb[7], service_action);
                return TGCS_INVALID_CDB_FIELD;
         }
	<SNIP>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   50 +++++++++++++++++++++++++++----
 1 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a3016f7..a20a4a9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5401,6 +5401,7 @@ static int transport_generic_cmd_sequencer(
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	int ret, sector_ret = 0;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
+	u16 service_action;
 	u8 alua_ascq = 0;
 	/*
 	 * Check for an existing UNIT ATTENTION condition
@@ -5572,6 +5573,48 @@ static int transport_generic_cmd_sequencer(
 		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
 		ret = TGCS_DATA_SG_IO_CDB;
 		break;
+	case VARIABLE_LENGTH_CMD:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		service_action = (cdb[8] << 8) | cdb[9];
+		/*
+		 * Check the additional CDB length (+ 8 bytes for header) does
+		 * not exceed our TCM_MAX_COMMAND_SIZE.
+		 */
+		if ((cdb[7] + 8) > TCM_MAX_COMMAND_SIZE) {
+			printk(KERN_INFO "Only %u-byte extended CDBs currently"
+				" supported for VARIABLE_LENGTH_CMD, received:"
+				" %d for service action: 0x%04x\n",
+				TCM_MAX_COMMAND_SIZE, cdb[7], service_action);
+			return TGCS_INVALID_CDB_FIELD;
+		}
+		switch (service_action) {
+		case 0x0007: /* XDWRITE_READ_32 */
+			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
+			if (sector_ret)
+				return TGCS_UNSUPPORTED_CDB;
+			size = transport_get_size(sectors, cdb, cmd);
+			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+			transport_get_maps(cmd);
+			/*
+			 * Use WRITE_32 and READ_32 opcodes for the emulated
+			 * XDWRITE_READ_32 logic.
+			 */
+			cmd->transport_split_cdb = &split_cdb_XX_32;
+			cmd->transport_get_long_lba = &transport_lba_64_ext;
+			/*
+			 * Setup BIDI XOR callback to be run during
+			 * transport_generic_complete_ok()
+			 */
+			cmd->transport_complete_callback = &transport_xor_callback;
+			T_TASK(cmd)->t_tasks_fua = (cdb[10] & 0x8);
+			ret = TGCS_DATA_SG_IO_CDB;	
+			break;
+		default:
+			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
+				" 0x%04x not supported\n", service_action);
+			return TGCS_UNSUPPORTED_CDB;
+		}
+		break;
 	case 0xa3:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
 		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
@@ -5747,13 +5790,6 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
-	case VARIABLE_LENGTH_CMD:
-		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
-		size = (cdb[10] << 8) | cdb[11];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
-		transport_get_maps(cmd);
-		ret = TGCS_CONTROL_NONSG_IO_CDB;
-		break;
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
 		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
-- 
1.5.6.5

