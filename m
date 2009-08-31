From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [Target_Core_Mod/ALUA]: Add support for saving primary
	port metadata across target power loss
Date: Mon, 31 Aug 2009 01:25:59 -0700
Message-ID: <1251707159.4136.38.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:30582 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752608AbZHaI33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2009 04:29:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hello,

This patch adds core_alua_update_tpg_primary_metadata() for saving ALUA target port group
primary access state and status in core_alua_do_transition_tg_pt() to struct file on a per
TCM storage object basis /var/target/alua/tpgs_$T10_UNIT_SERIAL/$TG_PT_GP_NAME.  The writing to
each struct file is protected by t10_alua_tg_pt_gp_t->tg_pt_gp_md_mutex.

This patch updates core_alua_do_port_transition() to allocate a local scope buffer of
t10_alua_tg_pt_gp_t->tg_pt_gp_md_buf_len (1024 hardcoded default), and that is then
passed into core_alua_do_transition_tg_pt() for actual ALUA primary state transition, and
freed upon core_alua_do_port_transition() return.  The following ALUA metadata key=value pairs
that are written to struct file for both implict and explict ALUA transitions operations are:

*) tg_pt_gp_id=  Used for cross checking ID when being loaded during bringup
*) alua_access_state=  ALUA primary access state
*) alua_access_status=  ALUA primary access status

This patch also makes the following changes to storage object ALUA configfs attributes
in /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP_NAME:

*) Make 'alua_access_status' writeable for processing key=value from struct file
*) Add 'alua_write_metadata' attribute for allowing configuration to enable/disable
   the writing of ALUA target port group primary access state/status to struct file.
   Does not affect ALUA fabric level operation

The reason why only dump state and status is because these are the only ALUA attributes
that can be changed during both in-band via MO SET_TARGET_PORT_GROUPs (explict) and out-of-band
via configfs (implict), while the other ALUA attributes can only be changed from configfs operations
and not via in-band means.

Note that this patch expects the other attributes (alua_access_type, nonop_delay_msecs, preferred)
in /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP_NAME that *cannot* be changed via
explict ALUA with MO SET_TARGET_PORT_GROUPS to still need to be saved using tcm_dump.py
from userspace to make those configuration changes persistent across target power loss and reboots.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c     |   89 ++++++++++++++++++++++++++++++++-
 drivers/target/target_core_configfs.c |   75 +++++++++++++++++++++++++++-
 include/target/target_core_alua.h     |    2 +-
 include/target/target_core_base.h     |    5 ++
 4 files changed, 167 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 0845436..4b92663 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -613,10 +613,66 @@ int core_alua_check_nonop_delay(
 }
 EXPORT_SYMBOL(core_alua_check_nonop_delay);
 
+/*
+ * Called with tg_pt_gp->tg_pt_gp_md_mutex held
+ */
+int core_alua_update_tpg_primary_metadata(
+	t10_alua_tg_pt_gp_t *tg_pt_gp,
+	int primary_state,
+	unsigned char *md_buf)
+{
+	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
+	t10_wwn_t *wwn = &su_dev->t10_wwn;
+	struct file *file;
+	struct iovec iov[1];
+	mm_segment_t old_fs;
+	char path[512];
+	int flags = O_RDWR | O_CREAT | O_TRUNC;
+	int len, ret;
+
+	memset(iov, 0, sizeof(struct iovec));
+	memset(path, 0, 512);
+
+	len = snprintf(md_buf, tg_pt_gp->tg_pt_gp_md_buf_len,
+			"tg_pt_gp_id=%hu\n"
+			"alua_access_state=0x%02x\n"
+			"alua_access_status=0x%02x\n",
+			tg_pt_gp->tg_pt_gp_id, primary_state,
+			tg_pt_gp->tg_pt_gp_alua_access_status);
+
+	snprintf(path, 512, "/var/target/alua/tpgs_%s/%s",
+		&wwn->unit_serial[0],
+		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
+	file = filp_open(path, flags, 0600);
+	if (IS_ERR(file) || !file || !file->f_dentry) {
+		printk(KERN_ERR "filp_open(%s) for ALUA metadata failed\n",
+			path);
+		return -1;
+	}
+	
+	iov[0].iov_base = &md_buf[0];
+	iov[0].iov_len = len;
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	ret = vfs_writev(file, &iov[0], 1, &file->f_pos);
+	set_fs(old_fs);
+
+	if (ret < 0) {
+		printk("Error writing ALUA metadata file: %s\n", path);	
+		filp_close(file, NULL);
+		return -1;
+	}
+	filp_close(file, NULL);
+
+	return 0;
+}
+
 int core_alua_do_transition_tg_pt(
 	t10_alua_tg_pt_gp_t *tg_pt_gp,
 	se_port_t *l_port,
 	se_node_acl_t *nacl,
+	unsigned char *md_buf,
 	int new_state,
 	int explict)
 {
@@ -684,6 +740,24 @@ int core_alua_do_transition_tg_pt(
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
+	 * Update the ALUA metadata buf that has been allocated in
+	 * core_alua_do_port_transition(), this metadata will be written
+	 * to struct file.
+	 *
+	 * Note that there is the case where we do not want to update the
+	 * metadata when the saved metadata is being parsed in userspace
+	 * when setting the existing port access state and access status.
+	 *
+	 * Also note that the failure to write out the ALUA metadata to
+	 * struct file does NOT affect the actual ALUA transition.
+	 */
+	if (tg_pt_gp->tg_pt_gp_write_metadata) {
+		mutex_lock(&tg_pt_gp->tg_pt_gp_md_mutex);
+		core_alua_update_tpg_primary_metadata(tg_pt_gp,
+					new_state, md_buf);
+		mutex_unlock(&tg_pt_gp->tg_pt_gp_md_mutex);
+	}
+	/*
 	 * Set the current primary ALUA access state to the requested new state
 	 */
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state, new_state);
@@ -712,11 +786,18 @@ int core_alua_do_port_transition(
 	t10_alua_lu_gp_t *lu_gp;
 	t10_alua_lu_gp_member_t *lu_gp_mem, *local_lu_gp_mem;
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	unsigned char *md_buf;
 	int primary;
 
 	if (core_alua_check_transition(new_state, &primary) != 0)
 		return -1;
 
+	md_buf = kzalloc(l_tg_pt_gp->tg_pt_gp_md_buf_len, GFP_KERNEL);
+	if (!(md_buf)) {
+		printk("Unable to allocate buf for ALUA metadata\n");
+		return -1;
+	}
+
 	local_lu_gp_mem = l_dev->dev_alua_lu_gp_mem;
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = local_lu_gp_mem->lu_gp;
@@ -734,9 +815,10 @@ int core_alua_do_port_transition(
 		 * success.
 		 */
 		core_alua_do_transition_tg_pt(l_tg_pt_gp, l_port, l_nacl,
-					new_state, explict);
+					md_buf, new_state, explict);
 		atomic_dec(&lu_gp->lu_gp_ref_cnt);
 		smp_mb__after_atomic_dec();
+		kfree(md_buf);
 		return 0;
 	}
 	/*
@@ -787,7 +869,7 @@ int core_alua_do_port_transition(
 			 * success.
 			 */
 			core_alua_do_transition_tg_pt(tg_pt_gp, port,
-					nacl, new_state, explict);
+					nacl, md_buf, new_state, explict);
 
 			spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
@@ -809,6 +891,7 @@ int core_alua_do_port_transition(
 
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
 	smp_mb__after_atomic_dec();
+	kfree(md_buf);
 	return 0;
 }
 
@@ -1111,9 +1194,11 @@ t10_alua_tg_pt_gp_t *core_alua_allocate_tg_pt_gp(
 	}
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_list);
 	INIT_LIST_HEAD(&tg_pt_gp->tg_pt_gp_mem_list);
+	mutex_init(&tg_pt_gp->tg_pt_gp_md_mutex);
 	spin_lock_init(&tg_pt_gp->tg_pt_gp_lock);
 	atomic_set(&tg_pt_gp->tg_pt_gp_ref_cnt, 0);
 	tg_pt_gp->tg_pt_gp_su_dev = su_dev;
+	tg_pt_gp->tg_pt_gp_md_buf_len = ALUA_MD_BUF_LEN;
 	atomic_set(&tg_pt_gp->tg_pt_gp_alua_access_state,
 		ALUA_ACCESS_STATE_ACTIVE_OPTMIZED);
 	/*
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 360fa92..3982796 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2222,7 +2222,41 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_status(
 		core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_access_status));
 }
 
-SE_DEV_ALUA_TG_PT_ATTR_RO(alua_access_status);
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_status(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int new_status, ret;
+	
+	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
+		printk(KERN_ERR "Unable to do set ALUA access status on non"
+			" valid tg_pt_gp ID: %hu\n",
+			tg_pt_gp->tg_pt_gp_valid_id);
+		return -EINVAL;		
+	}
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract new ALUA access status"
+				" from %s\n", page);
+		return -EINVAL;
+	}
+	new_status = (int)tmp;
+
+	if ((new_status != ALUA_STATUS_NONE) &&
+	    (new_status != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
+	    (new_status != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
+		printk(KERN_ERR "Illegal ALUA access status: 0x%02x\n", new_status);
+		return -EINVAL;
+	}
+
+	tg_pt_gp->tg_pt_gp_alua_access_status = new_status;
+	return count;
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(alua_access_status, S_IRUGO | S_IWUSR);
 
 /*
  * alua_access_type
@@ -2245,6 +2279,44 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_type(
 SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
 
 /*
+ * alua_write_metadata
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_write_metadata(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_write_metadata);
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_write_metadata(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract alua_write_metadata\n");	
+		return -EINVAL;
+	}
+
+	if ((tmp != 0) && (tmp != 1)) {
+		printk(KERN_ERR "Illegal value for alua_write_metadata:"
+			" %lu\n", tmp);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_write_metadata = (int)tmp;
+
+	return count;
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(alua_write_metadata, S_IRUGO | S_IWUSR);
+
+
+
+/*
  * nonop_delay_msecs
  */
 static ssize_t target_core_alua_tg_pt_gp_show_attr_nonop_delay_msecs(
@@ -2406,6 +2478,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
 	&target_core_alua_tg_pt_gp_alua_access_status.attr,
 	&target_core_alua_tg_pt_gp_alua_access_type.attr,
+	&target_core_alua_tg_pt_gp_alua_write_metadata.attr,
 	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_trans_delay_msecs.attr,
 	&target_core_alua_tg_pt_gp_preferred.attr,
diff --git a/include/target/target_core_alua.h b/include/target/target_core_alua.h
index 0229e18..7aa3b5d 100644
--- a/include/target/target_core_alua.h
+++ b/include/target/target_core_alua.h
@@ -66,7 +66,7 @@ extern int core_alua_check_transition(int, int *);
 extern int core_alua_check_nonop_delay(struct se_cmd_s *);
 extern int core_alua_do_transition_tg_pt(struct t10_alua_tg_pt_gp_s *,
 				struct se_port_s *, struct se_node_acl_s *,
-				int, int);
+				unsigned char *, int, int);
 extern int core_alua_do_port_transition(struct t10_alua_tg_pt_gp_s *,
 				struct se_device_s *, struct se_port_s *,
 				struct se_node_acl_s *, int, int);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8bf7877..d166606 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -77,6 +77,8 @@
 #define PR_APTPL_MAX_TPORT_LEN			256
 /* Used by t10_reservation_template_s->pr_aptpl_buf_len */
 #define PR_APTPL_BUF_LEN			8192
+/* Used by t10_alua_tg_pt_gp_t->tg_pt_gp_md_buf_len */
+#define ALUA_MD_BUF_LEN				1024
 
 /* used by PSCSI and iBlock Transport drivers */
 #define READ_BLOCK_LEN          		6
@@ -269,10 +271,13 @@ typedef struct t10_alua_tg_pt_gp_s {
 	int	tg_pt_gp_nonop_delay_msecs;
 	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_pref;
+	int	tg_pt_gp_write_metadata;
+	u32	tg_pt_gp_md_buf_len;
 	u32	tg_pt_gp_members;
 	atomic_t tg_pt_gp_alua_access_state;
 	atomic_t tg_pt_gp_ref_cnt;
 	spinlock_t tg_pt_gp_lock;
+	struct mutex tg_pt_gp_md_mutex;
 	struct se_subsystem_dev_s *tg_pt_gp_su_dev;
 	struct config_group tg_pt_gp_group;
 	struct list_head tg_pt_gp_list;
-- 
1.5.4.1




