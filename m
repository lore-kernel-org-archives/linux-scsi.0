Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9808BC4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28DB62225B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/s2XzIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgKPJIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:08:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgKPJIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605517680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KTiUwVy+emA6v5nYKdFgzkrxs5yXDxztLIktrszjVo=;
        b=Q/s2XzIPMYSbBhWupxpeWANkfq+8l8qYmmDwP+SJlvRMvVrSLGx5MSxxdPc3pwyc/YVgeb
        2H+nl7Z/+p6+j4Th4Pp1J0xU1vNdQJeFALEXX9YHbTx3JVmDqwpvI6McW5cMdM+B8VnVVA
        50x2cuHS4SM965LIzgX3heUulCMTDV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-SFsBCQvIP5ilj7Yn2hddFw-1; Mon, 16 Nov 2020 04:07:55 -0500
X-MC-Unique: SFsBCQvIP5ilj7Yn2hddFw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3475F186DD2B;
        Mon, 16 Nov 2020 09:07:54 +0000 (UTC)
Received: from localhost (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A8F45D9CC;
        Mon, 16 Nov 2020 09:07:50 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V4 01/12] sbitmap: remove sbitmap_clear_bit_unlock
Date:   Mon, 16 Nov 2020 17:07:26 +0800
Message-Id: <20201116090737.50989-2-ming.lei@redhat.com>
In-Reply-To: <20201116090737.50989-1-ming.lei@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No one uses this helper any more, so kill it.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/sbitmap.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index e40d019c3d9d..51edc05489cb 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -320,12 +320,6 @@ static inline void sbitmap_deferred_clear_bit(struct sbitmap *sb, unsigned int b
 	set_bit(SB_NR_TO_BIT(sb, bitnr), addr);
 }
 
-static inline void sbitmap_clear_bit_unlock(struct sbitmap *sb,
-					    unsigned int bitnr)
-{
-	clear_bit_unlock(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
-}
-
 static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
 {
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
-- 
2.25.4

