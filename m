From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: blk-mq vs kmemleak
Date: Mon, 3 Aug 2015 11:43:09 +0100
Message-ID: <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com>
 <20150708081740.GA3374@infradead.org>
 <55BC14AE.3090200@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([207.82.80.143]:24560 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbbHCKnN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2015 06:43:13 -0400
In-Reply-To: <55BC14AE.3090200@sandisk.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

On Sat, Aug 01, 2015 at 01:37:02AM +0100, Bart Van Assche wrote:
> On 07/08/2015 01:17 AM, Christoph Hellwig wrote:
> > On Tue, Jul 07, 2015 at 06:59:37AM -0700, Bart Van Assche wrote:
> >> Please note that my test was run with CONFIG_SLUB_DEBUG=y which causes a red
> >> zone to be allocated before and after each block of allocated memory. Could
> >> that explain the kmalloc-96 objects ?
> >
> > 96 is almost guaranteed to be the sense buffer allocated in
> > scsi_init_request and freed in scsi_exit_request.
> 
> kmemleak still reports large numbers of unreferenced objects for the 
> scsi-mq code with the v4.2-rc4 kernel even with the recently posted 
> scsi-mq leak fix applied on top of v4.2-rc4. Here is an example of one 
> such report:
> 
> unreferenced object 0xffff88045e05dc28 (size 96):
>    comm "srp_daemon", pid 8461, jiffies 4294973034 (age 742.350s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff814f2ede>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff811b0678>] kmem_cache_alloc_trace+0xc8/0x2d0
>      [<ffffffffa006cc37>] scsi_init_request+0x27/0x40 [scsi_mod]
>      [<ffffffff81278b91>] blk_mq_init_rq_map+0x1d1/0x260
>      [<ffffffff81278cc4>] blk_mq_alloc_tag_set+0xa4/0x1f0
>      [<ffffffffa006fb0d>] scsi_mq_setup_tags+0xcd/0xd0 [scsi_mod]
>      [<ffffffffa0066464>] scsi_add_host_with_dma+0x74/0x2e0 [scsi_mod]
>      [<ffffffffa0478e12>] srp_create_target+0xe12/0x1320 [ib_srp]
>      [<ffffffff8138a728>] dev_attr_store+0x18/0x30
>      [<ffffffff812371f8>] sysfs_kf_write+0x48/0x60
>      [<ffffffff812367f4>] kernfs_fop_write+0x144/0x190
>      [<ffffffff811bdaf8>] __vfs_write+0x28/0xe0
>      [<ffffffff811be1a9>] vfs_write+0xa9/0x190
>      [<ffffffff811bef09>] SyS_write+0x49/0xa0
>      [<ffffffff815022f2>] entry_SYSCALL_64_fastpath+0x16/0x7a
>      [<ffffffffffffffff>] 0xffffffffffffffff

If I read the code correctly, I think this is a false positive. In
blk_mq_init_irq_map(), tags->rqs[i] are allocated with
alloc_pages_node(). The scsi_cmd is placed after the request structure
in the same page and the sense_buffer pointer is stored in the scsi_cmd
structure. Since kmemleak does not track page allocations, it never
scans the scsi_cmd structure for the sense_buffer pointer, hence it
reports them as leaks.

The simplest would be to add a kmemleak_not_leak() annotation in
scsi_init_request(), though you would hide real leaks (if any).

A better way could be to inform kmemleak of these pages, something like
below (compile-tested only):

--------8<-------------
>From b5526babaf4b991fcc530c15563bc9b333f7c86a Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 3 Aug 2015 11:30:24 +0100
Subject: [PATCH] block: kmemleak: Track the page allocations for struct
 request

The pages allocated for struct request contain pointers to other slab
allocations (via ops->init_request). Since kmemleak does not track/scan
page allocations, the slab objects will be reported as leaks (false
positives). This patch adds kmemleak callbacks to allow tracking of such
pages.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-mq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7d842db59699..c5fe656fe244 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -9,6 +9,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/kmemleak.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -1448,6 +1449,11 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
 	while (!list_empty(&tags->page_list)) {
 		page = list_first_entry(&tags->page_list, struct page, lru);
 		list_del_init(&page->lru);
+		/*
+		 * Remove kmemleak object previously allocated in
+		 * blk_mq_init_rq_map().
+		 */
+		kmemleak_free(page_address(page));
 		__free_pages(page, page->private);
 	}
 
@@ -1520,6 +1526,11 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		list_add_tail(&page->lru, &tags->page_list);
 
 		p = page_address(page);
+		/*
+		 * Allow kmemleak to scan these pages as they contain pointers
+		 * to additional allocations like via ops->init_request().
+		 */
+		kmemleak_alloc(p, order_to_size(this_order), 1, GFP_KERNEL);
 		entries_per_page = order_to_size(this_order) / rq_size;
 		to_do = min(entries_per_page, set->queue_depth - i);
 		left -= to_do * rq_size;

