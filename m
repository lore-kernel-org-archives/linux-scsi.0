From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/4] [TCM/ConfigFS]: Add per-device attribute 'enforce_pr_isids'
Date: Mon, 12 Apr 2010 22:49:25 -0700
Message-ID: <1271137765-23399-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:23789 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751458Ab0DMFIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 01:08:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a per-device configfs attribute for enforce persistent
reservation ISIDs at:

/sys/kernel/config/target/core/$HBA/$DEV/attrib/enforce_pr_isids

By default this is '1', which means that ISID matching for PR operations
will be strictly enforced in target_core_pr.c:__core_scsi3_locate_pr_reg()
This means that an SCSI Initiator Port using ISIDs for TransportIDs must
supply the same ISID in order to access an existing PR registration or
reservation, otherwise the SCSI Initiator Port will be expected to perform
a new PR registration.

When this attribute is disabled with '0', PR registrations created without an
ISID (from ALL_TG_PT=1 and SPEC_I_PT=1 TransportIDs for example) will be allowed
to match in __core_scsi3_locate_pr_reg(), allowing for a level of compatibility
with persistent reservation consumers w/o using ISID aware TransportIDs.

This attribute may end up going away at some point, but it is useful now for
supporting all possible persistent reservation scenarios.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    4 ++++
 drivers/target/target_core_device.c    |   12 ++++++++++++
 include/target/target_core_device.h    |    1 +
 include/target/target_core_transport.h |    2 ++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3d0e263..b8f05a5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -527,6 +527,9 @@ SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(emulate_tas);
 SE_DEV_ATTR(emulate_tas, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB(enforce_pr_isids);
+SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -553,6 +556,7 @@ CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib_s, da_group);
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
+	&target_core_dev_attrib_enforce_pr_isids.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b0cbf8d..cfa3e9b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1003,6 +1003,7 @@ void se_dev_set_default_attribs(se_device_t *dev)
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
+	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	/*
 	 * block_size is based on subsystem plugin dependent requirements.
 	 */
@@ -1089,6 +1090,17 @@ int se_dev_set_emulate_tas(se_device_t *dev, int flag)
 	return 0;
 }
 
+int se_dev_set_enforce_pr_isids(se_device_t *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	DEV_ATTRIB(dev)->enforce_pr_isids = flag;
+	printk(KERN_INFO "dev[%p]: SE Device enforce_pr_isids bit: %s\n", dev,
+		(DEV_ATTRIB(dev)->enforce_pr_isids) ? "Enabled" : "Disabled");
+	return 0;
+}
 /*
  * Note, this can only be called on unexported SE Device Object.
  */
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 6268919..ad8407f 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -63,6 +63,7 @@ extern void se_dev_set_default_attribs(se_device_t *);
 extern int se_dev_set_task_timeout(se_device_t *, u32);
 extern int se_dev_set_emulate_ua_intlck_ctrl(se_device_t *, int);
 extern int se_dev_set_emulate_tas(se_device_t *, int);
+extern int se_dev_set_enforce_pr_isids(se_device_t *, int);
 extern int se_dev_set_queue_depth(se_device_t *, u32);
 extern int se_dev_set_max_sectors(se_device_t *, u32);
 extern int se_dev_set_block_size(se_device_t *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index a049053..f85cd62 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -109,6 +109,8 @@
 #define DA_EMULATE_RESERVATIONS			0
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_ALUA				0
+/* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
+#define DA_ENFORCE_PR_ISIDS			1
 #define DA_STATUS_MAX_SECTORS_MIN		16
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 
-- 
1.5.6.5

