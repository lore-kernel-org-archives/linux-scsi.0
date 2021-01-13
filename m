Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7EAC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA1F206C0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 01:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbhANBxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:53:20 -0500
Received: from smtp.infotech.no ([82.134.31.41]:50087 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbhANABD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 19:01:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 41C0B2042A4;
        Wed, 13 Jan 2021 23:45:51 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vvnHnDqG7mx8; Wed, 13 Jan 2021 23:45:49 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id E9DED204296;
        Wed, 13 Jan 2021 23:45:48 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH v13 15/45] sg: rework sg_vma_fault
Date:   Wed, 13 Jan 2021 17:44:56 -0500
Message-Id: <20210113224526.861000-16-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113224526.861000-1-dgilbert@interlog.com>
References: <20210113224526.861000-1-dgilbert@interlog.com>
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
index c376979c0efe..4d4e1c7b771c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1429,14 +1429,16 @@ sg_fasync(int fd, struct file *filp, int mode)
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
@@ -1448,20 +1450,31 @@ sg_vma_fault(struct vm_fault *vmf)
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

