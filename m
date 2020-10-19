Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D56C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B0722365
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgJSTTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:19:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:56037 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbgJSTTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 15:19:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5ECB12041D7;
        Mon, 19 Oct 2020 21:19:38 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h8dR+vfYtipF; Mon, 19 Oct 2020 21:19:38 +0200 (CEST)
Received: from xtwo70.bingwo.ca (vpn.infotech.no [82.134.31.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 0E96A20414F;
        Mon, 19 Oct 2020 21:19:36 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: [PATCH v3 4/4] scatterlist: add sgl_memset()
Date:   Mon, 19 Oct 2020 15:19:28 -0400
Message-Id: <20201019191928.77845-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201019191928.77845-1-dgilbert@interlog.com>
References: <20201019191928.77845-1-dgilbert@interlog.com>
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

Change implementation of sg_zero_buffer() to call this new
function.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  3 ++
 lib/scatterlist.c           | 65 +++++++++++++++++++++++++------------
 2 files changed, 48 insertions(+), 20 deletions(-)

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
index 49185536acba..6b430f7293e0 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -952,26 +952,7 @@ EXPORT_SYMBOL(sg_pcopy_to_buffer);
 size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 		       size_t buflen, off_t skip)
 {
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
+	return sgl_memset(sgl, nents, skip, 0, buflen);
 }
 EXPORT_SYMBOL(sg_zero_buffer);
 
@@ -1110,3 +1091,47 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
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
+	}
+fini:
+	sg_miter_stop(&miter);
+	return offset;
+}
+EXPORT_SYMBOL(sgl_memset);
+
-- 
2.25.1

