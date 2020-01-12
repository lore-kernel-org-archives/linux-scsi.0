Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189D5C33CB0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1BB20724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgALX6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:20 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51940 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbgALX6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C6BFF20415B;
        Mon, 13 Jan 2020 00:58:18 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ibuH7t9OcaP9; Mon, 13 Jan 2020 00:58:17 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id E4DB6204275;
        Mon, 13 Jan 2020 00:57:58 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v6 15/37] sg: rework sg_vma_fault
Date:   Mon, 13 Jan 2020 00:57:33 +0100
Message-Id: <20200112235755.14197-16-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simple refactoring of the sg_vma_fault() function.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 07d203ba7439..d4a1ca180d21 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1423,14 +1423,16 @@ sg_fasync(int fd, struct file *filp, int mode)
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
@@ -1442,20 +1444,31 @@ sg_vma_fault(struct vm_fault *vmf)
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
2.24.1

