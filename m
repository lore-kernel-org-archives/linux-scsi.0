From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 8/9] target: Add Third Party Copy (3PC) bit in INQUIRY response
Date: Fri, 23 Aug 2013 02:27:00 +0000
Message-ID: <1377224821-23422-9-git-send-email-nab@daterainc.com>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds the Third Party Copy (3PC) bit to signal support
for EXTENDED_COPY within standard inquiry response data.

Also add emulate_3pc device attribute in configfs (enabled by default)
to allow the exposure of this bit to be disabled, if necessary.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_configfs.c |    4 ++++
 drivers/target/target_core_device.c   |   14 ++++++++++++++
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_spc.c      |    6 ++++++
 include/target/target_core_base.h     |    3 +++
 5 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 939ecc5..026e42b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -639,6 +639,9 @@ SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_caw);
 SE_DEV_ATTR(emulate_caw, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(emulate_3pc);
+SE_DEV_ATTR(emulate_3pc, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
@@ -697,6 +700,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_emulate_caw.attr,
+	&target_core_dev_attrib_emulate_3pc.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_is_nonrot.attr,
 	&target_core_dev_attrib_emulate_rest_reord.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 458944e..6f492c7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -906,6 +906,19 @@ int se_dev_set_emulate_caw(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_emulate_3pc(struct se_device *dev, int flag)
+{
+	if (flag != 0 && flag != 1) {
+		pr_err("Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+	dev->dev_attrib.emulate_3pc = flag;
+	pr_debug("dev[%p]: SE Device 3rd Party Copy (EXTENDED_COPY): %d\n",
+		dev, flag);
+
+	return 0;
+}
+
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1442,6 +1455,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_tpu = DA_EMULATE_TPU;
 	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
+	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.is_nonrot = DA_IS_NONROT;
 	dev->dev_attrib.emulate_rest_reord = DA_EMULATE_REST_REORD;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 805ceb4..579128a 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -34,6 +34,7 @@ int	se_dev_set_emulate_tas(struct se_device *, int);
 int	se_dev_set_emulate_tpu(struct se_device *, int);
 int	se_dev_set_emulate_tpws(struct se_device *, int);
 int	se_dev_set_emulate_caw(struct se_device *, int);
+int	se_dev_set_emulate_3pc(struct se_device *, int);
 int	se_dev_set_enforce_pr_isids(struct se_device *, int);
 int	se_dev_set_is_nonrot(struct se_device *, int);
 int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 894e83b..566dd27 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -95,6 +95,12 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	 */
 	spc_fill_alua_data(lun->lun_sep, buf);
 
+	/*
+	 * Set Third-Party Copy (3PC) bit to indicate support for EXTENDED_COPY
+	 */
+	if (dev->dev_attrib.emulate_3pc)
+		buf[5] |= 0x8;
+
 	buf[7] = 0x2; /* CmdQue=1 */
 
 	snprintf(&buf[8], 8, "LIO-ORG");
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f54a015..ba9ca79 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -99,6 +99,8 @@
 #define DA_EMULATE_TPWS				0
 /* Emulation for CompareAndWrite (AtomicTestandSet) by default */
 #define DA_EMULATE_CAW				1
+/* Emulation for 3rd Party Copy (ExtendedCopy) by default */
+#define DA_EMULATE_3PC				1
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_ALUA				0
 /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
@@ -606,6 +608,7 @@ struct se_dev_attrib {
 	int		emulate_tpu;
 	int		emulate_tpws;
 	int		emulate_caw;
+	int		emulate_3pc;
 	int		enforce_pr_isids;
 	int		is_nonrot;
 	int		emulate_rest_reord;
-- 
1.7.2.5
