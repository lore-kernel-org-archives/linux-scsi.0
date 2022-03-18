Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F22C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 09:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiCRJ5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 05:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiCRJ5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 05:57:08 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8A2178686;
        Fri, 18 Mar 2022 02:55:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V7W8jbJ_1647597346;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V7W8jbJ_1647597346)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Mar 2022 17:55:47 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com,
        bostroesser@gmail.com
Subject: [RFC 1/3] mm/memory.c: introduce vm_insert_page(s)_mkspecial
Date:   Fri, 18 Mar 2022 17:55:29 +0800
Message-Id: <20220318095531.15479-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xu Yu <xuyu@linux.alibaba.com>

This adds the ability to insert anonymous pages or file pages, used for
direct IO or buffer IO respectively, to a user VM. The intention behind
this is to facilitate mapping pages in IO requests to user space, which
is usually the backend of remote block device.

This integrates the advantage of vm_insert_pages (batching the pmd lock),
and eliminates the overhead of remap_pfn_range (track_pfn_remap), since
the pages to be inserted should always be ram.

NOTE that file page used in buffer IO is either locked (read) or
writeback (sync), while anonymous page used in dio is pinned. Depending
on this premise, such pages can be inserted as special PTE, without
increasing the page refcount and mapcount. On the other hand, such pages
are unlocked, writeback cleared, or unpinned in endio, by when the
special mapping in user space is zapped (and of course, it is the caller's
responsibility).

Signed-off-by: Xu Yu <xuyu@linux.alibaba.com>
---
 include/linux/mm.h |   2 +
 mm/memory.c        | 182 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 184 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 213cc569b192..0d660139b29e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2870,6 +2870,8 @@ int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
+int vm_insert_pages_mkspecial(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
diff --git a/mm/memory.c b/mm/memory.c
index c125c4969913..1f745e4d11c2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2510,6 +2510,188 @@ int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long
 }
 EXPORT_SYMBOL(vm_iomap_memory);
 
+#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
+static int insert_page_into_pte_locked_mkspecial(struct mm_struct *mm, pte_t *pte,
+					unsigned long addr, struct page *page, pgprot_t prot)
+{
+	/*
+	 * The page to be inserted should be either anonymous page or file page.
+	 * The anonymous page used in dio should be pinned, while the file page
+	 * used in buffer IO is either locked (read) or writeback (sync).
+	 */
+	if (PageAnon(page)) {
+		int extra = 0;
+
+		if (PageSwapCache(page))
+			extra += 1 + page_has_private(page);
+
+		if ((page_count(page) - extra) <= page_mapcount(page))
+			return -EINVAL;
+	} else if (page_is_file_lru(page)) {
+		if (!PageLocked(page) && !PageWriteback(page))
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	flush_dcache_page(page);
+
+	if (!pte_none(*pte))
+		return -EBUSY;
+	set_pte_at(mm, addr, pte, pte_mkspecial(mk_pte(page, prot)));
+	return 0;
+}
+
+static int insert_page_mkspecial(struct vm_area_struct *vma, unsigned long addr,
+				 struct page *page, pgprot_t prot)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int retval;
+	pte_t *pte;
+	spinlock_t *ptl;
+
+	retval = -ENOMEM;
+	pte = get_locked_pte(mm, addr, &ptl);
+	if (!pte)
+		goto out;
+	retval = insert_page_into_pte_locked_mkspecial(mm, pte, addr, page, prot);
+	pte_unmap_unlock(pte, ptl);
+out:
+	return retval;
+}
+
+/*
+ * vm_insert_page_mkspecial - variant of vm_insert_page, where pte is inserted
+ * with special bit set.
+ *
+ * Different from vm_insert_page(), @page in vm_insert_page_mkspecial() can
+ * either be anonymous page or file page, used for direct IO or buffer IO,
+ * respectively.
+ */
+int vm_insert_page_mkspecial(struct vm_area_struct *vma, unsigned long addr, struct page *page)
+{
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return -EFAULT;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(mmap_read_trylock(vma->vm_mm));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
+	return insert_page_mkspecial(vma, addr, page, vma->vm_page_prot);
+}
+
+#ifdef pte_index
+/*
+ * insert_pages_mkspecial() amortizes the cost of spinlock operations
+ * when inserting pages in a loop. Arch *must* define pte_index.
+ */
+static int insert_pages_mkspecial(struct vm_area_struct *vma, unsigned long addr,
+				  struct page **pages, unsigned long *num, pgprot_t prot)
+{
+	pmd_t *pmd = NULL;
+	pte_t *start_pte, *pte;
+	spinlock_t *pte_lock;
+	struct mm_struct *const mm = vma->vm_mm;
+	unsigned long curr_page_idx = 0;
+	unsigned long remaining_pages_total = *num;
+	unsigned long pages_to_write_in_pmd;
+	int ret;
+more:
+	ret = -EFAULT;
+	pmd = walk_to_pmd(mm, addr);
+	if (!pmd)
+		goto out;
+
+	pages_to_write_in_pmd = min_t(unsigned long,
+		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
+
+	/* Allocate the PTE if necessary; takes PMD lock once only. */
+	ret = -ENOMEM;
+	if (pte_alloc(mm, pmd))
+		goto out;
+
+	while (pages_to_write_in_pmd) {
+		int pte_idx = 0;
+		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
+
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
+		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
+			int err = insert_page_into_pte_locked_mkspecial(mm, pte,
+						addr, pages[curr_page_idx], prot);
+			if (unlikely(err)) {
+				pte_unmap_unlock(start_pte, pte_lock);
+				ret = err;
+				remaining_pages_total -= pte_idx;
+				goto out;
+			}
+			addr += PAGE_SIZE;
+			++curr_page_idx;
+		}
+		pte_unmap_unlock(start_pte, pte_lock);
+		pages_to_write_in_pmd -= batch_size;
+		remaining_pages_total -= batch_size;
+	}
+	if (remaining_pages_total)
+		goto more;
+	ret = 0;
+out:
+	*num = remaining_pages_total;
+	return ret;
+}
+#endif  /* pte_index */
+
+/*
+ * vm_insert_pages_mkspecial - variant of vm_insert_pages, where pte is inserted
+ * with special bit set.
+ *
+ * Different from vm_insert_pages(), @pages in vm_insert_pages_mkspecial() can
+ * either be anonymous page or file page, used for direct IO or buffer IO,
+ * respectively.
+ *
+ * The main purpose of vm_insert_pages_mkspecial is to combine the advantages of
+ * vm_insert_pages (batching the pmd lock) and remap_pfn_range_notrack (skipping
+ * track_pfn_insert).
+ */
+int vm_insert_pages_mkspecial(struct vm_area_struct *vma, unsigned long addr,
+			      struct page **pages, unsigned long *num)
+{
+#ifdef pte_index
+	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
+
+	if (addr < vma->vm_start || end_addr >= vma->vm_end)
+		return -EFAULT;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(mmap_read_trylock(vma->vm_mm));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
+	return insert_pages_mkspecial(vma, addr, pages, num, vma->vm_page_prot);
+#else
+	unsigned long idx = 0, pgcount = *num;
+	int err = -EINVAL;
+
+	for (; idx < pgcount; ++idx) {
+		err = vm_insert_page_mkspecial(vma, addr + (PAGE_SIZE * idx), pages[idx]);
+		if (err)
+			break;
+	}
+	*num = pgcount - idx;
+	return err;
+#endif	/* pte_index */
+}
+#else
+int vm_insert_page_mkspecial(struct vm_area_struct *vma, unsigned long addr, struct page *page)
+{
+	return -EINVAL;
+}
+int vm_insert_pages_mkspecial(struct vm_area_struct *vma, unsigned long addr,
+			      struct page **pages, unsigned long *num)
+{
+	return -EINVAL;
+}
+#endif	/* CONFIG_ARCH_HAS_PTE_SPECIAL */
+EXPORT_SYMBOL(vm_insert_page_mkspecial);
+EXPORT_SYMBOL(vm_insert_pages_mkspecial);
+
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
 				     pte_fn_t fn, void *data, bool create,
-- 
2.14.4.44.g2045bb6

