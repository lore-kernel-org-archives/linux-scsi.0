Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D3FC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA6320B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VmaCLueT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDTTOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:14:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727066AbgDTTOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 15:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iLXxz2GkwgpXjo8LiM32hIhIt8Q/KGQzg3U8OQGgl+s=;
        b=VmaCLueTkCkRYAjuBwEW+S6OzUX1mCRl2X2Teiv5rc7oo6Y1jwY+E022UddWvnc6morx3Z
        o5XlLmLboBtpZV2Wz05CEijBnIS8aObDmE1xNqlG/vlcz91o64LVG+nLTUIFcf45oTzEoW
        i/Yu4f6Y8mfU+n90FpGjdgdqydMuv6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-nIn8OT1lO3-dhM63HeFW9g-1; Mon, 20 Apr 2020 15:14:49 -0400
X-MC-Unique: nIn8OT1lO3-dhM63HeFW9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08A121853898;
        Mon, 20 Apr 2020 19:14:48 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F954A18BF;
        Mon, 20 Apr 2020 19:14:46 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 03/12] iscsi target: setup transport_id
Date:   Mon, 20 Apr 2020 14:14:17 -0500
Message-Id: <20200420191426.17055-4-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi target does its own session setup. This patch updates the
driver so it sets up the transport id.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 38 ++++++++++++++++++++++++++=
++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/is=
csi/iscsi_target_nego.c
index 685d771..dd9bfa7 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1032,6 +1032,26 @@ static void iscsi_initiatorname_tolower(
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
+	tpid.format =3D 1;
+	tpid.iscsi.name =3D iname;
+	tpid.iscsi.session_id =3D isid_buf;
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
@@ -1260,11 +1280,21 @@ int iscsi_target_locate_portal(
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

