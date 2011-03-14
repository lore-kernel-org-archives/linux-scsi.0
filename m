From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/21] target: Avoid mem leak and needless work in transport_generic_get_mem
Date: Mon, 14 Mar 2011 04:06:05 -0700
Message-ID: <1300100775-10012-12-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

In drivers/target/target_core_transport.c::transport_generic_get_mem()
there are a few potential memory leaks in the error paths. This patch
makes sure that we free previously allocated memory when other allocations
fail.  It also moves some work (INIT_LIST_HEAD() and assignment to
se_mem->se_len) below all the allocations so that if something fails we
don't do the work at all.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 30c1223..af56ce2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4358,11 +4358,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
 			goto out;
 		}
-		INIT_LIST_HEAD(&se_mem->se_list);
-		se_mem->se_len = (length > dma_size) ? dma_size : length;
 
 /* #warning FIXME Allocate contigous pages for struct se_mem elements */
-		se_mem->se_page = (struct page *) alloc_pages(GFP_KERNEL, 0);
+		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
 		if (!(se_mem->se_page)) {
 			printk(KERN_ERR "alloc_pages() failed\n");
 			goto out;
@@ -4373,6 +4371,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 			printk(KERN_ERR "kmap_atomic() failed\n");
 			goto out;
 		}
+		INIT_LIST_HEAD(&se_mem->se_list);
+		se_mem->se_len = (length > dma_size) ? dma_size : length;
 		memset(buf, 0, se_mem->se_len);
 		kunmap_atomic(buf, KM_IRQ0);
 
@@ -4391,6 +4391,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 
 	return 0;
 out:
+	if (se_mem)
+		__free_pages(se_mem->se_page, 0);
+	kmem_cache_free(se_mem_cache, se_mem);
 	return -1;
 }
 
-- 
1.7.4.1
