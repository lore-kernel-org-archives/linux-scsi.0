Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F08C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14872076C
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/P3aezt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgFGUgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgFGUgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KYLHW137503;
        Sun, 7 Jun 2020 20:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=G+Png8uTl+OmiwQUfZgc/hn2TpO+61jKbR8PL8aMweU=;
 b=d/P3aeztRtU+nuHWytG4b71JrUEzP30wtbm8zEBoFLGELNZbOid371WMvHwmBd4qqy9W
 m244vtiHAzIrLxXG55nfYBimsq/3WKXOaglZnC9EeTD957WeultSyYbm8B74+y55FTYG
 tPcojO47lQzSETuAihSzi/JmBWzh3xs9L92Jt06+eDfHzr5TkZodKTJVQirHeoQiu8Ni
 Q0dU3EtxfTiI0Zem9t5fiQz5v8BaRj2AbP3LnGXoLJUhjg+m8kQcXvxJLzorAtWUKJJW
 E0DNR2lDAcsk0pw4DczW83cUmHi2/pJ8+X0qf/l+WLqQyOi+N987GNurA5EJ8QV3N9Nr Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smkxfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSFmk020050;
        Sun, 7 Jun 2020 20:36:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31gn205ncw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KaEs5024005;
        Sun, 7 Jun 2020 20:36:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:14 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 10/17] target: drop sess_get_initiator_sid
Date:   Sun,  7 Jun 2020 15:35:57 -0500
Message-Id: <1591562164-9766-11-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sess_get_initiator_sid is no longer used. Drop it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  2 --
 drivers/target/iscsi/iscsi_target_configfs.c | 13 -------------
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/usb/gadget/function/f_tcm.c          |  1 -
 drivers/vhost/scsi.c                         |  1 -
 drivers/xen/xen-scsiback.c                   |  1 -
 include/target/target_core_fabric.h          |  6 ------
 8 files changed, 26 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d107f63..3cda73c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3844,7 +3844,6 @@ static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
 	.check_stop_free		= srpt_check_stop_free,
 	.close_session			= srpt_close_session,
 	.sess_get_index			= srpt_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= srpt_write_pending,
 	.set_default_node_attributes	= srpt_set_default_node_attrs,
 	.get_cmd_state			= srpt_get_tcm_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7b21809..fff695a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1852,7 +1852,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
@@ -1892,7 +1891,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.close_session			= tcm_qla2xxx_close_session,
 	.sess_get_index			= tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	= tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			= tcm_qla2xxx_get_cmd_state,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0fa1d57..4513740 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1349,18 +1349,6 @@ static u32 lio_sess_get_index(struct se_session *se_sess)
 	return sess->session_index;
 }
 
-static u32 lio_sess_get_initiator_sid(
-	struct se_session *se_sess,
-	unsigned char *buf,
-	u32 size)
-{
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
-	/*
-	 * iSCSI Initiator Session Identifier from RFC-3720.
-	 */
-	return snprintf(buf, size, "%6phN", sess->isid);
-}
-
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
@@ -1545,7 +1533,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
 	.sess_get_index			= lio_sess_get_index,
-	.sess_get_initiator_sid		= lio_sess_get_initiator_sid,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
 	.get_cmd_state			= iscsi_get_cmd_state,
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 1a38c98..870b7bb 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -427,7 +427,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	.release_cmd =			ft_release_cmd,
 	.close_session =		ft_sess_close,
 	.sess_get_index =		ft_sess_get_index,
-	.sess_get_initiator_sid =	NULL,
 	.write_pending =		ft_write_pending,
 	.set_default_node_attributes =	ft_set_default_node_attr,
 	.get_cmd_state =		ft_get_cmd_state,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index cab3036..e81bdbd 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1716,7 +1716,6 @@ static int usbg_check_stop_free(struct se_cmd *se_cmd)
 	.tpg_get_inst_index		= usbg_tpg_get_inst_index,
 	.release_cmd			= usbg_release_cmd,
 	.sess_get_index			= usbg_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= usbg_send_write_request,
 	.set_default_node_attributes	= usbg_set_default_node_attrs,
 	.get_cmd_state			= usbg_get_cmd_state,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 37f66f8..d7c9bfc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2245,7 +2245,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
 	.release_cmd			= vhost_scsi_release_cmd,
 	.check_stop_free		= vhost_scsi_check_stop_free,
 	.sess_get_index			= vhost_scsi_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= vhost_scsi_write_pending,
 	.set_default_node_attributes	= vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			= vhost_scsi_get_cmd_state,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index f70b6da..883b15c 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1769,7 +1769,6 @@ static int scsiback_check_false(struct se_portal_group *se_tpg)
 	.check_stop_free		= scsiback_check_stop_free,
 	.release_cmd			= scsiback_release_cmd,
 	.sess_get_index			= scsiback_sess_get_index,
-	.sess_get_initiator_sid		= NULL,
 	.write_pending			= scsiback_write_pending,
 	.set_default_node_attributes	= scsiback_set_default_node_attrs,
 	.get_cmd_state			= scsiback_get_cmd_state,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 0113e1c..ced377f 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -67,12 +67,6 @@ struct target_core_fabric_ops {
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
 	u32 (*sess_get_index)(struct se_session *);
-	/*
-	 * Used only for SCSI fabrics that contain multi-value TransportIDs
-	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-	 */
-	u32 (*sess_get_initiator_sid)(struct se_session *,
-				      unsigned char *, u32);
 	int (*write_pending)(struct se_cmd *);
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	int (*get_cmd_state)(struct se_cmd *);
-- 
1.8.3.1

