Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7982C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30722074F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ya2FiIin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgDTTPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:03 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgDTTPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhDuad91FI3AHEIYNkb5E1G/sTM5LvRBMG6Q95RLRIw=;
        b=Ya2FiIin4VkU2InCpBnT41Bo6j1zIupmNvLihhPr0im52gOkHmnamqpiIfntH5i6/8lnZa
        iSt0Z3fe6/qsyo6KgAPEEWEQiwpkZnd69agbvPVDR6BB2e47TQZNiplVhgml1Zva09TRGZ
        ObSDt7SyTzQ/6PPRHFw4m4ewITDauGY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-NBsrwKmlNzWAGT-PudKK7g-1; Mon, 20 Apr 2020 15:14:56 -0400
X-MC-Unique: NBsrwKmlNzWAGT-PudKK7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1B59107ACC4;
        Mon, 20 Apr 2020 19:14:54 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD072A1898;
        Mon, 20 Apr 2020 19:14:53 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 06/12] target: drop sess_get_initiator_sid
Date:   Mon, 20 Apr 2020 14:14:20 -0500
Message-Id: <20200420191426.17055-7-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sess_get_initiator_sid is no longer used. Drop it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
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

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
index caeb32e..4dd2a41 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3847,7 +3847,6 @@ static ssize_t srpt_wwn_version_show(struct config_=
item *item, char *buf)
 	.check_stop_free		=3D srpt_check_stop_free,
 	.close_session			=3D srpt_close_session,
 	.sess_get_index			=3D srpt_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D srpt_write_pending,
 	.set_default_node_attributes	=3D srpt_set_default_node_attrs,
 	.get_cmd_state			=3D srpt_get_tcm_cmd_state,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
index 42a4025..dc1bddd 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1833,7 +1833,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct =
config_item *item,
 	.release_cmd			=3D tcm_qla2xxx_release_cmd,
 	.close_session			=3D tcm_qla2xxx_close_session,
 	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
@@ -1873,7 +1872,6 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct =
config_item *item,
 	.release_cmd			=3D tcm_qla2xxx_release_cmd,
 	.close_session			=3D tcm_qla2xxx_close_session,
 	.sess_get_index			=3D tcm_qla2xxx_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D tcm_qla2xxx_write_pending,
 	.set_default_node_attributes	=3D tcm_qla2xxx_set_default_node_attrs,
 	.get_cmd_state			=3D tcm_qla2xxx_get_cmd_state,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/targe=
t/iscsi/iscsi_target_configfs.c
index 42b369f..f640e7a 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1349,18 +1349,6 @@ static u32 lio_sess_get_index(struct se_session *s=
e_sess)
 	return sess->session_index;
 }
=20
-static u32 lio_sess_get_initiator_sid(
-	struct se_session *se_sess,
-	unsigned char *buf,
-	u32 size)
-{
-	struct iscsi_session *sess =3D se_sess->fabric_sess_ptr;
-	/*
-	 * iSCSI Initiator Session Identifier from RFC-3720.
-	 */
-	return snprintf(buf, size, "%6phN", sess->isid);
-}
-
 static int lio_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct iscsi_cmd *cmd =3D container_of(se_cmd, struct iscsi_cmd, se_cmd=
);
@@ -1542,7 +1530,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.release_cmd			=3D lio_release_cmd,
 	.close_session			=3D lio_tpg_close_session,
 	.sess_get_index			=3D lio_sess_get_index,
-	.sess_get_initiator_sid		=3D lio_sess_get_initiator_sid,
 	.write_pending			=3D lio_write_pending,
 	.set_default_node_attributes	=3D lio_set_default_node_attributes,
 	.get_cmd_state			=3D iscsi_get_cmd_state,
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc=
_conf.c
index 1a38c98..870b7bb 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -427,7 +427,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_gro=
up *se_tpg)
 	.release_cmd =3D			ft_release_cmd,
 	.close_session =3D		ft_sess_close,
 	.sess_get_index =3D		ft_sess_get_index,
-	.sess_get_initiator_sid =3D	NULL,
 	.write_pending =3D		ft_write_pending,
 	.set_default_node_attributes =3D	ft_set_default_node_attr,
 	.get_cmd_state =3D		ft_get_cmd_state,
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
index e282eb9..88319b9 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1722,7 +1722,6 @@ static int usbg_check_stop_free(struct se_cmd *se_c=
md)
 	.tpg_get_inst_index		=3D usbg_tpg_get_inst_index,
 	.release_cmd			=3D usbg_release_cmd,
 	.sess_get_index			=3D usbg_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D usbg_send_write_request,
 	.set_default_node_attributes	=3D usbg_set_default_node_attrs,
 	.get_cmd_state			=3D usbg_get_cmd_state,
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index bc377ee..7ad7a92 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2310,7 +2310,6 @@ static void vhost_scsi_drop_tport(struct se_wwn *ww=
n)
 	.release_cmd			=3D vhost_scsi_release_cmd,
 	.check_stop_free		=3D vhost_scsi_check_stop_free,
 	.sess_get_index			=3D vhost_scsi_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D vhost_scsi_write_pending,
 	.set_default_node_attributes	=3D vhost_scsi_set_default_node_attrs,
 	.get_cmd_state			=3D vhost_scsi_get_cmd_state,
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 0855a77f..6f9b4f7 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1831,7 +1831,6 @@ static int scsiback_check_false(struct se_portal_gr=
oup *se_tpg)
 	.check_stop_free		=3D scsiback_check_stop_free,
 	.release_cmd			=3D scsiback_release_cmd,
 	.sess_get_index			=3D scsiback_sess_get_index,
-	.sess_get_initiator_sid		=3D NULL,
 	.write_pending			=3D scsiback_write_pending,
 	.set_default_node_attributes	=3D scsiback_set_default_node_attrs,
 	.get_cmd_state			=3D scsiback_get_cmd_state,
diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h
index 6b8a6bc..0c1720d 100644
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
--=20
1.8.3.1

