Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FD9C2D0E4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FDD246DC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MvydeMK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgKSJrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 04:47:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbgKSJrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 04:47:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605779267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/ydx/Vm4HSwzsCtYxgT/l4606YkZuZlD2BGhGnlVZI=;
        b=MvydeMK0Uhd3aunTRPB/Lhtj3sQYYzFacDMEAykFjXdGyIy+9L8CH3FJTvGZK00A8pRamD
        JR7Z/J+3VSsmbYVrO2hCMUPnEZLna9sVjK/ctvQhwxv5L0aPoSDNoZqjLdqGP+6KwTopnw
        Ne+oSkMvCCnECSgwc0ja9n3417mn0cI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-uleNYCOoOJGHSR2bv6DXsw-1; Thu, 19 Nov 2020 04:47:45 -0500
X-MC-Unique: uleNYCOoOJGHSR2bv6DXsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E7A8144E6;
        Thu, 19 Nov 2020 09:47:44 +0000 (UTC)
Received: from localhost (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BC815D9C0;
        Thu, 19 Nov 2020 09:47:40 +0000 (UTC)
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
Date:   Thu, 19 Nov 2020 17:46:57 +0800
Message-Id: <20201119094705.280390-6-ming.lei@redhat.com>
In-Reply-To: <20201119094705.280390-1-ming.lei@redhat.com>
References: <20201119094705.280390-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

