Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39588C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D3D20CC7
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hb44LLRh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgF0Ef3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgF0Ef1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4W2Lq044988;
        Sat, 27 Jun 2020 04:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=iZJvKGQ3yyFMZyhm/t9A/kwXuZeEZcFLExLOfYS6SHk=;
 b=Hb44LLRhHzVFlX76oEzWwbwMFKCnd/VrG3OXH5siFOcTv/LWJDCHbmldzjTlUF9FTpHp
 b3+P9NV/ECG0XoK5kpet60fbhdfOFosWrVP/L0EEY4adeU/+/tPg1AeZZyNpEI3KlFQa
 6/tvxSe0vlrvl8cA6UlZnp+O343Kabm28maDMVNzGmSscNu5Ra6xTBsEPsA7/piw15Ng
 Om7qIfznlJaLVRDeTge3gQzhmET1vtUWd59jqcIKtPBlggmu2KA+ZFHkO756W83qdyJ7
 mCWbLEF7jiSujpjL++BJW9pioWDqwybKccSiCao3xFitSA8AwocYkBTFJJcM060N40mM MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31wx2m82g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4YMdk050735;
        Sat, 27 Jun 2020 04:35:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31wwwyvnqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4ZHYU030608;
        Sat, 27 Jun 2020 04:35:17 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 10/10] target: export sessions via configfs
Date:   Fri, 26 Jun 2020 23:35:09 -0500
Message-Id: <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 impostorscore=0 cotscore=-2147483648 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch exports the LIO sessions via configfs. If userspace makes
a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
supports the new interface on that TPG, then the kernel will make a
dir per session in the tpg/sessions or tpg/acls/alc/sessions dir

It works similar to how some targets export their session info today
where if it's dynamic session then it goes in the tpg dir and if
there is an ACL then it goes in the acl's sessions dir. The name of
the dir is "session-$sid".

qla2xxx example:

For ACL based sessions:

├── 21:00:00:24:ff:46:b8:88
│   ├── fabric_statistics
│   └── tpgt_1
│       ├── acls
│       │   └── 21:00:00:24:ff:46:b8:8a
│       │       └── sessions
│       │           └── session-1


or for a dynamic session it would be in the tpg dir
.....

│       ├── param
│       └── sessions
│           └── session-1



There is currently nothing in the session-$sid dir. To make the RFC
easier to read I did not post the transport id patches or the iscsi
conversion one, but on the final send I'll include them.

Note/Warning:

The interface has 2 quirks:

1. It works similar to the loop/vhost/usb/xen nexus file interface
where instead of a rmdir to delete the session you write to some special
file. For this new interface we have:

/fabric/target/tpgt/sessions/remove_session

2. Because the kernel is making the session, there is no mkdir/rmdir
support for each session like other objects like LUN, tpg, target, np,
etc. But, before we remove the parent tpg, we have to remove the
children sessions still. This gives configfs the behavior it expects
where parents can't be removed before children and we will not hit
issues like we hit before.

To signal that this new requirement is supported, userspace must do
mkdir "sessions" on the tpg/acl to create the root sessions dir that
will contain the individual sessions. See this rtslib patch:

https://github.com/mikechristie/rtslib-fb/commit/4af906d2955b739c0585d81b4b1a0d498cc2f663

If userspace does not do a mkdir "sessions" on the tpg, then the old
behavior is supported (we just don't register the session in configfs)
for that tpg.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_configfs.c | 187 +++++++++++++++++++++++++--
 drivers/target/target_core_transport.c       |   5 +
 include/target/target_core_base.h            |   4 +
 include/target/target_core_fabric.h          |   4 +-
 4 files changed, 189 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 2b70bdf..3c1288b 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -322,15 +322,45 @@ static struct config_group *target_fabric_make_mappedlun(
 	return ERR_PTR(ret);
 }
 
-static void target_fabric_drop_mappedlun(
-	struct config_group *group,
-	struct config_item *item)
+static struct config_item_type target_nacl_sess_type = {
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct config_group *
+target_make_nacl_sess_group(struct config_group *group)
 {
-	struct se_lun_acl *lacl = container_of(to_config_group(item),
-			struct se_lun_acl, se_lun_group);
+	struct se_node_acl *se_nacl = container_of(group, struct se_node_acl,
+						   acl_group);
+	struct se_portal_group *se_tpg = se_nacl->se_tpg;
+
+	config_group_init_type_name(&se_nacl->acl_sess_group, "sessions",
+				    &target_nacl_sess_type);
+	se_tpg->cfgfs_sess_supp = true;
+
+	return &se_nacl->acl_sess_group;
+}
+
+static struct config_group *target_make_nacl_group(struct config_group *group,
+						   const char *name)
+{
+	if (!strcmp(name, "sessions")) {
+		return target_make_nacl_sess_group(group);
+	} else {
+		return target_fabric_make_mappedlun(group, name);
+	}
+}
 
-	configfs_remove_default_groups(&lacl->ml_stat_grps.stat_group);
-	configfs_remove_default_groups(&lacl->se_lun_group);
+static void target_drop_nacl_group(struct config_group *group,
+				   struct config_item *item)
+{
+	struct se_lun_acl *lacl;
+
+	if (strstr(config_item_name(item), "lun_")) {
+		lacl = container_of(to_config_group(item), struct se_lun_acl,
+				    se_lun_group);
+		configfs_remove_default_groups(&lacl->ml_stat_grps.stat_group);
+		configfs_remove_default_groups(&lacl->se_lun_group);
+	}
 
 	config_item_put(item);
 }
@@ -349,8 +379,8 @@ static void target_fabric_nacl_base_release(struct config_item *item)
 };
 
 static struct configfs_group_operations target_fabric_nacl_base_group_ops = {
-	.make_group		= target_fabric_make_mappedlun,
-	.drop_item		= target_fabric_drop_mappedlun,
+	.make_group		= target_make_nacl_group,
+	.drop_item		= target_drop_nacl_group,
 };
 
 TF_CIT_SETUP_DRV(tpg_nacl_base, &target_fabric_nacl_base_item_ops,
@@ -799,6 +829,8 @@ static void target_fabric_drop_lun(
 TF_CIT_SETUP_DRV(tpg_auth, NULL, NULL);
 TF_CIT_SETUP_DRV(tpg_param, NULL, NULL);
 
+/* Start of tfc_tpg_session_cit */
+
 static void target_cfgfs_sess_release(struct config_item *item)
 {
 	struct se_session *se_sess = container_of(to_config_group(item),
@@ -832,6 +864,82 @@ int target_cfgfs_init_session(struct se_session *se_sess)
 	return 0;
 }
 
+int target_cfgfs_register_session(struct se_portal_group *se_tpg,
+				  struct se_session *se_sess)
+{
+	struct se_node_acl *se_nacl;
+	int ret;
+
+	/*
+	 * If the fabric doesn't support close_session, there's no way for
+	 * userspace to clean up the session during nacl/tpg deletion.
+	 */
+	if (!se_tpg->cfgfs_sess_supp || !se_tpg->se_tpg_tfo->close_session)
+		return 0;
+
+	se_nacl = se_sess->se_node_acl;
+	if (se_nacl->dynamic_node_acl) {
+		ret = configfs_register_group(&se_tpg->tpg_sess_group,
+					      &se_sess->group);
+	} else {
+		ret = configfs_register_group(&se_nacl->acl_sess_group,
+					      &se_sess->group);
+	}
+	if (ret)
+		goto fail;
+
+	/*
+	 * The session is not created via a mkdir like other objects. A
+	 * transport event like a login or userspace used the nexus file to
+	 * initiate creation. However, we want the same behavior as other
+	 * objects where we must remove the children before removing the
+	 * parent dir, so do a depend on the parent that is released when the
+	 * session is removed.
+	 */
+	if (se_nacl->dynamic_node_acl) {
+		ret = target_depend_item(&se_tpg->tpg_sess_group.cg_item);
+	} else {
+		ret = target_depend_item(&se_nacl->acl_sess_group.cg_item);
+	}
+	if (ret)
+		goto unreg_cfgfs;
+
+	se_sess->added_to_cfgfs = true;
+	return 0;
+
+unreg_cfgfs:
+	configfs_unregister_group(&se_sess->group);
+fail:
+	pr_err("Could not register session dir %d. Error %d.\n", se_sess->sid,
+	       ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(target_cfgfs_register_session);
+
+void target_cfgfs_unregister_session(struct se_session *se_sess)
+{
+	struct se_node_acl *se_nacl;
+
+	/*
+	 * The session attr interface may not be enabled and discovery
+	 * sessions are not registered.
+	 */
+	if (!se_sess->added_to_cfgfs)
+		return;
+
+	configfs_unregister_group(&se_sess->group);
+
+	se_nacl = se_sess->se_node_acl;
+	if (se_nacl->dynamic_node_acl) {
+		target_undepend_item(&se_sess->se_tpg->tpg_sess_group.cg_item);
+	} else {
+		target_undepend_item(&se_nacl->acl_sess_group.cg_item);
+	}
+}
+EXPORT_SYMBOL_GPL(target_cfgfs_unregister_session);
+
+/* End of tfc_tpg_session_cit */
+
 /* Start of tfc_tpg_base_cit */
 
 static void target_fabric_tpg_release(struct config_item *item)
@@ -848,7 +956,66 @@ static void target_fabric_tpg_release(struct config_item *item)
 	.release		= target_fabric_tpg_release,
 };
 
-TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops, NULL);
+static ssize_t target_tpg_remove_session_store(struct config_item *item,
+					       const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = container_of(to_config_group(item),
+						      struct se_portal_group,
+						      tpg_sess_group);
+	int ret, sid;
+
+	ret = kstrtoint(page, 10, &sid);
+	if (ret < 0)
+		return ret;
+
+	ret = target_close_session_sync(se_tpg, sid);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+CONFIGFS_ATTR_WO(target_tpg_, remove_session);
+
+static struct configfs_attribute *target_tpg_sess_attrs[] = {
+	&target_tpg_attr_remove_session,
+	NULL,
+};
+
+static struct config_item_type target_tpg_sess_type = {
+	.ct_owner	= THIS_MODULE,
+	.ct_attrs	= target_tpg_sess_attrs,
+};
+
+static struct config_group *
+target_make_tpg_sess_group(struct config_group *group, const char *name)
+{
+	struct se_portal_group *se_tpg = container_of(group,
+						      struct se_portal_group,
+						      tpg_group);
+
+	if (strcmp(name, "sessions"))
+		return ERR_PTR(-EINVAL);
+
+	config_group_init_type_name(&se_tpg->tpg_sess_group, name,
+				    &target_tpg_sess_type);
+	se_tpg->cfgfs_sess_supp = true;
+
+	return &se_tpg->tpg_sess_group;
+}
+
+static void target_drop_tpg_sess_group(struct config_group *group,
+				       struct config_item *item)
+{
+	config_item_put(item);
+}
+
+static struct configfs_group_operations target_tpg_sess_group_ops = {
+	.make_group	= target_make_tpg_sess_group,
+	.drop_item	= target_drop_tpg_sess_group,
+};
+
+TF_CIT_SETUP_DRV(tpg_base, &target_fabric_tpg_base_item_ops,
+		 &target_tpg_sess_group_ops);
 
 /* End of tfc_tpg_base_cit */
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 942b0c5..87aac76 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -480,6 +480,10 @@ struct se_session *
 		rc = -EACCES;
 		goto free_session;
 	}
+
+	rc = target_cfgfs_register_session(tpg, sess);
+	if (rc)
+		goto free_session;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -775,6 +779,7 @@ void target_remove_session(struct se_session *se_sess)
 	se_sess->sess_remove_running = 1;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
+	target_cfgfs_unregister_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 690fff2..f78c1f4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -571,6 +571,7 @@ struct se_node_acl {
 	struct config_group	acl_auth_group;
 	struct config_group	acl_param_group;
 	struct config_group	acl_fabric_stat_group;
+	struct config_group	acl_sess_group;
 	struct list_head	acl_list;
 	struct list_head	acl_sess_list;
 	struct completion	acl_free_comp;
@@ -626,6 +627,7 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	int			sid;
+	bool			added_to_cfgfs;
 	struct config_group	group;
 	const struct target_core_fabric_ops *tfo;
 };
@@ -887,6 +889,7 @@ struct se_portal_group {
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
 	struct mutex		tpg_lun_mutex;
+	bool			cfgfs_sess_supp;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
 	struct hlist_head	tpg_lun_hlist;
@@ -903,6 +906,7 @@ struct se_portal_group {
 	struct config_group	tpg_attrib_group;
 	struct config_group	tpg_auth_group;
 	struct config_group	tpg_param_group;
+	struct config_group	tpg_sess_group;
 };
 
 static inline struct se_portal_group *to_tpg(struct config_item *item)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index e200faa..1582455 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -154,7 +154,9 @@ void	transport_register_session(struct se_portal_group *,
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-
+int	target_cfgfs_register_session(struct se_portal_group *,
+				      struct se_session *);
+void	target_cfgfs_unregister_session(struct se_session *);
 
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
-- 
1.8.3.1

