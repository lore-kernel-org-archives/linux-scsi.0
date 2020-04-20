Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B28EC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12C87208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmA2kNEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgDTTPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53053 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgDTTPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmhYJWP6h0YZQcajADNhJU76fHQZNlraRMxwqVOZ8Ts=;
        b=AmA2kNEfSEhPPyEBw7V3YVHzDzZDw0ddocYxRtXQ6FUsmZeOBL0sIcGpLQyRVfc67/i8+v
        lyYd5fq+ltuDIz0I922WUtjk5so6jHGoU+Gqy9r4P8rO4G4NVbouM8kDQafPp3NCcrxeUP
        JP0A/yL2pYVJh/4BC54ixyOosC+VMDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-xoV6cuaVOJaq4BvYwWXDug-1; Mon, 20 Apr 2020 15:14:48 -0400
X-MC-Unique: xoV6cuaVOJaq4BvYwWXDug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D24F81005513;
        Mon, 20 Apr 2020 19:14:46 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCBD7A18BF;
        Mon, 20 Apr 2020 19:14:45 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 02/12] target: separate acl name from port ids
Date:   Mon, 20 Apr 2020 14:14:16 -0500
Message-Id: <20200420191426.17055-3-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To handle features like PGRs in userspace we need the entire iniaitor
port id. For iscsi that is defined as the initiator name plus the
session identifier. The session id is hidden from users, because
its internal to the drivers, so this patch separates the acl name
from the SCSI port ids.

This will then allow other drivers like SRP to use different values
like the port id or src address for the ACL, but then use the port
id for transport ID checks in target_core_fabric.c.

This will also be used to export the initiator info in the session's
sysfs dir in the last patches, so tools like tcmu-runner can rebuild
its session state used when handling PGR commands.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 13 +++--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  9 +++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  8 ++-
 drivers/target/loopback/tcm_loop.c       | 24 ++++++++-
 drivers/target/sbp/sbp_target.c          |  9 +++-
 drivers/target/target_core_fabric_lib.c  | 87 ++++++++++++++++++++++++++=
++++++
 drivers/target/target_core_internal.h    |  1 +
 drivers/target/target_core_transport.c   | 22 +++++---
 drivers/target/tcm_fc/tfc_sess.c         | 10 +++-
 drivers/usb/gadget/function/f_tcm.c      | 11 +++-
 drivers/vhost/scsi.c                     | 25 +++++++--
 drivers/xen/xen-scsiback.c               | 28 ++++++++--
 include/target/target_core_base.h        | 24 +++++++++
 include/target/target_core_fabric.h      |  3 +-
 14 files changed, 245 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
index 9855274..caeb32e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2144,6 +2144,7 @@ static int srpt_cm_req_recv(struct srpt_device *con=
st sdev,
 			    const char *src_addr)
 {
 	struct srpt_port *sport =3D &sdev->port[port_num - 1];
+	struct t10_transport_id tpid;
 	struct srpt_nexus *nexus;
 	struct srp_login_rsp *rsp =3D NULL;
 	struct srp_login_rej *rej =3D NULL;
@@ -2314,13 +2315,17 @@ static int srpt_cm_req_recv(struct srpt_device *c=
onst sdev,
 	tag_num =3D ch->rq_size;
 	tag_size =3D 1; /* ib_srpt does not use se_sess->sess_cmd_map */
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_SRP;
+	tpid.srp.port_id =3D i_port_id + 2;
+
 	mutex_lock(&sport->port_guid_id.mutex);
 	list_for_each_entry(stpg, &sport->port_guid_id.tpg_list, entry) {
 		if (!IS_ERR_OR_NULL(ch->sess))
 			break;
 		ch->sess =3D target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						ch->sess_name, ch, NULL);
+						&tpid, ch->sess_name, ch, NULL);
 	}
 	mutex_unlock(&sport->port_guid_id.mutex);
=20
@@ -2329,14 +2334,14 @@ static int srpt_cm_req_recv(struct srpt_device *c=
onst sdev,
 		if (!IS_ERR_OR_NULL(ch->sess))
 			break;
 		ch->sess =3D target_setup_session(&stpg->tpg, tag_num,
-					tag_size, TARGET_PROT_NORMAL, i_port_id,
-					ch, NULL);
+					tag_size, TARGET_PROT_NORMAL, &tpid,
+					i_port_id, ch, NULL);
 		if (!IS_ERR_OR_NULL(ch->sess))
 			break;
 		/* Retry without leading "0x" */
 		ch->sess =3D target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
-						i_port_id + 2, ch, NULL);
+						&tpid, i_port_id + 2, ch, NULL);
 	}
 	mutex_unlock(&sport->port_gid_id.mutex);
=20
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index d9e94e8..dba9ec0 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2208,6 +2208,7 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_tp=
ort *tport)
 {
 	char *name =3D tport->tport_name;
 	struct ibmvscsis_nexus *nexus;
+	struct t10_transport_id tpid;
 	struct scsi_info *vscsi =3D container_of(tport, struct scsi_info, tport=
);
 	int rc;
=20
@@ -2222,9 +2223,13 @@ static int ibmvscsis_make_nexus(struct ibmvscsis_t=
port *tport)
 		return -ENOMEM;
 	}
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_SRP;
+	tpid.srp.port_id =3D name;
+
 	nexus->se_sess =3D target_setup_session(&tport->se_tpg, 0, 0,
-					      TARGET_PROT_NORMAL, name, nexus,
-					      NULL);
+					      TARGET_PROT_NORMAL, &tpid, name,
+					      nexus, NULL);
 	if (IS_ERR(nexus->se_sess)) {
 		rc =3D PTR_ERR(nexus->se_sess);
 		goto transport_init_fail;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
index abe7f79..42a4025 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1428,6 +1428,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 {
 	struct qla_hw_data *ha =3D vha->hw;
 	struct tcm_qla2xxx_lport *lport;
+	struct t10_transport_id tpid;
 	struct tcm_qla2xxx_tpg *tpg;
 	struct se_session *se_sess;
 	unsigned char port_name[36];
@@ -1454,13 +1455,18 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 */
 	memset(&port_name, 0, 36);
 	snprintf(port_name, sizeof(port_name), "%8phC", fc_wwpn);
+
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_FCP;
+	tpid.fcp.port_name =3D port_name;
+
 	/*
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
 	se_sess =3D target_setup_session(&tpg->se_tpg, num_tags,
 				       sizeof(struct qla_tgt_cmd),
-				       TARGET_PROT_ALL, port_name,
+				       TARGET_PROT_ALL, &tpid, port_name,
 				       qlat_sess, tcm_qla2xxx_session_cb);
 	if (IS_ERR(se_sess))
 		return PTR_ERR(se_sess);
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback=
/tcm_loop.c
index 3305b47..7593a53 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -725,10 +725,11 @@ static int tcm_loop_alloc_sess_cb(struct se_portal_=
group *se_tpg,
=20
 static int tcm_loop_make_nexus(
 	struct tcm_loop_tpg *tl_tpg,
-	const char *name)
+	char *name)
 {
 	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
+	struct t10_transport_id tpid;
 	int ret;
=20
 	if (tl_tpg->tl_nexus) {
@@ -736,13 +737,32 @@ static int tcm_loop_make_nexus(
 		return -EEXIST;
 	}
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D tl_hba->tl_proto_id;
+
+	switch (tpid.proto) {
+	case SCSI_PROTOCOL_SAS:
+		tpid.sas.addr =3D name;
+		break;
+	case SCSI_PROTOCOL_FCP:
+		tpid.fcp.port_name =3D name;
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		/* we only support format=3D0 */
+		tpid.iscsi.name =3D name;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	tl_nexus =3D kzalloc(sizeof(*tl_nexus), GFP_KERNEL);
 	if (!tl_nexus)
 		return -ENOMEM;
=20
 	tl_nexus->se_sess =3D target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					name, tl_nexus, tcm_loop_alloc_sess_cb);
+					&tpid, name, tl_nexus,
+					tcm_loop_alloc_sess_cb);
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret =3D PTR_ERR(tl_nexus->se_sess);
 		kfree(tl_nexus);
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_tar=
get.c
index e4a9b9f..9a3121d 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -181,6 +181,7 @@ static struct sbp_session *sbp_session_create(
 		struct sbp_tpg *tpg,
 		u64 guid)
 {
+	struct t10_transport_id tpid;
 	struct sbp_session *sess;
 	int ret;
 	char guid_str[17];
@@ -196,10 +197,14 @@ static struct sbp_session *sbp_session_create(
 	INIT_DELAYED_WORK(&sess->maint_work, session_maintenance_work);
 	sess->guid =3D guid;
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_SBP;
+	tpid.sbp.name =3D guid_str;
+
 	sess->se_sess =3D target_setup_session(&tpg->se_tpg, 128,
 					     sizeof(struct sbp_target_request),
-					     TARGET_PROT_NORMAL, guid_str,
-					     sess, NULL);
+					     TARGET_PROT_NORMAL, &tpid,
+					     guid_str, sess, NULL);
 	if (IS_ERR(sess->se_sess)) {
 		pr_err("failed to init se_session\n");
 		ret =3D PTR_ERR(sess->se_sess);
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/tar=
get_core_fabric_lib.c
index 6b4b354..39b0e5e 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -421,3 +421,90 @@ const char *target_parse_pr_out_transport_id(struct =
se_portal_group *tpg,
 	*out_tid_len =3D 24;
 	return buf + offset;
 }
+
+struct t10_transport_id *target_cp_transport_id(struct t10_transport_id =
*src)
+{
+	struct t10_transport_id *dst;
+
+	dst =3D kzalloc(sizeof(*dst), GFP_KERNEL);
+	if (!dst)
+		return NULL;
+	dst->format =3D src->format;
+	dst->proto =3D src->proto;
+
+	switch (src->proto) {
+	case SCSI_PROTOCOL_FCP:
+		dst->fcp.port_name =3D kstrdup(src->fcp.port_name, GFP_KERNEL);
+		if (!dst->fcp.port_name)
+			goto free_tpid;
+		break;
+	case SCSI_PROTOCOL_SBP:
+		dst->sbp.name =3D kstrdup(src->sbp.name, GFP_KERNEL);
+		if (!dst->sbp.name)
+			goto free_tpid;
+		break;
+	case SCSI_PROTOCOL_SRP:
+		dst->srp.port_id =3D kstrdup(src->srp.port_id, GFP_KERNEL);
+		if (!dst->srp.port_id)
+			goto free_tpid;
+		break;
+	case SCSI_PROTOCOL_SAS:
+		dst->sas.addr =3D kstrdup(src->sas.addr, GFP_KERNEL);
+		if (!dst->sas.addr)
+			goto free_tpid;
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		dst->iscsi.name =3D kstrdup(src->iscsi.name, GFP_KERNEL);
+		if (!dst->iscsi.name)
+			goto free_tpid;
+
+		if (src->format) {
+			dst->iscsi.session_id =3D kstrdup(src->iscsi.session_id,
+							GFP_KERNEL);
+			if (!dst->iscsi.session_id) {
+				kfree(dst->iscsi.name);
+				goto free_tpid;
+			}
+		}
+		break;
+	default:
+		pr_err("Unknown proto_id: 0x%02x\n", src->proto);
+		return NULL;
+	}
+
+	return dst;
+
+free_tpid:
+	kfree(dst);
+	return NULL;
+}
+EXPORT_SYMBOL(target_cp_transport_id);
+
+void target_free_transport_id(struct t10_transport_id *tpid)
+{
+	if (!tpid)
+		return;
+
+	switch (tpid->proto) {
+	case SCSI_PROTOCOL_FCP:
+		kfree(tpid->fcp.port_name);
+		break;
+	case SCSI_PROTOCOL_SBP:
+		kfree(tpid->sbp.name);
+		break;
+	case SCSI_PROTOCOL_SRP:
+		kfree(tpid->srp.port_id);
+		break;
+	case SCSI_PROTOCOL_SAS:
+		kfree(tpid->sas.addr);
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		kfree(tpid->iscsi.name);
+		kfree(tpid->iscsi.session_id);
+		break;
+	default:
+		pr_err("Unknown proto_id: 0x%02x\n", tpid->proto);
+		return;
+	}
+	kfree(tpid);
+}
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index 8533444..5e016aa 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -104,6 +104,7 @@ int	target_get_pr_transport_id(struct se_node_acl *na=
cl,
 		unsigned char *buf);
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg=
,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
+void target_free_transport_id(struct t10_transport_id *tpid);
=20
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 0ae9e60..adf4a84 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -416,12 +416,13 @@ void transport_register_session(
 struct se_session *
 target_setup_session(struct se_portal_group *tpg,
 		     unsigned int tag_num, unsigned int tag_size,
-		     enum target_prot_op prot_op,
+		     enum target_prot_op prot_op, struct t10_transport_id *tpid,
 		     const char *initiatorname, void *private,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
 	struct se_session *sess;
+	int rc;
=20
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
@@ -435,6 +436,12 @@ struct se_session *
 	if (IS_ERR(sess))
 		return sess;
=20
+	sess->tpid =3D target_cp_transport_id(tpid);
+	if (!sess->tpid) {
+		rc =3D -ENOMEM;
+		goto free_sess;
+	}
+
 	sess->se_node_acl =3D core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
@@ -446,15 +453,17 @@ struct se_session *
 	 * required before transport_register_session().
 	 */
 	if (callback !=3D NULL) {
-		int rc =3D callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc =3D callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
=20
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
=20
@@ -579,6 +588,7 @@ void transport_free_session(struct se_session *se_ses=
s)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
+	target_free_transport_id(se_sess->tpid);
 	percpu_ref_exit(&se_sess->cmd_count);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc=
_sess.c
index 4fd6a1d..f261756 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -208,6 +208,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport=
 *tport, u32 port_id,
 				      struct fc_rport_priv *rdata)
 {
 	struct se_portal_group *se_tpg =3D &tport->tpg->se_tpg;
+	struct t10_transport_id tpid;
 	struct ft_sess *sess;
 	struct hlist_head *head;
 	unsigned char initiatorname[TRANSPORT_IQN_LEN];
@@ -227,10 +228,15 @@ static struct ft_sess *ft_sess_create(struct ft_tpo=
rt *tport, u32 port_id,
 	sess->tport =3D tport;
 	sess->port_id =3D port_id;
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_FCP;
+	tpid.fcp.port_name =3D &initiatorname[0];
+
 	sess->se_sess =3D target_setup_session(se_tpg, TCM_FC_DEFAULT_TAGS,
 					     sizeof(struct ft_cmd),
-					     TARGET_PROT_NORMAL, &initiatorname[0],
-					     sess, ft_sess_alloc_cb);
+					     TARGET_PROT_NORMAL, &tpid,
+					     &initiatorname[0], sess,
+					     ft_sess_alloc_cb);
 	if (IS_ERR(sess->se_sess)) {
 		int rc =3D PTR_ERR(sess->se_sess);
 		kfree(sess);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
index 3650493..e282eb9 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1564,6 +1564,7 @@ static int usbg_alloc_sess_cb(struct se_portal_grou=
p *se_tpg,
 static int tcm_usbg_make_nexus(struct usbg_tpg *tpg, char *name)
 {
 	struct tcm_usbg_nexus *tv_nexus;
+	struct t10_transport_id tpid;
 	int ret =3D 0;
=20
 	mutex_lock(&tpg->tpg_mutex);
@@ -1579,11 +1580,17 @@ static int tcm_usbg_make_nexus(struct usbg_tpg *t=
pg, char *name)
 		goto out_unlock;
 	}
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D tpg->se_tpg.proto_id;
+	/* SPC does not assign a proto id for USB-SCSI so we use SAS naming */
+	tpid.sas.addr =3D name;
+
 	tv_nexus->tvn_se_sess =3D target_setup_session(&tpg->se_tpg,
 						     USB_G_DEFAULT_SESSION_TAGS,
 						     sizeof(struct usbg_cmd),
-						     TARGET_PROT_NORMAL, name,
-						     tv_nexus, usbg_alloc_sess_cb);
+						     TARGET_PROT_NORMAL, &tpid,
+						     name, tv_nexus,
+						     usbg_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 #define MAKE_NEXUS_MSG "core_tpg_check_initiator_node_acl() failed for %=
s\n"
 		pr_debug(MAKE_NEXUS_MSG, name);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0b949a1..bc377ee 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1937,10 +1937,10 @@ static int vhost_scsi_nexus_cb(struct se_portal_g=
roup *se_tpg,
 	return -ENOMEM;
 }
=20
-static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
-				const char *name)
+static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg, char *name)
 {
 	struct vhost_scsi_nexus *tv_nexus;
+	struct t10_transport_id tpid;
=20
 	mutex_lock(&tpg->tv_tpg_mutex);
 	if (tpg->tpg_nexus) {
@@ -1949,6 +1949,25 @@ static int vhost_scsi_make_nexus(struct vhost_scsi=
_tpg *tpg,
 		return -EEXIST;
 	}
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D tpg->se_tpg.proto_id;
+
+	switch (tpid.proto) {
+	case SCSI_PROTOCOL_SAS:
+		tpid.sas.addr =3D name;
+		break;
+	case SCSI_PROTOCOL_FCP:
+		tpid.fcp.port_name =3D name;
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		/* we only support format=3D0 */
+		tpid.iscsi.name =3D name;
+		break;
+	default:
+		mutex_unlock(&tpg->tv_tpg_mutex);
+		return -EINVAL;
+	}
+
 	tv_nexus =3D kzalloc(sizeof(*tv_nexus), GFP_KERNEL);
 	if (!tv_nexus) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
@@ -1964,7 +1983,7 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_=
tpg *tpg,
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name, tv_nexus,
+					&tpid, (unsigned char *)name, tv_nexus,
 					vhost_scsi_nexus_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ba0942e..0855a77f 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1507,10 +1507,10 @@ static int scsiback_alloc_sess_cb(struct se_porta=
l_group *se_tpg,
 	return 0;
 }
=20
-static int scsiback_make_nexus(struct scsiback_tpg *tpg,
-				const char *name)
+static int scsiback_make_nexus(struct scsiback_tpg *tpg, char *name)
 {
 	struct scsiback_nexus *tv_nexus;
+	struct t10_transport_id tpid;
 	int ret =3D 0;
=20
 	mutex_lock(&tpg->tv_tpg_mutex);
@@ -1520,6 +1520,25 @@ static int scsiback_make_nexus(struct scsiback_tpg=
 *tpg,
 		goto out_unlock;
 	}
=20
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D tpg->se_tpg.proto_id;
+
+	switch (tpid.proto) {
+	case SCSI_PROTOCOL_SAS:
+		tpid.sas.addr =3D name;
+		break;
+	case SCSI_PROTOCOL_FCP:
+		tpid.fcp.port_name =3D name;
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		/* we only support format=3D0 */
+		tpid.iscsi.name =3D name;
+		break;
+	default:
+		ret =3D-EINVAL;
+		goto out_unlock;
+	}
+
 	tv_nexus =3D kzalloc(sizeof(struct scsiback_nexus), GFP_KERNEL);
 	if (!tv_nexus) {
 		ret =3D -ENOMEM;
@@ -1529,8 +1548,9 @@ static int scsiback_make_nexus(struct scsiback_tpg =
*tpg,
 	tv_nexus->tvn_se_sess =3D target_setup_session(&tpg->se_tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
-						     TARGET_PROT_NORMAL, name,
-						     tv_nexus, scsiback_alloc_sess_cb);
+						     TARGET_PROT_NORMAL, &tpid,
+						     name, tv_nexus,
+						     scsiback_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
 		ret =3D -ENOMEM;
diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h
index 1728e88..cd440ea 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -333,6 +333,29 @@ struct t10_wwn {
 	struct list_head t10_vpd_list;
 };
=20
+struct t10_transport_id {
+	union {
+		struct {
+			char *port_name;
+		} fcp;
+		struct {
+			char *addr;
+		} sas;
+		struct {
+			char *name;
+		} sbp;
+		struct {
+			char *port_id;
+		} srp;
+		struct {
+			char *name;
+			char *session_id;
+		} iscsi;
+	};
+	u8 format;
+	u8 proto;
+};
+
 struct t10_pr_registration {
 	/* Used for fabrics that contain WWN+ISID */
 #define PR_REG_ISID_LEN				16
@@ -605,6 +628,7 @@ static inline struct se_node_acl *fabric_stat_to_nacl=
(struct config_item *item)
 struct se_session {
 	unsigned		sess_tearing_down:1;
 	u64			sess_bin_isid;
+	struct t10_transport_id	*tpid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h
index 063f133..6b8a6bc 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -125,9 +125,10 @@ struct target_core_fabric_ops {
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
=20
+struct t10_transport_id *target_cp_transport_id(struct t10_transport_id =
*);
 struct se_session *target_setup_session(struct se_portal_group *,
 		unsigned int, unsigned int, enum target_prot_op prot_op,
-		const char *, void *,
+		struct t10_transport_id *, const char *, void *,
 		int (*callback)(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
--=20
1.8.3.1

