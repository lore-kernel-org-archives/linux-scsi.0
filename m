From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v1 16/47] fusion: use __arch_phys_wc_add()
Date: Fri, 20 Mar 2015 16:18:06 -0700
Message-ID: <1426893517-2511-17-git-send-email-mcgrof@do-not-panic.com>
References: <1426893517-2511-1-git-send-email-mcgrof@do-not-panic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34712 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbCTX4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 19:56:10 -0400
In-Reply-To: <1426893517-2511-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, jgross@suse.com, JBeulich@suse.com, bp@suse.de, suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com, airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, "Luis R. Rodriguez" <mcgrof@suse.com>, Ingo Molnar <mingo@elte.hu>, Daniel Vetter <daniel.vetter@ffwll.ch>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Antonino Daplas <adaplas@gmail.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

If and when this gets enabled the driver should address
using ioremap_wc() on the same area, that could require
a bit of work as it would mean a split with two ioremap'd
areas. Annotate this.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Juergen Gross <jgross@suse.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/message/fusion/mptbase.c | 19 ++++---------------
 drivers/message/fusion/mptbase.h |  2 +-
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 187f836..c7b1a55 100644
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
 
@@ -2820,11 +2816,8 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
 	pci_disable_device(ioc->pcidev);
 	pci_release_selected_regions(ioc->pcidev, ioc->bars);
 
-#if defined(CONFIG_MTRR) && 0
-	if (ioc->mtrr_reg > 0) {
-		mtrr_del(ioc->mtrr_reg, 0, 0);
-		dprintk(ioc, printk(MYIOC_s_INFO_FMT "MTRR region de-registered\n", ioc->name));
-	}
+#if 0
+	__arch_phys_wc_del(ioc->wc_cookie);
 #endif
 
 	/*  Zap the adapter lookup ptr!  */
@@ -4512,17 +4505,13 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 		ioc->req_frames_low_dma = (u32) (alloc_dma & 0xFFFFFFFF);
 
-#if defined(CONFIG_MTRR) && 0
+#if 0
 		/*
 		 *  Enable Write Combining MTRR for IOC's memory region.
 		 *  (at least as much as we can; "size and base must be
 		 *  multiples of 4 kiB"
 		 */
-		ioc->mtrr_reg = mtrr_add(ioc->req_frames_dma,
-					 sz,
-					 MTRR_TYPE_WRCOMB, 1);
-		dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MTRR region registered (base:size=%08x:%x)\n",
-				ioc->name, ioc->req_frames_dma, sz));
+		ioc->wc_cookie = arch_phys_wc_add(ioc->req_frames_dma, sz);
 #endif
 
 		for (i = 0; i < ioc->req_depth; i++) {
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8f14090..f0bff11 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -671,7 +671,7 @@ typedef struct _MPT_ADAPTER
 	u8			*HostPageBuffer; /* SAS - host page buffer support */
 	u32			HostPageBuffer_sz;
 	dma_addr_t		HostPageBuffer_dma;
-	int			 mtrr_reg;
+	int			wc_cookie;
 	struct pci_dev		*pcidev;	/* struct pci_dev pointer */
 	int			bars;		/* bitmask of BAR's that must be configured */
 	int			msi_enable;
-- 
2.3.2.209.gd67f9d5.dirty

