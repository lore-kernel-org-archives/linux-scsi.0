Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F98C54FCF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E410B2074F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ssaik5Hn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgDTTPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727985AbgDTTPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YiA1+BOH8JzV7idQWE/WfzPFNSIoRbQCQJnYYp3po/M=;
        b=Ssaik5HneNKIdY+n/SXa1dtEX42HbQF7F2oElvko1PUDdXb3YaSV+qAmiExCG7Z2FqnP3W
        9RECLv9L8I2pV+m24Bh0H2tAsFBWXbJHOrIgd3B8irnbbLaTZ2h8QZXK+EbOVccMqUwpkg
        et7fITdmKhwIblOzkyiZWdE9gsn7fn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-Nlr_NaeaPdGNVR59xdVbtw-1; Mon, 20 Apr 2020 15:14:57 -0400
X-MC-Unique: Nlr_NaeaPdGNVR59xdVbtw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE1E78017F6;
        Mon, 20 Apr 2020 19:14:55 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE4CAA1898;
        Mon, 20 Apr 2020 19:14:54 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 07/12] target: add sysfs support
Date:   Mon, 20 Apr 2020 14:14:21 -0500
Message-Id: <20200420191426.17055-8-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

configfs does not work well when the kernel is initiating the creation
of an object we want to export info for and the objects above/below it
are created by the user. There are races/bugs like seen with this patch
and the issue the original bug was trying to fix:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts

The problem is that for many drivers like qla2xxx, iscsi, etc, session
creation is done by the kernel when there is a login initiated by an
initiator, but we need a common way to export the systems sessions so
tools like targetcli can report basic info like what initaitors are
logged in and daemons like tcmu-runner can track sessions for load
balancing and PGRs.

This patch begins to add a sysfs interface that will initially be used
to export LIO's sessions. The general layout will mirror the lio
configfs tree:

scsi_target /
`-- $fabric_driver
    `-- target_name
        |-- tpgt_1
        |   `-- sessions
        `-- tpgt_2
            `-- sessions

iscsi example:
scsi_target /
`-- iscsi
    `-- iqn.1999-09.com.lio:tgt1
        |-- tpgt_1
        |   `-- sessions
        `-- tpgt_2
            `-- sessions

This initial patch adds only adds the upper layer dirs above the
sessions.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---

V2:
- rename top level dir to scsi_target

 drivers/target/target_core_configfs.c        | 21 ++++++++++++++++++
 drivers/target/target_core_fabric_configfs.c | 32 ++++++++++++++++++++++=
++++++
 drivers/target/target_core_internal.h        |  1 +
 include/target/target_core_base.h            |  4 ++++
 4 files changed, 58 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
index e6e1755..7e21b87 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -63,6 +63,8 @@
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
=20
+static struct kobject *tcm_core_kobj;
+
 extern struct t10_alua_lu_gp *default_lu_gp;
=20
 static LIST_HEAD(g_tf_list);
@@ -245,6 +247,11 @@ static struct config_group *target_core_register_fab=
ric(
 	}
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
 			" %s\n", tf->tf_ops->fabric_name);
+
+	tf->kobj =3D kobject_create_and_add(name, tcm_core_kobj);
+	if (!tf->kobj)
+		goto dec_tf;
+
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
@@ -261,6 +268,10 @@ static struct config_group *target_core_register_fab=
ric(
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
 		 config_item_name(&tf->tf_group.cg_item));
 	return &tf->tf_group;
+
+dec_tf:
+	atomic_dec(&tf->tf_access_cnt);
+	return ERR_PTR(-EINVAL);
 }
=20
 /*
@@ -283,6 +294,9 @@ static void target_core_deregister_fabric(
 	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
 			" %s\n", config_item_name(item));
=20
+	kobject_del(tf->kobj);
+	kobject_put(tf->kobj);
+
 	configfs_remove_default_groups(&tf->tf_group);
 	config_item_put(item);
 }
@@ -3536,6 +3550,10 @@ static int __init target_core_init_configfs(void)
=20
 	target_init_dbroot();
=20
+	tcm_core_kobj =3D kobject_create_and_add("scsi_target", NULL);
+	if (!tcm_core_kobj)
+		goto out;
+
 	return 0;
=20
 out:
@@ -3553,6 +3571,9 @@ static int __init target_core_init_configfs(void)
=20
 static void __exit target_core_exit_configfs(void)
 {
+	kobject_del(tcm_core_kobj);
+	kobject_put(tcm_core_kobj);
+
 	configfs_remove_default_groups(&alua_lu_gps_group);
 	configfs_remove_default_groups(&alua_group);
 	configfs_remove_default_groups(&target_core_hbagroup);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
index ee85602..4d208e4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -838,6 +838,14 @@ static struct config_group *target_fabric_make_tpg(
 	if (!se_tpg || IS_ERR(se_tpg))
 		return ERR_PTR(-EINVAL);
=20
+	se_tpg->kobj =3D kobject_create_and_add(name, wwn->kobj);
+	if (!se_tpg->kobj)
+		goto drop_tpg;
+
+	se_tpg->sessions_kobj =3D kobject_create_and_add("sessions", se_tpg->ko=
bj);
+	if (!se_tpg->sessions_kobj)
+		goto del_tpg_kobj;
+
 	config_group_init_type_name(&se_tpg->tpg_group, name,
 			&tf->tf_tpg_base_cit);
=20
@@ -872,6 +880,13 @@ static struct config_group *target_fabric_make_tpg(
 			&se_tpg->tpg_group);
=20
 	return &se_tpg->tpg_group;
+
+del_tpg_kobj:
+	kobject_del(se_tpg->kobj);
+	kobject_put(se_tpg->kobj);
+drop_tpg:
+	tf->tf_ops->fabric_drop_tpg(se_tpg);
+	return ERR_PTR(-EINVAL);
 }
=20
 static void target_fabric_drop_tpg(
@@ -881,6 +896,12 @@ static void target_fabric_drop_tpg(
 	struct se_portal_group *se_tpg =3D container_of(to_config_group(item),
 				struct se_portal_group, tpg_group);
=20
+	kobject_del(se_tpg->sessions_kobj);
+	kobject_put(se_tpg->sessions_kobj);
+
+	kobject_del(se_tpg->kobj);
+	kobject_put(se_tpg->kobj);
+
 	configfs_remove_default_groups(&se_tpg->tpg_group);
 	config_item_put(item);
 }
@@ -927,6 +948,7 @@ static struct config_group *target_fabric_make_wwn(
 	struct target_fabric_configfs *tf =3D container_of(group,
 				struct target_fabric_configfs, tf_group);
 	struct se_wwn *wwn;
+	int ret;
=20
 	if (!tf->tf_ops->fabric_make_wwn) {
 		pr_err("tf->tf_ops.fabric_make_wwn is NULL\n");
@@ -938,6 +960,9 @@ static struct config_group *target_fabric_make_wwn(
 		return ERR_PTR(-EINVAL);
=20
 	wwn->wwn_tf =3D tf;
+	wwn->kobj =3D kobject_create_and_add(name, tf->kobj);
+	if (!wwn->kobj)
+		goto drop_wwn;
=20
 	config_group_init_type_name(&wwn->wwn_group, name, &tf->tf_tpg_cit);
=20
@@ -947,7 +972,12 @@ static struct config_group *target_fabric_make_wwn(
=20
 	if (tf->tf_ops->add_wwn_groups)
 		tf->tf_ops->add_wwn_groups(wwn);
+
 	return &wwn->wwn_group;
+
+drop_wwn:
+	tf->tf_ops->fabric_drop_wwn(wwn);
+	return ERR_PTR(ret);
 }
=20
 static void target_fabric_drop_wwn(
@@ -957,6 +987,8 @@ static void target_fabric_drop_wwn(
 	struct se_wwn *wwn =3D container_of(to_config_group(item),
 				struct se_wwn, wwn_group);
=20
+	kobject_del(wwn->kobj);
+	kobject_put(wwn->kobj);
 	configfs_remove_default_groups(&wwn->wwn_group);
 	config_item_put(item);
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index efc5449..d242a97 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -27,6 +27,7 @@ struct target_backend {
 struct target_fabric_configfs {
 	atomic_t		tf_access_cnt;
 	struct list_head	tf_list;
+	struct kobject		*kobj;
 	struct config_group	tf_group;
 	struct config_group	tf_disc_group;
 	const struct target_core_fabric_ops *tf_ops;
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index cd440ea..b48f8cf 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,6 +8,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
+#include <linux/kobject.h>
=20
 #define TARGET_CORE_VERSION		"v5.0"
=20
@@ -909,6 +910,8 @@ struct se_portal_group {
 	/* Pointer to $FABRIC_MOD dependent code */
 	const struct target_core_fabric_ops *se_tpg_tfo;
 	struct se_wwn		*se_tpg_wwn;
+	struct kobject		*kobj;
+	struct kobject		*sessions_kobj;
 	struct config_group	tpg_group;
 	struct config_group	tpg_lun_group;
 	struct config_group	tpg_np_group;
@@ -947,6 +950,7 @@ struct se_wwn {
 	void			*priv;
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
+	struct kobject		*kobj;
 };
=20
 static inline void atomic_inc_mb(atomic_t *v)
--=20
1.8.3.1

