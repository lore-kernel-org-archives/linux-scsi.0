From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] tcm: Add WriteCache and FUADPO infrastructure and attributes
Date: Thu, 26 Aug 2010 21:32:56 -0700
Message-ID: <1282883576-10830-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds six new struct se_subsystem_api releated to
WriteCache emulation support, FUA Write, FUA READ and DPO.  The main two
for the SYNCHRONIZE_CACHE* op path callers are:

	/*
	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE has been
	 * received with WriteCache=1
	 */
	void (*do_sync_cache)(struct se_cmd *);
	/*
	 * do_sync_cache_range():
	 *
	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE w/ explict
	 * LBA + Range has been received with WriteCache=1
	 */
	void (*do_sync_cache_range)(struct se_cmd *, unsigned long long, u32)

that are used in the following patch.

This patch also adds the four (emulate_write_cache, emulate_fua_write,
emulate_fua_read, emulate_dpo) new struct se_dev_attrib values releated to
WriteCache, FUA and DPO configuration on a per struct se_device basis in:

	 /sys/kernel/config/target/core/$SUBNAME_$HBAID/$DEV/attrib/

It also sets the following hardcoded defaults, where are listed in the
diff for include/target/target_core_transport.h:

	/* Emulation for Direct Page Out */
	#define DA_EMULATE_DPO                         0
	/* Emulation for Forced Unit Access WRITEs */
	#define DA_EMULATE_FUA_WRITE                   1
	/* Emulation for Forced Unit Access READs */
	#define DA_EMULATE_FUA_READ                    0
	/* Emulation for WriteCache and SYNCHRONIZE_CACHE */
	#define DA_EMULATE_WRITE_CACHE                 0

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |   16 ++++++
 drivers/target/target_core_device.c    |   84 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    4 ++
 include/target/target_core_device.h    |    4 ++
 include/target/target_core_transport.h |   39 +++++++++++++++
 5 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b48340a..3e71fa9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -545,6 +545,18 @@ static struct target_core_dev_attrib_attribute				\
 	__CONFIGFS_EATTR_RO(_name,					\
 	target_core_dev_show_attr_##_name);
 
+DEF_DEV_ATTRIB(emulate_dpo);
+SE_DEV_ATTR(emulate_dpo, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(emulate_fua_write);
+SE_DEV_ATTR(emulate_fua_write, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(emulate_fua_read);
+SE_DEV_ATTR(emulate_fua_read, S_IRUGO | S_IWUSR);
+
+DEF_DEV_ATTRIB(emulate_write_cache);
+SE_DEV_ATTR(emulate_write_cache, S_IRUGO | S_IWUSR);
+
 DEF_DEV_ATTRIB(emulate_ua_intlck_ctrl);
 SE_DEV_ATTR(emulate_ua_intlck_ctrl, S_IRUGO | S_IWUSR);
 
@@ -578,6 +590,10 @@ SE_DEV_ATTR(task_timeout, S_IRUGO | S_IWUSR);
 CONFIGFS_EATTR_OPS(target_core_dev_attrib, se_dev_attrib, da_group);
 
 static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
+	&target_core_dev_attrib_emulate_dpo.attr,
+	&target_core_dev_attrib_emulate_fua_write.attr,
+	&target_core_dev_attrib_emulate_fua_read.attr,
+	&target_core_dev_attrib_emulate_write_cache.attr,
 	&target_core_dev_attrib_emulate_ua_intlck_ctrl.attr,
 	&target_core_dev_attrib_emulate_tas.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index efc85be..5230e12 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1025,6 +1025,10 @@ int se_dev_check_shutdown(struct se_device *dev)
 
 void se_dev_set_default_attribs(struct se_device *dev)
 {
+	DEV_ATTRIB(dev)->emulate_dpo = DA_EMULATE_DPO;
+	DEV_ATTRIB(dev)->emulate_fua_write = DA_EMULATE_FUA_WRITE;
+	DEV_ATTRIB(dev)->emulate_fua_read = DA_EMULATE_FUA_READ;
+	DEV_ATTRIB(dev)->emulate_write_cache = DA_EMULATE_WRITE_CACHE;
 	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
 	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
@@ -1075,6 +1079,86 @@ int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
 	return 0;
 }
 
+int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	if (TRANSPORT(dev)->dpo_emulated == NULL) {
+		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated is NULL\n");
+		return -1;
+	}
+	if (TRANSPORT(dev)->dpo_emulated(dev) == 0) {
+		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated not supported\n");
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_dpo = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Page Out (DPO) Emulation"
+			" bit: %d\n", dev, DEV_ATTRIB(dev)->emulate_dpo);
+	return 0;
+}
+
+int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	if (TRANSPORT(dev)->fua_write_emulated == NULL) {
+		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated is NULL\n");
+		return -1;
+	}
+	if (TRANSPORT(dev)->fua_write_emulated(dev) == 0) {
+		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated not supported\n");
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_fua_write = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
+			dev, DEV_ATTRIB(dev)->emulate_fua_write);
+	return 0;
+}
+
+int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	if (TRANSPORT(dev)->fua_read_emulated == NULL) {
+		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated is NULL\n");
+		return -1;
+	}
+	if (TRANSPORT(dev)->fua_read_emulated(dev) == 0) {
+		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated not supported\n");
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_fua_read = flag;
+	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access READs: %d\n",
+			dev, DEV_ATTRIB(dev)->emulate_fua_read);
+	return 0;
+}
+
+int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
+{
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -1;
+	}
+	if (TRANSPORT(dev)->write_cache_emulated == NULL) {
+		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated is NULL\n");
+		return -1;
+	}
+	if (TRANSPORT(dev)->write_cache_emulated(dev) == 0) {
+		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated not supported\n");
+		return -1;
+	}
+	DEV_ATTRIB(dev)->emulate_write_cache = flag;
+	printk(KERN_INFO "dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
+			dev, DEV_ATTRIB(dev)->emulate_write_cache);
+	return 0;
+}
+
 int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1) && (flag != 2)) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d82641..a32762c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -707,6 +707,10 @@ struct se_dev_entry {
 }  ____cacheline_aligned;
 
 struct se_dev_attrib {
+	int		emulate_dpo;
+	int		emulate_fua_write;
+	int		emulate_fua_read;
+	int		emulate_write_cache;
 	int		emulate_ua_intlck_ctrl;
 	int		emulate_tas;
 	int		emulate_reservations;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index e895604..283ccc7 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -66,6 +66,10 @@ extern int se_dev_check_online(struct se_device *);
 extern int se_dev_check_shutdown(struct se_device *);
 extern void se_dev_set_default_attribs(struct se_device *);
 extern int se_dev_set_task_timeout(struct se_device *, u32);
+extern int se_dev_set_emulate_dpo(struct se_device *, int);
+extern int se_dev_set_emulate_fua_write(struct se_device *, int);
+extern int se_dev_set_emulate_fua_read(struct se_device *, int);
+extern int se_dev_set_emulate_write_cache(struct se_device *, int);
 extern int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *, int);
 extern int se_dev_set_emulate_tas(struct se_device *, int);
 extern int se_dev_set_enforce_pr_isids(struct se_device *, int);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index d1a3a9a..fa59ed7 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -115,6 +115,14 @@
 /* struct se_dev_attrib sanity values */
 /* 10 Minutes, see transport_get_default_task_timeout()  */
 #define DA_TASK_TIMEOUT_MAX			600
+/* Emulation for Direct Page Out */
+#define DA_EMULATE_DPO				0
+/* Emulation for Forced Unit Access WRITEs */
+#define DA_EMULATE_FUA_WRITE			1
+/* Emulation for Forced Unit Access READs */
+#define DA_EMULATE_FUA_READ			0
+/* Emulation for WriteCache and SYNCHRONIZE_CACHE */
+#define DA_EMULATE_WRITE_CACHE			0
 /* Emulation for UNIT ATTENTION Interlock Control */
 #define DA_EMULATE_UA_INTLLCK_CTRL		0
 /* Emulation for TASK_ABORTED status (TAS) by default */
@@ -170,6 +178,7 @@ extern struct se_queue_req *__transport_get_qr_from_queue(
 					struct se_queue_obj *);
 extern void transport_remove_cmd_from_queue(struct se_cmd *,
 					    struct se_queue_obj *);
+extern void transport_complete_sync_cache(struct se_cmd *, int);
 extern void transport_complete_cmd(struct se_cmd *, int);
 extern void transport_complete_task(struct se_task *, int);
 extern void transport_add_task_to_execute_queue(struct se_task *,
@@ -409,6 +418,36 @@ struct se_subsystem_api {
 	 */
 	int (*do_tmr)(struct se_cmd *cmd);
 	/*
+	 * do_sync_cache():
+	 *
+	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE has been
+	 * received with WriteCache=1
+	 */
+	void (*do_sync_cache)(struct se_cmd *);
+	/*
+	 * do_sync_cache_range():
+	 *
+	 * Notify subsystem backstore when a SYNCHRONIZE_CACHE w/ explict
+	 * LBA + Range has been received with WriteCache=1
+	 */
+	void (*do_sync_cache_range)(struct se_cmd *, unsigned long long, u32);
+	/*
+	 * dpo_emulated():
+	 */
+	int (*dpo_emulated)(struct se_device *);
+	/*
+	 * fua_write_emulated():
+	 */
+	int (*fua_write_emulated)(struct se_device *);
+	/*
+	 * fua_read_emulated():
+	 */
+	int (*fua_read_emulated)(struct se_device *);
+	/*
+	 * write_cache_emulated():
+	 */
+	int (*write_cache_emulated)(struct se_device *);
+	/*
 	 * transport_complete():
 	 *
 	 * Use transport_generic_complete() for majority of DAS transport
-- 
1.5.6.5
