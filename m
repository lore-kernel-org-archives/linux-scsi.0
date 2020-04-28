Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE89BC8300A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25B9206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffUOQqnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgD1GL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27579 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgD1GL2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 02:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=smNHoQM1lqhjM14M7IPUV2FZjk9gDQuue/3cGiKr004=;
        b=ffUOQqnJZKbxNEzx7pRDmnJN5vOkL9kmEbprUok8XWRog7ZYmGA30FQtpwXFW1c4IkLCIY
        XmxqG/V5WQ7RZcT0mgxJhD5As1tLge7e1qSU6Xu1kBF+wY+9Cewy78V8xo2YyM2XdhJBg4
        fIEAPrPPJ6mhIDK2WCcl+BEzRGKLtWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-_-0t-wc-ONuMi4CyhQko3w-1; Tue, 28 Apr 2020 02:11:25 -0400
X-MC-Unique: _-0t-wc-ONuMi4CyhQko3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 788251899520;
        Tue, 28 Apr 2020 06:11:24 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76A0910013D9;
        Tue, 28 Apr 2020 06:11:23 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 09/11] target: add target_setup_session sysfs support
Date:   Tue, 28 Apr 2020 01:11:07 -0500
Message-Id: <20200428061109.3042-10-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a session dir per session for users of target_setup_session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
index 7f04b7bf..37aa6de 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -446,6 +446,7 @@ struct se_session *
=20
 	if (IS_ERR(sess))
 		return sess;
+	sess->tfo =3D tpg->se_tpg_tfo;
=20
 	sess->tpid =3D target_cp_transport_id(tpid);
 	if (!sess->tpid) {
@@ -459,6 +460,10 @@ struct se_session *
 		rc =3D -EACCES;
 		goto free_sess;
 	}
+
+	rc =3D target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto free_sess;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -466,12 +471,14 @@ struct se_session *
 	if (callback !=3D NULL) {
 		rc =3D callback(tpg, sess, private);
 		if (rc)
-			goto free_sess;
+			goto rm_sysfs;
 	}
=20
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
=20
+rm_sysfs:
+	target_sysfs_remove_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -662,6 +669,7 @@ void transport_deregister_session(struct se_session *=
se_sess)
=20
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
--=20
1.8.3.1

