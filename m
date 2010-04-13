From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 3/4/4/5] iSCSI-SCST's implementation files
Date: Tue, 13 Apr 2010 17:10:32 +0400
Message-ID: <4BC46D48.9040004@vlnb.net>
References: <4BC44A49.7070307@vlnb.net> <4BC45EF7.7010304@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BC45EF7.7010304@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch contains iSCSI-SCST's implementation files.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 config.c  |  933 ++++++++++++++++
 conn.c    |  785 +++++++++++++
 digest.c  |  226 +++
 event.c   |  163 ++
 iscsi.c   | 3583 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 nthread.c | 1524 ++++++++++++++++++++++++++
 param.c   |  306 +++++
 session.c |  482 ++++++++
 target.c  |  500 ++++++++
 9 files changed, 8502 insertions(+)

diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/config.c linux-2.6.33/drivers/scst/iscsi-scst/config.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/config.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/config.c
@@ -0,0 +1,933 @@
+/*
+ *  Copyright (C) 2004 - 2005 FUJITA Tomonori <tomof@acm.org>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include "iscsi.h"
+
+/* Protected by target_mgmt_mutex */
+int ctr_open_state;
+
+/* Protected by target_mgmt_mutex */
+static LIST_HEAD(iscsi_attrs_list);
+
+static ssize_t iscsi_version_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+
+	sprintf(buf, "%s\n", ISCSI_VERSION_STRING);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	strcat(buf, "EXTRACHECKS\n");
+#endif
+
+#ifdef CONFIG_SCST_TRACING
+	strcat(buf, "TRACING\n");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG
+	strcat(buf, "DEBUG\n");
+#endif
+
+#ifdef CONFIG_SCST_ISCSI_DEBUG_DIGEST_FAILURES
+	strcat(buf, "DEBUG_DIGEST_FAILURES\n");
+#endif
+	return strlen(buf);
+}
+
+static struct kobj_attribute iscsi_version_attr =
+	__ATTR(version, S_IRUGO, iscsi_version_show, NULL);
+
+static ssize_t iscsi_open_state_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	switch (ctr_open_state) {
+	case ISCSI_CTR_OPEN_STATE_CLOSED:
+		sprintf(buf, "%s\n", "closed");
+		break;
+	case ISCSI_CTR_OPEN_STATE_OPEN:
+		sprintf(buf, "%s\n", "open");
+		break;
+	case ISCSI_CTR_OPEN_STATE_CLOSING:
+		sprintf(buf, "%s\n", "closing");
+		break;
+	default:
+		sprintf(buf, "%s\n", "unknown");
+		break;
+	}
+
+	return strlen(buf);
+}
+
+static struct kobj_attribute iscsi_open_state_attr =
+	__ATTR(open_state, S_IRUGO, iscsi_open_state_show, NULL);
+
+const struct attribute *iscsi_attrs[] = {
+	&iscsi_version_attr.attr,
+	&iscsi_open_state_attr.attr,
+	NULL,
+};
+
+/* target_mgmt_mutex supposed to be locked */
+static int add_conn(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_session *session;
+	struct iscsi_kern_conn_info info;
+	struct iscsi_target *target;
+
+	rc = copy_from_user(&info, ptr, sizeof(info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	target = target_lookup_by_id(info.tid);
+	if (target == NULL) {
+		PRINT_ERROR("Target %d not found", info.tid);
+		err = -ENOENT;
+		goto out;
+	}
+
+	mutex_lock(&target->target_mutex);
+
+	session = session_lookup(target, info.sid);
+	if (!session) {
+		PRINT_ERROR("Session %lld not found",
+			(long long unsigned int)info.tid);
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	err = __add_conn(session, &info);
+
+out_unlock:
+	mutex_unlock(&target->target_mutex);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int del_conn(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_session *session;
+	struct iscsi_kern_conn_info info;
+	struct iscsi_target *target;
+
+	rc = copy_from_user(&info, ptr, sizeof(info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	target = target_lookup_by_id(info.tid);
+	if (target == NULL) {
+		PRINT_ERROR("Target %d not found", info.tid);
+		err = -ENOENT;
+		goto out;
+	}
+
+	mutex_lock(&target->target_mutex);
+
+	session = session_lookup(target, info.sid);
+	if (!session) {
+		PRINT_ERROR("Session %llx not found",
+			(long long unsigned int)info.sid);
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	err = __del_conn(session, &info);
+
+out_unlock:
+	mutex_unlock(&target->target_mutex);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int add_session(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_kern_session_info *info;
+	struct iscsi_target *target;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL) {
+		PRINT_ERROR("Can't alloc info (size %zd)", sizeof(*info));
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rc = copy_from_user(info, ptr, sizeof(*info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out_free;
+	}
+
+	info->initiator_name[sizeof(info->initiator_name)-1] = '\0';
+
+	target = target_lookup_by_id(info->tid);
+	if (target == NULL) {
+		PRINT_ERROR("Target %d not found", info->tid);
+		err = -ENOENT;
+		goto out_free;
+	}
+
+	err = __add_session(target, info);
+
+out_free:
+	kfree(info);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int del_session(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_kern_session_info *info;
+	struct iscsi_target *target;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL) {
+		PRINT_ERROR("Can't alloc info (size %zd)", sizeof(*info));
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rc = copy_from_user(info, ptr, sizeof(*info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out_free;
+	}
+
+	info->initiator_name[sizeof(info->initiator_name)-1] = '\0';
+
+	target = target_lookup_by_id(info->tid);
+	if (target == NULL) {
+		PRINT_ERROR("Target %d not found", info->tid);
+		err = -ENOENT;
+		goto out_free;
+	}
+
+	mutex_lock(&target->target_mutex);
+	err = __del_session(target, info->sid);
+	mutex_unlock(&target->target_mutex);
+
+out_free:
+	kfree(info);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int iscsi_params_config(void __user *ptr, int set)
+{
+	int err, rc;
+	struct iscsi_kern_params_info info;
+	struct iscsi_target *target;
+
+	rc = copy_from_user(&info, ptr, sizeof(info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	target = target_lookup_by_id(info.tid);
+	if (target == NULL) {
+		PRINT_ERROR("Target %d not found", info.tid);
+		err = -ENOENT;
+		goto out;
+	}
+
+	mutex_lock(&target->target_mutex);
+	err = iscsi_params_set(target, &info, set);
+	mutex_unlock(&target->target_mutex);
+
+	if (err < 0)
+		goto out;
+
+	if (!set) {
+		rc = copy_to_user(ptr, &info, sizeof(info));
+		if (rc != 0) {
+			PRINT_ERROR("Failed to copy to user %d bytes", rc);
+			err = -EFAULT;
+			goto out;
+		}
+	}
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int mgmt_cmd_callback(void __user *ptr)
+{
+	int err = 0, rc;
+	struct iscsi_kern_mgmt_cmd_res_info cinfo;
+	struct scst_sysfs_user_info *info;
+
+	rc = copy_from_user(&cinfo, ptr, sizeof(cinfo));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	cinfo.value[sizeof(cinfo.value)-1] = '\0';
+
+	info = scst_sysfs_user_get_info(cinfo.cookie);
+	TRACE_DBG("cookie %u, info %p, result %d", cinfo.cookie, info,
+		cinfo.result);
+	if (info == NULL) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	info->info_status = 0;
+
+	if (cinfo.result != 0) {
+		info->info_status = cinfo.result;
+		goto out_complete;
+	}
+
+	switch (cinfo.req_cmd) {
+	case E_ENABLE_TARGET:
+	case E_DISABLE_TARGET:
+	{
+		struct iscsi_target *target;
+
+		target = target_lookup_by_id(cinfo.tid);
+		if (target == NULL) {
+			PRINT_ERROR("Target %d not found", cinfo.tid);
+			err = -ENOENT;
+			goto out_status;
+		}
+
+		target->tgt_enabled = (cinfo.req_cmd == E_ENABLE_TARGET) ? 1 : 0;
+		break;
+	}
+
+	case E_GET_ATTR_VALUE:
+		info->data = kstrdup(cinfo.value, GFP_KERNEL);
+		if (info->data == NULL) {
+			PRINT_ERROR("Can't dublicate value %s", cinfo.value);
+			info->info_status = -ENOMEM;
+			goto out_complete;
+		}
+		break;
+	}
+
+out_complete:
+	complete(&info->info_completion);
+
+out:
+	return err;
+
+out_status:
+	info->info_status = err;
+	goto out_complete;
+}
+
+static ssize_t iscsi_attr_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct iscsi_attr *tgt_attr;
+	void *value;
+
+	tgt_attr = container_of(attr, struct iscsi_attr, attr);
+
+	pos = iscsi_sysfs_send_event(
+		(tgt_attr->target != NULL) ? tgt_attr->target->tid : 0,
+		E_GET_ATTR_VALUE, tgt_attr->name, NULL, &value);
+
+	if (pos != 0)
+		goto out;
+
+	pos = scnprintf(buf, SCST_SYSFS_BLOCK_SIZE, "%s\n", (char *)value);
+
+	kfree(value);
+
+out:
+	return pos;
+}
+
+static ssize_t iscsi_attr_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int res;
+	char *buffer;
+	struct iscsi_attr *tgt_attr;
+
+	buffer = kzalloc(count+1, GFP_KERNEL);
+	if (buffer == NULL) {
+		res = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(buffer, buf, count);
+	buffer[count] = '\0';
+
+	tgt_attr = container_of(attr, struct iscsi_attr, attr);
+
+	res = iscsi_sysfs_send_event(
+		(tgt_attr->target != NULL) ? tgt_attr->target->tid : 0,
+		E_SET_ATTR_VALUE, tgt_attr->name, buffer, NULL);
+
+	kfree(buffer);
+
+	if (res == 0)
+		res = count;
+
+out:
+	return res;
+}
+
+/*
+ * target_mgmt_mutex supposed to be locked. If target != 0, target_mutex
+ * supposed to be locked as well.
+ */
+int iscsi_add_attr(struct iscsi_target *target,
+	const struct iscsi_kern_attr *attr_info)
+{
+	int res = 0;
+	struct iscsi_attr *tgt_attr;
+	struct list_head *attrs_list;
+	const char *name;
+
+	if (target != NULL) {
+		attrs_list = &target->attrs_list;
+		name = target->name;
+	} else {
+		attrs_list = &iscsi_attrs_list;
+		name = "global";
+	}
+
+	list_for_each_entry(tgt_attr, attrs_list, attrs_list_entry) {
+		if (strncmp(tgt_attr->name, attr_info->name,
+				sizeof(tgt_attr->name) == 0)) {
+			PRINT_ERROR("Attribute %s for %s already exist",
+				attr_info->name, name);
+			res = -EEXIST;
+			goto out;
+		}
+	}
+
+	TRACE_DBG("Adding %s's attr %s with mode %x", name,
+		attr_info->name, attr_info->mode);
+
+	tgt_attr = kzalloc(sizeof(*tgt_attr), GFP_KERNEL);
+	if (tgt_attr == NULL) {
+		PRINT_ERROR("Unable to allocate user (size %zd)",
+			sizeof(*tgt_attr));
+		res = -ENOMEM;
+		goto out;
+	}
+
+	tgt_attr->target = target;
+
+	tgt_attr->name = kstrdup(attr_info->name, GFP_KERNEL);
+	if (tgt_attr->name == NULL) {
+		PRINT_ERROR("Unable to allocate attr %s name/value (target %s)",
+			attr_info->name, name);
+		res = -ENOMEM;
+		goto out_free;
+	}
+
+	list_add(&tgt_attr->attrs_list_entry, attrs_list);
+
+	tgt_attr->attr.attr.name = tgt_attr->name;
+	tgt_attr->attr.attr.owner = THIS_MODULE;
+	tgt_attr->attr.attr.mode = attr_info->mode & (S_IRUGO | S_IWUGO);
+	tgt_attr->attr.show = iscsi_attr_show;
+	tgt_attr->attr.store = iscsi_attr_store;
+
+	res = sysfs_create_file(
+		(target != NULL) ? scst_sysfs_get_tgt_kobj(target->scst_tgt) :
+				scst_sysfs_get_tgtt_kobj(&iscsi_template),
+		&tgt_attr->attr.attr);
+	if (res != 0) {
+		PRINT_ERROR("Unable to create file '%s' for target '%s'",
+			tgt_attr->attr.attr.name, name);
+		goto out_del;
+	}
+
+out:
+	return res;
+
+out_del:
+	list_del(&tgt_attr->attrs_list_entry);
+
+out_free:
+	kfree(tgt_attr->name);
+	kfree(tgt_attr);
+	goto out;
+}
+
+void __iscsi_del_attr(struct iscsi_target *target,
+	struct iscsi_attr *tgt_attr)
+{
+
+	TRACE_DBG("Deleting %s's attr %s",
+		(target != NULL) ? target->name : "global", tgt_attr->name);
+
+	list_del(&tgt_attr->attrs_list_entry);
+
+	sysfs_remove_file((target != NULL) ?
+			scst_sysfs_get_tgt_kobj(target->scst_tgt) :
+			scst_sysfs_get_tgtt_kobj(&iscsi_template),
+		&tgt_attr->attr.attr);
+
+	kfree(tgt_attr->name);
+	kfree(tgt_attr);
+	return;
+}
+
+/*
+ * target_mgmt_mutex supposed to be locked. If target != 0, target_mutex
+ * supposed to be locked as well.
+ */
+static int iscsi_del_attr(struct iscsi_target *target,
+	const char *attr_name)
+{
+	int res = 0;
+	struct iscsi_attr *tgt_attr, *a;
+	struct list_head *attrs_list;
+
+	if (target != NULL)
+		attrs_list = &target->attrs_list;
+	else
+		attrs_list = &iscsi_attrs_list;
+
+	tgt_attr = NULL;
+	list_for_each_entry(a, attrs_list, attrs_list_entry) {
+		if (strncmp(a->name, attr_name, sizeof(a->name)) == 0) {
+			tgt_attr = a;
+			break;
+		}
+	}
+
+	if (tgt_attr == NULL) {
+		PRINT_ERROR("attr %s not found (target %s)", attr_name,
+			(target != NULL) ? target->name : "global");
+		res = -ENOENT;
+		goto out;
+	}
+
+	__iscsi_del_attr(target, tgt_attr);
+
+out:
+	return res;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int iscsi_attr_cmd(void __user *ptr, unsigned int cmd)
+{
+	int rc, err = 0;
+	struct iscsi_kern_attr_info info;
+	struct iscsi_target *target;
+	struct scst_sysfs_user_info *i = NULL;
+
+	rc = copy_from_user(&info, ptr, sizeof(info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	info.attr.name[sizeof(info.attr.name)-1] = '\0';
+
+	if (info.cookie != 0) {
+		i = scst_sysfs_user_get_info(info.cookie);
+		TRACE_DBG("cookie %u, uinfo %p", info.cookie, i);
+		if (i == NULL) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	target = target_lookup_by_id(info.tid);
+
+	if (target != NULL)
+		mutex_lock(&target->target_mutex);
+
+	switch (cmd) {
+	case ISCSI_ATTR_ADD:
+		err = iscsi_add_attr(target, &info.attr);
+		break;
+	case ISCSI_ATTR_DEL:
+		err = iscsi_del_attr(target, info.attr.name);
+		break;
+	default:
+		BUG();
+	}
+
+	if (target != NULL)
+		mutex_unlock(&target->target_mutex);
+
+	if (i != NULL) {
+		i->info_status = err;
+		complete(&i->info_completion);
+	}
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int add_target(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_kern_target_info *info;
+	struct scst_sysfs_user_info *uinfo;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL) {
+		PRINT_ERROR("Can't alloc info (size %zd)", sizeof(*info));
+		err = -ENOMEM;
+		goto out;
+	}
+
+	rc = copy_from_user(info, ptr, sizeof(*info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out_free;
+	}
+
+	if (target_lookup_by_id(info->tid) != NULL) {
+		PRINT_ERROR("Target %u already exist!", info->tid);
+		err = -EEXIST;
+		goto out_free;
+	}
+
+	info->name[sizeof(info->name)-1] = '\0';
+
+	if (info->cookie != 0) {
+		uinfo = scst_sysfs_user_get_info(info->cookie);
+		TRACE_DBG("cookie %u, uinfo %p", info->cookie, uinfo);
+		if (uinfo == NULL) {
+			err = -EINVAL;
+			goto out_free;
+		}
+	} else
+		uinfo = NULL;
+
+	err = __add_target(info);
+
+	if (uinfo != NULL) {
+		uinfo->info_status = err;
+		complete(&uinfo->info_completion);
+	}
+
+out_free:
+	kfree(info);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int del_target(void __user *ptr)
+{
+	int err, rc;
+	struct iscsi_kern_target_info info;
+	struct scst_sysfs_user_info *uinfo;
+
+	rc = copy_from_user(&info, ptr, sizeof(info));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy %d user's bytes", rc);
+		err = -EFAULT;
+		goto out;
+	}
+
+	info.name[sizeof(info.name)-1] = '\0';
+
+	if (info.cookie != 0) {
+		uinfo = scst_sysfs_user_get_info(info.cookie);
+		TRACE_DBG("cookie %u, uinfo %p", info.cookie, uinfo);
+		if (uinfo == NULL) {
+			err = -EINVAL;
+			goto out;
+		}
+	} else
+		uinfo = NULL;
+
+	err = __del_target(info.tid);
+
+	if (uinfo != NULL) {
+		uinfo->info_status = err;
+		complete(&uinfo->info_completion);
+	}
+
+out:
+	return err;
+}
+
+static int iscsi_register(void __user *arg)
+{
+	struct iscsi_kern_register_info reg;
+	char ver[sizeof(ISCSI_SCST_INTERFACE_VERSION)+1];
+	int res, rc;
+
+	rc = copy_from_user(&reg, arg, sizeof(reg));
+	if (rc != 0) {
+		PRINT_ERROR("%s", "Unable to get register info");
+		res = -EFAULT;
+		goto out;
+	}
+
+	rc = copy_from_user(ver, (void __user *)(unsigned long)reg.version,
+				sizeof(ver));
+	if (rc != 0) {
+		PRINT_ERROR("%s", "Unable to get version string");
+		res = -EFAULT;
+		goto out;
+	}
+	ver[sizeof(ver)-1] = '\0';
+
+	if (strcmp(ver, ISCSI_SCST_INTERFACE_VERSION) != 0) {
+		PRINT_ERROR("Incorrect version of user space %s (expected %s)",
+			ver, ISCSI_SCST_INTERFACE_VERSION);
+		res = -EINVAL;
+		goto out;
+	}
+
+	memset(&reg, 0, sizeof(reg));
+	reg.max_data_seg_len = ISCSI_CONN_IOV_MAX << PAGE_SHIFT;
+	reg.max_queued_cmds = scst_get_max_lun_commands(NULL, NO_SUCH_LUN);
+
+	res = 0;
+
+	rc = copy_to_user(arg, &reg, sizeof(reg));
+	if (rc != 0) {
+		PRINT_ERROR("Failed to copy to user %d bytes", rc);
+		res = -EFAULT;
+		goto out;
+	}
+
+out:
+	return res;
+}
+
+static long ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long err;
+
+	if (cmd == REGISTER_USERD) {
+		err = iscsi_register((void __user *)arg);
+		goto out;
+	}
+
+	err = mutex_lock_interruptible(&target_mgmt_mutex);
+	if (err < 0)
+		goto out;
+
+	switch (cmd) {
+	case ADD_TARGET:
+		err = add_target((void __user *)arg);
+		break;
+
+	case DEL_TARGET:
+		err = del_target((void __user *)arg);
+		break;
+
+	case ISCSI_ATTR_ADD:
+	case ISCSI_ATTR_DEL:
+		err = iscsi_attr_cmd((void __user *)arg, cmd);
+		break;
+
+	case MGMT_CMD_CALLBACK:
+		err = mgmt_cmd_callback((void __user *)arg);
+		break;
+
+	case ADD_SESSION:
+		err = add_session((void __user *)arg);
+		break;
+
+	case DEL_SESSION:
+		err = del_session((void __user *)arg);
+		break;
+
+	case ISCSI_PARAM_SET:
+		err = iscsi_params_config((void __user *)arg, 1);
+		break;
+
+	case ISCSI_PARAM_GET:
+		err = iscsi_params_config((void __user *)arg, 0);
+		break;
+
+	case ADD_CONN:
+		err = add_conn((void __user *)arg);
+		break;
+
+	case DEL_CONN:
+		err = del_conn((void __user *)arg);
+		break;
+
+	default:
+		PRINT_ERROR("Invalid ioctl cmd %x", cmd);
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&target_mgmt_mutex);
+
+out:
+	return err;
+}
+
+static int open(struct inode *inode, struct file *file)
+{
+	bool already;
+
+	mutex_lock(&target_mgmt_mutex);
+	already = (ctr_open_state != ISCSI_CTR_OPEN_STATE_CLOSED);
+	if (!already)
+		ctr_open_state = ISCSI_CTR_OPEN_STATE_OPEN;
+	mutex_unlock(&target_mgmt_mutex);
+
+	if (already) {
+		PRINT_WARNING("%s", "Attempt to second open the control "
+			"device!");
+		return -EBUSY;
+	} else
+		return 0;
+}
+
+static int release(struct inode *inode, struct file *filp)
+{
+	struct iscsi_attr *attr, *t;
+
+	TRACE(TRACE_MGMT, "%s", "Releasing allocated resources");
+
+	mutex_lock(&target_mgmt_mutex);
+	ctr_open_state = ISCSI_CTR_OPEN_STATE_CLOSING;
+	mutex_unlock(&target_mgmt_mutex);
+
+	target_del_all();
+
+	mutex_lock(&target_mgmt_mutex);
+
+	list_for_each_entry_safe(attr, t, &iscsi_attrs_list,
+					attrs_list_entry) {
+		__iscsi_del_attr(NULL, attr);
+	}
+
+	ctr_open_state = ISCSI_CTR_OPEN_STATE_CLOSED;
+
+	mutex_unlock(&target_mgmt_mutex);
+
+	return 0;
+}
+
+const struct file_operations ctr_fops = {
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= ioctl,
+	.compat_ioctl	= ioctl,
+	.open		= open,
+	.release	= release,
+};
+
+#ifdef CONFIG_SCST_DEBUG
+static void iscsi_dump_char(int ch, unsigned char *text, int *pos)
+{
+	int i = *pos;
+
+	if (ch < 0) {
+		while ((i % 16) != 0) {
+			printk(KERN_CONT "   ");
+			text[i] = ' ';
+			i++;
+			if ((i % 16) == 0)
+				printk(KERN_CONT " | %.16s |\n", text);
+			else if ((i % 4) == 0)
+				printk(KERN_CONT " |");
+		}
+		i = 0;
+		goto out;
+	}
+
+	text[i] = (ch < 0x20 || (ch >= 0x80 && ch <= 0xa0)) ? ' ' : ch;
+	printk(KERN_CONT " %02x", ch);
+	i++;
+	if ((i % 16) == 0) {
+		printk(KERN_CONT " | %.16s |\n", text);
+		i = 0;
+	} else if ((i % 4) == 0)
+		printk(KERN_CONT " |");
+
+out:
+	*pos = i;
+	return;
+}
+
+void iscsi_dump_pdu(struct iscsi_pdu *pdu)
+{
+	unsigned char text[16];
+	int pos = 0;
+
+	if (trace_flag & TRACE_D_DUMP_PDU) {
+		unsigned char *buf;
+		int i;
+
+		buf = (void *)&pdu->bhs;
+		printk(KERN_DEBUG "BHS: (%p,%zd)\n", buf, sizeof(pdu->bhs));
+		for (i = 0; i < (int)sizeof(pdu->bhs); i++)
+			iscsi_dump_char(*buf++, text, &pos);
+		iscsi_dump_char(-1, text, &pos);
+
+		buf = (void *)pdu->ahs;
+		printk(KERN_DEBUG "AHS: (%p,%d)\n", buf, pdu->ahssize);
+		for (i = 0; i < pdu->ahssize; i++)
+			iscsi_dump_char(*buf++, text, &pos);
+		iscsi_dump_char(-1, text, &pos);
+
+		printk(KERN_DEBUG "Data: (%d)\n", pdu->datasize);
+	}
+}
+
+unsigned long iscsi_get_flow_ctrl_or_mgmt_dbg_log_flag(struct iscsi_cmnd *cmnd)
+{
+	unsigned long flag;
+
+	if (cmnd->cmd_req != NULL)
+		cmnd = cmnd->cmd_req;
+
+	if (cmnd->scst_cmd == NULL)
+		flag = TRACE_MGMT_DEBUG;
+	else {
+		int status = scst_cmd_get_status(cmnd->scst_cmd);
+		if ((status == SAM_STAT_TASK_SET_FULL) ||
+		    (status == SAM_STAT_BUSY))
+			flag = TRACE_FLOW_CONTROL;
+		else
+			flag = TRACE_MGMT_DEBUG;
+	}
+	return flag;
+}
+
+#endif /* CONFIG_SCST_DEBUG */
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/conn.c linux-2.6.33/drivers/scst/iscsi-scst/conn.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/conn.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/conn.c
@@ -0,0 +1,785 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/file.h>
+#include <linux/ip.h>
+#include <net/tcp.h>
+
+#include "iscsi.h"
+#include "digest.h"
+
+static int print_conn_state(char *p, size_t size, struct iscsi_conn *conn)
+{
+	int pos = 0;
+
+	if (conn->closing) {
+		pos += scnprintf(p, size, "%s", "closing");
+		goto out;
+	}
+
+	switch (conn->rd_state) {
+	case ISCSI_CONN_RD_STATE_PROCESSING:
+		pos += scnprintf(&p[pos], size - pos, "%s", "read_processing ");
+		break;
+	case ISCSI_CONN_RD_STATE_IN_LIST:
+		pos += scnprintf(&p[pos], size - pos, "%s", "in_read_list ");
+		break;
+	}
+
+	switch (conn->wr_state) {
+	case ISCSI_CONN_WR_STATE_PROCESSING:
+		pos += scnprintf(&p[pos], size - pos, "%s", "write_processing ");
+		break;
+	case ISCSI_CONN_WR_STATE_IN_LIST:
+		pos += scnprintf(&p[pos], size - pos, "%s", "in_write_list ");
+		break;
+	case ISCSI_CONN_WR_STATE_SPACE_WAIT:
+		pos += scnprintf(&p[pos], size - pos, "%s", "space_waiting ");
+		break;
+	}
+
+	if (test_bit(ISCSI_CONN_REINSTATING, &conn->conn_aflags))
+		pos += scnprintf(&p[pos], size - pos, "%s", "reinstating ");
+	else if (pos == 0)
+		pos += scnprintf(&p[pos], size - pos, "%s", "established idle ");
+
+out:
+	return pos;
+}
+
+static int conn_free(struct iscsi_conn *conn);
+
+static void iscsi_conn_release(struct kobject *kobj)
+{
+	struct iscsi_conn *conn;
+	struct iscsi_target *target;
+
+	conn = container_of(kobj, struct iscsi_conn, iscsi_conn_kobj);
+	target = conn->target;
+
+	mutex_lock(&target->target_mutex);
+	conn_free(conn);
+	mutex_unlock(&target->target_mutex);
+	return;
+}
+
+static struct kobj_type iscsi_conn_ktype = {
+	.sysfs_ops = &scst_sysfs_ops,
+	.release = iscsi_conn_release,
+};
+
+static ssize_t iscsi_get_initiator_ip(struct iscsi_conn *conn,
+	char *buf, int size)
+{
+	int pos;
+	struct sock *sk;
+
+	sk = conn->sock->sk;
+	switch (sk->sk_family) {
+	case AF_INET:
+		pos = scnprintf(buf, size,
+			"%u.%u.%u.%u", NIPQUAD(inet_sk(sk)->inet_daddr));
+		break;
+	case AF_INET6:
+		pos = scnprintf(buf, size, "[%p6]",
+			&inet6_sk(sk)->daddr);
+		break;
+	default:
+		pos = scnprintf(buf, size, "Unknown family %d",
+			sk->sk_family);
+		break;
+	}
+	return pos;
+}
+
+static ssize_t iscsi_conn_ip_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct iscsi_conn *conn;
+
+	conn = container_of(kobj, struct iscsi_conn, iscsi_conn_kobj);
+
+	pos = iscsi_get_initiator_ip(conn, buf, SCST_SYSFS_BLOCK_SIZE);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_conn_ip_attr =
+	__ATTR(ip, S_IRUGO, iscsi_conn_ip_show, NULL);
+
+static ssize_t iscsi_conn_cid_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct iscsi_conn *conn;
+
+	conn = container_of(kobj, struct iscsi_conn, iscsi_conn_kobj);
+
+	pos = sprintf(buf, "%u", conn->cid);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_conn_cid_attr =
+	__ATTR(cid, S_IRUGO, iscsi_conn_cid_show, NULL);
+
+static ssize_t iscsi_conn_state_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct iscsi_conn *conn;
+
+	conn = container_of(kobj, struct iscsi_conn, iscsi_conn_kobj);
+
+	pos = print_conn_state(buf, SCST_SYSFS_BLOCK_SIZE, conn);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_conn_state_attr =
+	__ATTR(state, S_IRUGO, iscsi_conn_state_show, NULL);
+
+/* target_mutex supposed to be locked */
+struct iscsi_conn *conn_lookup(struct iscsi_session *session, u16 cid)
+{
+	struct iscsi_conn *conn;
+
+	/*
+	 * We need to find the latest conn to correctly handle
+	 * multi-reinstatements
+	 */
+	list_for_each_entry_reverse(conn, &session->conn_list,
+					conn_list_entry) {
+		if (conn->cid == cid)
+			return conn;
+	}
+	return NULL;
+}
+
+void iscsi_make_conn_rd_active(struct iscsi_conn *conn)
+{
+
+	spin_lock_bh(&iscsi_rd_lock);
+
+	TRACE_DBG("conn %p, rd_state %x, rd_data_ready %d", conn,
+		conn->rd_state, conn->rd_data_ready);
+
+	conn->rd_data_ready = 1;
+
+	if (conn->rd_state == ISCSI_CONN_RD_STATE_IDLE) {
+		list_add_tail(&conn->rd_list_entry, &iscsi_rd_list);
+		conn->rd_state = ISCSI_CONN_RD_STATE_IN_LIST;
+		wake_up(&iscsi_rd_waitQ);
+	}
+
+	spin_unlock_bh(&iscsi_rd_lock);
+	return;
+}
+
+void iscsi_make_conn_wr_active(struct iscsi_conn *conn)
+{
+
+	spin_lock_bh(&iscsi_wr_lock);
+
+	TRACE_DBG("conn %p, wr_state %x, wr_space_ready %d", conn,
+		conn->wr_state, conn->wr_space_ready);
+
+	if (conn->wr_state == ISCSI_CONN_WR_STATE_IDLE) {
+		list_add_tail(&conn->wr_list_entry, &iscsi_wr_list);
+		conn->wr_state = ISCSI_CONN_WR_STATE_IN_LIST;
+		wake_up(&iscsi_wr_waitQ);
+	}
+
+	spin_unlock_bh(&iscsi_wr_lock);
+	return;
+}
+
+void __mark_conn_closed(struct iscsi_conn *conn, int flags)
+{
+	spin_lock_bh(&iscsi_rd_lock);
+	conn->closing = 1;
+	if (flags & ISCSI_CONN_ACTIVE_CLOSE)
+		conn->active_close = 1;
+	if (flags & ISCSI_CONN_DELETING)
+		conn->deleting = 1;
+	spin_unlock_bh(&iscsi_rd_lock);
+
+	iscsi_make_conn_rd_active(conn);
+}
+
+void mark_conn_closed(struct iscsi_conn *conn)
+{
+	__mark_conn_closed(conn, ISCSI_CONN_ACTIVE_CLOSE);
+}
+
+static void __iscsi_state_change(struct sock *sk)
+{
+	struct iscsi_conn *conn = sk->sk_user_data;
+
+	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
+		if (!conn->closing) {
+			PRINT_ERROR("Connection with initiator %s "
+				"unexpectedly closed!",
+				conn->session->initiator_name);
+			TRACE_MGMT_DBG("conn %p, sk state %d", conn,
+				sk->sk_state);
+			__mark_conn_closed(conn, 0);
+		}
+	} else
+		iscsi_make_conn_rd_active(conn);
+	return;
+}
+
+static void iscsi_state_change(struct sock *sk)
+{
+	struct iscsi_conn *conn = sk->sk_user_data;
+
+	__iscsi_state_change(sk);
+	conn->old_state_change(sk);
+
+	return;
+}
+
+static void iscsi_data_ready(struct sock *sk, int len)
+{
+	struct iscsi_conn *conn = sk->sk_user_data;
+
+	iscsi_make_conn_rd_active(conn);
+
+	conn->old_data_ready(sk, len);
+	return;
+}
+
+static void iscsi_write_space_ready(struct sock *sk)
+{
+	struct iscsi_conn *conn = sk->sk_user_data;
+
+	TRACE_DBG("Write space ready for conn %p", conn);
+
+	spin_lock_bh(&iscsi_wr_lock);
+	conn->wr_space_ready = 1;
+	if ((conn->wr_state == ISCSI_CONN_WR_STATE_SPACE_WAIT)) {
+		list_add_tail(&conn->wr_list_entry, &iscsi_wr_list);
+		conn->wr_state = ISCSI_CONN_WR_STATE_IN_LIST;
+		wake_up(&iscsi_wr_waitQ);
+	}
+	spin_unlock_bh(&iscsi_wr_lock);
+
+	conn->old_write_space(sk);
+	return;
+}
+
+static void conn_rsp_timer_fn(unsigned long arg)
+{
+	struct iscsi_conn *conn = (struct iscsi_conn *)arg;
+	struct iscsi_cmnd *cmnd;
+	unsigned long j = jiffies;
+
+	TRACE_DBG("Timer (conn %p)", conn);
+
+	spin_lock_bh(&conn->write_list_lock);
+
+	if (!list_empty(&conn->write_timeout_list)) {
+		unsigned long timeout_time;
+		cmnd = list_entry(conn->write_timeout_list.next,
+				struct iscsi_cmnd, write_timeout_list_entry);
+
+		timeout_time = j + conn->rsp_timeout + ISCSI_ADD_SCHED_TIME;
+
+		if (unlikely(time_after_eq(j, cmnd->write_start +
+						conn->rsp_timeout))) {
+			if (!conn->closing) {
+				PRINT_ERROR("Timeout sending data/waiting "
+					"for reply to/from initiator "
+					"%s (SID %llx), closing connection",
+					conn->session->initiator_name,
+					(long long unsigned int)
+						conn->session->sid);
+				/*
+				 * We must call mark_conn_closed() outside of
+				 * write_list_lock or we will have a circular
+				 * locking dependency with iscsi_rd_lock.
+				 */
+				spin_unlock_bh(&conn->write_list_lock);
+				mark_conn_closed(conn);
+				goto out;
+			}
+		} else if (!timer_pending(&conn->rsp_timer) ||
+			   time_after(conn->rsp_timer.expires, timeout_time)) {
+			TRACE_DBG("Restarting timer on %ld (conn %p)",
+				timeout_time, conn);
+			/*
+			 * Timer might have been restarted while we were
+			 * entering here.
+			 */
+			mod_timer(&conn->rsp_timer, timeout_time);
+		}
+	}
+
+	spin_unlock_bh(&conn->write_list_lock);
+
+	if (unlikely(conn->conn_tm_active)) {
+		TRACE_MGMT_DBG("TM active: making conn %p RD active", conn);
+		iscsi_make_conn_rd_active(conn);
+	}
+
+out:
+	return;
+}
+
+static void conn_nop_in_delayed_work_fn(struct delayed_work *work)
+{
+	struct iscsi_conn *conn = container_of(work, struct iscsi_conn,
+		nop_in_delayed_work);
+
+	if (time_after_eq(jiffies, conn->last_rcv_time +
+				conn->nop_in_interval)) {
+		iscsi_send_nop_in(conn);
+	}
+
+	if (conn->nop_in_interval > 0) {
+		TRACE_DBG("Reschedule Nop-In work for conn %p", conn);
+		schedule_delayed_work(&conn->nop_in_delayed_work,
+			conn->nop_in_interval + ISCSI_ADD_SCHED_TIME);
+	}
+	return;
+}
+
+/* Must be called from rd thread only */
+void iscsi_check_tm_data_wait_timeouts(struct iscsi_conn *conn, bool force)
+{
+	struct iscsi_cmnd *cmnd;
+	unsigned long j = jiffies;
+	bool aborted_cmds_pending;
+	unsigned long timeout_time = j + ISCSI_TM_DATA_WAIT_TIMEOUT +
+					ISCSI_ADD_SCHED_TIME;
+
+	TRACE_DBG_FLAG(force ? TRACE_CONN_OC_DBG : TRACE_MGMT_DEBUG,
+		"j %ld (TIMEOUT %d, force %d)", j,
+		ISCSI_TM_DATA_WAIT_TIMEOUT + ISCSI_ADD_SCHED_TIME, force);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+again:
+	spin_lock_bh(&iscsi_rd_lock);
+	spin_lock(&conn->write_list_lock);
+
+	aborted_cmds_pending = false;
+	list_for_each_entry(cmnd, &conn->write_timeout_list,
+				write_timeout_list_entry) {
+		if (test_bit(ISCSI_CMD_ABORTED, &cmnd->prelim_compl_flags)) {
+			TRACE_DBG_FLAG(force ? TRACE_CONN_OC_DBG : TRACE_MGMT_DEBUG,
+				"Checking aborted cmnd %p (scst_state %d, "
+				"on_write_timeout_list %d, write_start %ld, "
+				"r2t_len_to_receive %d)", cmnd,
+				cmnd->scst_state, cmnd->on_write_timeout_list,
+				cmnd->write_start, cmnd->r2t_len_to_receive);
+			if ((cmnd->r2t_len_to_receive != 0) &&
+			    (time_after_eq(j, cmnd->write_start + ISCSI_TM_DATA_WAIT_TIMEOUT) ||
+			     force)) {
+				spin_unlock(&conn->write_list_lock);
+				spin_unlock_bh(&iscsi_rd_lock);
+				iscsi_fail_data_waiting_cmnd(cmnd);
+				goto again;
+			}
+			aborted_cmds_pending = true;
+		}
+	}
+
+	if (aborted_cmds_pending) {
+		if (!force &&
+		    (!timer_pending(&conn->rsp_timer) ||
+		     time_after(conn->rsp_timer.expires, timeout_time))) {
+			TRACE_MGMT_DBG("Mod timer on %ld (conn %p)",
+				timeout_time, conn);
+			mod_timer(&conn->rsp_timer, timeout_time);
+		}
+	} else {
+		TRACE_MGMT_DBG("Clearing conn_tm_active for conn %p", conn);
+		conn->conn_tm_active = 0;
+	}
+
+	spin_unlock(&conn->write_list_lock);
+	spin_unlock_bh(&iscsi_rd_lock);
+	return;
+}
+
+/* target_mutex supposed to be locked */
+void conn_reinst_finished(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd, *t;
+
+	clear_bit(ISCSI_CONN_REINSTATING, &conn->conn_aflags);
+
+	list_for_each_entry_safe(cmnd, t, &conn->reinst_pending_cmd_list,
+					reinst_pending_cmd_list_entry) {
+		TRACE_MGMT_DBG("Restarting reinst pending cmnd %p",
+			cmnd);
+		list_del(&cmnd->reinst_pending_cmd_list_entry);
+		iscsi_restart_cmnd(cmnd);
+	}
+	return;
+}
+
+static void conn_activate(struct iscsi_conn *conn)
+{
+	TRACE_MGMT_DBG("Enabling conn %p", conn);
+
+	/* Catch double bind */
+	BUG_ON(conn->sock->sk->sk_state_change == iscsi_state_change);
+
+	write_lock_bh(&conn->sock->sk->sk_callback_lock);
+
+	conn->old_state_change = conn->sock->sk->sk_state_change;
+	conn->sock->sk->sk_state_change = iscsi_state_change;
+
+	conn->old_data_ready = conn->sock->sk->sk_data_ready;
+	conn->sock->sk->sk_data_ready = iscsi_data_ready;
+
+	conn->old_write_space = conn->sock->sk->sk_write_space;
+	conn->sock->sk->sk_write_space = iscsi_write_space_ready;
+
+	write_unlock_bh(&conn->sock->sk->sk_callback_lock);
+
+	/*
+	 * Check, if conn was closed while we were initializing it.
+	 * This function will make conn rd_active, if necessary.
+	 */
+	__iscsi_state_change(conn->sock->sk);
+
+	return;
+}
+
+/*
+ * Note: the code below passes a kernel space pointer (&opt) to setsockopt()
+ * while the declaration of setsockopt specifies that it expects a user space
+ * pointer. This seems to work fine, and this approach is also used in some
+ * other parts of the Linux kernel (see e.g. fs/ocfs2/cluster/tcp.c).
+ */
+static int conn_setup_sock(struct iscsi_conn *conn)
+{
+	int res = 0;
+	int opt = 1;
+	mm_segment_t oldfs;
+	struct iscsi_session *session = conn->session;
+
+	TRACE_DBG("%llu", (long long unsigned int)session->sid);
+
+	conn->sock = SOCKET_I(conn->file->f_dentry->d_inode);
+
+	if (conn->sock->ops->sendpage == NULL) {
+		PRINT_ERROR("Socket for sid %llu doesn't support sendpage()",
+			    (long long unsigned int)session->sid);
+		res = -EINVAL;
+		goto out;
+	}
+
+#if 0
+	conn->sock->sk->sk_allocation = GFP_NOIO;
+#endif
+	conn->sock->sk->sk_user_data = conn;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+	conn->sock->ops->setsockopt(conn->sock, SOL_TCP, TCP_NODELAY,
+		(void __force __user *)&opt, sizeof(opt));
+	set_fs(oldfs);
+
+out:
+	return res;
+}
+
+/* target_mutex supposed to be locked */
+static int conn_free(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = conn->session;
+
+	TRACE_MGMT_DBG("Freeing conn %p (sess=%p, %#Lx %u)", conn,
+		session, (long long unsigned int)session->sid, conn->cid);
+
+	del_timer_sync(&conn->rsp_timer);
+
+	BUG_ON(atomic_read(&conn->conn_ref_cnt) != 0);
+	BUG_ON(!list_empty(&conn->cmd_list));
+	BUG_ON(!list_empty(&conn->write_list));
+	BUG_ON(!list_empty(&conn->write_timeout_list));
+	BUG_ON(conn->conn_reinst_successor != NULL);
+	BUG_ON(!test_bit(ISCSI_CONN_SHUTTINGDOWN, &conn->conn_aflags));
+
+	/* Just in case if new conn gets freed before the old one */
+	if (test_bit(ISCSI_CONN_REINSTATING, &conn->conn_aflags)) {
+		struct iscsi_conn *c;
+		TRACE_MGMT_DBG("Freeing being reinstated conn %p", conn);
+		list_for_each_entry(c, &session->conn_list,
+					conn_list_entry) {
+			if (c->conn_reinst_successor == conn) {
+				c->conn_reinst_successor = NULL;
+				break;
+			}
+		}
+	}
+
+	list_del(&conn->conn_list_entry);
+
+	fput(conn->file);
+	conn->file = NULL;
+	conn->sock = NULL;
+
+	free_page((unsigned long)conn->read_iov);
+
+	kfree(conn);
+
+	if (list_empty(&session->conn_list)) {
+		BUG_ON(session->sess_reinst_successor != NULL);
+		session_free(session, true);
+	}
+
+	return 0;
+}
+
+/* target_mutex supposed to be locked */
+static int iscsi_conn_alloc(struct iscsi_session *session,
+	struct iscsi_kern_conn_info *info, struct iscsi_conn **new_conn)
+{
+	struct iscsi_conn *conn;
+	int res = 0;
+	struct iscsi_conn *c;
+	int n = 1;
+	char addr[64];
+
+	conn = kzalloc(sizeof(*conn), GFP_KERNEL);
+	if (!conn) {
+		res = -ENOMEM;
+		goto out_err;
+	}
+
+	TRACE_MGMT_DBG("Creating connection %p for sid %#Lx, cid %u", conn,
+		       (long long unsigned int)session->sid, info->cid);
+
+	/* Changing it, change ISCSI_CONN_IOV_MAX as well !! */
+	conn->read_iov = (struct iovec *)get_zeroed_page(GFP_KERNEL);
+	if (conn->read_iov == NULL) {
+		res = -ENOMEM;
+		goto out_err_free_conn;
+	}
+
+	atomic_set(&conn->conn_ref_cnt, 0);
+	conn->session = session;
+	if (session->sess_reinstating)
+		__set_bit(ISCSI_CONN_REINSTATING, &conn->conn_aflags);
+	conn->cid = info->cid;
+	conn->stat_sn = info->stat_sn;
+	conn->exp_stat_sn = info->exp_stat_sn;
+	conn->rd_state = ISCSI_CONN_RD_STATE_IDLE;
+	conn->wr_state = ISCSI_CONN_WR_STATE_IDLE;
+
+	conn->hdigest_type = session->sess_params.header_digest;
+	conn->ddigest_type = session->sess_params.data_digest;
+	res = digest_init(conn);
+	if (res != 0)
+		goto out_err_free1;
+
+	conn->target = session->target;
+	spin_lock_init(&conn->cmd_list_lock);
+	INIT_LIST_HEAD(&conn->cmd_list);
+	spin_lock_init(&conn->write_list_lock);
+	INIT_LIST_HEAD(&conn->write_list);
+	INIT_LIST_HEAD(&conn->write_timeout_list);
+	setup_timer(&conn->rsp_timer, conn_rsp_timer_fn, (unsigned long)conn);
+	init_waitqueue_head(&conn->read_state_waitQ);
+	init_completion(&conn->ready_to_free);
+	INIT_LIST_HEAD(&conn->reinst_pending_cmd_list);
+	INIT_LIST_HEAD(&conn->nop_req_list);
+	spin_lock_init(&conn->nop_req_list_lock);
+
+	conn->nop_in_ttt = 0;
+	INIT_DELAYED_WORK(&conn->nop_in_delayed_work,
+		(void (*)(struct work_struct *))conn_nop_in_delayed_work_fn);
+	conn->last_rcv_time = jiffies;
+	conn->rsp_timeout = session->tgt_params.rsp_timeout * HZ;
+	conn->nop_in_interval = session->tgt_params.nop_in_interval * HZ;
+	if (conn->nop_in_interval > 0) {
+		TRACE_DBG("Schedule Nop-In work for conn %p", conn);
+		schedule_delayed_work(&conn->nop_in_delayed_work,
+			conn->nop_in_interval + ISCSI_ADD_SCHED_TIME);
+	}
+
+	conn->file = fget(info->fd);
+
+	res = conn_setup_sock(conn);
+	if (res != 0)
+		goto out_err_free2;
+
+	iscsi_get_initiator_ip(conn, addr, sizeof(addr));
+
+restart:
+	list_for_each_entry(c, &session->conn_list, conn_list_entry) {
+		if (strcmp(addr, kobject_name(&conn->iscsi_conn_kobj)) == 0) {
+			char c_addr[64];
+
+			iscsi_get_initiator_ip(conn, c_addr, sizeof(c_addr));
+
+			TRACE_DBG("Duplicated conn from the same initiator "
+				"%s found", c_addr);
+
+			snprintf(addr, sizeof(addr), "%s_%d", c_addr, n);
+			n++;
+			goto restart;
+		}
+	}
+
+	res = kobject_init_and_add(&conn->iscsi_conn_kobj, &iscsi_conn_ktype,
+		scst_sysfs_get_sess_kobj(session->scst_sess), addr);
+	if (res != 0) {
+		PRINT_ERROR("Unable create sysfs entries for conn %s",
+			addr);
+		goto out_err_free2;
+	}
+
+	TRACE_DBG("conn %p, iscsi_conn_kobj %p", conn, &conn->iscsi_conn_kobj);
+
+	res = sysfs_create_file(&conn->iscsi_conn_kobj,
+			&iscsi_conn_state_attr.attr);
+	if (res != 0) {
+		PRINT_ERROR("Unable create sysfs attribute %s for conn %s",
+			iscsi_conn_state_attr.attr.name, addr);
+		goto out_err_free3;
+	}
+
+	res = sysfs_create_file(&conn->iscsi_conn_kobj,
+			&iscsi_conn_cid_attr.attr);
+	if (res != 0) {
+		PRINT_ERROR("Unable create sysfs attribute %s for conn %s",
+			iscsi_conn_cid_attr.attr.name, addr);
+		goto out_err_free3;
+	}
+
+	res = sysfs_create_file(&conn->iscsi_conn_kobj,
+			&iscsi_conn_ip_attr.attr);
+	if (res != 0) {
+		PRINT_ERROR("Unable create sysfs attribute %s for conn %s",
+			iscsi_conn_ip_attr.attr.name, addr);
+		goto out_err_free3;
+	}
+
+	list_add_tail(&conn->conn_list_entry, &session->conn_list);
+
+	*new_conn = conn;
+
+out:
+	return res;
+
+out_err_free3:
+	kobject_put(&conn->iscsi_conn_kobj);
+	goto out;
+
+out_err_free2:
+	fput(conn->file);
+
+out_err_free1:
+	free_page((unsigned long)conn->read_iov);
+
+out_err_free_conn:
+	kfree(conn);
+
+out_err:
+	goto out;
+}
+
+/* target_mutex supposed to be locked */
+int __add_conn(struct iscsi_session *session, struct iscsi_kern_conn_info *info)
+{
+	struct iscsi_conn *conn, *new_conn = NULL;
+	int err;
+	bool reinstatement = false;
+
+	conn = conn_lookup(session, info->cid);
+	if ((conn != NULL) &&
+	    !test_bit(ISCSI_CONN_SHUTTINGDOWN, &conn->conn_aflags)) {
+		/* conn reinstatement */
+		reinstatement = true;
+	} else if (!list_empty(&session->conn_list)) {
+		err = -EEXIST;
+		goto out;
+	}
+
+	err = iscsi_conn_alloc(session, info, &new_conn);
+	if (err != 0)
+		goto out;
+
+	if (reinstatement) {
+		TRACE_MGMT_DBG("Reinstating conn (old %p, new %p)", conn,
+			new_conn);
+		conn->conn_reinst_successor = new_conn;
+		__set_bit(ISCSI_CONN_REINSTATING, &new_conn->conn_aflags);
+		__mark_conn_closed(conn, 0);
+	}
+
+	conn_activate(new_conn);
+
+out:
+	return err;
+}
+
+/* target_mutex supposed to be locked */
+int __del_conn(struct iscsi_session *session, struct iscsi_kern_conn_info *info)
+{
+	struct iscsi_conn *conn;
+	int err = -EEXIST;
+
+	conn = conn_lookup(session, info->cid);
+	if (!conn) {
+		PRINT_ERROR("Connection %d not found", info->cid);
+		return err;
+	}
+
+	PRINT_INFO("Deleting connection with initiator %s (%p)",
+		conn->session->initiator_name, conn);
+
+	__mark_conn_closed(conn, ISCSI_CONN_ACTIVE_CLOSE|ISCSI_CONN_DELETING);
+
+	return 0;
+}
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+
+void iscsi_extracheck_is_rd_thread(struct iscsi_conn *conn)
+{
+	if (unlikely(current != conn->rd_task)) {
+		printk(KERN_EMERG "conn %p rd_task != current %p (pid %d)\n",
+			conn, current, current->pid);
+		while (in_softirq())
+			local_bh_enable();
+		printk(KERN_EMERG "rd_state %x\n", conn->rd_state);
+		printk(KERN_EMERG "rd_task %p\n", conn->rd_task);
+		printk(KERN_EMERG "rd_task->pid %d\n", conn->rd_task->pid);
+		BUG();
+	}
+}
+
+void iscsi_extracheck_is_wr_thread(struct iscsi_conn *conn)
+{
+	if (unlikely(current != conn->wr_task)) {
+		printk(KERN_EMERG "conn %p wr_task != current %p (pid %d)\n",
+			conn, current, current->pid);
+		while (in_softirq())
+			local_bh_enable();
+		printk(KERN_EMERG "wr_state %x\n", conn->wr_state);
+		printk(KERN_EMERG "wr_task %p\n", conn->wr_task);
+		printk(KERN_EMERG "wr_task->pid %d\n", conn->wr_task->pid);
+		BUG();
+	}
+}
+
+#endif /* CONFIG_SCST_EXTRACHECKS */
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/digest.c linux-2.6.33/drivers/scst/iscsi-scst/digest.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/digest.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/digest.c
@@ -0,0 +1,226 @@
+/*
+ *  iSCSI digest handling.
+ *
+ *  Copyright (C) 2004 - 2006 Xiranet Communications GmbH
+ *                            <arne.redlich@xiranet.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/scatterlist.h>
+
+#include "iscsi.h"
+#include "digest.h"
+#include <linux/crc32c.h>
+
+void digest_alg_available(int *val)
+{
+#if defined(CONFIG_LIBCRC32C_MODULE) || defined(CONFIG_LIBCRC32C)
+	int crc32c = 1;
+#else
+	int crc32c = 0;
+#endif
+
+	if ((*val & DIGEST_CRC32C) && !crc32c) {
+		PRINT_ERROR("%s", "CRC32C digest algorithm not available "
+			"in kernel");
+		*val |= ~DIGEST_CRC32C;
+	}
+}
+
+/**
+ * initialize support for digest calculation.
+ *
+ * digest_init -
+ * @conn: ptr to connection to make use of digests
+ *
+ * @return: 0 on success, < 0 on error
+ */
+int digest_init(struct iscsi_conn *conn)
+{
+	if (!(conn->hdigest_type & DIGEST_ALL))
+		conn->hdigest_type = DIGEST_NONE;
+
+	if (!(conn->ddigest_type & DIGEST_ALL))
+		conn->ddigest_type = DIGEST_NONE;
+
+	return 0;
+}
+
+static u32 evaluate_crc32_from_sg(struct scatterlist *sg, int nbytes,
+	uint32_t padding)
+{
+	u32 crc = ~0;
+	int pad_bytes = ((nbytes + 3) & -4) - nbytes;
+
+#ifdef CONFIG_SCST_ISCSI_DEBUG_DIGEST_FAILURES
+	if (((scst_random() % 100000) == 752)) {
+		PRINT_INFO("%s", "Simulating digest failure");
+		return 0;
+	}
+#endif
+
+#if defined(CONFIG_LIBCRC32C_MODULE) || defined(CONFIG_LIBCRC32C)
+	while (nbytes > 0) {
+		int d = min(nbytes, (int)(sg->length));
+		crc = crc32c(crc, sg_virt(sg), d);
+		nbytes -= d;
+		sg++;
+	}
+
+	if (pad_bytes)
+		crc = crc32c(crc, (u8 *)&padding, pad_bytes);
+#endif
+
+	return ~cpu_to_le32(crc);
+}
+
+static u32 digest_header(struct iscsi_pdu *pdu)
+{
+	struct scatterlist sg[2];
+	unsigned int nbytes = sizeof(struct iscsi_hdr);
+	int asize = (pdu->ahssize + 3) & -4;
+
+	sg_init_table(sg, 2);
+
+	sg_set_buf(&sg[0], &pdu->bhs, nbytes);
+	if (pdu->ahssize) {
+		sg_set_buf(&sg[1], pdu->ahs, asize);
+		nbytes += asize;
+	}
+	EXTRACHECKS_BUG_ON((nbytes & 3) != 0);
+	return evaluate_crc32_from_sg(sg, nbytes, 0);
+}
+
+static u32 digest_data(struct iscsi_cmnd *cmd, u32 size, u32 offset,
+	uint32_t padding)
+{
+	struct scatterlist *sg = cmd->sg;
+	int idx, count;
+	struct scatterlist saved_sg;
+	u32 crc;
+
+	offset += sg[0].offset;
+	idx = offset >> PAGE_SHIFT;
+	offset &= ~PAGE_MASK;
+
+	count = get_pgcnt(size, offset);
+
+	TRACE_DBG("req %p, idx %d, count %d, sg_cnt %d, size %d, "
+		"offset %d", cmd, idx, count, cmd->sg_cnt, size, offset);
+	BUG_ON(idx + count > cmd->sg_cnt);
+
+	saved_sg = sg[idx];
+	sg[idx].offset = offset;
+	sg[idx].length -= offset - saved_sg.offset;
+
+	crc = evaluate_crc32_from_sg(sg + idx, size, padding);
+
+	sg[idx] = saved_sg;
+	return crc;
+}
+
+int digest_rx_header(struct iscsi_cmnd *cmnd)
+{
+	u32 crc;
+
+	crc = digest_header(&cmnd->pdu);
+	if (unlikely(crc != cmnd->hdigest)) {
+		PRINT_ERROR("%s", "RX header digest failed");
+		return -EIO;
+	} else
+		TRACE_DBG("RX header digest OK for cmd %p", cmnd);
+
+	return 0;
+}
+
+void digest_tx_header(struct iscsi_cmnd *cmnd)
+{
+	cmnd->hdigest = digest_header(&cmnd->pdu);
+	TRACE_DBG("TX header digest for cmd %p: %x", cmnd, cmnd->hdigest);
+}
+
+int digest_rx_data(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_cmnd *req;
+	struct iscsi_data_out_hdr *req_hdr;
+	u32 offset, crc;
+	int res = 0;
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_SCSI_DATA_OUT:
+		req = cmnd->cmd_req;
+		if (unlikely(req == NULL)) {
+			/* It can be for prelim completed commands */
+			req = cmnd;
+			goto out;
+		}
+		req_hdr = (struct iscsi_data_out_hdr *)&cmnd->pdu.bhs;
+		offset = be32_to_cpu(req_hdr->buffer_offset);
+		break;
+
+	default:
+		req = cmnd;
+		offset = 0;
+	}
+
+	/*
+	 * We need to skip the digest check for prelim completed commands,
+	 * because we use shared data buffer for them, so, most likely, the
+	 * check will fail. Plus, for such commands we sometimes don't have
+	 * sg_cnt set correctly (cmnd_prepare_get_rejected_cmd_data() doesn't
+	 * do it).
+	 */
+	if (unlikely(req->prelim_compl_flags != 0))
+		goto out;
+
+	crc = digest_data(req, cmnd->pdu.datasize, offset,
+		cmnd->conn->rpadding);
+
+	if (unlikely(crc != cmnd->ddigest)) {
+		PRINT_ERROR("%s", "RX data digest failed");
+		TRACE_MGMT_DBG("Calculated crc %x, ddigest %x, offset %d", crc,
+			cmnd->ddigest, offset);
+		iscsi_dump_pdu(&cmnd->pdu);
+		res = -EIO;
+	} else
+		TRACE_DBG("RX data digest OK for cmd %p", cmnd);
+
+out:
+	return res;
+}
+
+void digest_tx_data(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_data_in_hdr *hdr;
+	u32 offset;
+
+	TRACE_DBG("%s:%d req %p, own_sg %d, sg %p, sgcnt %d cmnd %p, "
+		"own_sg %d, sg %p, sgcnt %d", __func__, __LINE__,
+		cmnd->parent_req, cmnd->parent_req->own_sg,
+		cmnd->parent_req->sg, cmnd->parent_req->sg_cnt,
+		cmnd, cmnd->own_sg, cmnd->sg, cmnd->sg_cnt);
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_SCSI_DATA_IN:
+		hdr = (struct iscsi_data_in_hdr *)&cmnd->pdu.bhs;
+		offset = be32_to_cpu(hdr->buffer_offset);
+		break;
+	default:
+		offset = 0;
+	}
+
+	cmnd->ddigest = digest_data(cmnd, cmnd->pdu.datasize, offset, 0);
+	TRACE_DBG("TX data digest for cmd %p: %x (offset %d, opcode %x)", cmnd,
+		cmnd->ddigest, offset, cmnd_opcode(cmnd));
+}
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/event.c linux-2.6.33/drivers/scst/iscsi-scst/event.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/event.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/event.c
@@ -0,0 +1,163 @@
+/*
+ *  Event notification code.
+ *
+ *  Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ *
+ *  Some functions are based on audit code.
+ */
+
+#include <net/tcp.h>
+#include "iscsi_scst.h"
+#include "iscsi.h"
+
+static struct sock *nl;
+static u32 iscsid_pid;
+
+static int event_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	u32 uid, pid, seq;
+	char *data;
+
+	pid  = NETLINK_CREDS(skb)->pid;
+	uid  = NETLINK_CREDS(skb)->uid;
+	seq  = nlh->nlmsg_seq;
+	data = NLMSG_DATA(nlh);
+
+	iscsid_pid = pid;
+
+	return 0;
+}
+
+static void event_recv_skb(struct sk_buff *skb)
+{
+	int err;
+	struct nlmsghdr	*nlh;
+	u32 rlen;
+
+	while (skb->len >= NLMSG_SPACE(0)) {
+		nlh = (struct nlmsghdr *)skb->data;
+		if (nlh->nlmsg_len < sizeof(*nlh) || skb->len < nlh->nlmsg_len)
+			goto out;
+		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (rlen > skb->len)
+			rlen = skb->len;
+		err = event_recv_msg(skb, nlh);
+		if (err)
+			netlink_ack(skb, nlh, -err);
+		else if (nlh->nlmsg_flags & NLM_F_ACK)
+			netlink_ack(skb, nlh, 0);
+		skb_pull(skb, rlen);
+	}
+
+out:
+	return;
+}
+
+/* event_mutex supposed to be held */
+static int __event_send(const void *buf, int buf_len)
+{
+	int res = 0, len;
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	static u32 seq; /* protected by event_mutex */
+
+	if (ctr_open_state != ISCSI_CTR_OPEN_STATE_OPEN)
+		goto out;
+
+	len = NLMSG_SPACE(buf_len);
+
+	skb = alloc_skb(NLMSG_SPACE(len), GFP_KERNEL);
+	if (skb == NULL) {
+		PRINT_ERROR("alloc_skb() failed (len %d)", len);
+		res =  -ENOMEM;
+		goto out;
+	}
+
+	nlh = __nlmsg_put(skb, iscsid_pid, seq++, NLMSG_DONE,
+			  len - sizeof(*nlh), 0);
+
+	memcpy(NLMSG_DATA(nlh), buf, buf_len);
+	res = netlink_unicast(nl, skb, iscsid_pid, 0);
+	if (res <= 0) {
+		if (res != -ECONNREFUSED)
+			PRINT_ERROR("netlink_unicast() failed: %d", res);
+		else
+			TRACE(TRACE_MINOR, "netlink_unicast() failed: %s. "
+				"Not functioning user space?",
+				"Connection refused");
+		goto out;
+	}
+
+out:
+	return res;
+}
+
+int event_send(u32 tid, u64 sid, u32 cid, u32 cookie,
+	enum iscsi_kern_event_code code,
+	const char *param1, const char *param2)
+{
+	int err;
+	static DEFINE_MUTEX(event_mutex);
+	struct iscsi_kern_event event;
+	int param1_size, param2_size;
+
+	param1_size = (param1 != NULL) ? strlen(param1) : 0;
+	param2_size = (param2 != NULL) ? strlen(param2) : 0;
+
+	event.tid = tid;
+	event.sid = sid;
+	event.cid = cid;
+	event.code = code;
+	event.cookie = cookie;
+	event.param1_size = param1_size;
+	event.param2_size = param2_size;
+
+	mutex_lock(&event_mutex);
+
+	err = __event_send(&event, sizeof(event));
+	if (err <= 0)
+		goto out_unlock;
+
+	if (param1_size > 0) {
+		err = __event_send(param1, param1_size);
+		if (err <= 0)
+			goto out_unlock;
+	}
+
+	if (param2_size > 0) {
+		err = __event_send(param2, param2_size);
+		if (err <= 0)
+			goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&event_mutex);
+	return err;
+}
+
+int __init event_init(void)
+{
+	nl = netlink_kernel_create(&init_net, NETLINK_ISCSI_SCST, 1,
+				   event_recv_skb, NULL, THIS_MODULE);
+	if (!nl) {
+		PRINT_ERROR("%s", "netlink_kernel_create() failed");
+		return -ENOMEM;
+	} else
+		return 0;
+}
+
+void event_exit(void)
+{
+	netlink_kernel_release(nl);
+}
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi.c linux-2.6.33/drivers/scst/iscsi-scst/iscsi.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/iscsi.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/iscsi.c
@@ -0,0 +1,3583 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/hash.h>
+#include <linux/kthread.h>
+#include <linux/scatterlist.h>
+#include <net/tcp.h>
+#include <scsi/scsi.h>
+
+#include "iscsi.h"
+#include "digest.h"
+
+#define ISCSI_INIT_WRITE_WAKE		0x1
+
+static int ctr_major;
+static char ctr_name[] = "iscsi-scst-ctl";
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+unsigned long iscsi_trace_flag = ISCSI_DEFAULT_LOG_FLAGS;
+#endif
+
+static struct kmem_cache *iscsi_cmnd_cache;
+
+DEFINE_SPINLOCK(iscsi_rd_lock);
+LIST_HEAD(iscsi_rd_list);
+DECLARE_WAIT_QUEUE_HEAD(iscsi_rd_waitQ);
+
+DEFINE_SPINLOCK(iscsi_wr_lock);
+LIST_HEAD(iscsi_wr_list);
+DECLARE_WAIT_QUEUE_HEAD(iscsi_wr_waitQ);
+
+static struct page *dummy_page;
+static struct scatterlist dummy_sg;
+
+struct iscsi_thread_t {
+	struct task_struct *thr;
+	struct list_head threads_list_entry;
+};
+
+static LIST_HEAD(iscsi_threads_list);
+
+static void cmnd_remove_data_wait_hash(struct iscsi_cmnd *cmnd);
+static void iscsi_send_task_mgmt_resp(struct iscsi_cmnd *req, int status);
+static void iscsi_check_send_delayed_tm_resp(struct iscsi_session *sess);
+static void req_cmnd_release(struct iscsi_cmnd *req);
+static int iscsi_preliminary_complete(struct iscsi_cmnd *req,
+	struct iscsi_cmnd *orig_req, bool get_data);
+static int cmnd_insert_data_wait_hash(struct iscsi_cmnd *cmnd);
+static void __cmnd_abort(struct iscsi_cmnd *cmnd);
+static void iscsi_set_resid(struct iscsi_cmnd *rsp, bool bufflen_set);
+static void iscsi_cmnd_init_write(struct iscsi_cmnd *rsp, int flags);
+
+static void req_del_from_write_timeout_list(struct iscsi_cmnd *req)
+{
+	struct iscsi_conn *conn;
+
+	if (!req->on_write_timeout_list)
+		goto out;
+
+	conn = req->conn;
+
+	TRACE_DBG("Deleting cmd %p from conn %p write_timeout_list",
+		req, conn);
+
+	spin_lock_bh(&conn->write_list_lock);
+
+	/* Recheck, since it can be changed behind us */
+	if (unlikely(!req->on_write_timeout_list))
+		goto out_unlock;
+
+	list_del(&req->write_timeout_list_entry);
+	req->on_write_timeout_list = 0;
+
+out_unlock:
+	spin_unlock_bh(&conn->write_list_lock);
+
+out:
+	return;
+}
+
+static inline u32 cmnd_write_size(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_scsi_cmd_hdr *hdr = cmnd_hdr(cmnd);
+
+	if (hdr->flags & ISCSI_CMD_WRITE)
+		return be32_to_cpu(hdr->data_length);
+	return 0;
+}
+
+static inline int cmnd_read_size(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_scsi_cmd_hdr *hdr = cmnd_hdr(cmnd);
+
+	if (hdr->flags & ISCSI_CMD_READ) {
+		struct iscsi_ahs_hdr *ahdr;
+
+		if (!(hdr->flags & ISCSI_CMD_WRITE))
+			return be32_to_cpu(hdr->data_length);
+
+		ahdr = (struct iscsi_ahs_hdr *)cmnd->pdu.ahs;
+		if (ahdr != NULL) {
+			uint8_t *p = (uint8_t *)ahdr;
+			unsigned int size = 0;
+			do {
+				int s;
+
+				ahdr = (struct iscsi_ahs_hdr *)p;
+
+				if (ahdr->ahstype == ISCSI_AHSTYPE_RLENGTH) {
+					struct iscsi_rlength_ahdr *rh =
+					      (struct iscsi_rlength_ahdr *)ahdr;
+					return be32_to_cpu(rh->read_length);
+				}
+
+				s = 3 + be16_to_cpu(ahdr->ahslength);
+				s = (s + 3) & -4;
+				size += s;
+				p += s;
+			} while (size < cmnd->pdu.ahssize);
+		}
+		return -1;
+	}
+	return 0;
+}
+
+void iscsi_restart_cmnd(struct iscsi_cmnd *cmnd)
+{
+	int status;
+
+	EXTRACHECKS_BUG_ON(cmnd->r2t_len_to_receive != 0);
+	EXTRACHECKS_BUG_ON(cmnd->r2t_len_to_send != 0);
+
+	req_del_from_write_timeout_list(cmnd);
+
+	/*
+	 * Let's remove cmnd from the hash earlier to keep it smaller.
+	 * See also corresponding comment in req_cmnd_release().
+	 */
+	if (cmnd->hashed)
+		cmnd_remove_data_wait_hash(cmnd);
+
+	if (unlikely(test_bit(ISCSI_CONN_REINSTATING,
+			&cmnd->conn->conn_aflags))) {
+		struct iscsi_target *target = cmnd->conn->session->target;
+		bool get_out;
+
+		mutex_lock(&target->target_mutex);
+
+		get_out = test_bit(ISCSI_CONN_REINSTATING,
+				&cmnd->conn->conn_aflags);
+		/* Let's don't look dead */
+		if (scst_cmd_get_cdb(cmnd->scst_cmd)[0] == TEST_UNIT_READY)
+			get_out = false;
+
+		if (!get_out)
+			goto unlock_cont;
+
+		TRACE_MGMT_DBG("Pending cmnd %p, because conn %p is "
+			"reinstated", cmnd, cmnd->conn);
+
+		cmnd->scst_state = ISCSI_CMD_STATE_REINST_PENDING;
+		list_add_tail(&cmnd->reinst_pending_cmd_list_entry,
+			&cmnd->conn->reinst_pending_cmd_list);
+
+unlock_cont:
+		mutex_unlock(&target->target_mutex);
+
+		if (get_out)
+			goto out;
+	}
+
+	if (unlikely(cmnd->prelim_compl_flags != 0)) {
+		if (test_bit(ISCSI_CMD_ABORTED, &cmnd->prelim_compl_flags)) {
+			TRACE_MGMT_DBG("cmnd %p (scst_cmd %p) aborted", cmnd,
+				cmnd->scst_cmd);
+			req_cmnd_release_force(cmnd);
+			goto out;
+		}
+
+		if (cmnd->scst_cmd == NULL) {
+			TRACE_MGMT_DBG("Finishing preliminary completed cmd %p "
+				"with NULL scst_cmd", cmnd);
+			req_cmnd_release(cmnd);
+			goto out;
+		}
+
+		status = SCST_PREPROCESS_STATUS_ERROR_SENSE_SET;
+	} else
+		status = SCST_PREPROCESS_STATUS_SUCCESS;
+
+	cmnd->scst_state = ISCSI_CMD_STATE_RESTARTED;
+
+	scst_restart_cmd(cmnd->scst_cmd, status, SCST_CONTEXT_THREAD);
+
+out:
+	return;
+}
+
+void iscsi_fail_data_waiting_cmnd(struct iscsi_cmnd *cmnd)
+{
+
+	TRACE_MGMT_DBG("Failing data waiting cmnd %p", cmnd);
+
+	/*
+	 * There is no race with conn_abort(), since all functions
+	 * called from single read thread
+	 */
+	iscsi_extracheck_is_rd_thread(cmnd->conn);
+	cmnd->r2t_len_to_receive = 0;
+	cmnd->r2t_len_to_send = 0;
+
+	req_cmnd_release_force(cmnd);
+	return;
+}
+
+struct iscsi_cmnd *cmnd_alloc(struct iscsi_conn *conn,
+			      struct iscsi_cmnd *parent)
+{
+	struct iscsi_cmnd *cmnd;
+
+	/* ToDo: __GFP_NOFAIL?? */
+	cmnd = kmem_cache_zalloc(iscsi_cmnd_cache, GFP_KERNEL|__GFP_NOFAIL);
+
+	atomic_set(&cmnd->ref_cnt, 1);
+	cmnd->scst_state = ISCSI_CMD_STATE_NEW;
+	cmnd->conn = conn;
+	cmnd->parent_req = parent;
+
+	if (parent == NULL) {
+		conn_get(conn);
+
+		INIT_LIST_HEAD(&cmnd->rsp_cmd_list);
+		INIT_LIST_HEAD(&cmnd->rx_ddigest_cmd_list);
+		cmnd->target_task_tag = cpu_to_be32(ISCSI_RESERVED_TAG);
+
+		spin_lock_bh(&conn->cmd_list_lock);
+		list_add_tail(&cmnd->cmd_list_entry, &conn->cmd_list);
+		spin_unlock_bh(&conn->cmd_list_lock);
+	}
+
+	TRACE_DBG("conn %p, parent %p, cmnd %p", conn, parent, cmnd);
+	return cmnd;
+}
+
+/* Frees a command. Also frees the additional header. */
+static void cmnd_free(struct iscsi_cmnd *cmnd)
+{
+
+	TRACE_DBG("cmnd %p", cmnd);
+
+	if (unlikely(test_bit(ISCSI_CMD_ABORTED, &cmnd->prelim_compl_flags))) {
+		TRACE_MGMT_DBG("Free aborted cmd %p (scst cmd %p, state %d, "
+			"parent_req %p)", cmnd, cmnd->scst_cmd,
+			cmnd->scst_state, cmnd->parent_req);
+	}
+
+	/* Catch users from cmd_list or rsp_cmd_list */
+	EXTRACHECKS_BUG_ON(atomic_read(&cmnd->ref_cnt) != 0);
+
+	kfree(cmnd->pdu.ahs);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	if (unlikely(cmnd->on_write_list || cmnd->on_write_timeout_list)) {
+		struct iscsi_scsi_cmd_hdr *req = cmnd_hdr(cmnd);
+
+		PRINT_CRIT_ERROR("cmnd %p still on some list?, %x, %x, %x, "
+			"%x, %x, %x, %x", cmnd, req->opcode, req->scb[0],
+			req->flags, req->itt, be32_to_cpu(req->data_length),
+			req->cmd_sn, be32_to_cpu(cmnd->pdu.datasize));
+
+		if (unlikely(cmnd->parent_req)) {
+			struct iscsi_scsi_cmd_hdr *preq =
+					cmnd_hdr(cmnd->parent_req);
+			PRINT_CRIT_ERROR("%p %x %u", preq, preq->opcode,
+				preq->scb[0]);
+		}
+		BUG();
+	}
+#endif
+
+	kmem_cache_free(iscsi_cmnd_cache, cmnd);
+	return;
+}
+
+/* Might be called under some lock and on SIRQ */
+void cmnd_done(struct iscsi_cmnd *cmnd)
+{
+
+	TRACE_DBG("cmnd %p", cmnd);
+
+	if (unlikely(test_bit(ISCSI_CMD_ABORTED, &cmnd->prelim_compl_flags))) {
+		TRACE_MGMT_DBG("Done aborted cmd %p (scst cmd %p, state %d, "
+			"parent_req %p)", cmnd, cmnd->scst_cmd,
+			cmnd->scst_state, cmnd->parent_req);
+	}
+
+	EXTRACHECKS_BUG_ON(cmnd->on_rx_digest_list);
+	EXTRACHECKS_BUG_ON(cmnd->hashed);
+
+	req_del_from_write_timeout_list(cmnd);
+
+	if (cmnd->parent_req == NULL) {
+		struct iscsi_conn *conn = cmnd->conn;
+		struct iscsi_cmnd *rsp, *t;
+
+		TRACE_DBG("Deleting req %p from conn %p", cmnd, conn);
+
+		spin_lock_bh(&conn->cmd_list_lock);
+		list_del(&cmnd->cmd_list_entry);
+		spin_unlock_bh(&conn->cmd_list_lock);
+
+		conn_put(conn);
+
+		EXTRACHECKS_BUG_ON(!list_empty(&cmnd->rx_ddigest_cmd_list));
+
+		/* Order between above and below code is important! */
+
+		if ((cmnd->scst_cmd != NULL) || (cmnd->scst_aen != NULL)) {
+			switch (cmnd->scst_state) {
+			case ISCSI_CMD_STATE_PROCESSED:
+				TRACE_DBG("cmd %p PROCESSED", cmnd);
+				scst_tgt_cmd_done(cmnd->scst_cmd,
+					SCST_CONTEXT_DIRECT_ATOMIC);
+				break;
+
+			case ISCSI_CMD_STATE_AFTER_PREPROC:
+			{
+				/* It can be for some aborted commands */
+				struct scst_cmd *scst_cmd = cmnd->scst_cmd;
+				TRACE_DBG("cmd %p AFTER_PREPROC", cmnd);
+				cmnd->scst_state = ISCSI_CMD_STATE_RESTARTED;
+				cmnd->scst_cmd = NULL;
+				scst_restart_cmd(scst_cmd,
+					SCST_PREPROCESS_STATUS_ERROR_FATAL,
+					SCST_CONTEXT_THREAD);
+				break;
+			}
+
+			case ISCSI_CMD_STATE_AEN:
+				TRACE_DBG("cmd %p AEN PROCESSED", cmnd);
+				scst_aen_done(cmnd->scst_aen);
+				break;
+
+			case ISCSI_CMD_STATE_OUT_OF_SCST_PRELIM_COMPL:
+				break;
+
+			default:
+				PRINT_CRIT_ERROR("Unexpected cmnd scst state "
+					"%d", cmnd->scst_state);
+				BUG();
+				break;
+			}
+		}
+
+		if (cmnd->own_sg) {
+			TRACE_DBG("own_sg for req %p", cmnd);
+			if (cmnd->sg != &dummy_sg)
+				scst_free(cmnd->sg, cmnd->sg_cnt);
+#ifdef CONFIG_SCST_DEBUG
+			cmnd->own_sg = 0;
+			cmnd->sg = NULL;
+			cmnd->sg_cnt = -1;
+#endif
+		}
+
+		if (cmnd->dec_active_cmnds) {
+			struct iscsi_session *sess = cmnd->conn->session;
+			TRACE_DBG("Decrementing active_cmds (cmd %p, sess %p, "
+				"new value %d)", cmnd, sess,
+				atomic_read(&sess->active_cmds)-1);
+			atomic_dec(&sess->active_cmds);
+#ifdef CONFIG_SCST_EXTRACHECKS
+			if (unlikely(atomic_read(&sess->active_cmds) < 0)) {
+				PRINT_CRIT_ERROR("active_cmds < 0 (%d)!!",
+					atomic_read(&sess->active_cmds));
+				BUG();
+			}
+#endif
+		}
+
+		list_for_each_entry_safe(rsp, t, &cmnd->rsp_cmd_list,
+					rsp_cmd_list_entry) {
+			cmnd_free(rsp);
+		}
+
+		cmnd_free(cmnd);
+	} else {
+		if (cmnd->own_sg) {
+			TRACE_DBG("own_sg for rsp %p", cmnd);
+			if ((cmnd->sg != &dummy_sg) && (cmnd->sg != cmnd->rsp_sg))
+				scst_free(cmnd->sg, cmnd->sg_cnt);
+#ifdef CONFIG_SCST_DEBUG
+			cmnd->own_sg = 0;
+			cmnd->sg = NULL;
+			cmnd->sg_cnt = -1;
+#endif
+		}
+
+		EXTRACHECKS_BUG_ON(cmnd->dec_active_cmnds);
+
+		if (cmnd == cmnd->parent_req->main_rsp) {
+			TRACE_DBG("Finishing main rsp %p (req %p)", cmnd,
+				cmnd->parent_req);
+			cmnd->parent_req->main_rsp = NULL;
+		}
+
+		cmnd_put(cmnd->parent_req);
+		/*
+		 * rsp will be freed on the last parent's put and can already
+		 * be freed!!
+		 */
+	}
+	return;
+}
+
+/*
+ * Corresponding conn may also get destroyed after this function, except only
+ * if it's called from the read thread!
+ *
+ * It can't be called in parallel with iscsi_cmnds_init_write()!
+ */
+void req_cmnd_release_force(struct iscsi_cmnd *req)
+{
+	struct iscsi_cmnd *rsp, *t;
+	struct iscsi_conn *conn = req->conn;
+	LIST_HEAD(cmds_list);
+
+	TRACE_MGMT_DBG("req %p", req);
+
+	BUG_ON(req == conn->read_cmnd);
+
+	spin_lock_bh(&conn->write_list_lock);
+	list_for_each_entry_safe(rsp, t, &conn->write_list, write_list_entry) {
+		if (rsp->parent_req != req)
+			continue;
+
+		cmd_del_from_write_list(rsp);
+
+		list_add_tail(&rsp->write_list_entry, &cmds_list);
+	}
+	spin_unlock_bh(&conn->write_list_lock);
+
+	list_for_each_entry_safe(rsp, t, &cmds_list, write_list_entry) {
+		TRACE_MGMT_DBG("Putting write rsp %p", rsp);
+		list_del(&rsp->write_list_entry);
+		cmnd_put(rsp);
+	}
+
+	/* Supposed nobody can add responses in the list anymore */
+	list_for_each_entry_reverse(rsp, &req->rsp_cmd_list,
+			rsp_cmd_list_entry) {
+		bool r;
+
+		if (rsp->force_cleanup_done)
+			continue;
+
+		rsp->force_cleanup_done = 1;
+
+		if (cmnd_get_check(rsp))
+			continue;
+
+		spin_lock_bh(&conn->write_list_lock);
+		r = rsp->on_write_list || rsp->write_processing_started;
+		spin_unlock_bh(&conn->write_list_lock);
+
+		cmnd_put(rsp);
+
+		if (r)
+			continue;
+
+		/*
+		 * If both on_write_list and write_processing_started not set,
+		 * we can safely put() rsp.
+		 */
+		TRACE_MGMT_DBG("Putting rsp %p", rsp);
+		cmnd_put(rsp);
+	}
+
+	if (req->main_rsp != NULL) {
+		TRACE_MGMT_DBG("Putting main rsp %p", req->main_rsp);
+		cmnd_put(req->main_rsp);
+		req->main_rsp = NULL;
+	}
+
+	req_cmnd_release(req);
+	return;
+}
+
+/*
+ * Corresponding conn may also get destroyed after this function, except only
+ * if it's called from the read thread!
+ */
+static void req_cmnd_release(struct iscsi_cmnd *req)
+{
+	struct iscsi_cmnd *c, *t;
+
+	TRACE_DBG("req %p", req);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	BUG_ON(req->release_called);
+	req->release_called = 1;
+#endif
+
+	if (unlikely(test_bit(ISCSI_CMD_ABORTED, &req->prelim_compl_flags))) {
+		TRACE_MGMT_DBG("Release aborted req cmd %p (scst cmd %p, "
+			"state %d)", req, req->scst_cmd, req->scst_state);
+	}
+
+	BUG_ON(req->parent_req != NULL);
+
+	/*
+	 * We have to remove hashed req from the hash list before sending
+	 * response. Otherwise we can have a race, when for some reason cmd's
+	 * release (and, hence, removal from the hash) is delayed after the
+	 * transmission and initiator sends cmd with the same ITT, hence
+	 * the new command will be erroneously rejected as a duplicate.
+	 */
+	if (unlikely(req->hashed)) {
+		/* It sometimes can happen during errors recovery */
+		cmnd_remove_data_wait_hash(req);
+	}
+
+	if (unlikely(req->main_rsp != NULL)) {
+		TRACE_DBG("Sending main rsp %p", req->main_rsp);
+		iscsi_cmnd_init_write(req->main_rsp, ISCSI_INIT_WRITE_WAKE);
+		req->main_rsp = NULL;
+	}
+
+	list_for_each_entry_safe(c, t, &req->rx_ddigest_cmd_list,
+				rx_ddigest_cmd_list_entry) {
+		cmd_del_from_rx_ddigest_list(c);
+		cmnd_put(c);
+	}
+
+	EXTRACHECKS_BUG_ON(req->pending);
+
+	if (req->dec_active_cmnds) {
+		struct iscsi_session *sess = req->conn->session;
+		TRACE_DBG("Decrementing active_cmds (cmd %p, sess %p, "
+			"new value %d)", req, sess,
+			atomic_read(&sess->active_cmds)-1);
+		atomic_dec(&sess->active_cmds);
+		req->dec_active_cmnds = 0;
+#ifdef CONFIG_SCST_EXTRACHECKS
+		if (unlikely(atomic_read(&sess->active_cmds) < 0)) {
+			PRINT_CRIT_ERROR("active_cmds < 0 (%d)!!",
+				atomic_read(&sess->active_cmds));
+			BUG();
+		}
+#endif
+	}
+
+	cmnd_put(req);
+	return;
+}
+
+/*
+ * Corresponding conn may also get destroyed after this function, except only
+ * if it's called from the read thread!
+ */
+void rsp_cmnd_release(struct iscsi_cmnd *cmnd)
+{
+	TRACE_DBG("%p", cmnd);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	BUG_ON(cmnd->release_called);
+	cmnd->release_called = 1;
+#endif
+
+	EXTRACHECKS_BUG_ON(cmnd->parent_req == NULL);
+
+	cmnd_put(cmnd);
+	return;
+}
+
+static struct iscsi_cmnd *iscsi_alloc_rsp(struct iscsi_cmnd *parent)
+{
+	struct iscsi_cmnd *rsp;
+
+	rsp = cmnd_alloc(parent->conn, parent);
+
+	TRACE_DBG("Adding rsp %p to parent %p", rsp, parent);
+	list_add_tail(&rsp->rsp_cmd_list_entry, &parent->rsp_cmd_list);
+
+	cmnd_get(parent);
+	return rsp;
+}
+
+static inline struct iscsi_cmnd *iscsi_alloc_main_rsp(struct iscsi_cmnd *parent)
+{
+	struct iscsi_cmnd *rsp;
+
+	EXTRACHECKS_BUG_ON(parent->main_rsp != NULL);
+
+	rsp = iscsi_alloc_rsp(parent);
+	parent->main_rsp = rsp;
+	return rsp;
+}
+
+static void iscsi_cmnds_init_write(struct list_head *send, int flags)
+{
+	struct iscsi_cmnd *rsp = list_entry(send->next, struct iscsi_cmnd,
+						write_list_entry);
+	struct iscsi_conn *conn = rsp->conn;
+	struct list_head *pos, *next;
+
+	BUG_ON(list_empty(send));
+
+	if (!(conn->ddigest_type & DIGEST_NONE)) {
+		list_for_each(pos, send) {
+			rsp = list_entry(pos, struct iscsi_cmnd,
+						write_list_entry);
+
+			if (rsp->pdu.datasize != 0) {
+				TRACE_DBG("Doing data digest (%p:%x)", rsp,
+					cmnd_opcode(rsp));
+				digest_tx_data(rsp);
+			}
+		}
+	}
+
+	spin_lock_bh(&conn->write_list_lock);
+	list_for_each_safe(pos, next, send) {
+		rsp = list_entry(pos, struct iscsi_cmnd, write_list_entry);
+
+		TRACE_DBG("%p:%x", rsp, cmnd_opcode(rsp));
+
+		BUG_ON(conn != rsp->conn);
+
+		list_del(&rsp->write_list_entry);
+		cmd_add_on_write_list(conn, rsp);
+	}
+	spin_unlock_bh(&conn->write_list_lock);
+
+	if (flags & ISCSI_INIT_WRITE_WAKE)
+		iscsi_make_conn_wr_active(conn);
+
+	return;
+}
+
+static void iscsi_cmnd_init_write(struct iscsi_cmnd *rsp, int flags)
+{
+	LIST_HEAD(head);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	if (unlikely(rsp->on_write_list)) {
+		PRINT_CRIT_ERROR("cmd already on write list (%x %x %x "
+			"%u %u %d %d", cmnd_itt(rsp),
+			cmnd_opcode(rsp), cmnd_scsicode(rsp),
+			rsp->hdigest, rsp->ddigest,
+			list_empty(&rsp->rsp_cmd_list), rsp->hashed);
+		BUG();
+	}
+#endif
+	list_add_tail(&rsp->write_list_entry, &head);
+	iscsi_cmnds_init_write(&head, flags);
+	return;
+}
+
+static void send_data_rsp(struct iscsi_cmnd *req, u8 status, int send_status)
+{
+	struct iscsi_cmnd *rsp;
+	struct iscsi_scsi_cmd_hdr *req_hdr = cmnd_hdr(req);
+	struct iscsi_data_in_hdr *rsp_hdr;
+	u32 pdusize, expsize, size, offset, sn;
+	LIST_HEAD(send);
+
+	TRACE_DBG("req %p", req);
+
+	pdusize = req->conn->session->sess_params.max_xmit_data_length;
+	expsize = req->read_size;
+	size = min(expsize, (u32)req->bufflen);
+	offset = 0;
+	sn = 0;
+
+	while (1) {
+		rsp = iscsi_alloc_rsp(req);
+		TRACE_DBG("rsp %p", rsp);
+		rsp->sg = req->sg;
+		rsp->sg_cnt = req->sg_cnt;
+		rsp->bufflen = req->bufflen;
+		rsp_hdr = (struct iscsi_data_in_hdr *)&rsp->pdu.bhs;
+
+		rsp_hdr->opcode = ISCSI_OP_SCSI_DATA_IN;
+		rsp_hdr->itt = req_hdr->itt;
+		rsp_hdr->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
+		rsp_hdr->buffer_offset = cpu_to_be32(offset);
+		rsp_hdr->data_sn = cpu_to_be32(sn);
+
+		if (size <= pdusize) {
+			TRACE_DBG("offset %d, size %d", offset, size);
+			rsp->pdu.datasize = size;
+			if (send_status) {
+				unsigned int scsisize;
+
+				TRACE_DBG("status %x", status);
+
+				EXTRACHECKS_BUG_ON((cmnd_hdr(req)->flags & ISCSI_CMD_WRITE) != 0);
+
+				rsp_hdr->flags = ISCSI_FLG_FINAL | ISCSI_FLG_STATUS;
+				rsp_hdr->cmd_status = status;
+
+				scsisize = req->bufflen;
+				if (scsisize < expsize) {
+					rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_UNDERFLOW;
+					size = expsize - scsisize;
+				} else if (scsisize > expsize) {
+					rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_OVERFLOW;
+					size = scsisize - expsize;
+				} else
+					size = 0;
+				rsp_hdr->residual_count = cpu_to_be32(size);
+			}
+			list_add_tail(&rsp->write_list_entry, &send);
+			break;
+		}
+
+		TRACE_DBG("pdusize %d, offset %d, size %d", pdusize, offset,
+			size);
+
+		rsp->pdu.datasize = pdusize;
+
+		size -= pdusize;
+		offset += pdusize;
+		sn++;
+
+		list_add_tail(&rsp->write_list_entry, &send);
+	}
+	iscsi_cmnds_init_write(&send, 0);
+	return;
+}
+
+static void iscsi_init_status_rsp(struct iscsi_cmnd *rsp,
+	int status, const u8 *sense_buf, int sense_len, bool bufflen_set)
+{
+	struct iscsi_cmnd *req = rsp->parent_req;
+	struct iscsi_scsi_rsp_hdr *rsp_hdr;
+	struct scatterlist *sg;
+
+	rsp_hdr = (struct iscsi_scsi_rsp_hdr *)&rsp->pdu.bhs;
+	rsp_hdr->opcode = ISCSI_OP_SCSI_RSP;
+	rsp_hdr->flags = ISCSI_FLG_FINAL;
+	rsp_hdr->response = ISCSI_RESPONSE_COMMAND_COMPLETED;
+	rsp_hdr->cmd_status = status;
+	rsp_hdr->itt = cmnd_hdr(req)->itt;
+
+	if (SCST_SENSE_VALID(sense_buf)) {
+		TRACE_DBG("%s", "SENSE VALID");
+
+		sg = rsp->sg = rsp->rsp_sg;
+		rsp->sg_cnt = 2;
+		rsp->own_sg = 1;
+
+		sg_init_table(sg, 2);
+		sg_set_buf(&sg[0], &rsp->sense_hdr, sizeof(rsp->sense_hdr));
+		sg_set_buf(&sg[1], sense_buf, sense_len);
+
+		rsp->sense_hdr.length = cpu_to_be16(sense_len);
+
+		rsp->pdu.datasize = sizeof(rsp->sense_hdr) + sense_len;
+		rsp->bufflen = rsp->pdu.datasize;
+	} else {
+		rsp->pdu.datasize = 0;
+		rsp->bufflen = 0;
+	}
+
+	iscsi_set_resid(rsp, bufflen_set);
+	return;
+}
+
+static inline struct iscsi_cmnd *create_status_rsp(struct iscsi_cmnd *req,
+	int status, const u8 *sense_buf, int sense_len, bool bufflen_set)
+{
+	struct iscsi_cmnd *rsp;
+
+	rsp = iscsi_alloc_rsp(req);
+	TRACE_DBG("rsp %p", rsp);
+
+	iscsi_init_status_rsp(rsp, status, sense_buf, sense_len, bufflen_set);
+	return rsp;
+}
+
+static struct iscsi_cmnd *create_prelim_status_rsp(struct iscsi_cmnd *req,
+	int status, const u8 *sense_buf, int sense_len)
+{
+	struct iscsi_cmnd *rsp;
+
+	rsp = iscsi_alloc_main_rsp(req);
+	TRACE_DBG("main rsp %p", rsp);
+
+	iscsi_init_status_rsp(rsp, status, sense_buf, sense_len, false);
+	return rsp;
+}
+
+static int iscsi_set_prelim_r2t_len_to_receive(struct iscsi_cmnd *req)
+{
+	struct iscsi_hdr *req_hdr = &req->pdu.bhs;
+	int res = 0;
+
+	if (req_hdr->flags & ISCSI_CMD_FINAL)
+		goto out;
+
+	res = cmnd_insert_data_wait_hash(req);
+	if (res != 0) {
+		/*
+		 * We have to close connection, because otherwise a data
+		 * corruption is possible if we allow to receive data
+		 * for this request in another request with dublicated ITT.
+		 */
+		mark_conn_closed(req->conn);
+		goto out;
+	}
+
+	/*
+	 * We need to wait for one or more PDUs. Let's simplify
+	 * other code and pretend we need to receive 1 byte.
+	 * In data_out_start() we will correct it.
+	 */
+	if (req->outstanding_r2t == 0) {
+		req->outstanding_r2t = 1;
+		req_add_to_write_timeout_list(req);
+	}
+	req->r2t_len_to_receive = 1;
+	req->r2t_len_to_send = 0;
+
+	TRACE_DBG("req %p, op %x, outstanding_r2t %d, r2t_len_to_receive %d, "
+		"r2t_len_to_send %d", req, cmnd_opcode(req),
+		req->outstanding_r2t, req->r2t_len_to_receive,
+		req->r2t_len_to_send);
+
+out:
+	return res;
+}
+
+static int create_preliminary_status_rsp(struct iscsi_cmnd *req,
+	int status, const u8 *sense_buf, int sense_len)
+{
+	int res = 0;
+	struct iscsi_scsi_cmd_hdr *req_hdr = cmnd_hdr(req);
+
+	if (req->prelim_compl_flags != 0) {
+		TRACE_MGMT_DBG("req %p already prelim completed", req);
+		goto out;
+	}
+
+	req->scst_state = ISCSI_CMD_STATE_OUT_OF_SCST_PRELIM_COMPL;
+
+	if ((req_hdr->flags & ISCSI_CMD_READ) &&
+	    (req_hdr->flags & ISCSI_CMD_WRITE)) {
+		int sz = cmnd_read_size(req);
+		if (sz > 0)
+			req->read_size = sz;
+	} else if (req_hdr->flags & ISCSI_CMD_READ)
+		req->read_size = be32_to_cpu(req_hdr->data_length);
+
+	create_prelim_status_rsp(req, status, sense_buf, sense_len);
+	res = iscsi_preliminary_complete(req, req, true);
+
+out:
+	return res;
+}
+
+static int set_scst_preliminary_status_rsp(struct iscsi_cmnd *req,
+	bool get_data, int key, int asc, int ascq)
+{
+	int res = 0;
+
+	if (req->scst_cmd == NULL) {
+		/* There must be already error set */
+		goto complete;
+	}
+
+	scst_set_cmd_error(req->scst_cmd, key, asc, ascq);
+
+complete:
+	res = iscsi_preliminary_complete(req, req, get_data);
+	return res;
+}
+
+static int create_reject_rsp(struct iscsi_cmnd *req, int reason, bool get_data)
+{
+	int res = 0;
+	struct iscsi_cmnd *rsp;
+	struct iscsi_reject_hdr *rsp_hdr;
+	struct scatterlist *sg;
+
+	TRACE_MGMT_DBG("Reject: req %p, reason %x", req, reason);
+
+	if (cmnd_opcode(req) == ISCSI_OP_SCSI_CMD) {
+		if (req->scst_cmd == NULL) {
+			/* BUSY status must be already set */
+			struct iscsi_scsi_rsp_hdr *rsp_hdr;
+			rsp_hdr = (struct iscsi_scsi_rsp_hdr *)&req->main_rsp->pdu.bhs;
+			BUG_ON(rsp_hdr->cmd_status == 0);
+			/*
+			 * Let's not send REJECT here. The initiator will retry
+			 * and, hopefully, next time we will not fail allocating
+			 * scst_cmd, so we will then send the REJECT.
+			 */
+			goto out;
+		} else
+			set_scst_preliminary_status_rsp(req, get_data,
+				SCST_LOAD_SENSE(scst_sense_invalid_message));
+	}
+
+	rsp = iscsi_alloc_main_rsp(req);
+	rsp_hdr = (struct iscsi_reject_hdr *)&rsp->pdu.bhs;
+
+	rsp_hdr->opcode = ISCSI_OP_REJECT;
+	rsp_hdr->ffffffff = ISCSI_RESERVED_TAG;
+	rsp_hdr->reason = reason;
+
+	sg = rsp->sg = rsp->rsp_sg;
+	rsp->sg_cnt = 1;
+	rsp->own_sg = 1;
+	sg_init_one(sg, &req->pdu.bhs, sizeof(struct iscsi_hdr));
+	rsp->bufflen = rsp->pdu.datasize = sizeof(struct iscsi_hdr);
+
+	res = iscsi_preliminary_complete(req, req, true);
+
+out:
+	return res;
+}
+
+static inline int iscsi_get_allowed_cmds(struct iscsi_session *sess)
+{
+	int res = max(-1, (int)sess->tgt_params.queued_cmnds -
+				atomic_read(&sess->active_cmds)-1);
+	TRACE_DBG("allowed cmds %d (sess %p, active_cmds %d)", res,
+		sess, atomic_read(&sess->active_cmds));
+	return res;
+}
+
+static u32 cmnd_set_sn(struct iscsi_cmnd *cmnd, int set_stat_sn)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct iscsi_session *sess = conn->session;
+	u32 res;
+
+	spin_lock(&sess->sn_lock);
+
+	if (set_stat_sn)
+		cmnd->pdu.bhs.sn = cpu_to_be32(conn->stat_sn++);
+	cmnd->pdu.bhs.exp_sn = cpu_to_be32(sess->exp_cmd_sn);
+	cmnd->pdu.bhs.max_sn = cpu_to_be32(sess->exp_cmd_sn +
+				 iscsi_get_allowed_cmds(sess));
+
+	res = cpu_to_be32(conn->stat_sn);
+
+	spin_unlock(&sess->sn_lock);
+	return res;
+}
+
+/* Called under sn_lock */
+static void __update_stat_sn(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	u32 exp_stat_sn;
+
+	cmnd->pdu.bhs.exp_sn = exp_stat_sn = be32_to_cpu(cmnd->pdu.bhs.exp_sn);
+	TRACE_DBG("%x,%x", cmnd_opcode(cmnd), exp_stat_sn);
+	if ((int)(exp_stat_sn - conn->exp_stat_sn) > 0 &&
+	    (int)(exp_stat_sn - conn->stat_sn) <= 0) {
+		/* free pdu resources */
+		cmnd->conn->exp_stat_sn = exp_stat_sn;
+	}
+	return;
+}
+
+static inline void update_stat_sn(struct iscsi_cmnd *cmnd)
+{
+	spin_lock(&cmnd->conn->session->sn_lock);
+	__update_stat_sn(cmnd);
+	spin_unlock(&cmnd->conn->session->sn_lock);
+	return;
+}
+
+/* Called under sn_lock */
+static int check_cmd_sn(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_session *session = cmnd->conn->session;
+	u32 cmd_sn;
+
+	cmnd->pdu.bhs.sn = cmd_sn = be32_to_cpu(cmnd->pdu.bhs.sn);
+	TRACE_DBG("%d(%d)", cmd_sn, session->exp_cmd_sn);
+	if (likely((s32)(cmd_sn - session->exp_cmd_sn) >= 0))
+		return 0;
+	PRINT_ERROR("sequence error (%x,%x)", cmd_sn, session->exp_cmd_sn);
+	return -ISCSI_REASON_PROTOCOL_ERROR;
+}
+
+static struct iscsi_cmnd *cmnd_find_itt_get(struct iscsi_conn *conn, u32 itt)
+{
+	struct iscsi_cmnd *cmnd, *found_cmnd = NULL;
+
+	spin_lock_bh(&conn->cmd_list_lock);
+	list_for_each_entry(cmnd, &conn->cmd_list, cmd_list_entry) {
+		if ((cmnd->pdu.bhs.itt == itt) && !cmnd_get_check(cmnd)) {
+			found_cmnd = cmnd;
+			break;
+		}
+	}
+	spin_unlock_bh(&conn->cmd_list_lock);
+
+	return found_cmnd;
+}
+
+/**
+ ** We use the ITT hash only to find original request PDU for subsequent
+ ** Data-Out PDUs.
+ **/
+
+/* Must be called under cmnd_data_wait_hash_lock */
+static struct iscsi_cmnd *__cmnd_find_data_wait_hash(struct iscsi_conn *conn,
+	u32 itt)
+{
+	struct list_head *head;
+	struct iscsi_cmnd *cmnd;
+
+	head = &conn->session->cmnd_data_wait_hash[cmnd_hashfn(itt)];
+
+	list_for_each_entry(cmnd, head, hash_list_entry) {
+		if (cmnd->pdu.bhs.itt == itt)
+			return cmnd;
+	}
+	return NULL;
+}
+
+static struct iscsi_cmnd *cmnd_find_data_wait_hash(struct iscsi_conn *conn,
+	u32 itt)
+{
+	struct iscsi_cmnd *res;
+	struct iscsi_session *session = conn->session;
+
+	spin_lock(&session->cmnd_data_wait_hash_lock);
+	res = __cmnd_find_data_wait_hash(conn, itt);
+	spin_unlock(&session->cmnd_data_wait_hash_lock);
+
+	return res;
+}
+
+static inline u32 get_next_ttt(struct iscsi_conn *conn)
+{
+	u32 ttt;
+	struct iscsi_session *session = conn->session;
+
+	/* Not compatible with MC/S! */
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	if (unlikely(session->next_ttt == ISCSI_RESERVED_TAG))
+		session->next_ttt++;
+	ttt = session->next_ttt++;
+
+	return ttt;
+}
+
+static int cmnd_insert_data_wait_hash(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_session *session = cmnd->conn->session;
+	struct iscsi_cmnd *tmp;
+	struct list_head *head;
+	int err = 0;
+	u32 itt = cmnd->pdu.bhs.itt;
+
+	if (unlikely(cmnd->hashed)) {
+		/* It can be for preliminary completed commands */
+		goto out;
+	}
+
+	/*
+	 * We don't need TTT, because ITT/buffer_offset pair is sufficient
+	 * to find out the original request and buffer for Data-Out PDUs, but
+	 * crazy iSCSI spec requires us to send this superfluous field in
+	 * R2T PDUs and some initiators may rely on it.
+	 */
+	cmnd->target_task_tag = get_next_ttt(cmnd->conn);
+
+	TRACE_DBG("%p:%x", cmnd, itt);
+	if (unlikely(itt == ISCSI_RESERVED_TAG)) {
+		PRINT_ERROR("%s", "ITT is RESERVED_TAG");
+		PRINT_BUFFER("Incorrect BHS", &cmnd->pdu.bhs,
+			sizeof(cmnd->pdu.bhs));
+		err = -ISCSI_REASON_PROTOCOL_ERROR;
+		goto out;
+	}
+
+	spin_lock(&session->cmnd_data_wait_hash_lock);
+
+	head = &session->cmnd_data_wait_hash[cmnd_hashfn(itt)];
+
+	tmp = __cmnd_find_data_wait_hash(cmnd->conn, itt);
+	if (likely(!tmp)) {
+		TRACE_DBG("Adding cmnd %p to the hash (ITT %x)", cmnd,
+			cmnd_itt(cmnd));
+		list_add_tail(&cmnd->hash_list_entry, head);
+		cmnd->hashed = 1;
+	} else {
+		PRINT_ERROR("Task %x in progress, cmnd %p", itt, cmnd);
+		err = -ISCSI_REASON_TASK_IN_PROGRESS;
+	}
+
+	spin_unlock(&session->cmnd_data_wait_hash_lock);
+
+out:
+	return err;
+}
+
+static void cmnd_remove_data_wait_hash(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_session *session = cmnd->conn->session;
+	struct iscsi_cmnd *tmp;
+
+	spin_lock(&session->cmnd_data_wait_hash_lock);
+
+	tmp = __cmnd_find_data_wait_hash(cmnd->conn, cmnd->pdu.bhs.itt);
+
+	if (likely(tmp && tmp == cmnd)) {
+		TRACE_DBG("Deleting cmnd %p from the hash (ITT %x)", cmnd,
+			cmnd_itt(cmnd));
+		list_del(&cmnd->hash_list_entry);
+		cmnd->hashed = 0;
+	} else
+		PRINT_ERROR("%p:%x not found", cmnd, cmnd_itt(cmnd));
+
+	spin_unlock(&session->cmnd_data_wait_hash_lock);
+
+	return;
+}
+
+static void cmnd_prepare_get_rejected_immed_data(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct scatterlist *sg = cmnd->sg;
+	char __user *addr;
+	u32 size;
+	unsigned int i;
+
+	TRACE_DBG_FLAG(iscsi_get_flow_ctrl_or_mgmt_dbg_log_flag(cmnd),
+		"Skipping (cmnd %p, ITT %x, op %x, cmd op %x, "
+		"datasize %u, scst_cmd %p, scst state %d)", cmnd,
+		cmnd_itt(cmnd), cmnd_opcode(cmnd), cmnd_hdr(cmnd)->scb[0],
+		cmnd->pdu.datasize, cmnd->scst_cmd, cmnd->scst_state);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	size = cmnd->pdu.datasize;
+	if (!size)
+		goto out;
+
+	/* We already checked pdu.datasize in check_segment_length() */
+
+	if (sg == NULL) {
+		/*
+		 * There are no problems with the safety from concurrent
+		 * accesses to dummy_page in dummy_sg, since data only
+		 * will be read and then discarded.
+		 */
+		sg = cmnd->sg = &dummy_sg;
+		cmnd->bufflen = PAGE_SIZE;
+		cmnd->own_sg = 1;
+	}
+
+	addr = (char __force __user *)(page_address(sg_page(&sg[0])));
+	BUG_ON(addr == NULL);
+	conn->read_size = size;
+	for (i = 0; size > PAGE_SIZE; i++, size -= cmnd->bufflen) {
+		/* We already checked pdu.datasize in check_segment_length() */
+		BUG_ON(i >= ISCSI_CONN_IOV_MAX);
+		conn->read_iov[i].iov_base = addr;
+		conn->read_iov[i].iov_len = cmnd->bufflen;
+	}
+	conn->read_iov[i].iov_base = addr;
+	conn->read_iov[i].iov_len = size;
+	conn->read_msg.msg_iov = conn->read_iov;
+	conn->read_msg.msg_iovlen = ++i;
+
+out:
+	return;
+}
+
+static void iscsi_set_resid(struct iscsi_cmnd *rsp, bool bufflen_set)
+{
+	struct iscsi_cmnd *req = rsp->parent_req;
+	struct iscsi_scsi_cmd_hdr *req_hdr = cmnd_hdr(req);
+	struct iscsi_scsi_rsp_hdr *rsp_hdr;
+	int resid, resp_len, in_resp_len;
+
+	if ((req_hdr->flags & ISCSI_CMD_READ) &&
+	    (req_hdr->flags & ISCSI_CMD_WRITE)) {
+		rsp_hdr = (struct iscsi_scsi_rsp_hdr *)&rsp->pdu.bhs;
+
+		if (bufflen_set) {
+			resp_len = req->bufflen;
+			if (req->scst_cmd != NULL)
+				in_resp_len = scst_cmd_get_in_bufflen(req->scst_cmd);
+			else
+				in_resp_len = 0;
+		} else {
+			resp_len = 0;
+			in_resp_len = 0;
+		}
+
+		resid = be32_to_cpu(req_hdr->data_length) - in_resp_len;
+		if (resid > 0) {
+			rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_UNDERFLOW;
+			rsp_hdr->residual_count = cpu_to_be32(resid);
+		} else if (resid < 0) {
+			resid = -resid;
+			rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_OVERFLOW;
+			rsp_hdr->residual_count = cpu_to_be32(resid);
+		}
+
+		resid = req->read_size - resp_len;
+		if (resid > 0) {
+			rsp_hdr->flags |= ISCSI_FLG_BIRESIDUAL_UNDERFLOW;
+			rsp_hdr->bi_residual_count = cpu_to_be32(resid);
+		} else if (resid < 0) {
+			resid = -resid;
+			rsp_hdr->flags |= ISCSI_FLG_BIRESIDUAL_OVERFLOW;
+			rsp_hdr->bi_residual_count = cpu_to_be32(resid);
+		}
+	} else {
+		if (bufflen_set)
+			resp_len = req->bufflen;
+		else
+			resp_len = 0;
+
+		resid = req->read_size - resp_len;
+		if (resid > 0) {
+			rsp_hdr = (struct iscsi_scsi_rsp_hdr *)&rsp->pdu.bhs;
+			rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_UNDERFLOW;
+			rsp_hdr->residual_count = cpu_to_be32(resid);
+		} else if (resid < 0) {
+			rsp_hdr = (struct iscsi_scsi_rsp_hdr *)&rsp->pdu.bhs;
+			resid = -resid;
+			rsp_hdr->flags |= ISCSI_FLG_RESIDUAL_OVERFLOW;
+			rsp_hdr->residual_count = cpu_to_be32(resid);
+		}
+	}
+	return;
+}
+
+static int iscsi_preliminary_complete(struct iscsi_cmnd *req,
+	struct iscsi_cmnd *orig_req, bool get_data)
+{
+	int res = 0;
+	bool set_r2t_len;
+
+#ifdef CONFIG_SCST_DEBUG
+	{
+		struct iscsi_hdr *req_hdr = &req->pdu.bhs;
+		TRACE_DBG_FLAG(iscsi_get_flow_ctrl_or_mgmt_dbg_log_flag(orig_req),
+			"Prelim completed req %p, orig_req %p (FINAL %x, "
+			"outstanding_r2t %d)", req, orig_req,
+			(req_hdr->flags & ISCSI_CMD_FINAL),
+			orig_req->outstanding_r2t);
+	}
+#endif
+
+	iscsi_extracheck_is_rd_thread(req->conn);
+	BUG_ON(req->parent_req != NULL);
+
+	if (test_bit(ISCSI_CMD_PRELIM_COMPLETED, &req->prelim_compl_flags)) {
+		TRACE_MGMT_DBG("req %p already prelim completed", req);
+		/* To not try to get data twice */
+		get_data = false;
+	}
+
+	set_r2t_len = !req->hashed &&
+		      (cmnd_opcode(req) == ISCSI_OP_SCSI_CMD) &&
+		      !test_bit(ISCSI_CMD_PRELIM_COMPLETED,
+				&orig_req->prelim_compl_flags);
+	set_bit(ISCSI_CMD_PRELIM_COMPLETED, &orig_req->prelim_compl_flags);
+
+	TRACE_DBG("get_data %d, set_r2t_len %d", get_data, set_r2t_len);
+
+	if (get_data)
+		cmnd_prepare_get_rejected_immed_data(req);
+
+	if (set_r2t_len)
+		res = iscsi_set_prelim_r2t_len_to_receive(orig_req);
+	return res;
+}
+
+static int cmnd_prepare_recv_pdu(struct iscsi_conn *conn,
+	struct iscsi_cmnd *cmd,	u32 offset, u32 size)
+{
+	struct scatterlist *sg = cmd->sg;
+	unsigned int bufflen = cmd->bufflen;
+	unsigned int idx, i;
+	char __user *addr;
+	int res = 0;
+
+	TRACE_DBG("%p %u,%u", cmd->sg, offset, size);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	if (unlikely((offset >= bufflen) ||
+		     (offset + size > bufflen))) {
+		PRINT_ERROR("Wrong ltn (%u %u %u)", offset, size, bufflen);
+		mark_conn_closed(conn);
+		res = -EIO;
+		goto out;
+	}
+
+	offset += sg[0].offset;
+	idx = offset >> PAGE_SHIFT;
+	offset &= ~PAGE_MASK;
+
+	conn->read_msg.msg_iov = conn->read_iov;
+	conn->read_size = size;
+
+	i = 0;
+	while (1) {
+		addr = (char __force __user *)(page_address(sg_page(&sg[idx])));
+		BUG_ON(addr == NULL);
+		conn->read_iov[i].iov_base = addr + offset;
+		if (offset + size <= PAGE_SIZE) {
+			TRACE_DBG("idx=%d, offset=%u, size=%d, addr=%p",
+				idx, offset, size, addr);
+			conn->read_iov[i].iov_len = size;
+			conn->read_msg.msg_iovlen = ++i;
+			break;
+		}
+		conn->read_iov[i].iov_len = PAGE_SIZE - offset;
+		TRACE_DBG("idx=%d, offset=%u, size=%d, iov_len=%zd, addr=%p",
+			idx, offset, size, conn->read_iov[i].iov_len, addr);
+		size -= conn->read_iov[i].iov_len;
+		if (unlikely(++i >= ISCSI_CONN_IOV_MAX)) {
+			PRINT_ERROR("Initiator %s violated negotiated "
+				"parameters by sending too much data (size "
+				"left %d)", conn->session->initiator_name,
+				size);
+			mark_conn_closed(conn);
+			res = -EINVAL;
+			break;
+		}
+		idx++;
+		offset = sg[idx].offset;
+	}
+	TRACE_DBG("msg_iov=%p, msg_iovlen=%zd",
+		conn->read_msg.msg_iov, conn->read_msg.msg_iovlen);
+
+out:
+	return res;
+}
+
+static void send_r2t(struct iscsi_cmnd *req)
+{
+	struct iscsi_session *sess = req->conn->session;
+	struct iscsi_cmnd *rsp;
+	struct iscsi_r2t_hdr *rsp_hdr;
+	u32 offset, burst;
+	LIST_HEAD(send);
+
+	EXTRACHECKS_BUG_ON(req->r2t_len_to_send == 0);
+
+	/*
+	 * There is no race with data_out_start() and conn_abort(), since
+	 * all functions called from single read thread
+	 */
+	iscsi_extracheck_is_rd_thread(req->conn);
+
+	/*
+	 * We don't need to check for PRELIM_COMPLETED here, because for such
+	 * commands we set r2t_len_to_send = 0, hence made sure we won't
+	 * called here.
+	 */
+
+	EXTRACHECKS_BUG_ON(req->outstanding_r2t >
+			   sess->sess_params.max_outstanding_r2t);
+
+	if (req->outstanding_r2t == sess->sess_params.max_outstanding_r2t)
+		goto out;
+
+	burst = sess->sess_params.max_burst_length;
+	offset = be32_to_cpu(cmnd_hdr(req)->data_length) -
+			req->r2t_len_to_send;
+
+	do {
+		rsp = iscsi_alloc_rsp(req);
+		rsp->pdu.bhs.ttt = req->target_task_tag;
+		rsp_hdr = (struct iscsi_r2t_hdr *)&rsp->pdu.bhs;
+		rsp_hdr->opcode = ISCSI_OP_R2T;
+		rsp_hdr->flags = ISCSI_FLG_FINAL;
+		rsp_hdr->lun = cmnd_hdr(req)->lun;
+		rsp_hdr->itt = cmnd_hdr(req)->itt;
+		rsp_hdr->r2t_sn = cpu_to_be32(req->r2t_sn++);
+		rsp_hdr->buffer_offset = cpu_to_be32(offset);
+		if (req->r2t_len_to_send > burst) {
+			rsp_hdr->data_length = cpu_to_be32(burst);
+			req->r2t_len_to_send -= burst;
+			offset += burst;
+		} else {
+			rsp_hdr->data_length = cpu_to_be32(req->r2t_len_to_send);
+			req->r2t_len_to_send = 0;
+		}
+
+		TRACE_WRITE("req %p, data_length %u, buffer_offset %u, "
+			"r2t_sn %u, outstanding_r2t %u", req,
+			be32_to_cpu(rsp_hdr->data_length),
+			be32_to_cpu(rsp_hdr->buffer_offset),
+			be32_to_cpu(rsp_hdr->r2t_sn), req->outstanding_r2t);
+
+		list_add_tail(&rsp->write_list_entry, &send);
+		req->outstanding_r2t++;
+
+	} while ((req->outstanding_r2t < sess->sess_params.max_outstanding_r2t) &&
+		 (req->r2t_len_to_send != 0));
+
+	iscsi_cmnds_init_write(&send, ISCSI_INIT_WRITE_WAKE);
+
+out:
+	return;
+}
+
+static int iscsi_pre_exec(struct scst_cmd *scst_cmd)
+{
+	int res = SCST_PREPROCESS_STATUS_SUCCESS;
+	struct iscsi_cmnd *req = (struct iscsi_cmnd *)
+		scst_cmd_get_tgt_priv(scst_cmd);
+	struct iscsi_cmnd *c, *t;
+
+	EXTRACHECKS_BUG_ON(scst_cmd_atomic(scst_cmd));
+
+	/* If data digest isn't used this list will be empty */
+	list_for_each_entry_safe(c, t, &req->rx_ddigest_cmd_list,
+				rx_ddigest_cmd_list_entry) {
+		TRACE_DBG("Checking digest of RX ddigest cmd %p", c);
+		if (digest_rx_data(c) != 0) {
+			scst_set_cmd_error(scst_cmd,
+				SCST_LOAD_SENSE(iscsi_sense_crc_error));
+			res = SCST_PREPROCESS_STATUS_ERROR_SENSE_SET;
+			/*
+			 * The rest of rx_ddigest_cmd_list will be freed
+			 * in req_cmnd_release()
+			 */
+			goto out;
+		}
+		cmd_del_from_rx_ddigest_list(c);
+		cmnd_put(c);
+	}
+
+out:
+	return res;
+}
+
+static int nop_out_start(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct iscsi_hdr *req_hdr = &cmnd->pdu.bhs;
+	u32 size, tmp;
+	int i, err = 0;
+
+	TRACE_DBG("%p", cmnd);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	if (!(req_hdr->flags & ISCSI_FLG_FINAL)) {
+		PRINT_ERROR("%s", "Initiator sent Nop-Out with not a single "
+			"PDU");
+		err = -ISCSI_REASON_PROTOCOL_ERROR;
+		goto out;
+	}
+
+	if (cmnd_itt(cmnd) == cpu_to_be32(ISCSI_RESERVED_TAG)) {
+		if (unlikely(!(cmnd->pdu.bhs.opcode & ISCSI_OP_IMMEDIATE)))
+			PRINT_ERROR("%s", "Initiator sent RESERVED tag for "
+				"non-immediate Nop-Out command");
+	}
+
+	spin_lock(&conn->session->sn_lock);
+	__update_stat_sn(cmnd);
+	err = check_cmd_sn(cmnd);
+	spin_unlock(&conn->session->sn_lock);
+	if (unlikely(err))
+		goto out;
+
+	size = cmnd->pdu.datasize;
+
+	if (size) {
+		conn->read_msg.msg_iov = conn->read_iov;
+		if (cmnd->pdu.bhs.itt != cpu_to_be32(ISCSI_RESERVED_TAG)) {
+			struct scatterlist *sg;
+
+			cmnd->sg = sg = scst_alloc(size, GFP_KERNEL,
+						&cmnd->sg_cnt);
+			if (sg == NULL) {
+				TRACE(TRACE_OUT_OF_MEM, "Allocating buffer for"
+				      " %d Nop-Out payload failed", size);
+				err = -ISCSI_REASON_OUT_OF_RESOURCES;
+				goto out;
+			}
+
+			/* We already checked it in check_segment_length() */
+			BUG_ON(cmnd->sg_cnt > (signed)ISCSI_CONN_IOV_MAX);
+
+			cmnd->own_sg = 1;
+			cmnd->bufflen = size;
+
+			for (i = 0; i < cmnd->sg_cnt; i++) {
+				conn->read_iov[i].iov_base =
+					(void __force __user *)(page_address(sg_page(&sg[i])));
+				tmp = min_t(u32, size, PAGE_SIZE);
+				conn->read_iov[i].iov_len = tmp;
+				conn->read_size += tmp;
+				size -= tmp;
+			}
+			BUG_ON(size != 0);
+		} else {
+			/*
+			 * There are no problems with the safety from concurrent
+			 * accesses to dummy_page, since for ISCSI_RESERVED_TAG
+			 * the data only read and then discarded.
+			 */
+			for (i = 0; i < (signed)ISCSI_CONN_IOV_MAX; i++) {
+				conn->read_iov[i].iov_base =
+					(void __force __user *)(page_address(dummy_page));
+				tmp = min_t(u32, size, PAGE_SIZE);
+				conn->read_iov[i].iov_len = tmp;
+				conn->read_size += tmp;
+				size -= tmp;
+			}
+
+			/* We already checked size in check_segment_length() */
+			BUG_ON(size != 0);
+		}
+
+		conn->read_msg.msg_iovlen = i;
+		TRACE_DBG("msg_iov=%p, msg_iovlen=%zd", conn->read_msg.msg_iov,
+			conn->read_msg.msg_iovlen);
+	}
+
+out:
+	return err;
+}
+
+int cmnd_rx_continue(struct iscsi_cmnd *req)
+{
+	struct iscsi_conn *conn = req->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_scsi_cmd_hdr *req_hdr = cmnd_hdr(req);
+	struct scst_cmd *scst_cmd = req->scst_cmd;
+	scst_data_direction dir;
+	bool unsolicited_data_expected = false;
+	int res = 0;
+
+	TRACE_DBG("scsi command: %x", req_hdr->scb[0]);
+
+	EXTRACHECKS_BUG_ON(req->scst_state != ISCSI_CMD_STATE_AFTER_PREPROC);
+
+	dir = scst_cmd_get_data_direction(scst_cmd);
+
+	/*
+	 * Check for preliminary completion here to save R2Ts. For TASK QUEUE
+	 * FULL statuses that might be a big performance win.
+	 */
+	if (unlikely(scst_cmd_prelim_completed(scst_cmd) ||
+	    unlikely(req->prelim_compl_flags != 0))) {
+		/*
+		 * If necessary, ISCSI_CMD_ABORTED will be set by
+		 * iscsi_xmit_response().
+		 */
+		res = iscsi_preliminary_complete(req, req, true);
+		goto trace;
+	}
+
+	/* For prelim completed commands sg&K can be already set! */
+
+	if (dir != SCST_DATA_BIDI) {
+		req->sg = scst_cmd_get_sg(scst_cmd);
+		req->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
+		req->bufflen = scst_cmd_get_bufflen(scst_cmd);
+	} else {
+		req->sg = scst_cmd_get_in_sg(scst_cmd);
+		req->sg_cnt = scst_cmd_get_in_sg_cnt(scst_cmd);
+		req->bufflen = scst_cmd_get_in_bufflen(scst_cmd);
+	}
+
+	if (dir & SCST_DATA_WRITE) {
+		unsolicited_data_expected = !(req_hdr->flags & ISCSI_CMD_FINAL);
+
+		if (unlikely(session->sess_params.initial_r2t &&
+		    unsolicited_data_expected)) {
+			PRINT_ERROR("Initiator %s violated negotiated "
+				"parameters: initial R2T is required (ITT %x, "
+				"op  %x)", session->initiator_name,
+				cmnd_itt(req), req_hdr->scb[0]);
+			goto out_close;
+		}
+
+		if (unlikely(!session->sess_params.immediate_data &&
+		    req->pdu.datasize)) {
+			PRINT_ERROR("Initiator %s violated negotiated "
+				"parameters: forbidden immediate data sent "
+				"(ITT %x, op  %x)", session->initiator_name,
+				cmnd_itt(req), req_hdr->scb[0]);
+			goto out_close;
+		}
+
+		if (unlikely(session->sess_params.first_burst_length < req->pdu.datasize)) {
+			PRINT_ERROR("Initiator %s violated negotiated "
+				"parameters: immediate data len (%d) > "
+				"first_burst_length (%d) (ITT %x, op  %x)",
+				session->initiator_name,
+				req->pdu.datasize,
+				session->sess_params.first_burst_length,
+				cmnd_itt(req), req_hdr->scb[0]);
+			goto out_close;
+		}
+
+		req->r2t_len_to_receive = be32_to_cpu(req_hdr->data_length) -
+					  req->pdu.datasize;
+
+		if (unlikely(req->r2t_len_to_receive > req->bufflen)) {
+			PRINT_ERROR("req->r2t_len_to_receive %d > req->bufflen "
+				"%d", req->r2t_len_to_receive, req->bufflen);
+			goto out_close;
+		}
+
+		res = cmnd_insert_data_wait_hash(req);
+		if (unlikely(res != 0)) {
+			/*
+			 * We have to close connection, because otherwise a data
+			 * corruption is possible if we allow to receive data
+			 * for this request in another request with dublicated
+			 * ITT.
+			 */
+			goto out_close;
+		}
+
+		if (unsolicited_data_expected) {
+			req->outstanding_r2t = 1;
+			req->r2t_len_to_send = req->r2t_len_to_receive -
+				min_t(unsigned int,
+				      session->sess_params.first_burst_length -
+						req->pdu.datasize,
+				      req->r2t_len_to_receive);
+		} else
+			req->r2t_len_to_send = req->r2t_len_to_receive;
+
+		req_add_to_write_timeout_list(req);
+
+		if (req->pdu.datasize) {
+			res = cmnd_prepare_recv_pdu(conn, req, 0, req->pdu.datasize);
+			/* For performance better to send R2Ts ASAP */
+			if (likely(res == 0) && (req->r2t_len_to_send != 0))
+				send_r2t(req);
+		}
+	} else {
+		if (unlikely(!(req_hdr->flags & ISCSI_CMD_FINAL) ||
+			     req->pdu.datasize)) {
+			PRINT_ERROR("Unexpected unsolicited data (ITT %x "
+				"CDB %x", cmnd_itt(req), req_hdr->scb[0]);
+			set_scst_preliminary_status_rsp(req, true,
+				SCST_LOAD_SENSE(iscsi_sense_unexpected_unsolicited_data));
+		}
+	}
+
+trace:
+	TRACE_DBG("req=%p, dir=%d, unsolicited_data_expected=%d, "
+		"r2t_len_to_receive=%d, r2t_len_to_send=%d, bufflen=%d, "
+		"own_sg %d", req, dir, unsolicited_data_expected,
+		req->r2t_len_to_receive, req->r2t_len_to_send, req->bufflen,
+		req->own_sg);
+
+out:
+	return res;
+
+out_close:
+	mark_conn_closed(conn);
+	res = -EINVAL;
+	goto out;
+}
+
+static int scsi_cmnd_start(struct iscsi_cmnd *req)
+{
+	struct iscsi_conn *conn = req->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_scsi_cmd_hdr *req_hdr = cmnd_hdr(req);
+	struct scst_cmd *scst_cmd;
+	scst_data_direction dir;
+	struct iscsi_ahs_hdr *ahdr;
+	int res = 0;
+
+	TRACE_DBG("scsi command: %x", req_hdr->scb[0]);
+
+	TRACE_DBG("Incrementing active_cmds (cmd %p, sess %p, "
+		"new value %d)", req, session,
+		atomic_read(&session->active_cmds)+1);
+	atomic_inc(&session->active_cmds);
+	req->dec_active_cmnds = 1;
+
+	scst_cmd = scst_rx_cmd(session->scst_sess,
+		(uint8_t *)&req_hdr->lun, sizeof(req_hdr->lun),
+		req_hdr->scb, sizeof(req_hdr->scb), SCST_NON_ATOMIC);
+	if (scst_cmd == NULL) {
+		res = create_preliminary_status_rsp(req, SAM_STAT_BUSY,
+			NULL, 0);
+		goto out;
+	}
+
+	req->scst_cmd = scst_cmd;
+	scst_cmd_set_tag(scst_cmd, req_hdr->itt);
+	scst_cmd_set_tgt_priv(scst_cmd, req);
+
+	if ((req_hdr->flags & ISCSI_CMD_READ) &&
+	    (req_hdr->flags & ISCSI_CMD_WRITE)) {
+		int sz = cmnd_read_size(req);
+		if (unlikely(sz < 0)) {
+			PRINT_ERROR("%s", "BIDI data transfer, but initiator "
+				"not supplied Bidirectional Read Expected Data "
+				"Transfer Length AHS");
+			set_scst_preliminary_status_rsp(req, true,
+			   SCST_LOAD_SENSE(scst_sense_parameter_value_invalid));
+		} else {
+			req->read_size = sz;
+			dir = SCST_DATA_BIDI;
+			scst_cmd_set_expected(scst_cmd, dir, sz);
+			scst_cmd_set_expected_in_transfer_len(scst_cmd,
+				be32_to_cpu(req_hdr->data_length));
+			scst_cmd_set_tgt_need_alloc_data_buf(scst_cmd);
+		}
+	} else if (req_hdr->flags & ISCSI_CMD_READ) {
+		req->read_size = be32_to_cpu(req_hdr->data_length);
+		dir = SCST_DATA_READ;
+		scst_cmd_set_expected(scst_cmd, dir, req->read_size);
+		scst_cmd_set_tgt_need_alloc_data_buf(scst_cmd);
+	} else if (req_hdr->flags & ISCSI_CMD_WRITE) {
+		dir = SCST_DATA_WRITE;
+		scst_cmd_set_expected(scst_cmd, dir,
+			be32_to_cpu(req_hdr->data_length));
+	} else {
+		dir = SCST_DATA_NONE;
+		scst_cmd_set_expected(scst_cmd, dir, 0);
+	}
+
+	switch (req_hdr->flags & ISCSI_CMD_ATTR_MASK) {
+	case ISCSI_CMD_SIMPLE:
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_SIMPLE);
+		break;
+	case ISCSI_CMD_HEAD_OF_QUEUE:
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_HEAD_OF_QUEUE);
+		break;
+	case ISCSI_CMD_ORDERED:
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_ORDERED);
+		break;
+	case ISCSI_CMD_ACA:
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_ACA);
+		break;
+	case ISCSI_CMD_UNTAGGED:
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_UNTAGGED);
+		break;
+	default:
+		PRINT_ERROR("Unknown task code %x, use ORDERED instead",
+			req_hdr->flags & ISCSI_CMD_ATTR_MASK);
+		scst_cmd_set_queue_type(scst_cmd, SCST_CMD_QUEUE_ORDERED);
+		break;
+	}
+
+	/* cmd_sn is already in CPU format converted in check_cmd_sn() */
+	scst_cmd_set_tgt_sn(scst_cmd, req_hdr->cmd_sn);
+
+	ahdr = (struct iscsi_ahs_hdr *)req->pdu.ahs;
+	if (ahdr != NULL) {
+		uint8_t *p = (uint8_t *)ahdr;
+		unsigned int size = 0;
+		do {
+			int s;
+
+			ahdr = (struct iscsi_ahs_hdr *)p;
+
+			if (ahdr->ahstype == ISCSI_AHSTYPE_CDB) {
+				struct iscsi_cdb_ahdr *eca =
+					(struct iscsi_cdb_ahdr *)ahdr;
+				scst_cmd_set_ext_cdb(scst_cmd, eca->cdb,
+					be16_to_cpu(ahdr->ahslength) - 1);
+				break;
+			}
+			s = 3 + be16_to_cpu(ahdr->ahslength);
+			s = (s + 3) & -4;
+			size += s;
+			p += s;
+		} while (size < req->pdu.ahssize);
+	}
+
+	TRACE_DBG("START Command (itt %x, queue_type %d)",
+		req_hdr->itt, scst_cmd_get_queue_type(scst_cmd));
+	req->scst_state = ISCSI_CMD_STATE_RX_CMD;
+	conn->rx_task = current;
+	scst_cmd_init_stage1_done(scst_cmd, SCST_CONTEXT_DIRECT, 0);
+
+	if (req->scst_state != ISCSI_CMD_STATE_RX_CMD)
+		res = cmnd_rx_continue(req);
+	else {
+		TRACE_DBG("Delaying req %p post processing (scst_state %d)",
+			req, req->scst_state);
+		res = 1;
+	}
+
+out:
+	return res;
+}
+
+static int data_out_start(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct iscsi_data_out_hdr *req_hdr =
+		(struct iscsi_data_out_hdr *)&cmnd->pdu.bhs;
+	struct iscsi_cmnd *orig_req;
+#if 0
+	struct iscsi_hdr *orig_req_hdr;
+#endif
+	u32 offset = be32_to_cpu(req_hdr->buffer_offset);
+	int res = 0;
+
+	/*
+	 * There is no race with send_r2t() and conn_abort(), since
+	 * all functions called from single read thread
+	 */
+	iscsi_extracheck_is_rd_thread(cmnd->conn);
+
+	update_stat_sn(cmnd);
+
+	orig_req = cmnd_find_data_wait_hash(conn, req_hdr->itt);
+	cmnd->cmd_req = orig_req;
+	if (unlikely(orig_req == NULL)) {
+		/*
+		 * It shouldn't happen, since we don't abort any request until
+		 * we received all related PDUs from the initiator or timeout
+		 * them. Let's quietly drop such PDUs.
+		 */
+		TRACE_MGMT_DBG("Unable to find scsi task ITT %x",
+			cmnd_itt(cmnd));
+		res = iscsi_preliminary_complete(cmnd, cmnd, true);
+		goto out;
+	}
+
+	if (unlikely(orig_req->r2t_len_to_receive < cmnd->pdu.datasize)) {
+		if (orig_req->prelim_compl_flags != 0) {
+			/* We can have fake r2t_len_to_receive */
+			goto go;
+		}
+		PRINT_ERROR("Data size (%d) > R2T length to receive (%d)",
+			cmnd->pdu.datasize, orig_req->r2t_len_to_receive);
+		set_scst_preliminary_status_rsp(orig_req, false,
+			SCST_LOAD_SENSE(iscsi_sense_incorrect_amount_of_data));
+		goto go;
+	}
+
+	/* Crazy iSCSI spec requires us to make this unneeded check */
+#if 0 /* ...but some initiators (Windows) don't care to correctly set it */
+	orig_req_hdr = &orig_req->pdu.bhs;
+	if (unlikely(orig_req_hdr->lun != req_hdr->lun)) {
+		PRINT_ERROR("Wrong LUN (%lld) in Data-Out PDU (expected %lld), "
+			"orig_req %p, cmnd %p", (unsigned long long)req_hdr->lun,
+			(unsigned long long)orig_req_hdr->lun, orig_req, cmnd);
+		create_reject_rsp(orig_req, ISCSI_REASON_PROTOCOL_ERROR, false);
+		goto go;
+	}
+#endif
+
+go:
+	if (req_hdr->flags & ISCSI_FLG_FINAL)
+		orig_req->outstanding_r2t--;
+
+	if (unlikely(orig_req->prelim_compl_flags != 0)) {
+		res = iscsi_preliminary_complete(cmnd, orig_req, true);
+		goto out;
+	}
+
+	TRACE_WRITE("cmnd %p, orig_req %p, offset %u, datasize %u", cmnd,
+		orig_req, offset, cmnd->pdu.datasize);
+
+	res = cmnd_prepare_recv_pdu(conn, orig_req, offset, cmnd->pdu.datasize);
+
+out:
+	return res;
+}
+
+static void data_out_end(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_data_out_hdr *req_hdr =
+		(struct iscsi_data_out_hdr *)&cmnd->pdu.bhs;
+	struct iscsi_cmnd *req;
+
+	EXTRACHECKS_BUG_ON(cmnd == NULL);
+	req = cmnd->cmd_req;
+	if (unlikely(req == NULL))
+		goto out;
+
+	TRACE_DBG("cmnd %p, req %p", cmnd, req);
+
+	iscsi_extracheck_is_rd_thread(cmnd->conn);
+
+	if (!(cmnd->conn->ddigest_type & DIGEST_NONE) &&
+	    !cmnd->ddigest_checked) {
+		cmd_add_on_rx_ddigest_list(req, cmnd);
+		cmnd_get(cmnd);
+	}
+
+	/*
+	 * Now we received the data and can adjust r2t_len_to_receive of the
+	 * orig req. We couldn't do it earlier, because it will break data
+	 * receiving errors recovery (calls of iscsi_fail_data_waiting_cmnd()).
+	 */
+	req->r2t_len_to_receive -= cmnd->pdu.datasize;
+
+	if (unlikely(req->prelim_compl_flags != 0)) {
+		/*
+		 * We might need to wait for one or more PDUs. Let's simplify
+		 * other code.
+		 */
+		req->r2t_len_to_receive = req->outstanding_r2t;
+		req->r2t_len_to_send = 0;
+	}
+
+	TRACE_DBG("req %p, FINAL %x, outstanding_r2t %d, r2t_len_to_receive %d,"
+		" r2t_len_to_send %d", req, req_hdr->flags & ISCSI_FLG_FINAL,
+		req->outstanding_r2t, req->r2t_len_to_receive,
+		req->r2t_len_to_send);
+
+	if (!(req_hdr->flags & ISCSI_FLG_FINAL))
+		goto out;
+
+	if (req->r2t_len_to_receive == 0) {
+		if (!req->pending)
+			iscsi_restart_cmnd(req);
+	} else if (req->r2t_len_to_send != 0)
+		send_r2t(req);
+
+out:
+	return;
+}
+
+/* Might be called under target_mutex and cmd_list_lock */
+static void __cmnd_abort(struct iscsi_cmnd *cmnd)
+{
+	unsigned long timeout_time = jiffies + ISCSI_TM_DATA_WAIT_TIMEOUT +
+					ISCSI_ADD_SCHED_TIME;
+	struct iscsi_conn *conn = cmnd->conn;
+
+	TRACE_MGMT_DBG("Aborting cmd %p, scst_cmd %p (scst state %x, "
+		"ref_cnt %d, on_write_timeout_list %d, write_start %ld, ITT %x, "
+		"sn %u, op %x, r2t_len_to_receive %d, r2t_len_to_send %d, "
+		"CDB op %x, size to write %u, outstanding_r2t %d, "
+		"sess->exp_cmd_sn %u, conn %p, rd_task %p)",
+		cmnd, cmnd->scst_cmd, cmnd->scst_state,
+		atomic_read(&cmnd->ref_cnt), cmnd->on_write_timeout_list,
+		cmnd->write_start, cmnd_itt(cmnd), cmnd->pdu.bhs.sn,
+		cmnd_opcode(cmnd), cmnd->r2t_len_to_receive,
+		cmnd->r2t_len_to_send, cmnd_scsicode(cmnd),
+		cmnd_write_size(cmnd), cmnd->outstanding_r2t,
+		cmnd->conn->session->exp_cmd_sn, cmnd->conn,
+		cmnd->conn->rd_task);
+
+	/*
+	 * Lock to sync with iscsi_check_tm_data_wait_timeouts(), including
+	 * CMD_ABORTED bit set.
+	 */
+	spin_lock_bh(&iscsi_rd_lock);
+
+	/*
+	 * We suppose that preliminary commands completion is tested by
+	 * comparing prelim_compl_flags with 0. Otherwise a race is possible,
+	 * like sending command in SCST core as PRELIM_COMPLETED, while it
+	 * wasn't aborted in it yet and have as the result a wrong success
+	 * status sent to the initiator.
+	 */
+	set_bit(ISCSI_CMD_ABORTED, &cmnd->prelim_compl_flags);
+
+	TRACE_MGMT_DBG("Setting conn_tm_active for conn %p", conn);
+	conn->conn_tm_active = 1;
+
+	spin_unlock_bh(&iscsi_rd_lock);
+
+	/*
+	 * We need the lock to sync with req_add_to_write_timeout_list() and
+	 * close races for rsp_timer.expires.
+	 */
+	spin_lock_bh(&conn->write_list_lock);
+	if (!timer_pending(&conn->rsp_timer) ||
+	    time_after(conn->rsp_timer.expires, timeout_time)) {
+		TRACE_MGMT_DBG("Mod timer on %ld (conn %p)", timeout_time,
+			conn);
+		mod_timer(&conn->rsp_timer, timeout_time);
+	} else
+		TRACE_MGMT_DBG("Timer for conn %p is going to fire on %ld "
+			"(timeout time %ld)", conn, conn->rsp_timer.expires,
+			timeout_time);
+	spin_unlock_bh(&conn->write_list_lock);
+
+	return;
+}
+
+/* Must be called from the read or conn close thread */
+static int cmnd_abort(struct iscsi_cmnd *req, int *status)
+{
+	struct iscsi_task_mgt_hdr *req_hdr =
+		(struct iscsi_task_mgt_hdr *)&req->pdu.bhs;
+	struct iscsi_cmnd *cmnd;
+	int res = -1;
+
+	req_hdr->ref_cmd_sn = be32_to_cpu(req_hdr->ref_cmd_sn);
+
+	if (!before(req_hdr->ref_cmd_sn, req_hdr->cmd_sn)) {
+		TRACE(TRACE_MGMT, "ABORT TASK: RefCmdSN(%u) > CmdSN(%u)",
+			req_hdr->ref_cmd_sn, req_hdr->cmd_sn);
+		*status = ISCSI_RESPONSE_UNKNOWN_TASK;
+		goto out;
+	}
+
+	cmnd = cmnd_find_itt_get(req->conn, req_hdr->rtt);
+	if (cmnd) {
+		struct iscsi_conn *conn = cmnd->conn;
+		struct iscsi_scsi_cmd_hdr *hdr = cmnd_hdr(cmnd);
+
+		if (req_hdr->lun != hdr->lun) {
+			PRINT_ERROR("ABORT TASK: LUN mismatch: req LUN "
+				    "%llx, cmd LUN %llx, rtt %u",
+				    (long long unsigned int)req_hdr->lun,
+				    (long long unsigned int)hdr->lun,
+				    req_hdr->rtt);
+			*status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+			goto out_put;
+		}
+
+		if (cmnd->pdu.bhs.opcode & ISCSI_OP_IMMEDIATE) {
+			if (req_hdr->ref_cmd_sn != req_hdr->cmd_sn) {
+				PRINT_ERROR("ABORT TASK: RefCmdSN(%u) != TM "
+					"cmd CmdSN(%u) for immediate command "
+					"%p", req_hdr->ref_cmd_sn,
+					req_hdr->cmd_sn, cmnd);
+				*status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+				goto out_put;
+			}
+		} else {
+			if (req_hdr->ref_cmd_sn != hdr->cmd_sn) {
+				PRINT_ERROR("ABORT TASK: RefCmdSN(%u) != "
+					"CmdSN(%u) for command %p",
+					req_hdr->ref_cmd_sn, req_hdr->cmd_sn,
+					cmnd);
+				*status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+				goto out_put;
+			}
+		}
+
+		if (before(req_hdr->cmd_sn, hdr->cmd_sn) ||
+		    (req_hdr->cmd_sn == hdr->cmd_sn)) {
+			PRINT_ERROR("ABORT TASK: SN mismatch: req SN %x, "
+				"cmd SN %x, rtt %u", req_hdr->cmd_sn,
+				hdr->cmd_sn, req_hdr->rtt);
+			*status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+			goto out_put;
+		}
+
+		spin_lock_bh(&conn->cmd_list_lock);
+		__cmnd_abort(cmnd);
+		spin_unlock_bh(&conn->cmd_list_lock);
+
+		cmnd_put(cmnd);
+		res = 0;
+	} else {
+		TRACE_MGMT_DBG("cmd RTT %x not found", req_hdr->rtt);
+		/*
+		 * iSCSI RFC:
+		 *
+		 * b)  If the Referenced Task Tag does not identify an existing task,
+		 * but if the CmdSN indicated by the RefCmdSN field in the Task
+		 * Management function request is within the valid CmdSN window
+		 * and less than the CmdSN of the Task Management function
+		 * request itself, then targets must consider the CmdSN received
+		 * and return the "Function complete" response.
+		 *
+		 * c)  If the Referenced Task Tag does not identify an existing task
+		 * and if the CmdSN indicated by the RefCmdSN field in the Task
+		 * Management function request is outside the valid CmdSN window,
+		 * then targets must return the "Task does not exist" response.
+		 *
+		 * 128 seems to be a good "window".
+		 */
+		if (between(req_hdr->ref_cmd_sn, req_hdr->cmd_sn - 128,
+			    req_hdr->cmd_sn)) {
+			*status = ISCSI_RESPONSE_FUNCTION_COMPLETE;
+			res = 0;
+		} else
+			*status = ISCSI_RESPONSE_UNKNOWN_TASK;
+	}
+
+out:
+	return res;
+
+out_put:
+	cmnd_put(cmnd);
+	goto out;
+}
+
+/* Must be called from the read or conn close thread */
+static int target_abort(struct iscsi_cmnd *req, int all)
+{
+	struct iscsi_target *target = req->conn->session->target;
+	struct iscsi_task_mgt_hdr *req_hdr =
+		(struct iscsi_task_mgt_hdr *)&req->pdu.bhs;
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+	struct iscsi_cmnd *cmnd;
+
+	mutex_lock(&target->target_mutex);
+
+	list_for_each_entry(session, &target->session_list,
+			    session_list_entry) {
+		list_for_each_entry(conn, &session->conn_list,
+				    conn_list_entry) {
+			spin_lock_bh(&conn->cmd_list_lock);
+			list_for_each_entry(cmnd, &conn->cmd_list,
+					    cmd_list_entry) {
+				if (cmnd == req)
+					continue;
+				if (all)
+					__cmnd_abort(cmnd);
+				else if (req_hdr->lun == cmnd_hdr(cmnd)->lun)
+					__cmnd_abort(cmnd);
+			}
+			spin_unlock_bh(&conn->cmd_list_lock);
+		}
+	}
+
+	mutex_unlock(&target->target_mutex);
+	return 0;
+}
+
+/* Must be called from the read or conn close thread */
+static void task_set_abort(struct iscsi_cmnd *req)
+{
+	struct iscsi_session *session = req->conn->session;
+	struct iscsi_task_mgt_hdr *req_hdr =
+		(struct iscsi_task_mgt_hdr *)&req->pdu.bhs;
+	struct iscsi_target *target = session->target;
+	struct iscsi_conn *conn;
+	struct iscsi_cmnd *cmnd;
+
+	mutex_lock(&target->target_mutex);
+
+	list_for_each_entry(conn, &session->conn_list, conn_list_entry) {
+		spin_lock_bh(&conn->cmd_list_lock);
+		list_for_each_entry(cmnd, &conn->cmd_list, cmd_list_entry) {
+			struct iscsi_scsi_cmd_hdr *hdr = cmnd_hdr(cmnd);
+			if (cmnd == req)
+				continue;
+			if (req_hdr->lun != hdr->lun)
+				continue;
+			if (before(req_hdr->cmd_sn, hdr->cmd_sn) ||
+			    req_hdr->cmd_sn == hdr->cmd_sn)
+				continue;
+			__cmnd_abort(cmnd);
+		}
+		spin_unlock_bh(&conn->cmd_list_lock);
+	}
+
+	mutex_unlock(&target->target_mutex);
+	return;
+}
+
+/* Must be called from the read or conn close thread */
+void conn_abort(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd, *r, *t;
+
+	TRACE_MGMT_DBG("Aborting conn %p", conn);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	cancel_delayed_work_sync(&conn->nop_in_delayed_work);
+
+	/* No locks, we are the only user */
+	list_for_each_entry_safe(r, t, &conn->nop_req_list,
+			nop_req_list_entry) {
+		list_del(&r->nop_req_list_entry);
+		cmnd_put(r);
+	}
+
+	spin_lock_bh(&conn->cmd_list_lock);
+again:
+	list_for_each_entry(cmnd, &conn->cmd_list, cmd_list_entry) {
+		__cmnd_abort(cmnd);
+		if (cmnd->r2t_len_to_receive != 0) {
+			if (!cmnd_get_check(cmnd)) {
+				spin_unlock_bh(&conn->cmd_list_lock);
+
+				/* ToDo: this is racy for MC/S */
+				iscsi_fail_data_waiting_cmnd(cmnd);
+
+				cmnd_put(cmnd);
+
+				/*
+				 * We are in the read thread, so we may not
+				 * worry that after cmnd release conn gets
+				 * released as well.
+				 */
+				spin_lock_bh(&conn->cmd_list_lock);
+				goto again;
+			}
+		}
+	}
+	spin_unlock_bh(&conn->cmd_list_lock);
+
+	return;
+}
+
+static void execute_task_management(struct iscsi_cmnd *req)
+{
+	struct iscsi_conn *conn = req->conn;
+	struct iscsi_session *sess = conn->session;
+	struct iscsi_task_mgt_hdr *req_hdr =
+		(struct iscsi_task_mgt_hdr *)&req->pdu.bhs;
+	int rc, status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+	int function = req_hdr->function & ISCSI_FUNCTION_MASK;
+	struct scst_rx_mgmt_params params;
+
+	TRACE(TRACE_MGMT, "TM fn %d", function);
+
+	TRACE_MGMT_DBG("TM req %p, ITT %x, RTT %x, sn %u, con %p", req,
+		cmnd_itt(req), req_hdr->rtt, req_hdr->cmd_sn, conn);
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	spin_lock(&sess->sn_lock);
+	sess->tm_active++;
+	sess->tm_sn = req_hdr->cmd_sn;
+	if (sess->tm_rsp != NULL) {
+		struct iscsi_cmnd *tm_rsp = sess->tm_rsp;
+
+		TRACE_MGMT_DBG("Dropping delayed TM rsp %p", tm_rsp);
+
+		sess->tm_rsp = NULL;
+		sess->tm_active--;
+
+		spin_unlock(&sess->sn_lock);
+
+		BUG_ON(sess->tm_active < 0);
+
+		rsp_cmnd_release(tm_rsp);
+	} else
+		spin_unlock(&sess->sn_lock);
+
+	memset(&params, 0, sizeof(params));
+	params.atomic = SCST_NON_ATOMIC;
+	params.tgt_priv = req;
+
+	if ((function != ISCSI_FUNCTION_ABORT_TASK) &&
+	    (req_hdr->rtt != ISCSI_RESERVED_TAG)) {
+		PRINT_ERROR("Invalid RTT %x (TM fn %d)", req_hdr->rtt,
+			function);
+		rc = -1;
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		goto reject;
+	}
+
+	/* cmd_sn is already in CPU format converted in check_cmd_sn() */
+
+	switch (function) {
+	case ISCSI_FUNCTION_ABORT_TASK:
+		rc = cmnd_abort(req, &status);
+		if (rc == 0) {
+			params.fn = SCST_ABORT_TASK;
+			params.tag = req_hdr->rtt;
+			params.tag_set = 1;
+			params.lun = (uint8_t *)&req_hdr->lun;
+			params.lun_len = sizeof(req_hdr->lun);
+			params.lun_set = 1;
+			params.cmd_sn = req_hdr->cmd_sn;
+			params.cmd_sn_set = 1;
+			rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+				&params);
+			status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		}
+		break;
+	case ISCSI_FUNCTION_ABORT_TASK_SET:
+		task_set_abort(req);
+		params.fn = SCST_ABORT_TASK_SET;
+		params.lun = (uint8_t *)&req_hdr->lun;
+		params.lun_len = sizeof(req_hdr->lun);
+		params.lun_set = 1;
+		params.cmd_sn = req_hdr->cmd_sn;
+		params.cmd_sn_set = 1;
+		rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+			&params);
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	case ISCSI_FUNCTION_CLEAR_TASK_SET:
+		task_set_abort(req);
+		params.fn = SCST_CLEAR_TASK_SET;
+		params.lun = (uint8_t *)&req_hdr->lun;
+		params.lun_len = sizeof(req_hdr->lun);
+		params.lun_set = 1;
+		params.cmd_sn = req_hdr->cmd_sn;
+		params.cmd_sn_set = 1;
+		rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+			&params);
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	case ISCSI_FUNCTION_CLEAR_ACA:
+		params.fn = SCST_CLEAR_ACA;
+		params.lun = (uint8_t *)&req_hdr->lun;
+		params.lun_len = sizeof(req_hdr->lun);
+		params.lun_set = 1;
+		params.cmd_sn = req_hdr->cmd_sn;
+		params.cmd_sn_set = 1;
+		rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+			&params);
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	case ISCSI_FUNCTION_TARGET_COLD_RESET:
+	case ISCSI_FUNCTION_TARGET_WARM_RESET:
+		target_abort(req, 1);
+		params.fn = SCST_TARGET_RESET;
+		params.cmd_sn = req_hdr->cmd_sn;
+		params.cmd_sn_set = 1;
+		rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+			&params);
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	case ISCSI_FUNCTION_LOGICAL_UNIT_RESET:
+		target_abort(req, 0);
+		params.fn = SCST_LUN_RESET;
+		params.lun = (uint8_t *)&req_hdr->lun;
+		params.lun_len = sizeof(req_hdr->lun);
+		params.lun_set = 1;
+		params.cmd_sn = req_hdr->cmd_sn;
+		params.cmd_sn_set = 1;
+		rc = scst_rx_mgmt_fn(conn->session->scst_sess,
+			&params);
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	case ISCSI_FUNCTION_TASK_REASSIGN:
+		rc = -1;
+		status = ISCSI_RESPONSE_ALLEGIANCE_REASSIGNMENT_UNSUPPORTED;
+		break;
+	default:
+		PRINT_ERROR("Unknown TM function %d", function);
+		rc = -1;
+		status = ISCSI_RESPONSE_FUNCTION_REJECTED;
+		break;
+	}
+
+reject:
+	if (rc != 0)
+		iscsi_send_task_mgmt_resp(req, status);
+
+	return;
+}
+
+static void nop_out_exec(struct iscsi_cmnd *req)
+{
+	struct iscsi_cmnd *rsp;
+	struct iscsi_nop_in_hdr *rsp_hdr;
+
+	TRACE_DBG("%p", req);
+
+	if (cmnd_itt(req) != cpu_to_be32(ISCSI_RESERVED_TAG)) {
+		rsp = iscsi_alloc_main_rsp(req);
+
+		rsp_hdr = (struct iscsi_nop_in_hdr *)&rsp->pdu.bhs;
+		rsp_hdr->opcode = ISCSI_OP_NOP_IN;
+		rsp_hdr->flags = ISCSI_FLG_FINAL;
+		rsp_hdr->itt = req->pdu.bhs.itt;
+		rsp_hdr->ttt = cpu_to_be32(ISCSI_RESERVED_TAG);
+
+		if (req->pdu.datasize)
+			BUG_ON(req->sg == NULL);
+		else
+			BUG_ON(req->sg != NULL);
+
+		if (req->sg) {
+			rsp->sg = req->sg;
+			rsp->sg_cnt = req->sg_cnt;
+			rsp->bufflen = req->bufflen;
+		}
+
+		/* We already checked it in check_segment_length() */
+		BUG_ON(get_pgcnt(req->pdu.datasize, 0) > ISCSI_CONN_IOV_MAX);
+
+		rsp->pdu.datasize = req->pdu.datasize;
+	} else {
+		bool found = false;
+		struct iscsi_cmnd *r;
+		struct iscsi_conn *conn = req->conn;
+
+		TRACE_DBG("Receive Nop-In response (ttt 0x%08x)",
+			be32_to_cpu(cmnd_ttt(req)));
+
+		spin_lock_bh(&conn->nop_req_list_lock);
+		list_for_each_entry(r, &conn->nop_req_list,
+				nop_req_list_entry) {
+			if (cmnd_ttt(req) == cmnd_ttt(r)) {
+				list_del(&r->nop_req_list_entry);
+				found = true;
+				break;
+			}
+		}
+		spin_unlock_bh(&conn->nop_req_list_lock);
+
+		if (found)
+			cmnd_put(r);
+		else
+			TRACE_MGMT_DBG("%s", "Got Nop-out response without "
+				"corresponding Nop-In request");
+	}
+
+	req_cmnd_release(req);
+	return;
+}
+
+static void logout_exec(struct iscsi_cmnd *req)
+{
+	struct iscsi_logout_req_hdr *req_hdr;
+	struct iscsi_cmnd *rsp;
+	struct iscsi_logout_rsp_hdr *rsp_hdr;
+
+	PRINT_INFO("Logout received from initiator %s",
+		req->conn->session->initiator_name);
+	TRACE_DBG("%p", req);
+
+	req_hdr = (struct iscsi_logout_req_hdr *)&req->pdu.bhs;
+	rsp = iscsi_alloc_main_rsp(req);
+	rsp_hdr = (struct iscsi_logout_rsp_hdr *)&rsp->pdu.bhs;
+	rsp_hdr->opcode = ISCSI_OP_LOGOUT_RSP;
+	rsp_hdr->flags = ISCSI_FLG_FINAL;
+	rsp_hdr->itt = req_hdr->itt;
+	rsp->should_close_conn = 1;
+
+	req_cmnd_release(req);
+
+	return;
+}
+
+static void iscsi_cmnd_exec(struct iscsi_cmnd *cmnd)
+{
+
+	TRACE_DBG("cmnd %p, op %x, SN %u", cmnd, cmnd_opcode(cmnd),
+		cmnd->pdu.bhs.sn);
+
+	iscsi_extracheck_is_rd_thread(cmnd->conn);
+
+	if (cmnd_opcode(cmnd) == ISCSI_OP_SCSI_CMD) {
+		if (cmnd->r2t_len_to_receive == 0)
+			iscsi_restart_cmnd(cmnd);
+		else if (cmnd->r2t_len_to_send != 0)
+			send_r2t(cmnd);
+		goto out;
+	}
+
+	if (cmnd->prelim_compl_flags != 0) {
+		TRACE_MGMT_DBG("Terminating prelim completed non-SCSI cmnd %p "
+			"(op %x)", cmnd, cmnd_opcode(cmnd));
+		req_cmnd_release(cmnd);
+		goto out;
+	}
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_NOP_OUT:
+		nop_out_exec(cmnd);
+		break;
+	case ISCSI_OP_SCSI_TASK_MGT_MSG:
+		execute_task_management(cmnd);
+		break;
+	case ISCSI_OP_LOGOUT_CMD:
+		logout_exec(cmnd);
+		break;
+	default:
+		PRINT_CRIT_ERROR("Unexpected cmnd op %x", cmnd_opcode(cmnd));
+		BUG();
+		break;
+	}
+
+out:
+	return;
+}
+
+static void set_cork(struct socket *sock, int on)
+{
+	int opt = on;
+	mm_segment_t oldfs;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+	sock->ops->setsockopt(sock, SOL_TCP, TCP_CORK,
+			      (void __force __user *)&opt, sizeof(opt));
+	set_fs(oldfs);
+	return;
+}
+
+void cmnd_tx_start(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+
+	TRACE_DBG("conn %p, cmnd %p, opcode %x", conn, cmnd, cmnd_opcode(cmnd));
+	iscsi_cmnd_set_length(&cmnd->pdu);
+
+	iscsi_extracheck_is_wr_thread(conn);
+
+	set_cork(conn->sock, 1);
+
+	conn->write_iop = conn->write_iov;
+	conn->write_iop->iov_base = (void __force __user *)(&cmnd->pdu.bhs);
+	conn->write_iop->iov_len = sizeof(cmnd->pdu.bhs);
+	conn->write_iop_used = 1;
+	conn->write_size = sizeof(cmnd->pdu.bhs) + cmnd->pdu.datasize;
+	conn->write_offset = 0;
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_NOP_IN:
+		if (cmnd_itt(cmnd) == cpu_to_be32(ISCSI_RESERVED_TAG))
+			cmnd->pdu.bhs.sn = cmnd_set_sn(cmnd, 0);
+		else
+			cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_SCSI_RSP:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_SCSI_TASK_MGT_RSP:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_TEXT_RSP:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_SCSI_DATA_IN:
+	{
+		struct iscsi_data_in_hdr *rsp =
+			(struct iscsi_data_in_hdr *)&cmnd->pdu.bhs;
+		u32 offset = cpu_to_be32(rsp->buffer_offset);
+
+		TRACE_DBG("cmnd %p, offset %u, datasize %u, bufflen %u", cmnd,
+			offset, cmnd->pdu.datasize, cmnd->bufflen);
+
+		BUG_ON(offset > cmnd->bufflen);
+		BUG_ON(offset + cmnd->pdu.datasize > cmnd->bufflen);
+
+		conn->write_offset = offset;
+
+		cmnd_set_sn(cmnd, (rsp->flags & ISCSI_FLG_FINAL) ? 1 : 0);
+		break;
+	}
+	case ISCSI_OP_LOGOUT_RSP:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_R2T:
+		cmnd->pdu.bhs.sn = cmnd_set_sn(cmnd, 0);
+		break;
+	case ISCSI_OP_ASYNC_MSG:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	case ISCSI_OP_REJECT:
+		cmnd_set_sn(cmnd, 1);
+		break;
+	default:
+		PRINT_ERROR("Unexpected cmnd op %x", cmnd_opcode(cmnd));
+		break;
+	}
+
+	iscsi_dump_pdu(&cmnd->pdu);
+	return;
+}
+
+void cmnd_tx_end(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+
+	TRACE_DBG("%p:%x (should_close_conn %d, should_close_all_conn %d)",
+		cmnd, cmnd_opcode(cmnd), cmnd->should_close_conn,
+		cmnd->should_close_all_conn);
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_NOP_IN:
+	case ISCSI_OP_SCSI_RSP:
+	case ISCSI_OP_SCSI_TASK_MGT_RSP:
+	case ISCSI_OP_TEXT_RSP:
+	case ISCSI_OP_R2T:
+	case ISCSI_OP_ASYNC_MSG:
+	case ISCSI_OP_REJECT:
+	case ISCSI_OP_SCSI_DATA_IN:
+	case ISCSI_OP_LOGOUT_RSP:
+		break;
+	default:
+		PRINT_CRIT_ERROR("unexpected cmnd op %x", cmnd_opcode(cmnd));
+		BUG();
+		break;
+	}
+#endif
+
+	if (unlikely(cmnd->should_close_conn)) {
+		if (cmnd->should_close_all_conn) {
+			PRINT_INFO("Closing all connections for target %x at "
+				"initiator's %s request",
+				cmnd->conn->session->target->tid,
+				conn->session->initiator_name);
+			target_del_all_sess(cmnd->conn->session->target, 0);
+		} else {
+			PRINT_INFO("Closing connection at initiator's %s "
+				"request", conn->session->initiator_name);
+			mark_conn_closed(conn);
+		}
+	}
+
+	set_cork(cmnd->conn->sock, 0);
+	return;
+}
+
+/*
+ * Push the command for execution. This functions reorders the commands.
+ * Called from the read thread.
+ *
+ * Basically, since we don't support MC/S and TCP guarantees data delivery
+ * order, all that SN's stuff isn't needed at all (commands delivery order is
+ * a natural commands execution order), but insane iSCSI spec requires
+ * us to check it and we have to, because some crazy initiators can rely
+ * on the SN's based order and reorder requests during sending. For all other
+ * normal initiators all that code is a NOP.
+ */
+static void iscsi_push_cmnd(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_session *session = cmnd->conn->session;
+	struct list_head *entry;
+	u32 cmd_sn;
+
+	TRACE_DBG("cmnd %p, iSCSI opcode %x, sn %u, exp sn %u", cmnd,
+		cmnd_opcode(cmnd), cmnd->pdu.bhs.sn, session->exp_cmd_sn);
+
+	iscsi_extracheck_is_rd_thread(cmnd->conn);
+
+	BUG_ON(cmnd->parent_req != NULL);
+
+	if (cmnd->pdu.bhs.opcode & ISCSI_OP_IMMEDIATE) {
+		TRACE_DBG("Immediate cmd %p (cmd_sn %u)", cmnd,
+			cmnd->pdu.bhs.sn);
+		iscsi_cmnd_exec(cmnd);
+		goto out;
+	}
+
+	spin_lock(&session->sn_lock);
+
+	cmd_sn = cmnd->pdu.bhs.sn;
+	if (cmd_sn == session->exp_cmd_sn) {
+		while (1) {
+			session->exp_cmd_sn = ++cmd_sn;
+
+			if (unlikely(session->tm_active > 0)) {
+				if (before(cmd_sn, session->tm_sn)) {
+					struct iscsi_conn *conn = cmnd->conn;
+
+					spin_unlock(&session->sn_lock);
+
+					spin_lock_bh(&conn->cmd_list_lock);
+					__cmnd_abort(cmnd);
+					spin_unlock_bh(&conn->cmd_list_lock);
+
+					spin_lock(&session->sn_lock);
+				}
+				iscsi_check_send_delayed_tm_resp(session);
+			}
+
+			spin_unlock(&session->sn_lock);
+
+			iscsi_cmnd_exec(cmnd);
+
+			spin_lock(&session->sn_lock);
+
+			if (list_empty(&session->pending_list))
+				break;
+			cmnd = list_entry(session->pending_list.next,
+					  struct iscsi_cmnd,
+					  pending_list_entry);
+			if (cmnd->pdu.bhs.sn != cmd_sn)
+				break;
+
+			list_del(&cmnd->pending_list_entry);
+			cmnd->pending = 0;
+
+			TRACE_MGMT_DBG("Processing pending cmd %p (cmd_sn %u)",
+				cmnd, cmd_sn);
+		}
+	} else {
+		int drop = 0;
+
+		TRACE_DBG("Pending cmd %p (cmd_sn %u, exp_cmd_sn %u)",
+			cmnd, cmd_sn, session->exp_cmd_sn);
+
+		/*
+		 * iSCSI RFC 3720: "The target MUST silently ignore any
+		 * non-immediate command outside of [from ExpCmdSN to MaxCmdSN
+		 * inclusive] range". But we won't honor the MaxCmdSN
+		 * requirement, because, since we adjust MaxCmdSN from the
+		 * separate write thread, rarely it is possible that initiator
+		 * can legally send command with CmdSN>MaxSN. But it won't
+		 * hurt anything, in the worst case it will lead to
+		 * additional QUEUE FULL status.
+		 */
+
+		if (unlikely(before(cmd_sn, session->exp_cmd_sn))) {
+			PRINT_ERROR("Unexpected cmd_sn (%u,%u)", cmd_sn,
+				session->exp_cmd_sn);
+			drop = 1;
+		}
+
+#if 0
+		if (unlikely(after(cmd_sn, session->exp_cmd_sn +
+					iscsi_get_allowed_cmds(session)))) {
+			TRACE_MGMT_DBG("Too large cmd_sn %u (exp_cmd_sn %u, "
+				"max_sn %u)", cmd_sn, session->exp_cmd_sn,
+				iscsi_get_allowed_cmds(session));
+		}
+#endif
+
+		spin_unlock(&session->sn_lock);
+
+		if (unlikely(drop)) {
+			req_cmnd_release_force(cmnd);
+			goto out;
+		}
+
+		if (unlikely(test_bit(ISCSI_CMD_ABORTED,
+					&cmnd->prelim_compl_flags))) {
+			struct iscsi_cmnd *tm_clone;
+
+			TRACE_MGMT_DBG("Pending aborted cmnd %p, creating TM "
+				"clone (scst cmd %p, state %d)", cmnd,
+				cmnd->scst_cmd, cmnd->scst_state);
+
+			tm_clone = cmnd_alloc(cmnd->conn, NULL);
+			if (tm_clone != NULL) {
+				set_bit(ISCSI_CMD_ABORTED,
+					&tm_clone->prelim_compl_flags);
+				tm_clone->pdu = cmnd->pdu;
+
+				TRACE_MGMT_DBG("TM clone %p created",
+					       tm_clone);
+
+				iscsi_cmnd_exec(cmnd);
+				cmnd = tm_clone;
+			} else
+				PRINT_ERROR("%s", "Unable to create TM clone");
+		}
+
+		TRACE_MGMT_DBG("Pending cmnd %p (op %x, sn %u, exp sn %u)",
+			cmnd, cmnd_opcode(cmnd), cmd_sn, session->exp_cmd_sn);
+
+		spin_lock(&session->sn_lock);
+		list_for_each(entry, &session->pending_list) {
+			struct iscsi_cmnd *tmp =
+				list_entry(entry, struct iscsi_cmnd,
+					   pending_list_entry);
+			if (before(cmd_sn, tmp->pdu.bhs.sn))
+				break;
+		}
+		list_add_tail(&cmnd->pending_list_entry, entry);
+		cmnd->pending = 1;
+	}
+
+	spin_unlock(&session->sn_lock);
+out:
+	return;
+}
+
+static int check_segment_length(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct iscsi_session *session = conn->session;
+
+	if (unlikely(cmnd->pdu.datasize > session->sess_params.max_recv_data_length)) {
+		PRINT_ERROR("Initiator %s violated negotiated parameters: "
+			"data too long (ITT %x, datasize %u, "
+			"max_recv_data_length %u", session->initiator_name,
+			cmnd_itt(cmnd), cmnd->pdu.datasize,
+			session->sess_params.max_recv_data_length);
+		mark_conn_closed(conn);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int cmnd_rx_start(struct iscsi_cmnd *cmnd)
+{
+	int res, rc;
+
+	iscsi_dump_pdu(&cmnd->pdu);
+
+	res = check_segment_length(cmnd);
+	if (res != 0)
+		goto out;
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_SCSI_CMD:
+		res = scsi_cmnd_start(cmnd);
+		if (unlikely(res < 0))
+			goto out;
+		spin_lock(&cmnd->conn->session->sn_lock);
+		__update_stat_sn(cmnd);
+		rc = check_cmd_sn(cmnd);
+		spin_unlock(&cmnd->conn->session->sn_lock);
+		break;
+	case ISCSI_OP_SCSI_DATA_OUT:
+		res = data_out_start(cmnd);
+		goto out;
+	case ISCSI_OP_NOP_OUT:
+		rc = nop_out_start(cmnd);
+		break;
+	case ISCSI_OP_SCSI_TASK_MGT_MSG:
+	case ISCSI_OP_LOGOUT_CMD:
+		spin_lock(&cmnd->conn->session->sn_lock);
+		__update_stat_sn(cmnd);
+		rc = check_cmd_sn(cmnd);
+		spin_unlock(&cmnd->conn->session->sn_lock);
+		break;
+	case ISCSI_OP_TEXT_CMD:
+	case ISCSI_OP_SNACK_CMD:
+	default:
+		rc = -ISCSI_REASON_UNSUPPORTED_COMMAND;
+		break;
+	}
+
+	if (unlikely(rc < 0)) {
+		PRINT_ERROR("Error %d (iSCSI opcode %x, ITT %x)", rc,
+			cmnd_opcode(cmnd), cmnd_itt(cmnd));
+		res = create_reject_rsp(cmnd, -rc, true);
+	}
+
+out:
+	return res;
+}
+
+void cmnd_rx_end(struct iscsi_cmnd *cmnd)
+{
+
+	TRACE_DBG("cmnd %p, opcode %x", cmnd, cmnd_opcode(cmnd));
+
+	cmnd->conn->last_rcv_time = jiffies;
+	TRACE_DBG("Updated last_rcv_time %ld", cmnd->conn->last_rcv_time);
+
+	switch (cmnd_opcode(cmnd)) {
+	case ISCSI_OP_SCSI_CMD:
+	case ISCSI_OP_NOP_OUT:
+	case ISCSI_OP_SCSI_TASK_MGT_MSG:
+	case ISCSI_OP_LOGOUT_CMD:
+		iscsi_push_cmnd(cmnd);
+		goto out;
+	case ISCSI_OP_SCSI_DATA_OUT:
+		data_out_end(cmnd);
+		break;
+	default:
+		PRINT_ERROR("Unexpected cmnd op %x", cmnd_opcode(cmnd));
+		break;
+	}
+
+	req_cmnd_release(cmnd);
+
+out:
+	return;
+}
+
+static int iscsi_alloc_data_buf(struct scst_cmd *cmd)
+{
+	/*
+	 * sock->ops->sendpage() is async zero copy operation,
+	 * so we must be sure not to free and reuse
+	 * the command's buffer before the sending was completed
+	 * by the network layers. It is possible only if we
+	 * don't use SGV cache.
+	 */
+	EXTRACHECKS_BUG_ON(!(scst_cmd_get_data_direction(cmd) & SCST_DATA_READ));
+	scst_cmd_set_no_sgv(cmd);
+	return 1;
+}
+
+static void iscsi_preprocessing_done(struct scst_cmd *scst_cmd)
+{
+	struct iscsi_cmnd *req = (struct iscsi_cmnd *)
+				scst_cmd_get_tgt_priv(scst_cmd);
+
+	TRACE_DBG("req %p", req);
+
+	if (req->conn->rx_task == current)
+		req->scst_state = ISCSI_CMD_STATE_AFTER_PREPROC;
+	else {
+		/*
+		 * We wait for the state change without any protection, so
+		 * without cmnd_get() it is possible that req will die
+		 * "immediately" after the state assignment and
+		 * iscsi_make_conn_rd_active() will operate on dead data.
+		 * We use the ordered version of cmnd_get(), because "get"
+		 * must be done before the state assignment.
+		 *
+		 * We protected from the race on calling cmnd_rx_continue(),
+		 * because there can be only one read thread processing
+		 * connection.
+		 */
+		cmnd_get_ordered(req);
+		req->scst_state = ISCSI_CMD_STATE_AFTER_PREPROC;
+		iscsi_make_conn_rd_active(req->conn);
+		if (unlikely(req->conn->closing)) {
+			TRACE_DBG("Waking up closing conn %p", req->conn);
+			wake_up(&req->conn->read_state_waitQ);
+		}
+		cmnd_put(req);
+	}
+
+	return;
+}
+
+/*
+ * No locks.
+ *
+ * IMPORTANT! Connection conn must be protected by additional conn_get()
+ * upon entrance in this function, because otherwise it could be destroyed
+ * inside as a result of iscsi_send(), which releases sent commands.
+ */
+static void iscsi_try_local_processing(struct iscsi_conn *conn)
+{
+	int local;
+
+	spin_lock_bh(&iscsi_wr_lock);
+	switch (conn->wr_state) {
+	case ISCSI_CONN_WR_STATE_IN_LIST:
+		list_del(&conn->wr_list_entry);
+		/* go through */
+	case ISCSI_CONN_WR_STATE_IDLE:
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->wr_task = current;
+#endif
+		conn->wr_state = ISCSI_CONN_WR_STATE_PROCESSING;
+		conn->wr_space_ready = 0;
+		local = 1;
+		break;
+	default:
+		local = 0;
+		break;
+	}
+	spin_unlock_bh(&iscsi_wr_lock);
+
+	if (local) {
+		int rc = 1;
+
+		if (test_write_ready(conn))
+			rc = iscsi_send(conn);
+
+		spin_lock_bh(&iscsi_wr_lock);
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->wr_task = NULL;
+#endif
+		if ((rc <= 0) || test_write_ready(conn)) {
+			list_add_tail(&conn->wr_list_entry, &iscsi_wr_list);
+			conn->wr_state = ISCSI_CONN_WR_STATE_IN_LIST;
+			wake_up(&iscsi_wr_waitQ);
+		} else
+			conn->wr_state = ISCSI_CONN_WR_STATE_IDLE;
+		spin_unlock_bh(&iscsi_wr_lock);
+	}
+	return;
+}
+
+static int iscsi_xmit_response(struct scst_cmd *scst_cmd)
+{
+	int is_send_status = scst_cmd_get_is_send_status(scst_cmd);
+	struct iscsi_cmnd *req = (struct iscsi_cmnd *)
+					scst_cmd_get_tgt_priv(scst_cmd);
+	struct iscsi_conn *conn = req->conn;
+	int status = scst_cmd_get_status(scst_cmd);
+	u8 *sense = scst_cmd_get_sense_buffer(scst_cmd);
+	int sense_len = scst_cmd_get_sense_buffer_len(scst_cmd);
+
+	if (unlikely(scst_cmd_atomic(scst_cmd)))
+		return SCST_TGT_RES_NEED_THREAD_CTX;
+
+	scst_cmd_set_tgt_priv(scst_cmd, NULL);
+
+	EXTRACHECKS_BUG_ON(req->scst_state != ISCSI_CMD_STATE_RESTARTED);
+
+	if (unlikely(scst_cmd_aborted(scst_cmd)))
+		set_bit(ISCSI_CMD_ABORTED, &req->prelim_compl_flags);
+
+	if (unlikely(req->prelim_compl_flags != 0)) {
+		if (test_bit(ISCSI_CMD_ABORTED, &req->prelim_compl_flags)) {
+			TRACE_MGMT_DBG("req %p (scst_cmd %p) aborted", req,
+				req->scst_cmd);
+			scst_set_delivery_status(req->scst_cmd,
+				SCST_CMD_DELIVERY_ABORTED);
+			req->scst_state = ISCSI_CMD_STATE_PROCESSED;
+			req_cmnd_release_force(req);
+			goto out;
+		}
+
+		TRACE_DBG("Prelim completed req %p", req);
+
+		/*
+		 * We could preliminary have finished req before we
+		 * knew its device, so check if we return correct sense
+		 * format.
+		 */
+		scst_check_convert_sense(scst_cmd);
+
+		if (!req->own_sg) {
+			req->sg = scst_cmd_get_sg(scst_cmd);
+			req->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
+		}
+	} else {
+		EXTRACHECKS_BUG_ON(req->own_sg);
+		req->sg = scst_cmd_get_sg(scst_cmd);
+		req->sg_cnt = scst_cmd_get_sg_cnt(scst_cmd);
+	}
+
+	req->bufflen = scst_cmd_get_resp_data_len(scst_cmd);
+
+	req->scst_state = ISCSI_CMD_STATE_PROCESSED;
+
+	TRACE_DBG("req %p, is_send_status=%x, req->bufflen=%d, req->sg=%p, "
+		"req->sg_cnt %d", req, is_send_status, req->bufflen, req->sg,
+		req->sg_cnt);
+
+	EXTRACHECKS_BUG_ON(req->hashed);
+	if (req->main_rsp != NULL)
+		EXTRACHECKS_BUG_ON(cmnd_opcode(req->main_rsp) != ISCSI_OP_REJECT);
+
+	if (unlikely((req->bufflen != 0) && !is_send_status)) {
+		PRINT_CRIT_ERROR("%s", "Sending DATA without STATUS is "
+			"unsupported");
+		scst_set_cmd_error(scst_cmd,
+			SCST_LOAD_SENSE(scst_sense_hardw_error));
+		BUG(); /* ToDo */
+	}
+
+	if (req->bufflen != 0) {
+		/*
+		 * Check above makes sure that is_send_status is set,
+		 * so status is valid here, but in future that could change.
+		 * ToDo
+		 */
+		if ((status != SAM_STAT_CHECK_CONDITION) &&
+		    ((cmnd_hdr(req)->flags & (ISCSI_CMD_WRITE|ISCSI_CMD_READ)) !=
+				(ISCSI_CMD_WRITE|ISCSI_CMD_READ))) {
+			send_data_rsp(req, status, is_send_status);
+		} else {
+			struct iscsi_cmnd *rsp;
+			send_data_rsp(req, 0, 0);
+			if (is_send_status) {
+				rsp = create_status_rsp(req, status, sense,
+					sense_len, true);
+				iscsi_cmnd_init_write(rsp, 0);
+			}
+		}
+	} else if (is_send_status) {
+		struct iscsi_cmnd *rsp;
+		rsp = create_status_rsp(req, status, sense, sense_len, false);
+		iscsi_cmnd_init_write(rsp, 0);
+	}
+#ifdef CONFIG_SCST_EXTRACHECKS
+	else
+		BUG();
+#endif
+
+	/*
+	 * "_ordered" here to protect from reorder, which can lead to
+	 * preliminary connection destroy in req_cmnd_release(). Just in
+	 * case, actually, because reordering shouldn't go so far, but who
+	 * knows..
+	 */
+	conn_get_ordered(conn);
+	req_cmnd_release(req);
+	iscsi_try_local_processing(conn);
+	conn_put(conn);
+
+out:
+	return SCST_TGT_RES_SUCCESS;
+}
+
+/* Called under sn_lock */
+static bool iscsi_is_delay_tm_resp(struct iscsi_cmnd *rsp)
+{
+	bool res = 0;
+	struct iscsi_task_mgt_hdr *req_hdr =
+		(struct iscsi_task_mgt_hdr *)&rsp->parent_req->pdu.bhs;
+	int function = req_hdr->function & ISCSI_FUNCTION_MASK;
+	struct iscsi_session *sess = rsp->conn->session;
+
+	/* This should be checked for immediate TM commands as well */
+
+	switch (function) {
+	default:
+		if (before(sess->exp_cmd_sn, req_hdr->cmd_sn))
+			res = 1;
+		break;
+	}
+	return res;
+}
+
+/* Called under sn_lock, but might drop it inside, then reaquire */
+static void iscsi_check_send_delayed_tm_resp(struct iscsi_session *sess)
+	__acquires(&sn_lock)
+	__releases(&sn_lock)
+{
+	struct iscsi_cmnd *tm_rsp = sess->tm_rsp;
+
+	if (tm_rsp == NULL)
+		goto out;
+
+	if (iscsi_is_delay_tm_resp(tm_rsp))
+		goto out;
+
+	TRACE_MGMT_DBG("Sending delayed rsp %p", tm_rsp);
+
+	sess->tm_rsp = NULL;
+	sess->tm_active--;
+
+	spin_unlock(&sess->sn_lock);
+
+	BUG_ON(sess->tm_active < 0);
+
+	iscsi_cmnd_init_write(tm_rsp, ISCSI_INIT_WRITE_WAKE);
+
+	spin_lock(&sess->sn_lock);
+
+out:
+	return;
+}
+
+static void iscsi_send_task_mgmt_resp(struct iscsi_cmnd *req, int status)
+{
+	struct iscsi_cmnd *rsp;
+	struct iscsi_task_mgt_hdr *req_hdr =
+				(struct iscsi_task_mgt_hdr *)&req->pdu.bhs;
+	struct iscsi_task_rsp_hdr *rsp_hdr;
+	struct iscsi_session *sess = req->conn->session;
+	int fn = req_hdr->function & ISCSI_FUNCTION_MASK;
+
+	TRACE_MGMT_DBG("TM req %p finished", req);
+	TRACE(TRACE_MGMT, "TM fn %d finished, status %d", fn, status);
+
+	rsp = iscsi_alloc_rsp(req);
+	rsp_hdr = (struct iscsi_task_rsp_hdr *)&rsp->pdu.bhs;
+
+	rsp_hdr->opcode = ISCSI_OP_SCSI_TASK_MGT_RSP;
+	rsp_hdr->flags = ISCSI_FLG_FINAL;
+	rsp_hdr->itt = req_hdr->itt;
+	rsp_hdr->response = status;
+
+	if (fn == ISCSI_FUNCTION_TARGET_COLD_RESET) {
+		rsp->should_close_conn = 1;
+		rsp->should_close_all_conn = 1;
+	}
+
+	BUG_ON(sess->tm_rsp != NULL);
+
+	spin_lock(&sess->sn_lock);
+	if (iscsi_is_delay_tm_resp(rsp)) {
+		TRACE_MGMT_DBG("Delaying TM fn %d response %p "
+			"(req %p), because not all affected commands "
+			"received (TM cmd sn %u, exp sn %u)",
+			req_hdr->function & ISCSI_FUNCTION_MASK, rsp, req,
+			req_hdr->cmd_sn, sess->exp_cmd_sn);
+		sess->tm_rsp = rsp;
+		spin_unlock(&sess->sn_lock);
+		goto out_release;
+	}
+	sess->tm_active--;
+	spin_unlock(&sess->sn_lock);
+
+	BUG_ON(sess->tm_active < 0);
+
+	iscsi_cmnd_init_write(rsp, ISCSI_INIT_WRITE_WAKE);
+
+out_release:
+	req_cmnd_release(req);
+	return;
+}
+
+static inline int iscsi_get_mgmt_response(int status)
+{
+	switch (status) {
+	case SCST_MGMT_STATUS_SUCCESS:
+		return ISCSI_RESPONSE_FUNCTION_COMPLETE;
+
+	case SCST_MGMT_STATUS_TASK_NOT_EXIST:
+		return ISCSI_RESPONSE_UNKNOWN_TASK;
+
+	case SCST_MGMT_STATUS_LUN_NOT_EXIST:
+		return ISCSI_RESPONSE_UNKNOWN_LUN;
+
+	case SCST_MGMT_STATUS_FN_NOT_SUPPORTED:
+		return ISCSI_RESPONSE_FUNCTION_UNSUPPORTED;
+
+	case SCST_MGMT_STATUS_REJECTED:
+	case SCST_MGMT_STATUS_FAILED:
+	default:
+		return ISCSI_RESPONSE_FUNCTION_REJECTED;
+	}
+}
+
+static void iscsi_task_mgmt_fn_done(struct scst_mgmt_cmd *scst_mcmd)
+{
+	int fn = scst_mgmt_cmd_get_fn(scst_mcmd);
+	struct iscsi_cmnd *req = (struct iscsi_cmnd *)
+				scst_mgmt_cmd_get_tgt_priv(scst_mcmd);
+	int status =
+		iscsi_get_mgmt_response(scst_mgmt_cmd_get_status(scst_mcmd));
+
+	if ((status == ISCSI_RESPONSE_UNKNOWN_TASK) &&
+	    (fn == SCST_ABORT_TASK)) {
+		/* If we are here, we found the task, so must succeed */
+		status = ISCSI_RESPONSE_FUNCTION_COMPLETE;
+	}
+
+	TRACE_MGMT_DBG("req %p, scst_mcmd %p, fn %d, scst status %d, status %d",
+		req, scst_mcmd, fn, scst_mgmt_cmd_get_status(scst_mcmd),
+		status);
+
+	switch (fn) {
+	case SCST_NEXUS_LOSS_SESS:
+	case SCST_ABORT_ALL_TASKS_SESS:
+		/* They are internal */
+		break;
+	default:
+		iscsi_send_task_mgmt_resp(req, status);
+		scst_mgmt_cmd_set_tgt_priv(scst_mcmd, NULL);
+		break;
+	}
+	return;
+}
+
+static int iscsi_scsi_aen(struct scst_aen *aen)
+{
+	int res = SCST_AEN_RES_SUCCESS;
+	uint64_t lun = scst_aen_get_lun(aen);
+	const uint8_t *sense = scst_aen_get_sense(aen);
+	int sense_len = scst_aen_get_sense_len(aen);
+	struct iscsi_session *sess = scst_sess_get_tgt_priv(
+					scst_aen_get_sess(aen));
+	struct iscsi_conn *conn;
+	bool found;
+	struct iscsi_cmnd *fake_req, *rsp;
+	struct iscsi_async_msg_hdr *rsp_hdr;
+	struct scatterlist *sg;
+
+	TRACE_MGMT_DBG("SCSI AEN to sess %p (initiator %s)", sess,
+		sess->initiator_name);
+
+	mutex_lock(&sess->target->target_mutex);
+
+	found = false;
+	list_for_each_entry_reverse(conn, &sess->conn_list, conn_list_entry) {
+		if (!test_bit(ISCSI_CONN_SHUTTINGDOWN, &conn->conn_aflags) &&
+		    (conn->conn_reinst_successor == NULL)) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		TRACE_MGMT_DBG("Unable to find alive conn for sess %p", sess);
+		goto out_err;
+	}
+
+	/* Create a fake request */
+	fake_req = cmnd_alloc(conn, NULL);
+	if (fake_req == NULL) {
+		PRINT_ERROR("%s", "Unable to alloc fake AEN request");
+		goto out_err;
+	}
+
+	mutex_unlock(&sess->target->target_mutex);
+
+	rsp = iscsi_alloc_main_rsp(fake_req);
+	if (rsp == NULL) {
+		PRINT_ERROR("%s", "Unable to alloc AEN rsp");
+		goto out_err_free_req;
+	}
+
+	fake_req->scst_state = ISCSI_CMD_STATE_AEN;
+	fake_req->scst_aen = aen;
+
+	rsp_hdr = (struct iscsi_async_msg_hdr *)&rsp->pdu.bhs;
+
+	rsp_hdr->opcode = ISCSI_OP_ASYNC_MSG;
+	rsp_hdr->flags = ISCSI_FLG_FINAL;
+	rsp_hdr->lun = lun; /* it's already in SCSI form */
+	rsp_hdr->ffffffff = 0xffffffff;
+	rsp_hdr->async_event = ISCSI_ASYNC_SCSI;
+
+	sg = rsp->sg = rsp->rsp_sg;
+	rsp->sg_cnt = 2;
+	rsp->own_sg = 1;
+
+	sg_init_table(sg, 2);
+	sg_set_buf(&sg[0], &rsp->sense_hdr, sizeof(rsp->sense_hdr));
+	sg_set_buf(&sg[1], sense, sense_len);
+
+	rsp->sense_hdr.length = cpu_to_be16(sense_len);
+	rsp->pdu.datasize = sizeof(rsp->sense_hdr) + sense_len;
+	rsp->bufflen = rsp->pdu.datasize;
+
+	req_cmnd_release(fake_req);
+
+out:
+	return res;
+
+out_err_free_req:
+	req_cmnd_release(fake_req);
+
+out_err:
+	mutex_unlock(&sess->target->target_mutex);
+	res = SCST_AEN_RES_FAILED;
+	goto out;
+}
+
+static int iscsi_report_aen(struct scst_aen *aen)
+{
+	int res;
+	int event_fn = scst_aen_get_event_fn(aen);
+
+	switch (event_fn) {
+	case SCST_AEN_SCSI:
+		res = iscsi_scsi_aen(aen);
+		break;
+	default:
+		TRACE_MGMT_DBG("Unsupported AEN %d", event_fn);
+		res = SCST_AEN_RES_NOT_SUPPORTED;
+		break;
+	}
+	return res;
+}
+
+void iscsi_send_nop_in(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *req, *rsp;
+	struct iscsi_nop_in_hdr *rsp_hdr;
+
+	req = cmnd_alloc(conn, NULL);
+	if (req == NULL) {
+		PRINT_ERROR("%s", "Unable to alloc fake Nop-In request");
+		goto out_err;
+	}
+
+	rsp = iscsi_alloc_main_rsp(req);
+	if (rsp == NULL) {
+		PRINT_ERROR("%s", "Unable to alloc Nop-In rsp");
+		goto out_err_free_req;
+	}
+
+	cmnd_get(rsp);
+
+	rsp_hdr = (struct iscsi_nop_in_hdr *)&rsp->pdu.bhs;
+	rsp_hdr->opcode = ISCSI_OP_NOP_IN;
+	rsp_hdr->flags = ISCSI_FLG_FINAL;
+	rsp_hdr->itt = cpu_to_be32(ISCSI_RESERVED_TAG);
+	rsp_hdr->ttt = conn->nop_in_ttt++;
+
+	if (conn->nop_in_ttt == cpu_to_be32(ISCSI_RESERVED_TAG))
+		conn->nop_in_ttt = 0;
+
+	/* Supposed that all other fields are zeroed */
+
+	TRACE_DBG("Sending Nop-In request (ttt 0x%08x)", rsp_hdr->ttt);
+	spin_lock_bh(&conn->nop_req_list_lock);
+	list_add_tail(&rsp->nop_req_list_entry, &conn->nop_req_list);
+	spin_unlock_bh(&conn->nop_req_list_lock);
+
+out_err_free_req:
+	req_cmnd_release(req);
+
+out_err:
+	return;
+}
+
+static int iscsi_target_detect(struct scst_tgt_template *templ)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static int iscsi_target_release(struct scst_tgt *scst_tgt)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static struct scst_trace_log iscsi_local_trace_tbl[] = {
+    { TRACE_D_WRITE,		"d_write" },
+    { TRACE_CONN_OC,		"conn" },
+    { TRACE_CONN_OC_DBG,	"conn_dbg" },
+    { TRACE_D_IOV,		"iov" },
+    { TRACE_D_DUMP_PDU,		"pdu" },
+    { TRACE_NET_PG,		"net_page" },
+    { 0,			NULL }
+};
+
+#define ISCSI_TRACE_TLB_HELP	", d_read, d_write, conn, conn_dbg, iov, pdu, net_page"
+
+#define ISCSI_MGMT_CMD_HELP	\
+	"       echo \"add_attribute IncomingUser name password\" >mgmt\n" \
+	"       echo \"del_attribute IncomingUser name\" >mgmt\n" \
+	"       echo \"add_attribute OutgoingUser name password\" >mgmt\n" \
+	"       echo \"del_attribute OutgoingUser name\" >mgmt\n" \
+	"       echo \"add_target_attribute target_name IncomingUser name password\" >mgmt\n" \
+	"       echo \"del_target_attribute target_name IncomingUser name\" >mgmt\n" \
+	"       echo \"add_target_attribute target_name OutgoingUser name password\" >mgmt\n" \
+	"       echo \"del_target_attribute target_name OutgoingUser name\" >mgmt\n"
+
+struct scst_tgt_template iscsi_template = {
+	.name = "iscsi",
+	.sg_tablesize = 0xFFFF /* no limit */,
+	.threads_num = 0,
+	.no_clustering = 1,
+	.xmit_response_atomic = 0,
+	.tgtt_attrs = iscsi_attrs,
+	.tgt_attrs = iscsi_tgt_attrs,
+	.sess_attrs = iscsi_sess_attrs,
+	.enable_target = iscsi_enable_target,
+	.is_target_enabled = iscsi_is_target_enabled,
+	.add_target = iscsi_sysfs_add_target,
+	.del_target = iscsi_sysfs_del_target,
+	.mgmt_cmd = iscsi_sysfs_mgmt_cmd,
+	.mgmt_cmd_help = ISCSI_MGMT_CMD_HELP,
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	.default_trace_flags = ISCSI_DEFAULT_LOG_FLAGS,
+	.trace_flags = &trace_flag,
+	.trace_tbl = iscsi_local_trace_tbl,
+	.trace_tbl_help = ISCSI_TRACE_TLB_HELP,
+#endif
+	.detect = iscsi_target_detect,
+	.release = iscsi_target_release,
+	.xmit_response = iscsi_xmit_response,
+	.alloc_data_buf = iscsi_alloc_data_buf,
+	.preprocessing_done = iscsi_preprocessing_done,
+	.pre_exec = iscsi_pre_exec,
+	.task_mgmt_affected_cmds_done = iscsi_task_mgmt_affected_cmds_done,
+	.task_mgmt_fn_done = iscsi_task_mgmt_fn_done,
+	.report_aen = iscsi_report_aen,
+};
+
+static __init int iscsi_run_threads(int count, char *name, int (*fn)(void *))
+{
+	int res = 0;
+	int i;
+	struct iscsi_thread_t *thr;
+
+	for (i = 0; i < count; i++) {
+		thr = kmalloc(sizeof(*thr), GFP_KERNEL);
+		if (!thr) {
+			res = -ENOMEM;
+			PRINT_ERROR("Failed to allocate thr %d", res);
+			goto out;
+		}
+		thr->thr = kthread_run(fn, NULL, "%s%d", name, i);
+		if (IS_ERR(thr->thr)) {
+			res = PTR_ERR(thr->thr);
+			PRINT_ERROR("kthread_create() failed: %d", res);
+			kfree(thr);
+			goto out;
+		}
+		list_add_tail(&thr->threads_list_entry, &iscsi_threads_list);
+	}
+
+out:
+	return res;
+}
+
+static void iscsi_stop_threads(void)
+{
+	struct iscsi_thread_t *t, *tmp;
+
+	list_for_each_entry_safe(t, tmp, &iscsi_threads_list,
+				threads_list_entry) {
+		int rc = kthread_stop(t->thr);
+		if (rc < 0)
+			TRACE_MGMT_DBG("kthread_stop() failed: %d", rc);
+		list_del(&t->threads_list_entry);
+		kfree(t);
+	}
+	return;
+}
+
+static int __init iscsi_init(void)
+{
+	int err = 0;
+	int num;
+
+	PRINT_INFO("iSCSI SCST Target - version %s", ISCSI_VERSION_STRING);
+
+	dummy_page = alloc_pages(GFP_KERNEL, 0);
+	if (dummy_page == NULL) {
+		PRINT_ERROR("%s", "Dummy page allocation failed");
+		goto out;
+	}
+
+	sg_init_table(&dummy_sg, 1);
+	sg_set_page(&dummy_sg, dummy_page, PAGE_SIZE, 0);
+
+	ctr_major = register_chrdev(0, ctr_name, &ctr_fops);
+	if (ctr_major < 0) {
+		PRINT_ERROR("failed to register the control device %d",
+			    ctr_major);
+		err = ctr_major;
+		goto out_callb;
+	}
+
+	err = event_init();
+	if (err < 0)
+		goto out_reg;
+
+	iscsi_cmnd_cache = KMEM_CACHE(iscsi_cmnd, SCST_SLAB_FLAGS);
+	if (!iscsi_cmnd_cache) {
+		err = -ENOMEM;
+		goto out_event;
+	}
+
+	err = scst_register_target_template(&iscsi_template);
+	if (err < 0)
+		goto out_kmem;
+
+	num = max((int)num_online_cpus(), 2);
+
+	err = iscsi_run_threads(num, "iscsird", istrd);
+	if (err != 0)
+		goto out_thr;
+
+	err = iscsi_run_threads(num, "iscsiwr", istwr);
+	if (err != 0)
+		goto out_thr;
+
+out:
+	return err;
+
+out_thr:
+	iscsi_stop_threads();
+
+	scst_unregister_target_template(&iscsi_template);
+
+out_kmem:
+	kmem_cache_destroy(iscsi_cmnd_cache);
+
+out_event:
+	event_exit();
+
+out_reg:
+	unregister_chrdev(ctr_major, ctr_name);
+
+out_callb:
+	__free_pages(dummy_page, 0);
+	goto out;
+}
+
+static void __exit iscsi_exit(void)
+{
+	iscsi_stop_threads();
+
+	unregister_chrdev(ctr_major, ctr_name);
+
+	event_exit();
+
+	kmem_cache_destroy(iscsi_cmnd_cache);
+
+	scst_unregister_target_template(&iscsi_template);
+
+	__free_pages(dummy_page, 0);
+	return;
+}
+
+module_init(iscsi_init);
+module_exit(iscsi_exit);
+
+MODULE_LICENSE("GPL");
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/nthread.c linux-2.6.33/drivers/scst/iscsi-scst/nthread.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/nthread.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/nthread.c
@@ -0,0 +1,1524 @@
+/*
+ *  Network threads.
+ *
+ *  Copyright (C) 2004 - 2005 FUJITA Tomonori <tomof@acm.org>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/file.h>
+#include <linux/kthread.h>
+#include <asm/ioctls.h>
+#include <linux/delay.h>
+#include <net/tcp.h>
+
+#include "iscsi.h"
+#include "digest.h"
+
+enum rx_state {
+	RX_INIT_BHS, /* Must be zero for better "switch" optimization. */
+	RX_BHS,
+	RX_CMD_START,
+	RX_DATA,
+	RX_END,
+
+	RX_CMD_CONTINUE,
+	RX_INIT_HDIGEST,
+	RX_CHECK_HDIGEST,
+	RX_INIT_DDIGEST,
+	RX_CHECK_DDIGEST,
+	RX_AHS,
+	RX_PADDING,
+};
+
+enum tx_state {
+	TX_INIT = 0, /* Must be zero for better "switch" optimization. */
+	TX_BHS_DATA,
+	TX_INIT_PADDING,
+	TX_PADDING,
+	TX_INIT_DDIGEST,
+	TX_DDIGEST,
+	TX_END,
+};
+
+static inline void iscsi_check_closewait(struct iscsi_conn *conn) {};
+
+static void free_pending_commands(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = conn->session;
+	struct list_head *pending_list = &session->pending_list;
+	int req_freed;
+	struct iscsi_cmnd *cmnd;
+
+	spin_lock(&session->sn_lock);
+	do {
+		req_freed = 0;
+		list_for_each_entry(cmnd, pending_list, pending_list_entry) {
+			TRACE_CONN_CLOSE_DBG("Pending cmd %p"
+				"(conn %p, cmd_sn %u, exp_cmd_sn %u)",
+				cmnd, conn, cmnd->pdu.bhs.sn,
+				session->exp_cmd_sn);
+			if ((cmnd->conn == conn) &&
+			    (session->exp_cmd_sn == cmnd->pdu.bhs.sn)) {
+				TRACE_CONN_CLOSE_DBG("Freeing pending cmd %p",
+					cmnd);
+
+				list_del(&cmnd->pending_list_entry);
+				cmnd->pending = 0;
+
+				session->exp_cmd_sn++;
+
+				spin_unlock(&session->sn_lock);
+
+				req_cmnd_release_force(cmnd);
+
+				req_freed = 1;
+				spin_lock(&session->sn_lock);
+				break;
+			}
+		}
+	} while (req_freed);
+	spin_unlock(&session->sn_lock);
+
+	return;
+}
+
+static void free_orphaned_pending_commands(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = conn->session;
+	struct list_head *pending_list = &session->pending_list;
+	int req_freed;
+	struct iscsi_cmnd *cmnd;
+
+	spin_lock(&session->sn_lock);
+	do {
+		req_freed = 0;
+		list_for_each_entry(cmnd, pending_list, pending_list_entry) {
+			TRACE_CONN_CLOSE_DBG("Pending cmd %p"
+				"(conn %p, cmd_sn %u, exp_cmd_sn %u)",
+				cmnd, conn, cmnd->pdu.bhs.sn,
+				session->exp_cmd_sn);
+			if (cmnd->conn == conn) {
+				PRINT_ERROR("Freeing orphaned pending cmd %p",
+					    cmnd);
+
+				list_del(&cmnd->pending_list_entry);
+				cmnd->pending = 0;
+
+				if (session->exp_cmd_sn == cmnd->pdu.bhs.sn)
+					session->exp_cmd_sn++;
+
+				spin_unlock(&session->sn_lock);
+
+				req_cmnd_release_force(cmnd);
+
+				req_freed = 1;
+				spin_lock(&session->sn_lock);
+				break;
+			}
+		}
+	} while (req_freed);
+	spin_unlock(&session->sn_lock);
+
+	return;
+}
+
+#ifdef CONFIG_SCST_DEBUG
+static void trace_conn_close(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd;
+
+#if 0
+	if (time_after(jiffies, start_waiting + 10*HZ))
+		trace_flag |= TRACE_CONN_OC_DBG;
+#endif
+
+	spin_lock_bh(&conn->cmd_list_lock);
+	list_for_each_entry(cmnd, &conn->cmd_list,
+			cmd_list_entry) {
+		TRACE_CONN_CLOSE_DBG(
+			"cmd %p, scst_cmd %p, scst_state %x, scst_cmd state "
+			"%d, r2t_len_to_receive %d, ref_cnt %d, sn %u, "
+			"parent_req %p, pending %d",
+			cmnd, cmnd->scst_cmd, cmnd->scst_state,
+			((cmnd->parent_req == NULL) && cmnd->scst_cmd) ?
+				cmnd->scst_cmd->state : -1,
+			cmnd->r2t_len_to_receive, atomic_read(&cmnd->ref_cnt),
+			cmnd->pdu.bhs.sn, cmnd->parent_req, cmnd->pending);
+	}
+	spin_unlock_bh(&conn->cmd_list_lock);
+	return;
+}
+#else /* CONFIG_SCST_DEBUG */
+static void trace_conn_close(struct iscsi_conn *conn) {}
+#endif /* CONFIG_SCST_DEBUG */
+
+void iscsi_task_mgmt_affected_cmds_done(struct scst_mgmt_cmd *scst_mcmd)
+{
+	int fn = scst_mgmt_cmd_get_fn(scst_mcmd);
+	void *priv = scst_mgmt_cmd_get_tgt_priv(scst_mcmd);
+
+	TRACE_MGMT_DBG("scst_mcmd %p, fn %d, priv %p", scst_mcmd, fn, priv);
+
+	switch (fn) {
+	case SCST_NEXUS_LOSS_SESS:
+	case SCST_ABORT_ALL_TASKS_SESS:
+	{
+		struct iscsi_conn *conn = (struct iscsi_conn *)priv;
+		struct iscsi_session *sess = conn->session;
+		struct iscsi_conn *c;
+
+		mutex_lock(&sess->target->target_mutex);
+
+		/*
+		 * We can't mark sess as shutting down earlier, because until
+		 * now it might have pending commands. Otherwise, in case of
+		 * reinstatement it might lead to data corruption, because
+		 * commands in being reinstated session can be executed
+		 * after commands in the new session.
+		 */
+		sess->sess_shutting_down = 1;
+		list_for_each_entry(c, &sess->conn_list, conn_list_entry) {
+			if (!test_bit(ISCSI_CONN_SHUTTINGDOWN, &c->conn_aflags)) {
+				sess->sess_shutting_down = 0;
+				break;
+			}
+		}
+
+		if (conn->conn_reinst_successor != NULL) {
+			BUG_ON(!test_bit(ISCSI_CONN_REINSTATING,
+				  &conn->conn_reinst_successor->conn_aflags));
+			conn_reinst_finished(conn->conn_reinst_successor);
+			conn->conn_reinst_successor = NULL;
+		} else if (sess->sess_reinst_successor != NULL) {
+			sess_reinst_finished(sess->sess_reinst_successor);
+			sess->sess_reinst_successor = NULL;
+		}
+		mutex_unlock(&sess->target->target_mutex);
+
+		complete_all(&conn->ready_to_free);
+		break;
+	}
+	default:
+		/* Nothing to do */
+		break;
+	}
+
+	return;
+}
+
+/* No locks */
+static void close_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session = conn->session;
+	struct iscsi_target *target = conn->target;
+	typeof(jiffies) start_waiting = jiffies;
+	typeof(jiffies) shut_start_waiting = start_waiting;
+	bool pending_reported = 0, wait_expired = 0, shut_expired = 0;
+	bool reinst;
+
+#define CONN_PENDING_TIMEOUT	((typeof(jiffies))10*HZ)
+#define CONN_WAIT_TIMEOUT	((typeof(jiffies))10*HZ)
+#define CONN_REG_SHUT_TIMEOUT	((typeof(jiffies))125*HZ)
+#define CONN_DEL_SHUT_TIMEOUT	((typeof(jiffies))10*HZ)
+
+	TRACE_MGMT_DBG("Closing connection %p (conn_ref_cnt=%d)", conn,
+		atomic_read(&conn->conn_ref_cnt));
+
+	iscsi_extracheck_is_rd_thread(conn);
+
+	BUG_ON(!conn->closing);
+
+	if (conn->active_close) {
+		/* We want all our already send operations to complete */
+		conn->sock->ops->shutdown(conn->sock, RCV_SHUTDOWN);
+	} else {
+		conn->sock->ops->shutdown(conn->sock,
+			RCV_SHUTDOWN|SEND_SHUTDOWN);
+	}
+
+	mutex_lock(&session->target->target_mutex);
+
+	set_bit(ISCSI_CONN_SHUTTINGDOWN, &conn->conn_aflags);
+	reinst = (conn->conn_reinst_successor != NULL);
+
+	mutex_unlock(&session->target->target_mutex);
+
+	if (reinst) {
+		int rc;
+		int lun = 0;
+
+		/* Abort all outstanding commands */
+		rc = scst_rx_mgmt_fn_lun(session->scst_sess,
+			SCST_ABORT_ALL_TASKS_SESS, (uint8_t *)&lun, sizeof(lun),
+			SCST_NON_ATOMIC, conn);
+		if (rc != 0)
+			PRINT_ERROR("SCST_ABORT_ALL_TASKS_SESS failed %d", rc);
+	} else {
+		int rc;
+		int lun = 0;
+
+		rc = scst_rx_mgmt_fn_lun(session->scst_sess,
+			SCST_NEXUS_LOSS_SESS, (uint8_t *)&lun, sizeof(lun),
+			SCST_NON_ATOMIC, conn);
+		if (rc != 0)
+			PRINT_ERROR("SCST_NEXUS_LOSS_SESS failed %d", rc);
+	}
+
+	if (conn->read_state != RX_INIT_BHS) {
+		struct iscsi_cmnd *cmnd = conn->read_cmnd;
+
+		if (cmnd->scst_state == ISCSI_CMD_STATE_RX_CMD) {
+			TRACE_CONN_CLOSE_DBG("Going to wait for cmnd %p to "
+				"change state from RX_CMD", cmnd);
+		}
+		wait_event(conn->read_state_waitQ,
+			cmnd->scst_state != ISCSI_CMD_STATE_RX_CMD);
+
+		TRACE_CONN_CLOSE_DBG("Releasing conn->read_cmnd %p (conn %p)",
+			conn->read_cmnd, conn);
+
+		conn->read_cmnd = NULL;
+		conn->read_state = RX_INIT_BHS;
+		req_cmnd_release_force(cmnd);
+	}
+
+	conn_abort(conn);
+
+	/* ToDo: not the best way to wait */
+	while (atomic_read(&conn->conn_ref_cnt) != 0) {
+		if (conn->conn_tm_active)
+			iscsi_check_tm_data_wait_timeouts(conn, true);
+
+		mutex_lock(&target->target_mutex);
+		spin_lock(&session->sn_lock);
+		if (session->tm_rsp && session->tm_rsp->conn == conn) {
+			struct iscsi_cmnd *tm_rsp = session->tm_rsp;
+			TRACE_MGMT_DBG("Dropping delayed TM rsp %p", tm_rsp);
+			session->tm_rsp = NULL;
+			session->tm_active--;
+			WARN_ON(session->tm_active < 0);
+			spin_unlock(&session->sn_lock);
+			mutex_unlock(&target->target_mutex);
+
+			rsp_cmnd_release(tm_rsp);
+		} else {
+			spin_unlock(&session->sn_lock);
+			mutex_unlock(&target->target_mutex);
+		}
+
+		/* It's safe to check it without sn_lock */
+		if (!list_empty(&session->pending_list)) {
+			TRACE_CONN_CLOSE_DBG("Disposing pending commands on "
+				"connection %p (conn_ref_cnt=%d)", conn,
+				atomic_read(&conn->conn_ref_cnt));
+
+			free_pending_commands(conn);
+
+			if (time_after(jiffies,
+				start_waiting + CONN_PENDING_TIMEOUT)) {
+				if (!pending_reported) {
+					TRACE_CONN_CLOSE("%s",
+						"Pending wait time expired");
+					pending_reported = 1;
+				}
+				free_orphaned_pending_commands(conn);
+			}
+		}
+
+		iscsi_make_conn_wr_active(conn);
+
+		/* That's for active close only, actually */
+		if (time_after(jiffies, start_waiting + CONN_WAIT_TIMEOUT) &&
+		    !wait_expired) {
+			TRACE_CONN_CLOSE("Wait time expired (conn %p, "
+				"sk_state %d)",
+				conn, conn->sock->sk->sk_state);
+			conn->sock->ops->shutdown(conn->sock, SEND_SHUTDOWN);
+			wait_expired = 1;
+			shut_start_waiting = jiffies;
+		}
+
+		if (wait_expired && !shut_expired &&
+		    time_after(jiffies, shut_start_waiting +
+				conn->deleting ? CONN_DEL_SHUT_TIMEOUT :
+						 CONN_REG_SHUT_TIMEOUT)) {
+			TRACE_CONN_CLOSE("Wait time after shutdown expired "
+				"(conn %p, sk_state %d)", conn,
+				conn->sock->sk->sk_state);
+			conn->sock->sk->sk_prot->disconnect(conn->sock->sk, 0);
+			shut_expired = 1;
+		}
+
+		if (conn->deleting)
+			msleep(200);
+		else
+			msleep(1000);
+
+		TRACE_CONN_CLOSE_DBG("conn %p, conn_ref_cnt %d left, "
+			"wr_state %d, exp_cmd_sn %u",
+			conn, atomic_read(&conn->conn_ref_cnt),
+			conn->wr_state, session->exp_cmd_sn);
+
+		trace_conn_close(conn);
+
+		iscsi_check_closewait(conn);
+	}
+
+	write_lock_bh(&conn->sock->sk->sk_callback_lock);
+	conn->sock->sk->sk_state_change = conn->old_state_change;
+	conn->sock->sk->sk_data_ready = conn->old_data_ready;
+	conn->sock->sk->sk_write_space = conn->old_write_space;
+	write_unlock_bh(&conn->sock->sk->sk_callback_lock);
+
+	while (1) {
+		bool t;
+
+		spin_lock_bh(&iscsi_wr_lock);
+		t = (conn->wr_state == ISCSI_CONN_WR_STATE_IDLE);
+		spin_unlock_bh(&iscsi_wr_lock);
+
+		if (t && (atomic_read(&conn->conn_ref_cnt) == 0))
+			break;
+
+		TRACE_CONN_CLOSE_DBG("Waiting for wr thread (conn %p), "
+			"wr_state %x", conn, conn->wr_state);
+		msleep(50);
+	}
+
+	wait_for_completion(&conn->ready_to_free);
+
+	TRACE_CONN_CLOSE("Notifying user space about closing connection %p",
+			 conn);
+	event_send(target->tid, session->sid, conn->cid, 0, E_CONN_CLOSE,
+		NULL, NULL);
+
+	kobject_put(&conn->iscsi_conn_kobj);
+	return;
+}
+
+static int close_conn_thr(void *arg)
+{
+	struct iscsi_conn *conn = (struct iscsi_conn *)arg;
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	/*
+	 * To satisfy iscsi_extracheck_is_rd_thread() in functions called
+	 * on the connection close. It is safe, because at this point conn
+	 * can't be used by any other thread.
+	 */
+	conn->rd_task = current;
+#endif
+	close_conn(conn);
+	return 0;
+}
+
+/* No locks */
+static void start_close_conn(struct iscsi_conn *conn)
+{
+	struct task_struct *t;
+
+	t = kthread_run(close_conn_thr, conn, "iscsi_conn_cleanup");
+	if (IS_ERR(t)) {
+		PRINT_ERROR("kthread_run() failed (%ld), closing conn %p "
+			"directly", PTR_ERR(t), conn);
+		close_conn(conn);
+	}
+	return;
+}
+
+static inline void iscsi_conn_init_read(struct iscsi_conn *conn,
+	void __user *data, size_t len)
+{
+	conn->read_iov[0].iov_base = data;
+	conn->read_iov[0].iov_len = len;
+	conn->read_msg.msg_iov = conn->read_iov;
+	conn->read_msg.msg_iovlen = 1;
+	conn->read_size = len;
+	return;
+}
+
+static void iscsi_conn_prepare_read_ahs(struct iscsi_conn *conn,
+	struct iscsi_cmnd *cmnd)
+{
+	int asize = (cmnd->pdu.ahssize + 3) & -4;
+
+	/* ToDo: __GFP_NOFAIL ?? */
+	cmnd->pdu.ahs = kmalloc(asize, __GFP_NOFAIL|GFP_KERNEL);
+	BUG_ON(cmnd->pdu.ahs == NULL);
+	iscsi_conn_init_read(conn, (void __force __user *)cmnd->pdu.ahs, asize);
+	return;
+}
+
+static struct iscsi_cmnd *iscsi_get_send_cmnd(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd = NULL;
+
+	spin_lock_bh(&conn->write_list_lock);
+	if (!list_empty(&conn->write_list)) {
+		cmnd = list_entry(conn->write_list.next, struct iscsi_cmnd,
+				write_list_entry);
+		cmd_del_from_write_list(cmnd);
+		cmnd->write_processing_started = 1;
+	}
+	spin_unlock_bh(&conn->write_list_lock);
+
+	if (unlikely(test_bit(ISCSI_CMD_ABORTED,
+			&cmnd->parent_req->prelim_compl_flags))) {
+		TRACE_MGMT_DBG("Going to send acmd %p (scst cmd %p, "
+			"state %d, parent_req %p)", cmnd, cmnd->scst_cmd,
+			cmnd->scst_state, cmnd->parent_req);
+	}
+
+	if (unlikely(cmnd_opcode(cmnd) == ISCSI_OP_SCSI_TASK_MGT_RSP)) {
+#ifdef CONFIG_SCST_DEBUG
+		struct iscsi_task_mgt_hdr *req_hdr =
+			(struct iscsi_task_mgt_hdr *)&cmnd->parent_req->pdu.bhs;
+		struct iscsi_task_rsp_hdr *rsp_hdr =
+			(struct iscsi_task_rsp_hdr *)&cmnd->pdu.bhs;
+		TRACE_MGMT_DBG("Going to send TM response %p (status %d, "
+			"fn %d, parent_req %p)", cmnd, rsp_hdr->response,
+			req_hdr->function & ISCSI_FUNCTION_MASK,
+			cmnd->parent_req);
+#endif
+	}
+
+	return cmnd;
+}
+
+/* Returns number of bytes left to receive or <0 for error */
+static int do_recv(struct iscsi_conn *conn)
+{
+	int res;
+	mm_segment_t oldfs;
+	struct msghdr msg;
+	int first_len;
+
+	EXTRACHECKS_BUG_ON(conn->read_cmnd == NULL);
+
+	if (unlikely(conn->closing)) {
+		res = -EIO;
+		goto out;
+	}
+
+	/*
+	 * We suppose that if sock_recvmsg() returned less data than requested,
+	 * then next time it will return -EAGAIN, so there's no point to call
+	 * it again.
+	 */
+
+restart:
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_iov = conn->read_msg.msg_iov;
+	msg.msg_iovlen = conn->read_msg.msg_iovlen;
+	first_len = msg.msg_iov->iov_len;
+
+	oldfs = get_fs();
+	set_fs(get_ds());
+	res = sock_recvmsg(conn->sock, &msg, conn->read_size,
+			   MSG_DONTWAIT | MSG_NOSIGNAL);
+	set_fs(oldfs);
+
+	if (res > 0) {
+		/*
+		 * To save some considerable effort and CPU power we
+		 * suppose that TCP functions adjust
+		 * conn->read_msg.msg_iov and conn->read_msg.msg_iovlen
+		 * on amount of copied data. This BUG_ON is intended
+		 * to catch if it is changed in the future.
+		 */
+		BUG_ON((res >= first_len) &&
+			(conn->read_msg.msg_iov->iov_len != 0));
+		conn->read_size -= res;
+		if (conn->read_size != 0) {
+			if (res >= first_len) {
+				int done = 1 + ((res - first_len) >> PAGE_SHIFT);
+				conn->read_msg.msg_iov += done;
+				conn->read_msg.msg_iovlen -= done;
+			}
+		}
+		res = conn->read_size;
+	} else {
+		switch (res) {
+		case -EAGAIN:
+			TRACE_DBG("EAGAIN received for conn %p", conn);
+			res = conn->read_size;
+			break;
+		case -ERESTARTSYS:
+			TRACE_DBG("ERESTARTSYS received for conn %p", conn);
+			goto restart;
+		default:
+			if (!conn->closing) {
+				PRINT_ERROR("sock_recvmsg() failed: %d", res);
+				mark_conn_closed(conn);
+			}
+			if (res == 0)
+				res = -EIO;
+			break;
+		}
+	}
+
+out:
+	return res;
+}
+
+static int iscsi_rx_check_ddigest(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd = conn->read_cmnd;
+	int res;
+
+	res = do_recv(conn);
+	if (res == 0) {
+		conn->read_state = RX_END;
+
+		if (cmnd->pdu.datasize <= 16*1024) {
+			/*
+			 * It's cache hot, so let's compute it inline. The
+			 * choice here about what will expose more latency:
+			 * possible cache misses or the digest calculation.
+			 */
+			TRACE_DBG("cmnd %p, opcode %x: checking RX "
+				"ddigest inline", cmnd, cmnd_opcode(cmnd));
+			cmnd->ddigest_checked = 1;
+			res = digest_rx_data(cmnd);
+			if (unlikely(res != 0)) {
+				mark_conn_closed(conn);
+				goto out;
+			}
+		} else if (cmnd_opcode(cmnd) == ISCSI_OP_SCSI_CMD) {
+			cmd_add_on_rx_ddigest_list(cmnd, cmnd);
+			cmnd_get(cmnd);
+		} else if (cmnd_opcode(cmnd) != ISCSI_OP_SCSI_DATA_OUT) {
+			/*
+			 * We could get here only for Nop-Out. ISCSI RFC
+			 * doesn't specify how to deal with digest errors in
+			 * this case. Is closing connection correct?
+			 */
+			TRACE_DBG("cmnd %p, opcode %x: checking NOP RX "
+				"ddigest", cmnd, cmnd_opcode(cmnd));
+			res = digest_rx_data(cmnd);
+			if (unlikely(res != 0)) {
+				mark_conn_closed(conn);
+				goto out;
+			}
+		}
+	}
+
+out:
+	return res;
+}
+
+/* No locks, conn is rd processing */
+static int process_read_io(struct iscsi_conn *conn, int *closed)
+{
+	struct iscsi_cmnd *cmnd = conn->read_cmnd;
+	int res;
+
+	/* In case of error cmnd will be freed in close_conn() */
+
+	do {
+		switch (conn->read_state) {
+		case RX_INIT_BHS:
+			EXTRACHECKS_BUG_ON(conn->read_cmnd != NULL);
+			cmnd = cmnd_alloc(conn, NULL);
+			conn->read_cmnd = cmnd;
+			iscsi_conn_init_read(cmnd->conn,
+				(void __force __user *)&cmnd->pdu.bhs,
+				sizeof(cmnd->pdu.bhs));
+			conn->read_state = RX_BHS;
+			/* go through */
+
+		case RX_BHS:
+			res = do_recv(conn);
+			if (res == 0) {
+				iscsi_cmnd_get_length(&cmnd->pdu);
+				if (cmnd->pdu.ahssize == 0) {
+					if ((conn->hdigest_type & DIGEST_NONE) == 0)
+						conn->read_state = RX_INIT_HDIGEST;
+					else
+						conn->read_state = RX_CMD_START;
+				} else {
+					iscsi_conn_prepare_read_ahs(conn, cmnd);
+					conn->read_state = RX_AHS;
+				}
+			}
+			break;
+
+		case RX_CMD_START:
+			res = cmnd_rx_start(cmnd);
+			if (res == 0) {
+				if (cmnd->pdu.datasize == 0)
+					conn->read_state = RX_END;
+				else
+					conn->read_state = RX_DATA;
+			} else if (res > 0)
+				conn->read_state = RX_CMD_CONTINUE;
+			else
+				BUG_ON(!conn->closing);
+			break;
+
+		case RX_CMD_CONTINUE:
+			if (cmnd->scst_state == ISCSI_CMD_STATE_RX_CMD) {
+				TRACE_DBG("cmnd %p is still in RX_CMD state",
+					cmnd);
+				res = 1;
+				break;
+			}
+			res = cmnd_rx_continue(cmnd);
+			if (unlikely(res != 0))
+				BUG_ON(!conn->closing);
+			else {
+				if (cmnd->pdu.datasize == 0)
+					conn->read_state = RX_END;
+				else
+					conn->read_state = RX_DATA;
+			}
+			break;
+
+		case RX_DATA:
+			res = do_recv(conn);
+			if (res == 0) {
+				int psz = ((cmnd->pdu.datasize + 3) & -4) - cmnd->pdu.datasize;
+				if (psz != 0) {
+					TRACE_DBG("padding %d bytes", psz);
+					iscsi_conn_init_read(conn,
+						(void __force __user *)&conn->rpadding, psz);
+					conn->read_state = RX_PADDING;
+				} else if ((conn->ddigest_type & DIGEST_NONE) != 0)
+					conn->read_state = RX_END;
+				else
+					conn->read_state = RX_INIT_DDIGEST;
+			}
+			break;
+
+		case RX_END:
+			if (unlikely(conn->read_size != 0)) {
+				PRINT_CRIT_ERROR("conn read_size !=0 on RX_END "
+					"(conn %p, op %x, read_size %d)", conn,
+					cmnd_opcode(cmnd), conn->read_size);
+				BUG();
+			}
+			conn->read_cmnd = NULL;
+			conn->read_state = RX_INIT_BHS;
+
+			cmnd_rx_end(cmnd);
+
+			EXTRACHECKS_BUG_ON(conn->read_size != 0);
+
+			/*
+			 * To maintain fairness. Res must be 0 here anyway, the
+			 * assignment is only to remove compiler warning about
+			 * uninitialized variable.
+			 */
+			res = 0;
+			goto out;
+
+		case RX_INIT_HDIGEST:
+			iscsi_conn_init_read(conn,
+				(void __force __user *)&cmnd->hdigest, sizeof(u32));
+			conn->read_state = RX_CHECK_HDIGEST;
+			/* go through */
+
+		case RX_CHECK_HDIGEST:
+			res = do_recv(conn);
+			if (res == 0) {
+				res = digest_rx_header(cmnd);
+				if (unlikely(res != 0)) {
+					PRINT_ERROR("rx header digest for "
+						"initiator %s failed (%d)",
+						conn->session->initiator_name,
+						res);
+					mark_conn_closed(conn);
+				} else
+					conn->read_state = RX_CMD_START;
+			}
+			break;
+
+		case RX_INIT_DDIGEST:
+			iscsi_conn_init_read(conn,
+				(void __force __user *)&cmnd->ddigest,
+				sizeof(u32));
+			conn->read_state = RX_CHECK_DDIGEST;
+			/* go through */
+
+		case RX_CHECK_DDIGEST:
+			res = iscsi_rx_check_ddigest(conn);
+			break;
+
+		case RX_AHS:
+			res = do_recv(conn);
+			if (res == 0) {
+				if ((conn->hdigest_type & DIGEST_NONE) == 0)
+					conn->read_state = RX_INIT_HDIGEST;
+				else
+					conn->read_state = RX_CMD_START;
+			}
+			break;
+
+		case RX_PADDING:
+			res = do_recv(conn);
+			if (res == 0) {
+				if ((conn->ddigest_type & DIGEST_NONE) == 0)
+					conn->read_state = RX_INIT_DDIGEST;
+				else
+					conn->read_state = RX_END;
+			}
+			break;
+
+		default:
+			PRINT_CRIT_ERROR("%d %x", conn->read_state, cmnd_opcode(cmnd));
+			res = -1; /* to keep compiler happy */
+			BUG();
+		}
+	} while (res == 0);
+
+	if (unlikely(conn->closing)) {
+		start_close_conn(conn);
+		*closed = 1;
+	}
+
+out:
+	return res;
+}
+
+/*
+ * Called under iscsi_rd_lock and BHs disabled, but will drop it inside,
+ * then reaquire.
+ */
+static void scst_do_job_rd(void)
+	__acquires(&iscsi_rd_lock)
+	__releases(&iscsi_rd_lock)
+{
+
+	/*
+	 * We delete/add to tail connections to maintain fairness between them.
+	 */
+
+	while (!list_empty(&iscsi_rd_list)) {
+		int closed = 0, rc;
+		struct iscsi_conn *conn = list_entry(iscsi_rd_list.next,
+			typeof(*conn), rd_list_entry);
+
+		list_del(&conn->rd_list_entry);
+
+		BUG_ON(conn->rd_state == ISCSI_CONN_RD_STATE_PROCESSING);
+		conn->rd_data_ready = 0;
+		conn->rd_state = ISCSI_CONN_RD_STATE_PROCESSING;
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->rd_task = current;
+#endif
+		spin_unlock_bh(&iscsi_rd_lock);
+
+		rc = process_read_io(conn, &closed);
+
+		spin_lock_bh(&iscsi_rd_lock);
+
+		if (unlikely(closed))
+			continue;
+
+		if (unlikely(conn->conn_tm_active)) {
+			spin_unlock_bh(&iscsi_rd_lock);
+			iscsi_check_tm_data_wait_timeouts(conn, false);
+			spin_lock_bh(&iscsi_rd_lock);
+		}
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->rd_task = NULL;
+#endif
+		if ((rc == 0) || conn->rd_data_ready) {
+			list_add_tail(&conn->rd_list_entry, &iscsi_rd_list);
+			conn->rd_state = ISCSI_CONN_RD_STATE_IN_LIST;
+		} else
+			conn->rd_state = ISCSI_CONN_RD_STATE_IDLE;
+	}
+	return;
+}
+
+static inline int test_rd_list(void)
+{
+	int res = !list_empty(&iscsi_rd_list) ||
+		  unlikely(kthread_should_stop());
+	return res;
+}
+
+int istrd(void *arg)
+{
+
+	PRINT_INFO("Read thread started, PID %d", current->pid);
+
+	current->flags |= PF_NOFREEZE;
+
+	spin_lock_bh(&iscsi_rd_lock);
+	while (!kthread_should_stop()) {
+		wait_queue_t wait;
+		init_waitqueue_entry(&wait, current);
+
+		if (!test_rd_list()) {
+			add_wait_queue_exclusive_head(&iscsi_rd_waitQ, &wait);
+			for (;;) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (test_rd_list())
+					break;
+				spin_unlock_bh(&iscsi_rd_lock);
+				schedule();
+				spin_lock_bh(&iscsi_rd_lock);
+			}
+			set_current_state(TASK_RUNNING);
+			remove_wait_queue(&iscsi_rd_waitQ, &wait);
+		}
+		scst_do_job_rd();
+	}
+	spin_unlock_bh(&iscsi_rd_lock);
+
+	/*
+	 * If kthread_should_stop() is true, we are guaranteed to be
+	 * on the module unload, so iscsi_rd_list must be empty.
+	 */
+	BUG_ON(!list_empty(&iscsi_rd_list));
+
+	PRINT_INFO("Read thread PID %d finished", current->pid);
+	return 0;
+}
+
+static inline void check_net_priv(struct iscsi_cmnd *cmd, struct page *page) {}
+static inline void __iscsi_get_page_callback(struct iscsi_cmnd *cmd) {}
+static inline void __iscsi_put_page_callback(struct iscsi_cmnd *cmd) {}
+
+void req_add_to_write_timeout_list(struct iscsi_cmnd *req)
+{
+	struct iscsi_conn *conn;
+	unsigned long timeout_time;
+	bool set_conn_tm_active = false;
+
+	if (req->on_write_timeout_list)
+		goto out;
+
+	conn = req->conn;
+
+	TRACE_DBG("Adding req %p to conn %p write_timeout_list",
+		req, conn);
+
+	spin_lock_bh(&conn->write_list_lock);
+
+	/* Recheck, since it can be changed behind us */
+	if (unlikely(req->on_write_timeout_list)) {
+		spin_unlock_bh(&conn->write_list_lock);
+		goto out;
+	}
+
+	req->on_write_timeout_list = 1;
+	req->write_start = jiffies;
+
+	list_add_tail(&req->write_timeout_list_entry,
+		&conn->write_timeout_list);
+
+	if (!timer_pending(&conn->rsp_timer)) {
+		if (unlikely(conn->conn_tm_active ||
+			     test_bit(ISCSI_CMD_ABORTED,
+					&req->prelim_compl_flags))) {
+			set_conn_tm_active = true;
+			timeout_time = req->write_start +
+					ISCSI_TM_DATA_WAIT_TIMEOUT +
+					ISCSI_ADD_SCHED_TIME;
+		} else
+			timeout_time = req->write_start +
+				conn->rsp_timeout + ISCSI_ADD_SCHED_TIME;
+
+		TRACE_DBG("Starting timer on %ld (con %p, write_start %ld)",
+			timeout_time, conn, req->write_start);
+
+		conn->rsp_timer.expires = timeout_time;
+		add_timer(&conn->rsp_timer);
+	} else if (unlikely(test_bit(ISCSI_CMD_ABORTED,
+				&req->prelim_compl_flags))) {
+		unsigned long timeout_time = jiffies +
+			ISCSI_TM_DATA_WAIT_TIMEOUT + ISCSI_ADD_SCHED_TIME;
+		set_conn_tm_active = true;
+		if (time_after(conn->rsp_timer.expires, timeout_time)) {
+			TRACE_MGMT_DBG("Mod timer on %ld (conn %p)",
+				timeout_time, conn);
+			mod_timer(&conn->rsp_timer, timeout_time);
+		}
+	}
+
+	spin_unlock_bh(&conn->write_list_lock);
+
+	/*
+	 * conn_tm_active can be already cleared by
+	 * iscsi_check_tm_data_wait_timeouts(). write_list_lock is an inner
+	 * lock for iscsi_rd_lock.
+	 */
+	if (unlikely(set_conn_tm_active)) {
+		spin_lock_bh(&iscsi_rd_lock);
+		TRACE_MGMT_DBG("Setting conn_tm_active for conn %p", conn);
+		conn->conn_tm_active = 1;
+		spin_unlock_bh(&iscsi_rd_lock);
+	}
+
+out:
+	return;
+}
+
+static int write_data(struct iscsi_conn *conn)
+{
+	mm_segment_t oldfs;
+	struct file *file;
+	struct iovec *iop;
+	struct socket *sock;
+	ssize_t (*sock_sendpage)(struct socket *, struct page *, int, size_t,
+				 int);
+	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
+	struct iscsi_cmnd *write_cmnd = conn->write_cmnd;
+	struct iscsi_cmnd *ref_cmd;
+	struct page *page;
+	struct scatterlist *sg;
+	int saved_size, size, sendsize;
+	int length, offset, idx;
+	int flags, res, count, sg_size;
+	bool do_put = false, ref_cmd_to_parent;
+
+	iscsi_extracheck_is_wr_thread(conn);
+
+	if (!write_cmnd->own_sg) {
+		ref_cmd = write_cmnd->parent_req;
+		ref_cmd_to_parent = true;
+	} else {
+		ref_cmd = write_cmnd;
+		ref_cmd_to_parent = false;
+	}
+
+	req_add_to_write_timeout_list(write_cmnd->parent_req);
+
+	file = conn->file;
+	size = conn->write_size;
+	saved_size = size;
+	iop = conn->write_iop;
+	count = conn->write_iop_used;
+
+	if (iop) {
+		while (1) {
+			loff_t off = 0;
+			int rest;
+
+			BUG_ON(count > (signed)(sizeof(conn->write_iov) /
+						sizeof(conn->write_iov[0])));
+retry:
+			oldfs = get_fs();
+			set_fs(KERNEL_DS);
+			res = vfs_writev(file,
+					 (struct iovec __force __user *)iop,
+					 count, &off);
+			set_fs(oldfs);
+			TRACE_WRITE("sid %#Lx, cid %u, res %d, iov_len %ld",
+				    (long long unsigned int)conn->session->sid,
+				    conn->cid, res, (long)iop->iov_len);
+			if (unlikely(res <= 0)) {
+				if (res == -EAGAIN) {
+					conn->write_iop = iop;
+					conn->write_iop_used = count;
+					goto out_iov;
+				} else if (res == -EINTR)
+					goto retry;
+				goto out_err;
+			}
+
+			rest = res;
+			size -= res;
+			while ((typeof(rest))iop->iov_len <= rest && rest) {
+				rest -= iop->iov_len;
+				iop++;
+				count--;
+			}
+			if (count == 0) {
+				conn->write_iop = NULL;
+				conn->write_iop_used = 0;
+				if (size)
+					break;
+				goto out_iov;
+			}
+			BUG_ON(iop > conn->write_iov + sizeof(conn->write_iov)
+						  /sizeof(conn->write_iov[0]));
+			iop->iov_base += rest;
+			iop->iov_len -= rest;
+		}
+	}
+
+	sg = write_cmnd->sg;
+	if (unlikely(sg == NULL)) {
+		PRINT_INFO("WARNING: Data missed (cmd %p)!", write_cmnd);
+		res = 0;
+		goto out;
+	}
+
+	/* To protect from too early transfer completion race */
+	__iscsi_get_page_callback(ref_cmd);
+	do_put = true;
+
+	sock = conn->sock;
+
+	if ((write_cmnd->parent_req->scst_cmd != NULL) &&
+	    scst_cmd_get_dh_data_buff_alloced(write_cmnd->parent_req->scst_cmd))
+		sock_sendpage = sock_no_sendpage;
+	else
+		sock_sendpage = sock->ops->sendpage;
+
+	flags = MSG_DONTWAIT;
+	sg_size = size;
+
+	if (sg != write_cmnd->rsp_sg) {
+		offset = conn->write_offset + sg[0].offset;
+		idx = offset >> PAGE_SHIFT;
+		offset &= ~PAGE_MASK;
+		length = min(size, (int)PAGE_SIZE - offset);
+		TRACE_WRITE("write_offset %d, sg_size %d, idx %d, offset %d, "
+			"length %d", conn->write_offset, sg_size, idx, offset,
+			length);
+	} else {
+		idx = 0;
+		offset = conn->write_offset;
+		while (offset >= sg[idx].length) {
+			offset -= sg[idx].length;
+			idx++;
+		}
+		length = sg[idx].length - offset;
+		offset += sg[idx].offset;
+		sock_sendpage = sock_no_sendpage;
+		TRACE_WRITE("rsp_sg: write_offset %d, sg_size %d, idx %d, "
+			"offset %d, length %d", conn->write_offset, sg_size,
+			idx, offset, length);
+	}
+	page = sg_page(&sg[idx]);
+
+	while (1) {
+		sendpage = sock_sendpage;
+
+		sendsize = min(size, length);
+		if (size <= sendsize) {
+retry2:
+			res = sendpage(sock, page, offset, size, flags);
+			TRACE_WRITE("Final %s sid %#Lx, cid %u, res %d (page "
+				"index %lu, offset %u, size %u, cmd %p, "
+				"page %p)", (sendpage != sock_no_sendpage) ?
+						"sendpage" : "sock_no_sendpage",
+				(long long unsigned int)conn->session->sid,
+				conn->cid, res, page->index,
+				offset, size, write_cmnd, page);
+			if (unlikely(res <= 0)) {
+				if (res == -EINTR)
+					goto retry2;
+				else
+					goto out_res;
+			}
+
+			check_net_priv(ref_cmd, page);
+			if (res == size) {
+				conn->write_size = 0;
+				res = saved_size;
+				goto out_put;
+			}
+
+			offset += res;
+			size -= res;
+			goto retry2;
+		}
+
+retry1:
+		res = sendpage(sock, page, offset, sendsize, flags | MSG_MORE);
+		TRACE_WRITE("%s sid %#Lx, cid %u, res %d (page index %lu, "
+			"offset %u, sendsize %u, size %u, cmd %p, page %p)",
+			(sendpage != sock_no_sendpage) ? "sendpage" :
+							 "sock_no_sendpage",
+			(unsigned long long)conn->session->sid, conn->cid,
+			res, page->index, offset, sendsize, size,
+			write_cmnd, page);
+		if (unlikely(res <= 0)) {
+			if (res == -EINTR)
+				goto retry1;
+			else
+				goto out_res;
+		}
+
+		check_net_priv(ref_cmd, page);
+
+		size -= res;
+
+		if (res == sendsize) {
+			idx++;
+			EXTRACHECKS_BUG_ON(idx >= ref_cmd->sg_cnt);
+			page = sg_page(&sg[idx]);
+			length = sg[idx].length;
+			offset = sg[idx].offset;
+		} else {
+			offset += res;
+			sendsize -= res;
+			goto retry1;
+		}
+	}
+
+out_off:
+	conn->write_offset += sg_size - size;
+
+out_iov:
+	conn->write_size = size;
+	if ((saved_size == size) && res == -EAGAIN)
+		goto out_put;
+
+	res = saved_size - size;
+
+out_put:
+	if (do_put)
+		__iscsi_put_page_callback(ref_cmd);
+
+out:
+	return res;
+
+out_res:
+	check_net_priv(ref_cmd, page);
+	if (res == -EAGAIN)
+		goto out_off;
+	/* else go through */
+
+out_err:
+#ifndef CONFIG_SCST_DEBUG
+	if (!conn->closing)
+#endif
+	{
+		PRINT_ERROR("error %d at sid:cid %#Lx:%u, cmnd %p", res,
+			    (long long unsigned int)conn->session->sid,
+			    conn->cid, conn->write_cmnd);
+	}
+	if (ref_cmd_to_parent &&
+	    ((ref_cmd->scst_cmd != NULL) || (ref_cmd->scst_aen != NULL))) {
+		if (ref_cmd->scst_state == ISCSI_CMD_STATE_AEN)
+			scst_set_aen_delivery_status(ref_cmd->scst_aen,
+				SCST_AEN_RES_FAILED);
+		else
+			scst_set_delivery_status(ref_cmd->scst_cmd,
+				SCST_CMD_DELIVERY_FAILED);
+	}
+	goto out_put;
+}
+
+static int exit_tx(struct iscsi_conn *conn, int res)
+{
+	iscsi_extracheck_is_wr_thread(conn);
+
+	switch (res) {
+	case -EAGAIN:
+	case -ERESTARTSYS:
+		res = 0;
+		break;
+	default:
+#ifndef CONFIG_SCST_DEBUG
+		if (!conn->closing)
+#endif
+		{
+			PRINT_ERROR("Sending data failed: initiator %s, "
+				"write_size %d, write_state %d, res %d",
+				conn->session->initiator_name,
+				conn->write_size,
+				conn->write_state, res);
+		}
+		conn->write_state = TX_END;
+		conn->write_size = 0;
+		mark_conn_closed(conn);
+		break;
+	}
+	return res;
+}
+
+static int tx_ddigest(struct iscsi_cmnd *cmnd, int state)
+{
+	int res, rest = cmnd->conn->write_size;
+	struct msghdr msg = {.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT};
+	struct kvec iov;
+
+	iscsi_extracheck_is_wr_thread(cmnd->conn);
+
+	TRACE_DBG("Sending data digest %x (cmd %p)", cmnd->ddigest, cmnd);
+
+	iov.iov_base = (char *)(&cmnd->ddigest) + (sizeof(u32) - rest);
+	iov.iov_len = rest;
+
+	res = kernel_sendmsg(cmnd->conn->sock, &msg, &iov, 1, rest);
+	if (res > 0) {
+		cmnd->conn->write_size -= res;
+		if (!cmnd->conn->write_size)
+			cmnd->conn->write_state = state;
+	} else
+		res = exit_tx(cmnd->conn, res);
+
+	return res;
+}
+
+static void init_tx_hdigest(struct iscsi_cmnd *cmnd)
+{
+	struct iscsi_conn *conn = cmnd->conn;
+	struct iovec *iop;
+
+	iscsi_extracheck_is_wr_thread(conn);
+
+	digest_tx_header(cmnd);
+
+	BUG_ON(conn->write_iop_used >=
+		(signed)(sizeof(conn->write_iov)/sizeof(conn->write_iov[0])));
+
+	iop = &conn->write_iop[conn->write_iop_used];
+	conn->write_iop_used++;
+	iop->iov_base = (void __force __user *)&(cmnd->hdigest);
+	iop->iov_len = sizeof(u32);
+	conn->write_size += sizeof(u32);
+
+	return;
+}
+
+static int tx_padding(struct iscsi_cmnd *cmnd, int state)
+{
+	int res, rest = cmnd->conn->write_size;
+	struct msghdr msg = {.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT};
+	struct kvec iov;
+	static const uint32_t padding;
+
+	iscsi_extracheck_is_wr_thread(cmnd->conn);
+
+	TRACE_DBG("Sending %d padding bytes (cmd %p)", rest, cmnd);
+
+	iov.iov_base = (char *)(&padding) + (sizeof(uint32_t) - rest);
+	iov.iov_len = rest;
+
+	res = kernel_sendmsg(cmnd->conn->sock, &msg, &iov, 1, rest);
+	if (res > 0) {
+		cmnd->conn->write_size -= res;
+		if (!cmnd->conn->write_size)
+			cmnd->conn->write_state = state;
+	} else
+		res = exit_tx(cmnd->conn, res);
+
+	return res;
+}
+
+static int iscsi_do_send(struct iscsi_conn *conn, int state)
+{
+	int res;
+
+	iscsi_extracheck_is_wr_thread(conn);
+
+	res = write_data(conn);
+	if (res > 0) {
+		if (!conn->write_size)
+			conn->write_state = state;
+	} else
+		res = exit_tx(conn, res);
+
+	return res;
+}
+
+/*
+ * No locks, conn is wr processing.
+ *
+ * IMPORTANT! Connection conn must be protected by additional conn_get()
+ * upon entrance in this function, because otherwise it could be destroyed
+ * inside as a result of cmnd release.
+ */
+int iscsi_send(struct iscsi_conn *conn)
+{
+	struct iscsi_cmnd *cmnd = conn->write_cmnd;
+	int ddigest, res = 0;
+
+	TRACE_DBG("conn %p, write_cmnd %p", conn, cmnd);
+
+	iscsi_extracheck_is_wr_thread(conn);
+
+	ddigest = conn->ddigest_type != DIGEST_NONE ? 1 : 0;
+
+	switch (conn->write_state) {
+	case TX_INIT:
+		BUG_ON(cmnd != NULL);
+		cmnd = conn->write_cmnd = iscsi_get_send_cmnd(conn);
+		if (!cmnd)
+			goto out;
+		cmnd_tx_start(cmnd);
+		if (!(conn->hdigest_type & DIGEST_NONE))
+			init_tx_hdigest(cmnd);
+		conn->write_state = TX_BHS_DATA;
+	case TX_BHS_DATA:
+		res = iscsi_do_send(conn, cmnd->pdu.datasize ?
+					TX_INIT_PADDING : TX_END);
+		if (res <= 0 || conn->write_state != TX_INIT_PADDING)
+			break;
+	case TX_INIT_PADDING:
+		cmnd->conn->write_size = ((cmnd->pdu.datasize + 3) & -4) -
+						cmnd->pdu.datasize;
+		if (cmnd->conn->write_size != 0)
+			conn->write_state = TX_PADDING;
+		else if (ddigest)
+			conn->write_state = TX_INIT_DDIGEST;
+		 else
+			conn->write_state = TX_END;
+		break;
+	case TX_PADDING:
+		res = tx_padding(cmnd, ddigest ? TX_INIT_DDIGEST : TX_END);
+		if (res <= 0 || conn->write_state != TX_INIT_DDIGEST)
+			break;
+	case TX_INIT_DDIGEST:
+		cmnd->conn->write_size = sizeof(u32);
+		conn->write_state = TX_DDIGEST;
+	case TX_DDIGEST:
+		res = tx_ddigest(cmnd, TX_END);
+		break;
+	default:
+		PRINT_CRIT_ERROR("%d %d %x", res, conn->write_state,
+			cmnd_opcode(cmnd));
+		BUG();
+	}
+
+	if (res == 0)
+		goto out;
+
+	if (conn->write_state != TX_END)
+		goto out;
+
+	if (unlikely(conn->write_size)) {
+		PRINT_CRIT_ERROR("%d %x %u", res, cmnd_opcode(cmnd),
+			conn->write_size);
+		BUG();
+	}
+	cmnd_tx_end(cmnd);
+
+	rsp_cmnd_release(cmnd);
+
+	conn->write_cmnd = NULL;
+	conn->write_state = TX_INIT;
+
+out:
+	return res;
+}
+
+/* No locks, conn is wr processing.
+ *
+ * IMPORTANT! Connection conn must be protected by additional conn_get()
+ * upon entrance in this function, because otherwise it could be destroyed
+ * inside as a result of iscsi_send(), which releases sent commands.
+ */
+static int process_write_queue(struct iscsi_conn *conn)
+{
+	int res = 0;
+
+	if (likely(test_write_ready(conn)))
+		res = iscsi_send(conn);
+	return res;
+}
+
+/*
+ * Called under iscsi_wr_lock and BHs disabled, but will drop it inside,
+ * then reaquire.
+ */
+static void scst_do_job_wr(void)
+	__acquires(&iscsi_wr_lock)
+	__releases(&iscsi_wr_lock)
+{
+
+	/*
+	 * We delete/add to tail connections to maintain fairness between them.
+	 */
+
+	while (!list_empty(&iscsi_wr_list)) {
+		int rc;
+		struct iscsi_conn *conn = list_entry(iscsi_wr_list.next,
+			typeof(*conn), wr_list_entry);
+
+		TRACE_DBG("conn %p, wr_state %x, wr_space_ready %d, "
+			"write ready %d", conn, conn->wr_state,
+			conn->wr_space_ready, test_write_ready(conn));
+
+		list_del(&conn->wr_list_entry);
+
+		BUG_ON(conn->wr_state == ISCSI_CONN_WR_STATE_PROCESSING);
+
+		conn->wr_state = ISCSI_CONN_WR_STATE_PROCESSING;
+		conn->wr_space_ready = 0;
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->wr_task = current;
+#endif
+		spin_unlock_bh(&iscsi_wr_lock);
+
+		conn_get(conn);
+
+		rc = process_write_queue(conn);
+
+		spin_lock_bh(&iscsi_wr_lock);
+#ifdef CONFIG_SCST_EXTRACHECKS
+		conn->wr_task = NULL;
+#endif
+		if ((rc == -EAGAIN) && !conn->wr_space_ready) {
+			conn->wr_state = ISCSI_CONN_WR_STATE_SPACE_WAIT;
+			goto cont;
+		}
+
+		if (test_write_ready(conn)) {
+			list_add_tail(&conn->wr_list_entry, &iscsi_wr_list);
+			conn->wr_state = ISCSI_CONN_WR_STATE_IN_LIST;
+		} else
+			conn->wr_state = ISCSI_CONN_WR_STATE_IDLE;
+
+cont:
+		conn_put(conn);
+	}
+	return;
+}
+
+static inline int test_wr_list(void)
+{
+	int res = !list_empty(&iscsi_wr_list) ||
+		  unlikely(kthread_should_stop());
+	return res;
+}
+
+int istwr(void *arg)
+{
+
+	PRINT_INFO("Write thread started, PID %d", current->pid);
+
+	current->flags |= PF_NOFREEZE;
+
+	spin_lock_bh(&iscsi_wr_lock);
+	while (!kthread_should_stop()) {
+		wait_queue_t wait;
+		init_waitqueue_entry(&wait, current);
+
+		if (!test_wr_list()) {
+			add_wait_queue_exclusive_head(&iscsi_wr_waitQ, &wait);
+			for (;;) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				if (test_wr_list())
+					break;
+				spin_unlock_bh(&iscsi_wr_lock);
+				schedule();
+				spin_lock_bh(&iscsi_wr_lock);
+			}
+			set_current_state(TASK_RUNNING);
+			remove_wait_queue(&iscsi_wr_waitQ, &wait);
+		}
+		scst_do_job_wr();
+	}
+	spin_unlock_bh(&iscsi_wr_lock);
+
+	/*
+	 * If kthread_should_stop() is true, we are guaranteed to be
+	 * on the module unload, so iscsi_wr_list must be empty.
+	 */
+	BUG_ON(!list_empty(&iscsi_wr_list));
+
+	PRINT_INFO("Write thread PID %d finished", current->pid);
+	return 0;
+}
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/param.c linux-2.6.33/drivers/scst/iscsi-scst/param.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/param.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/param.c
@@ -0,0 +1,306 @@
+/*
+ *  Copyright (C) 2005 FUJITA Tomonori <tomof@acm.org>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include "iscsi.h"
+#include "digest.h"
+
+#define	CHECK_PARAM(info, iparams, word, min, max)				\
+do {										\
+	if (!(info)->partial || ((info)->partial & 1 << key_##word)) {		\
+		TRACE_DBG("%s: %u", #word, (iparams)[key_##word]);		\
+		if ((iparams)[key_##word] < (min) ||				\
+			(iparams)[key_##word] > (max)) {			\
+			if ((iparams)[key_##word] < (min)) {			\
+				(iparams)[key_##word] = (min);			\
+				PRINT_WARNING("%s: %u is too small, resetting "	\
+					"it to allowed min %u",			\
+					#word, (iparams)[key_##word], (min));	\
+			} else {						\
+				PRINT_WARNING("%s: %u is too big, resetting "	\
+					"it to allowed max %u",			\
+					#word, (iparams)[key_##word], (max));	\
+				(iparams)[key_##word] = (max);			\
+			}							\
+		}								\
+	}									\
+} while (0)
+
+#define	SET_PARAM(params, info, iparams, word)					\
+({										\
+	int changed = 0;							\
+	if (!(info)->partial || ((info)->partial & 1 << key_##word)) {		\
+		if ((params)->word != (iparams)[key_##word])			\
+			changed = 1;						\
+		(params)->word = (iparams)[key_##word];				\
+		TRACE_DBG("%s set to %u", #word, (params)->word);		\
+	}									\
+	changed;								\
+})
+
+#define	GET_PARAM(params, info, iparams, word)					\
+do {										\
+	(iparams)[key_##word] = (params)->word;					\
+} while (0)
+
+const char *iscsi_get_bool_value(int val)
+{
+	if (val)
+		return "Yes";
+	else
+		return "No";
+}
+
+const char *iscsi_get_digest_name(int val, char *res)
+{
+	int pos = 0;
+
+	if (val & DIGEST_NONE)
+		pos = sprintf(&res[pos], "%s", "None");
+
+	if (val & DIGEST_CRC32C)
+		pos += sprintf(&res[pos], "%s%s", (pos != 0) ? ", " : "",
+			"CRC32C");
+
+	if (pos == 0)
+		sprintf(&res[pos], "%s", "Unknown");
+
+	return res;
+}
+
+static void log_params(struct iscsi_sess_params *params)
+{
+	char digest_name[64];
+
+	PRINT_INFO("Negotiated parameters: InitialR2T %s, ImmediateData %s, "
+		"MaxConnections %d, MaxRecvDataSegmentLength %d, "
+		"MaxXmitDataSegmentLength %d, ",
+		iscsi_get_bool_value(params->initial_r2t),
+		iscsi_get_bool_value(params->immediate_data), params->max_connections,
+		params->max_recv_data_length, params->max_xmit_data_length);
+	PRINT_INFO("    MaxBurstLength %d, FirstBurstLength %d, "
+		"DefaultTime2Wait %d, DefaultTime2Retain %d, ",
+		params->max_burst_length, params->first_burst_length,
+		params->default_wait_time, params->default_retain_time);
+	PRINT_INFO("    MaxOutstandingR2T %d, DataPDUInOrder %s, "
+		"DataSequenceInOrder %s, ErrorRecoveryLevel %d, ",
+		params->max_outstanding_r2t,
+		iscsi_get_bool_value(params->data_pdu_inorder),
+		iscsi_get_bool_value(params->data_sequence_inorder),
+		params->error_recovery_level);
+	PRINT_INFO("    HeaderDigest %s, DataDigest %s, OFMarker %s, "
+		"IFMarker %s, OFMarkInt %d, IFMarkInt %d",
+		iscsi_get_digest_name(params->header_digest, digest_name),
+		iscsi_get_digest_name(params->data_digest, digest_name),
+		iscsi_get_bool_value(params->ofmarker),
+		iscsi_get_bool_value(params->ifmarker),
+		params->ofmarkint, params->ifmarkint);
+}
+
+/* target_mutex supposed to be locked */
+static void sess_params_check(struct iscsi_kern_params_info *info)
+{
+	int32_t *iparams = info->session_params;
+	const int max_len = ISCSI_CONN_IOV_MAX * PAGE_SIZE;
+
+	CHECK_PARAM(info, iparams, initial_r2t, 0, 1);
+	CHECK_PARAM(info, iparams, immediate_data, 0, 1);
+	CHECK_PARAM(info, iparams, max_connections, 1, 1);
+	CHECK_PARAM(info, iparams, max_recv_data_length, 512, max_len);
+	CHECK_PARAM(info, iparams, max_xmit_data_length, 512, max_len);
+	CHECK_PARAM(info, iparams, max_burst_length, 512, max_len);
+	CHECK_PARAM(info, iparams, first_burst_length, 512, max_len);
+	CHECK_PARAM(info, iparams, max_outstanding_r2t, 1, 65535);
+	CHECK_PARAM(info, iparams, error_recovery_level, 0, 0);
+	CHECK_PARAM(info, iparams, data_pdu_inorder, 0, 1);
+	CHECK_PARAM(info, iparams, data_sequence_inorder, 0, 1);
+
+	digest_alg_available(&iparams[key_header_digest]);
+	digest_alg_available(&iparams[key_data_digest]);
+
+	CHECK_PARAM(info, iparams, ofmarker, 0, 0);
+	CHECK_PARAM(info, iparams, ifmarker, 0, 0);
+
+	return;
+}
+
+/* target_mutex supposed to be locked */
+static void sess_params_set(struct iscsi_sess_params *params,
+			   struct iscsi_kern_params_info *info)
+{
+	int32_t *iparams = info->session_params;
+
+	SET_PARAM(params, info, iparams, initial_r2t);
+	SET_PARAM(params, info, iparams, immediate_data);
+	SET_PARAM(params, info, iparams, max_connections);
+	SET_PARAM(params, info, iparams, max_recv_data_length);
+	SET_PARAM(params, info, iparams, max_xmit_data_length);
+	SET_PARAM(params, info, iparams, max_burst_length);
+	SET_PARAM(params, info, iparams, first_burst_length);
+	SET_PARAM(params, info, iparams, default_wait_time);
+	SET_PARAM(params, info, iparams, default_retain_time);
+	SET_PARAM(params, info, iparams, max_outstanding_r2t);
+	SET_PARAM(params, info, iparams, data_pdu_inorder);
+	SET_PARAM(params, info, iparams, data_sequence_inorder);
+	SET_PARAM(params, info, iparams, error_recovery_level);
+	SET_PARAM(params, info, iparams, header_digest);
+	SET_PARAM(params, info, iparams, data_digest);
+	SET_PARAM(params, info, iparams, ofmarker);
+	SET_PARAM(params, info, iparams, ifmarker);
+	SET_PARAM(params, info, iparams, ofmarkint);
+	SET_PARAM(params, info, iparams, ifmarkint);
+	return;
+}
+
+static void sess_params_get(struct iscsi_sess_params *params,
+			   struct iscsi_kern_params_info *info)
+{
+	int32_t *iparams = info->session_params;
+
+	GET_PARAM(params, info, iparams, initial_r2t);
+	GET_PARAM(params, info, iparams, immediate_data);
+	GET_PARAM(params, info, iparams, max_connections);
+	GET_PARAM(params, info, iparams, max_recv_data_length);
+	GET_PARAM(params, info, iparams, max_xmit_data_length);
+	GET_PARAM(params, info, iparams, max_burst_length);
+	GET_PARAM(params, info, iparams, first_burst_length);
+	GET_PARAM(params, info, iparams, default_wait_time);
+	GET_PARAM(params, info, iparams, default_retain_time);
+	GET_PARAM(params, info, iparams, max_outstanding_r2t);
+	GET_PARAM(params, info, iparams, data_pdu_inorder);
+	GET_PARAM(params, info, iparams, data_sequence_inorder);
+	GET_PARAM(params, info, iparams, error_recovery_level);
+	GET_PARAM(params, info, iparams, header_digest);
+	GET_PARAM(params, info, iparams, data_digest);
+	GET_PARAM(params, info, iparams, ofmarker);
+	GET_PARAM(params, info, iparams, ifmarker);
+	GET_PARAM(params, info, iparams, ofmarkint);
+	GET_PARAM(params, info, iparams, ifmarkint);
+	return;
+}
+
+/* target_mutex supposed to be locked */
+static void tgt_params_check(struct iscsi_session *session,
+	struct iscsi_kern_params_info *info)
+{
+	int32_t *iparams = info->target_params;
+
+	CHECK_PARAM(info, iparams, queued_cmnds, MIN_NR_QUEUED_CMNDS,
+		min_t(int, MAX_NR_QUEUED_CMNDS,
+		      scst_get_max_lun_commands(session->scst_sess, NO_SUCH_LUN)));
+	CHECK_PARAM(info, iparams, rsp_timeout, MIN_RSP_TIMEOUT,
+		MAX_RSP_TIMEOUT);
+	CHECK_PARAM(info, iparams, nop_in_interval, MIN_NOP_IN_INTERVAL,
+		MAX_NOP_IN_INTERVAL);
+	return;
+}
+
+/* target_mutex supposed to be locked */
+static int iscsi_tgt_params_set(struct iscsi_session *session,
+		      struct iscsi_kern_params_info *info, int set)
+{
+	struct iscsi_tgt_params *params = &session->tgt_params;
+	int32_t *iparams = info->target_params;
+
+	if (set) {
+		struct iscsi_conn *conn;
+
+		tgt_params_check(session, info);
+
+		SET_PARAM(params, info, iparams, queued_cmnds);
+		SET_PARAM(params, info, iparams, rsp_timeout);
+		SET_PARAM(params, info, iparams, nop_in_interval);
+
+		PRINT_INFO("Target parameters set for session %llx: "
+			"QueuedCommands %d, Response timeout %d, Nop-In "
+			"interval %d", session->sid, params->queued_cmnds,
+			params->rsp_timeout, params->nop_in_interval);
+
+		list_for_each_entry(conn, &session->conn_list,
+					conn_list_entry) {
+			conn->rsp_timeout = session->tgt_params.rsp_timeout * HZ;
+			conn->nop_in_interval = session->tgt_params.nop_in_interval * HZ;
+			spin_lock_bh(&iscsi_rd_lock);
+			if (!conn->closing && (conn->nop_in_interval > 0)) {
+				TRACE_DBG("Schedule Nop-In work for conn %p", conn);
+				schedule_delayed_work(&conn->nop_in_delayed_work,
+					conn->nop_in_interval + ISCSI_ADD_SCHED_TIME);
+			}
+			spin_unlock_bh(&iscsi_rd_lock);
+		}
+	} else {
+		GET_PARAM(params, info, iparams, queued_cmnds);
+		GET_PARAM(params, info, iparams, rsp_timeout);
+		GET_PARAM(params, info, iparams, nop_in_interval);
+	}
+
+	return 0;
+}
+
+/* target_mutex supposed to be locked */
+static int iscsi_sess_params_set(struct iscsi_session *session,
+	struct iscsi_kern_params_info *info, int set)
+{
+	struct iscsi_sess_params *params;
+
+	if (set)
+		sess_params_check(info);
+
+	params = &session->sess_params;
+
+	if (set) {
+		sess_params_set(params, info);
+		log_params(params);
+	} else
+		sess_params_get(params, info);
+
+	return 0;
+}
+
+/* target_mutex supposed to be locked */
+int iscsi_params_set(struct iscsi_target *target,
+	struct iscsi_kern_params_info *info, int set)
+{
+	int err;
+	struct iscsi_session *session;
+
+	if (info->sid == 0) {
+		PRINT_ERROR("sid must not be %d", 0);
+		err = -EINVAL;
+		goto out;
+	}
+
+	session = session_lookup(target, info->sid);
+	if (session == NULL) {
+		PRINT_ERROR("Session for sid %llx not found", info->sid);
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (set && !list_empty(&session->conn_list) &&
+	    (info->params_type != key_target)) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (info->params_type == key_session)
+		err = iscsi_sess_params_set(session, info, set);
+	else if (info->params_type == key_target)
+		err = iscsi_tgt_params_set(session, info, set);
+	else
+		err = -EINVAL;
+
+out:
+	return err;
+}
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/session.c linux-2.6.33/drivers/scst/iscsi-scst/session.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/session.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/session.c
@@ -0,0 +1,482 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include "iscsi.h"
+
+/* target_mutex supposed to be locked */
+struct iscsi_session *session_lookup(struct iscsi_target *target, u64 sid)
+{
+	struct iscsi_session *session;
+
+	list_for_each_entry(session, &target->session_list,
+			session_list_entry) {
+		if (session->sid == sid)
+			return session;
+	}
+	return NULL;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int iscsi_session_alloc(struct iscsi_target *target,
+	struct iscsi_kern_session_info *info, struct iscsi_session **result)
+{
+	int err;
+	unsigned int i;
+	struct iscsi_session *session;
+	char *name = NULL;
+
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	if (!session)
+		return -ENOMEM;
+
+	session->target = target;
+	session->sid = info->sid;
+	atomic_set(&session->active_cmds, 0);
+	session->exp_cmd_sn = info->exp_cmd_sn;
+
+	session->initiator_name = kstrdup(info->initiator_name, GFP_KERNEL);
+	if (!session->initiator_name) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	name =  info->initiator_name;
+
+	INIT_LIST_HEAD(&session->conn_list);
+	INIT_LIST_HEAD(&session->pending_list);
+
+	spin_lock_init(&session->sn_lock);
+
+	spin_lock_init(&session->cmnd_data_wait_hash_lock);
+	for (i = 0; i < ARRAY_SIZE(session->cmnd_data_wait_hash); i++)
+		INIT_LIST_HEAD(&session->cmnd_data_wait_hash[i]);
+
+	session->next_ttt = 1;
+
+	session->scst_sess = scst_register_session(target->scst_tgt, 0,
+		name, NULL, NULL);
+	if (session->scst_sess == NULL) {
+		PRINT_ERROR("%s", "scst_register_session() failed");
+		err = -ENOMEM;
+		goto err;
+	}
+
+	scst_sess_set_tgt_priv(session->scst_sess, session);
+
+	TRACE_MGMT_DBG("Session %p created: target %p, tid %u, sid %#Lx",
+		session, target, target->tid, info->sid);
+
+	*result = session;
+	return 0;
+
+err:
+	if (session) {
+		kfree(session->initiator_name);
+		kfree(session);
+	}
+	return err;
+}
+
+/* target_mutex supposed to be locked */
+void sess_reinst_finished(struct iscsi_session *sess)
+{
+	struct iscsi_conn *c;
+
+	TRACE_MGMT_DBG("Enabling reinstate successor sess %p", sess);
+
+	BUG_ON(!sess->sess_reinstating);
+
+	list_for_each_entry(c, &sess->conn_list, conn_list_entry) {
+		conn_reinst_finished(c);
+	}
+	sess->sess_reinstating = 0;
+	return;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+int __add_session(struct iscsi_target *target,
+	struct iscsi_kern_session_info *info)
+{
+	struct iscsi_session *new_sess = NULL, *sess, *old_sess;
+	int err = 0, i;
+	union iscsi_sid sid;
+	bool reinstatement = false;
+	struct iscsi_kern_params_info *params_info;
+
+	TRACE_MGMT_DBG("Adding session SID %llx", info->sid);
+
+	err = iscsi_session_alloc(target, info, &new_sess);
+	if (err != 0)
+		goto out;
+
+	mutex_lock(&target->target_mutex);
+
+	sess = session_lookup(target, info->sid);
+	if (sess != NULL) {
+		PRINT_ERROR("Attempt to add session with existing SID %llx",
+			info->sid);
+		err = -EEXIST;
+		goto out_err_unlock;
+	}
+
+	params_info = kmalloc(sizeof(*params_info), GFP_KERNEL);
+	if (params_info == NULL) {
+		PRINT_ERROR("Unable to allocate params info (size %zd)",
+			sizeof(*params_info));
+		err = -ENOMEM;
+		goto out_err_unlock;
+	}
+
+	sid = *(union iscsi_sid *)&info->sid;
+	sid.id.tsih = 0;
+	old_sess = NULL;
+
+	/*
+	 * We need to find the latest session to correctly handle
+	 * multi-reinstatements
+	 */
+	list_for_each_entry_reverse(sess, &target->session_list,
+			session_list_entry) {
+		union iscsi_sid i = *(union iscsi_sid *)&sess->sid;
+		i.id.tsih = 0;
+		if ((sid.id64 == i.id64) &&
+		    (strcmp(info->initiator_name, sess->initiator_name) == 0)) {
+			if (!sess->sess_shutting_down) {
+				/* session reinstatement */
+				old_sess = sess;
+			}
+			break;
+		}
+	}
+	sess = NULL;
+
+	list_add_tail(&new_sess->session_list_entry, &target->session_list);
+
+	memset(params_info, 0, sizeof(*params_info));
+	params_info->tid = target->tid;
+	params_info->sid = info->sid;
+	params_info->params_type = key_session;
+	for (i = 0; i < session_key_last; i++)
+		params_info->session_params[i] = info->session_params[i];
+
+	err = iscsi_params_set(target, params_info, 1);
+	if (err != 0)
+		goto out_del;
+
+	memset(params_info, 0, sizeof(*params_info));
+	params_info->tid = target->tid;
+	params_info->sid = info->sid;
+	params_info->params_type = key_target;
+	for (i = 0; i < target_key_last; i++)
+		params_info->target_params[i] = info->target_params[i];
+
+	err = iscsi_params_set(target, params_info, 1);
+	if (err != 0)
+		goto out_del;
+
+	kfree(params_info);
+	params_info = NULL;
+
+	if (old_sess != NULL) {
+		reinstatement = true;
+
+		TRACE_MGMT_DBG("Reinstating sess %p with SID %llx (old %p, "
+			"SID %llx)", new_sess, new_sess->sid, old_sess,
+			old_sess->sid);
+
+		new_sess->sess_reinstating = 1;
+		old_sess->sess_reinst_successor = new_sess;
+
+		target_del_session(old_sess->target, old_sess, 0);
+	}
+
+	mutex_unlock(&target->target_mutex);
+
+	if (reinstatement) {
+		/*
+		 * Mutex target_mgmt_mutex won't allow to add connections to
+		 * the new session after target_mutex was dropped, so it's safe
+		 * to replace the initial UA without it. We can't do it under
+		 * target_mutex, because otherwise we can establish a
+		 * circular locking dependency between target_mutex and
+		 * scst_mutex in SCST core (iscsi_report_aen() called by
+		 * SCST core under scst_mutex).
+		 */
+		scst_set_initial_UA(new_sess->scst_sess,
+			SCST_LOAD_SENSE(scst_sense_nexus_loss_UA));
+	}
+
+out:
+	return err;
+
+out_del:
+	list_del(&new_sess->session_list_entry);
+	kfree(params_info);
+
+out_err_unlock:
+	mutex_unlock(&target->target_mutex);
+
+	scst_unregister_session(new_sess->scst_sess, 1, NULL);
+	new_sess->scst_sess = NULL;
+
+	mutex_lock(&target->target_mutex);
+	session_free(new_sess, false);
+	mutex_unlock(&target->target_mutex);
+	goto out;
+}
+
+static void __session_free(struct iscsi_session *session)
+{
+	kfree(session->initiator_name);
+	kfree(session);
+}
+
+static void iscsi_unreg_sess_done(struct scst_session *scst_sess)
+{
+	struct iscsi_session *session;
+
+	session = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);
+
+	session->scst_sess = NULL;
+	__session_free(session);
+	return;
+}
+
+/* target_mutex supposed to be locked */
+int session_free(struct iscsi_session *session, bool del)
+{
+	unsigned int i;
+
+	TRACE_MGMT_DBG("Freeing session %p (SID %llx)",
+		session, session->sid);
+
+	BUG_ON(!list_empty(&session->conn_list));
+	if (unlikely(atomic_read(&session->active_cmds) != 0)) {
+		PRINT_CRIT_ERROR("active_cmds not 0 (%d)!!",
+			atomic_read(&session->active_cmds));
+		BUG();
+	}
+
+	for (i = 0; i < ARRAY_SIZE(session->cmnd_data_wait_hash); i++)
+		BUG_ON(!list_empty(&session->cmnd_data_wait_hash[i]));
+
+	if (session->sess_reinst_successor != NULL)
+		sess_reinst_finished(session->sess_reinst_successor);
+
+	if (session->sess_reinstating) {
+		struct iscsi_session *s;
+		TRACE_MGMT_DBG("Freeing being reinstated sess %p", session);
+		list_for_each_entry(s, &session->target->session_list,
+						session_list_entry) {
+			if (s->sess_reinst_successor == session) {
+				s->sess_reinst_successor = NULL;
+				break;
+			}
+		}
+	}
+
+	if (del)
+		list_del(&session->session_list_entry);
+
+	if (session->scst_sess != NULL) {
+		/*
+		 * We must NOT call scst_unregister_session() in the waiting
+		 * mode, since we are under target_mutex. Otherwise we can
+		 * establish a circular locking dependency between target_mutex
+		 * and scst_mutex in SCST core (iscsi_report_aen() called by
+		 * SCST core under scst_mutex).
+		 */
+		scst_unregister_session(session->scst_sess, 0,
+			iscsi_unreg_sess_done);
+	} else
+		__session_free(session);
+
+	return 0;
+}
+
+/* target_mutex supposed to be locked */
+int __del_session(struct iscsi_target *target, u64 sid)
+{
+	struct iscsi_session *session;
+
+	session = session_lookup(target, sid);
+	if (!session)
+		return -ENOENT;
+
+	if (!list_empty(&session->conn_list)) {
+		PRINT_ERROR("%llu still have connections",
+			    (long long unsigned int)session->sid);
+		return -EBUSY;
+	}
+
+	return session_free(session, true);
+}
+
+#define ISCSI_SESS_BOOL_PARAM_ATTR(name, exported_name)				\
+static ssize_t iscsi_sess_show_##name(struct kobject *kobj,			\
+	struct kobj_attribute *attr, char *buf)					\
+{										\
+	int pos;								\
+	struct scst_session *scst_sess;						\
+	struct iscsi_session *sess;						\
+										\
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);		\
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);	\
+										\
+	pos = sprintf(buf, "%s\n",						\
+		iscsi_get_bool_value(sess->sess_params.name));			\
+										\
+	return pos;								\
+}										\
+										\
+static struct kobj_attribute iscsi_sess_attr_##name =				\
+	__ATTR(exported_name, S_IRUGO, iscsi_sess_show_##name, NULL);
+
+#define ISCSI_SESS_INT_PARAM_ATTR(name, exported_name)				\
+static ssize_t iscsi_sess_show_##name(struct kobject *kobj,			\
+	struct kobj_attribute *attr, char *buf)					\
+{										\
+	int pos;								\
+	struct scst_session *scst_sess;						\
+	struct iscsi_session *sess;						\
+										\
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);		\
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);	\
+										\
+	pos = sprintf(buf, "%d\n", sess->sess_params.name);			\
+										\
+	return pos;								\
+}										\
+										\
+static struct kobj_attribute iscsi_sess_attr_##name =				\
+	__ATTR(exported_name, S_IRUGO, iscsi_sess_show_##name, NULL);
+
+#define ISCSI_SESS_DIGEST_PARAM_ATTR(name, exported_name)			\
+static ssize_t iscsi_sess_show_##name(struct kobject *kobj,			\
+	struct kobj_attribute *attr, char *buf)					\
+{										\
+	int pos;								\
+	struct scst_session *scst_sess;						\
+	struct iscsi_session *sess;						\
+	char digest_name[64];							\
+										\
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);		\
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);	\
+										\
+	pos = sprintf(buf, "%s\n", iscsi_get_digest_name(			\
+			sess->sess_params.name, digest_name));			\
+										\
+	return pos;								\
+}										\
+										\
+static struct kobj_attribute iscsi_sess_attr_##name =				\
+	__ATTR(exported_name, S_IRUGO, iscsi_sess_show_##name, NULL);
+
+ISCSI_SESS_BOOL_PARAM_ATTR(initial_r2t, InitialR2T);
+ISCSI_SESS_BOOL_PARAM_ATTR(immediate_data, ImmediateData);
+ISCSI_SESS_INT_PARAM_ATTR(max_recv_data_length, MaxRecvDataSegmentLength);
+ISCSI_SESS_INT_PARAM_ATTR(max_xmit_data_length, MaxXmitDataSegmentLength);
+ISCSI_SESS_INT_PARAM_ATTR(max_burst_length, MaxBurstLength);
+ISCSI_SESS_INT_PARAM_ATTR(first_burst_length, FirstBurstLength);
+ISCSI_SESS_INT_PARAM_ATTR(max_outstanding_r2t, MaxOutstandingR2T);
+ISCSI_SESS_DIGEST_PARAM_ATTR(header_digest, HeaderDigest);
+ISCSI_SESS_DIGEST_PARAM_ATTR(data_digest, DataDigest);
+
+static ssize_t iscsi_sess_sid_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct scst_session *scst_sess;
+	struct iscsi_session *sess;
+
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);
+
+	pos = sprintf(buf, "%llx\n", sess->sid);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_attr_sess_sid =
+	__ATTR(sid, S_IRUGO, iscsi_sess_sid_show, NULL);
+
+static ssize_t iscsi_sess_reinstating_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct scst_session *scst_sess;
+	struct iscsi_session *sess;
+
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);
+
+	pos = sprintf(buf, "%d\n", sess->sess_reinstating ? 1 : 0);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_sess_attr_reinstating =
+	__ATTR(reinstating, S_IRUGO, iscsi_sess_reinstating_show, NULL);
+
+static ssize_t iscsi_sess_force_close_store(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int res;
+	struct scst_session *scst_sess;
+	struct iscsi_session *sess;
+	struct iscsi_conn *conn;
+
+	scst_sess = container_of(kobj, struct scst_session, sess_kobj);
+	sess = (struct iscsi_session *)scst_sess_get_tgt_priv(scst_sess);
+
+	if (mutex_lock_interruptible(&sess->target->target_mutex) != 0) {
+		res = -EINTR;
+		goto out;
+	}
+
+	PRINT_INFO("Deleting session %llu with initiator %s (%p)",
+		(long long unsigned int)sess->sid, sess->initiator_name, sess);
+
+	list_for_each_entry(conn, &sess->conn_list, conn_list_entry) {
+		TRACE_MGMT_DBG("Deleting connection with initiator %p", conn);
+		__mark_conn_closed(conn, ISCSI_CONN_ACTIVE_CLOSE|ISCSI_CONN_DELETING);
+	}
+
+	mutex_unlock(&sess->target->target_mutex);
+
+	res = count;
+
+out:
+	return res;
+}
+
+static struct kobj_attribute iscsi_sess_attr_force_close =
+	__ATTR(force_close, S_IWUSR, NULL, iscsi_sess_force_close_store);
+
+const struct attribute *iscsi_sess_attrs[] = {
+	&iscsi_sess_attr_initial_r2t.attr,
+	&iscsi_sess_attr_immediate_data.attr,
+	&iscsi_sess_attr_max_recv_data_length.attr,
+	&iscsi_sess_attr_max_xmit_data_length.attr,
+	&iscsi_sess_attr_max_burst_length.attr,
+	&iscsi_sess_attr_first_burst_length.attr,
+	&iscsi_sess_attr_max_outstanding_r2t.attr,
+	&iscsi_sess_attr_header_digest.attr,
+	&iscsi_sess_attr_data_digest.attr,
+	&iscsi_attr_sess_sid.attr,
+	&iscsi_sess_attr_reinstating.attr,
+	&iscsi_sess_attr_force_close.attr,
+	NULL,
+};
+
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/target.c linux-2.6.33/drivers/scst/iscsi-scst/target.c
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/target.c
+++ linux-2.6.33/drivers/scst/iscsi-scst/target.c
@@ -0,0 +1,500 @@
+/*
+ *  Copyright (C) 2002 - 2003 Ardis Technolgies <roman@ardistech.com>
+ *  Copyright (C) 2007 - 2010 Vladislav Bolkhovitin
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+
+#include "iscsi.h"
+#include "digest.h"
+
+#define MAX_NR_TARGETS		(1UL << 30)
+
+DEFINE_MUTEX(target_mgmt_mutex);
+
+/* All 3 protected by target_mgmt_mutex */
+static LIST_HEAD(target_list);
+static u32 next_target_id;
+static u32 nr_targets;
+
+/* target_mgmt_mutex supposed to be locked */
+struct iscsi_target *target_lookup_by_id(u32 id)
+{
+	struct iscsi_target *target;
+
+	list_for_each_entry(target, &target_list, target_list_entry) {
+		if (target->tid == id)
+			return target;
+	}
+	return NULL;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static struct iscsi_target *target_lookup_by_name(const char *name)
+{
+	struct iscsi_target *target;
+
+	list_for_each_entry(target, &target_list, target_list_entry) {
+		if (!strcmp(target->name, name))
+			return target;
+	}
+	return NULL;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+static int iscsi_target_create(struct iscsi_kern_target_info *info, u32 tid,
+	struct iscsi_target **out_target)
+{
+	int err = -EINVAL, len;
+	char *name = info->name;
+	struct iscsi_target *target;
+
+	TRACE_MGMT_DBG("Creating target tid %u, name %s", tid, name);
+
+	len = strlen(name);
+	if (!len) {
+		PRINT_ERROR("The length of the target name is zero %u", tid);
+		goto out;
+	}
+
+	if (!try_module_get(THIS_MODULE)) {
+		PRINT_ERROR("Fail to get module %u", tid);
+		goto out;
+	}
+
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
+	if (!target) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	target->tid = info->tid = tid;
+
+	strlcpy(target->name, name, sizeof(target->name));
+
+	mutex_init(&target->target_mutex);
+	INIT_LIST_HEAD(&target->session_list);
+	INIT_LIST_HEAD(&target->attrs_list);
+
+	target->scst_tgt = scst_register_target(&iscsi_template, target->name);
+	if (!target->scst_tgt) {
+		PRINT_ERROR("%s", "scst_register_target() failed");
+		err = -EBUSY;
+		goto out_free;
+	}
+
+	scst_tgt_set_tgt_priv(target->scst_tgt, target);
+
+	list_add_tail(&target->target_list_entry, &target_list);
+
+	*out_target = target;
+
+	return 0;
+
+out_free:
+	kfree(target);
+
+out_put:
+	module_put(THIS_MODULE);
+
+out:
+	return err;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+int __add_target(struct iscsi_kern_target_info *info)
+{
+	int err;
+	u32 tid = info->tid;
+	struct iscsi_target *target;
+	struct iscsi_kern_params_info *params_info;
+	struct iscsi_kern_attr *attr_info;
+	union add_info_union {
+		struct iscsi_kern_params_info params_info;
+		struct iscsi_kern_attr attr_info;
+	} *add_info;
+	int i, rc;
+	unsigned long attrs_ptr_long;
+	struct iscsi_kern_attr __user *attrs_ptr;
+
+	if (nr_targets > MAX_NR_TARGETS) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (target_lookup_by_name(info->name)) {
+		PRINT_ERROR("Target %s already exist!", info->name);
+		err = -EEXIST;
+		goto out;
+	}
+
+	if (tid && target_lookup_by_id(tid)) {
+		PRINT_ERROR("Target %u already exist!", tid);
+		err = -EEXIST;
+		goto out;
+	}
+
+	add_info = kmalloc(sizeof(*add_info), GFP_KERNEL);
+	if (add_info == NULL) {
+		PRINT_ERROR("Unable to allocate additional info (size %zd)",
+			sizeof(*add_info));
+		err = -ENOMEM;
+		goto out;
+	}
+	params_info = (struct iscsi_kern_params_info *)add_info;
+	attr_info = (struct iscsi_kern_attr *)add_info;
+
+	if (tid == 0) {
+		do {
+			if (!++next_target_id)
+				++next_target_id;
+		} while (target_lookup_by_id(next_target_id));
+
+		tid = next_target_id;
+	}
+
+	err = iscsi_target_create(info, tid, &target);
+	if (err != 0)
+		goto out_free;
+
+	nr_targets++;
+
+	mutex_lock(&target->target_mutex);
+
+	attrs_ptr_long = info->attrs_ptr;
+	attrs_ptr = (struct iscsi_kern_attr __user *)attrs_ptr_long;
+	for (i = 0; i < info->attrs_num; i++) {
+		memset(attr_info, 0, sizeof(*attr_info));
+
+		rc = copy_from_user(attr_info, attrs_ptr, sizeof(*attr_info));
+		if (rc != 0) {
+			PRINT_ERROR("Failed to copy users of target %s "
+				"failed", info->name);
+			err = -EFAULT;
+			goto out_del_unlock;
+		}
+
+		attr_info->name[sizeof(attr_info->name)-1] = '\0';
+
+		err = iscsi_add_attr(target, attr_info);
+		if (err != 0)
+			goto out_del_unlock;
+
+		attrs_ptr++;
+	}
+
+	mutex_unlock(&target->target_mutex);
+
+	err = tid;
+
+out_free:
+	kfree(add_info);
+
+out:
+	return err;
+
+out_del_unlock:
+	mutex_unlock(&target->target_mutex);
+	__del_target(tid);
+	goto out_free;
+}
+
+static void target_destroy(struct iscsi_target *target)
+{
+	struct iscsi_attr *attr, *t;
+
+	TRACE_MGMT_DBG("Destroying target tid %u", target->tid);
+
+	list_for_each_entry_safe(attr, t, &target->attrs_list,
+				attrs_list_entry) {
+		__iscsi_del_attr(target, attr);
+	}
+
+	scst_unregister_target(target->scst_tgt);
+
+	kfree(target);
+
+	module_put(THIS_MODULE);
+	return;
+}
+
+/* target_mgmt_mutex supposed to be locked */
+int __del_target(u32 id)
+{
+	struct iscsi_target *target;
+	int err;
+
+	target = target_lookup_by_id(id);
+	if (!target) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	mutex_lock(&target->target_mutex);
+
+	if (!list_empty(&target->session_list)) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
+	list_del(&target->target_list_entry);
+	nr_targets--;
+
+	mutex_unlock(&target->target_mutex);
+
+	target_destroy(target);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&target->target_mutex);
+
+out:
+	return err;
+}
+
+/* target_mutex supposed to be locked */
+void target_del_session(struct iscsi_target *target,
+	struct iscsi_session *session, int flags)
+{
+
+	TRACE_MGMT_DBG("Deleting session %p", session);
+
+	if (!list_empty(&session->conn_list)) {
+		struct iscsi_conn *conn, *tc;
+		list_for_each_entry_safe(conn, tc, &session->conn_list,
+					 conn_list_entry) {
+			TRACE_MGMT_DBG("Mark conn %p closing", conn);
+			__mark_conn_closed(conn, flags);
+		}
+	} else {
+		TRACE_MGMT_DBG("Freeing session %p without connections",
+			       session);
+		__del_session(target, session->sid);
+	}
+	return;
+}
+
+/* target_mutex supposed to be locked */
+void target_del_all_sess(struct iscsi_target *target, int flags)
+{
+	struct iscsi_session *session, *ts;
+
+	if (!list_empty(&target->session_list)) {
+		TRACE_MGMT_DBG("Deleting all sessions from target %p", target);
+		list_for_each_entry_safe(session, ts, &target->session_list,
+						session_list_entry) {
+			target_del_session(target, session, flags);
+		}
+	}
+	return;
+}
+
+void target_del_all(void)
+{
+	struct iscsi_target *target, *t;
+	bool first = true;
+
+	TRACE_MGMT_DBG("%s", "Deleting all targets");
+
+	/* Not the best, ToDo */
+	while (1) {
+		mutex_lock(&target_mgmt_mutex);
+
+		if (list_empty(&target_list))
+			break;
+
+		/*
+		 * In the first iteration we won't delete targets to go at
+		 * first through all sessions of all targets and close their
+		 * connections. Otherwise we can stuck for noticeable time
+		 * waiting during a target's unregistration for the activities
+		 * suspending over active connection. This can especially got
+		 * bad if any being wait connection itself stuck waiting for
+		 * something and can be recovered only by connection close.
+		 * Let's for such cases not wait while such connection recover
+		 * theyself, but act in advance.
+		 */
+
+		list_for_each_entry_safe(target, t, &target_list,
+					 target_list_entry) {
+			mutex_lock(&target->target_mutex);
+
+			if (!list_empty(&target->session_list)) {
+				target_del_all_sess(target,
+					ISCSI_CONN_ACTIVE_CLOSE |
+					ISCSI_CONN_DELETING);
+			} else if (!first) {
+				TRACE_MGMT_DBG("Deleting target %p", target);
+				list_del(&target->target_list_entry);
+				nr_targets--;
+				mutex_unlock(&target->target_mutex);
+				target_destroy(target);
+				continue;
+			}
+
+			mutex_unlock(&target->target_mutex);
+		}
+		mutex_unlock(&target_mgmt_mutex);
+		msleep(100);
+
+		first = false;
+	}
+
+	mutex_unlock(&target_mgmt_mutex);
+
+	TRACE_MGMT_DBG("%s", "Deleting all targets finished");
+	return;
+}
+
+static ssize_t iscsi_tgt_tid_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	int pos;
+	struct scst_tgt *scst_tgt;
+	struct iscsi_target *tgt;
+
+	scst_tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
+	tgt = (struct iscsi_target *)scst_tgt_get_tgt_priv(scst_tgt);
+
+	pos = sprintf(buf, "%u\n", tgt->tid);
+	return pos;
+}
+
+static struct kobj_attribute iscsi_tgt_attr_tid =
+	__ATTR(tid, S_IRUGO, iscsi_tgt_tid_show, NULL);
+
+const struct attribute *iscsi_tgt_attrs[] = {
+	&iscsi_tgt_attr_tid.attr,
+	NULL,
+};
+
+ssize_t iscsi_sysfs_send_event(uint32_t tid, enum iscsi_kern_event_code code,
+	const char *param1, const char *param2, void **data)
+{
+	int res;
+	struct scst_sysfs_user_info *info;
+
+	if (ctr_open_state != ISCSI_CTR_OPEN_STATE_OPEN) {
+		PRINT_ERROR("%s", "User space process not connected");
+		res = -EPERM;
+		goto out;
+	}
+
+	res = scst_sysfs_user_add_info(&info);
+	if (res != 0)
+		goto out;
+
+	TRACE_DBG("Sending event %d (tid %d, param1 %s, param2 %s, cookie %d, "
+		"info %p)", tid, code, param1, param2, info->info_cookie, info);
+
+	res = event_send(tid, 0, 0, info->info_cookie, code, param1, param2);
+	if (res <= 0) {
+		PRINT_ERROR("event_send() failed: %d", res);
+		if (res == 0)
+			res = -EFAULT;
+		goto out_free;
+	}
+
+	/*
+	 * It may wait 30 secs in blocking connect to an unreacheable
+	 * iSNS server. It must be fixed, but not now. ToDo.
+	 */
+	res = scst_wait_info_completion(info, 31 * HZ);
+
+	if (data != NULL)
+		*data = info->data;
+
+out_free:
+	scst_sysfs_user_del_info(info);
+
+out:
+	return res;
+}
+
+int iscsi_enable_target(struct scst_tgt *scst_tgt, bool enable)
+{
+	struct iscsi_target *tgt =
+		(struct iscsi_target *)scst_tgt_get_tgt_priv(scst_tgt);
+	int res;
+	uint32_t type;
+
+	if (enable)
+		type = E_ENABLE_TARGET;
+	else
+		type = E_DISABLE_TARGET;
+
+	TRACE_DBG("%s target %d", enable ? "Enabling" : "Disabling", tgt->tid);
+
+	res = iscsi_sysfs_send_event(tgt->tid, type, NULL, NULL, NULL);
+	return res;
+}
+
+bool iscsi_is_target_enabled(struct scst_tgt *scst_tgt)
+{
+	struct iscsi_target *tgt =
+		(struct iscsi_target *)scst_tgt_get_tgt_priv(scst_tgt);
+
+	return tgt->tgt_enabled;
+}
+
+ssize_t iscsi_sysfs_add_target(const char *target_name, char *params)
+{
+	int res;
+
+	res = iscsi_sysfs_send_event(0, E_ADD_TARGET, target_name,
+			params, NULL);
+	if (res > 0) {
+		/* It's tid */
+		res = 0;
+	}
+	return res;
+}
+
+ssize_t iscsi_sysfs_del_target(const char *target_name)
+{
+	int res = 0, tid;
+
+	/* We don't want to have tgt visible after the mutex unlock */
+	{
+		struct iscsi_target *tgt;
+		mutex_lock(&target_mgmt_mutex);
+		tgt = target_lookup_by_name(target_name);
+		if (tgt == NULL) {
+			PRINT_ERROR("Target %s not found", target_name);
+			mutex_unlock(&target_mgmt_mutex);
+			res = -ENOENT;
+			goto out;
+		}
+		tid = tgt->tid;
+		mutex_unlock(&target_mgmt_mutex);
+	}
+
+	TRACE_DBG("Deleting target %s (tid %d)", target_name, tid);
+
+	res = iscsi_sysfs_send_event(tid, E_DEL_TARGET, NULL, NULL, NULL);
+
+out:
+	return res;
+}
+
+ssize_t iscsi_sysfs_mgmt_cmd(char *cmd)
+{
+	int res;
+
+	TRACE_DBG("Sending mgmt cmd %s", cmd);
+
+	res = iscsi_sysfs_send_event(0, E_MGMT_CMD, cmd, NULL, NULL);
+	return res;
+}
+
