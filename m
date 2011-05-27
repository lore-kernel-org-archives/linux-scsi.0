From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] fs: block_page_mkwrite should wait for writeback to finish
Date: Fri, 27 May 2011 12:23:41 -0700
Message-ID: <20110527192341.32105.95751.stgit@elm3c44.beaverton.ibm.com>
References: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
function to wait for pending writeback before allowing the page to become
writable.  This is needed to stabilize pages during writeback for those two
filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/buffer.c b/fs/buffer.c
index 698c6b2..49c9aad 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2382,6 +2382,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
+	wait_on_page_writeback(page);
 	return 0;
 out_unlock:
 	unlock_page(page);

