Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906ECC352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E3A120848
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zr8feK0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgBKKSk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52849 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so2715248wmc.2
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uZCAv4JP0mR1y+dfUp2XBUcP5A7SC7sXiDA7eSjSXMI=;
        b=Zr8feK0v14Exb3MJFeYI1O9Z4YDWNs16WJrx6uQd8eisb4wOQBECZAQpH8W3gpnUWC
         /EM5boDA0a8GauM0KEavTjAhNvgj/czgI5YQwqEuf7MeDFf1g9/3vVdzI43a3QBfY/gM
         W05a+V6/z6MV/Qx92PL4+8f2E5ckDlJqryfyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uZCAv4JP0mR1y+dfUp2XBUcP5A7SC7sXiDA7eSjSXMI=;
        b=A69P4x/cwvLwga+R647mJEfQzX7aDol/RAbJQQ6CCH9pUY/9PbwRmxoo1VIUrvWY0+
         YW1Yc4IydsWGM7arciicIotdzt6XiMRQkC0FQbcY2Shjm0Z8KxSloONVNelV4Eo1OoxE
         4PW24PWiILpBlLmao7S6xKtqVB94o7BCxA5xNr7RsTF+sUVhmEzI76zotvfbq0CxG/zg
         ANKU5h1gxkMn/QHfIvfMRUZlP0ElCFm1MnzU64uRPUKbsKwTpgUxB5aUp0aD4V8e/bP/
         NsbWvYW1rSh34EaoTe2MWD4+0oRnc3tzM5XabyCSzhMPj/ZAYhsnVGQG22g99qC9K/tz
         kTPg==
X-Gm-Message-State: APjAAAXm9cGlvxnZK96ytrX/bopovmEXnFJk1tlNqIDym1/tWbtqEBXX
        qKmjQs5+vtkkQ5TWkav9DnSS7CpM3YswE8Kq5tzBfrkV33tX18raStolGxv05fbVRAFXSIIcYbH
        UUokfK/bTdQnXP3fbG7ifXXrVbx3k0AeSxty/Y0rjKGQ69aSP6aqfKhN7/acHvarUfbBh0fZ1Yb
        V0jZrCZMcCIVuzr/M/7t6bZSI=
X-Google-Smtp-Source: APXvYqznpyo2BiC7QfH1yamXRn/Ai1N3jJomHBn+Zw8/SR8qX2RRUjnLsXli0oa33BkE/6ZYA9y5XQ==
X-Received: by 2002:a7b:c94a:: with SMTP id i10mr4830060wml.88.1581416317348;
        Tue, 11 Feb 2020 02:18:37 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:36 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/5] mpt3sas: Don't change the dma coherent mask after  allocations
Date:   Tue, 11 Feb 2020 05:18:09 -0500
Message-Id: <1581416293-41610-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

During driver load ioc->dma_mask is set to 0. Since this
flag is not set, in _base_config_dma_addressing() driver
always sets 32 bit DMA and later after allocating memory
for RDPQ's the dma mask is set to 64/63 bit from
_base_change_consistent_dma_mask.

Removed Flag ioc->dma_mask and
_base_change_consistent_dma_mask().

Set coherent dma mask to 64/63/32 bit based on
controller at driver load time in _base_config_dma_addressing().
and If 63/64 bit fails attempt again with 32-bit DMA mask.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 82 ++++++++++++++-----------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 -
 2 files changed, 30 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 663782b..18c5045 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2806,55 +2806,42 @@ _base_build_sg_ieee(struct MPT3SAS_ADAPTER *ioc, void *psge,
 static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
-	u64 required_mask, coherent_mask;
 	struct sysinfo s;
-	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	int dma_mask = (ioc->hba_mpi_version_belonged > MPI2_VERSION) ? 63 : 64;
-
+	char *desc = "64";
+	u64 consistent_dma_mask = DMA_BIT_MASK(64);
 	if (ioc->is_mcpu_endpoint)
 		goto try_32bit;
 
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
-		goto try_32bit;
-
-	ioc->base_add_sg_single = &_base_add_sg_single_64;
-	ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-	ioc->dma_mask = dma_mask;
-	goto out;
-
- try_32bit:
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
+	if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
+		consistent_dma_mask = DMA_BIT_MASK(63);
+		desc = "63";
+	}
+	if (sizeof(dma_addr_t) > 4) {
+		const u64 required_mask = dma_get_required_mask(&pdev->dev);
+		if ((required_mask > DMA_BIT_MASK(32)) &&
+		    !pci_set_dma_mask(pdev, consistent_dma_mask) &&
+		    !pci_set_consistent_dma_mask(pdev,
+		    consistent_dma_mask)) {
+			ioc->base_add_sg_single = &_base_add_sg_single_64;
+			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+			goto out;
+		}
+	}
+try_32bit:
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+	    && !pci_set_consistent_dma_mask(pdev,
+	    DMA_BIT_MASK(32))) {
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
 
@@ -5169,14 +5156,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
 
@@ -7158,7 +7137,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
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

