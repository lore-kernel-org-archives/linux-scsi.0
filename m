Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4041AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 02:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123C122C9F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 02:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbhAYCB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jan 2021 21:01:29 -0500
Received: from smtp.infotech.no ([82.134.31.41]:45887 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbhAYB7H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Jan 2021 20:59:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1C387204272;
        Mon, 25 Jan 2021 02:27:23 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WCOyx0ngbxcc; Mon, 25 Jan 2021 02:27:21 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id ED27B20425C;
        Mon, 25 Jan 2021 02:27:11 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH v14 15/45] sg: rework sg_vma_fault
Date:   Sun, 24 Jan 2021 20:26:20 -0500
Message-Id: <20210125012650.269411-16-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125012650.269411-1-dgilbert@interlog.com>
References: <20210125012650.269411-1-dgilbert@interlog.com>
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
index e847d94cf2b2..afeb12cc40b7 100644
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

