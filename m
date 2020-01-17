Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB27C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A175020661
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 13:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GyzRvij8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgAQNpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 08:45:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgAQNpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 08:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AN2hr5dcia6+CzI/dY/K91UkGTWZziysWiorCAbapjw=; b=GyzRvij8w1ieCUCI314sUiunC
        nwbW94DTiya1AbDARzchXcbX/Ah99Nb1aLH0wjwJFIYpyUj98xY3VnQIa22XyIEEjqmrl5hyZEYKR
        yVM/6w4zEvDDhcvhnpmc+UWoODhqd0vPAZR2IHRVfzZEtTgFlZp5dyU5/yWCnp+P/FJzP9kXN0u5I
        bRb/7e+aCq1Rrwcfxxp5OQdjnuIzfsvKvYRt+VrOK4Q+VkFCztpwrHaY9k9/3q6LlrLy6/VuZEBKi
        eIh2G0F9GdAyGp4v+9eu49ve+lhP7vaxWV+f4z2gWR5qssiVq4BqRxx/rB28RYFetyZX3ofOFnkBR
        9cr77dTIg==;
Received: from [88.128.92.44] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isRw2-0001R7-Bv; Fri, 17 Jan 2020 13:45:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, abdhalee@linux.vnet.ibm.com
Subject: [PATCH] mpt3sas: don't change the dma coherent mask after allocations
Date:   Fri, 17 Jan 2020 14:45:06 +0100
Message-Id: <20200117134506.633586-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The DMA layer does not allow changing the DMA coherent mask after
there are outstanding allocations.  Stop doing that and always
use a 32-bit coherent DMA mask in mpt3sas.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 67 ++++++++---------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 -
 2 files changed, 19 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fea3cb6a090b..3b51bed05008 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2706,58 +2706,38 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
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
+	int dma_mask;
 
-	required_mask = dma_get_required_mask(&pdev->dev);
-	if (sizeof(dma_addr_t) == 4 || required_mask == 32)
-		goto try_32bit;
-
-	if (ioc->dma_mask)
-		coherent_mask = DMA_BIT_MASK(dma_mask);
+	if (ioc->is_mcpu_endpoint ||
+	    sizeof(dma_addr_t) == 4 ||
+	    dma_get_required_mask(&pdev->dev) <= 32)
+		dma_mask = 32;
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+		dma_mask = 63;
 	else
-		coherent_mask = DMA_BIT_MASK(32);
+		dma_mask = 64;
 
 	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, coherent_mask))
-		goto try_32bit;
-
-	ioc->base_add_sg_single = &_base_add_sg_single_64;
-	ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-	ioc->dma_mask = dma_mask;
-	goto out;
-
- try_32bit:
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))
 		return -ENODEV;
 
-	ioc->base_add_sg_single = &_base_add_sg_single_32;
-	ioc->sge_size = sizeof(Mpi2SGESimple32_t);
-	ioc->dma_mask = 32;
- out:
+	if (dma_mask > 32) {
+		ioc->base_add_sg_single = &_base_add_sg_single_64;
+		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+	} else {
+		ioc->base_add_sg_single = &_base_add_sg_single_32;
+		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
+	}
+
 	si_meminfo(&s);
 	ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
-		 ioc->dma_mask, convert_to_kb(s.totalram));
+		 dma_mask, convert_to_kb(s.totalram));
 
 	return 0;
 }
 
-static int
-_base_change_consistent_dma_mask(struct MPT3SAS_ADAPTER *ioc,
-				      struct pci_dev *pdev)
-{
-	if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(ioc->dma_mask))) {
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
-			return -ENODEV;
-	}
-	return 0;
-}
-
 /**
  * _base_check_enable_msix - checks MSIX capabable.
  * @ioc: per adapter object
@@ -5030,14 +5010,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -6965,7 +6937,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->smp_affinity_enable = smp_affinity_enable;
 
 	ioc->rdpq_array_enable_assigned = 0;
-	ioc->dma_mask = 0;
 	if (ioc->is_aero_ioc)
 		ioc->base_readl = &_base_readl_aero;
 	else
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index faca0a5e71f8..e57cade1155c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1011,7 +1011,6 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @ir_firmware: IR firmware present
  * @bars: bitmask of BAR's that must be configured
  * @mask_interrupts: ignore interrupt
- * @dma_mask: used to set the consistent dma mask
  * @pci_access_mutex: Mutex to synchronize ioctl, sysfs show path and
  *			pci resource handling
  * @fault_reset_work_q_name: fw fault work queue
@@ -1185,7 +1184,6 @@ struct MPT3SAS_ADAPTER {
 	u8		ir_firmware;
 	int		bars;
 	u8		mask_interrupts;
-	int		dma_mask;
 
 	/* fw fault handler */
 	char		fault_reset_work_q_name[20];
-- 
2.24.1

