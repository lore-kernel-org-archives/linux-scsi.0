From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/7] [Target_Core_Mod]: Update core logic to use
	DEV_ATTRIB(dev)->block_size
Date: Fri, 20 Feb 2009 00:01:06 -0800
Message-ID: <1235116866.12375.1036.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:33040 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753298AbZBTICM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 03:02:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From f613324c94fd43569c8b7e90bda34b1465afd592 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:32:48 -0800
Subject: [PATCH 2/7] [Target_Core_Mod]: Update core logic to use DEV_ATTRIB(dev)->block_size

This patch updates dev_obj_blocksize(), dev_obj_get_cdb_size() in
target_core_seobj.c, and transport_generic_emulate_readcapacity() and
transport_generic_emulate_readcapacity_16() to use DEV_ATTRIB(dev)->block_size
for 4k sector/block size support.

This patch also adds a conditional to check for OVERFLOW/UNDERFLOW of LBA related
(READ_* and WRITE *) ops that causes a CHECK_CONDITION+INVALID_CDB_FIELD to be sent
when the OVERFLOW/UNDERFLOW is detected for *ONLY* SCF_SCSI_DATA_SG_IO_CDB type
ops with non 512-byte sectore/block sized devices.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_seobj.c     |   12 +++++--
 drivers/lio-core/target_core_transport.c |   48 ++++++++++++++++++------------
 drivers/lio-core/target_core_transport.h |    4 +-
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index 643659c..7a2e9ed 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -273,7 +273,7 @@ extern int dev_obj_blocksize (void *p)
 {
 	se_device_t *dev  = (se_device_t *)p;
 
-	return(TRANSPORT(dev)->get_blocksize(dev));
+	return(DEV_ATTRIB(dev)->block_size);
 }
 
 extern int dev_obj_max_sectors (void *p)
@@ -551,13 +551,19 @@ extern u32 dev_obj_get_cdb_size (
 
 	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
 		if (cdb[1] & 1) { /* sectors */
-			return(TRANSPORT(dev)->get_blocksize(dev) * sectors);
+			return(DEV_ATTRIB(dev)->block_size * sectors);
 		} else /* bytes */
 			return(sectors);
 	}
 	
 	/* sectors */
-	return(TRANSPORT(dev)->get_blocksize(dev) * sectors);
+#if 0
+	printk("Returning block_size: %u, sectors: %u == %u for %s object\n",
+			DEV_ATTRIB(dev)->block_size, sectors, 
+			DEV_ATTRIB(dev)->block_size * sectors,
+			TRANSPORT(dev)->name);
+#endif
+	return(DEV_ATTRIB(dev)->block_size * sectors);
 }
 
 extern void dev_obj_generate_cdb (void *p, unsigned long long lba, u32 *sectors, unsigned char *cdb, int rw)
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 8c6195e..4fae205 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -1473,7 +1473,7 @@ extern void transport_dump_dev_state (
 		atomic_read(&dev->execute_tasks), atomic_read(&dev->depth_left),
 		dev->queue_depth);
 	*bl += sprintf(b+*bl, "  SectorSize: %u  MaxSectors: %u\n",
-		TRANSPORT(dev)->get_blocksize(dev), DEV_ATTRIB(dev)->max_sectors);
+		DEV_ATTRIB(dev)->block_size, DEV_ATTRIB(dev)->max_sectors);
 	*bl += sprintf(b+*bl, "        ");
 
 	return;	
@@ -4386,28 +4386,28 @@ set_len:
 
 extern int transport_generic_emulate_readcapacity (
 	se_cmd_t *cmd, 
-	u32 blocks,
-	u32 blocksize)
+	u32 blocks)
 {
+	se_device_t *dev = SE_DEV(cmd);
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
 	buf[2] = (blocks >> 8) & 0xff;
 	buf[3] = blocks & 0xff;
-	buf[4] = (blocksize >> 24) & 0xff;
-	buf[5] = (blocksize >> 16) & 0xff;
-	buf[6] = (blocksize >> 8) & 0xff;
-	buf[7] = blocksize & 0xff;
+	buf[4] = (DEV_ATTRIB(dev)->block_size >> 24) & 0xff;
+	buf[5] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
+	buf[6] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
+	buf[7] = DEV_ATTRIB(dev)->block_size & 0xff;
 		
 	return(0);
 }
 
 extern int transport_generic_emulate_readcapacity_16 (
 	se_cmd_t *cmd,
-	unsigned long long blocks,
-	u32 blocksize)
+	unsigned long long blocks)
 {
+	se_device_t *dev = SE_DEV(cmd);
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 
 	buf[0] = (blocks >> 56) & 0xff;
@@ -4418,10 +4418,10 @@ extern int transport_generic_emulate_readcapacity_16 (
 	buf[5] = (blocks >> 16) & 0xff;
 	buf[6] = (blocks >> 8) & 0xff;
 	buf[7] = blocks & 0xff;
-	buf[8] = (blocksize >> 24) & 0xff;
-	buf[9] = (blocksize >> 16) & 0xff;
-	buf[10] = (blocksize >> 8) & 0xff;
-	buf[11] = blocksize & 0xff;
+	buf[8] = (DEV_ATTRIB(dev)->block_size >> 24) & 0xff;
+	buf[9] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
+	buf[10] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
+	buf[11] = DEV_ATTRIB(dev)->block_size & 0xff;
 
 	return(0);
 }
@@ -5024,8 +5024,8 @@ static int transport_generic_cmd_sequencer (
 		ret = 2;
 		break;
 	default:
-		TRACE_ERROR("TARGET_CORE[%s]: Unsupported SCSI Opcode 0x%02x,"
-			" sending CHECK_CONDITION.\n",
+		printk(KERN_WARNING "TARGET_CORE[%s]: Unsupported SCSI Opcode"
+			" 0x%02x, sending CHECK_CONDITION.\n",
 			CMD_TFO(cmd)->get_fabric_name(), cdb[0]);
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 		transport_get_maps(cmd);
@@ -5033,18 +5033,28 @@ static int transport_generic_cmd_sequencer (
 	}
 
 	if (size != cmd->data_length) {
-		TRACE_ERROR("TARGET_CORE[%s]: Expected Transfer Length: %u"
-			" does not match SCSI CDB Length: %u for SAM Opcode:"
+		printk(KERN_WARNING "TARGET_CORE[%s]: Expected Transfer Length:"
+			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", CMD_TFO(cmd)->get_fabric_name(),
 				cmd->data_length, size, cdb[0]);
 
 		cmd->cmd_spdtl = size;
 
 		if (cmd->data_direction == SE_DIRECTION_WRITE) {
-			TRACE_ERROR("Rejecting underflow/overflow WRITE data\n");
+			printk(KERN_ERR "Rejecting underflow/overflow WRITE data\n");
 			return(6);
 		}
-
+		/*
+		 * Reject READ_* or WRITE_* with overflow/underflow for
+		 * type SCF_SCSI_DATA_SG_IO_CDB.
+		 */
+		if (!(ret) && (DEV_ATTRIB(dev)->block_size != 512))  {
+			printk(KERN_ERR "Failing OVERFLOW/UNDERFLOW for LBA op"
+				" CDB on non 512-byte sector setup subsystem"
+				" plugin: %s\n", TRANSPORT(dev)->name);
+			return(6); // Returns CHECK_CONDITION + INVALID_CDB_FIELD
+		}
+			
 		if (size > cmd->data_length) {
 			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
 			cmd->residual_count = (size - cmd->data_length);
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 330c478..2a0c420 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -173,8 +173,8 @@ extern void transport_stop_task_timer (struct se_task_s *);
 extern void transport_stop_all_task_timers (struct se_cmd_s *);
 extern int transport_execute_tasks (struct se_cmd_s *);
 extern int transport_generic_emulate_inquiry (struct se_cmd_s *, unsigned char, unsigned char *, unsigned char *, unsigned char *);
-extern int transport_generic_emulate_readcapacity (struct se_cmd_s *, u32, u32);
-extern int transport_generic_emulate_readcapacity_16 (struct se_cmd_s *, unsigned long long, u32);
+extern int transport_generic_emulate_readcapacity (struct se_cmd_s *, u32);
+extern int transport_generic_emulate_readcapacity_16 (struct se_cmd_s *, unsigned long long);
 extern int transport_generic_emulate_modesense (struct se_cmd_s *, unsigned char *, unsigned char *, int, int);
 extern int transport_get_sense_data (struct se_cmd_s *);
 extern void transport_memcpy_read_contig (struct se_cmd_s *, unsigned char *);
-- 
1.5.4.1



