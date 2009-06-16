From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: [PATCH][SCST]: Show sessions for a target on sysfs; sysfs interface
 to add luns to a given target.
Date: Tue, 16 Jun 2009 12:32:04 -0300
Message-ID: <4A37BAF4.9080308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:47670 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZFPPcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 11:32:09 -0400
Received: from mailhub1.br.ibm.com (mailhub1.br.ibm.com [9.18.232.109])
	by e24smtp04.br.ibm.com (8.13.1/8.13.1) with ESMTP id n5GFUJnw017147
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 12:30:19 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.18.232.47])
	by mailhub1.br.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5GFWWpH1491086
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 12:32:33 -0300
Received: from d24av02.br.ibm.com (loopback [127.0.0.1])
	by d24av02.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5GFW5kY028079
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 12:32:06 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The patch below show created sessions for a target on
/sys/kernel/scst_tgt/targets/<target_driver_name>/<target>/session
and allow creation of default LUNs (tgt->default_acg) to the target
using targets/<target_driver_name>/<target>/luns/mgmt

please review.

Signed-off-by: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
---
include/scst.h   |    7
src/scst_lib.c   |   26 ---
src/scst_main.c  |   11 +
src/scst_priv.h  |    3
src/scst_sysfs.c |  387 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
src/scst_targ.c  |    7
6 files changed, 408 insertions(+), 33 deletions(-)

Index: scst/include/scst.h
===================================================================
--- scst/include/scst.h	(revision 887)
+++ scst/include/scst.h	(working copy)
@@ -931,6 +931,8 @@ struct scst_tgt {

  	struct scst_tgt_template *tgtt;	/* corresponding target template */

+	struct scst_acg *default_acg; /* The default acg for this target. */
+
  	/*
  	 * Maximum SG table size. Needed here, since different cards on the
  	 * same target template can have different SG table limitations.
@@ -1046,6 +1048,8 @@ struct scst_session {
  	/* Used if scst_unregister_session() called in wait mode */
  	struct completion *shutdown_compl;

+	struct kobject sess_kobj; /* kobject for this struct */
+
  	/*
  	 * Functions and data for user callbacks from scst_register_session()
  	 * and scst_unregister_session()
@@ -1631,6 +1635,9 @@ struct scst_acg_dev {

  	/* list entry in acg->acg_dev_list */
  	struct list_head acg_dev_list_entry;
+
+	/* kobject for this structure. */
+	struct kobject acg_dev_kobj;
  };

  /*
Index: scst/src/scst_main.c
===================================================================
--- scst/src/scst_main.c	(revision 887)
+++ scst/src/scst_main.c	(working copy)
@@ -394,9 +394,13 @@ struct scst_tgt *scst_register(struct sc
  			SCST_DEFAULT_TGT_NAME_SUFFIX, tgt_num++);
  	}

+	tgt->default_acg = scst_alloc_add_acg(target_name);
+	if (tgt->default_acg == NULL)
+		goto out_free_tgt_name;
+
  	rc = scst_build_proc_target_entries(tgt);
  	if (rc < 0)
-		goto out_free_tgt_name;
+		goto out_free_acg;

  	rc = scst_create_tgt_sysfs(tgt);
  	if (rc < 0)
@@ -422,6 +426,9 @@ out_clean_proc:
  out_free_tgt_name:
  	kfree(tgt->tgt_name);

+out_free_acg:
+	scst_destroy_acg(tgt->default_acg);
+
  out_free_def_name:
  	kfree(tgt->default_group_name);

@@ -499,6 +506,8 @@ again:
  	kfree(tgt->tgt_name);
  	kfree(tgt->default_group_name);

+	scst_destroy_acg(tgt->default_acg);
+
  	del_timer_sync(&tgt->retry_timer);

  	scst_cleanup_tgt_sysfs_put(tgt);
Index: scst/src/scst_priv.h
===================================================================
--- scst/src/scst_priv.h	(revision 887)
+++ scst/src/scst_priv.h	(working copy)
@@ -291,6 +291,7 @@ struct scst_acg *scst_alloc_add_acg(cons
  int scst_destroy_acg(struct scst_acg *acg);

  int scst_sess_alloc_tgt_devs(struct scst_session *sess);
+void scst_sess_free_tgt_devs(struct scst_session *sess);
  void scst_nexus_loss(struct scst_tgt_dev *tgt_dev, bool queue_UA);

  int scst_acg_add_dev(struct scst_acg *acg, struct scst_device *dev,
@@ -390,6 +391,8 @@ int scst_create_tgtt_sysfs(struct scst_t
  void scst_cleanup_tgtt_sysfs(struct scst_tgt_template *vtt);
  int scst_create_tgt_sysfs(struct scst_tgt *tgt);
  void scst_cleanup_tgt_sysfs_put(struct scst_tgt *tgt);
+int scst_create_sess_sysfs(struct scst_session *sess);
+void scst_cleanup_sess_sysfs_put(struct scst_session *session);
  int scst_create_sgv_sysfs(struct sgv_pool *pool);
  void scst_cleanup_sgv_sysfs_put(struct sgv_pool *pool);

Index: scst/src/scst_lib.c
===================================================================
--- scst/src/scst_lib.c	(revision 887)
+++ scst/src/scst_lib.c	(working copy)
@@ -45,7 +45,6 @@ static void scst_alloc_set_UA(struct scs
  	const uint8_t *sense, int sense_len, int flags);
  static void scst_free_all_UA(struct scst_tgt_dev *tgt_dev);
  static void scst_release_space(struct scst_cmd *cmd);
-static void scst_sess_free_tgt_devs(struct scst_session *sess);
  static void scst_unblock_cmds(struct scst_device *dev);

  #ifdef CONFIG_SCST_DEBUG_TM
@@ -925,12 +924,7 @@ static void scst_free_acg_dev(struct scs
  {
  	TRACE_ENTRY();

-	TRACE_DBG("Removing acg_dev %p from acg_dev_list and dev_acg_dev_list",
-		acg_dev);
-	list_del(&acg_dev->acg_dev_list_entry);
-	list_del(&acg_dev->dev_acg_dev_list_entry);
-
-	kmem_cache_free(scst_acgd_cachep, acg_dev);
+	kobject_put(&acg_dev->acg_dev_kobj);

  	TRACE_EXIT();
  	return;
@@ -1314,7 +1308,7 @@ out_free:
   * scst_mutex supposed to be held, there must not be parallel activity in this
   * session.
   */
-static void scst_sess_free_tgt_devs(struct scst_session *sess)
+void scst_sess_free_tgt_devs(struct scst_session *sess)
  {
  	int i;
  	struct scst_tgt_dev *tgt_dev, *t;
@@ -1890,21 +1884,7 @@ void scst_free_session(struct scst_sessi
  {
  	TRACE_ENTRY();

-	mutex_lock(&scst_mutex);
-
-	TRACE_DBG("Removing sess %p from the list", sess);
-	list_del(&sess->sess_list_entry);
-	TRACE_DBG("Removing session %p from acg %s", sess, sess->acg->acg_name);
-	list_del(&sess->acg_sess_list_entry);
-
-	scst_sess_free_tgt_devs(sess);
-
-	wake_up_all(&sess->tgt->unreg_waitQ);
-
-	mutex_unlock(&scst_mutex);
-
-	kfree(sess->initiator_name);
-	kmem_cache_free(scst_sess_cachep, sess);
+	scst_cleanup_sess_sysfs_put(sess);

  	TRACE_EXIT();
  	return;
Index: scst/src/scst_sysfs.c
===================================================================
--- scst/src/scst_sysfs.c	(revision 887)
+++ scst/src/scst_sysfs.c	(working copy)
@@ -11,6 +11,9 @@

  #define SCST_SYSFS_BLOCK_SIZE (PAGE_SIZE - 512)

+#define SCST_LUN_ACTION_ADD		 1
+#define SCST_LUN_ACTION_DEL		 2
+
  static DEFINE_MUTEX(scst_sysfs_mutex);

  static struct kobject *scst_sysfs_root_kobj;
@@ -22,7 +25,16 @@ static struct kobject *scst_back_drivers
  static struct sysfs_ops scst_sysfs_ops;

  static void scst_sysfs_release(struct kobject *kobj);
-
+static ssize_t scst_luns_mgmt_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf);
+static ssize_t scst_luns_mgmt_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t count);
+
+/*
+ * Target Template (e.g iscsi).
+ */
  int scst_create_tgtt_sysfs(struct scst_tgt_template *tgtt)
  {
  	int retval = 0;
@@ -43,6 +55,9 @@ void scst_cleanup_tgtt_sysfs(struct scst
  	kobject_put(tgtt->tgtt_kobj);
  }

+/*
+ * Target (e.g. iscsi target name).
+ */
  static void scst_tgt_free(struct kobject *kobj)
  {
  	struct scst_tgt *tgt;
@@ -61,6 +76,10 @@ static struct kobj_type tgt_ktype = {
  	.release = scst_tgt_free,
  };

+static struct kobj_attribute scst_luns_mgmt =
+	__ATTR(mgmt, S_IRUGO | S_IWUSR, scst_luns_mgmt_show,
+	       scst_luns_mgmt_store);
+
  int scst_create_tgt_sysfs(struct scst_tgt *tgt)
  {
  	int retval;
@@ -85,6 +104,8 @@ int scst_create_tgt_sysfs(struct scst_tg
  		PRINT_ERROR("Can't create luns kobj for tgt %s", tgt->tgt_name);
  		goto luns_kobj_err;
  	}
+	if (sysfs_create_file(tgt->tgt_luns_kobj, &scst_luns_mgmt.attr))
+		goto create_luns_mgmt_err;

  	tgt->tgt_ini_grp_kobj = kobject_create_and_add("ini_group",
  						    &tgt->tgt_kobj);
@@ -98,6 +119,7 @@ out:
  	TRACE_EXIT_RES(retval);
  	return retval;

+create_luns_mgmt_err:
  ini_grp_kobj_err:
  	kobject_del(tgt->tgt_luns_kobj);
  	kobject_put(tgt->tgt_luns_kobj);
@@ -129,7 +151,356 @@ void scst_cleanup_tgt_sysfs_put(struct s
  	return;
  }

-struct kobj_attribute sgv_stat_attr =
+/*
+ * Target sessions directory implementation
+ */
+ssize_t scst_sess_sysfs_commands_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct scst_session *sess;
+
+	sess = container_of(kobj, struct scst_session, sess_kobj);
+
+	return sprintf(buf, "%i\n", sess->sess_cmd_count.counter);
+}
+
+struct kobj_attribute session_attr =
+	__ATTR(commands, S_IRUGO, scst_sess_sysfs_commands_show, NULL);
+
+static struct attribute *scst_session_attrs[] = {
+	&session_attr.attr,
+	NULL,
+};
+
+static void scst_session_release(struct kobject *kobj)
+{
+	struct scst_session *sess;
+
+	TRACE_ENTRY();
+
+	sess = container_of(kobj, struct scst_session, sess_kobj);
+
+	mutex_lock(&scst_mutex);
+
+	TRACE_DBG("Removing sess %p from the list", sess);
+	list_del(&sess->sess_list_entry);
+	TRACE_DBG("Removing session %p from acg %s", sess, sess->acg->acg_name);
+	list_del(&sess->acg_sess_list_entry);
+
+	scst_sess_free_tgt_devs(sess);
+
+	wake_up_all(&sess->tgt->unreg_waitQ);
+
+	mutex_unlock(&scst_mutex);
+
+	kfree(sess->initiator_name);
+	kmem_cache_free(scst_sess_cachep, sess);
+
+	TRACE_EXIT();
+	return;
+}
+
+static struct kobj_type scst_session_ktype = {
+	.sysfs_ops = &scst_sysfs_ops,
+	.release = scst_session_release,
+	.default_attrs = scst_session_attrs,
+};
+
+int scst_create_sess_sysfs(struct scst_session *sess)
+{
+	int retval = 0;
+
+	TRACE_ENTRY();
+
+	retval = kobject_init_and_add(&sess->sess_kobj, &scst_session_ktype,
+			      sess->tgt->tgt_sess_kobj, sess->initiator_name);
+	if (retval != 0) {
+		PRINT_ERROR("Can't add session %s to sysfs",
+			    sess->initiator_name);
+		goto out;
+	}
+
+out:
+	TRACE_EXIT_RES(retval);
+	return retval;
+}
+
+void scst_cleanup_sess_sysfs_put(struct scst_session *session)
+{
+	TRACE_ENTRY();
+
+	kobject_put(&session->sess_kobj);
+
+	TRACE_EXIT();
+	return;
+}
+
+/* Target luns directory implementation. */
+static void scst_acg_dev_release(struct kobject *kobj)
+{
+	struct scst_acg_dev *acg_dev;
+
+	TRACE_ENTRY();
+
+	acg_dev = container_of(kobj, struct scst_acg_dev, acg_dev_kobj);
+
+	TRACE_DBG("Removing acg_dev %p from acg_dev_list and dev_acg_dev_list",
+		acg_dev);
+	list_del(&acg_dev->acg_dev_list_entry);
+	list_del(&acg_dev->dev_acg_dev_list_entry);
+
+	kmem_cache_free(scst_acgd_cachep, acg_dev);
+
+	TRACE_EXIT();
+	return;
+}
+
+static ssize_t scst_lun_options_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf)
+{
+	return sprintf(buf, "lun options show!!\n");
+}
+
+struct kobj_attribute lun_options_attr =
+	__ATTR(options, S_IRUGO, scst_lun_options_show, NULL);
+
+static struct attribute *lun_attrs[] = {
+	&lun_options_attr.attr,
+	NULL,
+};
+
+static struct kobj_type acg_dev_ktype = {
+	.sysfs_ops = &scst_sysfs_ops,
+	.release = scst_acg_dev_release,
+	.default_attrs = lun_attrs,
+};
+
+int scst_create_acg_dev_sysfs(struct scst_acg *acg, unsigned int virt_lun,
+			  struct kobject *parent)
+{
+	int retval;
+	struct scst_acg_dev *acg_dev = NULL, *acg_dev_tmp;
+	TRACE_ENTRY();
+
+	list_for_each_entry(acg_dev_tmp, &acg->acg_dev_list,
+			    acg_dev_list_entry) {
+		if (acg_dev_tmp->lun == virt_lun) {
+			acg_dev = acg_dev_tmp;
+			break;
+		}
+	}
+
+	if (!acg_dev) {
+		PRINT_ERROR("%s", "acg_dev lookup for kobject creation failed");
+		retval = -EINVAL;
+		goto out;
+	}
+
+	retval = kobject_init_and_add(&acg_dev->acg_dev_kobj, &acg_dev_ktype,
+				      parent, "%u", virt_lun);
+	if (retval != 0) {
+		PRINT_ERROR("Can't add acg %s to sysfs", acg->acg_name);
+		retval = -EINVAL;
+	}
+
+/* 	XXX: change the second parameter to the kobject where */
+/* 	the link will point to. */
+	sysfs_create_link(&acg_dev->acg_dev_kobj, &acg_dev->acg_dev_kobj,
+			    "device");
+
+out:
+	return retval;
+}
+
+static ssize_t scst_luns_mgmt_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf)
+{
+	static char *help =
+"Usage: echo \"add|del H:C:I:L lun [READ_ONLY]\" \
+> mgmt\n"
+"       echo \"add|del V_NAME lun [READ_ONLY]\" \
+> mgmt\n";
+
+	return sprintf(buf, help);
+}
+
+static ssize_t scst_luns_mgmt_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int res = count, virt = 0, rc, read_only = 0, action;
+	char *buffer, *p, *e = NULL;
+	unsigned int host, channel = 0, id = 0, lun = 0, virt_lun;
+	struct scst_acg *acg;
+	struct scst_acg_dev *acg_dev = NULL, *acg_dev_tmp;
+	struct scst_device *d, *dev = NULL;
+	struct scst_tgt *tgt;
+
+	TRACE_ENTRY();
+
+	tgt = container_of(kobj->parent, struct scst_tgt, tgt_kobj);
+	acg = tgt->default_acg;
+
+	buffer = kzalloc(count+1, GFP_KERNEL);
+	memcpy(buffer, buf, count);
+	buffer[count+1] = '\0';
+	p = buffer;
+
+	p = buffer;
+	if (p[strlen(p) - 1] == '\n')
+		p[strlen(p) - 1] = '\0';
+	if (!strncasecmp("add ", p, 4)) {
+		p += 4;
+		action = SCST_LUN_ACTION_ADD;
+	} else if (!strncasecmp("del ", p, 4)) {
+		p += 4;
+		action = SCST_LUN_ACTION_DEL;
+	} else {
+		PRINT_ERROR("Unknown action \"%s\"", p);
+		res = -EINVAL;
+		goto out_free;
+	}
+
+	if (scst_suspend_activity(true) != 0) {
+		res = EINVAL;
+		goto out_free;
+	}
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0) {
+		res = -EINTR;
+		goto out_free_resume;
+	}
+
+
+	while (isspace(*p) && *p != '\0')
+		p++;
+	e = p; /* save p */
+	host = simple_strtoul(p, &p, 0);
+	if (*p == ':') {
+		channel = simple_strtoul(p + 1, &p, 0);
+		id = simple_strtoul(p + 1, &p, 0);
+		lun = simple_strtoul(p + 1, &p, 0);
+		e = p;
+	} else {
+		virt++;
+		p = e; /* restore p */
+		while (!isspace(*e) && *e != '\0')
+			e++;
+		*e = 0;
+	}
+
+	list_for_each_entry(d, &scst_dev_list, dev_list_entry) {
+		if (virt) {
+			if (d->virt_id && !strcmp(d->virt_name, p)) {
+				dev = d;
+				TRACE_DBG("Virt device %p (%s) found",
+					  dev, p);
+				break;
+			}
+		} else {
+			if (d->scsi_dev &&
+			    d->scsi_dev->host->host_no == host &&
+			    d->scsi_dev->channel == channel &&
+			    d->scsi_dev->id == id &&
+			    d->scsi_dev->lun == lun) {
+				dev = d;
+				TRACE_DBG("Dev %p (%d:%d:%d:%d) found",
+					  dev, host, channel, id, lun);
+				break;
+			}
+		}
+	}
+	if (dev == NULL) {
+		if (virt) {
+			PRINT_ERROR("Virt device %s not found", p);
+		} else {
+			PRINT_ERROR("Device %d:%d:%d:%d not found",
+				    host, channel, id, lun);
+		}
+		res = -EINVAL;
+		goto out_free_up;
+	}
+
+	switch (action) {
+	case SCST_LUN_ACTION_ADD:
+		e++;
+		while (isspace(*e) && *e != '\0')
+			e++;
+		virt_lun = simple_strtoul(e, &e, 0);
+
+		while (isspace(*e) && *e != '\0')
+			e++;
+
+		if (*e != '\0') {
+			if (!strncasecmp("READ_ONLY", e, 9))
+				read_only = 1;
+			else {
+				PRINT_ERROR("Unknown option \"%s\"", e);
+				res = -EINVAL;
+				goto out_free_up;
+			}
+		}
+
+		list_for_each_entry(acg_dev_tmp, &acg->acg_dev_list,
+				    acg_dev_list_entry) {
+			if (acg_dev_tmp->lun == virt_lun) {
+				acg_dev = acg_dev_tmp;
+				break;
+			}
+		}
+
+		if (acg_dev) {
+			acg_dev = acg_dev_tmp;
+			PRINT_ERROR("virt lun %d already exists in group %s",
+				    virt_lun, acg->acg_name);
+			res = -EINVAL;
+			goto out_free_up;
+		}
+
+
+		rc = scst_acg_add_dev(acg, dev, virt_lun, read_only);
+		if (rc) {
+			PRINT_ERROR("scst_acg_add_dev() returned %d", rc);
+			res = rc;
+			goto out_free_up;
+		}
+
+		rc = scst_create_acg_dev_sysfs(acg, virt_lun, kobj);
+		if (rc < 0) {
+			PRINT_ERROR("%s", "creation of acg_dev kobject failed");
+			goto out_remove_acg_dev;
+		}
+		break;
+	case SCST_LUN_ACTION_DEL:
+		rc = scst_acg_remove_dev(acg, dev);
+		if (rc) {
+			PRINT_ERROR("scst_acg_remove_dev() returned %d", rc);
+			res = rc;
+		}
+		break;
+	}
+out_free_up:
+	mutex_unlock(&scst_mutex);
+
+out_free_resume:
+	scst_resume_activity();
+
+out_free:
+	kfree(buffer);
+	TRACE_EXIT_RES(res);
+
+	return res;
+
+out_remove_acg_dev:
+	scst_acg_remove_dev(acg, dev);
+
+	goto out_free_up;
+}
+
+/* svg directory implementation. */
+struct kobj_attribute sgv_stat_attr =
  	__ATTR(stats, S_IRUGO, sgv_sysfs_stat_show, NULL);

  static struct attribute *sgv_attrs[] = {
@@ -183,7 +554,7 @@ void scst_cleanup_sgv_sysfs_put(struct s
  	return;
  }

-struct kobj_attribute sgv_global_stat_attr =
+struct kobj_attribute sgv_global_stat_attr =
  	__ATTR(global_stats, S_IRUGO, sgv_sysfs_global_stat_show, NULL);

  static struct attribute *sgv_default_attrs[] = {
@@ -197,6 +568,7 @@ static struct kobj_type sgv_ktype = {
  	.default_attrs = sgv_default_attrs,
  };

+/* scst sysfs root implementation. */
  static ssize_t scst_threads_show(struct kobject *kobj, struct kobj_attribute *attr,
  				 char *buf)
  {
@@ -326,7 +698,7 @@ static ssize_t scst_version_show(struct
  	return strlen(buf);
  }

-struct kobj_attribute scst_threads_attr =
+struct kobj_attribute scst_threads_attr =
  	__ATTR(threads, S_IRUGO | S_IWUSR, scst_threads_show,
  	       scst_threads_store);

@@ -334,9 +706,9 @@ struct kobj_attribute scst_trace_level_a
  	__ATTR(trace_level, S_IRUGO | S_IWUSR, scst_trace_level_show,
  	       scst_trace_level_store);

-struct kobj_attribute scst_version_attr =
+struct kobj_attribute scst_version_attr =
  	__ATTR(version, S_IRUGO, scst_version_show, NULL);
-	
+
  static struct attribute *scst_sysfs_root_default_attrs[] = {
  	&scst_threads_attr.attr,
  	&scst_trace_level_attr.attr,
@@ -378,7 +750,6 @@ static struct kobj_type scst_sysfs_root_
  	.default_attrs = scst_sysfs_root_default_attrs,
  };

-
  int __init scst_sysfs_init(void)
  {
  	int retval = 0;
@@ -420,7 +791,7 @@ int __init scst_sysfs_init(void)
  		goto back_drivers_kobj_error;


-out:	
+out:
  	TRACE_EXIT_RES(retval);
  	return retval;

Index: scst/src/scst_targ.c
===================================================================
--- scst/src/scst_targ.c	(revision 887)
+++ scst/src/scst_targ.c	(working copy)
@@ -5288,12 +5288,13 @@ static int scst_init_session(struct scst

  	mutex_lock(&scst_mutex);

+/* 	debonzi: Not fully implemented. */
  	if (sess->initiator_name)
  		acg = scst_find_acg(sess->initiator_name);
  	if ((acg == NULL) && (sess->tgt->default_group_name != NULL))
  		acg = scst_find_acg_by_name(sess->tgt->default_group_name);
  	if (acg == NULL)
-		acg = scst_default_acg;
+		acg = sess->tgt->default_acg;

  	PRINT_INFO("Using security group \"%s\" for initiator \"%s\"",
  		acg->acg_name, sess->initiator_name);
@@ -5355,6 +5356,10 @@ restart:
  			&scst_active_mgmt_cmd_list);
  		mwake = 1;
  	}
+
+	if (res == 0)
+		res = scst_create_sess_sysfs(sess);
+
  	spin_unlock(&scst_mcmd_lock);
  	sess->init_phase = SCST_SESS_IPH_READY;
  	spin_unlock_irq(&sess->sess_list_lock);
