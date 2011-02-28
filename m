From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Mon, 28 Feb 2011 07:54:05 -0500
Message-ID: <1298897186-sup-9394@think>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com> <yq1vd0cf26f.fsf@sermon.lab.mkp.net> <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20110224182732.GV27190@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Excerpts from Darrick J. Wong's message of 2011-02-24 13:27:32 -0500:
> On Thu, Feb 24, 2011 at 12:37:53PM -0500, Chris Mason wrote:
> > Excerpts from Jan Kara's message of 2011-02-24 11:47:58 -0500:
> > > On Wed 23-02-11 15:35:11, Chris Mason wrote:
> > > > Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > > > > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > > > > Also, DIX is only the tip of the iceberg. Many other impending
> > > > > > technologies feature checksums and require pages to be stable during I/O
> > > > > > due to checksumming, encryption and so on.
> > > > > > 
> > > > > > The VM is already trying to do the right thing. We just need the
> > > > > > relevant filesystems to catch up.
> > > > > 
> > > > >     ocfs2 handles stable metadata for its checksums when feeding
> > > > > things to the journal.  If we're doing pagecache-based I/O, is the
> > > > > pagecache going to help here for data?
> > > > 
> > > > Data is much easier than metadata.  All you really need is to wait on
> > > > writeback in file_write, wait on writeback in page_mkwrite, and make
> > > > sure you don't free blocks back to the allocator that are actively under
> > > > IO.
> > > > 
> > > > I expect the hard part to be jbd and metadata in ext34.
> > >   But JBD already has to do data copy if a buffer is going to be modified
> > > before/while it is written to the journal. So we should alredy do all that
> > > is needed for metadata. I don't say there aren't any bugs as they could be
> > > triggered only by crashing at the wrong moment and observing fs corruption.
> > > But most of the work should be there...
> > 
> > Most of it is there, but there are always little bits and pieces.  The
> > ext4 journal csumming code was one semi-recent example where we found
> > metadata changing in flight.
> > 
> > A big part of testing this is getting some way to detect the bugs
> > without dif/dix.  With btrfs I have patches to do set_memory_ro on
> > pages once I've don the crc, hopefully we can generalize that idea or
> > some up with something smarter.
> 
> Right now I'm faking it with modprobe scsi_debug ato=1 guard=1 dif=3 dix=199.
> 
> Hm, would you mind sharing those patches?  I've been working on a second patch
> to do the wait-on-writeback per everyone's suggestions, but I still see the
> occasional corruption error as soon as I enable the mmap write case and covet
> some more debugging tools.  It does seem to be working for the pure pwrite()
> case. :)

Here's an ext4 version of the debugging patch.  It's a few years old but
it'll give you the idea.  This only covers metadata pages.

Looks like I hacked the btrfs version up and didn't keep the original,
I'll have to rework it, I was trying to use it for the big corruption I
fixed recently and made a bunch of changes.

For data if mmap is giving you trouble you need to wait on writeback in
page_mkwrite, with the page locked.  fs/btrfs/inode.c has our
page_mkwrite, which uses wait_on_page_writeback() and also the btrfs
ordered write code.  But for the other filesystems, waiting on writeback
should be enough.

-chris

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index d4cfd6d..9f278db 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -28,6 +28,16 @@
 #include <linux/blkdev.h>
 #include <trace/events/jbd2.h>
 
+int set_memory_ro(unsigned long addr, int numpages);
+
+static int set_page_ro(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	if (PageHighMem(page))
+		return 0;
+	return set_memory_ro(addr, 1);
+}
+
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
  */
@@ -639,6 +654,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		set_bit(BH_JWrite, &jh2bh(new_jh)->b_state);
 		wbuf[bufs++] = jh2bh(new_jh);
 
+		set_page_ro(jh2bh(new_jh)->b_page);
+
 		/* Record the new block's tag in the current descriptor
                    buffer */
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a051270..153888e 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -28,6 +28,15 @@
 #include <linux/hrtimer.h>
 
 static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh);
+int set_memory_rw(unsigned long addr, int numpages);
+static int set_page_rw(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	if (PageHighMem(page))
+		return 0;
+	return set_memory_rw(addr, 1);
+}
+
 
 /*
  * jbd2_get_transaction: obtain a new transaction_t object.
@@ -1474,9 +1487,11 @@ void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 		break;
 	case BJ_IO:
 		list = &transaction->t_iobuf_list;
+		set_page_rw(bh->b_page);
 		break;
 	case BJ_Shadow:
 		list = &transaction->t_shadow_list;
+		set_page_rw(bh->b_page);
 		break;
 	case BJ_LogCtl:
 		list = &transaction->t_log_list;
