Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0CBC83007
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07436206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ae5GwGNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD1GLf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726475AbgD1GLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 02:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LlESilmGHUzSik0O32o2phaC0LUCROeTfncJqfyfQi0=;
        b=ae5GwGNr6Ka9rw5iNmtmqw6hdvTjhe/rCUynG5r/cqTRSRfXP2Lr+P9AV9g41OlHLTRik/
        SZ7nia/upVj1L94P5oA5T91DpYlFNVH/9rOvDOXwAfF7D5QPc09jxr6rOptmbBlkx3RQ8r
        oWXE9ZYTthHPb85VqxIDkFGUOdPkTyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-GBczX3ygMTiDdtQ9dpA4wQ-1; Tue, 28 Apr 2020 02:11:24 -0400
X-MC-Unique: GBczX3ygMTiDdtQ9dpA4wQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4008C835B41;
        Tue, 28 Apr 2020 06:11:23 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FA0610013D9;
        Tue, 28 Apr 2020 06:11:22 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 08/11] target: add sysfs session helper functions
Date:   Tue, 28 Apr 2020 01:11:06 -0500
Message-Id: <20200428061109.3042-9-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds helpers to add/remove a dir per session. There is
only 2 files/dirs.

acl - name of acl session is accessed through.
transport_id - Contains fabric module specific transportID values.

scsi_target/
=E2=94=9C=E2=94=80=E2=94=80 iscsi
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 iqn.1999-09.com.tcmu:al=
ua
=E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 tpgt_1
=E2=94=82=C2=A0=C2=A0         =E2=94=94=E2=94=80=E2=94=80 sessions
=E2=94=82=C2=A0=C2=A0             =E2=94=94=E2=94=80=E2=94=80 session-1
=E2=94=82=C2=A0=C2=A0                 =E2=94=9C=E2=94=80=E2=94=80 acl
=E2=94=82=C2=A0=C2=A0                 =E2=94=94=E2=94=80=E2=94=80 transpo=
rt_id
=E2=94=82=C2=A0=C2=A0                     =E2=94=9C=E2=94=80=E2=94=80 nam=
e
=E2=94=82=C2=A0=C2=A0                     =E2=94=9C=E2=94=80=E2=94=80 pro=
to
=E2=94=82=C2=A0=C2=A0                     =E2=94=94=E2=94=80=E2=94=80 ses=
sion_id
=E2=94=94=E2=94=80=E2=94=80 sessions
    =E2=94=94=E2=94=80=E2=94=80 session-1 ->
../iscsi/iqn.1999-09.com.tcmu:alua/tpgt_1/sessions/session-1

Fabric drivers like iscsi or elx can add pass in an attribute_group
to add driver specific attrs via the target_core_fabric_ops
session_attrs field.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
V2:
- Fix extra newline
- Copy data that's exported to sysfs so we do not have to worry about
  configfs and sysfs refcounts.
- adds back the global sid allocator instead of the per tpg
one because in the future we will want to tag target_core_user commands
with the session id. This will be needed when tcmu devices are mapped
to multiple fabric modules or tpgs and they userspace needs to track
the different session to command mappings for commands like PRs.

V3:
- add session symlink
- use simple ida.

 drivers/target/Makefile                |   1 +
 drivers/target/target_core_configfs.c  |   2 +-
 drivers/target/target_core_internal.h  |   5 +
 drivers/target/target_core_sysfs.c     | 194 +++++++++++++++++++++++++++=
++++++
 drivers/target/target_core_transport.c |  35 +++++-
 include/target/target_core_base.h      |   6 +
 include/target/target_core_fabric.h    |   8 +-
 7 files changed, 243 insertions(+), 8 deletions(-)
 create mode 100644 drivers/target/target_core_sysfs.c

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4563474..4a7246e 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
 target_core_mod-y		:=3D target_core_configfs.o \
+				   target_core_sysfs.o \
 				   target_core_device.o \
 				   target_core_fabric_configfs.o \
 				   target_core_fabric_lib.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
index 20aa58b..c557deb 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -64,7 +64,7 @@
 }
=20
 static struct kobject *tcm_core_kobj;
-static struct kobject *tcm_core_sessions_kobj;
+struct kobject *tcm_core_sessions_kobj;
=20
 extern struct t10_alua_lu_gp *default_lu_gp;
=20
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index aea50f1..74b9098 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -91,6 +91,7 @@ int	target_for_each_device(int (*fn)(struct se_device *=
dev, void *data),
 			       void *data);
=20
 /* target_core_configfs.c */
+extern struct kobject *tcm_core_sessions_kobj;
 extern struct configfs_item_operations target_core_dev_item_ops;
 void	target_setup_backend_cits(struct target_backend *);
=20
@@ -107,6 +108,9 @@ const char *target_parse_pr_out_transport_id(struct s=
e_portal_group *tpg,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 void target_free_transport_id(struct t10_transport_id *tpid);
=20
+/* target_core_sysfs.c */
+void	target_sysfs_init_session(struct se_session *sess);
+
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
 int	core_delete_hba(struct se_hba *);
@@ -154,6 +158,7 @@ void	transport_dump_dev_info(struct se_device *, stru=
ct se_lun *,
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	__target_free_session(struct se_session *);
=20
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_sysfs.c b/drivers/target/target_c=
ore_sysfs.c
new file mode 100644
index 0000000..af0005a
--- /dev/null
+++ b/drivers/target/target_core_sysfs.c
@@ -0,0 +1,194 @@
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
+	struct se_session *se_sess =3D container_of(kobj, struct se_session, ko=
bj);
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
+	return snprintf(page, PAGE_SIZE, "%s\n", se_sess->acl_name ?
+			se_sess->acl_name : "");
+}
+
+static struct session_attr session_acl_attr =3D {
+	.attr =3D { .name =3D "acl", .mode =3D S_IRUGO },
+	.show =3D session_acl_show,
+};
+
+/* Default attrs common to all fabric modules */
+static struct attribute *session_attrs[] =3D {
+	&session_acl_attr.attr,
+	NULL
+};
+
+static const struct attribute_group session_group =3D {
+	.attrs =3D session_attrs,
+};
+
+/* transportID attrs */
+#define transport_id_attr_show(name, fmt_str)				\
+static ssize_t show_##name(struct se_session *se_sess, char *page)	\
+{									\
+	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpid->name); \
+}
+
+#define transport_id_attr(name, fmt_str)		\
+	transport_id_attr_show(name, fmt_str)		\
+static struct session_attr transport_id_##name##_attr =3D	\
+	__ATTR(name, S_IRUGO, show_##name, NULL)
+
+transport_id_attr(proto, "%u\n");
+transport_id_attr(name, "%s\n");
+
+static ssize_t session_id_show(struct se_session *se_sess, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%s\n", se_sess->tpid->session_id ?
+			se_sess->tpid->session_id : "");
+}
+
+static struct session_attr transport_id_session_id_attr =3D {
+	.attr =3D { .name =3D "session_id", .mode =3D S_IRUGO },
+	.show =3D session_id_show,
+};
+
+static struct attribute *transport_id_attrs[] =3D {
+	&transport_id_proto_attr.attr,
+	&transport_id_name_attr.attr,
+	&transport_id_session_id_attr.attr,
+	NULL
+};
+
+static const struct attribute_group transport_id_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_attrs,
+};
+
+static ssize_t
+session_attr_store(struct kobject *kobj, struct attribute *attr,
+		   const char *page, size_t length)
+{
+	struct se_session *se_sess =3D container_of(kobj, struct se_session, ko=
bj);
+	struct session_attr *sess_attr =3D to_session(attr);
+
+	if (!sess_attr->store)
+		return -ENOSYS;
+
+	return sess_attr->store(se_sess, page, length);
+}
+
+static ssize_t
+session_attr_show(struct kobject *kobj, struct attribute *attr, char *pa=
ge)
+{
+	struct se_session *se_sess =3D container_of(kobj, struct se_session, ko=
bj);
+	struct session_attr *sess_attr =3D to_session(attr);
+
+	if (!sess_attr->show)
+		return -ENOSYS;
+
+	return sess_attr->show(se_sess, page);
+}
+
+static const struct sysfs_ops session_sysfs_ops =3D {
+	.show	=3D session_attr_show,
+	.store	=3D session_attr_store,
+};
+
+static const struct attribute_group *def_session_groups[] =3D {
+	&session_group,
+	&transport_id_group,
+	NULL
+};
+
+static struct kobj_type session_ktype =3D {
+	.sysfs_ops	=3D &session_sysfs_ops,
+	.release	=3D target_sysfs_session_release,
+	.default_groups	=3D def_session_groups,
+};
+
+void target_sysfs_init_session(struct se_session *se_sess)
+{
+	kobject_init(&se_sess->kobj, &session_ktype);
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
+		se_sess->acl_name =3D kstrdup(se_sess->se_node_acl->initiatorname,
+					    GFP_KERNEL);
+		if (!se_sess->acl_name)
+			return -ENOMEM;
+	}
+
+	ret =3D kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "session-%d"=
,
+			  se_sess->sid);
+	if (ret) {
+		pr_err("Could not add session%d to sysfs. Error %d.\n",
+		       se_sess->sid, ret);
+		goto free_acl_name;
+	}
+
+	if (se_sess->tfo->session_attrs) {
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 se_sess->tfo->session_attrs);
+		if (ret)
+			goto del_kobj;
+	}
+
+	ret =3D sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
+				se_sess->kobj.name);
+	if (ret)
+		goto rm_group;
+
+	se_sess->sysfs_added =3D true;
+	return 0;
+
+rm_group:
+	if (se_sess->tfo->session_attrs)
+		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
+del_kobj:
+	kobject_del(&se_sess->kobj);
+free_acl_name:
+	kfree(se_sess->acl_name);
+	se_sess->acl_name =3D NULL;
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
+	kobject_del(&se_sess->kobj);
+}
+EXPORT_SYMBOL(target_sysfs_remove_session);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 369cd7e..7f04b7bf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -42,6 +42,7 @@
=20
 static struct workqueue_struct *target_completion_wq;
 static struct kmem_cache *se_sess_cache;
+static DEFINE_IDA(se_sess_ida);
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
@@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum tar=
get_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret =3D transport_init_session(se_sess);
+
+	ret =3D ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		pr_err("Unable to allocate session index.\n");
+		goto free_sess;
 	}
-	se_sess->sup_prot_ops =3D sup_prot_ops;
+	se_sess->sid =3D ret;
+
+	ret =3D transport_init_session(se_sess);
+	if (ret < 0)
+		goto free_sid;
=20
+	se_sess->sup_prot_ops =3D sup_prot_ops;
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
=20
@@ -585,12 +599,21 @@ void transport_free_session(struct se_session *se_s=
ess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	target_free_transport_id(se_sess->tpid);
 	percpu_ref_exit(&se_sess->cmd_count);
-	kmem_cache_free(se_sess_cache, se_sess);
+	kobject_put(&se_sess->kobj);
 }
 EXPORT_SYMBOL(transport_free_session);
=20
+void __target_free_session(struct se_session *se_sess)
+{
+	kfree(se_sess->acl_name);
+	target_free_transport_id(se_sess->tpid);
+
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 static int target_release_res(struct se_device *dev, void *data)
 {
 	struct se_session *sess =3D data;
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index 16d2a4c..a1ae82f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -9,6 +9,7 @@
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/idr.h>
=20
 #define TARGET_CORE_VERSION		"v5.0"
=20
@@ -621,6 +622,7 @@ struct se_session {
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
+	char			*acl_name;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
 	struct percpu_ref	cmd_count;
@@ -631,6 +633,10 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct kobject		kobj;
+	int			sid;
+	bool			sysfs_added;
+	const struct target_core_fabric_ops *tfo;
 };
=20
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h
index 0c1720d..be43180 100644
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
@@ -141,7 +145,9 @@ void	transport_register_session(struct se_portal_grou=
p *,
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-
+void	target_sysfs_remove_session(struct se_session *se_sess);
+int	target_sysfs_add_session(struct se_portal_group *se_tpg,
+				 struct se_session *se_sess);
=20
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
--=20
1.8.3.1

