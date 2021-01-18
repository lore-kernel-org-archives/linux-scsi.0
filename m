Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E454AC43381
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD9C522516
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbhARAvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jan 2021 19:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729570AbhARAvI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Jan 2021 19:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610930981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X8ra4neYE8z0u7txJCMfbP+VRmzix1iAdp1uN9nzhVw=;
        b=P+Bps6TwhjAH71n8sqKFdPEurkSmHXJ58owumVYS9N7t9pxwJ4o9VSf24aY1AkBzz6OLxg
        Ke7FI0bwds73DbLYn0LPi3xvMFYBKy8CPpQJTMhbClowbvGK04HmC4zfA9lfaH95yHynB4
        8yGLvDulQgQ7yT7jhtR2OmQvBh/nPzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-RZVRnkCYN9WViFvXr7Qrvw-1; Sun, 17 Jan 2021 19:49:39 -0500
X-MC-Unique: RZVRnkCYN9WViFvXr7Qrvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1D8C800D53;
        Mon, 18 Jan 2021 00:49:37 +0000 (UTC)
Received: from localhost (ovpn-12-73.pek2.redhat.com [10.72.12.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2583E5D720;
        Mon, 18 Jan 2021 00:49:32 +0000 (UTC)
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
Subject: [PATCH V6 01/13] sbitmap: remove sbitmap_clear_bit_unlock
Date:   Mon, 18 Jan 2021 08:49:09 +0800
Message-Id: <20210118004921.202545-2-ming.lei@redhat.com>
In-Reply-To: <20210118004921.202545-1-ming.lei@redhat.com>
References: <20210118004921.202545-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 74cc6384715e..16353fbee765 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -315,12 +315,6 @@ static inline void sbitmap_deferred_clear_bit(struct sbitmap *sb, unsigned int b
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
2.28.0

