From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi build failure
Date: Mon, 31 Mar 2008 21:58:08 -0500
Message-ID: <1207018688.3192.89.camel@localhost.localdomain>
References: <20080401113308.65f762cb.sfr@au.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39921 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYDAC6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2008 22:58:14 -0400
In-Reply-To: <20080401113308.65f762cb.sfr@au.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@au1.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-04-01 at 11:33 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> The linux-next 20080331 build (m68k defconfig) failed like this:
> 
> drivers/scsi/gvp11.c:325: error: 'a3000_host' undeclared (first use in this function)
> make[3]: *** [drivers/scsi/gvp11.o] Error 1
> drivers/scsi/a2091.c:182: error: 'a3000_host' undeclared (first use in this function)
> 
> presumably caused by commit 90609948bc0e9de545dfddf761f760382ea97b16
> ("[SCSI] WD33C93: let platform stub override no_sync/fast/dma_mode").  I
> shall revert that commit from today's tree.

I think Thomas has been slightly careless with the cut and paste.  This
should be the fix.

James

---

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index e75a7ba..ca73637 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -322,9 +322,9 @@ int __init gvp11_detect(struct scsi_host_template *tpnt)
 	 */
 	regs.SASR = &(DMA(instance)->SASR);
 	regs.SCMD = &(DMA(instance)->SCMD);
-	HDATA(a3000_host)->no_sync = 0xff;
-	HDATA(a3000_host)->fast = 0;
-	HDATA(a3000_host)->dma_mode = CTRL_DMA;
+	HDATA(instance)->no_sync = 0xff;
+	HDATA(instance)->fast = 0;
+	HDATA(instance)->dma_mode = CTRL_DMA;
 	wd33c93_init(instance, regs, dma_setup, dma_stop,
 		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
 					     : WD33C93_FS_12_15);
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index 6a8cf17..d722235 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -82,9 +82,9 @@ int mvme147_detect(struct scsi_host_template *tpnt)
     mvme147_host->irq = MVME147_IRQ_SCSI_PORT;
     regs.SASR = (volatile unsigned char *)0xfffe4000;
     regs.SCMD = (volatile unsigned char *)0xfffe4001;
-    HDATA(a3000_host)->no_sync = 0xff;
-    HDATA(a3000_host)->fast = 0;
-    HDATA(a3000_host)->dma_mode = CTRL_DMA;
+    HDATA(mvme147_host)->no_sync = 0xff;
+    HDATA(mvme147_host)->fast = 0;
+    HDATA(mvme147_host)->dma_mode = CTRL_DMA;
     wd33c93_init(mvme147_host, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
 
     if (request_irq(MVME147_IRQ_SCSI_PORT, mvme147_intr, 0, "MVME147 SCSI PORT", mvme147_intr))


