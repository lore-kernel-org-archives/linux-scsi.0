Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01571C433E3
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D219D20775
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zXVrPDUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgFGUgc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728106AbgFGUg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KXKjX018709;
        Sun, 7 Jun 2020 20:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vCC4FA2+H5sXb1cU9cRT4wLy1oWpbeb5TUyrw94qBSY=;
 b=zXVrPDUSlDJN7l4jw6rz4feMRd2Il/V5dpP6xwKfB3Fq0FieF+wjq0cw7jaeBCkHCuZJ
 o85tzDJRQEvTe5PSNoEX/EQDYgXvAFn8bfA5nEvqEkBEUQjzCxaUuXktygecAUxwrOgL
 +gRMn+A4A3r1vUoPmv2wGblUqc3NF5nStD9COWr58ml/E8nO8N2Uj9rWNX6rxNBzK+WQ
 tX9FVoyLmZspQ1MrPsYjnJoye0Z12MUsQoM4QswjdIDcPV92+C7OITw/g9fd5vPgQNBF
 l3UI8jjvLOsdyI9p41Kdwk9KvD2bWGS8Xs23tICWrq+3QJ85aMS7hYX8G0dSrhL83VUX RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31g33kv0qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSQ7o020409;
        Sun, 7 Jun 2020 20:36:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31gn205nh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 057KaIBH022832;
        Sun, 7 Jun 2020 20:36:18 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:17 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 17/17] target: drop sess_get_index
Date:   Sun,  7 Jun 2020 15:36:04 -0500
Message-Id: <1591562164-9766-18-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the LIO session id for the scsiAttIntrPortIndex. iSCSI was
already using this value and the other drivers used hard coded
values of 1 or 0. The SCSI-MIB specs says:

This object represents an arbitrary integer used to uniquely
identify a particular attached remote initiator port to a
particular SCSI target port within a particular SCSI target device
within a particular SCSI instance.

So the lio session sid can be used.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ---------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  7 -------
 drivers/target/iscsi/iscsi_target_configfs.c |  6 ------
 drivers/target/loopback/tcm_loop.c           |  6 ------
 drivers/target/sbp/sbp_target.c              |  6 ------
 drivers/target/target_core_configfs.c        |  4 ----
 drivers/target/target_core_stat.c            |  5 +----
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/target/tcm_fc/tfc_sess.c             |  7 -------
 drivers/usb/gadget/function/f_tcm.c          |  6 ------
 drivers/vhost/scsi.c                         |  6 ------
 drivers/xen/xen-scsiback.c                   |  6 ------
 include/target/target_core_fabric.h          |  1 -
 14 files changed, 1 insertion(+), 81 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3cda73c..7fe76e0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3353,20 +3353,6 @@ static void srpt_close_session(struct se_session *se_sess)
 	srpt_disconnect_ch_sync(ch);
 }
 
-/**
- * srpt_sess_get_index - return the value of scsiAttIntrPortIndex (SCSI-MIB)
- * @se_sess: SCSI target session.
- *
- * A quote from RFC 4455 (SCSI-MIB) about this MIB object:
- * This object represents an arbitrary integer used to uniquely identify a
- * particular attached remote initiator port to a particular SCSI target port
- * within a particular SCSI target device within a particular SCSI instance.
- */
-static u32 srpt_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -3843,7 +3829,6 @@ static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
 	.release_cmd			= srpt_release_cmd,
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
-	.sess_get_index			= srpt_sess_get_index,
 	.write_pending			= srpt_write_pending,
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 31459f3..8d37375 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3739,11 +3739,6 @@ static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
 	spin_unlock_bh(&vscsi->intr_lock);
 }
 
-static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
@@ -4034,7 +4029,6 @@ static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
 	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd			= ibmvscsis_release_cmd,
-	.sess_get_index			= ibmvscsis_sess_get_index,
 	.write_pending			= ibmvscsis_write_pending,
 	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
 	.get_cmd_state			= ibmvscsis_get_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index fff695a..8a68085 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -377,11 +377,6 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	tcm_qla2xxx_put_sess(sess);
 }
 
-static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -1851,7 +1846,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free		= tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
@@ -1890,7 +1884,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
-	.sess_get_index			= tcm_qla2xxx_sess_get_index,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 64de2ec..5bb3375 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1395,11 +1395,6 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 	return cmd->i_state;
 }
 
-static u32 lio_sess_get_index(struct se_session *se_sess)
-{
-	return se_sess->sid;
-}
-
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1592,7 +1587,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
 	.free_session			= lio_free_session,
-	.sess_get_index			= lio_sess_get_index,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
 	.get_cmd_state			= iscsi_get_cmd_state,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 64e5f1f..8daa424 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -512,11 +512,6 @@ static u32 tcm_loop_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static u32 tcm_loop_sess_get_index(struct se_session *se_sess)
-{
-	return 1;
-}
-
 static void tcm_loop_set_default_node_attributes(struct se_node_acl *se_acl)
 {
 	return;
@@ -1093,7 +1088,6 @@ static ssize_t tcm_loop_wwn_version_show(struct config_item *item, char *page)
 	.tpg_get_inst_index		= tcm_loop_get_inst_index,
 	.check_stop_free		= tcm_loop_check_stop_free,
 	.release_cmd			= tcm_loop_release_cmd,
-	.sess_get_index			= tcm_loop_sess_get_index,
 	.write_pending			= tcm_loop_write_pending,
 	.set_default_node_attributes	= tcm_loop_set_default_node_attributes,
 	.get_cmd_state			= tcm_loop_get_cmd_state,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 2cac4d9..782c326 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1708,11 +1708,6 @@ static void sbp_release_cmd(struct se_cmd *se_cmd)
 	sbp_free_request(req);
 }
 
-static u32 sbp_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int sbp_write_pending(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req = container_of(se_cmd,
@@ -2309,7 +2304,6 @@ static ssize_t sbp_tpg_attrib_max_logins_per_lun_store(struct config_item *item,
 	.tpg_check_prod_mode_write_protect = sbp_check_false,
 	.tpg_get_inst_index		= sbp_tpg_get_inst_index,
 	.release_cmd			= sbp_release_cmd,
-	.sess_get_index			= sbp_sess_get_index,
 	.write_pending			= sbp_write_pending,
 	.set_default_node_attributes	= sbp_set_default_node_attrs,
 	.get_cmd_state			= sbp_get_cmd_state,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c23552b..a2a4641 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -385,10 +385,6 @@ static int target_fabric_tf_ops_check(const struct target_core_fabric_ops *tfo)
 		pr_err("Missing tfo->release_cmd()\n");
 		return -EINVAL;
 	}
-	if (!tfo->sess_get_index) {
-		pr_err("Missing tfo->sess_get_index()\n");
-		return -EINVAL;
-	}
 	if (!tfo->write_pending) {
 		pr_err("Missing tfo->write_pending()\n");
 		return -EINVAL;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 3eb1b9b..621dc17 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1264,7 +1264,6 @@ static ssize_t target_stat_iport_indx_show(struct config_item *item,
 	struct se_lun_acl *lacl = iport_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
 
 	spin_lock_irq(&nacl->nacl_sess_lock);
@@ -1274,10 +1273,8 @@ static ssize_t target_stat_iport_indx_show(struct config_item *item,
 		return -ENODEV;
 	}
 
-	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->sess_get_index(se_sess));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 870b7bb..747824f 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -426,7 +426,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	.check_stop_free =		ft_check_stop_free,
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
-	.sess_get_index =		ft_sess_get_index,
 	.write_pending =		ft_write_pending,
 	.set_default_node_attributes =	ft_set_default_node_attr,
 	.get_cmd_state =		ft_get_cmd_state,
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 1d1c460..84a2c5d 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -326,13 +326,6 @@ void ft_sess_close(struct se_session *se_sess)
 	synchronize_rcu();		/* let transport deregister happen */
 }
 
-u32 ft_sess_get_index(struct se_session *se_sess)
-{
-	struct ft_sess *sess = se_sess->fabric_sess_ptr;
-
-	return sess->port_id;	/* XXX TBD probably not what is needed */
-}
-
 u32 ft_sess_get_port_name(struct se_session *se_sess,
 			  unsigned char *buf, u32 len)
 {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index e81bdbd..7bdd7c5 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1287,11 +1287,6 @@ static void usbg_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 usbg_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void usbg_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -1715,7 +1710,6 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.tpg_check_prod_mode_write_protect = usbg_check_false,
 	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
-	.sess_get_index			= usbg_sess_get_index,
 	.write_pending			= usbg_send_write_request,
 	.set_default_node_attributes	= usbg_set_default_node_attrs,
 	.get_cmd_state			= usbg_get_cmd_state,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d7c9bfc..14f7c3bf 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -340,11 +340,6 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
 
-static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -2244,7 +2239,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.tpg_get_inst_index		= vhost_scsi_tpg_get_inst_index,
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
-	.sess_get_index			= vhost_scsi_sess_get_index,
 	.write_pending			= vhost_scsi_write_pending,
 	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			= vhost_scsi_get_cmd_state,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 883b15c..923c96a 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1392,11 +1392,6 @@ static void scsiback_release_cmd(struct se_cmd *se_cmd)
 	target_free_tag(se_cmd->se_sess, se_cmd);
 }
 
-static u32 scsiback_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int scsiback_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -1768,7 +1763,6 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.tpg_get_inst_index		= scsiback_tpg_get_inst_index,
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
-	.sess_get_index			= scsiback_sess_get_index,
 	.write_pending			= scsiback_write_pending,
 	.set_default_node_attributes	= scsiback_set_default_node_attrs,
 	.get_cmd_state			= scsiback_get_cmd_state,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index af7d585..56be2ae 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -71,7 +71,6 @@ struct target_core_fabric_ops {
 	 */
 	void (*free_session)(struct se_session *);
 	void (*close_session)(struct se_session *);
-	u32 (*sess_get_index)(struct se_session *);
 	int (*write_pending)(struct se_cmd *);
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	int (*get_cmd_state)(struct se_cmd *);
-- 
1.8.3.1

