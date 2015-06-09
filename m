From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v4] fusion: remove dead MTRR code
Date: Tue,  9 Jun 2015 16:15:00 -0700
Message-ID: <1433891700-19961-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:33693 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbbFIXRQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 19:17:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Andy Lutomirski <luto@amacapital.net>, Juergen Gross <jgross@suse.com>, Dave Airlie <airlied@redhat.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, MPT-FusionLinux.pdl@avagotech.com

From: "Luis R. Rodriguez" <mcgrof@suse.com>

If and when this gets enabled the driver could should split
up IO memory space properly and that is quite a bit of work.
Just remove the uncommented dead MTRR code then.

There are a few motivations for this:

a) Take advantage of PAT when available

b) Help bury MTRR code away, MTRR is architecture specific and on
   x86 its replaced by PAT

c) Help with the goal of eventually using _PAGE_CACHE_UC over
   _PAGE_CACHE_UC_MINUS on x86 on ioremap_nocache() (see commit
   de33c442e titled "x86 PAT: fix performance drop for glx,
   use UC minus for ioremap(), ioremap_nocache() and
   pci_mmap_page_range()")

Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Juergen Gross <jgross@suse.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---

James,

The last patches for fusion went up through Christoph. I checked with him and
he notes this should go through you. This v4 has only the commit log changed to
annotate the Acked-by the driver maintainer. Please let me know if there are
any issue with this, or if you are busy it seems like Andrew Morton might be
willing to take this up through his tree. Let me know what you prefer.

This is part of a long series of patches in which we are doing transformation
over from MTRR specific code to the more PAT friendly aware code. This driver
specific change is really trivial as all it does is remove commented out code
which we woiuld otherwise have to replace and port. The driver maintainer is
OK with this removal.

 drivers/message/fusion/mptbase.c | 24 ------------------------
 drivers/message/fusion/mptbase.h |  1 -
 2 files changed, 25 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 187f836..5dcc031 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -59,10 +59,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>		/* needed for in_interrupt() proto */
 #include <linux/dma-mapping.h>
-#include <asm/io.h>
-#ifdef CONFIG_MTRR
-#include <asm/mtrr.h>
-#endif
 #include <linux/kthread.h>
 #include <scsi/scsi_host.h>
 
@@ -2820,13 +2816,6 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 	pci_disable_device(ioc->pcidev);
 	pci_release_selected_regions(ioc->pcidev, ioc->bars);
 
-#if defined(CONFIG_MTRR) && 0
-	if (ioc->mtrr_reg > 0) {
-		mtrr_del(ioc->mtrr_reg, 0, 0);
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT "MTRR region de-registered\n", ioc->name));
-	}
-#endif
-
 	/*  Zap the adapter lookup ptr!  */
 	list_del(&ioc->list);
 
@@ -4512,19 +4501,6 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 		ioc->req_frames_low_dma = (u32) (alloc_dma & 0xFFFFFFFF);
 
-#if defined(CONFIG_MTRR) && 0
-		/*
-		 *  Enable Write Combining MTRR for IOC's memory region.
-		 *  (at least as much as we can; "size and base must be
-		 *  multiples of 4 kiB"
-		 */
-		ioc->mtrr_reg = mtrr_add(ioc->req_frames_dma,
-					 sz,
-					 MTRR_TYPE_WRCOMB, 1);
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MTRR region registered (base:size=%08x:%x)\n",
-				ioc->name, ioc->req_frames_dma, sz));
-#endif
-
 		for (i = 0; i < ioc->req_depth; i++) {
 			alloc_dma += ioc->req_sz;
 			mem += ioc->req_sz;
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8f14090..813d463 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -671,7 +671,6 @@ typedef struct _MPT_ADAPTER
 	u8			*HostPageBuffer; /* SAS - host page buffer support */
 	u32			HostPageBuffer_sz;
 	dma_addr_t		HostPageBuffer_dma;
-	int			 mtrr_reg;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	int			bars;		/* bitmask of BAR's that must be configured */
 	int			msi_enable;
-- 
2.3.2.209.gd67f9d5.dirty

