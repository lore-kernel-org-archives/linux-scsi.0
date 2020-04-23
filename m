Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E17FC2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD9E20736
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gTXDOuQG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgDWHXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:23:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22386C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so5386346wmg.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R3THRl3KgnbLuD68f3CjfeAS6X01pZTMWvpwEQpO/84=;
        b=gTXDOuQGgDIW37QUoud9nCFARAGDbYsmzD4aPH2j+I0F7omVFghkWJLvocqNWFPhI7
         //cg/jL9NIg88quvfhtY+/X6UvVaFeyoXQFVYaPVjv94b6FEelTLfHmFyPkeIJdpzZST
         R3ieepgmqe8SCPe6bc8VPkgqBw50RtORM15Ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R3THRl3KgnbLuD68f3CjfeAS6X01pZTMWvpwEQpO/84=;
        b=m3JlTynY15KXHj0pSmYlJf1Ge3azAb/X80KXXe3bvzenbYwdZ/WmlWeXIlB0MHz01K
         fc+fv1ZVeEbRf1RM0zhmSbII/50kkv4buurVCiNIWxRsln3Nn8RQLWyMfTTLJqOutq3i
         zjJf1igADuesvLWCq9G9gF4Vf3jCNoUSiq9TN3UC2r2jfwXDd5HVZ9HkJDdOrhbc92Uq
         A3iGsvcSFnl3fkqVXDmsfVpiAHFVErf2wKoQszxN5NuGgtCdv131oW9nUqX0PhOhUf38
         GAYS21XRktJ8/8vHk8qgbCeOc72N+7J/JfM5QkQKhur3E+Akz7RWo2rwd8zaRD+ooO4X
         qvlw==
X-Gm-Message-State: AGi0PuaN8i92ryCOlfFjteijv5hRsViy7Py/UKKdN3sFqAYpZ6Ma/Kzx
        gHg93//YFSDwX4kwoTZvtwpYQtwTKTnyejk25f/nagqvqna0aA9ICSLO/YXBRnREzQ0EtE7/rGV
        N8a+C/AX3XpNqtJemqHsIMO5C2CBV9Ml02+4pbvvEj/9PN9a9551cNt6xN0UTS+D9q00TqciIwx
        sSxfl4IB//WBZhdldOBgkT
X-Google-Smtp-Source: APiQypJ1JylOvNw6VoiyrPIPY+/3JAcogUqnne+M6LQqtgDgFF6TN7m0BZvxBM1fadMOw/OHwrj8Iw==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr2643328wmj.33.1587626626296;
        Thu, 23 Apr 2020 00:23:46 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l4sm2336130wrw.25.2020.04.23.00.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 00:23:45 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [v2 1/5] mpt3sas: don't change the dma coherent mask after allocations
Date:   Thu, 23 Apr 2020 03:23:12 -0400
Message-Id: <1587626596-1044-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The DMA layer does not allow changing the DMA coherent mask after
there are outstanding allocations.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
v2:
 Initial patch was always setting dma coherent mask to 32 bit,
 now dma coherent mask is setting to either 32 bit or 63/64 bit
 based on controller capability.

 drivers/scsi/mpt3sas/mpt3sas_base.c | 67 +++++++++++--------------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 --
 2 files changed, 19 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 663782b..b8679c2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2806,58 +2806,38 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
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
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(dma_mask)))
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
+		dma_mask, convert_to_kb(s.totalram));
 
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
@@ -5169,14 +5149,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -7158,7 +7130,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->smp_affinity_enable = smp_affinity_enable;
 
 	ioc->rdpq_array_enable_assigned = 0;
-	ioc->dma_mask = 0;
 	if (ioc->is_aero_ioc)
 		ioc->base_readl = &_base_readl_aero;
 	else
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index e719715..caae040 100644
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
1.8.3.1

