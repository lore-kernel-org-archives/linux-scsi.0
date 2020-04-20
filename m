Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974F0C3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764D720B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grxmt94h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgDTTPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:15:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56577 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgDTTPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pCegcxJy4UklGssIXPodhf24cVnuyCjEP6awIGo3o4=;
        b=grxmt94hB3x74VD97VQBUNIRyzhzWNCcqsJn7ApBBWt7NYwryqxfsv72g+WgwaeA69vhoL
        qJEQskr5Yxj5IS+DVS0H2HYI1JkzvbpXL6LuaHg6IIrFMjZBde/t31UD9nD2X5Dj5285E2
        /Ev8pRoANT3n0t5KJMyeuIQbDxiA2XA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-2iTSdM-cPbKbg28AdOscKg-1; Mon, 20 Apr 2020 15:14:55 -0400
X-MC-Unique: 2iTSdM-cPbKbg28AdOscKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EB838024DF;
        Mon, 20 Apr 2020 19:14:53 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BD90A2934;
        Mon, 20 Apr 2020 19:14:51 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 05/12] target: drop sess_get_initiator_sid from PR code
Date:   Mon, 20 Apr 2020 14:14:19 -0500
Message-Id: <20200420191426.17055-6-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the transport id session id.

Note: this just converts __transport_register_session. It keeps the sid
copying bug. That fix is still being discussed, and it involves deep
interaction with the core PGR code, so it should be done in another
patchset.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_pr.c        | 24 +++++-------------------
 drivers/target/target_core_transport.c | 11 ++++-------
 2 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index cd2d32f..251caf9 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1204,17 +1204,8 @@ static struct t10_pr_registration *core_scsi3_loca=
te_pr_reg(
 	struct se_node_acl *nacl,
 	struct se_session *sess)
 {
-	struct se_portal_group *tpg =3D nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr =3D NULL;
-
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid !=3D NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
-		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
-					PR_REG_ISID_LEN);
-		isid_ptr =3D &buf[0];
-	}
-
-	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
+	return __core_scsi3_locate_pr_reg(dev, nacl,
+					  transport_id_get_sid(sess->tpid));
 }
=20
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
@@ -1592,7 +1583,7 @@ static void core_scsi3_lunacl_undepend_item(struct =
se_dev_entry *se_deve)
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
 			 * for fabric modules (iSCSI) requiring them.
 			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+			if (transport_id_get_sid(se_sess->tpid) &&
                             dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
 				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sen=
t in the SPEC_I_PT data for %s.",
@@ -2057,7 +2048,7 @@ static sense_reason_t core_scsi3_update_and_write_a=
ptpl(struct se_device *dev, b
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl =3D &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr =3D NULL;
+	unsigned char *isid_ptr =3D NULL;
 	sense_reason_t ret =3D TCM_NO_SENSE;
 	int pr_holder =3D 0, type;
=20
@@ -2067,12 +2058,7 @@ static sense_reason_t core_scsi3_update_and_write_=
aptpl(struct se_device *dev, b
 	}
 	se_tpg =3D se_sess->se_tpg;
=20
-	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
-		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
-		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
-				PR_REG_ISID_LEN);
-		isid_ptr =3D &isid_buf[0];
-	}
+	isid_ptr =3D transport_id_get_sid(se_sess->tpid);
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index adf4a84..66f0af1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -343,7 +343,7 @@ void __transport_register_session(
 	void *fabric_sess_ptr)
 {
 	const struct target_core_fabric_ops *tfo =3D se_tpg->se_tpg_tfo;
-	unsigned char buf[PR_REG_ISID_LEN];
+	unsigned char *sid;
 	unsigned long flags;
=20
 	se_sess->se_tpg =3D se_tpg;
@@ -374,12 +374,9 @@ void __transport_register_session(
 		 * If the fabric module supports an ISID based TransportID,
 		 * save this value in binary from the fabric I_T Nexus now.
 		 */
-		if (se_tpg->se_tpg_tfo->sess_get_initiator_sid !=3D NULL) {
-			memset(&buf[0], 0, PR_REG_ISID_LEN);
-			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
-					&buf[0], PR_REG_ISID_LEN);
-			se_sess->sess_bin_isid =3D get_unaligned_be64(&buf[0]);
-		}
+		sid =3D transport_id_get_sid(se_sess->tpid);
+		if (sid)
+			se_sess->sess_bin_isid =3D get_unaligned_be64(sid);
=20
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
--=20
1.8.3.1

