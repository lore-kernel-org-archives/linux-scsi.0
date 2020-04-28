Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D776DC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A04206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LGEatN/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD1GL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726423AbgD1GLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 02:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwahiG6giDSOCHGuB2P5B+5dYlCl8FKEb6/pL2iIexg=;
        b=LGEatN/P3D/jz2fweGtZ/+eaXKrUIjsIWdKLwkp8iSPTOKbs9aar1swOch1R5olst38b+3
        p6OeNtziUDzlTazhGbZtfiFI1KYNToeDhm9GuLu2oQTv1qg2xQp/oPdTPky6yeTKCHb7TS
        06aLF6Z5gNdnMD/Hom64g1Wjw2hRwzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-oIbbm3TlNkS3Q1wN-r2oww-1; Tue, 28 Apr 2020 02:11:18 -0400
X-MC-Unique: oIbbm3TlNkS3Q1wN-r2oww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2050B835B52;
        Tue, 28 Apr 2020 06:11:17 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0375A10001B2;
        Tue, 28 Apr 2020 06:11:15 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 03/11] iscsi target: setup transport_id
Date:   Tue, 28 Apr 2020 01:11:01 -0500
Message-Id: <20200428061109.3042-4-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi target does its own session setup. This patch updates the
driver so it sets up the transport id.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++++=
++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/is=
csi/iscsi_target_nego.c
index 685d771..dce2fe2 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1032,6 +1032,25 @@ static void iscsi_initiatorname_tolower(
 	}
 }
=20
+static int iscsi_setup_i_tpid(struct iscsi_session *sess, char *iname)
+{
+	struct t10_transport_id tpid;
+	char isid_buf[13];
+
+	sprintf(isid_buf, "%6phN", sess->isid);
+
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto =3D SCSI_PROTOCOL_ISCSI;
+	tpid.name =3D iname;
+	tpid.session_id =3D isid_buf;
+
+	sess->se_sess->tpid =3D target_cp_transport_id(&tpid);
+	if (!sess->se_sess->tpid)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Processes the first Login Request..
  */
@@ -1260,11 +1279,21 @@ int iscsi_target_locate_portal(
 	tag_size =3D sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size=
;
=20
 	ret =3D transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
-	if (ret < 0) {
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				    ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		ret =3D -1;
+	if (ret < 0)
+		goto return_oom;
+
+	if (conn->tpg !=3D iscsit_global->discovery_tpg) {
+		if (iscsi_setup_i_tpid(sess, i_buf))
+			/* tags and nacl released when session is freed */
+			goto return_oom;
 	}
+
+	goto out;
+
+return_oom:
+	iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+			    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+	ret =3D -1;
 out:
 	kfree(tmpbuf);
 	return ret;
--=20
1.8.3.1

