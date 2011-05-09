From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/7] mm: Provide stub page_mkwrite functionality to stabilize
	pages during writes
Date: Mon, 09 May 2011 16:03:41 -0700
Message-ID: <20110509230341.19566.3876.stgit@elm3c44.beaverton.ibm.com>
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

For filesystems that do not provide any page_mkwrite handler, provide a stub
page_mkwrite function that locks the page and waits for pending writeback to
complete.  This is needed to stabilize pages during writes for a large variety
of filesystem drivers (ext2, ext3, vfat, hfs...).

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 mm/filemap.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)


diff --git a/mm/filemap.c b/mm/filemap.c
index fd0e7f2..1e096a0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1713,8 +1713,27 @@ page_not_uptodate:
 }
 EXPORT_SYMBOL(filemap_fault);
 
+static int empty_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	loff_t size;
+
+	lock_page(page);
+	size = i_size_read(inode);
+	if ((page->mapping != inode->i_mapping) ||
+	    (page_offset(page) > size)) {
+		/* page got truncated out from underneath us */
+		unlock_page(page);
+		return VM_FAULT_NOPAGE;
+	}
+	wait_on_page_writeback(page);
+	return VM_FAULT_LOCKED;
+}
+
 const struct vm_operations_struct generic_file_vm_ops = {
 	.fault		= filemap_fault,
+	.page_mkwrite	= empty_page_mkwrite,
 };
 
 /* This is used for a general mmap of a disk file */

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
