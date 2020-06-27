Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8ACC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A024E20CC7
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ByR7Ht2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgF0Eh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:37:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgF0Eh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:37:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Xbgh045573;
        Sat, 27 Jun 2020 04:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0Ib3BPGcSzo6bo+zutPufsN+YCglmBLlgJqbRwDzxO8=;
 b=ByR7Ht2i6ON97Y6541d0OZKb/YA6I2DAg0+Dx2V4qngJutpczXkquGj4xPN7QR7W+XwD
 ABYWhRG9fcoXACRzGWHUmogXo/EXA144kAjowySWyA75BXwLxX4VgaWwZiMZWQh61Bmh
 Pm2A72ERLIXkam/glF1VUX1sXoBqsdQxbmTGUOti7q9oaZMjxAFCdFLxYub5hyw1c23s
 EXZFmeX4wTUAA0sNSXCgnzu5joTOA6h1gGj67cHlkNGH1Y2dKcrRkBmqGaStPj867mT7
 LmkQyrQ0zkR0TeSio+dZAs+Yw0tmns0AtmhE5L1qkJY2/iOLKKHmEmYZSfeERWgJTF0j ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31wx2m82hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:37:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y9vh122016;
        Sat, 27 Jun 2020 04:35:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31wv58v89w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4ZEqJ004205;
        Sat, 27 Jun 2020 04:35:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 05/10] target: add free_session callout and use cfgfs refcounts
Date:   Fri, 26 Jun 2020 23:35:04 -0500
Message-Id: <1593232509-13720-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 impostorscore=0 cotscore=-2147483648 priorityscore=1501 malwarescore=0
 phishscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a free_session callout and uses the configfs refcounts to
determine when to free the session. Currently, when you delete an ACL it
will call into the fabric module to remove the session. While this is
happening userspace could be accessing a configfs file that accesses the
se_session. In many places we try to check for this by using the acl/tpg
locks. This patch has us to start using refcounts and release functions
so we can drop that locking.

This first patch just hooks us into the refcoutning. The next patches
will then add us into configfs and export some useful info.

Hannes, you had added your reviewed-by tag to the original version of
this patch:

target: add free_session callout

but I did not carry it over, because I modified it for the configfs
refcounts instead of being sysfs based.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c          |  6 +-
 drivers/target/iscsi/iscsi_target_configfs.c |  9 +++
 drivers/target/iscsi/iscsi_target_login.c    |  8 +--
 drivers/target/target_core_fabric_configfs.c | 33 +++++++++++
 drivers/target/target_core_internal.h        |  2 +
 drivers/target/target_core_transport.c       | 88 +++++++++++++++++++---------
 include/target/target_core_base.h            |  2 +
 include/target/target_core_fabric.h          | 15 ++++-
 8 files changed, 122 insertions(+), 41 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e3b3de6..9f215ff 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4386,8 +4386,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 		}
 	}
 
-	transport_deregister_session(sess->se_sess);
-
 	if (sess->sess_ops->ErrorRecoveryLevel == 2)
 		iscsit_free_connection_recovery_entries(sess);
 
@@ -4405,11 +4403,9 @@ int iscsit_close_session(struct iscsi_session *sess)
 	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
 
-	kfree(sess->sess_ops);
-	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
 
-	kfree(sess);
+	transport_deregister_session(sess->se_sess);
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index d8b657b..3e843b0 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1488,6 +1488,14 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	iscsit_dec_session_usage_count(sess);
 }
 
+static void lio_free_session(struct se_session *se_sess)
+{
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+
+	kfree(sess->sess_ops);
+	kfree(sess);
+}
+
 static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
 {
 	return iscsi_tpg(se_tpg)->tpg_tiqn->tiqn_index;
@@ -1537,6 +1545,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.check_stop_free		= lio_check_stop_free,
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
+	.free_session			= lio_free_session,
 	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 417b797..486297c 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -307,7 +307,8 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_sess;
 	}
 
-	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
+	sess->se_sess = transport_alloc_session(&iscsi_ops, TARGET_PROT_NORMAL,
+						sess);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -740,7 +741,7 @@ void iscsi_post_login_handler(
 
 	spin_lock_bh(&se_tpg->session_lock);
 	__transport_register_session(&sess->tpg->tpg_se_tpg,
-			se_sess->se_node_acl, se_sess, sess);
+				     se_sess->se_node_acl, se_sess);
 	pr_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 
@@ -1146,9 +1147,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		goto old_sess_out;
 
 	transport_free_session(conn->sess->se_sess);
-	kfree(conn->sess->sess_ops);
-	kfree(conn->sess);
-	conn->sess = NULL;
 
 old_sess_out:
 	iscsi_stop_login_thread_timer(np);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602..2b70bdf 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -799,6 +799,39 @@ static void target_fabric_drop_lun(
 TF_CIT_SETUP_DRV(tpg_auth, NULL, NULL);
 TF_CIT_SETUP_DRV(tpg_param, NULL, NULL);
 
+static void target_cfgfs_sess_release(struct config_item *item)
+{
+	struct se_session *se_sess = container_of(to_config_group(item),
+						  struct se_session, group);
+	target_release_session(se_sess);
+}
+
+static struct configfs_item_operations target_sess_item_ops = {
+	.release	= target_cfgfs_sess_release,
+};
+
+static struct config_item_type target_sess_type = {
+	.ct_owner	= THIS_MODULE,
+	.ct_item_ops	= &target_sess_item_ops,
+};
+
+int target_cfgfs_init_session(struct se_session *se_sess)
+{
+	int ret;
+
+	ret = config_item_set_name(&se_sess->group.cg_item, "session-%d",
+				   se_sess->sid);
+	if (ret) {
+		pr_err("Could not set configfs name for sid %d. Error %d.\n",
+		       se_sess->sid, ret);
+		return ret;
+	}
+
+	se_sess->group.cg_item.ci_type = &target_sess_type;
+	config_group_init(&se_sess->group);
+	return 0;
+}
+
 /* Start of tfc_tpg_base_cit */
 
 static void target_fabric_tpg_release(struct config_item *item)
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e7b3c6e..e92dcf2 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -92,6 +92,7 @@ int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 /* target_core_configfs.c */
 extern struct configfs_item_operations target_core_dev_item_ops;
 void	target_setup_backend_cits(struct target_backend *);
+int	target_cfgfs_init_session(struct se_session *);
 
 /* target_core_fabric_configfs.c */
 int	target_fabric_setup_cits(struct target_fabric_configfs *);
@@ -153,6 +154,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_release_session(struct se_session *);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0da9bba..8d11a8c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -246,9 +246,13 @@ void transport_uninit_session(struct se_session *se_sess)
 
 /**
  * transport_alloc_session - allocate a session object and initialize it
+ * @tfo: target core fabric ops
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ * @private: pointer to fabric session storage in fabric_sess_ptr
  */
-struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *tfo,
+					   enum target_prot_op sup_prot_ops,
+					   void *private)
 {
 	struct se_session *se_sess;
 	int ret;
@@ -259,6 +263,8 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
+	se_sess->fabric_sess_ptr = private;
+	se_sess->tfo = tfo;
 
 	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0) {
@@ -270,10 +276,20 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 	ret = transport_init_session(se_sess);
 	if (ret < 0)
 		goto free_ida;
-	se_sess->sup_prot_ops = sup_prot_ops;
 
+	/*
+	 * After this call we always (even if it does not get added to cfgfs)
+	 * use the cfg item refcounts to determine when to release the sess.
+	 */
+	ret = target_cfgfs_init_session(se_sess);
+	if (ret)
+		goto uninit_sess;
+
+	se_sess->sup_prot_ops = sup_prot_ops;
 	return se_sess;
 
+uninit_sess:
+	transport_uninit_session(se_sess);
 free_ida:
 	ida_simple_remove(&se_sess_ida, se_sess->sid);
 free_sess:
@@ -317,14 +333,17 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 
 /**
  * transport_init_session_tags - allocate a session and target driver private data
+ * @tfo: target core fabric ops
  * @tag_num:  Maximum number of in-flight commands between initiator and target.
  * @tag_size: Size in bytes of the private data a target driver associates with
  *	      each command.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ * @private: pointer to fabric session storage in fabric_sess_ptr
  */
 static struct se_session *
-transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
-			    enum target_prot_op sup_prot_ops)
+transport_init_session_tags(const struct target_core_fabric_ops *tfo,
+			    unsigned int tag_num, unsigned int tag_size,
+			    enum target_prot_op sup_prot_ops, void *private)
 {
 	struct se_session *se_sess;
 	int rc;
@@ -340,7 +359,7 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 		return ERR_PTR(-EINVAL);
 	}
 
-	se_sess = transport_alloc_session(sup_prot_ops);
+	se_sess = transport_alloc_session(tfo, sup_prot_ops, private);
 	if (IS_ERR(se_sess))
 		return se_sess;
 
@@ -359,15 +378,13 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 void __transport_register_session(
 	struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
-	struct se_session *se_sess,
-	void *fabric_sess_ptr)
+	struct se_session *se_sess)
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
 	unsigned char buf[PR_REG_ISID_LEN];
 	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
-	se_sess->fabric_sess_ptr = fabric_sess_ptr;
 	/*
 	 * Used by struct se_node_acl's under ConfigFS to locate active se_session-t
 	 *
@@ -415,20 +432,19 @@ void __transport_register_session(
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
 	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
-		se_tpg->se_tpg_tfo->fabric_name, se_sess->fabric_sess_ptr);
+		 se_sess->tfo->fabric_name, se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
 
 void transport_register_session(
 	struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
-	struct se_session *se_sess,
-	void *fabric_sess_ptr)
+	struct se_session *se_sess)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
-	__transport_register_session(se_tpg, se_nacl, se_sess, fabric_sess_ptr);
+	__transport_register_session(se_tpg, se_nacl, se_sess);
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 }
 EXPORT_SYMBOL(transport_register_session);
@@ -442,15 +458,18 @@ struct se_session *
 				     struct se_session *, void *))
 {
 	struct se_session *sess;
+	int rc;
 
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
 	 */
 	if (tag_num != 0)
-		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
+		sess = transport_init_session_tags(tpg->se_tpg_tfo, tag_num,
+						   tag_size, prot_op, private);
 	else
-		sess = transport_alloc_session(prot_op);
+		sess = transport_alloc_session(tpg->se_tpg_tfo, prot_op,
+					       private);
 
 	if (IS_ERR(sess))
 		return sess;
@@ -458,23 +477,30 @@ struct se_session *
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_session;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_session;
 	}
 
-	transport_register_session(tpg, sess->se_node_acl, sess, private);
+	transport_register_session(tpg, sess->se_node_acl, sess);
 	return sess;
+
+free_session:
+	/*
+	 * Don't call back into the driver's free_session. The setup callback
+	 * was not successfully run, so the fabric didn't perform its setup.
+	 */
+	sess->tfo = NULL;
+	transport_free_session(sess);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -557,6 +583,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session_configfs);
 
+void target_release_session(struct se_session *se_sess)
+{
+	if (se_sess->tfo && se_sess->tfo->free_session)
+		se_sess->tfo->free_session(se_sess);
+
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 void transport_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
@@ -567,7 +602,6 @@ void transport_free_session(struct se_session *se_sess)
 	 */
 	if (se_nacl) {
 		struct se_portal_group *se_tpg = se_nacl->se_tpg;
-		const struct target_core_fabric_ops *se_tfo = se_tpg->se_tpg_tfo;
 		unsigned long flags;
 
 		se_sess->se_node_acl = NULL;
@@ -579,7 +613,7 @@ void transport_free_session(struct se_session *se_sess)
 		 */
 		mutex_lock(&se_tpg->acl_node_mutex);
 		if (se_nacl->dynamic_node_acl &&
-		    !se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
+		    !se_sess->tfo->tpg_check_demo_mode_cache(se_tpg)) {
 			spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 			if (list_empty(&se_nacl->acl_sess_list))
 				se_nacl->dynamic_stop = true;
@@ -600,8 +634,7 @@ void transport_free_session(struct se_session *se_sess)
 		kvfree(se_sess->sess_cmd_map);
 	}
 	transport_uninit_session(se_sess);
-	ida_simple_remove(&se_sess_ida, se_sess->sid);
-	kmem_cache_free(se_sess_cache, se_sess);
+	config_group_put(&se_sess->group);
 }
 EXPORT_SYMBOL(transport_free_session);
 
@@ -627,7 +660,6 @@ void transport_deregister_session(struct se_session *se_sess)
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
 	se_sess->se_tpg = NULL;
-	se_sess->fabric_sess_ptr = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	/*
@@ -637,7 +669,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	target_for_each_device(target_release_res, se_sess);
 
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
-		se_tpg->se_tpg_tfo->fabric_name);
+		se_sess->tfo->fabric_name);
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index adea3bd..d6aca0c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -624,6 +624,8 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	int			sid;
+	struct config_group	group;
+	const struct target_core_fabric_ops *tfo;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6b05510..838c2f0 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -65,6 +65,14 @@ struct target_core_fabric_ops {
 	 */
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
+	/*
+	 * Optional callout to free internal fabric resources when all
+	 * references to the session have been dropped. For modules that call
+	 * transport_alloc_session this will be called if that function
+	 * is successfully run. For modules that call target_setup_session
+	 * the callout will be called if that function is successfully run.
+	 */
+	void (*free_session)(struct se_session *);
 	void (*close_session)(struct se_session *);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
@@ -132,13 +140,14 @@ struct se_session *target_setup_session(struct se_portal_group *,
 void target_remove_session(struct se_session *);
 
 int transport_init_session(struct se_session *se_sess);
-struct se_session *transport_alloc_session(enum target_prot_op);
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *,
+					   enum target_prot_op, void *);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
 void	__transport_register_session(struct se_portal_group *,
-		struct se_node_acl *, struct se_session *, void *);
+		struct se_node_acl *, struct se_session *);
 void	transport_register_session(struct se_portal_group *,
-		struct se_node_acl *, struct se_session *, void *);
+		struct se_node_acl *, struct se_session *);
 ssize_t	target_show_dynamic_sessions(struct se_portal_group *, char *);
 void	transport_free_session(struct se_session *);
 void	target_spc2_release(struct se_node_acl *nacl);
-- 
1.8.3.1

