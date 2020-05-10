Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8C3C38A2A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F77420801
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 21:58:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqPGAZLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgEJV6J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 17:58:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51981 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729478AbgEJV6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 17:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589147887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bUkG9t562FY69NCrVRDdoSAcdF75ZLnLXa6jrtMNPnM=;
        b=FqPGAZLhKFuvOu8ny+p2EanZfTFVOAFRkpbcswmmTlAy2ZGQBMWO554aCq2QCOt2/NQ2eG
        +RshQkRn000hYYNtvw37WmLSNrW9WSVf3/mrqL3FIDA69ZgGWpqUyKNixZ7caBQS/tXeqf
        d1h2JMBngR+2AB5yiZyxxnuYNlWebqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-rYCs7i0-M1Stx-raCuRX4g-1; Sun, 10 May 2020 17:58:03 -0400
X-MC-Unique: rYCs7i0-M1Stx-raCuRX4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E16DB107ACCA;
        Sun, 10 May 2020 21:58:01 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149851002382;
        Sun, 10 May 2020 21:58:00 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 07/15] iscsi target: setup transport_id
Date:   Sun, 10 May 2020 16:57:36 -0500
Message-Id: <20200510215744.21999-8-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi target does its own session setup. This patch updates the
driver so it sets up the transport id.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771..c44613a2 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1032,6 +1032,20 @@ static void iscsi_initiatorname_tolower(
 	}
 }
 
+static int iscsi_setup_i_tpt_id(struct iscsi_session *sess, char *iname)
+{
+	char isid_buf[13];
+
+	sprintf(isid_buf, "%6phN", sess->isid);
+
+	sess->se_sess->tpt_id = target_create_transport_id(SCSI_PROTOCOL_ISCSI,
+							   iname, isid_buf);
+	if (!sess->se_sess->tpt_id)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Processes the first Login Request..
  */
@@ -1260,11 +1274,21 @@ int iscsi_target_locate_portal(
 	tag_size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 
 	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
-	if (ret < 0) {
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				    ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		ret = -1;
+	if (ret < 0)
+		goto return_oom;
+
+	if (conn->tpg != iscsit_global->discovery_tpg) {
+		if (iscsi_setup_i_tpt_id(sess, i_buf))
+			/* tags and nacl released when session is freed */
+			goto return_oom;
 	}
+
+	goto out;
+
+return_oom:
+	iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+			    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+	ret = -1;
 out:
 	kfree(tmpbuf);
 	return ret;
-- 
1.8.3.1

