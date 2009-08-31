From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [Target_Core_Mod/ALUA]: Add support for saving
	secondary fabric port metadata across target power loss
Date: Mon, 31 Aug 2009 01:26:43 -0700
Message-ID: <1251707203.4136.40.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752715AbZHaI3g@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Alasdair G Kergon <agk@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch adds core_alua_update_tpg_secondary_metadata() for saving ALUA target target group
secondary access state and status in core_alua_set_tg_pt_secondary_state() on a per TCM
fabric Port/LUN basis in /var/target/alua/$FABRIC/$FABRIC_ENDPOINT/.  The
writing to each struct file is protected by se_port_t->sep_tg_pt_md_mutex.

This patch updates core_alua_set_tg_pt_secondary_state() to allocate a local
scope buffer of t10_alua_tg_pt_gp_t->tg_pt_gp_md_buf_len (1024 hardcoded
default), and that is then passed into core_alua_update_tpg_secondary_metadata()
for the acual ALUA secondary state transition, and freed upon
core_alua_set_tg_pt_secondary_state() return.

This patch adds the fabric configfs wrappers for handling ALUA secondary access
metadata that are defined as EXPORT_SYMBOL() and called by TCM fabric module code

*) core_alua_show_secondary_status()
*) core_alua_store_secondary_status(),
*) core_alua_show_secondary_write_metadata()
*) core_alua_store_secondary_write_metadata()

This patch also moves the vfs_writev() to struct file for ALUA metadata code
to a generic function in core_alua_write_tpg_metadata() and adds
core_alua_update_tpg_primary_metadata() to use this code for ALUA primary
access state/status metadata writeout as well.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c |  193 ++++++++++++++++++++++++++++++++-----
 include/target/target_core_alua.h |   15 +++-
 include/target/target_core_base.h |    2 +
 3 files changed, 181 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4b92663..8d1f9fc 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -614,44 +614,30 @@ int core_alua_check_nonop_delay(
 EXPORT_SYMBOL(core_alua_check_nonop_delay);
 
 /*
- * Called with tg_pt_gp->tg_pt_gp_md_mutex held
+ * Called with tg_pt_gp->tg_pt_gp_md_mutex or tg_pt_gp_mem->sep_tg_pt_md_mutex
+ * 
  */
-int core_alua_update_tpg_primary_metadata(
-	t10_alua_tg_pt_gp_t *tg_pt_gp,
-	int primary_state,
-	unsigned char *md_buf)
+int core_alua_write_tpg_metadata(
+	const char *path,
+	unsigned char *md_buf,
+	u32 md_buf_len) 
 {
-	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
-	t10_wwn_t *wwn = &su_dev->t10_wwn;
+	mm_segment_t old_fs;
 	struct file *file;
 	struct iovec iov[1];
-	mm_segment_t old_fs;
-	char path[512];
-	int flags = O_RDWR | O_CREAT | O_TRUNC;
-	int len, ret;
+	int flags = O_RDWR | O_CREAT | O_TRUNC, ret;
 
 	memset(iov, 0, sizeof(struct iovec));
-	memset(path, 0, 512);
-
-	len = snprintf(md_buf, tg_pt_gp->tg_pt_gp_md_buf_len,
-			"tg_pt_gp_id=%hu\n"
-			"alua_access_state=0x%02x\n"
-			"alua_access_status=0x%02x\n",
-			tg_pt_gp->tg_pt_gp_id, primary_state,
-			tg_pt_gp->tg_pt_gp_alua_access_status);
 
-	snprintf(path, 512, "/var/target/alua/tpgs_%s/%s",
-		&wwn->unit_serial[0],
-		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file) || !file || !file->f_dentry) {
 		printk(KERN_ERR "filp_open(%s) for ALUA metadata failed\n",
 			path);
 		return -1;
 	}
-	
+
 	iov[0].iov_base = &md_buf[0];
-	iov[0].iov_len = len;
+	iov[0].iov_len = md_buf_len;
 
 	old_fs = get_fs();
 	set_fs(get_ds());
@@ -659,7 +645,7 @@ int core_alua_update_tpg_primary_metadata(
 	set_fs(old_fs);
 
 	if (ret < 0) {
-		printk("Error writing ALUA metadata file: %s\n", path);	
+		printk("Error writing ALUA metadata file: %s\n", path);
 		filp_close(file, NULL);
 		return -1;
 	}
@@ -668,6 +654,35 @@ int core_alua_update_tpg_primary_metadata(
 	return 0;
 }
 
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
+	char path[512];
+	int len;
+
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
+
+	return core_alua_write_tpg_metadata(path, md_buf, len);
+}
+
 int core_alua_do_transition_tg_pt(
 	t10_alua_tg_pt_gp_t *tg_pt_gp,
 	se_port_t *l_port,
@@ -895,6 +910,41 @@ int core_alua_do_port_transition(
 	return 0;
 }
 
+/*
+ * Called with tg_pt_gp_mem->sep_tg_pt_md_mutex held
+ */
+int core_alua_update_tpg_secondary_metadata(
+	struct t10_alua_tg_pt_gp_member_s *tg_pt_gp_mem,
+	se_port_t *port,
+	unsigned char *md_buf,
+	u32 md_buf_len)
+{
+	se_portal_group_t *se_tpg = port->sep_tpg;
+	char path[512], wwn[1024];
+	int len;
+
+	memset(path, 0, 512);
+	memset(wwn, 0, 1024);
+
+	len = snprintf(wwn, 512, "%s",
+			TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg));
+
+	if (TPG_TFO(se_tpg)->tpg_get_tag != NULL)
+		snprintf(wwn+len, 1024-len, "+%hu",
+				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
+
+	len = snprintf(md_buf, md_buf_len, "alua_tg_pt_offline=%d\n"
+			"alua_tg_pt_status=0x%02x\n",
+			atomic_read(&port->sep_tg_pt_secondary_offline),
+			port->sep_tg_pt_secondary_stat);
+
+	snprintf(path, 512, "/var/target/alua/%s/%s/lun_%u",
+			TPG_TFO(se_tpg)->get_fabric_name(), wwn,
+			port->sep_lun->unpacked_lun);
+	
+	return core_alua_write_tpg_metadata(path, md_buf, len);
+}
+
 int core_alua_set_tg_pt_secondary_state(
 	struct t10_alua_tg_pt_gp_member_s *tg_pt_gp_mem,
 	se_port_t *port,
@@ -902,6 +952,8 @@ int core_alua_set_tg_pt_secondary_state(
 	int offline)
 {
 	struct t10_alua_tg_pt_gp_s *tg_pt_gp;
+	unsigned char *md_buf;
+	u32 md_buf_len;
 	int trans_delay_msecs;
 
 	spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
@@ -922,6 +974,7 @@ int core_alua_set_tg_pt_secondary_state(
 	else
 		atomic_set(&port->sep_tg_pt_secondary_offline, 0);
 
+	md_buf_len = tg_pt_gp->tg_pt_gp_md_buf_len;
 	port->sep_tg_pt_secondary_stat = (explict) ?
 			ALUA_STATUS_ALTERED_BY_EXPLICT_STPG :
 			ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA;
@@ -932,9 +985,30 @@ int core_alua_set_tg_pt_secondary_state(
 		tg_pt_gp->tg_pt_gp_id, (offline) ? "OFFLINE" : "ONLINE");
 
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-
+	/*
+	 * Do the optional transition delay after we set the secondary
+	 * ALUA access state.
+	 */
 	if (trans_delay_msecs != 0)
 		msleep_interruptible(trans_delay_msecs);	
+	/*
+	 * See if we need to update the ALUA fabric port metadata for
+	 * secondary state and status
+	 */
+	if (port->sep_tg_pt_secondary_write_md) {
+		md_buf = kzalloc(md_buf_len, GFP_KERNEL);
+		if (!(md_buf)) {
+			printk(KERN_ERR "Unable to allocate md_buf for"
+				" secondary ALUA access metadata\n");
+			return -1;
+		}
+		mutex_lock(&port->sep_tg_pt_md_mutex);
+		core_alua_update_tpg_secondary_metadata(tg_pt_gp_mem, port,
+				md_buf, md_buf_len);
+		mutex_unlock(&port->sep_tg_pt_md_mutex);
+
+		kfree(md_buf);
+	}
 
 	return 0;
 }
@@ -1781,6 +1855,73 @@ ssize_t core_alua_store_offline_bit(se_lun_t *lun, const char *page, size_t coun
 }
 EXPORT_SYMBOL(core_alua_store_offline_bit);
 
+ssize_t core_alua_show_secondary_status(
+	se_lun_t *lun,
+	char *page)
+{
+	return sprintf(page, "%d\n", lun->lun_sep->sep_tg_pt_secondary_stat);
+}
+EXPORT_SYMBOL(core_alua_show_secondary_status);
+
+ssize_t core_alua_store_secondary_status(
+	se_lun_t *lun,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract alua_tg_pt_status\n");
+		return -EINVAL;
+	}
+	if ((tmp != ALUA_STATUS_NONE) &&
+	    (tmp != ALUA_STATUS_ALTERED_BY_EXPLICT_STPG) &&
+	    (tmp != ALUA_STATUS_ALTERED_BY_IMPLICT_ALUA)) {
+		printk(KERN_ERR "Illegal value for alua_tg_pt_status: %lu\n",
+				tmp);
+		return -EINVAL;
+	}
+	lun->lun_sep->sep_tg_pt_secondary_stat = (int)tmp;
+
+	return count;
+}
+EXPORT_SYMBOL(core_alua_store_secondary_status);
+
+ssize_t core_alua_show_secondary_write_metadata(
+	se_lun_t *lun,
+	char *page)
+{
+	return sprintf(page, "%d\n",
+			lun->lun_sep->sep_tg_pt_secondary_write_md);
+}
+EXPORT_SYMBOL(core_alua_show_secondary_write_metadata);
+
+ssize_t core_alua_store_secondary_write_metadata(
+	se_lun_t *lun,
+	const char *page,
+	size_t count)
+{
+	unsigned long tmp;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk(KERN_ERR "Unable to extract alua_tg_pt_write_md\n");
+		return -EINVAL;
+	}
+	if ((tmp != 0) && (tmp != 1)) {
+		printk(KERN_ERR "Illegal value for alua_tg_pt_write_md:"
+				" %lu\n", tmp);
+		return -EINVAL;
+	}
+	lun->lun_sep->sep_tg_pt_secondary_write_md = (int)tmp;
+
+	return count;
+}
+EXPORT_SYMBOL(core_alua_store_secondary_write_metadata);
+
 int core_setup_alua(se_device_t *dev)
 {
 	se_subsystem_dev_t *su_dev = dev->se_sub_dev;
diff --git a/include/target/target_core_alua.h b/include/target/target_core_alua.h
index 7aa3b5d..4e5a107 100644
--- a/include/target/target_core_alua.h
+++ b/include/target/target_core_alua.h
@@ -115,11 +115,20 @@ extern ssize_t core_alua_show_trans_delay_msecs(struct t10_alua_tg_pt_gp_s *,
 					char *);
 extern ssize_t core_alua_store_trans_delay_msecs(struct t10_alua_tg_pt_gp_s *,
 					const char *, size_t);
-extern ssize_t core_alua_show_preferred_bit(struct t10_alua_tg_pt_gp_s *, char *);
+extern ssize_t core_alua_show_preferred_bit(struct t10_alua_tg_pt_gp_s *,
+					char *);
 extern ssize_t core_alua_store_preferred_bit(struct t10_alua_tg_pt_gp_s *,
-				const char *, size_t);
+					const char *, size_t);
 extern ssize_t core_alua_show_offline_bit(struct se_lun_s *, char *);
-extern ssize_t core_alua_store_offline_bit(struct se_lun_s *, const char *, size_t);
+extern ssize_t core_alua_store_offline_bit(struct se_lun_s *, const char *,
+					size_t);
+extern ssize_t core_alua_show_secondary_status(struct se_lun_s *, char *);
+extern ssize_t core_alua_store_secondary_status(struct se_lun_s *,
+					const char *, size_t);
+extern ssize_t core_alua_show_secondary_write_metadata(struct se_lun_s *,
+					char *);
+extern ssize_t core_alua_store_secondary_write_metadata(struct se_lun_s *,
+					const char *, size_t);
 extern int core_setup_alua(struct se_device_s *);
 
 #endif /* TARGET_CORE_ALUA_H */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d166606..7ae0758 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -882,6 +882,7 @@ typedef struct se_port_s {
 	/* RELATIVE TARGET PORT IDENTIFER */
 	u16		sep_rtpi;
 	int		sep_tg_pt_secondary_stat;
+	int		sep_tg_pt_secondary_write_md;
 #ifdef SNMP_SUPPORT
 	u32		sep_index;
 	scsi_port_stats_t sep_stats;
@@ -890,6 +891,7 @@ typedef struct se_port_s {
 	atomic_t	sep_tg_pt_gp_active;
 	atomic_t	sep_tg_pt_secondary_offline;
 	spinlock_t	sep_alua_lock;
+	struct mutex	sep_tg_pt_md_mutex;
 	struct t10_alua_tg_pt_gp_member_s *sep_alua_tg_pt_gp_mem;
 	struct se_lun_s *sep_lun;
 	struct se_portal_group_s *sep_tpg;
-- 
1.5.4.1
