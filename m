From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 09/12] target: Add MAXIMUM COMPARE AND WRITE LENGTH in Block Limits VPD
Date: Thu, 22 Aug 2013 04:54:07 +0000
Message-ID: <1377147250-10125-10-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds the MAXIMUM COMPARE AND WRITE LENGTH bit, currently
hardcoded to a single logical block (NoLB=1) within the Block Limits
VPD in spc_emulate_evpd_b0().

Also add emulate_caw device attribute in configfs (enabled by default)
to allow the exposure of this bit to be disabled, if necessary.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_configfs.c |    4 ++++
 drivers/target/target_core_device.c   |   14 ++++++++++++++
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_spc.c      |    5 +++++
 include/target/target_core_base.h     |    3 +++
 5 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f67a9af..24517d4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -636,6 +636,9 @@ SE_DEV_ATTR(emulate_tpu, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_tpws);
 SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_caw);
+SE_DEV_ATTR(emulate_caw, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
@@ -693,6 +696,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tas.attr,
 	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_emulate_tpws.attr,
+	&target_core_dev_attrib_emulate_caw.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_is_nonrot.attr,
 	&target_core_dev_attrib_emulate_rest_reord.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8f4142f..0b5f868 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -890,6 +890,19 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_emulate_caw(struct se_device *dev, int flag)
+{
+	if (flag != 0 && flag != 1) {
+		pr_err("Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+	dev->dev_attrib.emulate_caw = flag;
+	pr_debug("dev[%p]: SE Device CompareAndWrite (AtomicTestandSet): %d\n",
+		 dev, flag);
+
+	return 0;
+}
+
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1423,6 +1436,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_tas = DA_EMULATE_TAS;
 	dev->dev_attrib.emulate_tpu = DA_EMULATE_TPU;
 	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
+	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.is_nonrot = DA_IS_NONROT;
 	dev->dev_attrib.emulate_rest_reord = DA_EMULATE_REST_REORD;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 18d49df..805ceb4 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -33,6 +33,7 @@ int	se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
 int	se_dev_set_emulate_tas(struct se_device *, int);
 int	se_dev_set_emulate_tpu(struct se_device *, int);
 int	se_dev_set_emulate_tpws(struct se_device *, int);
+int	se_dev_set_emulate_caw(struct se_device *, int);
 int	se_dev_set_enforce_pr_isids(struct se_device *, int);
 int	se_dev_set_is_nonrot(struct se_device *, int);
 int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 4cb667d..ed7077a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -457,6 +457,11 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 
 	/* Set WSNZ to 1 */
 	buf[4] = 0x01;
+	/*
+	 * Set MAXIMUM COMPARE AND WRITE LENGTH
+	 */
+	if (dev->dev_attrib.emulate_caw)
+		buf[5] = 0x01;
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index eb439e7..53eea33 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -97,6 +97,8 @@
  * block/blk-lib.c:blkdev_issue_discard()
  */
 #define DA_EMULATE_TPWS				0
+/* Emulation for CompareAndWrite (AtomicTestandSet) by default */
+#define DA_EMULATE_CAW				1
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_ALUA				0
 /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
@@ -602,6 +604,7 @@ struct se_dev_attrib {
 	int		emulate_tas;
 	int		emulate_tpu;
 	int		emulate_tpws;
+	int		emulate_caw;
 	int		enforce_pr_isids;
 	int		is_nonrot;
 	int		emulate_rest_reord;
-- 
1.7.2.5
