Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC805C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8520420857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HyK49OAf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgF0Ef2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgF0Ef1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4XVWm118765;
        Sat, 27 Jun 2020 04:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=UqVh+Qq45m1qyMQYABqYNg5keIO3mjWJqXi6V/qtmRI=;
 b=HyK49OAfQsQiClDk15t9l8k5s/TepXLFf87Azz7K7GjRSSDiIhdxDvQq+Kc+rNA1mWnf
 6Uws4Gof8alkX1PyIOZejJM4A0e4plZlpFfvoQuClBifb97JGAhUw0Waxgsi6MBt2vpz
 0is0zpd44r4p+72Oj11X4172CqAbMlhVMtZWwQ0YK7rBPPYbT+DoAyhbx7VlzgWQok42
 FIE4DCdo0YLka/QWbKEcceuJthGv7WoivvmVO2zHmPaYSmmjlu0iiYBTsgxJgHeOgUeO
 nj4brM4vnzqXsG9CqT+2gBGvX2X9n+OnIyEkQjaHcWjugjDhr+lxvpMeaLtYAWT3sRC9 dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31wwhr83sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y9M9121984;
        Sat, 27 Jun 2020 04:35:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31wv58v8as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R4ZGlw010413;
        Sat, 27 Jun 2020 04:35:16 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 09/10] target: add helper to close session synchronously
Date:   Fri, 26 Jun 2020 23:35:08 -0500
Message-Id: <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to be able to delete sessions from userspace like is done for
the ACL path or is done for other objects like tpg, lun, etc. This patch
adds a helper function that calls the fabric module close_session
callback and then waits for the removal to complete. It will be used
in the next patch so userspace can remove sessions before deleting
TPGs/ACLs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 90 ++++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |  2 +
 3 files changed, 93 insertions(+)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e92dcf2..0af3844 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -155,6 +155,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
 void	target_release_session(struct se_session *);
+int	target_close_session_sync(struct se_portal_group *, int);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8d11a8c..942b0c5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -650,6 +650,7 @@ static int target_release_res(struct se_device *dev, void *data)
 void transport_deregister_session(struct se_session *se_sess)
 {
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
+	struct completion *removal_comp;
 	unsigned long flags;
 
 	if (!se_tpg) {
@@ -660,6 +661,8 @@ void transport_deregister_session(struct se_session *se_sess)
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
 	se_sess->se_tpg = NULL;
+	removal_comp = se_sess->removal_comp;
+	se_sess->removal_comp = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	/*
@@ -680,11 +683,98 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 
 	transport_free_session(se_sess);
+
+	if (removal_comp)
+		complete(removal_comp);
 }
 EXPORT_SYMBOL(transport_deregister_session);
 
+/**
+ * target_close_session_sync - Request fabric remove session and wait removal
+ * @se_tpg: se_portal_group that is the parent of the sess to remove
+ * @sid: session id
+ */
+int target_close_session_sync(struct se_portal_group *se_tpg, int sid)
+{
+	DECLARE_COMPLETION_ONSTACK(removal_comp);
+	struct se_session *se_sess;
+	unsigned long flags;
+	int ret;
+
+retry:
+	spin_lock_irqsave(&se_tpg->session_lock, flags);
+	list_for_each_entry(se_sess, &se_tpg->tpg_sess_list, sess_list) {
+		if (se_sess->sid == sid) {
+			config_group_get(&se_sess->group);
+			goto found;
+		}
+	}
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+	return -ENODEV;
+
+found:
+	if (!se_sess->tfo->close_session) {
+		pr_err("Session %d does not support configfs session removal.",
+		       se_sess->sid);
+		return -EINVAL;
+	}
+
+	if (se_sess->sess_tearing_down || se_sess->sess_remove_running ||
+	    se_sess->removal_comp) {
+		spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+		config_group_put(&se_sess->group);
+		/*
+		 * Either the transport started a removal already or another
+		 * caller of this function did. Wait for it to be torn down,
+		 * so caller knows it's safe to proceed with operations like
+		 * parent removals when this returns.
+		 */
+		msleep(250);
+		goto retry;
+	}
+
+	se_sess->removal_comp = &removal_comp;
+	pr_debug("Closing session-%d\n", se_sess->sid);
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+
+	ret = se_sess->tfo->close_session(se_sess);
+	if (ret < 0) {
+		pr_debug("Close for session-%d failed %d\n", se_sess->sid, ret);
+		if (ret != -ENODEV) {
+			spin_lock_irqsave(&se_tpg->session_lock, flags);
+			se_sess->removal_comp = NULL;
+			spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+			goto put_sess;
+		}
+		/*
+		 * Raced with fabric specific nexus interface, but we set our
+		 * compeltion before they called target_remove_session, so we
+		 * can just wait below for them to call complete.
+		 */
+	}
+
+	wait_for_completion(&removal_comp);
+
+put_sess:
+	config_group_put(&se_sess->group);
+	return ret;
+}
+
 void target_remove_session(struct se_session *se_sess)
 {
+	struct se_portal_group *se_tpg = se_sess->se_tpg;
+	unsigned long flags;
+
+	pr_debug("Removing session-%d\n", se_sess->sid);
+
+	spin_lock_irqsave(&se_tpg->session_lock, flags);
+	if (se_sess->sess_remove_running) {
+		spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+		return;
+	}
+	se_sess->sess_remove_running = 1;
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d6aca0c..690fff2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -609,12 +609,14 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 
 struct se_session {
 	unsigned		sess_tearing_down:1;
+	unsigned		sess_remove_running:1;
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
+	struct completion	*removal_comp;
 	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
-- 
1.8.3.1

