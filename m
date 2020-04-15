Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2E9C2BB55
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A5C2074F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:25:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IFg5skZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632910AbgDONZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636097AbgDONZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B578C061A0C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z6so1235937plk.10
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hf3xCHfH3xNg3T3scjfL+j1UjrvC8CIu881OAHKx3Lg=;
        b=IFg5skZRiUjZGa7Hav7YleeQZSKnR8akR2cL7Ri3s9N1F/CPqMM8VqIl/1eEhC7KqD
         ZIsX7ySax8/meAJXwzae68qTikgdInObrLpPpVH6wN/L4sfb3kwslP/Qvt4Si+hFHYUM
         CVCLD0lSrni/0hWYpfMNsxktyOt7RM8Gd7Hck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hf3xCHfH3xNg3T3scjfL+j1UjrvC8CIu881OAHKx3Lg=;
        b=Gmo9NYdv7DsgasTOIUBEPoICh0NGao2M528GI1Ir1s59E0P4X5UEtqpM+e5QcuoPcU
         7xrR3yElIk0FVC+OCdCOTvxRxK5NTq+EzuFGqnwk4/E43eDfB+o0ZoNa7MWICQO9pVAw
         JpPZ54432zD8Qvi7sHfF85n4Ve8T5oNqQrw1Ftzy/X3Stvohm/ZfrIKrNp7488lzo6Mu
         Mwaw86AgSt/bhJOXss7fJdC2ZcFe81e3HGZgCMhZtP/m4PMlZ65kPelsw1pZ6Kh0vPGI
         HlamrtUmP+jAdGQt7Ezc258rzKSib5zQBBgStF3Vm+dmhFwqbOJ3yeTQnFCIXgpkNcfL
         CDNg==
X-Gm-Message-State: AGi0PuZyS4olLoBjRsA+prR2OqMrsmo3FzenlKAlZJ+w4zktBujoJUbl
        93svSNSD85rS6qSNV7wY/L3wcDz5IKb8O44LUy51R7NSpm5wXE/6XnJEei46CvnwnDj+glO/tK0
        4P/h95NcGIbq3yU/QWr5purMA9ghLOfeZVohfg2BhVf9OYfRx6U8YcPaX29HhZU+yOI9D3VYldd
        HbDkHN4XxAYJGzdXeI53Mr
X-Google-Smtp-Source: APiQypKGnTNz1MnldXuLjE5Mah177bInjSwkRX+fuHwMRtBAnejrgeWdSImZlIcZQVzi4RVNcQGMZw==
X-Received: by 2002:a17:90b:b08:: with SMTP id bf8mr5729349pjb.158.1586957143082;
        Wed, 15 Apr 2020 06:25:43 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:42 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 1/5] mpt3sas: Don't change the dma coherent mask after  allocations
Date:   Wed, 15 Apr 2020 09:25:21 -0400
Message-Id: <1586957125-19460-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Currently driver is initially setting the dma coherent mask to 32 bit
and then after allocating the Reply Descriptor Post Queues(RDPQ) pools
it changes the dma coherent mask to 64/63 according to HBA generation.

But the DMA layer does not allow changing the DMA coherent mask after
there are outstanding allocations.

So, updating the driver to stop changing the dma coherent mask after
allocations.

Rename ioc variable "dma_mask" to "is_dma_32bit" and use it to set 32
bit DMA.
---
v1 Change log:
1) Incorporated the review comments from Christoph Hellwig

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 83 ++++++++++++++-----------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  4 +-
 2 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 663782b..8e937c8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2806,55 +2806,40 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
 static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
-	u64 required_mask, coherent_mask;
 	struct sysinfo s;
-	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
+	char *desc = "64";
+	u64 consistent_dma_mask = DMA_BIT_MASK(64);
+	u64 required_mask = dma_get_required_mask(&pdev->dev);
 
-	if (ioc->is_mcpu_endpoint)
-		goto try_32bit;
-
-	required_mask = dma_get_required_mask(&pdev->dev);
-	if (sizeof(dma_addr_t) == 4 || required_mask == 32)
-		goto try_32bit;
-
-	if (ioc->dma_mask)
-		coherent_mask = DMA_BIT_MASK(dma_mask);
-	else
-		coherent_mask = DMA_BIT_MASK(32);
-
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, coherent_mask))
+	if (ioc->is_mcpu_endpoint || ioc->is_dma_32bit ||
+	    sizeof(dma_addr_t) == 4 || required_mask == DMA_BIT_MASK(32))
 		goto try_32bit;
-
-	ioc->base_add_sg_single = &_base_add_sg_single_64;
-	ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-	ioc->dma_mask = dma_mask;
-	goto out;
-
- try_32bit:
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	/*
+	 * Set 63 bit DMA mask for all SAS3 and SAS35 controllers
+	 */
+	if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
+		consistent_dma_mask = DMA_BIT_MASK(63);
+		desc = "63";
+	}
+	if (!dma_set_mask(&pdev->dev, consistent_dma_mask) &&
+	    !dma_set_coherent_mask(&pdev->dev, consistent_dma_mask)) {
+		ioc->base_add_sg_single = &_base_add_sg_single_64;
+		ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+		goto out;
+	}
+try_32bit:
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))
+	    && !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		ioc->base_add_sg_single = &_base_add_sg_single_32;
+		ioc->sge_size = sizeof(Mpi2SGESimple32_t);
+		desc = "32";
+	} else
 		return -ENODEV;
-
-	ioc->base_add_sg_single = &_base_add_sg_single_32;
-	ioc->sge_size = sizeof(Mpi2SGESimple32_t);
-	ioc->dma_mask = 32;
- out:
+out:
 	si_meminfo(&s);
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
-	}
+	ioc_info(ioc,
+		"%s BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
+		desc, convert_to_kb(s.totalram));
 	return 0;
 }
 
@@ -5169,14 +5154,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -7158,7 +7135,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->smp_affinity_enable = smp_affinity_enable;
 
 	ioc->rdpq_array_enable_assigned = 0;
-	ioc->dma_mask = 0;
+	ioc->is_dma_32bit = 0;
 	if (ioc->is_aero_ioc)
 		ioc->base_readl = &_base_readl_aero;
 	else
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e719715..396ac96 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1026,7 +1026,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @ir_firmware: IR firmware present
  * @bars: bitmask of BAR's that must be configured
  * @mask_interrupts: ignore interrupt
- * @dma_mask: used to set the consistent dma mask
+ * @is_dma_32bit: used to set the consistent dma mask
  * @pci_access_mutex: Mutex to synchronize ioctl, sysfs show path and
  *			pci resource handling
  * @fault_reset_work_q_name: fw fault work queue
@@ -1205,7 +1205,7 @@ struct MPT3SAS_ADAPTER {
 	u8		ir_firmware;
 	int		bars;
 	u8		mask_interrupts;
-	int		dma_mask;
+	int		is_dma_32bit;
 
 	/* fw fault handler */
 	char		fault_reset_work_q_name[20];
-- 
1.8.3.1

