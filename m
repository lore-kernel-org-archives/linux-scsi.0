Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1484C54E8F
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D6A2080C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jKHgrx3/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgEJV6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729496AbgEJV6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 17:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zB1rd/h3i3G/pLOyLugNRXNm9zWMXwOA7nmWGzzbG+c=;
        b=jKHgrx3/ENP3spXAl1DiJnLTp0Gx+MmNIX5+cZcw7erVtGgBMssl/PzCVgFUxfgSCCY7Tv
        6ej3w4Yhs3vYAFneP+gu6Xm9vi5wK0OiH4YsSLKCohx2o2Tc6rNl3Xpwjvo8ajC4W9A4+u
        +UqUSwN+Mo24T2iXKoFcVtRCEesMK18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-KBlfF6PJO6Oa-l7GdChqkw-1; Sun, 10 May 2020 17:58:09 -0400
X-MC-Unique: KBlfF6PJO6Oa-l7GdChqkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A8C1005510;
        Sun, 10 May 2020 21:58:08 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E1501002382;
        Sun, 10 May 2020 21:58:07 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 13/15] target: add target_setup_session sysfs support
Date:   Sun, 10 May 2020 16:57:42 -0500
Message-Id: <20200510215744.21999-14-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a session dir per session for users of target_setup_session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 04cb042..7bfeab2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -457,6 +457,7 @@ struct se_session *
 
 	if (IS_ERR(sess))
 		return sess;
+	sess->tfo = tpg->se_tpg_tfo;
 
 	sess->tpt_id = target_create_transport_id(tpg->proto_id, tpt_id_name,
 						  NULL);
@@ -471,6 +472,10 @@ struct se_session *
 		rc = -EACCES;
 		goto free_sess;
 	}
+
+	rc = target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto free_sess;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -478,12 +483,14 @@ struct se_session *
 	if (callback != NULL) {
 		rc = callback(tpg, sess, private);
 		if (rc)
-			goto free_sess;
+			goto rm_sysfs;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
 
+rm_sysfs:
+	target_sysfs_remove_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -674,6 +681,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1

