From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] mm: Wait for writeback when grabbing pages to begin a
	write
Date: Fri, 27 May 2011 12:23:34 -0700
Message-ID: <20110527192334.32105.99904.stgit@elm3c44.beaverton.ibm.com>
References: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20110527192326.32105.34164.stgit@elm3c44.beaverton.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

When grabbing a page for a buffered IO write, the mm should wait for writeback
on the page to complete so that the page does not become writable during the IO
operation.  This change is needed to provide page stability during writes for
all filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 mm/filemap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/mm/filemap.c b/mm/filemap.c
index bcdc393..dac95a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2327,7 +2327,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 repeat:
 	page = find_lock_page(mapping, index);
 	if (page)
-		return page;
+		goto found;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
 	if (!page)
@@ -2340,6 +2340,8 @@ repeat:
 			goto repeat;
 		return NULL;
 	}
+found:
+	wait_on_page_writeback(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
