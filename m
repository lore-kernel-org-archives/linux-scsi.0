Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2BBC8300B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E72E206D7
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JIER9uUz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgD1GL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47603 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726453AbgD1GLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 02:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7CGUahcxXkgqnWckHyziBroYR9jevjwgpqBwe42zSo=;
        b=JIER9uUzaY8vVlGhfzbOJZvSgwdpL0Ij136U+OD2qvvUfPXim/wxpveIDOh6i7V+a08qE/
        KtZ72ZGRXTSLZvVvxD62uvBlnUWHV2qKzIgx2/CttgfUMGR0t11FzPTjPeuEaFaPA0mAtG
        vHEoxZ02BNbBisPeIxXxe34AGoaaRog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-K1AHXl62O9qa4a6Sf5WHtg-1; Tue, 28 Apr 2020 02:11:19 -0400
X-MC-Unique: K1AHXl62O9qa4a6Sf5WHtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56CC9107ACF6;
        Tue, 28 Apr 2020 06:11:18 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55BAB10013D9;
        Tue, 28 Apr 2020 06:11:17 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 04/11] target: use tpid in target_stat_iport_port_ident_show
Date:   Tue, 28 Apr 2020 01:11:02 -0500
Message-Id: <20200428061109.3042-5-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 drivers/target/target_core_stat.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_co=
re_stat.c
index 237309d..69ba7c3 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1308,9 +1308,7 @@ static ssize_t target_stat_iport_port_ident_show(st=
ruct config_item *item,
 	struct se_lun_acl *lacl =3D iport_to_lacl(item);
 	struct se_node_acl *nacl =3D lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
-	unsigned char buf[64];
=20
 	spin_lock_irq(&nacl->nacl_sess_lock);
 	se_sess =3D nacl->nacl_sess;
@@ -1319,13 +1317,9 @@ static ssize_t target_stat_iport_port_ident_show(s=
truct config_item *item,
 		return -ENODEV;
 	}
=20
-	tpg =3D nacl->se_tpg;
-	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
-	memset(buf, 0, 64);
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid !=3D NULL)
-		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
-
-	ret =3D snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf=
);
+	ret =3D snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
+		       se_sess->tpid->session_id ? se_sess->tpid->session_id :
+		       "");
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
--=20
1.8.3.1

