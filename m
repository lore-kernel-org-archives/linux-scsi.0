Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48E5C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 16:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9396120718
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 16:37:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BRADmFut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKOQhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 11:37:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56509 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727507AbfKOQhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 11:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573835852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ta9OCG6VRWG56rAVVq0AG0wDlpj4I2cCFmoWAJxSJuQ=;
        b=BRADmFutkayKu4qg5A+isXpJxJI08Xl9kKbrSqF0RxjNPDgmOgAUUDHm6+wvBFfW9avhEq
        zIl1TjSdgbl5XWsYuAeS10/RwBgWOoYMw7aY/Mp7Xa3IBL/RtivZOdnTp5vJAEbkGyzJYV
        Atm0JofuuEaslsUDlzaNHmELZFu0fW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-eBHu5WFyN5u__lQYbR_hUw-1; Fri, 15 Nov 2019 11:37:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 260118035E3;
        Fri, 15 Nov 2019 16:37:30 +0000 (UTC)
Received: from manaslu.redhat.com (ovpn-204-242.brq.redhat.com [10.40.204.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B8E575E32;
        Fri, 15 Nov 2019 16:37:28 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi_debug: num_tgts must be >= 0
Date:   Fri, 15 Nov 2019 17:37:27 +0100
Message-Id: <20191115163727.24626-1-mlombard@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: eBHu5WFyN5u__lQYbR_hUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passing the parameter "num_tgts=3D-1" will start
an infinite loop that exhausts the system memory

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..32965ec76965 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5263,6 +5263,11 @@ static int __init scsi_debug_init(void)
 =09=09return -EINVAL;
 =09}
=20
+=09if (sdebug_num_tgts < 0) {
+=09=09pr_err("num_tgts must be >=3D 0\n");
+=09=09return -EINVAL;
+=09}
+
 =09if (sdebug_guard > 1) {
 =09=09pr_err("guard must be 0 or 1\n");
 =09=09return -EINVAL;
--=20
Maurizio Lombardi

