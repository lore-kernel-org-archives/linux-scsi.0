From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] tcm: Add WRITE_SAME_16 emulation and passthrough support
Date: Sat,  2 Oct 2010 17:53:40 -0700
Message-ID: <1286067220-14471-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:32909 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752337Ab0JCAxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2010 20:53:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds WRITE_SAME_16 emulation support into TCM Core which
is used in a followup patch by TCM/IBLOCK and TCM/FILEIO subsystems plugins
together with generic Block layer Discard logic.  It also allows for existing
TCM/pSCSI passthrough support to function with the same WRITE_SAME_16 ops in
transport_generic_cmd_sequencer().

Note that WRITE_SAME_16 is setup as a TGCS_DATA_SG_IO_CDB operation, but
for the current emulated WRITE_SAME_16 w/ UNMAP=1 code we set T_TASK(cmd)->t_tasks_unmap=1
to signal IBLOCK and FILEIO that they will be callling the new transport_generic_write_same()
code, but not actually writing the WRITE_SAME_16 w/ UNMAP=1 data payload.  The main
transport_generic_write_same() caller uses received LBA and Number of blocks (range)
together with blk_issue_discard() to perform the emulation.

This patch also adds a new configfs attrib fot WRITE_SAME_16 support in:

	sys/kernel/config/target/core/$HBA/$DEV/attrib/emulate_tpws

by default this is disabled and will be enabled by IBLOCK+FILEIO on a struct se_device
context when blk_queue_discard()==1 is detected.

This patch also updates INQUIRY Block Limits VPD, Thin Provisioning VPD
READ_CAPACITY_* to take into account the DEV_ATTRIB(dev)->emulate_tpws=1

Here is how it looks in action with TCM_Loop -> TCM/FILEIO -> scsi_debug:

	sg_vpd --page=0xb2 /dev/sdh
	Thin provisioning VPD page (SBC):
	  Unmap supported (TPU): 1
	  Write same with unmap supported (TPWS): 1
	  Anchored LBAs not supported
	  Threshold exponent: 0
	  Descriptor present (DP): 0

	sg_write_same --xferlen=4096 -S -U -v -v --lba=1024 --num=8 /dev/sdh
	open /dev/sdh with flags=0x802
	Default data-out buffer to 4096 zeroes
	    Write same(16) cmd: 93 08 00 00 00 00 00 00 04 00 00 00 00 08 00 00
	    Data-out buffer length=4096

Note that this has also been briefly tested with TCM_Loop -> TCM/IBLOCK ->
scsi_debug with emulate_tpws=1, as well as with WRITE_SAME_16 passthrough
with TCM_Loop -> TCM/pSCSI -> scsi_debug.

Many, many thanks to Martin Petersen for his help in this area!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    4 +
 drivers/target/target_core_device.c    |   15 +++++-
 drivers/target/target_core_transport.c |   99 ++++++++++++++++++++++++++++++--
 include/target/target_core_base.h      |    5 +-
 include/target/target_core_device.h    |    1 +
 include/target/target_core_transport.h |    6 ++
 6 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ae4a894..49547ab 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -566,6 +566,9 @@ SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_tpu);
 SE_DEV_ATTR(emulate_tpu, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_tpws);
+SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
@@ -615,6 +618,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
 	&target_core_dev_attrib_emulate_tpu.attr,
+	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6101382..070da98 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1004,6 +1004,7 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
 	DEV_ATTRIB(dev)->emulate_tpu = DA_EMULATE_TPU;
+	DEV_ATTRIB(dev)->emulate_tpws = DA_EMULATE_TPWS;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
@@ -1231,7 +1232,19 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 		return -1;
 	}
 	DEV_ATTRIB(dev)->emulate_tpu = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Thin Provising UNMAP bit: %d\n",
+	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
+				dev, flag);
+	return 0;
+}
+
+int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_tpws = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
 				dev, flag);
 	return 0;
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 866b0fa..c320395 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4932,9 +4932,11 @@ set_len:
 	case 0xb0: /* Block Limits VPD page */
 		/*
 		 * Following sbc3r22 section 6.5.3 Block Limits VPD page,
-		 * when emulate_tpu=1 we will be expect a different page length
+		 * when emulate_tpu=1 or emulate_tpws=1 we will be expect
+		 * a different page length for Thin Provisioning.
 		 */
-		if (!(DEV_ATTRIB(dev)->emulate_tpu)) {
+		if (!(DEV_ATTRIB(dev)->emulate_tpu) &&
+		    !(DEV_ATTRIB(dev)->emulate_tpws)) {
 			if (cmd->data_length < (0x10 + 4)) {
 				printk(KERN_INFO "Received data_length: %u"
 					" too small for TPE=1 EVPD 0xb0\n",
@@ -5037,6 +5039,14 @@ set_len:
 		 */
 		if (DEV_ATTRIB(dev)->emulate_tpu != 0)
 			buf[5] = 0x80;
+		/*
+		 * A TPWS bit set to one indicates that the device server supports
+		 * the use of the WRITE SAME (16) command (see 5.42) to unmap LBAs.
+		 * A TPWS bit set to zero indicates that the device server does not
+		 * support the use of the WRITE SAME (16) command to unmap LBAs.
+		 */
+		if (DEV_ATTRIB(dev)->emulate_tpws != 0)
+			buf[5] |= 0x40;
 		break;
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
@@ -5065,7 +5075,7 @@ int transport_generic_emulate_readcapacity(
 	/*
 	 * Set max 32-bit blocks to signal SERVICE ACTION READ_CAPACITY_16
 	*/
-	if (DEV_ATTRIB(dev)->emulate_tpu)
+	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
 		put_unaligned_be32(0xFFFFFFFF, &buf[0]);
 
 	return 0;
@@ -5093,9 +5103,9 @@ int transport_generic_emulate_readcapacity_16(
 	buf[11] = DEV_ATTRIB(dev)->block_size & 0xff;
 	/*
 	 * Set Thin Provisioning Enable bit following sbc3r22 in section
-	 * READ CAPACITY (16) byte 14 if emulate_tpu is enabled.
+	 * READ CAPACITY (16) byte 14 if emulate_tpu or emulate_tpws is enabled.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpu)
+	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
 		buf[14] = 0x80;
 
 	return 0;
@@ -5534,6 +5544,38 @@ int transport_generic_unmap(struct se_cmd *cmd, struct block_device *bdev)
 }
 EXPORT_SYMBOL(transport_generic_unmap);
 
+/*
+ * Used for TCM/IBLOCK and TCM/FILEIO for block/blk-lib.c level discard support.
+ * Note this is not used for TCM/pSCSI passthrough
+ */
+int transport_generic_write_same(struct se_cmd *cmd, struct block_device *bdev)
+{
+	struct se_device *dev = SE_DEV(cmd);
+	sector_t lba;
+	unsigned int range;
+	int barrier = 0, ret;
+	/*
+	 * If the UNMAP bit was not set, we should not be calling this to being with..
+	 */
+	if (!(T_TASK(cmd)->t_tasks_unmap)) {
+		dump_stack();
+		return -1;
+	}
+
+	lba = T_TASK(cmd)->t_task_lba;
+	range = (cmd->data_length / TRANSPORT(dev)->get_blocksize(dev));
+
+	printk(KERN_INFO "WRITE_SAME UNMAP: LBA: %llu Range: %u\n", lba, range);
+
+	ret = blkdev_issue_discard(bdev, lba, range, GFP_KERNEL, barrier);
+	if (ret < 0) {
+		printk(KERN_INFO "blkdev_issue_discard() failed for WRITE_SAME\n");
+		return -1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(transport_generic_write_same);
+
 static inline void transport_dev_get_mem_buf(
 	struct se_device *dev,
 	struct se_cmd *cmd)
@@ -6154,6 +6196,53 @@ static int transport_generic_cmd_sequencer(
 
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
+	case WRITE_SAME_16:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		cmd->transport_allocate_resources =
+				&transport_generic_allocate_buf;
+		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
+		if (sector_ret)
+			return TGCS_UNSUPPORTED_CDB;
+		size = transport_get_size(sectors, cdb, cmd);
+		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		cmd->transport_split_cdb = &split_cdb_XX_16;
+		cmd->transport_get_long_lba = &transport_lba_64;
+		passthrough = (TRANSPORT(dev)->transport_type ==
+				TRANSPORT_PLUGIN_PHBA_PDEV);
+		/*
+		 * Determine if the received WRITE_SAME_16 is used to for direct
+		 * passthrough into Linux/SCSI with struct request via TCM/pSCSI
+		 * or we are signaling the use of internal WRITE_SAME + UNMAP=1
+		 * emulation for -> Linux/BLOCK disbard with TCM/IBLOCK and
+		 * TCM/FILEIO subsystem plugin backstores.
+		 */ 
+		if (!(passthrough)) {
+			if ((cdb[1] & 0x04) || (cdb[1] & 0x02)) {
+				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
+					" bits not supported for Block Discard"
+					" Emulation\n");
+				return TGCS_INVALID_CDB_FIELD;
+			}
+			/*
+			 * Currently for the emulated case we only accept
+			 * tpws with the UNMAP=1 bit set.
+			 */
+			if (!(cdb[1] & 0x08)) {
+				printk(KERN_ERR "WRITE_SAME w/ UNMAP bit not "
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
+		}
+		ret = TGCS_DATA_SG_IO_CDB;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case GPCMD_CLOSE_TRACK:
 	case ERASE:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fc5300c..bceb794 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -138,7 +138,8 @@ enum se_cmd_flags_table {
 	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
 	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
 	SCF_EMULATE_SYNC_UNMAP		= 0x04000000,
-	SCF_ECDB_ALLOCATION		= 0x08000000
+	SCF_ECDB_ALLOCATION		= 0x08000000,
+	SCF_EMULATE_SYNC_WRITE_SAME	= 0x10000000
 };
 	
 /* struct se_device->type for known subsystem plugins */
@@ -431,6 +432,7 @@ struct se_transport_task {
 	int			t_tasks_failed;
 	int			t_tasks_fua;
 	int			t_tasks_bidi:1;
+	int			t_tasks_unmap:1;
 	u32			t_task_cdbs;
 	u32			t_tasks_check;
 	u32			t_tasks_no;
@@ -752,6 +754,7 @@ struct se_dev_attrib {
 	int		emulate_ua_intlck_ctrl;
 	int		emulate_tas;
 	int		emulate_tpu;
+	int		emulate_tpws;
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index e8546f3..248d954 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -49,6 +49,7 @@ extern int se_dev_set_emulate_write_cache(struct se_device *, int);
 extern int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
 extern int se_dev_set_emulate_tas(struct se_device *, int);
 extern int se_dev_set_emulate_tpu(struct se_device *, int);
+extern int se_dev_set_emulate_tpws(struct se_device *, int);
 extern int se_dev_set_enforce_pr_isids(struct se_device *, int);
 extern int se_dev_set_queue_depth(struct se_device *, u32);
 extern int se_dev_set_max_sectors(struct se_device *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index d45063e..74a56f1 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -109,6 +109,11 @@
 #define DA_EMULATE_TAS				1
 /* Emulation for Thin Provisioning UNMAP using block/blk-lib.c:blkdev_issue_discard() */
 #define DA_EMULATE_TPU				0
+/*
+ * Emulation for Thin Provisioning WRITE_SAME w/ UNMAP=1 bit using
+ * block/blk-lib.c:blkdev_issue_discard()
+ */
+#define DA_EMULATE_TPWS				0
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_RESERVATIONS			0
 /* No Emulation for PSCSI by default */
@@ -235,6 +240,7 @@ extern int transport_generic_emulate_request_sense(struct se_cmd *,
 						   unsigned char *);
 extern int transport_get_sense_data(struct se_cmd *);
 extern int transport_generic_unmap(struct se_cmd *, struct block_device *);
+extern int transport_generic_write_same(struct se_cmd *, struct block_device *);
 extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
 						void *, u32, u32, void *);
 extern void transport_passthrough_release(struct se_cmd *);
-- 
1.5.6.5

