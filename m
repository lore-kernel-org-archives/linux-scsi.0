Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76093C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56213208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XWFf8ZMx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgDTTO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:14:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54985 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726234AbgDTTOz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 15:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SeWrKG1khqDe0X8wNf20z2lFuV+pfHDtim9I4D99zTQ=;
        b=XWFf8ZMxSqluhrUkMJe2AxwWEhWNMCfGRo4Y5uMiN7igDJXDhp9HytT0b0/k7b+5WWpIEr
        cyXciXWAkaZPTb8KmsjjML0OsJFvVI48yVovTA7MCTCL3X/qx2/5s25jgqqcY7p5oyLzPb
        uiU5jBu4lWE3egcJ9cIHHF+7mjsN8t0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-bbfpvRbiObyvCC6Nvv4j7Q-1; Mon, 20 Apr 2020 15:14:52 -0400
X-MC-Unique: bbfpvRbiObyvCC6Nvv4j7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E8231853890;
        Mon, 20 Apr 2020 19:14:51 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 337BFA18BF;
        Mon, 20 Apr 2020 19:14:48 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 04/12] target: use tpid in target_stat_iport_port_ident_show
Date:   Mon, 20 Apr 2020 14:14:18 -0500
Message-Id: <20200420191426.17055-5-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the tpid session id instead of sess_get_initiator_sid.

Note that for userspace compat this patch continues the behavior:

1. Still add the "+i+" even if there is no session_id.
2. Use the acl initiatorname instead of the transportID port/addr/name.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_fabric_lib.c |  7 +++++++
 drivers/target/target_core_internal.h   |  1 +
 drivers/target/target_core_stat.c       | 12 ++++++------
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/tar=
get_core_fabric_lib.c
index 39b0e5e..6a53e16 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -508,3 +508,10 @@ void target_free_transport_id(struct t10_transport_i=
d *tpid)
 	}
 	kfree(tpid);
 }
+
+char *transport_id_get_sid(struct t10_transport_id *tpid)
+{
+	if (tpid->proto =3D=3D SCSI_PROTOCOL_ISCSI)
+		return tpid->iscsi.session_id;
+	return NULL;
+}
diff --git a/drivers/target/target_core_internal.h b/drivers/target/targe=
t_core_internal.h
index 5e016aa..efc5449 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -105,6 +105,7 @@ int	target_get_pr_transport_id(struct se_node_acl *na=
cl,
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg=
,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 void target_free_transport_id(struct t10_transport_id *tpid);
+char *transport_id_get_sid(struct t10_transport_id *tpid);
=20
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_co=
re_stat.c
index 237309d..cc9c966 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1309,8 +1309,8 @@ static ssize_t target_stat_iport_port_ident_show(st=
ruct config_item *item,
 	struct se_node_acl *nacl =3D lacl->se_lun_nacl;
 	struct se_session *se_sess;
 	struct se_portal_group *tpg;
+	char *session_id =3D NULL;
 	ssize_t ret;
-	unsigned char buf[64];
=20
 	spin_lock_irq(&nacl->nacl_sess_lock);
 	se_sess =3D nacl->nacl_sess;
@@ -1319,13 +1319,13 @@ static ssize_t target_stat_iport_port_ident_show(=
struct config_item *item,
 		return -ENODEV;
 	}
=20
+	session_id =3D transport_id_get_sid(se_sess->tpid);
+	if (!session_id)
+		session_id =3D "";
 	tpg =3D nacl->se_tpg;
 	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
-	memset(buf, 0, 64);
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid !=3D NULL)
-		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
-
-	ret =3D snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf=
);
+	ret =3D snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
+		       session_id);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
--=20
1.8.3.1

