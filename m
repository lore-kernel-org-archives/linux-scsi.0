Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE18C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3181E64E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBGJWw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:22:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229717AbhBGJWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 04:22:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612689666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NQbHSeYUBG1OhOepiNAE6URM0kU5Vn4WnKABOQl7lo=;
        b=ZcBBEG0C3+yTUV9HNTaNlwxIto2yQlz9jqullNsQ/etNnQayd4Btw3ZidJ4V8LRNAxsk3z
        1S2wvrljIBYQq3nHv8yCqUu8Z2CVIjYtz19CXx84e/sznUB44a53M+hxPwmMTJCtymQgGg
        ly6PpciJxCCkoAIoSd3KJAAbHIurjYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-ap8Y5AizOLuhA0eR-DzMag-1; Sun, 07 Feb 2021 04:21:04 -0500
X-MC-Unique: ap8Y5AizOLuhA0eR-DzMag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 475161846092;
        Sun,  7 Feb 2021 09:21:03 +0000 (UTC)
Received: from localhost (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97AB35C8A7;
        Sun,  7 Feb 2021 09:21:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V8 05/13] sbitmap: export sbitmap_weight
Date:   Sun,  7 Feb 2021 17:20:21 +0800
Message-Id: <20210207092029.1558550-6-ming.lei@redhat.com>
In-Reply-To: <20210207092029.1558550-1-ming.lei@redhat.com>
References: <20210207092029.1558550-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI's .device_busy will be converted to sbitmap, and sbitmap_weight
is needed, so export the helper.

Meantime the only user of sbitmap_weight() is just for getting how
many set and not cleared bits, so align sbitmap_weight() meaning
with this way because the external user only cares how many busy
bits there are in the sbitmap.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/sbitmap.h | 10 ++++++++++
 lib/sbitmap.c           | 11 ++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 247776fcc02c..c65ba887dcc3 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -341,6 +341,16 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
  */
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
 
+
+/**
+ * sbitmap_weight() - Return how many set and not cleared bits in a &struct
+ * sbitmap.
+ * @sb: Bitmap to check.
+ *
+ * Return: How many set and not cleared bits set
+ */
+unsigned int sbitmap_weight(const struct sbitmap *sb);
+
 /**
  * sbitmap_bitmap_show() - Write a hex dump of a &struct sbitmap to a &struct
  * seq_file.
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index e395435654aa..73da26ad021e 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -334,20 +334,21 @@ static unsigned int __sbitmap_weight(const struct sbitmap *sb, bool set)
 	return weight;
 }
 
-static unsigned int sbitmap_weight(const struct sbitmap *sb)
+static unsigned int sbitmap_cleared(const struct sbitmap *sb)
 {
-	return __sbitmap_weight(sb, true);
+	return __sbitmap_weight(sb, false);
 }
 
-static unsigned int sbitmap_cleared(const struct sbitmap *sb)
+unsigned int sbitmap_weight(const struct sbitmap *sb)
 {
-	return __sbitmap_weight(sb, false);
+	return __sbitmap_weight(sb, true) - sbitmap_cleared(sb);
 }
+EXPORT_SYMBOL_GPL(sbitmap_weight);
 
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m)
 {
 	seq_printf(m, "depth=%u\n", sb->depth);
-	seq_printf(m, "busy=%u\n", sbitmap_weight(sb) - sbitmap_cleared(sb));
+	seq_printf(m, "busy=%u\n", sbitmap_weight(sb));
 	seq_printf(m, "cleared=%u\n", sbitmap_cleared(sb));
 	seq_printf(m, "bits_per_word=%u\n", 1U << sb->shift);
 	seq_printf(m, "map_nr=%u\n", sb->map_nr);
-- 
2.29.2

