From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v3 2/3] ext4: Wait for writeback to complete while making
	pages writable
Date: Wed, 4 May 2011 10:41:36 -0700
Message-ID: <20110504174136.GG20579@tux1.beaverton.ibm.com>
References: <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110422000226.GA22189@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In order to stabilize pages during disk writes, ext4_page_mkwrite must wait for
writeback operations to complete before making a page writable.  Furthermore,
the function must return locked pages, and recheck the writeback status if the
page lock is ever dropped.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/inode.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3db34b2..1d162a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5809,15 +5809,19 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out_unlock;
 	}
 	ret = 0;
-	if (PageMappedToDisk(page))
-		goto out_unlock;
+
+	lock_page(page);
+	wait_on_page_writeback(page);
+	if (PageMappedToDisk(page)) {
+		up_read(&inode->i_alloc_sem);
+		return VM_FAULT_LOCKED;
+	}
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
 
-	lock_page(page);
 	/*
 	 * return if we have all the buffers mapped. This avoid
 	 * the need to call write_begin/write_end which does a
@@ -5827,8 +5831,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -5848,6 +5852,16 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
+	wait_on_page_writeback(page);
+	up_read(&inode->i_alloc_sem);
+	return VM_FAULT_LOCKED;
 out_unlock:
 	if (ret)
 		ret = VM_FAULT_SIGBUS;
