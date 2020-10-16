Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BCEC4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A432073A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgJPExI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:53:08 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44921 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgJPExI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Oct 2020 00:53:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2219920425C;
        Fri, 16 Oct 2020 06:53:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8+pwfKrTq32T; Fri, 16 Oct 2020 06:53:04 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id CF86120423B;
        Fri, 16 Oct 2020 06:53:02 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
Subject: [PATCH 2/4] scatterlist: add sgl_copy_sgl() function
Date:   Fri, 16 Oct 2020 00:52:56 -0400
Message-Id: <20201016045258.16246-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201016045258.16246-1-dgilbert@interlog.com>
References: <20201016045258.16246-1-dgilbert@interlog.com>
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
operations in the kernel. Start with a copy.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  4 ++
 lib/scatterlist.c           | 86 +++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 80178afc2a4a..6649414c0749 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -321,6 +321,10 @@ size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
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
index d5770e7f1030..1ec2c909c8d4 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -974,3 +974,89 @@ size_t sg_zero_buffer(struct scatterlist *sgl, unsigned int nents,
 	return offset;
 }
 EXPORT_SYMBOL(sg_zero_buffer);
+
+/**
+ * sgl_copy_sgl - Copy over a destination sgl from a source sgl
+ * @d_sgl:		 Destination sgl
+ * @d_nents:		 Number of SG entries in destination sgl
+ * @d_skip:		 Number of bytes to skip in destination before copying
+ * @s_sgl:		 Source sgl
+ * @s_nents:		 Number of SG entries in source sgl
+ * @s_skip:		 Number of bytes to skip in source before copying
+ * @n_bytes:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ * Notes:
+ *   Destination arguments appear before the source arguments, as with memcpy().
+ *
+ *   Stops copying if the end of d_sgl or s_sgl is reached.
+ *
+ *   Since memcpy() is used, overlapping copies (where d_sgl and s_sgl belong
+ *   to the same sgl and the copy regions overlap) are not supported.
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
+	size_t d_off, s_off, len, d_len, s_len;
+	size_t offset = 0;
+	struct sg_mapping_iter d_iter;
+	struct sg_mapping_iter s_iter;
+
+	if (n_bytes == 0)
+		return 0;
+	sg_miter_start(&d_iter, d_sgl, d_nents, SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	sg_miter_start(&s_iter, s_sgl, s_nents, SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	if (!sg_miter_skip(&d_iter, d_skip))
+		goto fini;
+	if (!sg_miter_skip(&s_iter, s_skip))
+		goto fini;
+
+	for (d_off = 0, s_off = 0; true ; ) {
+		/* Assume d_iter.length and s_iter.length can never be 0 */
+		if (d_off == 0) {
+			if (!sg_miter_next(&d_iter))
+				break;
+			d_len = d_iter.length;
+		} else {
+			d_len = d_iter.length - d_off;
+		}
+		if (s_off == 0) {
+			if (!sg_miter_next(&s_iter))
+				break;
+			s_len = s_iter.length;
+		} else {
+			s_len = s_iter.length - s_off;
+		}
+		len = min3(d_len, s_len, n_bytes - offset);
+
+		memcpy(d_iter.addr + d_off, s_iter.addr + s_off, len);
+		offset += len;
+		if (offset >= n_bytes)
+			break;
+		if (d_len == s_len) {
+			d_off = 0;
+			s_off = 0;
+		} else if (d_len < s_len) {
+			d_off = 0;
+			s_off += len;
+		} else {
+			d_off += len;
+			s_off = 0;
+		}
+	}
+fini:
+	sg_miter_stop(&d_iter);
+	sg_miter_stop(&s_iter);
+	return offset;
+}
+EXPORT_SYMBOL(sgl_copy_sgl);
+
-- 
2.25.1

