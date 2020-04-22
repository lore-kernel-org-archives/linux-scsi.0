Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B874C54FCB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 17:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F8C2082E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 17:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="erCruCHk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgDVRST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726363AbgDVRSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 13:18:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8475C03C1A9
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 10:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NzRYI7AyZ6i+iYzXbZlq4sHy/wUTqDJ9zYOSP0XPrAU=; b=erCruCHkJRLMLb4AKyrQYojUJT
        2F7DArvzD4CI+5Ttd/ibWjMIbKVI0a1LTkf/mGG4jabOJ0VxjsMtQvkjp1u27fmG2ayMIFZXPZh/A
        Q1PQNKuCsg6OaYdPW1BTnKTAOz9LsddMZLDBw60dnLd/fX972ibVa7TiEx7XNN0PQqcsoZkVfzGmp
        U34ljC/+VHfBXd091SNUjZnUWjnEkYMu4q1wsDvQZbN90LlaC6z4fLTHH0/xxFTEKcYMH9O4y0ht5
        idXrHAdpz/6ixjcEv5EGO+rV0MpgtJlkzkmAYMYnqz6WcuSkdyM6ttRsGI8dVZoGiKT1tEcjyPD01
        0ZPsQDbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRJ0s-0000nN-HS; Wed, 22 Apr 2020 17:18:18 +0000
Date:   Wed, 22 Apr 2020 10:18:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <Sathya.Prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [v1 1/5] mpt3sas: Don't change the dma coherent mask after
 allocations
Message-ID: <20200422171818.GA19176@infradead.org>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-2-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20200422063427.GB20318@infradead.org>
 <CA+RiK67m6Uk=QLppNcO23C4CnbSO483uwowTg0ZPZ9oRLxOsew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+RiK67m6Uk=QLppNcO23C4CnbSO483uwowTg0ZPZ9oRLxOsew@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 22, 2020 at 02:49:42PM +0530, Suganath Prabu Subramani wrote:
> Hi Christoph,
> 
> Your original patch always set the dma coherent mask to 32bit.
> But in this patch set, we first set the dma coherent to 64bit, if RDPQ
> pools crosses
> the 4gb boundary then we change it to 32 bit.
> Like your original patch we will simplify.

This is however missing most of the cleanups.  Also the is_dma_32bit
flag is unused in this patch.  So I don't think it should be added
here, but only when used.  It should then also use a bool type
and be named use_32bit_dma.

When reworking your patch using all criteria I still end up with
something looking a lot like my original one, with the only big
difference that is also forces a 32-bit DMA streaming mask for
all the limited devices, which actually looks wrong to me:

---
From 5253b88eba38dbf50cbbe5f34c8f5b4c345cca57 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 22 Apr 2020 19:18:00 +0200
Subject: mpt3sas: don't change the dma coherent mask after allocations

The DMA layer does not allow changing the DMA coherent mask after
there are outstanding allocations.  Stop doing that and always
use a 32-bit coherent DMA mask in mpt3sas.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 71 ++++++++---------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 -
 2 files changed, 20 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 663782bb790d..3072599a187a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2806,55 +2806,33 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
 static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
-	u64 required_mask, coherent_mask;
 	struct sysinfo s;
-	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
-
-	if (ioc->is_mcpu_endpoint)
-		goto try_32bit;
+	int dma_bits;
 
-	required_mask = dma_get_required_mask(&pdev->dev);
-	if (sizeof(dma_addr_t) == 4 || required_mask == 32)
-		goto try_32bit;
-
-	if (ioc->dma_mask)
-		coherent_mask = DMA_BIT_MASK(dma_mask);
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+		dma_bits = 32;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+		dma_bits = 63;
 	else
-		coherent_mask = DMA_BIT_MASK(32);
-
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, coherent_mask))
-		goto try_32bit;
+		dma_bits = 64;
 
-	ioc->base_add_sg_single = &_base_add_sg_single_64;
-	ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-	ioc->dma_mask = dma_mask;
-	goto out;
-
- try_32bit:
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	if (dma_set_mask_and_coherent(&pdev->dev, dma_bits))
 		return -ENODEV;
 
-	ioc->base_add_sg_single = &_base_add_sg_single_32;
-	ioc->sge_size = sizeof(Mpi2SGESimple32_t);
-	ioc->dma_mask = 32;
- out:
-	si_meminfo(&s);
-	ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
-		 ioc->dma_mask, convert_to_kb(s.totalram));
-
-	return 0;
-}
-
-static int
-_base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
-				      struct pci_dev *pdev)
-{
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
-			return -ENODEV;
+	if (dma_bits > 32) {
+		ioc->base_add_sg_single = &_base_add_sg_single_64;
+		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+	} else {
+		ioc->base_add_sg_single = &_base_add_sg_single_32;
+		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
 	}
+
+	si_meminfo(&s);
+	ioc_info(ioc,
+		"%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
+		dma_bits, convert_to_kb(s.totalram));
 	return 0;
 }
 
@@ -5169,14 +5147,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		total_sz += sz;
 	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
 
-	if (ioc->dma_mask > 32) {
-		if (_base_change_consistent_dma_mask(ioc, ioc->pdev) != 0) {
-			ioc_warn(ioc, "no suitable consistent DMA mask for %s\n",
-				 pci_name(ioc->pdev));
-			goto out;
-		}
-	}
-
 	ioc->scsiio_depth = ioc->hba_queue_depth -
 	    ioc->hi_priority_depth - ioc->internal_depth;
 
@@ -7158,7 +7128,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->smp_affinity_enable = smp_affinity_enable;
 
 	ioc->rdpq_array_enable_assigned = 0;
-	ioc->dma_mask = 0;
 	if (ioc->is_aero_ioc)
 		ioc->base_readl = &_base_readl_aero;
 	else
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e7197150721f..caae04086539 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1026,7 +1026,6 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @ir_firmware: IR firmware present
  * @bars: bitmask of BAR's that must be configured
  * @mask_interrupts: ignore interrupt
- * @dma_mask: used to set the consistent dma mask
  * @pci_access_mutex: Mutex to synchronize ioctl, sysfs show path and
  *			pci resource handling
  * @fault_reset_work_q_name: fw fault work queue
@@ -1205,7 +1204,6 @@ struct MPT3SAS_ADAPTER {
 	u8		ir_firmware;
 	int		bars;
 	u8		mask_interrupts;
-	int		dma_mask;
 
 	/* fw fault handler */
 	char		fault_reset_work_q_name[20];
-- 
2.26.1

