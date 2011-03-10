From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Thu, 10 Mar 2011 15:57:22 -0800
Message-ID: <20110310235722.GA1110@tux1.beaverton.ibm.com>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <yq1vd0cf26f.fsf@sermon.lab.mkp.net> <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com> <20110308045626.GD1956@dastard>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110308045626.GD1956@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 08, 2011 at 03:56:26PM +1100, Dave Chinner wrote:

> On Fri, Mar 04, 2011 at 01:07:24PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 28, 2011 at 07:54:05AM -0500, Chris Mason wrote:
> > > Excerpts from Darrick J. Wong's message of 2011-02-24 13:27:32 -0500:
> > > > On Thu, Feb 24, 2011 at 12:37:53PM -0500, Chris Mason wrote:
> > > > > Excerpts from Jan Kara's message of 2011-02-24 11:47:58 -0500:
> > > > > > On Wed 23-02-11 15:35:11, Chris Mason wrote:
> > > > > > > Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > > > > > > > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > > > > > > > Also, DIX is only the tip of the iceberg. Many other impending
> > > > > > > > > technologies feature checksums and require pages to be stable during I/O
> > > > > > > > > due to checksumming, encryption and so on.
> > > > > > > > > 
> > > > > > > > > The VM is already trying to do the right thing. We just need the
> > > > > > > > > relevant filesystems to catch up.
> > > > > > > > 
> > > > > > > >     ocfs2 handles stable metadata for its checksums when feeding
> > > > > > > > things to the journal.  If we're doing pagecache-based I/O, is the
> > > > > > > > pagecache going to help here for data?
> > > > > > > 
> > > > > > > Data is much easier than metadata.  All you really need is to wait on
> > > > > > > writeback in file_write, wait on writeback in page_mkwrite, and make

Hrm... I've been looking for a file_write in ext4; was the aio_write function
pointer what you had in mind here?

Adding a wait_on_page_writeback to ext4_page_mkwrite eliminated most of the DIF
checksum errors in the mmap case.  Unfortunately, I still see them, usually
within the first few seconds of kicking off the not-first run.  I suspect that
may be related to the test program truncating the file after each run causing
blocks to come and go, so I'll investigate that part of ext4 next.

I also noticed that testing the directio+mmap case exhibits the same symptoms.

Anyhow, just attaching the latest hack of mine in case anyone wants to have a
look.
--
fs: Wait for page writeback when rewrite detected
---

 fs/buffer.c     |    2 ++
 fs/ext4/inode.c |    6 +++++-
 mm/filemap.c    |   19 +++++++++++++++++--
 mm/memory.c     |    3 +++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2219a76..f3639f2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2369,6 +2369,8 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	else
 		end = PAGE_CACHE_SIZE;
 
+	WARN_ON(!PageLocked(page));
+	wait_on_page_writeback(page);
 	ret = __block_write_begin(page, 0, end, get_block);
 	if (!ret)
 		ret = block_commit_write(page, 0, end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..ba45b31 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2762,6 +2762,8 @@ static int ext4_writepage(struct page *page,
 		 */
 		goto redirty_page;
 	}
+	WARN_ON(!PageLocked(page));
+	wait_on_page_writeback(page);
 	if (commit_write)
 		/* now mark the buffer_heads as dirty and uptodate */
 		block_commit_write(page, 0, len);
@@ -5865,12 +5867,14 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (PageMappedToDisk(page))
 		goto out_unlock;
 
+	lock_page(page);
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
diff --git a/mm/filemap.c b/mm/filemap.c
index 83a45d3..61af700 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2217,8 +2217,9 @@ EXPORT_SYMBOL(generic_file_direct_write);
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
@@ -2243,6 +2244,20 @@ repeat:
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
