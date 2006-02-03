From: Hugh Dickins <hugh@veritas.com>
Subject: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Fri, 3 Feb 2006 19:55:17 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0602031953400.14829@goblin.wat.veritas.com>
References: <Pine.LNX.4.63.0512271807130.4955@kai.makisara.local>
 <20060104172727.GA320@tau.solarneutrino.net> <Pine.LNX.4.63.0601042334310.5087@kai.makisara.local>
 <20060105201249.GB1795@tau.solarneutrino.net> <Pine.LNX.4.64.0601051312380.3169@g5.osdl.org>
 <20060109033149.GC283@tau.solarneutrino.net> <Pine.LNX.4.64.0601082000450.3169@g5.osdl.org>
 <Pine.LNX.4.61.0601090933160.7632@goblin.wat.veritas.com>
 <20060109185350.GG283@tau.solarneutrino.net> <Pine.LNX.4.61.0601091922550.15426@goblin.wat.veritas.com>
 <20060118001252.GB821@tau.solarneutrino.net> <Pine.LNX.4.61.0601181556050.9110@goblin.wat.veritas.com>
 <Pine.LNX.4.61.0602031842290.14065@goblin.wat.veritas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.veritas.com ([143.127.12.110]:41578 "EHLO gold.veritas.com")
	by vger.kernel.org with ESMTP id S1422899AbWBCTyk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 14:54:40 -0500
Received: from goblin.wat.veritas.com([10.10.97.2]) (3661 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1F570w-0001TeC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 11:54:38 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <Pine.LNX.4.61.0602031842290.14065@goblin.wat.veritas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On some architectures, mapping the scatterlist may coalesce entries:
if that coalesced list is then used for freeing the pages afterwards,
there's a danger that pages may be doubly freed (and others leaked).

Fix Power RAID's ipr_free_ucode_buffer by freeing from a separate array
beyond the scatterlist.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Warning: untested!

 drivers/scsi/ipr.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

--- 2.6.16-rc2/drivers/scsi/ipr.c	2006-02-03 09:32:24.000000000 +0000
+++ linux/drivers/scsi/ipr.c	2006-02-03 09:59:37.000000000 +0000
@@ -2538,6 +2538,7 @@ static struct ipr_sglist *ipr_alloc_ucod
 	int sg_size, order, bsize_elem, num_elem, i, j;
 	struct ipr_sglist *sglist;
 	struct scatterlist *scatterlist;
+	struct page **sg_pages;
 	struct page *page;
 
 	/* Get the minimum size per scatter/gather element */
@@ -2557,7 +2558,8 @@ static struct ipr_sglist *ipr_alloc_ucod
 
 	/* Allocate a scatter/gather list for the DMA */
 	sglist = kzalloc(sizeof(struct ipr_sglist) +
-			 (sizeof(struct scatterlist) * (num_elem - 1)),
+			 (sizeof(struct scatterlist) * (num_elem - 1)) +
+			 (sizeof(struct page *) * num_elem),
 			 GFP_KERNEL);
 
 	if (sglist == NULL) {
@@ -2566,6 +2568,8 @@ static struct ipr_sglist *ipr_alloc_ucod
 	}
 
 	scatterlist = sglist->scatterlist;
+	/* Save pages to be freed in array beyond scatterlist */
+	sg_pages = (struct page **) (scatterlist + num_elem);
 
 	sglist->order = order;
 	sglist->num_sg = num_elem;
@@ -2584,6 +2588,7 @@ static struct ipr_sglist *ipr_alloc_ucod
 		}
 
 		scatterlist[i].page = page;
+		sg_pages[i] = page;
 	}
 
 	return sglist;
@@ -2601,10 +2606,13 @@ static struct ipr_sglist *ipr_alloc_ucod
  **/
 static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
 {
+	struct page **sg_pages;
 	int i;
 
+	/* Scatterlist entries may have been coalesced: free saved pagelist */
+	sg_pages = (struct page **) (sglist->scatterlist + sglist->num_sg);
 	for (i = 0; i < sglist->num_sg; i++)
-		__free_pages(sglist->scatterlist[i].page, sglist->order);
+		__free_pages(sg_pages[i], sglist->order);
 
 	kfree(sglist);
 }
