From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] exofs: fix printk format warnings
Date: Thu, 26 Mar 2009 14:44:30 -0700
Message-ID: <49CBF73E.2010808@oracle.com>
References: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:62462 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbZCZVpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 17:45:07 -0400
In-Reply-To: <20090326190130.54fc6fde.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix exofs printk format warnings:

fs/exofs/inode.c:184: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
fs/exofs/inode.c:291: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
fs/exofs/inode.c:373: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
fs/exofs/inode.c:461: warning: format '%zx' expects type 'size_t', but argument 6 has type 'long unsigned int'
fs/exofs/inode.c:534: warning: format '%zx' expects type 'size_t', but argument 7 has type 'long unsigned int'
fs/exofs/inode.c:610: warning: format '%zx' expects type 'size_t', but argument 5 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-next-20090325.orig/fs/exofs/inode.c
+++ linux-next-20090325/fs/exofs/inode.c
@@ -182,7 +182,7 @@ static int __readpages_done(struct osd_r
 		good_bytes = pcol->length - resid;
 
 	EXOFS_DBGMSG("readpages_done(%ld) good_bytes=%llx"
-		     " length=%zx nr_pages=%u\n",
+		     " length=%lx nr_pages=%u\n",
 		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
 		     pcol->nr_pages);
 
@@ -288,7 +288,7 @@ static int read_exec(struct page_collect
 
 	atomic_inc(&pcol->sbi->s_curr_pending);
 
-	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%zx\n",
+	EXOFS_DBGMSG("read_exec obj=%llx start=%llx length=%lx\n",
 		  obj.id, _LLU(i_start), pcol->length);
 
 	/* pages ownership was passed to pcol_copy */
@@ -371,7 +371,7 @@ try_again:
 	ret = pcol_add_page(pcol, page, len);
 	if (ret) {
 		EXOFS_DBGMSG("Failed pcol_add_page pages[i]=%p "
-			  "len=%zx nr_pages=%u length=%zx\n",
+			  "len=%zx nr_pages=%u length=%lx\n",
 			  page, len, pcol->nr_pages, pcol->length);
 
 		/* split the request, and start again with current page */
@@ -459,7 +459,7 @@ static void writepages_done(struct osd_r
 		good_bytes = pcol->length - resid;
 
 	EXOFS_DBGMSG("writepages_done(%lx) good_bytes=%llx"
-		     " length=%zx nr_pages=%u\n",
+		     " length=%lx nr_pages=%u\n",
 		     pcol->inode->i_ino, _LLU(good_bytes), pcol->length,
 		     pcol->nr_pages);
 
@@ -531,7 +531,7 @@ static int write_exec(struct page_collec
 	}
 
 	atomic_inc(&pcol->sbi->s_curr_pending);
-	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%zx\n",
+	EXOFS_DBGMSG("write_exec(%lx, %lx) start=%llx length=%lx\n",
 		  pcol->inode->i_ino, pcol->pg_first, _LLU(i_start),
 		  pcol->length);
 	/* pages ownership was passed to pcol_copy */
@@ -608,7 +608,7 @@ try_again:
 	ret = pcol_add_page(pcol, page, len);
 	if (unlikely(ret)) {
 		EXOFS_DBGMSG("Failed pcol_add_page "
-			     "nr_pages=%u total_length=%zx\n",
+			     "nr_pages=%u total_length=%lx\n",
 			     pcol->nr_pages, pcol->length);
 
 		/* split the request, next loop will start again */
