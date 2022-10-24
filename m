Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017EFFA373F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 01:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiJXBME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 21:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJXBMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 21:12:00 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED94C63374
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 18:11:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 479772041CE;
        Mon, 24 Oct 2022 03:02:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d4n03ElnWqja; Mon, 24 Oct 2022 03:02:50 +0200 (CEST)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id B084E2041BB;
        Mon, 24 Oct 2022 03:02:48 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 2/5] scatterlist: add sgl_copy_sgl() function
Date:   Sun, 23 Oct 2022 21:02:41 -0400
Message-Id: <20221024010244.9522-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024010244.9522-1-dgilbert@interlog.com>
References: <20221024010244.9522-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both the SCSI and NVMe subsystems receive user data from the block
layer in scatterlist_s (aka scatter gather lists (sgl) which are
often arrays). If drivers in those subsystems represent storage
(e.g. a ramdisk) or cache "hot" user data then they may also
choose to use scatterlist_s. Currently there are no sgl to sgl
operations in the kernel. Start with a sgl to sgl copy. Stops
when the first of the number of requested bytes to copy, or the
source sgl, or the destination sgl is exhausted. So the
destination sgl will _not_ grow.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  4 ++
 lib/scatterlist.c           | 74 +++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 0930755a756e..cea1edd246cb 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -445,6 +445,10 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 		       size_t buflen, off_t skip);
 
+size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
+		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
+		    size_t n_bytes);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index f633e2d669fe..5d873bd0cb96 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1088,3 +1088,77 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 	return offset;
 }
 EXPORT_SYMBOL(sg_zero_buffer);
+
+/**
+ * sgl_copy_sgl - Copy over a destination sgl from a source sgl
+ * @d_sgl:		 Destination sgl
+ * @d_nents:		 Number of SG entries in destination sgl
+ * @d_skip:		 Number of bytes to skip in destination before starting
+ * @s_sgl:		 Source sgl
+ * @s_nents:		 Number of SG entries in source sgl
+ * @s_skip:		 Number of bytes to skip in source before starting
+ * @n_bytes:		 The (maximum) number of bytes to copy
+ *
+ * Returns:
+ *   The number of copied bytes.
+ *
+ * Notes:
+ *   Destination arguments appear before the source arguments, as with memcpy().
+ *
+ *   Stops copying if either d_sgl, s_sgl or n_bytes is exhausted.
+ *
+ *   Since memcpy() is used, overlapping copies (where d_sgl and s_sgl belong
+ *   to the same sgl and the copy regions overlap) are not supported.
+ *
+ *   Large copies are broken into copy segments whose sizes may vary. Those
+ *   copy segment sizes are chosen by the min3() statement in the code below.
+ *   Since SG_MITER_ATOMIC is used for both sides, each copy segment is started
+ *   with kmap_atomic() [in sg_miter_next()] and completed with kunmap_atomic()
+ *   [in sg_miter_stop()]. This means pre-emption is inhibited for relatively
+ *   short periods even in very large copies.
+ *
+ *   If d_skip is large, potentially spanning multiple d_nents then some
+ *   integer arithmetic to adjust d_sgl may improve performance. For example
+ *   if d_sgl is built using sgl_alloc_order(chainable=false) then the sgl
+ *   will be an array with equally sized segments facilitating that
+ *   arithmetic. The suggestion applies to s_skip, s_sgl and s_nents as well.
+ *
+ **/
+size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
+		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
+		    size_t n_bytes)
+{
+	size_t len;
+	size_t offset = 0;
+	struct sg_mapping_iter d_iter, s_iter;
+
+	if (n_bytes == 0)
+		return 0;
+	sg_miter_start(&s_iter, s_sgl, s_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&d_iter, d_sgl, d_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	if (!sg_miter_skip(&s_iter, s_skip))
+		goto fini;
+	if (!sg_miter_skip(&d_iter, d_skip))
+		goto fini;
+
+	while (offset < n_bytes) {
+		if (!sg_miter_next(&s_iter))
+			break;
+		if (!sg_miter_next(&d_iter))
+			break;
+		len = min3(d_iter.length, s_iter.length, n_bytes - offset);
+
+		memcpy(d_iter.addr, s_iter.addr, len);
+		offset += len;
+		/* LIFO order (stop d_iter before s_iter) needed with SG_MITER_ATOMIC */
+		d_iter.consumed = len;
+		sg_miter_stop(&d_iter);
+		s_iter.consumed = len;
+		sg_miter_stop(&s_iter);
+	}
+fini:
+	sg_miter_stop(&d_iter);
+	sg_miter_stop(&s_iter);
+	return offset;
+}
+EXPORT_SYMBOL(sgl_copy_sgl);
-- 
2.37.3

