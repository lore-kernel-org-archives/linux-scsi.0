Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38FBC47087
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72866117A
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 01:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhEXBDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 21:03:45 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33179 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhEXBDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 May 2021 21:03:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 43089204296;
        Mon, 24 May 2021 03:02:14 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x8VnGuP+vez6; Mon, 24 May 2021 03:02:12 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 25EBE204278;
        Mon, 24 May 2021 03:02:08 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v19 15/45] sg: rework sg_vma_fault
Date:   Sun, 23 May 2021 21:01:17 -0400
Message-Id: <20210524010147.94845-16-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524010147.94845-1-dgilbert@interlog.com>
References: <20210524010147.94845-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simple refactoring of the sg_vma_fault() function.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ed8d8d27f0d5..aa3202cbf3a1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1428,14 +1428,16 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
+/* Note: the error return: VM_FAULT_SIGBUS causes a "bus error" */
 static vm_fault_t
 sg_vma_fault(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	struct sg_fd *sfp;
+	int k, length;
 	unsigned long offset, len, sa;
+	struct vm_area_struct *vma = vmf->vma;
 	struct sg_scatter_hold *rsv_schp;
-	int k, length;
+	struct sg_device *sdp;
+	struct sg_fd *sfp;
 	const char *nbp = "==NULL, bad";
 
 	if (!vma) {
@@ -1447,20 +1449,31 @@ sg_vma_fault(struct vm_fault *vmf)
 		pr_warn("%s: sfp%s\n", __func__, nbp);
 		goto out_err;
 	}
+	sdp = sfp->parentdp;
+	if (sdp && unlikely(SG_IS_DETACHING(sdp))) {
+		SG_LOG(1, sfp, "%s: device detaching\n", __func__);
+		goto out_err;
+	}
 	rsv_schp = &sfp->reserve;
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->buflen)
-		return VM_FAULT_SIGBUS;
+	if (offset >= (unsigned int)rsv_schp->buflen) {
+		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__,
+		       offset);
+		goto out_err;
+	}
 	sa = vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=0x%lx, off=%lu\n", __func__, sa, offset);
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; k++) {
+	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; ++k) {
 		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
+		len = min_t(int, len, (int)length);
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
+			struct page *page;
+			struct page *pp;
+
+			pp = rsv_schp->pages[k];
+			page = nth_page(pp, offset >> PAGE_SHIFT);
+			get_page(page); /* increment page count */
 			vmf->page = page;
 			return 0; /* success */
 		}
-- 
2.25.1

