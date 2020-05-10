Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07D9C54E90
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A2D2080C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fdnk4D/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgEJV6R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729475AbgEJV6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 17:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4HdEIlq2jztu2Cxj4xpajeqclQc1tCgeFxi9hfE6V0=;
        b=Fdnk4D/w4DIrws2MryXy92w6sEJD2cPdVD9LBDrSOU6dVw5O/GIKV1d0mp84moU64TAgPi
        hoWp/yKAcMroCv0gz3lwa0TtVuBiUqEpyldjbCno9YtJa7168iGcoqdt60nip5XrZ+NaXy
        Yb/gTWXTpoRbWBJtVkFW6f3gW2tt/LU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-iIJI_W7JOY6GZirwz733Cg-1; Sun, 10 May 2020 17:58:08 -0400
X-MC-Unique: iIJI_W7JOY6GZirwz733Cg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E13468E;
        Sun, 10 May 2020 21:58:07 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BFD81002382;
        Sun, 10 May 2020 21:58:06 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/15] target: add sysfs session helper functions
Date:   Sun, 10 May 2020 16:57:41 -0500
Message-Id: <20200510215744.21999-13-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds helpers to add/remove a dir per session. There is only 2
files/dirs initially.

acl - name of acl session is accessed through.
transport_id - Contains fabric module specific transportID values.

See sysfs-scsi-target below for more info on each file/dir.

scsi_target/
|-- iscsi
|   `-- iqn.1999-09.com.tcmu:minna
|       `-- tpgt_1
|           `-- sessions
|               `-- iqn.2005-03.com.ceph:ini1-1
|                   |-- acl
|                   `-- transport_id
|                       |-- name
|                       |-- proto
|                       `-- session_id

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---

V4:
- add Documentation/ABI
- use initaitor port prefix instead of generic "session"

V3:
- add session symlink
- use simple ida.

V2:
- Fix extra newline
- Copy data that's exported to sysfs so we do not have to worry about
  configfs and sysfs refcounts.
- adds back the global sid allocator instead of the per tpg
one because in the future we will want to tag target_core_user commands
with the session id. This will be needed when tcmu devices are mapped
to multiple fabric modules or tpgs and they userspace needs to track
the different session to command mappings for commands like PRs.

 Documentation/ABI/testing/sysfs-scsi-target |  46 ++++++
 drivers/target/Makefile                     |   1 +
 drivers/target/target_core_configfs.c       |   2 +-
 drivers/target/target_core_internal.h       |   5 +
 drivers/target/target_core_sysfs.c          | 233 ++++++++++++++++++++++++++++
 drivers/target/target_core_transport.c      |  35 ++++-
 include/target/target_core_base.h           |   6 +
 include/target/target_core_fabric.h         |   8 +-
 8 files changed, 328 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-scsi-target
 create mode 100644 drivers/target/target_core_sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-scsi-target b/Documentation/ABI/testing/sysfs-scsi-target
new file mode 100644
index 0000000..0408798
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-scsi-target
@@ -0,0 +1,46 @@
+What:		/sys/scsi_target/<fabric>/<target>/<tpgt_N>/sessions/<initiator-X>
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	The sessions dir contains a dir for each I_T Nexus. The name of
+		the dir is initiator port name followed by an integer that is
+		unique across all fabrics. The dir contains files that export
+		info like the ACL being used, SCSI port values, and fabric and
+		transport specific values.
+
+What:		/sys/scsi_target/<fabric>/.../sessions/<initiator-X>/acl
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	Returns the name of the ACL that was used to validate login or
+		an empty string if no user created ACL was used.
+
+What:		/sys/scsi_target/<fabric>/.../sessions/<initiator-X/transport_id
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	The transport_id contains the SCSI TransportID values for the
+		initiator port as defined in SPC4r37.
+
+What:		/sys/scsi_target/<fabric>/.../sessions/<initiator-X/transport_id/proto
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	Returns the SCSI protocol identifier in hex defined in SPC4r37.
+
+What:		/sys/scsi_target/<fabric>/.../sessions/<initiator-X/transport_id/name
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	Returns the port name/address/id in the protocol specific
+		TransportID format defined in SPC4r37's.
+
+What:		/sys/scsi_target/<fabric>/.../sessions/<initiator-X/transport_id/session_id
+Date:		May 9, 2020
+KernelVersion:	5.8
+Contact:	linux-scsi@vger.kernel.org
+Description:	If is proto=0x5 (iSCSI) and TPID FORMAT=1 this file will exist
+		and will return the iSCSI Initiator Session ID in ASCII
+		characters that are the hexadecimal digits converted from the
+		binary iSCSI initiator session identifier value. If iSCSI and
+		format=1 is not used by this session this file will not exist.
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4563474..4a7246e 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 target_core_mod-y		:= target_core_configfs.o \
+				   target_core_sysfs.o \
 				   target_core_device.o \
 				   target_core_fabric_configfs.o \
 				   target_core_fabric_lib.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3eb2566..7a9f607 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -64,7 +64,7 @@
 }
 
 static struct kobject *tcm_core_kobj;
-static struct kobject *tcm_core_sessions_kobj;
+struct kobject *tcm_core_sessions_kobj;
 
 extern struct t10_alua_lu_gp *default_lu_gp;
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 16ae020..5bf216f 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -91,6 +91,7 @@ int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 			       void *data);
 
 /* target_core_configfs.c */
+extern struct kobject *tcm_core_sessions_kobj;
 extern struct configfs_item_operations target_core_dev_item_ops;
 void	target_setup_backend_cits(struct target_backend *);
 
@@ -106,6 +107,9 @@ int	target_get_pr_transport_id(struct se_node_acl *nacl,
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 
+/* target_core_sysfs.c */
+void	target_sysfs_init_session(struct se_session *sess);
+
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
 int	core_delete_hba(struct se_hba *);
@@ -153,6 +157,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	__target_free_session(struct se_session *);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_sysfs.c b/drivers/target/target_core_sysfs.c
new file mode 100644
index 0000000..f8353a9
--- /dev/null
+++ b/drivers/target/target_core_sysfs.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kobject.h>
+#include <linux/idr.h>
+
+#include <scsi/scsi_proto.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include "target_core_internal.h"
+
+static void target_sysfs_session_release(struct kobject *kobj)
+{
+	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
+
+	__target_free_session(se_sess);
+}
+
+struct session_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct se_session *, char *);
+	ssize_t (*store)(struct se_session *, const char *, size_t);
+};
+
+#define to_session(atr) container_of((atr), struct session_attr, attr)
+
+static ssize_t session_acl_show(struct se_session *se_sess, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%s", se_sess->acl_name ?
+			se_sess->acl_name : "");
+}
+
+static struct session_attr session_acl_attr = {
+	.attr = { .name = "acl", .mode = S_IRUGO },
+	.show = session_acl_show,
+};
+
+/* Default attrs common to all fabric modules */
+static struct attribute *session_attrs[] = {
+	&session_acl_attr.attr,
+	NULL
+};
+
+static const struct attribute_group session_group = {
+	.attrs = session_attrs,
+};
+
+/* transportID attrs */
+#define tpt_id_attr_show(name, fmt_str)					\
+static ssize_t show_##name(struct se_session *se_sess, char *page)	\
+{									\
+	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpt_id->name); \
+}
+
+#define tpt_id_attr(name, fmt_str)			\
+	tpt_id_attr_show(name, fmt_str)			\
+static struct session_attr tpt_id_##name##_attr =	\
+	__ATTR(name, S_IRUGO, show_##name, NULL)
+
+tpt_id_attr(proto, "0x%x");
+tpt_id_attr(name, "%s");
+
+static ssize_t session_id_show(struct se_session *se_sess, char *page)
+{
+	if (!se_sess->tpt_id->session_id)
+		return 0;
+
+	return snprintf(page, PAGE_SIZE, "0x%s", se_sess->tpt_id->session_id);
+}
+
+static struct session_attr tpt_id_session_id_attr = {
+	.attr = { .name = "session_id", .mode = S_IRUGO },
+	.show = session_id_show,
+};
+
+/*
+ * The drivers that emulate iSCSI like loop/vhost/xen do not support format=1,
+ * so we only separate based on format and not also proto.
+ */
+static struct attribute *tpt_id_fmt0_attrs[] = {
+	&tpt_id_proto_attr.attr,
+	&tpt_id_name_attr.attr,
+	NULL
+};
+
+static const struct attribute_group tpt_id_fmt0_group = {
+	.name = "transport_id",
+	.attrs = tpt_id_fmt0_attrs,
+};
+
+static struct attribute *tpt_id_fmt1_attrs[] = {
+	&tpt_id_proto_attr.attr,
+	&tpt_id_name_attr.attr,
+	&tpt_id_session_id_attr.attr,
+	NULL
+};
+
+static const struct attribute_group tpt_id_fmt1_group = {
+	.name = "transport_id",
+	.attrs = tpt_id_fmt1_attrs,
+};
+
+static ssize_t
+session_attr_store(struct kobject *kobj, struct attribute *attr,
+		   const char *page, size_t length)
+{
+	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
+	struct session_attr *sess_attr = to_session(attr);
+
+	if (!sess_attr->store)
+		return -ENOSYS;
+
+	return sess_attr->store(se_sess, page, length);
+}
+
+static ssize_t
+session_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct se_session *se_sess = container_of(kobj, struct se_session, kobj);
+	struct session_attr *sess_attr = to_session(attr);
+
+	if (!sess_attr->show)
+		return -ENOSYS;
+
+	return sess_attr->show(se_sess, page);
+}
+
+static const struct sysfs_ops session_sysfs_ops = {
+	.show	= session_attr_show,
+	.store	= session_attr_store,
+};
+
+static const struct attribute_group *def_session_groups[] = {
+	&session_group,
+	NULL
+};
+
+static struct kobj_type session_ktype = {
+	.sysfs_ops	= &session_sysfs_ops,
+	.release	= target_sysfs_session_release,
+	.default_groups	= def_session_groups,
+};
+
+void target_sysfs_init_session(struct se_session *se_sess)
+{
+	kobject_init(&se_sess->kobj, &session_ktype);
+}
+
+static int add_transport_id_attrs(struct se_session *se_sess)
+{
+	if (se_sess->tpt_id->session_id)
+		return sysfs_create_group(&se_sess->kobj, &tpt_id_fmt1_group);
+	else
+		return sysfs_create_group(&se_sess->kobj, &tpt_id_fmt0_group);
+}
+
+static void remove_transport_id_attrs(struct se_session *se_sess)
+{
+	if (se_sess->tpt_id->session_id)
+		sysfs_remove_group(&se_sess->kobj, &tpt_id_fmt1_group);
+	else
+		sysfs_remove_group(&se_sess->kobj, &tpt_id_fmt0_group);
+}
+
+int target_sysfs_add_session(struct se_portal_group *se_tpg,
+			     struct se_session *se_sess)
+{
+	int ret;
+
+	/*
+	 * Copy ACL name so we don't have to worry about mixing configfs
+	 * and sysfs refcounts.
+	 */
+	if (!se_sess->se_node_acl->dynamic_node_acl) {
+		se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
+					    GFP_KERNEL);
+		if (!se_sess->acl_name)
+			return -ENOMEM;
+	}
+
+	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
+			  se_sess->tpt_id->name, se_sess->sid);
+	if (ret) {
+		pr_err("Could not add session%d to sysfs. Error %d.\n",
+		       se_sess->sid, ret);
+		goto free_acl_name;
+	}
+
+	ret = add_transport_id_attrs(se_sess);
+	if (ret)
+		goto del_kobj;
+
+	if (se_sess->tfo->session_attrs) {
+		ret = sysfs_create_group(&se_sess->kobj,
+					 se_sess->tfo->session_attrs);
+		if (ret)
+			goto rm_tpt_id_grps;
+	}
+
+	ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
+				se_sess->kobj.name);
+	if (ret)
+		goto rm_fabric_grps;
+
+	se_sess->sysfs_added = true;
+	return 0;
+
+rm_fabric_grps:
+	if (se_sess->tfo->session_attrs)
+		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
+rm_tpt_id_grps:
+	remove_transport_id_attrs(se_sess);
+del_kobj:
+	kobject_del(&se_sess->kobj);
+free_acl_name:
+	kfree(se_sess->acl_name);
+	se_sess->acl_name = NULL;
+	return ret;
+}
+EXPORT_SYMBOL(target_sysfs_add_session);
+
+void target_sysfs_remove_session(struct se_session *se_sess)
+{
+	/* discovery sessions are normally not added to sysfs */
+	if (!se_sess->sysfs_added)
+		return;
+
+	sysfs_remove_link(tcm_core_sessions_kobj, se_sess->kobj.name);
+	if (se_sess->tfo->session_attrs)
+		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
+	remove_transport_id_attrs(se_sess);
+	kobject_del(&se_sess->kobj);
+}
+EXPORT_SYMBOL(target_sysfs_remove_session);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fdf84db..04cb042 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -42,6 +42,7 @@
 
 static struct workqueue_struct *target_completion_wq;
 static struct kmem_cache *se_sess_cache;
+static DEFINE_IDA(se_sess_ida);
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
@@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
+
+	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		pr_err("Unable to allocate session index.\n");
+		goto free_sess;
 	}
-	se_sess->sup_prot_ops = sup_prot_ops;
+	se_sess->sid = ret;
+
+	ret = transport_init_session(se_sess);
+	if (ret < 0)
+		goto free_sid;
 
+	se_sess->sup_prot_ops = sup_prot_ops;
+	target_sysfs_init_session(se_sess);
 	return se_sess;
+
+free_sid:
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+free_sess:
+	kmem_cache_free(se_sess_cache, se_sess);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -597,12 +611,21 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	target_free_transport_id(se_sess->tpt_id);
 	percpu_ref_exit(&se_sess->cmd_count);
-	kmem_cache_free(se_sess_cache, se_sess);
+	kobject_put(&se_sess->kobj);
 }
 EXPORT_SYMBOL(transport_free_session);
 
+void __target_free_session(struct se_session *se_sess)
+{
+	kfree(se_sess->acl_name);
+	target_free_transport_id(se_sess->tpt_id);
+
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 static int target_release_res(struct se_device *dev, void *data)
 {
 	struct se_session *sess = data;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b7f7e02..34d89cb 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -9,6 +9,7 @@
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/idr.h>
 
 #define TARGET_CORE_VERSION		"v5.0"
 
@@ -626,6 +627,7 @@ struct se_session {
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
+	char			*acl_name;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
 	struct percpu_ref	cmd_count;
@@ -636,6 +638,10 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct kobject		kobj;
+	int			sid;
+	bool			sysfs_added;
+	const struct target_core_fabric_ops *tfo;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index ced377f..f876a05 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -74,6 +74,10 @@ struct target_core_fabric_ops {
 	int (*queue_status)(struct se_cmd *);
 	void (*queue_tm_rsp)(struct se_cmd *);
 	void (*aborted_task)(struct se_cmd *);
+
+	/* Optional session management and sysfs callouts */
+	const struct attribute_group *session_attrs;
+
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
@@ -145,7 +149,9 @@ void	transport_register_session(struct se_portal_group *,
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-
+void	target_sysfs_remove_session(struct se_session *se_sess);
+int	target_sysfs_add_session(struct se_portal_group *se_tpg,
+				 struct se_session *se_sess);
 
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
-- 
1.8.3.1

