Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85584C3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 01:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJXBMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 21:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJXBMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 21:12:00 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3710635DE
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 18:11:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4B54D2041D7;
        Mon, 24 Oct 2022 03:02:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aXc9Tbhz7yvZ; Mon, 24 Oct 2022 03:02:52 +0200 (CEST)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id E31F52041C0;
        Mon, 24 Oct 2022 03:02:49 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Bodo Stroesser <bostroesser@gmail.com>,
        David Disseldorp <ddiss@suse.de>
Subject: [PATCH 3/5] scatterlist: add sgl_equal_sgl() function
Date:   Sun, 23 Oct 2022 21:02:42 -0400
Message-Id: <20221024010244.9522-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024010244.9522-1-dgilbert@interlog.com>
References: <20221024010244.9522-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After enabling copies between scatter gather lists (sgl_s), another
storage related operation is to compare two sgl_s for equality. This
new function is designed to partially implement NVMe's Compare
command and the SCSI VERIFY(BYTCHK=1) command. Like memcmp() this
function begins scanning at the start (of each sgl) and returns
false on the first miscompare and stops comparing.

The sgl_equal_sgl_idx() function additionally yields the index (i.e.
byte position) of the first miscompare. The additional parameter,
miscompare_idx, is a pointer. If it is non-NULL and a miscompare is
detected (i.e. the function returns false) then the byte index of
the first miscompare is written to *miscompare_idx. Knowing the
location of the first miscompare is needed to implement properly
the SCSI COMPARE AND WRITE command.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |   8 +++
 lib/scatterlist.c           | 110 ++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cea1edd246cb..e1552a3e9e13 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -449,6 +449,14 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
 		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
 		    size_t n_bytes);
 
+bool sgl_equal_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		   struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		   size_t n_bytes);
+
+bool sgl_equal_sgl_idx(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		       struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		       size_t n_bytes, size_t *miscompare_idx);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 5d873bd0cb96..426d73ba464a 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1162,3 +1162,113 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
 	return offset;
 }
 EXPORT_SYMBOL(sgl_copy_sgl);
+
+/**
+ * sgl_equal_sgl_idx - check if x and y (both sgl_s) compare equal, report
+ *		       index for first unequal bytes
+ * @x_sgl:		 x (left) sgl
+ * @x_nents:		 Number of SG entries in x (left) sgl
+ * @x_skip:		 Number of bytes to skip in x (left) before starting
+ * @y_sgl:		 y (right) sgl
+ * @y_nents:		 Number of SG entries in y (right) sgl
+ * @y_skip:		 Number of bytes to skip in y (right) before starting
+ * @n_bytes:		 The (maximum) number of bytes to compare
+ * @miscompare_idx:	 if return is false, index of first miscompare written
+ *			 to this pointer (if non-NULL). Value will be < n_bytes
+ *
+ * Returns:
+ *   true if x and y compare equal before x, y or n_bytes is exhausted.
+ *   Otherwise on a miscompare, returns false (and stops comparing). If return
+ *   is false and miscompare_idx is non-NULL, then index of first miscompared
+ *   byte written to *miscompare_idx.
+ *
+ * Notes:
+ *   x and y are symmetrical: they can be swapped and the result is the same.
+ *
+ *   Implementation is based on memcmp(). x and y segments may overlap.
+ *
+ *   The notes in sgl_copy_sgl() about large sgl_s _applies here as well.
+ *
+ **/
+bool sgl_equal_sgl_idx(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		       struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		       size_t n_bytes, size_t *miscompare_idx)
+{
+	bool equ = true;
+	size_t len;
+	size_t offset = 0;
+	struct sg_mapping_iter x_iter, y_iter;
+
+	if (n_bytes == 0)
+		return true;
+	sg_miter_start(&x_iter, x_sgl, x_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&y_iter, y_sgl, y_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	if (!sg_miter_skip(&x_iter, x_skip))
+		goto fini;
+	if (!sg_miter_skip(&y_iter, y_skip))
+		goto fini;
+
+	while (offset < n_bytes) {
+		if (!sg_miter_next(&x_iter))
+			break;
+		if (!sg_miter_next(&y_iter))
+			break;
+		len = min3(x_iter.length, y_iter.length, n_bytes - offset);
+
+		equ = !memcmp(x_iter.addr, y_iter.addr, len);
+		if (!equ)
+			goto fini;
+		offset += len;
+		/* LIFO order is important when SG_MITER_ATOMIC is used */
+		y_iter.consumed = len;
+		sg_miter_stop(&y_iter);
+		x_iter.consumed = len;
+		sg_miter_stop(&x_iter);
+	}
+fini:
+	if (miscompare_idx && !equ) {
+		u8 *xp = x_iter.addr;
+		u8 *yp = y_iter.addr;
+		u8 *x_endp;
+
+		for (x_endp = xp + len ; xp < x_endp; ++xp, ++yp) {
+			if (*xp != *yp)
+				break;
+		}
+		*miscompare_idx = offset + len - (x_endp - xp);
+	}
+	sg_miter_stop(&y_iter);
+	sg_miter_stop(&x_iter);
+	return equ;
+}
+EXPORT_SYMBOL(sgl_equal_sgl_idx);
+
+/**
+ * sgl_equal_sgl - check if x and y (both sgl_s) compare equal
+ * @x_sgl:		 x (left) sgl
+ * @x_nents:		 Number of SG entries in x (left) sgl
+ * @x_skip:		 Number of bytes to skip in x (left) before starting
+ * @y_sgl:		 y (right) sgl
+ * @y_nents:		 Number of SG entries in y (right) sgl
+ * @y_skip:		 Number of bytes to skip in y (right) before starting
+ * @n_bytes:		 The (maximum) number of bytes to compare
+ *
+ * Returns:
+ *   true if x and y compare equal before x, y or n_bytes is exhausted.
+ *   Otherwise on a miscompare, returns false (and stops comparing).
+ *
+ * Notes:
+ *   x and y are symmetrical: they can be swapped and the result is the same.
+ *
+ *   Implementation is based on memcmp(). x and y segments may overlap.
+ *
+ *   The notes in sgl_copy_sgl() about large sgl_s _applies here as well.
+ *
+ **/
+bool sgl_equal_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		   struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		   size_t n_bytes)
+{
+	return sgl_equal_sgl_idx(x_sgl, x_nents, x_skip, y_sgl, y_nents, y_skip, n_bytes, NULL);
+}
+EXPORT_SYMBOL(sgl_equal_sgl);
-- 
2.37.3

