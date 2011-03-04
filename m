From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Fri, 4 Mar 2011 13:07:24 -0800
Message-ID: <20110304210724.GF27190@tux1.beaverton.ibm.com>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <yq1vd0cf26f.fsf@sermon.lab.mkp.net> <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1298897186-sup-9394@think>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 28, 2011 at 07:54:05AM -0500, Chris Mason wrote:
> Excerpts from Darrick J. Wong's message of 2011-02-24 13:27:32 -0500:
> > On Thu, Feb 24, 2011 at 12:37:53PM -0500, Chris Mason wrote:
> > > Excerpts from Jan Kara's message of 2011-02-24 11:47:58 -0500:
> > > > On Wed 23-02-11 15:35:11, Chris Mason wrote:
> > > > > Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > > > > > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > > > > > Also, DIX is only the tip of the iceberg. Many other impending
> > > > > > > technologies feature checksums and require pages to be stable during I/O
> > > > > > > due to checksumming, encryption and so on.
> > > > > > > 
> > > > > > > The VM is already trying to do the right thing. We just need the
> > > > > > > relevant filesystems to catch up.
> > > > > > 
> > > > > >     ocfs2 handles stable metadata for its checksums when feeding
> > > > > > things to the journal.  If we're doing pagecache-based I/O, is the
> > > > > > pagecache going to help here for data?
> > > > > 
> > > > > Data is much easier than metadata.  All you really need is to wait on
> > > > > writeback in file_write, wait on writeback in page_mkwrite, and make
> > > > > sure you don't free blocks back to the allocator that are actively under
> > > > > IO.
> > > > > 
> > > > > I expect the hard part to be jbd and metadata in ext34.
> > > >   But JBD already has to do data copy if a buffer is going to be modified
> > > > before/while it is written to the journal. So we should alredy do all that
> > > > is needed for metadata. I don't say there aren't any bugs as they could be
> > > > triggered only by crashing at the wrong moment and observing fs corruption.
> > > > But most of the work should be there...
> > > 
> > > Most of it is there, but there are always little bits and pieces.  The
> > > ext4 journal csumming code was one semi-recent example where we found
> > > metadata changing in flight.
> > > 
> > > A big part of testing this is getting some way to detect the bugs
> > > without dif/dix.  With btrfs I have patches to do set_memory_ro on
> > > pages once I've don the crc, hopefully we can generalize that idea or
> > > some up with something smarter.
> > 
> > Right now I'm faking it with modprobe scsi_debug ato=1 guard=1 dif=3 dix=199.
> > 
> > Hm, would you mind sharing those patches?  I've been working on a second patch
> > to do the wait-on-writeback per everyone's suggestions, but I still see the
> > occasional corruption error as soon as I enable the mmap write case and covet
> > some more debugging tools.  It does seem to be working for the pure pwrite()
> > case. :)
> 
> Here's an ext4 version of the debugging patch.  It's a few years old but
> it'll give you the idea.  This only covers metadata pages.
> 
> Looks like I hacked the btrfs version up and didn't keep the original,
> I'll have to rework it, I was trying to use it for the big corruption I
> fixed recently and made a bunch of changes.
> 
> For data if mmap is giving you trouble you need to wait on writeback in
> page_mkwrite, with the page locked.  fs/btrfs/inode.c has our
> page_mkwrite, which uses wait_on_page_writeback() and also the btrfs
> ordered write code.  But for the other filesystems, waiting on writeback
> should be enough.

Ok, here's what I have so far.  I took everyone's suggestions of where to add
calls to wait_on_page_writeback, which seems to handle the multiple-write case
adequately.  Unfortunately, it is still possible to generate checksum errors by
scribbling furiously on a mmap'd region, even after adding the writeback wait
in the ext4 writepage function.  Oddly, I couldn't break btrfs with mmap by
removing its wait_for_page_writeback call, so I suspect there's a bit more
going on in btrfs than I've been able to figure out.

The set_memory_ro debugging trick didn't ferret out any write paths that I
didn't catch... though it did have the effect of causing occasional fsync()
deadlocks.  I suppose I could sprinkle in a few more of those write calls to
see what happens.

Either way, I'm emailing to ask everyone's advice since I've run out of ideas.
Or: Did I miss something?

Thanks all for the feedback so far!

--
fs: Wait for page writeback when rewrite detected

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/buffer.c     |    4 +++-
 fs/ext4/inode.c |    3 +++
 mm/filemap.c    |   15 +++++++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2219a76..39e934c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2379,8 +2379,10 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			ret = VM_FAULT_OOM;
 		else /* -ENOSPC, -EIO, etc */
 			ret = VM_FAULT_SIGBUS;
-	} else
+	} else {
+		wait_on_page_writeback(page);
 		ret = VM_FAULT_LOCKED;
+	}
 
 out:
 	return ret;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..2364704 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2730,12 +2730,15 @@ static int ext4_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	trace_ext4_writepage(inode, page);
+lock_page(page);
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
 
+wait_on_page_writeback(page);
+
 	/*
 	 * If the page does not have buffers (for whatever reason),
 	 * try to create them using __block_write_begin.  If this
diff --git a/mm/filemap.c b/mm/filemap.c
index 83a45d3..f201d80 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2217,8 +2217,8 @@ EXPORT_SYMBOL(generic_file_direct_write);
  * Find or create a page at the given pagecache position. Return the locked
  * page. This function is specifically for buffered writes.
  */
-struct page *grab_cache_page_write_begin(struct address_space *mapping,
-					pgoff_t index, unsigned flags)
+struct page *__grab_cache_page_write_begin(struct address_space *mapping,
+					   pgoff_t index, unsigned flags)
 {
 	int status;
 	struct page *page;
@@ -2243,6 +2243,17 @@ repeat:
 	}
 	return page;
 }
+struct page *grab_cache_page_write_begin(struct address_space *mapping,
+					pgoff_t index, unsigned flags)
+{
+	struct page *p;
+
+	p = __grab_cache_page_write_begin(mapping, index, flags);
+	if (p)
+		wait_on_page_writeback(p);
+
+	return p;
+}
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
 static ssize_t generic_perform_write(struct file *file,
