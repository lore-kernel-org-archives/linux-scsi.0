From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 084/103] target: Implement Block Device Characteristics VPD page
Date: Thu, 21 Jul 2011 00:12:07 -0700
Message-ID: <1311232346-6674-85-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27.bullet.mail.bf1.yahoo.com ([98.139.212.186]:47984 "HELO
	nm27.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035Ab1GUHI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:59 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Implement page B1h, Block Device Characteristics, so that we can report
a medium rotation rate of 1 (non-rotating / solid state) if the
is_nonrot device attribute is set; we update the iblock backend to set
this attribute if the underlying Linux block device has its nonrot
flag set.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c       |   17 +++++++++++++++++
 drivers/target/target_core_configfs.c  |    4 ++++
 drivers/target/target_core_device.c    |   13 +++++++++++++
 drivers/target/target_core_iblock.c    |    3 +++
 include/target/target_core_base.h      |    1 +
 include/target/target_core_device.h    |    1 +
 include/target/target_core_transport.h |    2 ++
 7 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 1157e0c..4322530 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -535,6 +535,22 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	return 0;
 }
 
+/* Block Device Characteristics VPD page */
+static int
+target_emulate_evpd_b1(struct se_cmd *cmd, unsigned char *buf)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	buf[0] = dev->transport->get_device_type(dev);
+	buf[3] = 0x3c;
+
+	if (cmd->data_length >= 5 &&
+	    dev->se_sub_dev->se_dev_attrib.is_nonrot)
+		buf[5] = 1;
+
+	return 0;
+}
+
 /* Thin Provisioning VPD */
 static int
 target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
@@ -599,6 +615,7 @@ static struct {
 	{ .page = 0x83, .emulate = target_emulate_evpd_83 },
 	{ .page = 0x86, .emulate = target_emulate_evpd_86 },
 	{ .page = 0xb0, .emulate = target_emulate_evpd_b0 },
+	{ .page = 0xb1, .emulate = target_emulate_evpd_b1 },
 	{ .page = 0xb2, .emulate = target_emulate_evpd_b2 },
 };
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8d2aba5..6b00810 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -698,6 +698,9 @@ SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(is_nonrot);
+SE_DEV_ATTR(is_nonrot, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -746,6 +749,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
+	&target_core_dev_attrib_is_nonrot.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f13e294..440e6b6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -853,6 +853,7 @@ void se_dev_set_default_attribs(
 	dev->se_sub_dev->se_dev_attrib.emulate_reservations = DA_EMULATE_RESERVATIONS;
 	dev->se_sub_dev->se_dev_attrib.emulate_alua = DA_EMULATE_ALUA;
 	dev->se_sub_dev->se_dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
+	dev->se_sub_dev->se_dev_attrib.is_nonrot = DA_IS_NONROT;
 	/*
 	 * The TPU=1 and TPWS=1 settings will be set in TCM/IBLOCK
 	 * iblock_create_virtdevice() from struct queue_limits values
@@ -1117,6 +1118,18 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_is_nonrot(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+	dev->se_sub_dev->se_dev_attrib.is_nonrot = flag;
+	printk(KERN_INFO "dev[%p]: SE Device is_nonrot bit: %d\n",
+	       dev, flag);
+	return 0;
+}
+
 /*
  * Note, this can only be called on unexported SE Device Object.
  */
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 160c484..392e75f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -196,6 +196,9 @@ static struct se_device *iblock_create_virtdevice(
 				" disabled by default\n");
 	}
 
+	if (blk_queue_nonrot(q))
+		dev->se_sub_dev->se_dev_attrib.is_nonrot = 1;
+
 	return dev;
 
 failed:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cd163dd..81deb39 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -661,6 +661,7 @@ struct se_dev_attrib {
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
+	int		is_nonrot;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 96586cc..f3b6ae6 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -39,6 +39,7 @@ extern int se_dev_set_emulate_tas(struct se_device *, int);
 extern int se_dev_set_emulate_tpu(struct se_device *, int);
 extern int se_dev_set_emulate_tpws(struct se_device *, int);
 extern int se_dev_set_enforce_pr_isids(struct se_device *, int);
+extern int se_dev_set_is_nonrot(struct se_device *, int);
 extern int se_dev_set_queue_depth(struct se_device *, u32);
 extern int se_dev_set_max_sectors(struct se_device *, u32);
 extern int se_dev_set_optimal_sectors(struct se_device *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 2aae764..b27ce1a 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -101,6 +101,8 @@
 #define DA_ENFORCE_PR_ISIDS			1
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
+/* By default don't report non-rotating (solid state) medium */
+#define DA_IS_NONROT				0
 
 #define SE_MODE_PAGE_BUF			512
 
-- 
1.7.6

