Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0B7C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CEE20857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUG2YDlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgF0Ef0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgF0EfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4WxI3078438;
        Sat, 27 Jun 2020 04:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=a5+qWx19xiffHAyz0XEGWFulanRlwMIBkYQcqbAE5PA=;
 b=qUG2YDlOqICAKJqGQUzwWfFuRwBf9VKKLeYVOoFEh/7JrWbIWYx7d+WUSwWpReo+8WG1
 XsiZcIm1vGsfi0GZhYankSEIRQim9V3gdatTA2g6bzWK/shsFBCKM9ri+wulSVfEavno
 3nbwxws6k9dAy2j70bXr+eIO7NvQWCxchf/4obfCnv/Dms8GIcobOQ533dktlTnzEwPt
 bCvEldY/2/j+20XeQsuzBrGchgcsrFxPYiS4ofG0Rz4kMGwPAgCKugfOSK0ajPGiOjSr
 TmoZSG7PRIT1afo2UgEo4APd8a0xCHuqUcNPiy92Yxu/mt1LWguSTQdBi2TONOud5czT yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrmr0y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4YMUk050661;
        Sat, 27 Jun 2020 04:35:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31wwwyvnpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R4ZF1O010409;
        Sat, 27 Jun 2020 04:35:15 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 07/10] target: add return value to close_session
Date:   Fri, 26 Jun 2020 23:35:06 -0500
Message-Id: <1593232509-13720-8-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=2 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a return value to close_session. In this patch only fcoe
returns non-zero and we don't do anything. In the next patches we will
be able to remove the session via configfs through the common fabric
configfs interface and the fabric specific nexus one, so we will need
to handle the case where the interfaces both try to delete the session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 3 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 3 ++-
 drivers/target/iscsi/iscsi_target_configfs.c | 5 +++--
 drivers/target/tcm_fc/tcm_fc.h               | 2 +-
 drivers/target/tcm_fc/tfc_sess.c             | 5 +++--
 include/target/target_core_fabric.h          | 2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index de564d1..f9a5bd8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3337,11 +3337,12 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
  * with a node ACL when the user invokes
  * rmdir /sys/kernel/config/target/$driver/$port/$tpg/acls/$i_port_id
  */
-static void srpt_close_session(struct se_session *se_sess)
+static int srpt_close_session(struct se_session *se_sess)
 {
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
 
 	srpt_disconnect_ch_sync(ch);
+	return 0;
 }
 
 static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index fa861ba..94a26ba 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -360,7 +360,7 @@ static void tcm_qla2xxx_put_sess(struct fc_port *sess)
 	kref_put(&sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
-static void tcm_qla2xxx_close_session(struct se_session *se_sess)
+static int tcm_qla2xxx_close_session(struct se_session *se_sess)
 {
 	struct fc_port *sess = se_sess->fabric_sess_ptr;
 	struct scsi_qla_host *vha;
@@ -375,6 +375,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 
 	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
+	return 0;
 }
 
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 3e843b0..aa7c4a6 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1460,7 +1460,7 @@ static int lio_tpg_check_prot_fabric_only(
  * This function calls iscsit_inc_session_usage_count() on the
  * struct iscsi_session in question.
  */
-static void lio_tpg_close_session(struct se_session *se_sess)
+static int lio_tpg_close_session(struct se_session *se_sess)
 {
 	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
 	struct se_portal_group *se_tpg = &sess->tpg->tpg_se_tpg;
@@ -1473,7 +1473,7 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 		spin_unlock(&sess->conn_lock);
 		spin_unlock_bh(&se_tpg->session_lock);
-		return;
+		return 0;
 	}
 	iscsit_inc_session_usage_count(sess);
 	atomic_set(&sess->session_reinstatement, 1);
@@ -1486,6 +1486,7 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
+	return 0;
 }
 
 static void lio_free_session(struct se_session *se_sess)
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 2ff716d..4280171 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -130,7 +130,7 @@ struct ft_cmd {
  * Session ops.
  */
 void ft_sess_put(struct ft_sess *);
-void ft_sess_close(struct se_session *);
+int ft_sess_close(struct se_session *);
 u32 ft_sess_get_index(struct se_session *);
 u32 ft_sess_get_port_name(struct se_session *, unsigned char *, u32);
 
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 6df570a..12c54e6 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -306,7 +306,7 @@ static void ft_sess_delete_all(struct ft_tport *tport)
  * Remove session and send PRLO.
  * This is called when the ACL is being deleted or queue depth is changing.
  */
-void ft_sess_close(struct se_session *se_sess)
+int ft_sess_close(struct se_session *se_sess)
 {
 	struct ft_sess *sess = se_sess->fabric_sess_ptr;
 	u32 port_id;
@@ -315,7 +315,7 @@ void ft_sess_close(struct se_session *se_sess)
 	port_id = sess->port_id;
 	if (port_id == -1) {
 		mutex_unlock(&ft_lport_lock);
-		return;
+		return -ENODEV;
 	}
 	TFC_SESS_DBG(sess->tport->lport, "port_id %x close session\n", port_id);
 	ft_sess_unhash(sess);
@@ -323,6 +323,7 @@ void ft_sess_close(struct se_session *se_sess)
 	ft_close_sess(sess);
 	/* XXX Send LOGO or PRLO */
 	synchronize_rcu();		/* let transport deregister happen */
+	return 0;
 }
 
 u32 ft_sess_get_port_name(struct se_session *se_sess,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 838c2f0..e200faa 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -73,7 +73,7 @@ struct target_core_fabric_ops {
 	 * the callout will be called if that function is successfully run.
 	 */
 	void (*free_session)(struct se_session *);
-	void (*close_session)(struct se_session *);
+	int (*close_session)(struct se_session *);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
 	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-- 
1.8.3.1

