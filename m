From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 09 Mar 2008 10:08:35 -0500
Message-ID: <1205075315.3792.12.camel@localhost.localdomain>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
	 <20080309212916T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36770 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbYCIPIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Mar 2008 11:08:40 -0400
In-Reply-To: <20080309212916T.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, 2008-03-09 at 21:29 +0900, FUJITA Tomonori wrote:
> On Sun, 09 Mar 2008 14:23:13 +0300
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
> > Just got quite.. bad situation on a production server
> > here.  The machine locked up hard several times in a
> > row (required hard reboot).  So I finally enabled watchdog
> > subsystem which helped.
> > 
> > Now I see the following (over netconsole):
> > 
> > DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
> > ------------[ cut here ]------------
> > kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
> 
> Seems that you was out of swiommu space (and aic79xx can't handle it
> though it should). This happened because:
> 
> a) you produced more I/Os than swiommu can handle.
> 
> b) swiommu space leaks due to bugs.
> 
> If you hit this problem due to a), the following boot option might
> help:
> 
> swiotlb=65536
> 
> The same machine run well with old kernels? If so, probably, 2.6.24
> has new bugs that lead to swiommu space leak.

Actually, it's worse than this.  The aic79xx is a fully 64 bit capable
PCI card, it shouldn't be using the iommu at all.  However, it has three
DMA modes:  64 bit, 39 bit and 32 bit; with a corresponding resource
cost increasing with the number of bits.  It employs special APIs to
size the masks according to the memory, in aic79xx_osm_pci.c:

	if (sizeof(dma_addr_t) > 4) {
		const u64 required_mask = dma_get_required_mask(dev);

		if (required_mask > DMA_39BIT_MASK &&
		    dma_set_mask(dev, DMA_64BIT_MASK) == 0)
			ahd->flags |= AHD_64BIT_ADDRESSING;
		else if (required_mask > DMA_32BIT_MASK &&
			 dma_set_mask(dev, DMA_39BIT_MASK) == 0)
			ahd->flags |= AHD_39BIT_ADDRESSING;
		else
			dma_set_mask(dev, DMA_32BIT_MASK);
	} else {
		dma_set_mask(dev, DMA_32BIT_MASK);
	}

Could you firstly tell me how much memory you have, and secondly
instrument this code with the patch below to see if we can work out what
it's doing?

Thanks,

James

---

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index dfaaae5..d6e46ce 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -194,14 +194,21 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (sizeof(dma_addr_t) > 4) {
 		const u64 required_mask = dma_get_required_mask(dev);
 
+		printk("DEBUG: RETURNED REQUIRED MASK %llx\n",
+		       (unsigned long long)required_mask);
+
 		if (required_mask > DMA_39BIT_MASK &&
-		    dma_set_mask(dev, DMA_64BIT_MASK) == 0)
+		    dma_set_mask(dev, DMA_64BIT_MASK) == 0) {
+			printk("DEBUG: SET 64 BIT ADDRESSING\n");
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-		else if (required_mask > DMA_32BIT_MASK &&
-			 dma_set_mask(dev, DMA_39BIT_MASK) == 0)
+		} else if (required_mask > DMA_32BIT_MASK &&
+			   dma_set_mask(dev, DMA_39BIT_MASK) == 0) {
+			printk("DEBUG: SET 39 BIT ADDRESSING\n");
 			ahd->flags |= AHD_39BIT_ADDRESSING;
-		else
+		} else {
+			printk("DEBUG: SET 32 BIT ADDRESSING\n");
 			dma_set_mask(dev, DMA_32BIT_MASK);
+		}
 	} else {
 		dma_set_mask(dev, DMA_32BIT_MASK);
 	}


