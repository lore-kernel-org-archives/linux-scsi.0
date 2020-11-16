Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA37AC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8DD20782
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIaUXk4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgKPJId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:08:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728379AbgKPJIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605517711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1boafxgVkbzAVxrjUmbpC4G1KYXRR9SishF69UWWDoI=;
        b=eIaUXk4SAP/axhO0y1c7/NO8NkZHYjM19ZhoEfdcuN8AfQZWlyN9OwTGPjW6pGHBhZQ1YV
        KlrSMEQf7CKmpVN2yjRWiK8mIrZdKGlAAsAk2OK3K6am1mTNjn5PdTLY0lEREg84YxwO+D
        Qaq0MG9EljGSpRzufZZu2JgBXIrTjTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-doUaHe2tOG-Mp6t8UuieaA-1; Mon, 16 Nov 2020 04:08:27 -0500
X-MC-Unique: doUaHe2tOG-Mp6t8UuieaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D53BB879516;
        Mon, 16 Nov 2020 09:08:25 +0000 (UTC)
Received: from localhost (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A86DD5B4BF;
        Mon, 16 Nov 2020 09:08:21 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V4 06/12] sbitmap: add helper of sbitmap_calculate_shift
Date:   Mon, 16 Nov 2020 17:07:31 +0800
Message-Id: <20201116090737.50989-7-ming.lei@redhat.com>
In-Reply-To: <20201116090737.50989-1-ming.lei@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move code for calculating default shift into one public helper,
which can be used for SCSI to calculate shift.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/sbitmap.h | 18 ++++++++++++++++++
 lib/sbitmap.c           | 16 +++-------------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 34343ce3ef6c..2a40364d6d00 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -337,6 +337,24 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
 }
 
+static inline int sbitmap_calculate_shift(unsigned int depth)
+{
+	int	shift = ilog2(BITS_PER_LONG);
+
+	/*
+	 * If the bitmap is small, shrink the number of bits per word so
+	 * we spread over a few cachelines, at least. If less than 4
+	 * bits, just forget about it, it's not going to work optimally
+	 * anyway.
+	 */
+	if (depth >= 4) {
+		while ((4U << shift) > depth)
+			shift--;
+	}
+
+	return shift;
+}
+
 /**
  * sbitmap_show() - Dump &struct sbitmap information to a &struct seq_file.
  * @sb: Bitmap to show.
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index fb1d3c2f70a2..c5a58cf7731b 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -96,19 +96,9 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
 	unsigned int bits_per_word;
 	unsigned int i;
 
-	if (shift < 0) {
-		shift = ilog2(BITS_PER_LONG);
-		/*
-		 * If the bitmap is small, shrink the number of bits per word so
-		 * we spread over a few cachelines, at least. If less than 4
-		 * bits, just forget about it, it's not going to work optimally
-		 * anyway.
-		 */
-		if (depth >= 4) {
-			while ((4U << shift) > depth)
-				shift--;
-		}
-	}
+	if (shift < 0)
+		shift = sbitmap_calculate_shift(depth);
+
 	bits_per_word = 1U << shift;
 	if (bits_per_word > BITS_PER_LONG)
 		return -EINVAL;
-- 
2.25.4

