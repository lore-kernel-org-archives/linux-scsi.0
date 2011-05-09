From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 5/7] ext4: Wait for writeback to complete while making pages
	writable
Date: Mon, 09 May 2011 16:03:56 -0700
Message-ID: <20110509230356.19566.48351.stgit@elm3c44.beaverton.ibm.com>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

In order to stabilize pages during disk writes, ext4_page_mkwrite must wait for
writeback operations to complete before making a page writable.  Furthermore,
the function must return locked pages, and recheck the writeback status if the
page lock is ever dropped.  The "someone could wander in" part of this patch
was suggested by Chris Mason.

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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
