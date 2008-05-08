From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Thu, 08 May 2008 16:18:31 -0500
Message-ID: <1210281511.3114.72.camel@localhost.localdomain>
References: <20080502185227.GN14976@parisc-linux.org>
	 <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
	 <20080503105135.GY14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35421 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758074AbYEHVSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 17:18:35 -0400
In-Reply-To: <20080503105135.GY14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, 2008-05-03 at 04:51 -0600, Matthew Wilcox wrote:
> On Fri, May 02, 2008 at 03:06:42PM -0400, Mark Salyzyn wrote:
> > The num_physpages variable works as needed for the PERC controllers  
> > that are installed in vanilla x86 machines is it not? The PERC card  
> > would not be installed in any other arch.
> > 
> > AAC_QUIRK_SCSI_32 means the card can not send 64bit format commands to  
> > the SCSI devices (non DASD) but can send 64bit format commands to the  
> > logical (Array) devices. This is for a select set of old PERC cards.
> > 
> > AAC_OPT_SGMAP_HOST64 means this card 'can' do DAC (send 64 bit format  
> > commands to both SCSI and to Array devices), but sadly some that  
> > report this are borken (hence the Quirk AAC_QUIRK_SCSI_32).
> > 
> > Dropping the cards is not an option, that is the whole reason this  
> > workaround was put in place.
> 
> Thanks for the explanation of the quirks and options.  I don't want to
> drop support for any cards, I just want to make aacraid not rely on
> the meaning of num_physpages.
> 
> The question aacraid wants to ask is "Does this device have to
> do DAC to access memory?"  The answer can be affected by an IOMMU or
> by memory layout.  It's far from clear what question num_physpages is
> intended to answer; there are different bits of the kernel using it in
> interesting ways.  But we do have a function designed to answer the
> question you want to ask: dma_get_required_mask().  This may be an
> expensive question to ask, so in the below patch I cache the answer in
> the aac_dev.

Actually, I think we can do a bit better than this.  We really only want
to enable 64 bit fibs if they're actually needed, so we should be
checking the dma_get_required_mask at all places the driver currently
looks for sizeof(dma_addr_t) > 4.

The attached, I think is cleaner (it also explains what this quirk is
for and calls the variable something more consonant with its function).

James


---

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..15e60cb 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1206,9 +1206,7 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
 
 static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 {
-	if ((sizeof(dma_addr_t) > 4) &&
-	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
-	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
+	if (fib->dev->no_scsi_64)
 		return FAILED;
 	return aac_scsi_32(fib, cmd);
 }
@@ -1372,11 +1370,23 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		printk(KERN_INFO "%s%d: Non-DASD support enabled.\n",dev->name, dev->id);
 
 	dev->dac_support = 0;
-	if( (sizeof(dma_addr_t) > 4) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
+	if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK
+	    && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){
 		if (!dev->in_reset)
 			printk(KERN_INFO "%s%d: 64bit support enabled.\n",
 				dev->name, dev->id);
 		dev->dac_support = 1;
+
+		/*
+		 * Adapters with AAC_QUIRK_SCSI_32 can only send pass
+		 * through commands as 32 bit fibs (although they can
+		 * send RAID commands as 64 bit fibs) flag these here
+		 * so we fail direct SCSI commands in the special
+		 * aac_scsi_32_64 routine
+		 */
+		if (aac_get_driver_ident(dev->cardtype)->quirks
+		    & AAC_QUIRK_SCSI_32)
+			dev->no_scsi_64 = 1;
 	}
 
 	if(dacmode != -1) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 73916ad..39070c5 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1020,6 +1020,7 @@ struct aac_dev
 	u8			jbod;
 	u8			cache_protected;
 	u8			dac_support;
+	u8			no_scsi_64;
 	u8			raid_scsi_mode;
 	u8			comm_interface;
 #	define AAC_COMM_PRODUCER 0


