From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Fri, 09 May 2008 11:49:41 -0500
Message-ID: <1210351781.3069.41.camel@localhost.localdomain>
References: <20080502185227.GN14976@parisc-linux.org>
	 <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
	 <20080503105135.GY14976@parisc-linux.org>
	 <1210281511.3114.72.camel@localhost.localdomain>
	 <FD415073-DC5F-426F-8ADD-09CF96C6917D@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59660 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbYEIQtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 12:49:45 -0400
In-Reply-To: <FD415073-DC5F-426F-8ADD-09CF96C6917D@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2008-05-09 at 02:39 -0400, Mark Salyzyn wrote:
> with comment, I had chosen to perform the sizeof check as it optimized  
> out the code on the 32 bit platforms and could have merged the  
> aac_scsi_32_64 and aac_scsi_32 functions (such considerations are my  
> penance for writing peephole optimizers and BIOS code in C/C++). Never  
> sacrifice clarity/maintainability for optimization if you can afford it.

Actually, point taken on the queuecommand check and the lesson in
optimisation.  This should actually be a better optimised version,
getting rid of the check altogether.

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [SCSI] aacraid: don't use num_physpages

aacraid uses num_physpages as a check to see if it needs to fail
commands to physical drives which can only be sent as 32 bit fibs for
certain cards (those with AAC_QUIRK_SCSI_32 set).  The correct API for
this is dma_get_required_mask(), so make it use that.  Also tidy up
the 64 bit fib enabling code so we only enable it if the kernel is 64
bit and the dma mask goes over 32 bits (i.e. it has memory above 4GB).

Acked-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/aacraid/aachba.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..2cc2c09 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1204,13 +1204,14 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
 				  (fib_callback) aac_srb_callback, (void *) cmd);
 }
 
+/*
+ * This routine is only used if we have memory > 4GB and the adapter
+ * is one of the quirky ones that can't do dma above 4GB to physical
+ * disks
+ */
 static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 {
-	if ((sizeof(dma_addr_t) > 4) &&
-	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
-	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
-		return FAILED;
-	return aac_scsi_32(fib, cmd);
+	return FAILED;
 }
 
 int aac_get_adapter_info(struct aac_dev* dev)
@@ -1372,16 +1373,29 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 
 	dev->dac_support = 0;
-	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
+	dev->a_ops.adapter_scsi = aac_scsi_32;
+	if ((dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK
+	     && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)
+	     && dacmode == -1) ||
+	    dacmode == 1) {
 		if (!dev->in_reset)
 			printk(KERN_INFO "%s%d: 64bit support enabled.\n",
 				dev->name, dev->id);
 		dev->dac_support = 1;
-	}
+		dev->a_ops.adapter_scsi = aac_scsi_64;
 
-	if(dacmode != -1) {
-		dev->dac_support = (dacmode!=0);
+		/*
+		 * Adapters with AAC_QUIRK_SCSI_32 can only send pass
+		 * through commands as 32 bit fibs (although they can
+		 * send RAID commands as 64 bit fibs) flag these here
+		 * so we fail direct SCSI commands in the special
+		 * aac_scsi_32_64 routine
+		 */
+		if (aac_get_driver_ident(dev->cardtype)->quirks
+		    & AAC_QUIRK_SCSI_32)
+			dev->a_ops.adapter_scsi = aac_scsi_32_64;
 	}
+
 	if(dev->dac_support != 0) {
 		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
 			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
@@ -1403,11 +1417,6 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	 * Deal with configuring for the individualized limits of each packet
 	 * interface.
 	 */
-	dev->a_ops.adapter_scsi = (dev->dac_support)
-	  ? ((aac_get_driver_ident(dev->cardtype)->quirks & AAC_QUIRK_SCSI_32)
-				? aac_scsi_32_64
-				: aac_scsi_64)
-				: aac_scsi_32;
 	if (dev->raw_io_interface) {
 		dev->a_ops.adapter_bounds = (dev->raw_io_64)
 					? aac_bounds_64
-- 
1.5.4.1



