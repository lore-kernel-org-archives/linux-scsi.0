Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D81CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 02:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244358AbiDKCbv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 22:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244371AbiDKCbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 22:31:20 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58849BC
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 19:29:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DE08D2041BD;
        Mon, 11 Apr 2022 04:29:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5nymGKVFHf3Y; Mon, 11 Apr 2022 04:29:01 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 3C2F0204179;
        Mon, 11 Apr 2022 04:28:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v24 16/46] sg: rework sg_mmap
Date:   Sun, 10 Apr 2022 22:28:06 -0400
Message-Id: <20220411022836.11871-17-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411022836.11871-1-dgilbert@interlog.com>
References: <20220411022836.11871-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simple rework of the sg_mmap() function.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2e451a650701..c906f70e47fd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1466,14 +1466,15 @@ static const struct vm_operations_struct sg_mmap_vm_ops = {
 	.fault = sg_vma_fault,
 };
 
+/* Entry point for mmap(2) system call */
 static int
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	struct sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	struct sg_scatter_hold *rsv_schp;
 	int k, length;
 	int ret = 0;
+	unsigned long req_sz, len, sa;
+	struct sg_scatter_hold *rsv_schp;
+	struct sg_fd *sfp;
 
 	if (!filp || !vma)
 		return -ENXIO;
@@ -1486,19 +1487,23 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	SG_LOG(3, sfp, "%s: vm_start=%p, len=%d\n", __func__,
 	       (void *)vma->vm_start, (int)req_sz);
 	if (vma->vm_pgoff)
-		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
+		return -EINVAL; /* only an offset of 0 accepted */
+	/* Check reserve request is inactive and has large enough buffer */
 	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->buflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
+	if (sfp->res_in_use) {
+		ret = -EBUSY;
+		goto out;
+	}
+	rsv_schp = &sfp->reserve;
+	if (req_sz > (unsigned long)rsv_schp->buflen) {
+		ret = -ENOMEM;
 		goto out;
 	}
-
 	sa = vma->vm_start;
 	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; k++) {
+	for (k = 0; k < rsv_schp->num_sgat && sa < vma->vm_end; ++k) {
 		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
+		len = min_t(unsigned long, len, (unsigned long)length);
 		sa += len;
 	}
 
-- 
2.25.1

