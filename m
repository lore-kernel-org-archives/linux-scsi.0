Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C55C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 01:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4857F22C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 01:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbhAYBik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jan 2021 20:38:40 -0500
Received: from smtp.infotech.no ([82.134.31.41]:45824 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbhAYBho (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Jan 2021 20:37:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C17C52042AD;
        Mon, 25 Jan 2021 02:27:23 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0c+fs5SzmLQe; Mon, 25 Jan 2021 02:27:22 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 140FB20429F;
        Mon, 25 Jan 2021 02:27:12 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH v14 16/45] sg: rework sg_mmap
Date:   Sun, 24 Jan 2021 20:26:21 -0500
Message-Id: <20210125012650.269411-17-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125012650.269411-1-dgilbert@interlog.com>
References: <20210125012650.269411-1-dgilbert@interlog.com>
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
index afeb12cc40b7..90ce33849aa7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1489,14 +1489,15 @@ static const struct vm_operations_struct sg_mmap_vm_ops = {
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
@@ -1509,19 +1510,23 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
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

