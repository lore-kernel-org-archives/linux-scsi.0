From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] cxgbit: fix dma_addr_t printk format
Date: Sat,  5 Mar 2016 01:04:41 +0100
Message-ID: <1457136294-2229829-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51056 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760491AbcCEAFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 19:05:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

The newly added driver prints a dma_addr_t using the %llx format string,
but that is wrong on most 32-bit architectures:

drivers/target/iscsi/cxgbit/cxgbit_ddp.c: In function 'cxgbit_dump_sgl':
drivers/target/iscsi/cxgbit/cxgbit_ddp.c:180:10: error: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t {aka unsigned int}' [-Werror=format=]
   pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma 0x%llx, %u\n",

Unfortunately, we can't use the %pad format string here because
we are not printing an lvalue, so we have to add a cast to u64, which
matches the format string on all architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: c49aa56e556d ("cxgbit: add cxgbit_ddp.c")
---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 07e2bc86d0df..d667bc88e21d 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -179,7 +179,7 @@ cxgbit_dump_sgl(const char *cap, struct scatterlist *sgl, int nents)
 	for_each_sg(sgl, sg, nents, i)
 		pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma 0x%llx, %u\n",
 			i, nents, sg, sg->length, sg->offset, sg_page(sg),
-			sg_dma_address(sg), sg_dma_len(sg));
+			(u64)sg_dma_address(sg), sg_dma_len(sg));
 }
 
 static int cxgbit_ddp_sgl_check(struct scatterlist *sgl, int nents)
-- 
2.7.0

