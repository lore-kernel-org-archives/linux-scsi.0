Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91375C3F2CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 639A2246A8
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dwx80B2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB1X3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:29:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726674AbgB1X3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 18:29:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=utWzRwD1J+TLeCfKl8qxMp4PjbRU/QJ4O369KCrzxC0=;
        b=dwx80B2Dsn1dVm8oN4mxWll8tWF0v8yJ+qLpdNlSdkQgmpJHsw7hYHUNKuuQdvueiDix4/
        Ez8gAeQzw3jGJWcqpwEAGlbH2w+39NtZV4PzzvZEvKuJlBbn8tkwV+Fm+5AQ4RZIQ8mvxY
        I9562MenFAibdghhYmU9B8hNQFZhHD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-g4ypaRY2NqK1WOuvncHscA-1; Fri, 28 Feb 2020 18:29:49 -0500
X-MC-Unique: g4ypaRY2NqK1WOuvncHscA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7FD813E4;
        Fri, 28 Feb 2020 23:29:47 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 799AE8C096;
        Fri, 28 Feb 2020 23:29:44 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH V2 03/10] sbitmap: remove sbitmap_clear_bit_unlock
Date:   Sat, 29 Feb 2020 07:29:13 +0800
Message-Id: <20200228232920.20960-4-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No one uses this helper any more, so kill it.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/sbitmap.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 559c37e27d30..68097b052ec3 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -320,12 +320,6 @@ static inline void sbitmap_deferred_clear_bit(struct=
 sbitmap *sb, unsigned int b
 	set_bit(SB_NR_TO_BIT(sb, bitnr), addr);
 }
=20
-static inline void sbitmap_clear_bit_unlock(struct sbitmap *sb,
-					    unsigned int bitnr)
-{
-	clear_bit_unlock(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
-}
-
 static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitn=
r)
 {
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
--=20
2.20.1

