Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AC9C2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659C820575
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UaR8v0+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636107AbgDON0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636101AbgDONZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:53 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F231DC061A0E
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:52 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t4so1229960plq.12
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Rf6x/KTTOIAwzoHwYKg3dCdH/l54Q/TaxTnrLHIz5bg=;
        b=UaR8v0+kDtirqidHg1iG0qd/aYFlktcnMX09huB4MQYTHNTOSWleFp4GE5tXttqjNS
         3pcCWQrT2OxYb8FybfX4kIYlFL6tdvbVMvxSpW5JQ6PrJcCH0+i4fep0CEIBi08Jq64i
         gdulCbte7sVeDgsw3zf4+YbsPkXin0WU0fa3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Rf6x/KTTOIAwzoHwYKg3dCdH/l54Q/TaxTnrLHIz5bg=;
        b=blegYvc6Tf9802Oeg5R8KQiKkNE4ZNgxQMdmLDdPFd/Dx9t+cQINzxl8teKRR8+m9g
         K7oVjHRFMbPzA6aC0wPEWI3fGaqscBWLEMB6arynPGTF7X/+zF+Vny5LFbXDHvdqiOlr
         48CU75JsOuHDIvOJMDZ0dl7REx8/zGqyaRsfauCgHbvAsVvIV+hxiADWH8lUOSD3KdLJ
         fjmTTdqGYUNCC9mPhhD5qm3IrhItW/F1HDVDEUgn2a5mWfgkcAPKk3HEk7O1tmpXlGfm
         RtRb+1Uc9arNg+rWotLDaJV9z08+l+FbpiVXkHPpG8JVpk6h1aaLir4d66OpTgtar69Y
         +H+Q==
X-Gm-Message-State: AGi0PuYu4fL0EL2H5Gw4cZvV56EGuh4p85Zo+mFh2hM6Gb8gghkQL/Vn
        S+fej1dR6GbN6wD1IimU/rANmnlS2m1fhU/pNEr0XZYnqaNC7F+o+432ulJYlcrw1LHwGNRmocL
        1PO64KBS/lw+SOkAgWiDItr/1sJHOlCxPVxcg42BZ4hrxKDVTZ/wULed2qOxNlw8DYWC4WQ1l2C
        vqnbpgUCfBA2IUCmaTxEmU
X-Google-Smtp-Source: APiQypLD//c/6CQw4bi9V3aHP4CGdDyZIqfq5RuCfoT0hJe3W+2Lcp+N1fOAYbEubdvyW9feDK8M1A==
X-Received: by 2002:a17:90a:3441:: with SMTP id o59mr5709106pjb.185.1586957151393;
        Wed, 15 Apr 2020 06:25:51 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:50 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4G region
Date:   Wed, 15 Apr 2020 09:25:24 -0400
Message-Id: <1586957125-19460-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..) and
VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..) should
be within 4 GB boundary. Driver uses limitation of VENTURA_SERIES to
manage INVADER_SERIES as well. So here driver is allocating the DMA able
memory for RDPQ's accordingly.

1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.
2) Check if allocated resources for RDPQ are in the same 4GB range.
3) If #2 is true, continue with 64 bit DMA and go to #6
4) If #2 is false, then free all the resources from #1.
5) Set DMA mask to 32 and allocate RDPQ's.
6) Proceed with driver loading and other allocations
---
v1 Change log:
1) Use one dma pool for RDPQ's, thus removes the logic of using second
dma pool with align.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 153 +++++++++++++++++++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   1 +
 2 files changed, 107 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 27c829e..add23d7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3345,7 +3345,6 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	pci_set_master(pdev);
 
-
 	if (_base_config_dma_addressing(ioc, pdev) != 0) {
 		ioc_warn(ioc, "no suitable DMA mask for %s\n", pci_name(pdev));
 		r = -ENODEV;
@@ -4812,8 +4811,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i = 0;
 	int j = 0;
+	int dma_alloc_count = 0;
 	struct chain_tracker *ct;
-	struct reply_post_struct *rps;
 
 	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -4855,29 +4854,34 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->reply_post) {
-		do {
-			rps = &ioc->reply_post[i];
-			if (rps->reply_post_free) {
-				dma_pool_free(
-				    ioc->reply_post_free_dma_pool,
-				    rps->reply_post_free,
-				    rps->reply_post_free_dma);
-				dexitprintk(ioc,
-					    ioc_info(ioc, "reply_post_free_pool(0x%p): free\n",
-						     rps->reply_post_free));
-				rps->reply_post_free = NULL;
+		dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
+				RDPQ_MAX_INDEX_IN_ONE_CHUNK);
+		for (i = 0; i < ioc->reply_queue_count; i++) {
+			if (i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0
+			    && dma_alloc_count) {
+				if (ioc->reply_post[i].reply_post_free) {
+					dma_pool_free(
+					    ioc->reply_post_free_dma_pool,
+					    ioc->reply_post[i].reply_post_free,
+					ioc->reply_post[i].reply_post_free_dma);
+					dexitprintk(ioc, ioc_info(ioc,
+					   "reply_post_free_pool(0x%p): free\n",
+					   ioc->reply_post[i].reply_post_free));
+					ioc->reply_post[i].reply_post_free =
+									NULL;
+				}
+				--dma_alloc_count;
 			}
-		} while (ioc->rdpq_array_enable &&
-			   (++i < ioc->reply_queue_count));
+		}
+		dma_pool_destroy(ioc->reply_post_free_dma_pool);
 		if (ioc->reply_post_free_array &&
 			ioc->rdpq_array_enable) {
 			dma_pool_free(ioc->reply_post_free_array_dma_pool,
-				ioc->reply_post_free_array,
-				ioc->reply_post_free_array_dma);
+			    ioc->reply_post_free_array,
+			    ioc->reply_post_free_array_dma);
 			ioc->reply_post_free_array = NULL;
 		}
 		dma_pool_destroy(ioc->reply_post_free_array_dma_pool);
-		dma_pool_destroy(ioc->reply_post_free_dma_pool);
 		kfree(ioc->reply_post);
 	}
 
@@ -4953,42 +4957,82 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 static int
 base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 {
-	int i;
+	int i = 0;
+	u32 dma_alloc_count = 0;
+	int reply_post_free_sz = ioc->reply_post_queue_depth *
+		sizeof(Mpi2DefaultReplyDescriptor_t);
 
 	ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
 	    (ioc->reply_queue_count):1,
 	    sizeof(struct reply_post_struct), GFP_KERNEL);
-
 	if (!ioc->reply_post) {
 		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
 		return -ENOMEM;
 	}
-	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
-			&ioc->pdev->dev, sz, 16, 0);
+	/*
+	 *  For INVADER_SERIES each set of 8 reply queues(0-7, 8-15, ..) and
+	 *  VENTURA_SERIES each set of 16 reply queues(0-15, 16-31, ..) should
+	 *  be within 4GB boundary i.e reply queues in a set must have same
+	 *  upper 32-bits in their memory address. so here driver is allocating
+	 *  the DMA'able memory for reply queues according.
+	 *  Driver uses limitation of
+	 *  VENTURA_SERIES to manage INVADER_SERIES as well.
+	 */
+	dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
+				RDPQ_MAX_INDEX_IN_ONE_CHUNK);
+	ioc->reply_post_free_dma_pool =
+		dma_pool_create("reply_post_free pool",
+		    &ioc->pdev->dev, sz, 16, 0);
 	if (!ioc->reply_post_free_dma_pool) {
 		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
 		return -ENOMEM;
 	}
-	i = 0;
-	do {
-		ioc->reply_post[i].reply_post_free =
-			dma_pool_zalloc(ioc->reply_post_free_dma_pool,
+	for (i = 0; i < ioc->reply_queue_count; i++) {
+		if ((i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0) && dma_alloc_count) {
+			ioc->reply_post[i].reply_post_free =
+			    dma_pool_alloc(ioc->reply_post_free_dma_pool,
 				GFP_KERNEL,
 				&ioc->reply_post[i].reply_post_free_dma);
-		if (!ioc->reply_post[i].reply_post_free) {
-			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
-			return -ENOMEM;
-		}
-		dinitprintk(ioc,
-			ioc_info(ioc, "reply post free pool (0x%p): depth(%d),"
-			    "element_size(%d), pool_size(%d kB)\n",
-			    ioc->reply_post[i].reply_post_free,
-			    ioc->reply_post_queue_depth, 8, sz / 1024));
-		dinitprintk(ioc,
-			ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
-			    (u64)ioc->reply_post[i].reply_post_free_dma));
+			if (!ioc->reply_post[i].reply_post_free) {
+				ioc_err(ioc, "reply_post_free pool: "
+				    "dma_pool_alloc failed\n");
+				return -ENOMEM;
+			}
+			/*
+			 * Each set of RDPQ pool must satisfy 4gb boundary
+			 * restriction.
+			 * 1) Check if allocated resources for RDPQ pool are in
+			 *	the same 4GB range.
+			 * 2) If #1 is true, continue with 64 bit DMA.
+			 * 3) If #1 is false, return 1. which means free all the
+			 * resources and set DMA mask to 32 and allocate.
+			 */
+			if (!mpt3sas_check_same_4gb_region(
+				(long)ioc->reply_post[i].reply_post_free, sz)) {
+				dinitprintk(ioc,
+				    ioc_err(ioc, "bad Replypost free pool(0x%p)"
+				    "reply_post_free_dma = (0x%llx)\n",
+				    ioc->reply_post[i].reply_post_free,
+				    (unsigned long long)
+				    ioc->reply_post[i].reply_post_free_dma));
+				return -EAGAIN;
+			}
+			memset(ioc->reply_post[i].reply_post_free, 0,
+						RDPQ_MAX_INDEX_IN_ONE_CHUNK *
+						reply_post_free_sz);
+			dma_alloc_count--;
 
-	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
+		} else {
+			ioc->reply_post[i].reply_post_free =
+			    (Mpi2ReplyDescriptorsUnion_t *)
+			    ((long)ioc->reply_post[i-1].reply_post_free
+			    + reply_post_free_sz);
+			ioc->reply_post[i].reply_post_free_dma =
+			    (dma_addr_t)
+			    (ioc->reply_post[i-1].reply_post_free_dma +
+			    reply_post_free_sz);
+		}
+	}
 	return 0;
 }
 
@@ -5006,10 +5050,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 chains_needed_per_io;
 	u32 sz, total_sz, reply_post_free_sz, reply_post_free_array_sz;
 	u32 retry_sz;
+	u32 rdpq_sz = 0;
 	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
 	u16 sge_size;
 	int i, j;
+	int ret = 0;
 	struct chain_tracker *ct;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
@@ -5163,14 +5209,28 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* reply post queue, 16 byte align */
 	reply_post_free_sz = ioc->reply_post_queue_depth *
 	    sizeof(Mpi2DefaultReplyDescriptor_t);
-
-	sz = reply_post_free_sz;
+	rdpq_sz = reply_post_free_sz * RDPQ_MAX_INDEX_IN_ONE_CHUNK;
 	if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
-		sz *= ioc->reply_queue_count;
-	if (base_alloc_rdpq_dma_pool(ioc, sz))
-		goto out;
-	total_sz += sz * (!ioc->rdpq_array_enable ? 1 : ioc->reply_queue_count);
-
+		rdpq_sz = reply_post_free_sz * ioc->reply_queue_count;
+	ret = base_alloc_rdpq_dma_pool(ioc, rdpq_sz);
+	if (ret == -EAGAIN) {
+		/*
+		 * Free allocated bad RDPQ memory pools.
+		 * Change dma coherent mask to 32 bit and reallocate RDPQ
+		 */
+		_base_release_memory_pools(ioc);
+		ioc->is_dma_32bit = 1;
+		if (_base_config_dma_addressing(ioc, ioc->pdev) != 0) {
+			ioc_err(ioc,
+			    "32 DMA mask failed %s\n", pci_name(ioc->pdev));
+			return -ENODEV;
+		}
+		if (base_alloc_rdpq_dma_pool(ioc, rdpq_sz))
+			return -ENOMEM;
+	} else if (ret == -ENOMEM)
+		return -ENOMEM;
+	total_sz = rdpq_sz * (!ioc->rdpq_array_enable ? 1 :
+	    DIV_ROUND_UP(ioc->reply_queue_count, RDPQ_MAX_INDEX_IN_ONE_CHUNK));
 	ioc->scsiio_depth = ioc->hba_queue_depth -
 	    ioc->hi_priority_depth - ioc->internal_depth;
 
@@ -5182,7 +5242,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_info(ioc, "scsi host: can_queue depth (%d)\n",
 			     ioc->shost->can_queue));
 
-
 	/* contiguous pool for request and chains, 16 byte align, one extra "
 	 * "frame for smid=0
 	 */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 396ac96..99724a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -367,6 +367,7 @@ struct mpt3sas_nvme_cmd {
 #define MPT3SAS_HIGH_IOPS_REPLY_QUEUES		8
 #define MPT3SAS_HIGH_IOPS_BATCH_COUNT		16
 #define MPT3SAS_GEN35_MAX_MSIX_QUEUES		128
+#define RDPQ_MAX_INDEX_IN_ONE_CHUNK		16
 
 /* OEM Specific Flags will come from OEM specific header files */
 struct Mpi2ManufacturingPage10_t {
-- 
1.8.3.1

