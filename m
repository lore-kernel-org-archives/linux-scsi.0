From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC v2] block integrity: Stabilize(?) pages during writeback
Date: Thu, 21 Apr 2011 17:02:26 -0700
Message-ID: <20110422000226.GA22189@tux1.beaverton.ibm.com>
References: <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1302742128.2586.274.camel@mingming-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 13, 2011 at 05:48:48PM -0700, Mingming Cao wrote:
> On Mon, 2011-04-11 at 20:57 -0400, Christoph Hellwig wrote:
> > On Mon, Apr 11, 2011 at 05:46:52PM -0700, Mingming Cao wrote:
> > > Oh, right. Currently ext4_page_mkwrite drops the page lock before
> > > calling it's dirty the page (by write_begin() and write_end().  I
> > > suspect regrab the lock() after write_end() (with your proposed change)
> > > and returning with locked still leave the dirty by ext4_page_mkwrite
> > > unlocked.  We probably should to keep the page locked the page during
> > > the entire ext4_page_mkwrite() call. Any reason to drop the page lock()
> > > before calling aops->write_begin()?
> > 
> > write_begin takes the page lock by itself.  That's one of the reasons why
> > block_page_mkwrite doesn't use plain ->write_begin / write_end, the
> > other beeing that we already get a page passed to use, so there's no
> > need to do the pagecache lookup or allocation done by
> > grab_cache_page_write_begin.
> > 
> > The best thing would be to completely drop ext4's current version
> > of page_mkwrite and start out with a copy of block_page_mkwrite which
> > has the journalling calls added back into it.
> 
> The problem is the locking order, we can't hold page lock then start the
> journal lock. Kjournald will need to hold the journal lock first, then
> commit, commit may need to callback writepages, which need to hold the
> page lock.
> 
> 
> I looked at ext3, in that case, ext3 even don't have ext3_page_mkwrite()
> to do the stable page yet. It requires some block reservation/delayed
> allocation for filling holes in mmaped IO case. Jan tried that before I
> don't think the proposal get far.
> 
> 
> Now looking back ext4_page_mkwrite(), it calls write_begin(), as long as
> we do wait in write_begin() things would be fine, right? It seems
> Darrick already did that wait per Dave Chinner's suggestion when grab
> the page and lock that page. But still a puzzle to me why that's not
> sufficient.

Hi everyone,

I've finally managed to get together a patch that seems to provide stable pages
during writeback, or at least gets us to the point that after several days of
running tests I don't see DIF checksum errors anymore. :)

The last two pieces to go into this puzzle were (a) bio_integrity_prep needs to
walk the process tree to find all userland ptes that map to a particular memory
page and revoke write access, and (b) ext4_page_mkwrite should always lock (and
wait on) a page before returning.  There are still some huge warts with the
patch; in particular, the x86-specific set_memory_r[ow] needs to go away, which
is what I was trying to do with the #ifdef USE_X86 case.  Also, there are
probably more wait_for_page_writeback()s than are really necessary.

Going forward, however, it might be easier to take all those waits out and
simply copy-migrate the page to another location when the page fault handler
sees the write-during-io case, so I'll look into that tomorrow.  I'm also not
particularly sure what happens when huge pages get involved.

Debug-quality patch follows, before my kernel-build disks crash again.

--D
---

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 9c5e6b2..8031bd7 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -25,6 +25,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <asm/tlbflush.h>
 
 struct integrity_slab {
 	struct kmem_cache *slab;
@@ -382,6 +383,110 @@ static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
 	return 0;
 }
 
+#define USE_X86
+
+#ifdef USE_X86
+static int set_page_ro(struct page *page)
+{
+	int set_memory_ro(unsigned long addr, int numpages);
+	unsigned long addr = (unsigned long)page_address(page);
+	if (PageHighMem(page))
+		return 0;
+	return set_memory_ro(addr, 1);
+}
+
+static int set_page_rw(struct page *page)
+{
+	int set_memory_rw(unsigned long addr, int numpages);
+	unsigned long addr = (unsigned long)page_address(page);
+	if (PageHighMem(page))
+		return 0;
+	return set_memory_rw(addr, 1);
+}
+#endif
+
+#include <linux/rmap.h>
+static void set_bio_page_access(struct mm_struct *mm, struct bio *bio, int rw)
+{
+	struct bio_vec *from;
+	int i;
+
+	__bio_for_each_segment(from, bio, i, 0) {
+		struct vm_area_struct *vma;
+		int modified = 0;
+
+		for (vma = mm->mmap; vma; vma = vma->vm_next) {
+			unsigned long address;
+			pte_t *pte;
+			spinlock_t *ptl;
+
+			// grab pte, change to ro?
+			address = page_address_in_vma(from->bv_page, vma);
+			if (address == -EFAULT)		/* out of vma range */
+				continue;
+			pte = page_check_address(from->bv_page, vma->vm_mm, address, &ptl, 1);
+			if (!pte)			/* the page is not in this mm */
+				continue;
+			modified = 1;
+			if (rw) {
+				pte_t old_pte = *pte;
+				set_pte_at(mm, address, pte, pte_mkwrite(old_pte));
+			} else
+				ptep_set_wrprotect(mm, address, pte);
+			pte_unmap_unlock(pte, ptl);
+		}
+		if (modified)
+			flush_tlb_mm(mm);
+	}
+}
+
+static void set_bio_page_rw(struct mm_struct *mm, struct bio *bio)
+{
+	set_bio_page_access(mm, bio, 1);
+}
+
+static void set_bio_page_ro(struct mm_struct *mm, struct bio *bio)
+{
+	set_bio_page_access(mm, bio, 0);
+}
+
+#ifdef USE_X86
+static void bio_integrity_write_fn(struct work_struct *work)
+{
+	struct bio_integrity_payload *bip =
+		container_of(work, struct bio_integrity_payload, bip_work);
+	struct bio *bio = bip->bip_bio;
+	struct bio_vec *from;
+	int i;
+
+	__bio_for_each_segment(from, bio, i, 0) {
+		set_page_rw(from->bv_page);
+	}
+
+	/* Restore original bio completion handler */
+	bio->bi_end_io = bip->bip_end_io;
+	bio_endio(bio, bip->bip_error);
+}
+#endif
+
+static void bio_integrity_endio_write(struct bio *bio, int error)
+{
+	struct bio_integrity_payload *bip = bio->bi_integrity;
+
+	BUG_ON(bip->bip_bio != bio);
+
+#ifndef USE_X86
+	set_bio_page_rw(&init_mm, bio);
+	bio->bi_end_io = bip->bip_end_io;
+	bio_endio(bio, bip->bip_error);
+	return;
+#else
+	bip->bip_error = error;
+	INIT_WORK(&bip->bip_work, bio_integrity_write_fn);
+	queue_work(kintegrityd_wq, &bip->bip_work);
+#endif
+}
+
 /**
  * bio_integrity_prep - Prepare bio for integrity I/O
  * @bio:	bio to prepare
@@ -468,8 +573,42 @@ int bio_integrity_prep(struct bio *bio)
 	}
 
 	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE)
+	if (bio_data_dir(bio) == WRITE) {
+		struct task_struct *p;
+		struct mm_struct *mm;
+
+		bip->bip_end_io = bio->bi_end_io;
+		bio->bi_end_io = bio_integrity_endio_write;
+
+#ifndef USE_X86
+//		kmap_flush_unused();
+//		vm_unmap_aliases();
+		set_bio_page_ro(&init_mm, bio);
+		flush_tlb_all();
+#else
+		{
+		struct bio_vec *from;
+		int i;
+	 
+		__bio_for_each_segment(from, bio, i, 0) {
+			set_page_ro(from->bv_page);
+		}
+		}
+#endif
+
+		for_each_process(p) {
+			task_lock(p);
+			mm = p->mm;
+			if (!mm) {
+				task_unlock(p);
+				continue;
+			}
+
+			set_bio_page_ro(mm, bio);
+			task_unlock(p);
+		}
 		bio_integrity_generate(bio);
+	}
 
 	return 0;
 }
diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..02156c5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -376,8 +376,10 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 		if (!quiet_error(bh)) {
 			buffer_io_error(bh);
 			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-			       bdevname(bh->b_bdev, b));
+					"I/O error on %s, flags=%lx\n",
+			       bdevname(bh->b_bdev, b), page->flags);
+if (page->mapping && page->mapping->host)
+printk(KERN_ERR "mode=%x inode=%d dev=%d\n", page->mapping->host->i_mode, page->mapping->host->i_ino, (page->mapping->host->i_rdev));
 		}
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
@@ -2357,6 +2359,8 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	else
 		end = PAGE_CACHE_SIZE;
 
+	WARN_ON(!PageLocked(page));
+	wait_on_page_writeback(page);
 	ret = __block_write_begin(page, 0, end, get_block);
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..228b4aa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2667,6 +2667,8 @@ static int ext4_writepage(struct page *page,
 		 */
 		goto redirty_page;
 	}
+	WARN_ON(!PageLocked(page));
+	wait_on_page_writeback(page);
 	if (commit_write)
 		/* now mark the buffer_heads as dirty and uptodate */
 		block_commit_write(page, 0, len);
@@ -2779,7 +2781,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 			}
 
 			lock_page(page);
-
+			if (PageWriteback(page))
+				wait_on_page_writeback(page);
 			/*
 			 * If the page is no longer dirty, or its
 			 * mapping no longer corresponds to inode we
@@ -5811,15 +5814,21 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out_unlock;
 	}
 	ret = 0;
-	if (PageMappedToDisk(page))
-		goto out_unlock;
+	lock_page(page);
+	if (PageWriteback(page))
+		wait_on_page_writeback(page);
+	if (PageMappedToDisk(page)) {
+		up_read(&inode->i_alloc_sem);
+		return VM_FAULT_LOCKED;
+	}
 
+	/* this one seems to handle mmap */
+	wait_on_page_writeback(page);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
 
-	lock_page(page);
 	/*
 	 * return if we have all the buffers mapped. This avoid
 	 * the need to call write_begin/write_end which does a
@@ -5829,8 +5838,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
-			unlock_page(page);
-			goto out_unlock;
+			up_read(&inode->i_alloc_sem);
+			return VM_FAULT_LOCKED;
 		}
 	}
 	unlock_page(page);
@@ -5850,6 +5859,17 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (ret < 0)
 		goto out_unlock;
 	ret = 0;
+
+	/*
+	 * write_begin/end might have created a dirty page and someone
+	 * could wander in and start the IO.  Make sure that hasn't
+	 * happened.
+	 */
+	lock_page(page);
+	if (PageWriteback(page))
+		wait_on_page_writeback(page);
+	up_read(&inode->i_alloc_sem);
+	return VM_FAULT_LOCKED;
 out_unlock:
 	if (ret)
 		ret = VM_FAULT_SIGBUS;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ce33e68..ea36e89 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -180,6 +180,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_idx;	/* current bip_vec index */
 
+	int			bip_error;	/* bio completion status? */
 	struct work_struct	bip_work;	/* I/O completion */
 	struct bio_vec		bip_vec[0];	/* embedded bvec array */
 };
diff --git a/mm/filemap.c b/mm/filemap.c
index c641edf..3ed13a3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2277,8 +2277,9 @@ EXPORT_SYMBOL(generic_file_direct_write);
  * Find or create a page at the given pagecache position. Return the locked
  * page. This function is specifically for buffered writes.
  */
-struct page *grab_cache_page_write_begin(struct address_space *mapping,
-					pgoff_t index, unsigned flags)
+static struct page *
+__grab_cache_page_write_begin(struct address_space *mapping, pgoff_t index,
+			      unsigned flags)
 {
 	int status;
 	struct page *page;
@@ -2303,6 +2304,20 @@ repeat:
 	}
 	return page;
 }
+
+struct page *grab_cache_page_write_begin(struct address_space *mapping,
+					pgoff_t index, unsigned flags)
+{
+	struct page *p;
+
+	p = __grab_cache_page_write_begin(mapping, index, flags);
+	if (p) {
+		WARN_ON(!PageLocked(p));
+		wait_on_page_writeback(p);
+	}
+
+	return p;
+}
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
 static ssize_t generic_perform_write(struct file *file,
diff --git a/mm/memory.c b/mm/memory.c
index ce22a25..9d3dc5d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3156,6 +3156,9 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 				} else
 					VM_BUG_ON(!PageLocked(page));
 				page_mkwrite = 1;
+			} else {
+				WARN_ON(!PageLocked(page));
+				wait_on_page_writeback(page);
 			}
 		}
 
