From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm: Add Thin Provisioning / UNMAP emulation and Block Limits VPD page
Date: Mon, 27 Sep 2010 15:51:28 -0700
Message-ID: <1285627889-6450-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ne1.yahoo.com ([98.138.90.66]:34556 "HELO
	nm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760417Ab0I0Wvf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:51:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a generic Thin Provisioning enabled (TPE=1) emulation
and a new transport_generic_unmap() exported caller used by TCM/IBLOCK and
TCM/FILEIO to issue blkdev_issue_discard() for a received LBA + Range
to a struct block_device.  This includes the addition of UNMAP in
transport_generic_cmd_sequencer() for both the DEV_ATTRIB(dev)->emulate_tpe=1
case for IBLOCK/FILEIO and the passthrough case for TCM/pSCSI.

Tthis patch also adds the Block Limits VPD (0xb0) page for INQUIRY EVPD=1
to report both emulate_tpe=1 and emulate_tpe=0 cases.  This page returns
the these values, the ones related to TPE=1 have been added into
struct se_dev_attrib:

	*) OPTIMAL TRANSFER LENGTH GRANULARITY
	*) MAXIMUM TRANSFER LENGTH
	*) OPTIMAL TRANSFER LENGTH
	*) MAXIMUM UNMAP LBA COUNT (tpe=1)
	*) MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT (tpe=1)
	*) OPTIMAL UNMAP GRANULARITY (tpe=1)
	*) UNMAP GRANULARITY ALIGNMENT (tpe=1)

the TPE=1 releated values in Block Limits VPD also now appear along with
optimal_sectors as new configfs attributes in:

	 /sys/kernel/config/target/core/$HBA/$DEV/attrib/

Finally, this patch updates transport_generic_emulate_readcapacity() to
signal SA READ_CAPACITY16 and updates transport_generic_emulate_readcapacity_16()
to set TPE=1 bit when emulate_tpe=1.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |   24 +++++
 drivers/target/target_core_device.c    |   90 +++++++++++++++++++
 drivers/target/target_core_transport.c |  152 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    9 ++-
 include/target/target_core_device.h    |    6 ++
 include/target/target_core_transport.h |   11 +++
 6 files changed, 291 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f66ac33..208db8e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -563,6 +563,9 @@ SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_tas);
 SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_tpe);
+SE_DEV_ATTR(emulate_tpe, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
@@ -578,6 +581,9 @@ SE_DEV_ATTR_RO(hw_max_sectors);
 DEF_DEV_ATTRIB(max_sectors);
 SE_DEV_ATTR(max_sectors, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(optimal_sectors);
+SE_DEV_ATTR(optimal_sectors, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_queue_depth);
 SE_DEV_ATTR_RO(hw_queue_depth);
 
@@ -587,6 +593,18 @@ SE_DEV_ATTR(queue_depth, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(task_timeout);
 SE_DEV_ATTR(task_timeout, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(max_unmap_lba_count);
+SE_DEV_ATTR(max_unmap_lba_count, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(max_unmap_block_desc_count);
+SE_DEV_ATTR(max_unmap_block_desc_count, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(unmap_granularity);
+SE_DEV_ATTR(unmap_granularity, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(unmap_granularity_alignment);
+SE_DEV_ATTR(unmap_granularity_alignment, S_IRUGO | S_IWUSR);
+
 CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib, da_group);
 
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
@@ -596,14 +614,20 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_write_cache.attr,
 	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
+	&target_core_dev_attrib_emulate_tpe.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
 	&target_core_dev_attrib_max_sectors.attr,
+	&target_core_dev_attrib_optimal_sectors.attr,
 	&target_core_dev_attrib_hw_queue_depth.attr,
 	&target_core_dev_attrib_queue_depth.attr,
 	&target_core_dev_attrib_task_timeout.attr,
+	&target_core_dev_attrib_max_unmap_lba_count.attr,
+	&target_core_dev_attrib_max_unmap_block_desc_count.attr,
+	&target_core_dev_attrib_unmap_granularity.attr,
+	&target_core_dev_attrib_unmap_granularity_alignment.attr,
 	NULL,
 };
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1e8be47..f8543f6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1003,9 +1003,16 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->emulate_write_cache = DA_EMULATE_WRITE_CACHE;
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
+	DEV_ATTRIB(dev)->emulate_tpe = DA_EMULATE_TPE;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
+	DEV_ATTRIB(dev)->max_unmap_lba_count = DA_MAX_UNMAP_LBA_COUNT;
+	DEV_ATTRIB(dev)->max_unmap_block_desc_count =
+				DA_MAX_UNMAP_BLOCK_DESC_COUNT;
+	DEV_ATTRIB(dev)->unmap_granularity = DA_UNMAP_GRANULARITY_DEFAULT;
+	DEV_ATTRIB(dev)->unmap_granularity_alignment =
+				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	/*
 	 * block_size is based on subsystem plugin dependent requirements.
 	 */
@@ -1017,6 +1024,11 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->hw_max_sectors = TRANSPORT(dev)->get_max_sectors(dev);
 	DEV_ATTRIB(dev)->max_sectors = TRANSPORT(dev)->get_max_sectors(dev);
 	/*
+	 * Set optimal_sectors from max_sectors, which can be lowered via
+	 * configfs.
+	 */
+	DEV_ATTRIB(dev)->optimal_sectors = DEV_ATTRIB(dev)->max_sectors;
+	/*
 	 * queue_depth is based on subsystem plugin dependent requirements.
 	 */
 	DEV_ATTRIB(dev)->hw_queue_depth = TRANSPORT(dev)->get_queue_depth(dev);
@@ -1051,6 +1063,46 @@ int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
 	return 0;
 }
 
+int se_dev_set_max_unmap_lba_count(
+	struct se_device *dev,
+	u32 max_unmap_lba_count)
+{
+	DEV_ATTRIB(dev)->max_unmap_lba_count = max_unmap_lba_count;
+	printk(KERN_INFO "dev[%p]: Set max_unmap_lba_count: %u\n",
+			dev, DEV_ATTRIB(dev)->max_unmap_lba_count);
+	return 0;
+}
+
+int se_dev_set_max_unmap_block_desc_count(
+	struct se_device *dev,
+	u32 max_unmap_block_desc_count)
+{
+	DEV_ATTRIB(dev)->max_unmap_block_desc_count = max_unmap_block_desc_count;
+	printk(KERN_INFO "dev[%p]: Set max_unmap_block_desc_count: %u\n",
+			dev, DEV_ATTRIB(dev)->max_unmap_block_desc_count);
+	return 0;
+}
+
+int se_dev_set_unmap_granularity(
+	struct se_device *dev,
+	u32 unmap_granularity)
+{
+	DEV_ATTRIB(dev)->unmap_granularity = unmap_granularity;
+	printk(KERN_INFO "dev[%p]: Set unmap_granularity: %u\n",
+			dev, DEV_ATTRIB(dev)->unmap_granularity);
+	return 0;
+}
+
+int se_dev_set_unmap_granularity_alignment(
+	struct se_device *dev,
+	u32 unmap_granularity_alignment)
+{
+	DEV_ATTRIB(dev)->unmap_granularity_alignment = unmap_granularity_alignment;
+	printk(KERN_INFO "dev[%p]: Set unmap_granularity_alignment: %u\n",
+			dev, DEV_ATTRIB(dev)->unmap_granularity_alignment);
+	return 0;
+}
+
 int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1172,6 +1224,18 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_emulate_tpe(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_tpe = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Thin Provising Enabled bit: %d\n",
+				dev, flag);
+	return 0;
+}
+
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1297,6 +1361,32 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 	return 0;
 }
 
+int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
+{
+	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device"
+			" optimal_sectors while dev_export_obj: %d count exists\n",
+			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
+		return -EINVAL;
+	}
+	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+		printk(KERN_ERR "dev[%p]: Passed optimal_sectors cannot be"
+				" changed for TCM/pSCSI\n", dev);
+		return -EINVAL;
+	}
+	if (optimal_sectors > DEV_ATTRIB(dev)->max_sectors) {
+		printk(KERN_ERR "dev[%p]: Passed optimal_sectors %u cannot be"
+			" greater than max_sectors: %u\n", dev,
+			optimal_sectors, DEV_ATTRIB(dev)->max_sectors);
+		return -EINVAL;
+	}
+
+	DEV_ATTRIB(dev)->optimal_sectors = optimal_sectors;
+	printk(KERN_INFO "dev[%p]: SE Device optimal_sectors changed to %u\n",
+			dev, optimal_sectors);
+	return 0;
+}
+
 int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 {
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index be235ef..0a35a5c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4907,6 +4907,83 @@ set_len:
 			buf[6] = 0x01;
 
 		break;
+	case 0xb0: /* Block Limits VPD page */
+		/*
+		 * Following sbc3r22 section 6.5.3 Block Limits VPD page,
+		 * when emulate_tpe=1 we will be expect a different page length
+		 */
+		if (!(DEV_ATTRIB(dev)->emulate_tpe)) {
+			if (cmd->data_length < 0x10) {
+				printk(KERN_INFO "Received data_length: %u"
+					" too small for TPE=0 EVPD 0xb0\n",
+					cmd->data_length);
+				return -1;
+			}
+			buf[0] = TRANSPORT(dev)->get_device_type(dev);
+			buf[1] = 0xb0;
+			buf[3] = 0x10; /* Set hardcoded TPE=0 length */
+			/*
+			 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
+			 */
+			put_unaligned_be16(1, &buf[6]);
+			/*
+			 * Set MAXIMUM TRANSFER LENGTH
+			 */
+			put_unaligned_be32(DEV_ATTRIB(dev)->max_sectors,
+					&buf[8]);
+			/*
+			 * Set OPTIMAL TRANSFER LENGTH
+			 */
+			put_unaligned_be32(DEV_ATTRIB(dev)->optimal_sectors,
+					&buf[12]);
+			break;
+		}
+
+		if (cmd->data_length < 0x3c) {
+			printk(KERN_INFO "Received data_length: %u"
+				" too small for TPE=1 EVPD 0xb0\n",
+				cmd->data_length);
+			return -1;
+		}
+		buf[0] = TRANSPORT(dev)->get_device_type(dev);
+		buf[1] = 0xb0;
+		buf[3] = 0x3c; /* Set hardcoded TPE=1 length */
+		/*
+		 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
+		 * Note that this follows what scsi_debug.c reports to SCSI ML
+		 */
+		put_unaligned_be16(1, &buf[6]);
+		/*
+		 * Set MAXIMUM TRANSFER LENGTH
+		 */	
+		put_unaligned_be32(DEV_ATTRIB(dev)->max_sectors, &buf[8]);
+		/*
+		 * Set OPTIMAL TRANSFER LENGTH
+		 */
+		put_unaligned_be32(DEV_ATTRIB(dev)->optimal_sectors, &buf[12]);
+		/*
+		 * Set MAXIMUM UNMAP LBA COUNT
+		 */
+		put_unaligned_be32(DEV_ATTRIB(dev)->max_unmap_lba_count,
+				&buf[20]);
+		/*
+		 * Set MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT
+		 */
+		put_unaligned_be32(DEV_ATTRIB(dev)->max_unmap_block_desc_count,
+				&buf[24]);
+		/*
+		 * Set OPTIMAL UNMAP GRANULARITY
+		 */
+		put_unaligned_be32(DEV_ATTRIB(dev)->unmap_granularity,
+				&buf[28]);
+		/*
+		 * UNMAP GRANULARITY ALIGNMENT
+		 */
+		put_unaligned_be32(DEV_ATTRIB(dev)->unmap_granularity_alignment,
+				&buf[32]);
+		if (DEV_ATTRIB(dev)->unmap_granularity_alignment != 0)
+			buf[32] |= 0x80; /* Set the UGAVALID bit */
+		break;
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
 		return -1;
@@ -4931,6 +5008,11 @@ int transport_generic_emulate_readcapacity(
 	buf[5] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
 	buf[6] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
 	buf[7] = DEV_ATTRIB(dev)->block_size & 0xff;
+	/*
+	 * Set max 32-bit blocks to signal SERVICE ACTION READ_CAPACITY_16
+	*/
+	if (DEV_ATTRIB(dev)->emulate_tpe)
+		put_unaligned_be32(0xFFFFFFFF, &buf[0]);
 
 	return 0;
 }
@@ -4955,6 +5037,12 @@ int transport_generic_emulate_readcapacity_16(
 	buf[9] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
 	buf[10] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
 	buf[11] = DEV_ATTRIB(dev)->block_size & 0xff;
+	/*
+	 * Set Thin Provisioning Enable bit following sbc3r22 in section
+	 * READ CAPACITY (16) byte 14.
+	 */
+	if (DEV_ATTRIB(dev)->emulate_tpe)
+		buf[14] = 0x80;
 
 	return 0;
 }
@@ -5351,6 +5439,47 @@ static int transport_generic_synchronize_cache(struct se_cmd *cmd)
 	return 0;
 }
 
+/*
+ * Used for TCM/IBLOCK and TCM/FILEIO for block/blk-lib.c level discard support.
+ * Note this is not used for TCM/pSCSI passthrough
+ */
+int transport_generic_unmap(struct se_cmd *cmd, struct block_device *bdev)
+{
+	struct se_device *dev = SE_DEV(cmd);
+	unsigned char *buf = T_TASK(cmd)->t_task_buf, *ptr = NULL;
+	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
+	sector_t lba;
+	unsigned int size = cmd->data_length, range;
+	int barrier = 0, ret, offset = 8; /* First UNMAP block descriptor starts at 8 byte offset */
+	unsigned short dl, bd_dl;
+
+	/* Skip over UNMAP header */
+	size -= 8;
+	dl = get_unaligned_be16(&cdb[0]);
+	bd_dl = get_unaligned_be16(&cdb[2]);
+	ptr = &buf[offset];
+	printk("UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu ptr: %p\n",
+		TRANSPORT(dev)->name, dl, bd_dl, size, ptr);
+
+	while (size) {
+		lba = get_unaligned_be64(&ptr[0]);
+		range = get_unaligned_be32(&ptr[8]);
+		printk("UNMAP: Using lba: %llu and range: %u\n", lba, range);
+
+		ret = blkdev_issue_discard(bdev, lba, range, GFP_KERNEL, barrier);
+		if (ret < 0) {
+			printk(KERN_ERR "blkdev_issue_discard() failed: %d\n", ret);
+			return -1;
+		}
+
+		ptr += 16;
+		size -= 16;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(transport_generic_unmap);
+
 static inline void transport_dev_get_mem_buf(
 	struct se_device *dev,
 	struct se_cmd *cmd)
@@ -5946,6 +6075,29 @@ static int transport_generic_cmd_sequencer(
 		if (transport_get_sectors(cmd) < 0)
 			return TGCS_INVALID_CDB_FIELD;
 		break;
+	case UNMAP:
+		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
+		cmd->transport_allocate_resources =
+				&transport_generic_allocate_buf;
+		size = get_unaligned_be16(&cdb[7]);
+		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
+		transport_get_maps(cmd);
+		passthrough = (TRANSPORT(dev)->transport_type ==
+				TRANSPORT_PLUGIN_PHBA_PDEV);
+		printk("Got UNMAP CDB for subsystem plugin: %s, pt: %hd size: %hu\n",
+				TRANSPORT(dev)->name, passthrough, size);
+		/*
+		 * Determine if the received UNMAP used to for direct passthrough
+		 * into Linux/SCSI with struct request via TCM/pSCSI or we are
+		 * signaling the use of internal transport_generic_unmap() emulation
+		 * for UNMAP -> Linux/BLOCK disbard with TCM/IBLOCK and TCM/FILEIO
+		 * subsystem plugin backstores.
+		 */
+		if (!(passthrough))
+			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_UNMAP;
+
+		ret = TGCS_CONTROL_NONSG_IO_CDB;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case GPCMD_CLOSE_TRACK:
 	case ERASE:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b6f3b75..69c61bb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -136,7 +136,8 @@ enum se_cmd_flags_table {
 	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00400000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00800000,
 	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
-	SCF_EMULATE_CDB_ASYNC		= 0x02000000
+	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
+	SCF_EMULATE_SYNC_UNMAP		= 0x04000000
 };
 	
 /* struct se_device->type for known subsystem plugins */
@@ -748,6 +749,7 @@ struct se_dev_attrib {
 	int		emulate_write_cache;
 	int		emulate_ua_intlck_ctrl;
 	int		emulate_tas;
+	int		emulate_tpe;
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
@@ -755,9 +757,14 @@ struct se_dev_attrib {
 	u32		block_size;
 	u32		hw_max_sectors;
 	u32		max_sectors;
+	u32		optimal_sectors;
 	u32		hw_queue_depth;
 	u32		queue_depth;
 	u32		task_timeout;
+	u32		max_unmap_lba_count;
+	u32		max_unmap_block_desc_count;
+	u32		unmap_granularity;
+	u32		unmap_granularity_alignment;
 	struct se_subsystem_dev *da_sub_dev;
 	struct config_group da_group;
 } ____cacheline_aligned;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index eb825c3..01358a3 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -38,15 +38,21 @@ extern int se_dev_check_online(struct se_device *);
 extern int se_dev_check_shutdown(struct se_device *);
 extern void se_dev_set_default_attribs(struct se_device *);
 extern int se_dev_set_task_timeout(struct se_device *, u32);
+extern int se_dev_set_max_unmap_lba_count(struct se_device *, u32);
+extern int se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
+extern int se_dev_set_unmap_granularity(struct se_device *, u32);
+extern int se_dev_set_unmap_granularity_alignment(struct se_device *, u32);
 extern int se_dev_set_emulate_dpo(struct se_device *, int);
 extern int se_dev_set_emulate_fua_write(struct se_device *, int);
 extern int se_dev_set_emulate_fua_read(struct se_device *, int);
 extern int se_dev_set_emulate_write_cache(struct se_device *, int);
 extern int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
 extern int se_dev_set_emulate_tas(struct se_device *, int);
+extern int se_dev_set_emulate_tpe(struct se_device *, int);
 extern int se_dev_set_enforce_pr_isids(struct se_device *, int);
 extern int se_dev_set_queue_depth(struct se_device *, u32);
 extern int se_dev_set_max_sectors(struct se_device *, u32);
+extern int se_dev_set_optimal_sectors(struct se_device *, u32);
 extern int se_dev_set_block_size(struct se_device *, u32);
 extern struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_hba *,
 					struct se_device *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 20702d7..47af81b 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -87,6 +87,14 @@
 /* struct se_dev_attrib sanity values */
 /* 10 Minutes, see transport_get_default_task_timeout()  */
 #define DA_TASK_TIMEOUT_MAX			600
+/* Default max_unmap_lba_count */
+#define DA_MAX_UNMAP_LBA_COUNT			0
+/* Default max_unmap_block_desc_count */
+#define DA_MAX_UNMAP_BLOCK_DESC_COUNT		0
+/* Default unmap_granularity */
+#define DA_UNMAP_GRANULARITY_DEFAULT		0
+/* Default unmap_granularity_alignment */
+#define DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT	0
 /* Emulation for Direct Page Out */
 #define DA_EMULATE_DPO				0
 /* Emulation for Forced Unit Access WRITEs */
@@ -99,6 +107,8 @@
 #define DA_EMULATE_UA_INTLLCK_CTRL		0
 /* Emulation for TASK_ABORTED status (TAS) by default */
 #define DA_EMULATE_TAS				1
+/* Emulation for Thin Provisioning Enabled using block/blk-lib.c:blkdev_issue_discard() */
+#define DA_EMULATE_TPE				0
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_RESERVATIONS			0
 /* No Emulation for PSCSI by default */
@@ -224,6 +234,7 @@ extern int transport_generic_emulate_modesense(struct se_cmd *,
 extern int transport_generic_emulate_request_sense(struct se_cmd *,
 						   unsigned char *);
 extern int transport_get_sense_data(struct se_cmd *);
+extern int transport_generic_unmap(struct se_cmd *, struct block_device *);
 extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
 						void *, u32, u32, void *);
 extern void transport_passthrough_release(struct se_cmd *);
-- 
1.5.6.5

