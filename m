From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] mvsas: Fix the kernel panic due to unaligned data access
Date: Sun, 09 Jun 2013 09:23:16 -0700
Message-ID: <1370794996.2097.12.camel@dabdike.int.hansenpartnership.com>
References: <5189F864.5080808@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33613 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab3FIQXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 12:23:18 -0400
In-Reply-To: <5189F864.5080808@tilera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Guo <ggang@tilera.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org

On Wed, 2013-05-08 at 15:01 +0800, Paul Guo wrote:
> It's easy to find the address and symbol that causes the unalignd data
> access according to the stack dump information. The following small
> patch will fix it.

Do you have the panic log?  because it sounds like a bug in your
platform code.  All platforms have to support unaligned accesses because
some of the kernel parsers generate them as well.  You can see examples
of how to do this in e.g. arch/parisc/kernel/unaligned.c

> This change is harmless for platforms (like x86/x64) which support
> unaligned data access but is critical for platforms those do not support
> unaligned data access (like our platform: arch/tile).
> 
> I sent the patch but did not ping the status. I sync-up the workspace
> and re-generate the patch again. Feel free to give me any feedback. It's
> really annoying to maintain the change internally.

First off, you didn't compile this on x86, did you?

> @@ -39,6 +39,7 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/unaligned.h>
>  #include <scsi/libsas.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_tcq.h>

Causes

  CC [M]  drivers/scsi/scsi_sysfs.o
In file included from drivers/scsi/mvsas/mv_sas.c:26:0:
drivers/scsi/mvsas/mv_sas.h:41:29: fatal error: linux/unaligned.h: No
such file or directory

because it should be asm/unaligned.h.  If it actually compiles on your
platform, you've got a serious problem with the way include paths work.

Secondly, the reason we have get_unaligned() macros is to speed up
things by avoiding the trap when we know the data is unaligned, but it
is really inefficient on most platforms because it will unroll a u64
deref into 8 single byte loads.  In this case, the DMA buffer looks to
be a word file, so the below is probably how it should be done.  Notice
the efficient access in the fast path and the inefficient one in the
error path.

James

---

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f14665a..6b1b4e9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1857,11 +1857,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		goto out;
 	}
 
-	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	/*
+	 * error info record present; slot->response is 32 bit aligned but may
+	 * not be 64 bit aligned, so check for zero in two 32 bit reads
+	 */
+	if (unlikely((rx_desc & RXQ_ERR)
+		     && (*((u32 *)slot->response)
+			 || *(((u32 *)slot->response) + 1)))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			 rx_desc, get_unaligned_le64(slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 60e2fb7..d6b19dc 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/unaligned.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>


