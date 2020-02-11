Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF59C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5A092086A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SCZDJUyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgBKKSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46484 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so11500206wrl.13
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Udb0vLFL2p9a7XpHfaYLI7isGZCzGKSPCbP9BsZThy4=;
        b=SCZDJUyuJob3lDvVsk2QFLZTb1120Z/PabYa20SlIo3Fih8F0i737Fumf2hP/Q4mKj
         N7iZMrMCTVnhgENF9Pv4H51kRUpkRJBe2aovW3tEFf0tvDn6Nb2osmQfGk28IOe4tQeO
         Msxwgv5+UkzQMYtAxgXOLsKN/4HJ0XOtPwUh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Udb0vLFL2p9a7XpHfaYLI7isGZCzGKSPCbP9BsZThy4=;
        b=Z2exzc74gp3fK3HKdliy+/58TmIUDi6pkNmy3YIwDES9szWqH8RtkZjdzs56InISTI
         itHkldFunyCqyyVVG5v/Dmp7A54nlIHi+mBjsnKk9WRsI8+7AZJVkusUJpKWngeMji5Z
         U2fkghoF7VMFe5pptuTCkixXeLlMm/wZEMeBxL7jX1bF6x+ZKqYTih9iv4dVLh6u+Bsc
         i5gATZI8kxuD0tO/grY8sJ2OutHbt88QYTxwBGiciRU1H/LhyVQFHP/JqtTcf7hhfqkI
         +5YESSPqH5151NdhV37hTD5sPsJS6UK+bl0437O92qx7zOmzBv/angOilkuvj+o04AzK
         hxJA==
X-Gm-Message-State: APjAAAXv6hlWEo+rCTDOjrTitpwBNTqBi2zvfcjwQS0vRZQ7AYZnrkf2
        M20gV3wVrWEKVewa3Ks+0RLK7M9axtN0ocbY0tOI/qCGb4VQ4l5Dg+0hZHnl4Uqq0pq7FCgRu18
        eocjvAHKjgoCiao+9aoJAeqVSu4gKUlzb/iOhNVjay7bhboqgIK2L2h7oi6iTDP7jmUX0G5J9e5
        x9Qe8AlubE+r6GrifXW1Kayg8=
X-Google-Smtp-Source: APXvYqxGUq0VAUQeJpPhzw/9z6F7enB/Gnd1o5MdBLekpAXh7+WkaHCRZCSLNoXuo2ntJW8T6P6B7Q==
X-Received: by 2002:adf:a39a:: with SMTP id l26mr7654347wrb.211.1581416326872;
        Tue, 11 Feb 2020 02:18:46 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:46 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4g region
Date:   Tue, 11 Feb 2020 05:18:12 -0500
Message-Id: <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..)and
VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..)should
be within 4 GB boundary.Driver uses limitation of VENTURA_SERIES
to manage INVADER_SERIES as well. So here driver is allocating the DMA
able memory for RDPQ's accordingly.

For RDPQ buffers, driver creates two separate pci pool.
"reply_post_free_dma_pool" and "reply_post_free_dma_pool_align"
First driver tries allocating memory from the pool
"reply_post_free_dma_pool", if the requested allocation are
within same 4gb region then proceeds for next allocations.
If not, allocates from reply_post_free_dma_pool_align which is
size aligned and if success, it will always meet same 4gb region
requirement

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 167 ++++++++++++++++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   3 +
 2 files changed, 123 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8739310..7d10dd8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4814,8 +4814,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i = 0;
 	int j = 0;
+	int dma_alloc_count = 0;
 	struct chain_tracker *ct;
-	struct reply_post_struct *rps;
 
 	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -4857,29 +4857,35 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
+							&& dma_alloc_count) {
+				if (ioc->reply_post[i].reply_post_free) {
+					pci_pool_free(
+					    ioc->reply_post[i].dma_pool,
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
+		dma_pool_destroy(ioc->reply_post_free_dma_pool_align);
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
 
@@ -4955,42 +4961,108 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 static int
 base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 {
-	int i;
+	int i = 0;
+	u32 dma_alloc_count = 0;
+	int reply_post_free_sz = ioc->reply_post_queue_depth *
+		sizeof(Mpi2DefaultReplyDescriptor_t);
 
 	ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
-	    (ioc->reply_queue_count):1,
-	    sizeof(struct reply_post_struct), GFP_KERNEL);
-
+				(ioc->reply_queue_count):1,
+				sizeof(struct reply_post_struct), GFP_KERNEL);
 	if (!ioc->reply_post) {
 		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
 		return -ENOMEM;
 	}
-	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
-	    &ioc->pdev->dev, sz, 16, 0);
-	if (!ioc->reply_post_free_dma_pool) {
+	/*
+	 *  For INVADER_SERIES each set of 8 reply queues(0-7, 8-15, ..) and
+	 *  VENTURA_SERIES each set of 16 reply queues(0-15, 16-31, ..) should
+	 *  be within 4GB boundary and also reply queues in a set must have same
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
+	ioc->reply_post_free_dma_pool_align =
+		dma_pool_create("reply_post_free pool",
+		    &ioc->pdev->dev, sz, roundup_pow_of_two(sz), 0);
+	if (!ioc->reply_post_free_dma_pool ||
+	     !ioc->reply_post_free_dma_pool_align) {
 		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
 		return -ENOMEM;
 	}
-	i = 0;
-	do {
-		ioc->reply_post[i].reply_post_free =
-		    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
-		    GFP_KERNEL,
-		    &ioc->reply_post[i].reply_post_free_dma);
-		if (!ioc->reply_post[i].reply_post_free) {
-			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
-			return -ENOMEM;
-		}
-		dinitprintk(ioc,
-		    ioc_info(ioc, "reply post free pool (0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
-		    ioc->reply_post[i].reply_post_free,
-		    ioc->reply_post_queue_depth,
-		    8, sz / 1024));
-		dinitprintk(ioc,
-		    ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
-		    (u64)ioc->reply_post[i].reply_post_free_dma));
+	for (i = 0; i < ioc->reply_queue_count; i++) {
+		if ((i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0) && dma_alloc_count) {
+			ioc->reply_post[i].reply_post_free =
+				dma_pool_alloc(ioc->reply_post_free_dma_pool,
+				    GFP_KERNEL,
+				    &ioc->reply_post[i].reply_post_free_dma);
+			if (!ioc->reply_post[i].reply_post_free) {
+				ioc_err(ioc, "reply_post_free pool: "
+				    "dma_pool_alloc failed\n");
+				return -ENOMEM;
+			}
+		/* reply desc pool requires to be in same 4 gb region.
+		 * Below function will check this.
+		 * In case of failure, new pci pool will be created with updated
+		 * alignment.
+		 * For RDPQ buffers, driver allocates two separate pci pool.
+		 * Alignment will be used such a way that next allocation if
+		 * success, will always meet same 4gb region requirement.
+		 * Flag dma_pool keeps track of each buffers pool,
+		 * It will help driver while freeing the resources.
+		 */
+			if (!mpt3sas_check_same_4gb_region(
+				(long)ioc->reply_post[i].reply_post_free, sz)) {
+				dinitprintk(ioc,
+				    ioc_err(ioc, "bad Replypost free pool(0x%p)"
+				    "reply_post_free_dma = (0x%llx)\n",
+				    ioc->reply_post[i].reply_post_free,
+				    (unsigned long long)
+				    ioc->reply_post[i].reply_post_free_dma));
+
+				pci_pool_free(ioc->reply_post_free_dma_pool,
+				    ioc->reply_post[i].reply_post_free,
+				    ioc->reply_post[i].reply_post_free_dma);
+
+				ioc->reply_post[i].reply_post_free = NULL;
+				ioc->reply_post[i].reply_post_free_dma = 0;
+				//Retry with modified alignment
+				ioc->reply_post[i].reply_post_free =
+					dma_pool_alloc(
+					    ioc->reply_post_free_dma_pool_align,
+					    GFP_KERNEL,
+				    &ioc->reply_post[i].reply_post_free_dma);
+				if (!ioc->reply_post[i].reply_post_free) {
+					ioc_err(ioc, "reply_post_free pool: "
+					    "pci_pool_alloc failed\n");
+					return -ENOMEM;
+				}
+				ioc->reply_post[i].dma_pool =
+				    ioc->reply_post_free_dma_pool_align;
+			} else
+				ioc->reply_post[i].dma_pool =
+				    ioc->reply_post_free_dma_pool;
+			memset(ioc->reply_post[i].reply_post_free, 0,
+			    RDPQ_MAX_INDEX_IN_ONE_CHUNK *
+			    reply_post_free_sz);
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
 
@@ -5008,6 +5080,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 chains_needed_per_io;
 	u32 sz, total_sz, reply_post_free_sz, reply_post_free_array_sz;
 	u32 retry_sz;
+	u32 rdpq_sz = 0;
 	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
 	u16 sge_size;
@@ -5164,12 +5237,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	/* reply post queue, 16 byte align */
 	reply_post_free_sz = ioc->reply_post_queue_depth *
 	    sizeof(Mpi2DefaultReplyDescriptor_t);
-	sz = reply_post_free_sz;
+	rdpq_sz = reply_post_free_sz * RDPQ_MAX_INDEX_IN_ONE_CHUNK;
 	if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
-		sz *= ioc->reply_queue_count;
-	if (base_alloc_rdpq_dma_pool(ioc, sz))
+		rdpq_sz = reply_post_free_sz * ioc->reply_queue_count;
+	if (base_alloc_rdpq_dma_pool(ioc, rdpq_sz))
 		goto out;
-	total_sz += sz;
+	total_sz += rdpq_sz;
 
 	ioc->scsiio_depth = ioc->hba_queue_depth -
 	    ioc->hi_priority_depth - ioc->internal_depth;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index caae040..30ca583 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -367,6 +367,7 @@ struct mpt3sas_nvme_cmd {
 #define MPT3SAS_HIGH_IOPS_REPLY_QUEUES		8
 #define MPT3SAS_HIGH_IOPS_BATCH_COUNT		16
 #define MPT3SAS_GEN35_MAX_MSIX_QUEUES		128
+#define RDPQ_MAX_INDEX_IN_ONE_CHUNK		16
 
 /* OEM Specific Flags will come from OEM specific header files */
 struct Mpi2ManufacturingPage10_t {
@@ -1006,6 +1007,7 @@ struct mpt3sas_port_facts {
 struct reply_post_struct {
 	Mpi2ReplyDescriptorsUnion_t	*reply_post_free;
 	dma_addr_t			reply_post_free_dma;
+	struct dma_pool			*dma_pool;
 };
 
 typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
@@ -1423,6 +1425,7 @@ struct MPT3SAS_ADAPTER {
 	u8		rdpq_array_enable;
 	u8		rdpq_array_enable_assigned;
 	struct dma_pool *reply_post_free_dma_pool;
+	struct dma_pool	*reply_post_free_dma_pool_align;
 	struct dma_pool *reply_post_free_array_dma_pool;
 	Mpi2IOCInitRDPQArrayEntry *reply_post_free_array;
 	dma_addr_t reply_post_free_array_dma;
-- 
1.8.3.1

