From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v3 3/3] mm: Wait for writeback when grabbing pages to begin
	a write
Date: Wed, 4 May 2011 10:42:27 -0700
Message-ID: <20110504174227.GH20579@tux1.beaverton.ibm.com>
References: <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110422000226.GA22189@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When grabbing a page for a buffered IO write, the mm should wait for writeback
on the page to complete so that the page does not become writable during the IO
operation.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 mm/filemap.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c641edf..c22675f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2287,8 +2287,10 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 		gfp_notmask = __GFP_FS;
 repeat:
 	page = find_lock_page(mapping, index);
-	if (page)
+	if (page) {
+		wait_on_page_writeback(page);
 		return page;
+	}
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
 	if (!page)
@@ -2301,6 +2303,7 @@ repeat:
 			goto repeat;
 		return NULL;
 	}
+	wait_on_page_writeback(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
