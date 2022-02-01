Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61861C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 03:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiBADta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 22:49:30 -0500
Received: from smtp.infotech.no ([82.134.31.41]:32860 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231993AbiBADt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 22:49:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 81C4A2041AE;
        Tue,  1 Feb 2022 04:49:27 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 94WlMPlS0Lj0; Tue,  1 Feb 2022 04:49:25 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id EE7DA2041AC;
        Tue,  1 Feb 2022 04:49:22 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v7 4/4] scatterlist: add sgl_memset()
Date:   Mon, 31 Jan 2022 22:49:15 -0500
Message-Id: <20220201034915.183117-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201034915.183117-1-dgilbert@interlog.com>
References: <20220201034915.183117-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The existing sg_zero_buffer() function is a bit restrictive. For
example protection information (PI) blocks are usually initialized
to 0xff bytes. As its name suggests sgl_memset() is modelled on
memset(). One difference is the type of the val argument which is
u8 rather than int. Plus it returns the number of bytes (over)written.

Change implementation of sg_zero_buffer() to call this new function.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h | 20 +++++++++-
 lib/scatterlist.c           | 78 ++++++++++++++++++++-----------------
 2 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index a96874a8b791..c0b7f5938e64 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -373,8 +373,6 @@ size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			    const void *buf, size_t buflen, off_t skip);
 size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			  void *buf, size_t buflen, off_t skip);
-size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
-		       size_t buflen, off_t skip);
 
 size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
 		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
@@ -388,6 +386,24 @@ bool sgl_equal_sgl_idx(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_
 		       struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
 		       size_t n_bytes, size_t *miscompare_idx);
 
+size_t sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+		  u8 val, size_t n_bytes);
+
+/**
+ * sg_zero_buffer - Zero-out a part of a SG list
+ * @sgl:		The SG list
+ * @nents:		Number of SG entries
+ * @buflen:		The number of bytes to zero out
+ * @skip:		Number of bytes to skip before zeroing
+ *
+ * Returns the number of bytes zeroed.
+ **/
+static inline size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
+				    size_t buflen, off_t skip)
+{
+	return sgl_memset(sgl, nents, skip, 0, buflen);
+}
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 1fb14b2e320a..35d706eed9c2 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1053,41 +1053,6 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 }
 EXPORT_SYMBOL(sg_pcopy_to_buffer);
 
-/**
- * sg_zero_buffer - Zero-out a part of a SG list
- * @sgl:		 The SG list
- * @nents:		 Number of SG entries
- * @buflen:		 The number of bytes to zero out
- * @skip:		 Number of bytes to skip before zeroing
- *
- * Returns the number of bytes zeroed.
- **/
-size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
-		       size_t buflen, off_t skip)
-{
-	unsigned int offset = 0;
-	struct sg_mapping_iter miter;
-	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
-
-	sg_miter_start(&miter, sgl, nents, sg_flags);
-
-	if (!sg_miter_skip(&miter, skip))
-		return false;
-
-	while (offset < buflen && sg_miter_next(&miter)) {
-		unsigned int len;
-
-		len = min(miter.length, buflen - offset);
-		memset(miter.addr, 0, len);
-
-		offset += len;
-	}
-
-	sg_miter_stop(&miter);
-	return offset;
-}
-EXPORT_SYMBOL(sg_zero_buffer);
-
 /**
  * sgl_copy_sgl - Copy over a destination sgl from a source sgl
  * @d_sgl:		 Destination sgl
@@ -1271,3 +1236,46 @@ bool sgl_equal_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip
 	return sgl_equal_sgl_idx(x_sgl, x_nents, x_skip, y_sgl, y_nents, y_skip, n_bytes, NULL);
 }
 EXPORT_SYMBOL(sgl_equal_sgl);
+
+/**
+ * sgl_memset - set byte 'val' up to n_bytes times on SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries in sgl
+ * @skip:		 Number of bytes to skip before starting
+ * @val:		 byte value to write to sgl
+ * @n_bytes:		 The (maximum) number of bytes to modify
+ *
+ * Returns:
+ *   The number of bytes written.
+ *
+ * Notes:
+ *   Stops writing if either sgl or n_bytes is exhausted. If n_bytes is
+ *   set SIZE_MAX then val will be written to each byte until the end
+ *   of sgl.
+ *
+ *   The notes in sgl_copy_sgl() about large sgl_s _applies here as well.
+ *
+ **/
+size_t sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+		  u8 val, size_t n_bytes)
+{
+	size_t offset = 0;
+	size_t len;
+	struct sg_mapping_iter miter;
+
+	if (n_bytes == 0)
+		return 0;
+	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	if (!sg_miter_skip(&miter, skip))
+		goto fini;
+
+	while ((offset < n_bytes) && sg_miter_next(&miter)) {
+		len = min(miter.length, n_bytes - offset);
+		memset(miter.addr, val, len);
+		offset += len;
+	}
+fini:
+	sg_miter_stop(&miter);
+	return offset;
+}
+EXPORT_SYMBOL(sgl_memset);
-- 
2.25.1

