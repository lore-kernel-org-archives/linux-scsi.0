From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 17:33:14 +0900
Message-ID: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52275 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZFEIdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2009 04:33:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingo@elte.hu, lethal@linux-sh.org
Cc: joerg.roedel@amd.com, just.for.lkml@googlemail.com, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

dma-debugs wrongly assumes that no multiple DMA transfers are
performed against the same dma address on one device at the same
time. However it's true only with hardware IOMMUs. For example, an
application can easily send the same buffer twice with different
lengths to one device by using DIO and AIO. If these requests are not
unmapped in the same order in which they were mapped,
hash_bucket_find() finds a wrong entry and gives a false warning.

We should fix this before 2.6.30 release. Seems that there is no
easy way to fix it. I think that it's better to just disable
dma-debug for now.

Torsten Kaiser found this bug with the RAID1 configuration:

http://marc.info/?t=124336541900008&r=1&w=2

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/sh/Kconfig  |    1 -
 arch/x86/Kconfig |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index e7390dd..4fb19d7 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -14,7 +14,6 @@ config SUPERH
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IOREMAP_PROT if MMU
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_DMA_API_DEBUG
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..b3cf490 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -42,7 +42,6 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
-	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
-- 
1.6.0.6

