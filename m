Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849E5C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FD8020843
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PMiVQFyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfHMHZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:25:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMHZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cgclgIChKmsKhpLXlOft+Wkj1db+yWf9x8RgsfU6OzE=; b=PMiVQFyZ+8mfW2VPlqYVe8JiOY
        zV/v6anuZagKrECf9sNO2D0S6UYtGf2Y71W7ScHHDMen22YCjdpxmyIkYsD+erklxgBnNWxmgTH3z
        i7siYcXiP1tyrzRqw3CZlxaZDY9ffBoufN608XRatLLH4lxQUv5imlMpo7seTS7asruOsAyL6Gx0h
        r17Hrtfw3IhWn995g7AdHJYPiMB5PYSLgrVdSoGULegco/CTeSQP1jF5f74p1aQ33PslvnowIuOIq
        pqkbLpiJt0TTXLHNkL4ucIUPdIAam1UkmkfrjcQq+Qjey3ec1RMOMeWpeIukHy9JYq7sPNQZn+Nep
        rDdLc8fQ==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBg-00069T-Jl; Tue, 13 Aug 2019 07:25:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/28] char/mspec: remove SGI SN2 support
Date:   Tue, 13 Aug 2019 09:24:55 +0200
Message-Id: <20190813072514.23299-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SGI SN2 support is about to be removed, so drop the bits specific to
it from this driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/mspec.c | 155 +++----------------------------------------
 1 file changed, 11 insertions(+), 144 deletions(-)

diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index e75c9df7c2d8..a9d9f074fbd6 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -9,11 +9,8 @@
  *
  * This driver exports the SN special memory (mspec) facility to user
  * processes.
- * There are three types of memory made available thru this driver:
- * fetchops, uncached and cached.
- *
- * Fetchops are atomic memory operations that are implemented in the
- * memory controller on SGI SN hardware.
+ * There are two types of memory made available thru this driver:
+ * uncached and cached.
  *
  * Uncached are used for memory write combining feature of the ia64
  * cpu.
@@ -46,16 +43,8 @@
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/uncached.h>
-#include <asm/sn/addrs.h>
-#include <asm/sn/arch.h>
-#include <asm/sn/mspec.h>
-#include <asm/sn/sn_cpuid.h>
-#include <asm/sn/io.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/shubio.h>
 
 
-#define FETCHOP_ID	"SGI Fetchop,"
 #define CACHED_ID	"Cached,"
 #define UNCACHED_ID	"Uncached"
 #define REVISION	"4.0"
@@ -65,17 +54,10 @@
  * Page types allocated by the device.
  */
 enum mspec_page_type {
-	MSPEC_FETCHOP = 1,
-	MSPEC_CACHED,
+	MSPEC_CACHED = 2,
 	MSPEC_UNCACHED
 };
 
-#ifdef CONFIG_SGI_SN
-static int is_sn2;
-#else
-#define is_sn2		0
-#endif
-
 /*
  * One of these structures is allocated when an mspec region is mmaped. The
  * structure is pointed to by the vma->vm_private_data field in the vma struct.
@@ -96,39 +78,6 @@ struct vma_data {
 	unsigned long maddr[0];	/* Array of MSPEC addresses. */
 };
 
-/* used on shub2 to clear FOP cache in the HUB */
-static unsigned long scratch_page[MAX_NUMNODES];
-#define SH2_AMO_CACHE_ENTRIES	4
-
-static inline int
-mspec_zero_block(unsigned long addr, int len)
-{
-	int status;
-
-	if (is_sn2) {
-		if (is_shub2()) {
-			int nid;
-			void *p;
-			int i;
-
-			nid = nasid_to_cnodeid(get_node_number(__pa(addr)));
-			p = (void *)TO_AMO(scratch_page[nid]);
-
-			for (i=0; i < SH2_AMO_CACHE_ENTRIES; i++) {
-				FETCHOP_LOAD_OP(p, FETCHOP_LOAD);
-				p += FETCHOP_VAR_SIZE;
-			}
-		}
-
-		status = bte_copy(0, addr & ~__IA64_UNCACHED_OFFSET, len,
-				  BTE_WACQUIRE | BTE_ZERO_FILL, NULL);
-	} else {
-		memset((char *) addr, 0, len);
-		status = 0;
-	}
-	return status;
-}
-
 /*
  * mspec_open
  *
@@ -173,11 +122,8 @@ mspec_close(struct vm_area_struct *vma)
 		 */
 		my_page = vdata->maddr[index];
 		vdata->maddr[index] = 0;
-		if (!mspec_zero_block(my_page, PAGE_SIZE))
-			uncached_free_page(my_page, 1);
-		else
-			printk(KERN_WARNING "mspec_close(): "
-			       "failed to zero page %ld\n", my_page);
+		memset((char *)my_page, 0, PAGE_SIZE);
+		uncached_free_page(my_page, 1);
 	}
 
 	kvfree(vdata);
@@ -213,11 +159,7 @@ mspec_fault(struct vm_fault *vmf)
 		spin_unlock(&vdata->lock);
 	}
 
-	if (vdata->type == MSPEC_FETCHOP)
-		paddr = TO_AMO(maddr);
-	else
-		paddr = maddr & ~__IA64_UNCACHED_OFFSET;
-
+	paddr = maddr & ~__IA64_UNCACHED_OFFSET;
 	pfn = paddr >> PAGE_SHIFT;
 
 	return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
@@ -269,19 +211,13 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 	vma->vm_private_data = vdata;
 
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
-	if (vdata->type == MSPEC_FETCHOP || vdata->type == MSPEC_UNCACHED)
+	if (vdata->type == MSPEC_UNCACHED)
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_ops = &mspec_vm_ops;
 
 	return 0;
 }
 
-static int
-fetchop_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	return mspec_mmap(file, vma, MSPEC_FETCHOP);
-}
-
 static int
 cached_mmap(struct file *file, struct vm_area_struct *vma)
 {
@@ -294,18 +230,6 @@ uncached_mmap(struct file *file, struct vm_area_struct *vma)
 	return mspec_mmap(file, vma, MSPEC_UNCACHED);
 }
 
-static const struct file_operations fetchop_fops = {
-	.owner = THIS_MODULE,
-	.mmap = fetchop_mmap,
-	.llseek = noop_llseek,
-};
-
-static struct miscdevice fetchop_miscdev = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = "sgi_fetchop",
-	.fops = &fetchop_fops
-};
-
 static const struct file_operations cached_fops = {
 	.owner = THIS_MODULE,
 	.mmap = cached_mmap,
@@ -339,89 +263,32 @@ static int __init
 mspec_init(void)
 {
 	int ret;
-	int nid;
-
-	/*
-	 * The fetchop device only works on SN2 hardware, uncached and cached
-	 * memory drivers should both be valid on all ia64 hardware
-	 */
-#ifdef CONFIG_SGI_SN
-	if (ia64_platform_is("sn2")) {
-		is_sn2 = 1;
-		if (is_shub2()) {
-			ret = -ENOMEM;
-			for_each_node_state(nid, N_ONLINE) {
-				int actual_nid;
-				int nasid;
-				unsigned long phys;
-
-				scratch_page[nid] = uncached_alloc_page(nid, 1);
-				if (scratch_page[nid] == 0)
-					goto free_scratch_pages;
-				phys = __pa(scratch_page[nid]);
-				nasid = get_node_number(phys);
-				actual_nid = nasid_to_cnodeid(nasid);
-				if (actual_nid != nid)
-					goto free_scratch_pages;
-			}
-		}
 
-		ret = misc_register(&fetchop_miscdev);
-		if (ret) {
-			printk(KERN_ERR
-			       "%s: failed to register device %i\n",
-			       FETCHOP_ID, ret);
-			goto free_scratch_pages;
-		}
-	}
-#endif
 	ret = misc_register(&cached_miscdev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register device %i\n",
 		       CACHED_ID, ret);
-		if (is_sn2)
-			misc_deregister(&fetchop_miscdev);
-		goto free_scratch_pages;
+		return ret;
 	}
 	ret = misc_register(&uncached_miscdev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register device %i\n",
 		       UNCACHED_ID, ret);
 		misc_deregister(&cached_miscdev);
-		if (is_sn2)
-			misc_deregister(&fetchop_miscdev);
-		goto free_scratch_pages;
+		return ret;
 	}
 
-	printk(KERN_INFO "%s %s initialized devices: %s %s %s\n",
-	       MSPEC_BASENAME, REVISION, is_sn2 ? FETCHOP_ID : "",
-	       CACHED_ID, UNCACHED_ID);
+	printk(KERN_INFO "%s %s initialized devices: %s %s\n",
+	       MSPEC_BASENAME, REVISION, CACHED_ID, UNCACHED_ID);
 
 	return 0;
-
- free_scratch_pages:
-	for_each_node(nid) {
-		if (scratch_page[nid] != 0)
-			uncached_free_page(scratch_page[nid], 1);
-	}
-	return ret;
 }
 
 static void __exit
 mspec_exit(void)
 {
-	int nid;
-
 	misc_deregister(&uncached_miscdev);
 	misc_deregister(&cached_miscdev);
-	if (is_sn2) {
-		misc_deregister(&fetchop_miscdev);
-
-		for_each_node(nid) {
-			if (scratch_page[nid] != 0)
-				uncached_free_page(scratch_page[nid], 1);
-		}
-	}
 }
 
 module_init(mspec_init);
-- 
2.20.1

