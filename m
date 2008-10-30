From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 4/9] osdfs: address_space_operations
Date: Thu, 30 Oct 2008 16:33:25 +0200
Message-ID: <1225377205-25316-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:52168 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbYJ3PL3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:11:29 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

OK Now we start to read and write from osd-objects, page-by-page.
The page index is the object's offset.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/osdfs/inode.c |  284 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/osdfs/osdfs.h |    3 +
 2 files changed, 287 insertions(+), 0 deletions(-)

diff --git a/fs/osdfs/inode.c b/fs/osdfs/inode.c
index e009eb0..bfd82b1 100644
--- a/fs/osdfs/inode.c
+++ b/fs/osdfs/inode.c
@@ -60,6 +60,290 @@ int osdfs_get_block(struct inode *inode, sector_t iblock,
 	return 0;
 }
 
+/*
+ * Callback function when writepage finishes.  Check for errors, unlock, clean
+ * up, etc.
+ */
+void writepage_done(struct osd_request *req, void *p)
+{
+	int ret;
+	struct page *page = (struct page *)p;
+	struct inode *inode = page->mapping->host;
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+
+	ret = check_ok(req);
+	free_osd_req(req);
+	atomic_dec(&sbi->s_curr_pending);
+
+	if (ret) {
+		if (ret == -ENOSPC)
+			set_bit(AS_ENOSPC, &page->mapping->flags);
+		else
+			set_bit(AS_EIO, &page->mapping->flags);
+
+		SetPageError(page);
+	}
+
+	end_page_writeback(page);
+	unlock_page(page);
+}
+
+/*
+ * Write a page to disk.  page->index gives us the page number.  The page is
+ * locked before this function is called.  We write asynchronously and then the
+ * callback function (writepage_done) is called.  We signify that the operation
+ * has completed by unlocking the page and calling end_page_writeback().
+ */
+static int osdfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	loff_t i_size = i_size_read(inode);
+	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
+	unsigned offset = 0;
+	struct osd_request *req = NULL;
+	struct osdfs_sb_info *sbi;
+	uint64_t start;
+	uint64_t len = PAGE_CACHE_SIZE;
+	unsigned char *kaddr;
+	int ret = 0;
+
+	if (!PageLocked(page))
+		BUG();
+
+	/* if the object has not been created, and we are not in sync mode,
+	 * just return.  otherwise, wait. */
+	if (!ObjCreated(oi)) {
+		if (!Obj2BCreated(oi))
+			BUG();
+
+		if (wbc->sync_mode == WB_SYNC_NONE) {
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			ret = 0;
+			goto out;
+		} else {
+			wait_event(oi->i_wq, ObjCreated(oi));
+		}
+	}
+
+	/* in this case, the page is within the limits of the file */
+	if (page->index < end_index)
+		goto do_it;
+
+	offset = i_size & (PAGE_CACHE_SIZE - 1);
+	len = offset;
+
+	/*in this case, the page is outside the limits (truncate in progress)*/
+	if (page->index >= end_index + 1 || !offset) {
+		unlock_page(page);
+		goto out;
+	}
+
+	/* otherwise, the page straddles i_size.  It must be zeroed out. */
+	kaddr = kmap_atomic(page, KM_USER0);
+	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
+	flush_dcache_page(page);
+	kunmap_atomic(page, KM_USER0);
+
+do_it:
+	BUG_ON(PageWriteback(page));
+	set_page_writeback(page);
+	start = page->index << PAGE_CACHE_SHIFT;
+	sbi = inode->i_sb->s_fs_info;
+
+	kaddr = page_address(page);
+
+	req = prepare_osd_write(sbi->s_dev, sbi->s_pid,
+			      inode->i_ino + OSDFS_OBJ_OFF, len, start, 0,
+			      kaddr);
+	if (!req) {
+		printk(KERN_ERR "ERROR: writepage failed.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	ret = osdfs_async_op(req, writepage_done, (void *)page, oi->i_cred);
+	if (ret) {
+		free_osd_req(req);
+		goto fail;
+	}
+	atomic_inc(&sbi->s_curr_pending);
+out:
+	return ret;
+fail:
+	set_bit(AS_EIO, &page->mapping->flags);
+	end_page_writeback(page);
+	unlock_page(page);
+	goto out;
+}
+
+/*
+ * Callback for readpage
+ */
+void readpage_done(struct osd_request *req, void *p)
+{
+	struct page *page = (struct page *)p;
+	struct inode *inode = page->mapping->host;
+	struct osdfs_sb_info *sbi = inode->i_sb->s_fs_info;
+	char *kaddr;
+	int ret;
+
+	ret = check_ok(req);
+	free_osd_req(req);
+	atomic_dec(&sbi->s_curr_pending);
+
+	if (ret == -EFAULT) {
+
+		/* In this case we were trying to read something that wasn't on
+		 * disk yet - return a page full of zeroes.  This should be OK,
+		 * because the object should be empty (if there was a write
+		 * before this read, the read would be waiting with the page
+		 * locked */
+		kaddr = page_address(page);
+		memset(kaddr, 0, PAGE_CACHE_SIZE);
+
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+	} else if (ret == 0) {
+
+		/* Everything is OK */
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+	} else {
+
+		/* Error */
+		SetPageError(page);
+	}
+
+	unlock_page(page);
+}
+
+/*
+ * Read a page from the OSD
+ */
+static int readpage_filler(struct page *page)
+{
+	struct osd_request *req = NULL;
+	struct inode *inode = page->mapping->host;
+	struct osdfs_i_info *oi = OSDFS_I(inode);
+	ino_t ino = inode->i_ino;
+	loff_t i_size = i_size_read(inode);
+	unsigned long end_index = i_size >> PAGE_CACHE_SHIFT;
+	struct super_block *sb = inode->i_sb;
+	struct osdfs_sb_info *sbi = sb->s_fs_info;
+	uint64_t amount;
+	unsigned char *kaddr;
+	int ret = 0;
+
+	if (!PageLocked(page))
+		BUG();
+
+	if (PageUptodate(page))
+		goto out;
+
+	/* we are before the last page */
+	if (page->index < end_index) {
+		amount = PAGE_CACHE_SIZE;
+		goto do_it;
+	}
+
+	amount = i_size & (PAGE_CACHE_SIZE - 1);
+
+	/* this will be out of bounds, or doesn't exist yet */
+	if ((page->index >= end_index + 1 || !amount) || (!ObjCreated(oi))) {
+		kaddr = kmap_atomic(page, KM_USER0);
+		memset(kaddr, 0, PAGE_CACHE_SIZE);
+		flush_dcache_page(page);
+		kunmap_atomic(page, KM_USER0);
+		SetPageUptodate(page);
+		if (PageError(page))
+			ClearPageError(page);
+		unlock_page(page);
+		goto out;
+	}
+
+do_it:
+	kaddr = page_address(page);
+
+	req = prepare_osd_read(sbi->s_dev, sbi->s_pid, ino + OSDFS_OBJ_OFF,
+			amount, (uint64_t)(page->index << PAGE_CACHE_SHIFT), 0,
+			kaddr);
+	if (!req) {
+		printk(KERN_ERR "ERROR: readpage failed.\n");
+		ret = -ENOMEM;
+		unlock_page(page);
+		goto out;
+	}
+
+	ret = osdfs_async_op(req, readpage_done, (void *)page, oi->i_cred);
+	if (ret) {
+		free_osd_req(req);
+		unlock_page(page);
+		goto out;
+	}
+	atomic_inc(&sbi->s_curr_pending);
+out:
+	return ret;
+}
+
+/*
+ * We don't need the file
+ */
+static int osdfs_readpage(struct file *file, struct page *page)
+{
+	return readpage_filler(page);
+}
+
+/*
+ * We don't need the data
+ */
+static int readpage_strip(void *data, struct page *page)
+{
+	return readpage_filler(page);
+}
+
+/*
+ * read a bunch of pages - usually for readahead
+ */
+static int osdfs_readpages(struct file *file, struct address_space *mapping,
+			   struct list_head *pages, unsigned nr_pages)
+{
+	return read_cache_pages(mapping, pages, readpage_strip, NULL);
+}
+
+/* This was borrowed from fs/libfs.c it used to be exported but now it
+ * is not. FIXME: Is this at all right?
+ */
+static int osdfs_simple_commit_write(struct file *file, struct page *page,
+			       unsigned from, unsigned to)
+{
+	struct inode *inode = page->mapping->host;
+	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold the i_mutex.
+	 */
+	if (pos > inode->i_size)
+		i_size_write(inode, pos);
+	set_page_dirty(page);
+	return 0;
+}
+
+struct address_space_operations osdfs_aops = {
+	.readpage		= osdfs_readpage,
+	.readpages		= osdfs_readpages,
+	.writepage		= osdfs_writepage,
+	.prepare_write		= simple_prepare_write,
+	.commit_write		= osdfs_simple_commit_write,
+	.writepages		= generic_writepages,
+};
+
 /******************************************************************************
  * INODE OPERATIONS
  *****************************************************************************/
diff --git a/fs/osdfs/osdfs.h b/fs/osdfs/osdfs.h
index 7610ce3..29e7d7b 100644
--- a/fs/osdfs/osdfs.h
+++ b/fs/osdfs/osdfs.h
@@ -188,6 +188,9 @@ int osdfs_setattr(struct dentry *, struct iattr *);
 extern struct inode_operations osdfs_file_inode_operations;
 extern struct file_operations osdfs_file_operations;
 
+/* inode.c           */
+extern struct address_space_operations osdfs_aops;
+
 /* symlink.c         */
 extern struct inode_operations osdfs_symlink_inode_operations;
 extern struct inode_operations osdfs_fast_symlink_inode_operations;
-- 
1.6.0.1

