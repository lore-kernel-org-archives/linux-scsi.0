Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B31C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C3123136
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbhAVCiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 21:38:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726698AbhAVCfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 21:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611282852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dz69XAp6V25w6/fUS/AfxO4UWms2LrSSlaFzOyuN0DA=;
        b=SpeLTLEC0n3JMDrN4UAvygEry1iNzM4WKjMHGlX8F5JBLUbz1C1Wxi+mhAbvvNR+wdpEhB
        twNf1y0KysgbXsH/2K/x6cXPcbfr1LDotcvu0wBeRe0bkMs8LqQMnL7DvZNRg4yIaxHAJZ
        zuUKq6fyUGIfTctEVg/jgNfjSpzDPi4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-r7fP57pUNPGwzlMzRmA_Mw-1; Thu, 21 Jan 2021 21:34:08 -0500
X-MC-Unique: r7fP57pUNPGwzlMzRmA_Mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 322A410054FF;
        Fri, 22 Jan 2021 02:34:07 +0000 (UTC)
Received: from localhost (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82575100AE44;
        Fri, 22 Jan 2021 02:34:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V7 03/13] sbitmap: add helpers for updating allocation hint
Date:   Fri, 22 Jan 2021 10:33:07 +0800
Message-Id: <20210122023317.687987-4-ming.lei@redhat.com>
In-Reply-To: <20210122023317.687987-1-ming.lei@redhat.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers for updating allocation hint, so that we can
avoid to duplicate code.

Prepare for moving allocation hint into sbitmap.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 lib/sbitmap.c | 93 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 7000636933b3..2b43a6aefec3 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -9,6 +9,55 @@
 #include <linux/sbitmap.h>
 #include <linux/seq_file.h>
 
+static int init_alloc_hint(struct sbitmap_queue *sbq, gfp_t flags)
+{
+	unsigned depth = sbq->sb.depth;
+
+	sbq->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
+	if (!sbq->alloc_hint)
+		return -ENOMEM;
+
+	if (depth && !sbq->sb.round_robin) {
+		int i;
+
+		for_each_possible_cpu(i)
+			*per_cpu_ptr(sbq->alloc_hint, i) = prandom_u32() % depth;
+	}
+
+	return 0;
+}
+
+static inline unsigned update_alloc_hint_before_get(struct sbitmap_queue *sbq,
+						    unsigned int depth)
+{
+	unsigned hint;
+
+	hint = this_cpu_read(*sbq->alloc_hint);
+	if (unlikely(hint >= depth)) {
+		hint = depth ? prandom_u32() % depth : 0;
+		this_cpu_write(*sbq->alloc_hint, hint);
+	}
+
+	return hint;
+}
+
+static inline void update_alloc_hint_after_get(struct sbitmap_queue *sbq,
+					       unsigned int depth,
+					       unsigned int hint,
+					       unsigned int nr)
+{
+	if (nr == -1) {
+		/* If the map is full, a hint won't do us much good. */
+		this_cpu_write(*sbq->alloc_hint, 0);
+	} else if (nr == hint || unlikely(sbq->sb.round_robin)) {
+		/* Only update the hint if we used it. */
+		hint = nr + 1;
+		if (hint >= depth - 1)
+			hint = 0;
+		this_cpu_write(*sbq->alloc_hint, hint);
+	}
+}
+
 /*
  * See if we have deferred clears that we can batch move
  */
@@ -355,17 +404,11 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq, unsigned int depth,
 	if (ret)
 		return ret;
 
-	sbq->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
-	if (!sbq->alloc_hint) {
+	if (init_alloc_hint(sbq, flags) != 0) {
 		sbitmap_free(&sbq->sb);
 		return -ENOMEM;
 	}
 
-	if (depth && !round_robin) {
-		for_each_possible_cpu(i)
-			*per_cpu_ptr(sbq->alloc_hint, i) = prandom_u32() % depth;
-	}
-
 	sbq->min_shallow_depth = UINT_MAX;
 	sbq->wake_batch = sbq_calc_wake_batch(sbq, depth);
 	atomic_set(&sbq->wake_index, 0);
@@ -418,24 +461,10 @@ int __sbitmap_queue_get(struct sbitmap_queue *sbq)
 	unsigned int hint, depth;
 	int nr;
 
-	hint = this_cpu_read(*sbq->alloc_hint);
 	depth = READ_ONCE(sbq->sb.depth);
-	if (unlikely(hint >= depth)) {
-		hint = depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	hint = update_alloc_hint_before_get(sbq, depth);
 	nr = sbitmap_get(&sbq->sb, hint);
-
-	if (nr == -1) {
-		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr == hint || unlikely(sbq->sb.round_robin)) {
-		/* Only update the hint if we used it. */
-		hint = nr + 1;
-		if (hint >= depth - 1)
-			hint = 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	update_alloc_hint_after_get(sbq, depth, hint, nr);
 
 	return nr;
 }
@@ -449,24 +478,10 @@ int __sbitmap_queue_get_shallow(struct sbitmap_queue *sbq,
 
 	WARN_ON_ONCE(shallow_depth < sbq->min_shallow_depth);
 
-	hint = this_cpu_read(*sbq->alloc_hint);
 	depth = READ_ONCE(sbq->sb.depth);
-	if (unlikely(hint >= depth)) {
-		hint = depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	hint = update_alloc_hint_before_get(sbq, depth);
 	nr = sbitmap_get_shallow(&sbq->sb, hint, shallow_depth);
-
-	if (nr == -1) {
-		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr == hint || unlikely(sbq->sb.round_robin)) {
-		/* Only update the hint if we used it. */
-		hint = nr + 1;
-		if (hint >= depth - 1)
-			hint = 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
-	}
+	update_alloc_hint_after_get(sbq, depth, hint, nr);
 
 	return nr;
 }
-- 
2.28.0

