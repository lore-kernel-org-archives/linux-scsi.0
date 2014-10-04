From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] target: Add force_pr_aptpl device attribute
Date: Sat,  4 Oct 2014 05:14:25 +0000
Message-ID: <1412399665-15057-2-git-send-email-nab@daterainc.com>
References: <1412399665-15057-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:45857 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaJDFnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Oct 2014 01:43:25 -0400
Received: by mail-oi0-f51.google.com with SMTP id e131so1662025oig.38
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2014 22:43:24 -0700 (PDT)
In-Reply-To: <1412399665-15057-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a force_pr_aptpl device attribute used to force SPC-3 PR
Activate Persistence across Target Power Loss (APTPL) operation.  This
makes PR metadata write-out occur during state change regardless if new
PERSISTENT_RESERVE_OUT CDBs have their APTPL feature bit set.

This is useful during H/A failover in active/passive setups where all PR
state is being re-created on a different node, driven by configfs backend
device + export layout and pre-loaded $DEV/pr/res_aptpl_metadata.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 ++++
 drivers/target/target_core_device.c   |   18 ++++++++++++++++++
 drivers/target/target_core_internal.h |    1 +
 drivers/target/target_core_pr.c       |    9 +++++++++
 include/target/target_core_base.h     |    3 +++
 5 files changed, 35 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 291dc71..b30fc8f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -665,6 +665,9 @@ SE_DEV_ATTR(is_nonrot, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_rest_reord);
 SE_DEV_ATTR(emulate_rest_reord, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(force_pr_aptpl);
+SE_DEV_ATTR(force_pr_aptpl, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -719,6 +722,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_hw_pi_prot_type.attr,
 	&target_core_dev_attrib_pi_prot_format.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
+	&target_core_dev_attrib_force_pr_aptpl.attr,
 	&target_core_dev_attrib_is_nonrot.attr,
 	&target_core_dev_attrib_emulate_rest_reord.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d18dd8b..c45f9e9 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1018,6 +1018,23 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_force_pr_aptpl(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+	if (dev->export_count) {
+		pr_err("dev[%p]: Unable to set force_pr_aptpl while"
+		       " export_count is %d\n", dev, dev->export_count);
+		return -EINVAL;
+	}
+
+	dev->dev_attrib.force_pr_aptpl = flag;
+	pr_debug("dev[%p]: SE Device force_pr_aptpl: %d\n", dev, flag);
+	return 0;
+}
+
 int se_dev_set_is_nonrot(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1544,6 +1561,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
 	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
+	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
 	dev->dev_attrib.is_nonrot = DA_IS_NONROT;
 	dev->dev_attrib.emulate_rest_reord = DA_EMULATE_REST_REORD;
 	dev->dev_attrib.max_unmap_lba_count = DA_MAX_UNMAP_LBA_COUNT;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 42ef4ab..e31f42f 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -38,6 +38,7 @@ int	se_dev_set_emulate_3pc(struct se_device *, int);
 int	se_dev_set_pi_prot_type(struct se_device *, int);
 int	se_dev_set_pi_prot_format(struct se_device *, int);
 int	se_dev_set_enforce_pr_isids(struct se_device *, int);
+int	se_dev_set_force_pr_aptpl(struct se_device *, int);
 int	se_dev_set_is_nonrot(struct se_device *, int);
 int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
 int	se_dev_set_queue_depth(struct se_device *, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a06edb5..8c60a1a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -895,6 +895,7 @@ static int __core_scsi3_check_aptpl_registration(
 	spin_lock(&pr_tmpl->aptpl_reg_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
 				pr_reg_aptpl_list) {
+
 		if (!strcmp(pr_reg->pr_iport, i_port) &&
 		     (pr_reg->pr_res_mapped_lun == deve->mapped_lun) &&
 		    !(strcmp(pr_reg->pr_tport, t_port)) &&
@@ -3470,6 +3471,7 @@ static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
 sense_reason_t
 target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 {
+	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = &cmd->t_task_cdb[0];
 	unsigned char *buf;
 	u64 res_key, sa_res_key;
@@ -3534,6 +3536,13 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		aptpl = (buf[17] & 0x01);
 		unreg = (buf[17] & 0x02);
 	}
+	/*
+	 * If the backend device has been configured to force APTPL metadata
+	 * write-out, go ahead and propigate aptpl=1 down now.
+	 */
+	if (dev->dev_attrib.force_pr_aptpl)
+		aptpl = 1;
+
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b106240..23c518a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -108,6 +108,8 @@
 #define DA_EMULATE_ALUA				0
 /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
 #define DA_ENFORCE_PR_ISIDS			1
+/* Force SPC-3 PR Activate Persistence across Target Power Loss */
+#define DA_FORCE_PR_APTPL			0
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 /* By default don't report non-rotating (solid state) medium */
@@ -680,6 +682,7 @@ struct se_dev_attrib {
 	enum target_prot_type pi_prot_type;
 	enum target_prot_type hw_pi_prot_type;
 	int		enforce_pr_isids;
+	int		force_pr_aptpl;
 	int		is_nonrot;
 	int		emulate_rest_reord;
 	u32		hw_block_size;
-- 
1.7.10.4

