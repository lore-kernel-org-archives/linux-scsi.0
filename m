Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3088FC43467
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3BDA20874
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgJPExU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:53:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44940 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388345AbgJPExK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Oct 2020 00:53:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B2F60204238;
        Fri, 16 Oct 2020 06:53:08 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id l6GpIUqz6pps; Fri, 16 Oct 2020 06:53:07 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 9A707204259;
        Fri, 16 Oct 2020 06:53:05 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
Subject: [PATCH 4/4] scatterlist: add sgl_memset()
Date:   Fri, 16 Oct 2020 00:52:58 -0400
Message-Id: <20201016045258.16246-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201016045258.16246-1-dgilbert@interlog.com>
References: <20201016045258.16246-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The existing sg_zero_buffer() function is a bit restrictive.
For example protection information (PI) blocks are usually
initialized to 0xff bytes. As its name suggests sgl_memset()
is modelled on memset(). One difference is the type of the
val argument which is u8 rather than int.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 include/linux/scatterlist.h |  3 +++
 lib/scatterlist.c           | 39 +++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ae260dc5fedb..e50dc9a6d887 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -329,6 +329,9 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
 		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
 		     size_t n_bytes);
 
+void sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+		u8 val, size_t n_bytes);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 344725990b9d..3ca66f0c949f 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1083,8 +1083,8 @@ EXPORT_SYMBOL(sgl_copy_sgl);
  *
  **/
 bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
-		     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
-		     size_t n_bytes)
+		    struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+		    size_t n_bytes)
 {
 	bool equ = true;
 	size_t x_off, y_off, len, x_len, y_len;
@@ -1140,3 +1140,38 @@ bool sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_sk
 	return equ;
 }
 EXPORT_SYMBOL(sgl_compare_sgl);
+
+/**
+ * sgl_memset - set byte 'val' n_bytes times on SG list
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries in sgl
+ * @skip:		 Number of bytes to skip before starting
+ * @val:		 byte value to write to sgl
+ * @n_bytes:		 The number of bytes to modify
+ *
+ * Notes:
+ *   Writes val n_bytes times or until sgl is exhausted.
+ *
+ **/
+void sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+		u8 val, size_t n_bytes)
+{
+	size_t offset = 0;
+	size_t len;
+	struct sg_mapping_iter miter;
+	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
+
+	if (n_bytes == 0)
+		return;
+	sg_miter_start(&miter, sgl, nents, sg_flags);
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
+}
-- 
2.25.1

