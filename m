From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 34/87] message: fusion: remove memset after pci_alloc_consistent in mptbase.c
Date: Fri, 28 Jun 2019 01:38:57 +0800
Message-ID: <20190627173858.3623-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_alloc_consistent calls dma_alloc_coherent directly
In commit af7ddd8a627c
("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
dma_alloc_coherent has already zeroed the memory.
So memset is not needed.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/message/fusion/mptbase.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d8882b0a1338..845d1ef8abdf 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4507,7 +4507,6 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Total alloc @ %p[%p], sz=%d[%x] bytes\n",
 			 	ioc->name, mem, (void *)(ulong)alloc_dma, total_size, total_size));
 
-		memset(mem, 0, total_size);
 		ioc->alloc_total += total_size;
 		ioc->alloc = mem;
 		ioc->alloc_dma = alloc_dma;
-- 
2.11.0
