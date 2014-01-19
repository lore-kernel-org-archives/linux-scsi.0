From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 09/17] target/configfs: Expose protection device attributes
Date: Sun, 19 Jan 2014 02:44:32 +0000
Message-ID: <1390099480-29013-10-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for exposing DIF protection device
attributes via configfs.  This includes:

   pi_prot_type: Protection Type (0, 1, 3 currently support)
   pi_prot_format: Protection Format Operation (FILEIO only)

Within se_dev_set_pi_prot_type() it also adds the se_subsystem_api
device callbacks to setup per device protection information.

v2 changes:
  - Drop pi_guard_type + pi_prot_version related code (MKP)
  - Add pi_prot_format logic (Sagi)
  - Add ->free_prot callback in target_free_device
  - Add hw_pi_prot_type read-only attribute

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   12 +++++
 drivers/target/target_core_device.c   |   89 +++++++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h |    2 +
 3 files changed, 103 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 5cf6135..f0e85b1 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -643,6 +643,15 @@ SE_DEV_ATTR(emulate_caw, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_3pc);
 SE_DEV_ATTR(emulate_3pc, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(pi_prot_type);
+SE_DEV_ATTR(pi_prot_type, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB_RO(hw_pi_prot_type);
+SE_DEV_ATTR_RO(hw_pi_prot_type);
+
+DEF_DEV_ATTRIB(pi_prot_format);
+SE_DEV_ATTR(pi_prot_format, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
@@ -702,6 +711,9 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_emulate_caw.attr,
 	&target_core_dev_attrib_emulate_3pc.attr,
+	&target_core_dev_attrib_pi_prot_type.attr,
+	&target_core_dev_attrib_hw_pi_prot_type.attr,
+	&target_core_dev_attrib_pi_prot_format.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_is_nonrot.attr,
 	&target_core_dev_attrib_emulate_rest_reord.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3244058..883099e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -918,6 +918,90 @@ int se_dev_set_emulate_3pc(struct se_device *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
+{
+	int rc, old_prot = dev->dev_attrib.pi_prot_type;
+
+	if (flag != 0 && flag != 1 && flag != 2 && flag != 3) {
+		pr_err("Illegal value %d for pi_prot_type\n", flag);
+		return -EINVAL;
+	}
+	if (flag == 2) {
+		pr_err("DIF TYPE2 protection currently not supported\n");
+		return -ENOSYS;
+	}
+	if (dev->dev_attrib.hw_pi_prot_type) {
+		pr_warn("DIF protection enabled on underlying hardware,"
+			" ignoring\n");
+		return 0;
+	}
+	if (!dev->transport->init_prot || !dev->transport->free_prot) {
+		pr_err("DIF protection not supported by backend: %s\n",
+		       dev->transport->name);
+		return -ENOSYS;
+	}
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("DIF protection requires device to be configured\n");
+		return -ENODEV;
+	}
+	if (dev->export_count) {
+		pr_err("dev[%p]: Unable to change SE Device PROT type while"
+		       " export_count is %d\n", dev, dev->export_count);
+		return -EINVAL;
+	}
+
+	dev->dev_attrib.pi_prot_type = flag;
+
+	if (flag && !old_prot) {
+		rc = dev->transport->init_prot(dev);
+		if (rc) {
+			dev->dev_attrib.pi_prot_type = old_prot;
+			return rc;
+		}
+
+	} else if (!flag && old_prot) {
+		dev->transport->free_prot(dev);
+	}
+	pr_debug("dev[%p]: SE Device Protection Type: %d\n", dev, flag);
+
+	return 0;
+}
+
+int se_dev_set_pi_prot_format(struct se_device *dev, int flag)
+{
+	int rc;
+
+	if (!flag)
+		return 0;
+
+	if (flag != 1) {
+		pr_err("Illegal value %d for pi_prot_format\n", flag);
+		return -EINVAL;
+	}
+	if (!dev->transport->format_prot) {
+		pr_err("DIF protection format not supported by backend %s\n",
+		       dev->transport->name);
+		return -ENOSYS;
+	}
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("DIF protection format requires device to be configured\n");
+		return -ENODEV;
+	}
+	if (dev->export_count) {
+		pr_err("dev[%p]: Unable to format SE Device PROT type while"
+		       " export_count is %d\n", dev, dev->export_count);
+		return -EINVAL;
+	}
+
+	rc = dev->transport->format_prot(dev);
+	if (rc)
+		return rc;
+
+	pr_debug("dev[%p]: SE Device Protection Format complete\n", dev);
+
+	return 0;
+}
+
 int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
@@ -1415,6 +1499,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_link_magic = SE_DEV_LINK_MAGIC;
 	dev->se_hba = hba;
 	dev->transport = hba->transport;
+	dev->prot_length = sizeof(struct se_dif_v1_tuple);
 
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
@@ -1457,6 +1542,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
+	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.is_nonrot = DA_IS_NONROT;
 	dev->dev_attrib.emulate_rest_reord = DA_EMULATE_REST_REORD;
@@ -1589,6 +1675,9 @@ void target_free_device(struct se_device *dev)
 	core_scsi3_free_all_registrations(dev);
 	se_release_vpd_for_dev(dev);
 
+	if (dev->transport->free_prot)
+		dev->transport->free_prot(dev);
+
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 1e27614..de9cab7 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -35,6 +35,8 @@ int	se_dev_set_emulate_tpu(struct se_device *, int);
 int	se_dev_set_emulate_tpws(struct se_device *, int);
 int	se_dev_set_emulate_caw(struct se_device *, int);
 int	se_dev_set_emulate_3pc(struct se_device *, int);
+int	se_dev_set_pi_prot_type(struct se_device *, int);
+int	se_dev_set_pi_prot_format(struct se_device *, int);
 int	se_dev_set_enforce_pr_isids(struct se_device *, int);
 int	se_dev_set_is_nonrot(struct se_device *, int);
 int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
-- 
1.7.10.4
