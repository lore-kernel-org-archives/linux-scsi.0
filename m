Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FAC3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF71920B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNBu6pC/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgDTTPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728038AbgDTTPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 15:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cG9OCx03dz8wCGqDYFKPNsbmy6yU8pSRLAIJUWLeSFY=;
        b=FNBu6pC//gXozOkXh7F4b7AjSgReSSoHqszl8/aHqv3+G462Q+xReDXkzkfYeQVVYpBOd3
        KHbwV7+IpAoTjMormMd/FCRX8GyQIe8HOaOSQc4i/T+lXeIHEN0EISQG4ZMWcUwWN4KlSA
        QP5PRVYFpkLog8bh8COJFjHdmuuauIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-5BfCnwRrP62ZMxjCEjdfUg-1; Mon, 20 Apr 2020 15:15:19 -0400
X-MC-Unique: 5BfCnwRrP62ZMxjCEjdfUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC19A192D78E;
        Mon, 20 Apr 2020 19:15:11 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75058A188B;
        Mon, 20 Apr 2020 19:15:09 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 12/12] target: drop sess_get_index
Date:   Mon, 20 Apr 2020 14:14:26 -0500
Message-Id: <20200420191426.17055-13-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LIO now handles session id allocation so drop the callout.

Signed-off-by: Mike Christie <mchristi@redhat.com>
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

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
index 59a6b9b..87330bb 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3356,20 +3356,6 @@ static void srpt_close_session(struct se_session *=
se_sess)
 	srpt_disconnect_ch_sync(ch);
 }
=20
-/**
- * srpt_sess_get_index - return the value of scsiAttIntrPortIndex (SCSI-=
MIB)
- * @se_sess: SCSI target session.
- *
- * A quote from RFC 4455 (SCSI-MIB) about this MIB object:
- * This object represents an arbitrary integer used to uniquely identify=
 a
- * particular attached remote initiator port to a particular SCSI target=
 port
- * within a particular SCSI target device within a particular SCSI insta=
nce.
- */
-static u32 srpt_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -3846,7 +3832,6 @@ static ssize_t srpt_wwn_version_show(struct config_=
item *item, char *buf)
 	.release_cmd			=3D srpt_release_cmd,
 	.check_stop_free		=3D srpt_check_stop_free,
 	.close_session			=3D srpt_close_session,
-	.sess_get_index			=3D srpt_sess_get_index,
 	.write_pending			=3D srpt_write_pending,
 	.set_default_node_attributes	=3D srpt_set_default_node_attrs,
 	.get_cmd_state			=3D srpt_get_tcm_cmd_state,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index 23ffcd8..42b3c83 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3744,11 +3744,6 @@ static void ibmvscsis_release_cmd(struct se_cmd *s=
e_cmd)
 	spin_unlock_bh(&vscsi->intr_lock);
 }
=20
-static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
 	struct ibmvscsis_cmd *cmd =3D container_of(se_cmd, struct ibmvscsis_cmd=
,
@@ -4039,7 +4034,6 @@ static ssize_t ibmvscsis_tpg_enable_store(struct co=
nfig_item *item,
 	.tpg_get_inst_index		=3D ibmvscsis_tpg_get_inst_index,
 	.check_stop_free		=3D ibmvscsis_check_stop_free,
 	.release_cmd			=3D ibmvscsis_release_cmd,
-	.sess_get_index			=3D ibmvscsis_sess_get_index,
 	.write_pending			=3D ibmvscsis_write_pending,
 	.set_default_node_attributes	=3D ibmvscsis_set_default_node_attrs,
 	.get_cmd_state			=3D ibmvscsis_get_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
index d864d13..a60dc89 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -354,11 +354,6 @@ static void tcm_qla2xxx_close_session(struct se_sess=
ion *se_sess)
 	tcm_qla2xxx_put_sess(sess);
 }
=20
-static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd =3D container_of(se_cmd,
@@ -1833,7 +1828,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct =
config_item *item,
 	.release_cmd			=3D tcm_qla2xxx_release_cmd,
 	.close_session			=3D tcm_qla2xxx_close_session,
 	.init_session			=3D tcm_qla2xxx_init_session,
-	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
 	.write_pending			=3D tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
@@ -1873,7 +1867,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct =
config_item *item,
 	.release_cmd			=3D tcm_qla2xxx_release_cmd,
 	.close_session			=3D tcm_qla2xxx_close_session,
 	.init_session			=3D tcm_qla2xxx_init_session,
-	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
 	.write_pending			=3D tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/targe=
t/iscsi/iscsi_target_configfs.c
index c40cff1..0b98245 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1342,11 +1342,6 @@ static int iscsi_get_cmd_state(struct se_cmd *se_c=
md)
 	return cmd->i_state;
 }
=20
-static u32 lio_sess_get_index(struct se_session *se_sess)
-{
-	return se_sess->sid;
-}
-
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_cmd=
);
@@ -1527,7 +1522,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.check_stop_free		=3D lio_check_stop_free,
 	.release_cmd			=3D lio_release_cmd,
 	.close_session			=3D lio_tpg_close_session,
-	.sess_get_index			=3D lio_sess_get_index,
 	.write_pending			=3D lio_write_pending,
 	.set_default_node_attributes	=3D lio_set_default_node_attributes,
 	.get_cmd_state			=3D iscsi_get_cmd_state,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback=
/tcm_loop.c
index 7025b7e..1d92c36 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -512,11 +512,6 @@ static u32 tcm_loop_get_inst_index(struct se_portal_=
group *se_tpg)
 	return 1;
 }
=20
-static u32 tcm_loop_sess_get_index(struct se_session *se_sess)
-{
-	return 1;
-}
-
 static void tcm_loop_set_default_node_attributes(struct se_node_acl *se_=
acl)
 {
 	return;
@@ -1156,7 +1151,6 @@ static ssize_t tcm_loop_wwn_version_show(struct con=
fig_item *item, char *page)
 	.tpg_get_inst_index		=3D tcm_loop_get_inst_index,
 	.check_stop_free		=3D tcm_loop_check_stop_free,
 	.release_cmd			=3D tcm_loop_release_cmd,
-	.sess_get_index			=3D tcm_loop_sess_get_index,
 	.write_pending			=3D tcm_loop_write_pending,
 	.set_default_node_attributes	=3D tcm_loop_set_default_node_attributes,
 	.get_cmd_state			=3D tcm_loop_get_cmd_state,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_tar=
get.c
index 20f8b3b..a3d868b 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1713,11 +1713,6 @@ static void sbp_release_cmd(struct se_cmd *se_cmd)
 	sbp_free_request(req);
 }
=20
-static u32 sbp_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int sbp_write_pending(struct se_cmd *se_cmd)
 {
 	struct sbp_target_request *req =3D container_of(se_cmd,
@@ -2314,7 +2309,6 @@ static ssize_t sbp_tpg_attrib_max_logins_per_lun_st=
ore(struct config_item *item,
 	.tpg_check_prod_mode_write_protect =3D sbp_check_false,
 	.tpg_get_inst_index		=3D sbp_tpg_get_inst_index,
 	.release_cmd			=3D sbp_release_cmd,
-	.sess_get_index			=3D sbp_sess_get_index,
 	.write_pending			=3D sbp_write_pending,
 	.set_default_node_attributes	=3D sbp_set_default_node_attrs,
 	.get_cmd_state			=3D sbp_get_cmd_state,
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
index 7e21b87..dcb981d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -399,10 +399,6 @@ static int target_fabric_tf_ops_check(const struct t=
arget_core_fabric_ops *tfo)
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
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_co=
re_stat.c
index cc9c966..562532f 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1264,7 +1264,6 @@ static ssize_t target_stat_iport_indx_show(struct c=
onfig_item *item,
 	struct se_lun_acl *lacl =3D iport_to_lacl(item);
 	struct se_node_acl *nacl =3D lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
=20
 	spin_lock_irq(&nacl->nacl_sess_lock);
@@ -1274,10 +1273,8 @@ static ssize_t target_stat_iport_indx_show(struct =
config_item *item,
 		return -ENODEV;
 	}
=20
-	tpg =3D nacl->se_tpg;
 	/* scsiAttIntrPortIndex */
-	ret =3D snprintf(page, PAGE_SIZE, "%u\n",
-			tpg->se_tpg_tfo->sess_get_index(se_sess));
+	ret =3D snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc=
_conf.c
index 7983554..a0e9970 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -427,7 +427,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_gro=
up *se_tpg)
 	.release_cmd =3D			ft_release_cmd,
 	.close_session =3D		ft_sess_close,
 	.init_session =3D			ft_sess_init,
-	.sess_get_index =3D		ft_sess_get_index,
 	.write_pending =3D		ft_write_pending,
 	.set_default_node_attributes =3D	ft_set_default_node_attr,
 	.get_cmd_state =3D		ft_get_cmd_state,
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc=
_sess.c
index 7357c38..4a55b6f 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -330,13 +330,6 @@ void ft_sess_close(struct se_session *se_sess)
 	synchronize_rcu();		/* let transport deregister happen */
 }
=20
-u32 ft_sess_get_index(struct se_session *se_sess)
-{
-	struct ft_sess *sess =3D se_sess->fabric_sess_ptr;
-
-	return sess->port_id;	/* XXX TBD probably not what is needed */
-}
-
 u32 ft_sess_get_port_name(struct se_session *se_sess,
 			  unsigned char *buf, u32 len)
 {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
index eab61c6..1724432 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1287,11 +1287,6 @@ static void usbg_release_cmd(struct se_cmd *se_cmd=
)
 	target_free_tag(se_sess, se_cmd);
 }
=20
-static u32 usbg_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static void usbg_set_default_node_attrs(struct se_node_acl *nacl)
 {
 }
@@ -1720,7 +1715,6 @@ static int usbg_check_stop_free(struct se_cmd *se_c=
md)
 	.tpg_check_prod_mode_write_protect =3D usbg_check_false,
 	.tpg_get_inst_index		=3D usbg_tpg_get_inst_index,
 	.release_cmd			=3D usbg_release_cmd,
-	.sess_get_index			=3D usbg_sess_get_index,
 	.write_pending			=3D usbg_send_write_request,
 	.set_default_node_attributes	=3D usbg_set_default_node_attrs,
 	.get_cmd_state			=3D usbg_get_cmd_state,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 51392ab..40fb1c7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -340,11 +340,6 @@ static void vhost_scsi_release_cmd(struct se_cmd *se=
_cmd)
 	target_free_tag(se_sess, se_cmd);
 }
=20
-static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int vhost_scsi_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -2308,7 +2303,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *ww=
n)
 	.tpg_get_inst_index		=3D vhost_scsi_tpg_get_inst_index,
 	.release_cmd			=3D vhost_scsi_release_cmd,
 	.check_stop_free		=3D vhost_scsi_check_stop_free,
-	.sess_get_index			=3D vhost_scsi_sess_get_index,
 	.write_pending			=3D vhost_scsi_write_pending,
 	.set_default_node_attributes	=3D vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			=3D vhost_scsi_get_cmd_state,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 1d8c0c2..f183ec3 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1391,11 +1391,6 @@ static void scsiback_release_cmd(struct se_cmd *se=
_cmd)
 	target_free_tag(se_cmd->se_sess, se_cmd);
 }
=20
-static u32 scsiback_sess_get_index(struct se_session *se_sess)
-{
-	return 0;
-}
-
 static int scsiback_write_pending(struct se_cmd *se_cmd)
 {
 	/* Go ahead and process the write immediately */
@@ -1829,7 +1824,6 @@ static int scsiback_check_false(struct se_portal_gr=
oup *se_tpg)
 	.tpg_get_inst_index		=3D scsiback_tpg_get_inst_index,
 	.check_stop_free		=3D scsiback_check_stop_free,
 	.release_cmd			=3D scsiback_release_cmd,
-	.sess_get_index			=3D scsiback_sess_get_index,
 	.write_pending			=3D scsiback_write_pending,
 	.set_default_node_attributes	=3D scsiback_set_default_node_attrs,
 	.get_cmd_state			=3D scsiback_get_cmd_state,
diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h
index 509edcf..335ef7d0 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -66,7 +66,6 @@ struct target_core_fabric_ops {
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
-	u32 (*sess_get_index)(struct se_session *);
 	int (*write_pending)(struct se_cmd *);
 	void (*set_default_node_attributes)(struct se_node_acl *);
 	int (*get_cmd_state)(struct se_cmd *);
--=20
1.8.3.1

