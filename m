Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3450C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 15:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E772230C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 15:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJh2fsjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfKSPq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:46:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728532AbfKSPq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 10:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=P/G7kM8j4oYCC+cnhV5sL37M7tSFWLv6DMhMjlzyrJo=;
        b=FJh2fsjcraAs3XALfHccbpBnGjbzWlxSD0wrDJL+CGJXx8LudrxWHQLx+be330e8Ej+2yK
        9VnSeaPHZe/ftvf1Oc4xuoRqhEOsmvsKxcwFTd3IyXi3NL+7urOfgni5l3SvlkSk40KzWA
        EQjNSMFCjPpuD8vFJ85PdHafw+aMgpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-pPA5X5TqMgmxuvNuWZetHQ-1; Tue, 19 Nov 2019 10:46:54 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C0B08E5DC3;
        Tue, 19 Nov 2019 15:46:53 +0000 (UTC)
Received: from rhel7lobe.redhat.com (ovpn-117-16.phx2.redhat.com [10.3.117.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 927D860850;
        Tue, 19 Nov 2019 15:46:52 +0000 (UTC)
From:   Laurence Oberman <loberman@redhat.com>
To:     QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org,
        djeffery@redhat.com, jpittman@redhat.com, cdupuis1@gmail.com
Cc:     Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] bnx2fc: timeout calculation invalid for bnx2fc_eh_abort()
Date:   Tue, 19 Nov 2019 10:46:34 -0500
Message-Id: <1574178394-16635-1-git-send-email-loberman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: pPA5X5TqMgmxuvNuWZetHQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the bnx2fc_eh_abort() function there is a calculation for
wait_for_completion that uses a HZ multiplier.
This is incorrect, it scales the timeout by 1000 seconds
instead of converting the ms value to jiffies.
Therefore change the calculation.

Reported-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: John Pittman .jpittman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_i=
o.c
index 401743e..d8ae6d0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1242,7 +1242,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
=20
 =09/* Wait 2 * RA_TOV + 1 to be sure timeout function hasn't fired */
 =09time_left =3D wait_for_completion_timeout(&io_req->abts_done,
-=09=09=09=09=09=09(2 * rp->r_a_tov + 1) * HZ);
+=09=09=09=09=09msecs_to_jiffies(2 * rp->r_a_tov + 1));
 =09if (time_left)
 =09=09BNX2FC_IO_DBG(io_req,
 =09=09=09      "Timed out in eh_abort waiting for abts_done");
--=20
1.8.3.1

