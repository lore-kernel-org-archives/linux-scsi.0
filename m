Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D94BC3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03FE5208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxf9iT7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgDTTPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727981AbgDTTPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQNW9r85/saTM928lPMZrjFhCd+n6ULNsj+2asZFZ2Y=;
        b=hxf9iT7EborQ91l0s0oS25WPV0TLQNv2YYWNxivRbJSMTqJwwmnnDquu6IZMkGRj8kcyi8
        UpHAqn71CL/WryqgjzzXKdyMdyt4PVt5tEeGCZAuhDD2qA/pk6VOChwM0b0xFnnoTDCJCT
        YKT703BFpOOwfijNDQr+yy6vh61cVds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-JTSpb3tROKq03Vw8bYC2hA-1; Mon, 20 Apr 2020 15:15:05 -0400
X-MC-Unique: JTSpb3tROKq03Vw8bYC2hA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6A77801E67;
        Mon, 20 Apr 2020 19:15:00 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18649A2934;
        Mon, 20 Apr 2020 19:14:55 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 08/12] target: add sysfs session helper functions
Date:   Mon, 20 Apr 2020 14:14:22 -0500
Message-Id: <20200420191426.17055-9-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds helpers to add/remove a dir per session. There is
only 2 files/dirs.

acl - name of acl session is accessed through.
transport_id - Contains fabric module specific transportID values.

iSCSI example:

scsi_target/
=E2=94=9C=E2=94=80=E2=94=80 iscsi
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 iqn.1999-09.com.tcmu:al=
ua
=E2=94=82=C2=A0=C2=A0     =E2=94=9C=E2=94=80=E2=94=80 tpgt_1
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80=
 sessions
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=
=94=80 session-1
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0         =E2=94=9C=E2=94=80=
=E2=94=80 acl
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0         =E2=94=94=E2=94=80=
=E2=94=80 transport_id
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0             =E2=94=9C=E2=94=
=80=E2=94=80 format
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0             =E2=94=9C=E2=94=
=80=E2=94=80 iscsi_name
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0             =E2=94=9C=E2=94=
=80=E2=94=80 iscsi_session_id
=E2=94=82=C2=A0=C2=A0     =E2=94=82=C2=A0=C2=A0             =E2=94=94=E2=94=
=80=E2=94=80 proto
=E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 tpgt_2
=E2=94=82=C2=A0=C2=A0         =E2=94=94=E2=94=80=E2=94=80 sessions
.....

Fabric drivers like iscsi or elx can add pass in an attribute_group
to add driver specific attrs via the target_core_fabric_ops
session_attrs field.

Note that this adds back the global sid allocator instead of the per tpg
one because in the future we will want to tag target_core_user commands
with the session id. This will be needed when tcmu devices are mapped
to multiple fabric modules or tpgs and they userspace needs to track
the different session to command mappings for commands like PRs.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
V2:
- Fix extra newline
- Copy data that's exported to sysfs so we do not have to worry about
configfs and sysfs refcounts.

 drivers/target/Makefile                |   1 +
 drivers/target/target_core_internal.h  |   4 +
 drivers/target/target_core_sysfs.c     | 296 +++++++++++++++++++++++++++=
++++++
 drivers/target/target_core_transport.c |  43 ++++-
 include/target/target_core_base.h      |   6 +
 include/target/target_core_fabric.h    |   8 +-
 6 files changed, 351 insertions(+), 7 deletions(-)
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
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index d242a97..c85eb30 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -108,6 +108,9 @@ const char *target_parse_pr_out_transport_id(struct s=
e_portal_group *tpg,
 void target_free_transport_id(struct t10_transport_id *tpid);
 char *transport_id_get_sid(struct t10_transport_id *tpid);
=20
+/* target_core_sysfs.c */
+void	target_sysfs_init_session(struct se_session *sess);
+
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
 int	core_delete_hba(struct se_hba *);
@@ -155,6 +158,7 @@ void	transport_dump_dev_info(struct se_device *, stru=
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
index 0000000..d8f2c1e
--- /dev/null
+++ b/drivers/target/target_core_sysfs.c
@@ -0,0 +1,296 @@
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
+ATTRIBUTE_GROUPS(session);
+
+/* transportID attrs */
+#define transport_id_def_attr_show(name, fmt_str)		\
+static ssize_t def_show_##name(struct se_session *se_sess, char *page) \
+{									\
+	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpid->name); \
+}
+
+#define transport_id_def_attr(name, fmt_str)		\
+	transport_id_def_attr_show(name, fmt_str)		\
+static struct session_attr transport_id_def_##name##_attr =3D	\
+	__ATTR(name, S_IRUGO, def_show_##name, NULL)
+
+#define transport_id_attr_show(pref, name, fmt_str)			\
+static ssize_t show_##pref##_##name(struct se_session *se_sess, char *pa=
ge) \
+{									\
+	return snprintf(page, PAGE_SIZE, fmt_str, se_sess->tpid->pref.name); \
+}
+
+#define transport_id_attr(pref, name, fmt_str)				\
+	transport_id_attr_show(pref, name, fmt_str)			\
+static struct session_attr transport_id_##pref##_##name##_attr =3D	\
+	__ATTR(name, S_IRUGO, show_##pref##_##name, NULL)
+
+transport_id_def_attr(proto, "%u\n");
+transport_id_def_attr(format, "%u\n");
+transport_id_attr(fcp, port_name, "%s\n");
+transport_id_attr(sbp, name, "%s\n");
+transport_id_attr(srp, port_id, "%s\n");
+transport_id_attr(sas, addr, "%s\n");
+transport_id_attr(iscsi, name, "%s\n");
+transport_id_attr(iscsi, session_id, "%s\n");
+
+static struct attribute *transport_id_fcp_attrs[] =3D {
+	&transport_id_def_proto_attr.attr,
+	&transport_id_def_format_attr.attr,
+	&transport_id_fcp_port_name_attr.attr,
+	NULL
+};
+
+static struct attribute *transport_id_sbp_attrs[] =3D {
+	&transport_id_def_proto_attr.attr,
+	&transport_id_def_format_attr.attr,
+	&transport_id_sbp_name_attr.attr,
+	NULL
+};
+
+static struct attribute *transport_id_srp_attrs[] =3D {
+	&transport_id_def_proto_attr.attr,
+	&transport_id_def_format_attr.attr,
+	&transport_id_srp_port_id_attr.attr,
+	NULL
+};
+
+static struct attribute *transport_id_sas_attrs[] =3D {
+	&transport_id_def_proto_attr.attr,
+	&transport_id_def_format_attr.attr,
+	&transport_id_sas_addr_attr.attr,
+	NULL
+};
+
+static struct attribute *transport_id_iscsi_attrs[] =3D {
+	&transport_id_def_proto_attr.attr,
+	&transport_id_def_format_attr.attr,
+	&transport_id_iscsi_name_attr.attr,
+	&transport_id_iscsi_session_id_attr.attr,
+	NULL
+};
+
+static const struct attribute_group transport_id_fcp_attr_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_fcp_attrs,
+};
+
+static const struct attribute_group transport_id_sbp_attr_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_sbp_attrs,
+};
+
+static const struct attribute_group transport_id_srp_attr_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_srp_attrs,
+};
+
+static const struct attribute_group transport_id_sas_attr_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_sas_attrs,
+};
+
+static const struct attribute_group transport_id_iscsi_attr_group =3D {
+	.name =3D "transport_id",
+	.attrs =3D transport_id_iscsi_attrs,
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
+static struct kobj_type session_ktype =3D {
+	.sysfs_ops	=3D &session_sysfs_ops,
+	.release	=3D target_sysfs_session_release,
+	.default_groups	=3D session_groups,
+};
+
+void target_sysfs_init_session(struct se_session *se_sess)
+{
+	kobject_init(&se_sess->kobj, &session_ktype);
+}
+
+static int add_transport_id_attrs(struct se_session *se_sess)
+{
+	int ret =3D 0;
+
+	switch (se_sess->tpid->proto) {
+
+	case SCSI_PROTOCOL_FCP:
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 &transport_id_fcp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SBP:
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 &transport_id_sbp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SRP:
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 &transport_id_srp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SAS:
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 &transport_id_sas_attr_group);
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 &transport_id_iscsi_attr_group);
+		break;
+	}
+
+	return ret;
+}
+
+static void remove_transport_id_attrs(struct se_session *se_sess)
+{
+	switch (se_sess->tpid->proto) {
+	case SCSI_PROTOCOL_FCP:
+		sysfs_remove_group(&se_sess->kobj,
+				   &transport_id_fcp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SBP:
+		sysfs_remove_group(&se_sess->kobj,
+				   &transport_id_sbp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SRP:
+		sysfs_remove_group(&se_sess->kobj,
+				   &transport_id_srp_attr_group);
+		break;
+	case SCSI_PROTOCOL_SAS:
+		sysfs_remove_group(&se_sess->kobj,
+				   &transport_id_sas_attr_group);
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		sysfs_remove_group(&se_sess->kobj,
+				   &transport_id_iscsi_attr_group);
+		break;
+	}
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
+	ret =3D add_transport_id_attrs(se_sess);
+	if (ret)
+		goto del_kobj;
+
+	if (se_sess->tfo->session_attrs) {
+		ret =3D sysfs_create_group(&se_sess->kobj,
+					 se_sess->tfo->session_attrs);
+		if (ret)
+			goto rm_tpid_grps;
+	}
+	se_sess->sysfs_added =3D true;
+
+	return 0;
+
+rm_tpid_grps:
+	remove_transport_id_attrs(se_sess);
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
+	remove_transport_id_attrs(se_sess);
+
+	if (se_sess->tfo->session_attrs)
+		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
+	kobject_del(&se_sess->kobj);
+}
+EXPORT_SYMBOL(target_sysfs_remove_session);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 66f0af1..d3248d4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -42,6 +42,8 @@
=20
 static struct workqueue_struct *target_completion_wq;
 static struct kmem_cache *se_sess_cache;
+static DEFINE_MUTEX(se_sess_idr_mutex);
+static DEFINE_IDR(se_sess_idr);
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
@@ -251,14 +253,32 @@ struct se_session *transport_alloc_session(enum tar=
get_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret =3D transport_init_session(se_sess);
+
+	mutex_lock(&se_sess_idr_mutex);
+	ret =3D idr_alloc_cyclic(&se_sess_idr, NULL, 1, 0, GFP_KERNEL);
+	if (ret >=3D 0)
+		se_sess->sid =3D ret;
+	mutex_unlock(&se_sess_idr_mutex);
 	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		pr_err("Unable to allocate session index.\n");
+		goto free_sess;
 	}
-	se_sess->sup_prot_ops =3D sup_prot_ops;
=20
+	ret =3D transport_init_session(se_sess);
+	if (ret < 0)
+		goto free_sid;
+
+	se_sess->sup_prot_ops =3D sup_prot_ops;
+	target_sysfs_init_session(se_sess);
 	return se_sess;
+
+free_sid:
+	mutex_lock(&se_sess_idr_mutex);
+	idr_remove(&se_sess_idr, se_sess->sid);
+	mutex_unlock(&se_sess_idr_mutex);
+free_sess:
+	kmem_cache_free(se_sess_cache, se_sess);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
=20
@@ -585,12 +605,23 @@ void transport_free_session(struct se_session *se_s=
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
+	mutex_lock(&se_sess_idr_mutex);
+	idr_remove(&se_sess_idr, se_sess->sid);
+	mutex_unlock(&se_sess_idr_mutex);
+
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 static int target_release_res(struct se_device *dev, void *data)
 {
 	struct se_session *sess =3D data;
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index b48f8cf..61115b7 100644
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
@@ -633,6 +634,7 @@ struct se_session {
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
+	char			*acl_name;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
 	struct percpu_ref	cmd_count;
@@ -643,6 +645,10 @@ struct se_session {
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

