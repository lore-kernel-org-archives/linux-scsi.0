Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA3AC43457
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 872CE2087D
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388874AbgJPExU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:53:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44935 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388247AbgJPExJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Oct 2020 00:53:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DAF72204191;
        Fri, 16 Oct 2020 06:53:07 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g1Jfl04mXnez; Fri, 16 Oct 2020 06:53:06 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 39303204238;
        Fri, 16 Oct 2020 06:53:04 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
Subject: [PATCH 3/4] scatterlist: add sgl_compare_sgl() function
Date:   Fri, 16 Oct 2020 00:52:57 -0400
Message-Id: <20201016045258.16246-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201016045258.16246-1-dgilbert@interlog.com>
References: <20201016045258.16246-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After enabling copies between scatter gather lists (sgl_s),
another storage related operation is to compare two sgl_s.
This new function is modelled on NVMe's Compare command and
the SCSI VERIFY(BYTCHK=1) command. Like memcmp() this function
returns false on the first miscompare and stop comparing.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  4 ++
 lib/scatterlist.c           | 84 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6649414c0749..ae260dc5fedb 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -325,6 +325,10 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
 		    struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
 		    size_t n_bytes);
 
+bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		     size_t n_bytes);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 1ec2c909c8d4..344725990b9d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -979,10 +979,10 @@ EXPORT_SYMBOL(sg_zero_buffer);
  * sgl_copy_sgl - Copy over a destination sgl from a source sgl
  * @d_sgl:		 Destination sgl
  * @d_nents:		 Number of SG entries in destination sgl
- * @d_skip:		 Number of bytes to skip in destination before copying
+ * @d_skip:		 Number of bytes to skip in destination before starting
  * @s_sgl:		 Source sgl
  * @s_nents:		 Number of SG entries in source sgl
- * @s_skip:		 Number of bytes to skip in source before copying
+ * @s_skip:		 Number of bytes to skip in source before starting
  * @n_bytes:		 The number of bytes to copy
  *
  * Returns the number of copied bytes.
@@ -1060,3 +1060,83 @@ size_t sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_ski
 }
 EXPORT_SYMBOL(sgl_copy_sgl);
 
+/**
+ * sgl_compare_sgl - Compare x and y (both sgl_s)
+ * @x_sgl:		 x (left) sgl
+ * @x_nents:		 Number of SG entries in x (left) sgl
+ * @x_skip:		 Number of bytes to skip in x (left) before starting
+ * @y_sgl:		 y (right) sgl
+ * @y_nents:		 Number of SG entries in y (right) sgl
+ * @y_skip:		 Number of bytes to skip in y (right) before starting
+ * @n_bytes:		 The number of bytes to compare
+ *
+ * Returns true if x and y compare equal before x, y or n_bytes is exhausted.
+ * Otherwise on a miscompare, returns false (and stops comparing).
+ *
+ * Notes:
+ *   x and y are symmetrical: they can be swapped and the result is the same.
+ *
+ *   Implementation is based on memcmp(). x and y segments may overlap.
+ *
+ *   Same comment from sgl_copy_sgl() about large _skip arguments applies here
+ *   as well.
+ *
+ **/
+bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		     size_t n_bytes)
+{
+	bool equ = true;
+	size_t x_off, y_off, len, x_len, y_len;
+	size_t offset = 0;
+	struct sg_mapping_iter x_iter;
+	struct sg_mapping_iter y_iter;
+
+	if (n_bytes == 0)
+		return true;
+	sg_miter_start(&x_iter, x_sgl, x_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	sg_miter_start(&y_iter, y_sgl, y_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	if (!sg_miter_skip(&x_iter, x_skip))
+		goto fini;
+	if (!sg_miter_skip(&y_iter, y_skip))
+		goto fini;
+
+	for (x_off = 0, y_off = 0; true ; ) {
+		/* Assume x_iter.length and y_iter.length can never be 0 */
+		if (x_off == 0) {
+			if (!sg_miter_next(&x_iter))
+				break;
+			x_len = x_iter.length;
+		} else {
+			x_len = x_iter.length - x_off;
+		}
+		if (y_off == 0) {
+			if (!sg_miter_next(&y_iter))
+				break;
+			y_len = y_iter.length;
+		} else {
+			y_len = y_iter.length - y_off;
+		}
+		len = min3(x_len, y_len, n_bytes - offset);
+
+		equ = memcmp(x_iter.addr + x_off, y_iter.addr + y_off, len) == 0;
+		offset += len;
+		if (!equ || offset >= n_bytes)
+			break;
+		if (x_len == y_len) {
+			x_off = 0;
+			y_off = 0;
+		} else if (x_len < y_len) {
+			x_off = 0;
+			y_off += len;
+		} else {
+			x_off += len;
+			y_off = 0;
+		}
+	}
+fini:
+	sg_miter_stop(&x_iter);
+	sg_miter_stop(&y_iter);
+	return equ;
+}
+EXPORT_SYMBOL(sgl_compare_sgl);
-- 
2.25.1

