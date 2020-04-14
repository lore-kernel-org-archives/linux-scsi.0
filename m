Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8584FC2BB85
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA64206E9
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+NeEt6O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405429AbgDNFPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 01:15:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729007AbgDNFP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 01:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586841323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yuCz3EgLLPyYOmIUEQtKgiuXh5DQ7wvAQ0gj60Jez3M=;
        b=H+NeEt6O7Il4HSPBpvj7KAPh+PORq3mti1wT3fHkIzTicUM83lLxibZT4dySPzFAf+oihI
        GMtqbEhXwyNTywGzq4VfUTXqDVvWdC2/jd/iC5gdBLPqzSdTIJJzWfG9ZQf9ajY5sLrIwf
        2kNL08sIWq9jIwc/o2w9fwhk89ISxOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-iWjna8kTMO-s_SC0GxZz9w-1; Tue, 14 Apr 2020 01:15:20 -0400
X-MC-Unique: iWjna8kTMO-s_SC0GxZz9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05D041005509;
        Tue, 14 Apr 2020 05:15:19 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-112-105.rdu2.redhat.com [10.10.112.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21E821000325;
        Tue, 14 Apr 2020 05:15:18 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 2/5] target: add sysfs session helper functions
Date:   Tue, 14 Apr 2020 00:15:11 -0500
Message-Id: <20200414051514.7296-3-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-1-mchristi@redhat.com>
References: <20200414051514.7296-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds helpers to add/remove a dir per session. There is
only one default file in there which points to the ACL being used
if there is one.

iSCSI example:

target_core/
=E2=94=94=E2=94=80=E2=94=80 iscsi
    =E2=94=94=E2=94=80=E2=94=80 iqn.1999-09.com.tcmu:alua
        =E2=94=94=E2=94=80=E2=94=80 tpgt_1
            =E2=94=94=E2=94=80=E2=94=80 sessions
                =E2=94=94=E2=94=80=E2=94=80 session-1
                    =E2=94=94=E2=94=80=E2=94=80 acl

cat acl=20
iqn.2005-03.com.ceph:ini1

Fabric drivers like iscsi or elx can add pass in an attribute_group
to add driver specific attrs.

This patch just adds the helpers and does the initial kobject refcount
hookup. The next 2 patches will convert lio core and the fabric drivers
like iscsi to use these functions.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/Makefile                      |   1 +
 drivers/target/target_core_fabric_configfs.c |   3 +
 drivers/target/target_core_internal.h        |   4 +
 drivers/target/target_core_sysfs.c           | 143 +++++++++++++++++++++=
++++++
 drivers/target/target_core_transport.c       |   9 +-
 include/target/target_core_base.h            |   5 +
 include/target/target_core_fabric.h          |   5 +-
 7 files changed, 168 insertions(+), 2 deletions(-)
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
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
index 4d208e4..b37c530 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -960,6 +960,8 @@ static struct config_group *target_fabric_make_wwn(
 		return ERR_PTR(-EINVAL);
=20
 	wwn->wwn_tf =3D tf;
+	ida_init(&wwn->sid_ida);
+
 	wwn->kobj =3D kobject_create_and_add(name, tf->kobj);
 	if (!wwn->kobj)
 		goto drop_wwn;
@@ -987,6 +989,7 @@ static void target_fabric_drop_wwn(
 	struct se_wwn *wwn =3D container_of(to_config_group(item),
 				struct se_wwn, wwn_group);
=20
+	ida_destroy(&wwn->sid_ida);
 	kobject_del(wwn->kobj);
 	kobject_put(wwn->kobj);
 	configfs_remove_default_groups(&wwn->wwn_group);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index 16ae020..1b683ce 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -106,6 +106,9 @@ int	target_get_pr_transport_id(struct se_node_acl *na=
cl,
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg=
,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
=20
+/* target_core_sysfs.c */
+void	target_sysfs_init_session(struct se_session *sess);
+
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
 int	core_delete_hba(struct se_hba *);
@@ -153,6 +156,7 @@ void	transport_dump_dev_info(struct se_device *, stru=
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
index 0000000..d4f9d33
--- /dev/null
+++ b/drivers/target/target_core_sysfs.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kobject.h>
+#include <linux/idr.h>
+
+#include <target/target_core_base.h>
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
+static ssize_t session_acl_show(struct se_session *se_sess, char *page)
+{
+	struct se_node_acl *acl;
+	ssize_t len;
+
+	acl =3D se_sess->se_node_acl;
+	if (!acl)
+		return -ENOTCONN;
+
+	if (acl->dynamic_node_acl) {
+		page[0] =3D '\0';
+		len =3D 0;
+	} else {
+		len =3D snprintf(page, PAGE_SIZE, "%s\n", acl->initiatorname);
+	}
+
+	return len;
+}
+
+static struct session_attr session_acl_attr =3D {
+	.attr =3D { .name =3D "acl", .mode =3D 0444 },
+	.show =3D session_acl_show,
+};
+
+static struct attribute *session_attrs[] =3D {
+	&session_acl_attr.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(session);
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
+int target_sysfs_add_session(struct se_portal_group *se_tpg,
+			     struct se_session *se_sess,
+			     struct attribute_group *fabric_attrs)
+{
+	int ret;
+
+	ret =3D ida_simple_get(&se_tpg->se_tpg_wwn->sid_ida, 1, 0, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("Could not allocate session id. Error %d.\n", ret);
+		return ret;
+	}
+	se_sess->sid =3D ret;
+
+	ret =3D kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "session-%d"=
,
+			  se_sess->sid);
+	if (ret) {
+		pr_err("Could not add session%d to sysfs. Error %d.\n",
+		       se_sess->sid, ret);
+		goto remove_id;
+	}
+
+	if (fabric_attrs) {
+		ret =3D sysfs_create_group(&se_sess->kobj, fabric_attrs);
+		if (ret)
+			goto del_kobj;
+		se_sess->fabric_attrs =3D fabric_attrs;=09
+	}
+
+	return 0;
+
+del_kobj:
+	kobject_del(&se_sess->kobj);
+remove_id:
+	ida_simple_remove(&se_tpg->se_tpg_wwn->sid_ida, se_sess->sid);
+	return ret;
+}
+EXPORT_SYMBOL(target_sysfs_add_session);
+
+void target_sysfs_remove_session(struct se_session *se_sess)
+{
+	/* discovery sessions are normally not added to sysfs */
+	if (!se_sess->sid)
+		return;
+
+	if (se_sess->fabric_attrs)
+		sysfs_remove_group(&se_sess->kobj, se_sess->fabric_attrs);
+	ida_simple_remove(&se_sess->se_tpg->se_tpg_wwn->sid_ida, se_sess->sid);
+	kobject_del(&se_sess->kobj);
+}
+EXPORT_SYMBOL(target_sysfs_remove_session);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 594b724..fba059c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -257,6 +257,7 @@ struct se_session *transport_alloc_session(enum targe=
t_prot_op sup_prot_ops)
 		return ERR_PTR(ret);
 	}
 	se_sess->sup_prot_ops =3D sup_prot_ops;
+	target_sysfs_init_session(se_sess);
=20
 	return se_sess;
 }
@@ -537,8 +538,15 @@ void transport_deregister_session_configfs(struct se=
_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session_configfs);
=20
+
 void transport_free_session(struct se_session *se_sess)
 {
+	kobject_put(&se_sess->kobj);
+}
+EXPORT_SYMBOL(transport_free_session);
+
+void __target_free_session(struct se_session *se_sess)
+{
 	struct se_node_acl *se_nacl =3D se_sess->se_node_acl;
=20
 	/*
@@ -582,7 +590,6 @@ void transport_free_session(struct se_session *se_ses=
s)
 	percpu_ref_exit(&se_sess->cmd_count);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
-EXPORT_SYMBOL(transport_free_session);
=20
 static int target_release_res(struct se_device *dev, void *data)
 {
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index 9d38b53..3bc2498 100644
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
@@ -624,6 +625,9 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct kobject		kobj;
+	int			sid;
+	struct attribute_group	*fabric_attrs;
 };
=20
 struct se_device;
@@ -932,6 +936,7 @@ struct se_wwn {
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
 	struct kobject		*kobj;
+	struct ida		sid_ida;
 };
=20
 static inline void atomic_inc_mb(atomic_t *v)
diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h
index 063f133..5948b87 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -146,7 +146,10 @@ void	transport_register_session(struct se_portal_gro=
up *,
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-
+void	target_sysfs_remove_session(struct se_session *se_sess);
+int	target_sysfs_add_session(struct se_portal_group *se_tpg,
+				 struct se_session *se_sess,
+				 struct attribute_group *fabric_attrs);
=20
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
--=20
1.8.3.1

