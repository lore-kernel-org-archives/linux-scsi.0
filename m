Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEADC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BB6E2076C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 17:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/mie6n1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCMRHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 13:07:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726414AbgCMRHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 13:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584119230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCRu2uO7JRNFqZuuAU7FJwrFZSO6JRc5fYwy5NacvU4=;
        b=P/mie6n12uFF+ntDQAIhsTV81xKmxSeR58P1o+4htD5HZaNeCxy4MFWmDKwB2EOk5YaOue
        eyqdvPhK96ScataOefA3L+hwfcBRDTVcW9WIIkJdpBQaTCo79chLD3YeMrptLdvFexzpLY
        G2tiMGFE810aKv2FZRne5BwCnkK6C4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-LgOQQK2YNkek2L5utI8Ujg-1; Fri, 13 Mar 2020 13:07:09 -0400
X-MC-Unique: LgOQQK2YNkek2L5utI8Ujg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 174E78017CC;
        Fri, 13 Mar 2020 17:07:08 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-206-24.brq.redhat.com [10.40.206.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CB0873862;
        Fri, 13 Mar 2020 17:07:05 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de,
        mcoleman@datto.com, linux-scsi@vger.kernel.org
Subject: [PATCH RESEND 3/3] iscsi target: calling iscsit_stop_session() inside iscsit_close_session() has no effect
Date:   Fri, 13 Mar 2020 18:06:56 +0100
Message-Id: <20200313170656.9716-4-mlombard@redhat.com>
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com>
References: <20200313170656.9716-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit_close_session() can only be called when nconn is zero (otherwise
a kernel panic is triggered); if nconn is zero then
iscsit_stop_session() does nothing and exits, so calling it
makes no sense.

We still need to call iscsit_check_session_usage_count() because
this function will sleep if the session's refcount is not zero and
we don't want to destroy the session structure if
it's still being referenced.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
index 9e90edc875f1..14f4842e3517 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4385,8 +4385,7 @@ int iscsit_close_session(struct iscsi_session *sess=
)
 	 * restart the timer and exit.
 	 */
 	if (!in_interrupt()) {
-		if (iscsit_check_session_usage_count(sess) =3D=3D 1)
-			iscsit_stop_session(sess, 1, 1);
+		iscsit_check_session_usage_count(sess);
 	} else {
 		if (iscsit_check_session_usage_count(sess) =3D=3D 2) {
 			atomic_set(&sess->session_logout, 0);
--=20
2.21.0

