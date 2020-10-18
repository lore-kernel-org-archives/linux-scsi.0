Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19FEC43457
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 17:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB6E72223F
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 17:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgJRRNz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 13:13:55 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52056 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbgJRRNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 13:13:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E3C01204255;
        Sun, 18 Oct 2020 19:13:51 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gHPwiAFxcovT; Sun, 18 Oct 2020 19:13:49 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 1DDB720418E;
        Sun, 18 Oct 2020 19:13:47 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: [PATCH v2 4/4] scatterlist: add sgl_memset()
Date:   Sun, 18 Oct 2020 13:13:36 -0400
Message-Id: <20201018171336.63839-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018171336.63839-1-dgilbert@interlog.com>
References: <20201018171336.63839-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The existing sg_zero_buffer() function is a bit restrictive.
For example protection information (PI) blocks are usually
initialized to 0xff bytes. As its name suggests sgl_memset()
is modelled on memset(). One difference is the type of the
val argument which is u8 rather than int. Plus it returns
the number of bytes (over)written.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  3 +++
 lib/scatterlist.c           | 54 ++++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ae260dc5fedb..a40012c8a4e6 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -329,6 +329,9 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
 		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
 		     size_t n_bytes);
 
+size_t sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+		  u8 val, size_t n_bytes);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d910776a4c96..a704039ab54d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -985,7 +985,8 @@ EXPORT_SYMBOL(sg_zero_buffer);
  * @s_skip:		 Number of bytes to skip in source before starting
  * @n_bytes:		 The (maximum) number of bytes to copy
  *
- * Returns the number of copied bytes.
+ * Returns:
+ *   The number of copied bytes.
  *
  * Notes:
  *   Destination arguments appear before the source arguments, as with memcpy().
@@ -1058,8 +1059,9 @@ EXPORT_SYMBOL(sgl_copy_sgl);
  * @y_skip:		 Number of bytes to skip in y (right) before starting
  * @n_bytes:		 The (maximum) number of bytes to compare
  *
- * Returns true if x and y compare equal before x, y or n_bytes is exhausted.
- * Otherwise on a miscompare, returns false (and stops comparing).
+ * Returns:
+ *   true if x and y compare equal before x, y or n_bytes is exhausted.
+ *   Otherwise on a miscompare, returns false (and stops comparing).
  *
  * Notes:
  *   x and y are symmetrical: they can be swapped and the result is the same.
@@ -1108,3 +1110,49 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
 	return equ;
 }
 EXPORT_SYMBOL(sgl_compare_sgl);
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
+		miter.consumed = len;
+		sg_miter_stop(&miter);
+	}
+fini:
+	sg_miter_stop(&miter);
+	return offset;
+}
+EXPORT_SYMBOL(sgl_memset);
+
-- 
2.25.1

