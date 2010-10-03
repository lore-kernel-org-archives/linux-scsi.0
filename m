From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add support for SA WRITE_SAME_32
Date: Sat,  2 Oct 2010 18:20:06 -0700
Message-ID: <1286068806-21458-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings mkp, boaz and co,

This patch adds support for service action WRITE_SAME_32 into
transport_generic_cmd_sequencer() to allow both emulate_tpws=1 with
TCM IBLOCK+FILEIO WRITE_SAME_32 w/ UNMAP=1 and existing TCM/pSCSI passthrough to
function.  This has been briefly tested 'sg_write_same -T' with TCM_Loop ->
TCM/FILEIO -> scsi_debug:

	sg_write_same --xferlen=4096 -T -U -v -v --lba=1024 --num=8 /dev/bsg/9\:0\:1\:0
	open /dev/bsg/9:0:1:0 with flags=0x802
	Default data-out buffer to 4096 zeroes
	    Write same(32) cmd: 7f 00 00 00 00 00 00 18 00 0d 08 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 08
	    Data-out buffer length=4096

Comments are welcome!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   40 ++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 445fbc3..39bbf57 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5856,6 +5856,46 @@ static int transport_generic_cmd_sequencer(
 			T_TASK(cmd)->t_tasks_fua = (cdb[10] & 0x8);
 			ret = TGCS_DATA_SG_IO_CDB;	
 			break;
+		case WRITE_SAME_32:
+			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
+			if (sector_ret)
+				return TGCS_UNSUPPORTED_CDB;
+			size = transport_get_size(sectors, cdb, cmd);
+			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+			transport_get_maps(cmd);
+			cmd->transport_split_cdb = &split_cdb_XX_32;
+			cmd->transport_get_long_lba = &transport_lba_64_ext;
+			/*
+			 * Skip the remaining assignments for TCM/PSCSI passthrough
+			 */
+			if (passthrough) {
+				ret = TGCS_DATA_SG_IO_CDB;
+				break;
+			}
+			if ((cdb[10] & 0x04) || (cdb[10] & 0x02)) {
+				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
+					" bits not supported for Block Discard"
+					" Emulation\n");
+				return TGCS_INVALID_CDB_FIELD;
+			}
+			/*
+			 * Currently for the emulated case we only accept
+			 * tpws with the UNMAP=1 bit set.
+			 */
+			if (!(cdb[10] & 0x08)) {
+				printk(KERN_ERR "WRITE_SAME w/ UNMAP bit not"
+					" supported for Block Discard Emulation\n");
+				return TGCS_INVALID_CDB_FIELD;
+			}
+			
+			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_WRITE_SAME;
+			/*
+			 * Signal to TCM IBLOCK+FILEIO subsystem plugins that WRITE
+			 * tasks will be translated to SCSI UNMAP -> Block Discard
+			 */
+			T_TASK(cmd)->t_tasks_unmap = 1;
+			ret = TGCS_DATA_SG_IO_CDB;	
+			break;
 		default:
 			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
 				" 0x%04x not supported\n", service_action);
-- 
1.5.6.5
