Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A77C388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D1E22259
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeALWGW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKSJes (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 04:34:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgKSJes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 04:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605778486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/ydx/Vm4HSwzsCtYxgT/l4606YkZuZlD2BGhGnlVZI=;
        b=YeALWGW4Jw9w60wSvoYdTfIiC9fBDruHtyQDlHjkzf8ZWyehCrLV8XybBbZ4xM7yVbz6fu
        RJZhaCXbazOLkrraby+2loelnMhrka8pZn5tqb8k5O1jQooSyt+pVM3pHvPHWhybyQY9mC
        mqpw0iF0gaREccUbOlZZmZU90UOsQnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-h-RED_i4OeSGeiZNEGbg6Q-1; Thu, 19 Nov 2020 04:34:44 -0500
X-MC-Unique: h-RED_i4OeSGeiZNEGbg6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4745018B6126;
        Thu, 19 Nov 2020 09:34:43 +0000 (UTC)
Received: from localhost (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 729A210016FB;
        Thu, 19 Nov 2020 09:34:39 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V5 05/13] sbitmap: export sbitmap_weight
Date:   Thu, 19 Nov 2020 17:33:54 +0800
Message-Id: <20201119093402.279318-6-ming.lei@redhat.com>
In-Reply-To: <20201119093402.279318-1-ming.lei@redhat.com>
References: <20201119093402.279318-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 103b41c03311..c1706cfd1ab3 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -346,6 +346,16 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
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
index dcd6a89b4d2f..fb1d3c2f70a2 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -342,20 +342,21 @@ static unsigned int __sbitmap_weight(const struct sbitmap *sb, bool set)
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
2.25.4

