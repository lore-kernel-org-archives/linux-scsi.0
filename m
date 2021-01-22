Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2DBC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970AD22DFA
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbhAVCha (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 21:37:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726716AbhAVCfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 21:35:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611282867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JFNwPRzhKVtwJllbpCbbqCnXRr3rf6vp6JSToC5x0GY=;
        b=Yt13qNYO0ASqalWrIcV/Lk7oBHdisfju8mlKbGidz+gwOvM8jEo8yHBhsiFS7GUzoUxaTd
        6cio6bjQ7wWqinfMlhgzvxXiL2JZn05Guaz71RA/Yb5bx8XnFIK7FSmvm4nzKz4PyoaGUw
        qLduMl3R+dVjZbI/sPiOiBhDezbQI/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-V486xY5_P6iSzf_Khy4Xgg-1; Thu, 21 Jan 2021 21:34:25 -0500
X-MC-Unique: V486xY5_P6iSzf_Khy4Xgg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9283B1922960;
        Fri, 22 Jan 2021 02:34:23 +0000 (UTC)
Received: from localhost (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E93D86D018;
        Fri, 22 Jan 2021 02:34:19 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V7 06/13] sbitmap: add helper of sbitmap_calculate_shift
Date:   Fri, 22 Jan 2021 10:33:10 +0800
Message-Id: <20210122023317.687987-7-ming.lei@redhat.com>
In-Reply-To: <20210122023317.687987-1-ming.lei@redhat.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index c65ba887dcc3..3087e1f15fdd 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -332,6 +332,24 @@ static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
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
index 73da26ad021e..47b3691058eb 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -87,19 +87,9 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
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
2.28.0

