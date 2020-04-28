Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90A1C83007
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840E9206E2
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V2+VicKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgD1GL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54996 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbgD1GL0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 02:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KgNTP4LUIsIT5bup4rFmmedr4liejO4SovPtA8TrN5E=;
        b=V2+VicKdUYB1EI1pJMmIP8lW89xmDRcikp6G5Sejy4pCumCHVRXkuaHCCJslhKIa6FHXN1
        nRop5LPB6Wr1Rcxg2VzV50h9w+Pw7iUCNq+Rlb9KgGZX3j25V69geB/058FGbmrHz7byPN
        aLDlzpIgW/Csxc3RUx61e1KScw9khAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-jjSaVIyMNumO1L1YlU0Dcg-1; Tue, 28 Apr 2020 02:11:20 -0400
X-MC-Unique: jjSaVIyMNumO1L1YlU0Dcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E596100CCC0;
        Tue, 28 Apr 2020 06:11:19 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB8B10013D9;
        Tue, 28 Apr 2020 06:11:18 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 05/11] target: drop sess_get_initiator_sid from PR code
Date:   Tue, 28 Apr 2020 01:11:03 -0500
Message-Id: <20200428061109.3042-6-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the transport id session id in the PR related code.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_pr.c        | 23 ++++-------------------
 drivers/target/target_core_transport.c | 11 ++++-------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index cd2d32f..e80bd88 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1204,17 +1204,7 @@ static struct t10_pr_registration *core_scsi3_loca=
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
+	return __core_scsi3_locate_pr_reg(dev, nacl, sess->tpid->session_id);
 }
=20
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
@@ -1592,7 +1582,7 @@ static void core_scsi3_lunacl_undepend_item(struct =
se_dev_entry *se_deve)
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
 			 * for fabric modules (iSCSI) requiring them.
 			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+			if (se_sess->tpid->session_id &&
                             dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
 				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sen=
t in the SPEC_I_PT data for %s.",
@@ -2057,7 +2047,7 @@ static sense_reason_t core_scsi3_update_and_write_a=
ptpl(struct se_device *dev, b
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl =3D &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr =3D NULL;
+	unsigned char *isid_ptr =3D NULL;
 	sense_reason_t ret =3D TCM_NO_SENSE;
 	int pr_holder =3D 0, type;
=20
@@ -2067,12 +2057,7 @@ static sense_reason_t core_scsi3_update_and_write_=
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
+	isid_ptr =3D se_sess->tpid->session_id;
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 7715a723..369cd7e 100644
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
+		sid =3D se_sess->tpid->session_id;
+		if (sid)
+			se_sess->sess_bin_isid =3D get_unaligned_be64(sid);
=20
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
--=20
1.8.3.1

