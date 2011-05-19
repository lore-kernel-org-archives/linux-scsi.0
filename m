From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/3] fs: block_page_mkwrite should wait for writeback to finish
Date: Thu, 19 May 2011 15:48:55 -0700
Message-ID: <20110519224855.28755.2720.stgit@elm3c44.beaverton.ibm.com>
References: <20110519224841.28755.80650.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20110519224841.28755.80650.stgit@elm3c44.beaverton.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
function to wait for pending writeback before allowing the page to become
writable.  This is needed to stabilize pages during writeback for those two
filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/buffer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/fs/buffer.c b/fs/buffer.c
index a08bb8e..0e7fa16 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2367,8 +2367,10 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
