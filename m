Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5608C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 02:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbhLaCQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:16:15 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46082 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242547AbhLaCQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Dec 2021 21:16:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E25CB2041BD;
        Fri, 31 Dec 2021 03:08:45 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7CHrElf+TvdR; Fri, 31 Dec 2021 03:08:44 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        by smtp.infotech.no (Postfix) with ESMTPA id 3E8472041CE;
        Fri, 31 Dec 2021 03:08:38 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH 7/9] scsi_debug: add sdeb_sgl_copy_sgl and friends
Date:   Thu, 30 Dec 2021 21:08:27 -0500
Message-Id: <20211231020829.29147-8-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231020829.29147-1-dgilbert@interlog.com>
References: <20211231020829.29147-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scatter-gather list helper functions in this patch have been
proposed for inclusion in lib/scatterlist.c where they would be
exported. Before that happens they need to be accepted via another
kernel subsystem maintainer. In the meantime they are placed in
this driver with a "sdeb_" prefix and with static scope. The next
patch in this set makes extensive use of these functions as
the backing store(s) of the scsi_debug driver is changed from
vmalloc() based to sgl based.

These functions where proposed for the patchset whose cover was
titled: "[PATCH v4 0/4] scatterlist: add new capabilities". That
patchset was sent to the linux-block, linux-scsi and linux-kernel
lists on 20201016. Since all patches in that set were reviewed by
Bodo Stroesser his review is carried over to this patch.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 127 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 44c74cf6b498..464467fbbf1a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1206,6 +1206,133 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 	return 0;
 }
 
+/*
+ * The following 4 functions are proposed for lib/scatterlist.c (without the
+ * "sdeb_" prefix) and will be removed from this driver if the proposal is accepted.
+ */
+static size_t sdeb_sgl_copy_sgl(struct scatterlist *d_sgl, unsigned int d_nents, off_t d_skip,
+				struct scatterlist *s_sgl, unsigned int s_nents, off_t s_skip,
+				size_t n_bytes)
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
+
+static bool sdeb_sgl_compare_sgl_idx(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+				     struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+				     size_t n_bytes, size_t *miscompare_idx)
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
+
+static bool sdeb_sgl_compare_sgl(struct scatterlist *x_sgl, unsigned int x_nents, off_t x_skip,
+				 struct scatterlist *y_sgl, unsigned int y_nents, off_t y_skip,
+				 size_t n_bytes)
+{
+	return sdeb_sgl_compare_sgl_idx(x_sgl, x_nents, x_skip, y_sgl, y_nents, y_skip, n_bytes,
+					NULL);
+}
+
+static size_t sdeb_sgl_memset(struct scatterlist *sgl, unsigned int nents, off_t skip,
+			      u8 val, size_t n_bytes)
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
+
+/* end of functions proposed for lib/scatterlist.c */
+
 /* Fetches from SCSI "data-out" buffer. Returns number of bytes fetched into
  * 'arr' or -1 if error.
  */
-- 
2.25.1

