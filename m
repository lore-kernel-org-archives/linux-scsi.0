From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm: Rename device attribute emulate_tpe to emulate_tpu
Date: Wed, 29 Sep 2010 14:20:54 -0700
Message-ID: <1285795254-30932-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch renames the usage of struct se_dev_attrib->emulate_tpe to
->emulate_tpu in order to signal explict support for UNMAP emulation.

This patch does not change any functional logic from commit 49d2e85a032
and will still use blk_queue_discard() to set emulate_tpu=1 and set TPE=1
in SA READ_CAPACITY_16 when block discard is available.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    6 +++---
 drivers/target/target_core_device.c    |    8 ++++----
 drivers/target/target_core_file.c      |    4 ++--
 drivers/target/target_core_iblock.c    |    4 ++--
 drivers/target/target_core_transport.c |   12 ++++++------
 include/target/target_core_base.h      |    2 +-
 include/target/target_core_device.h    |    2 +-
 include/target/target_core_transport.h |    4 ++--
 8 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 208db8e..ae4a894 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -563,8 +563,8 @@ SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_tas);
 SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
 
-DEF_DEV_ATTRIB(emulate_tpe);
-SE_DEV_ATTR(emulate_tpe, S_IRUGO | S_IWUSR);
+DEF_DEV_ATTRIB(emulate_tpu);
+SE_DEV_ATTR(emulate_tpu, S_IRUGO | S_IWUSR);
 
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
@@ -614,7 +614,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_write_cache.attr,
 	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
-	&target_core_dev_attrib_emulate_tpe.attr,
+	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f8543f6..6101382 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1003,7 +1003,7 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->emulate_write_cache = DA_EMULATE_WRITE_CACHE;
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
-	DEV_ATTRIB(dev)->emulate_tpe = DA_EMULATE_TPE;
+	DEV_ATTRIB(dev)->emulate_tpu = DA_EMULATE_TPU;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
@@ -1224,14 +1224,14 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 	return 0;
 }
 
-int se_dev_set_emulate_tpe(struct se_device *dev, int flag)
+int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -1;
 	}
-	DEV_ATTRIB(dev)->emulate_tpe = flag;
-	printk(KERN_INFO "dev[%p]: SE Device Thin Provising Enabled bit: %d\n",
+	DEV_ATTRIB(dev)->emulate_tpu = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Thin Provising UNMAP bit: %d\n",
 				dev, flag);
 	return 0;
 }
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 1d4e27a..8864f8f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,9 +241,9 @@ static struct se_device *fd_create_virtdevice(
 	 */
 	if (S_ISBLK(inode->i_mode)) {
 		if (blk_queue_discard(bdev_get_queue(inode->i_bdev))) {
-			DEV_ATTRIB(dev)->emulate_tpe = 1;
+			DEV_ATTRIB(dev)->emulate_tpu = 1;
 			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
-				" and TPE=1 emulation\n");
+				" and TPU=1 emulation\n");
 		}
 	}
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 3839efd..80b9880 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -227,9 +227,9 @@ static struct se_device *iblock_create_virtdevice(
 	 * in ATA and we need to set TPE=1
 	 */
 	if (blk_queue_discard(bdev_get_queue(bd))) {
-		DEV_ATTRIB(dev)->emulate_tpe = 1;
+		DEV_ATTRIB(dev)->emulate_tpu = 1;
 		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard"
-				" and TPE=1 emulation\n");
+				" and TPU=1 emulation\n");
 	}
 
 	return dev;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6c39a28..2093563 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4910,12 +4910,12 @@ set_len:
 	case 0xb0: /* Block Limits VPD page */
 		/*
 		 * Following sbc3r22 section 6.5.3 Block Limits VPD page,
-		 * when emulate_tpe=1 we will be expect a different page length
+		 * when emulate_tpu=1 we will be expect a different page length
 		 */
-		if (!(DEV_ATTRIB(dev)->emulate_tpe)) {
+		if (!(DEV_ATTRIB(dev)->emulate_tpu)) {
 			if (cmd->data_length < (0x10 + 4)) {
 				printk(KERN_INFO "Received data_length: %u"
-					" too small for TPE=0 EVPD 0xb0\n",
+					" too small for TPE=1 EVPD 0xb0\n",
 					cmd->data_length);
 				return -1;
 			}
@@ -5011,7 +5011,7 @@ int transport_generic_emulate_readcapacity(
 	/*
 	 * Set max 32-bit blocks to signal SERVICE ACTION READ_CAPACITY_16
 	*/
-	if (DEV_ATTRIB(dev)->emulate_tpe)
+	if (DEV_ATTRIB(dev)->emulate_tpu)
 		put_unaligned_be32(0xFFFFFFFF, &buf[0]);
 
 	return 0;
@@ -5039,9 +5039,9 @@ int transport_generic_emulate_readcapacity_16(
 	buf[11] = DEV_ATTRIB(dev)->block_size & 0xff;
 	/*
 	 * Set Thin Provisioning Enable bit following sbc3r22 in section
-	 * READ CAPACITY (16) byte 14.
+	 * READ CAPACITY (16) byte 14 if emulate_tpu is enabled.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpe)
+	if (DEV_ATTRIB(dev)->emulate_tpu)
 		buf[14] = 0x80;
 
 	return 0;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 69c61bb..3905a0e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -749,7 +749,7 @@ struct se_dev_attrib {
 	int		emulate_write_cache;
 	int		emulate_ua_intlck_ctrl;
 	int		emulate_tas;
-	int		emulate_tpe;
+	int		emulate_tpu;
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 01358a3..e8546f3 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -48,7 +48,7 @@ extern int se_dev_set_emulate_fua_read(struct se_device *, int);
 extern int se_dev_set_emulate_write_cache(struct se_device *, int);
 extern int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
 extern int se_dev_set_emulate_tas(struct se_device *, int);
-extern int se_dev_set_emulate_tpe(struct se_device *, int);
+extern int se_dev_set_emulate_tpu(struct se_device *, int);
 extern int se_dev_set_enforce_pr_isids(struct se_device *, int);
 extern int se_dev_set_queue_depth(struct se_device *, u32);
 extern int se_dev_set_max_sectors(struct se_device *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 47af81b..ab7336b 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -107,8 +107,8 @@
 #define DA_EMULATE_UA_INTLLCK_CTRL		0
 /* Emulation for TASK_ABORTED status (TAS) by default */
 #define DA_EMULATE_TAS				1
-/* Emulation for Thin Provisioning Enabled using block/blk-lib.c:blkdev_issue_discard() */
-#define DA_EMULATE_TPE				0
+/* Emulation for Thin Provisioning UNMAP using block/blk-lib.c:blkdev_issue_discard() */
+#define DA_EMULATE_TPU				0
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_RESERVATIONS			0
 /* No Emulation for PSCSI by default */
-- 
1.5.6.5
