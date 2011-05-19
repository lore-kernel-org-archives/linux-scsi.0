From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCHSET v3.2 0/3] data integrity: Stabilize pages during writeback
	for various fses
Date: Thu, 19 May 2011 15:48:41 -0700
Message-ID: <20110519224841.28755.80650.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is v3.2 of the stable-page-writes patchset for ext4 and xfs.  The purpose
of this patchset is to prohibit processes from writing on memory pages that are
currently being written to disk because certain storage setups (e.g. SCSI disks
with DIF integrity checksums) will fail a write if the page contents don't
match the checksum.  btrfs already guarantees page stability, so it does not
use these changes.

The technique used is fairly simple -- whenever a page is about to become
writable (either because of a write fault to a mapped page, or a buffered write
is in progress), wait for the page writeback flag to be clear, indicating that
the page is not being written to disk.  This means that it is necessary (1) to
add wait for writeback code to grab_cache_page_write_begin to take care of
buffered writes, and (2) all filesystems must have a page_mkwrite that locks a
page, waits for writeback, and returns the locked page.  For filesystems that
piggyback on the generic block_page_mkwrite, the patchset adds the writeback
wait to that function; for filesystems that do not use the page_mkwrite hook at
all, the patchset provides a stub page_mkwrite.

I ran my write-after-checksum ("wac") reproducer program to try to create the
DIF checksum errors by madly rewriting the same memory pages.  In fact, I tried
the following combinations against ext4, xfs, and btrfs:

a. 64 write() threads + sync_file_range
b. 64 mmap write threads + msync
c. 32 write() threads + sync_file_range + 32 mmap write threads + msync
d. Same as C, but with all threads in directio mode
e. Same as A, but with all threads in directio mode
f. Same as B, but with all threads in directio mode

After running profiles A-F for 30 minutes each on 6 different machines, ext4
and xfs report no errors.   btrfs eventually reports -ENOSPC and fails the
test, though it does that even without any of the patches applied.

To assess the performance impact of stable page writes, I moved to a disk that
doesn't have DIF support so that I could measure just the impact of waiting for
writeback.  I first ran wac with 64 threads madly scribbling on a 64k file and
saw about a 12 percent performance decrease.  I then reran the wac program with
64 threads and a 64MB file and saw about the same performance numbers.  As I
suspected, the patchset only seems to impact workloads that rewrite the same
memory page frequently.

Per various comments regarding v3 of this patchset, I've integrated his
suggestions, reworked the patch descriptions to make it clearer which ones
touch all the filesystems and which ones are to fix remaining holes in specific
filesystems, and expanded the scope of filesystems that got fixed.

As always, questions and comments are welcome; and thank you to all the
previous reviewers of this patchset.  I am also soliciting people's opinions on
whether or not these patches could go upstream for .40.

This latest iteration of the patchset focuses solely on the generic changes
necessary to provide stable pages.  It is being sent to Al Viro (just like v3.1
was).

--D
