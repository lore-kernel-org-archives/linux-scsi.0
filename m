Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA15C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C5C20842
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 10:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cBKdwlyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgBKKSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:18:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33489 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgBKKSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 05:18:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so1918821wmc.0
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 02:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mg77+Vkmr1pxwidUzM/drgkbfNBSA8a+O8NQjwl4X+o=;
        b=cBKdwlyqEZA43xibeY0G78wbCeu7gHlZ7hpiDCHxXxxSrDOKni/meY9HiuyvRVqwxf
         ZAA+9d9PhDjj86NGYxEigQ8tG4g6q+14lwdgllTTHWf6GB/r0YZ9Yexocg9LoI570RC7
         KwbZoWLq+5i56l8/zFEd5Q/S9mHmgOSy628G0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mg77+Vkmr1pxwidUzM/drgkbfNBSA8a+O8NQjwl4X+o=;
        b=cCpPwJMkVZlxfgrxRSETBvt+YuOgqdKAnrcpgN4rsFhMnHDvuVumzc9rYJPCKm2L+H
         H/UovdmkMZ8WoaO7OEXzsfA3nY/mnyzbVEKC+vN9gY//nvtxdQTw42VR40mdoZm126qJ
         9MOEBRvgrW2hpxMkM0GA8Ff4wUOorHl6EiUZPPP+C/JYBj4FsnQVvt+dLHCHQP8ocMw2
         kAkIRUq3SLuGO99sJrXD3SGqthjzYqfaYVcGb1jDHvaxpRis3yxLJ0JQy0na9ZxbW4YM
         yHqCsHxlrMQsFM+scCApU3p/+G9mrsRmYGCPvv+53maGDG6mA8kQf+sTnzBFHiRb5/KY
         D2VQ==
X-Gm-Message-State: APjAAAXvuO2fM5H16oIH/cIrn45YzuAJZZpOVZ24chcneCVkvzn4ytTg
        S5hKzh+HofQhHFdodhnu/CxX71u9KEDWdcC97VPuUtSos1tG/Wcgvp90lpFzv8b1dkYOVCVHmV/
        WXeB/FJK743nfNxO5fgwqAJN2tK5zOGsK87qoqoSkfOxuOkD+v70qKzx2avQaKSLpCGkaTSMwTc
        HC/QfpIxrh0txk8EFZx+qYgfw=
X-Google-Smtp-Source: APXvYqxrkf/Sy0UaaPSamntYbVxD5j58e0OOdnP43ORoI3LU5h1g6Ncku6desuVNxnKanSVf0j0jSA==
X-Received: by 2002:a1c:670a:: with SMTP id b10mr3826038wmc.2.1581416323627;
        Tue, 11 Feb 2020 02:18:43 -0800 (PST)
Received: from dhcp-10-123-20-55.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f65sm3058895wmf.29.2020.02.11.02.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 02:18:43 -0800 (PST)
From:   suganath-prabu.subramani@broadcom.com
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, kashyap.desai@broadcom.com,
        sathya.prakash@broadcom.com, martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 3/5] mpt3sas: Code Refactoring.
Date:   Tue, 11 Feb 2020 05:18:11 -0500
Message-Id: <1581416293-41610-4-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

Separate out RDPQ allocations to
new function base_alloc_rdpq_dma_pool().

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 88 +++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4718b86..8739310 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4946,6 +4946,55 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 }
 
 /**
+ * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
+ *			for reply queues.
+ * @ioc: er object
+ * @sz: DMA Pool size
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
+{
+	int i;
+
+	ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
+	    (ioc->reply_queue_count):1,
+	    sizeof(struct reply_post_struct), GFP_KERNEL);
+
+	if (!ioc->reply_post) {
+		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
+		return -ENOMEM;
+	}
+	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
+	    &ioc->pdev->dev, sz, 16, 0);
+	if (!ioc->reply_post_free_dma_pool) {
+		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
+		return -ENOMEM;
+	}
+	i = 0;
+	do {
+		ioc->reply_post[i].reply_post_free =
+		    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
+		    GFP_KERNEL,
+		    &ioc->reply_post[i].reply_post_free_dma);
+		if (!ioc->reply_post[i].reply_post_free) {
+			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
+			return -ENOMEM;
+		}
+		dinitprintk(ioc,
+		    ioc_info(ioc, "reply post free pool (0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
+		    ioc->reply_post[i].reply_post_free,
+		    ioc->reply_post_queue_depth,
+		    8, sz / 1024));
+		dinitprintk(ioc,
+		    ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
+		    (u64)ioc->reply_post[i].reply_post_free_dma));
+
+	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
+	return 0;
+}
+
+/**
  * _base_allocate_memory_pools - allocate start of day memory pools
  * @ioc: per adapter object
  *
@@ -5112,49 +5161,15 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	    ioc->max_sges_in_chain_message,
 	    ioc->shost->sg_tablesize,
 	    ioc->chains_needed_per_io);
-
 	/* reply post queue, 16 byte align */
 	reply_post_free_sz = ioc->reply_post_queue_depth *
 	    sizeof(Mpi2DefaultReplyDescriptor_t);
-
 	sz = reply_post_free_sz;
 	if (_base_is_controller_msix_enabled(ioc) && !ioc->rdpq_array_enable)
 		sz *= ioc->reply_queue_count;
-
-	ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
-	    (ioc->reply_queue_count):1,
-	    sizeof(struct reply_post_struct), GFP_KERNEL);
-
-	if (!ioc->reply_post) {
-		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
-		goto out;
-	}
-	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
-	    &ioc->pdev->dev, sz, 16, 0);
-	if (!ioc->reply_post_free_dma_pool) {
-		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
+	if (base_alloc_rdpq_dma_pool(ioc, sz))
 		goto out;
-	}
-	i = 0;
-	do {
-		ioc->reply_post[i].reply_post_free =
-		    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
-		    GFP_KERNEL,
-		    &ioc->reply_post[i].reply_post_free_dma);
-		if (!ioc->reply_post[i].reply_post_free) {
-			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
-			goto out;
-		}
-		dinitprintk(ioc,
-			    ioc_info(ioc, "reply post free pool (0x%p): depth(%d), element_size(%d), pool_size(%d kB)\n",
-				     ioc->reply_post[i].reply_post_free,
-				     ioc->reply_post_queue_depth,
-				     8, sz / 1024));
-		dinitprintk(ioc,
-			    ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
-				     (u64)ioc->reply_post[i].reply_post_free_dma));
-		total_sz += sz;
-	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
+	total_sz += sz;
 
 	ioc->scsiio_depth = ioc->hba_queue_depth -
 	    ioc->hi_priority_depth - ioc->internal_depth;
@@ -5167,7 +5182,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		    ioc_info(ioc, "scsi host: can_queue depth (%d)\n",
 			     ioc->shost->can_queue));
 
-
 	/* contiguous pool for request and chains, 16 byte align, one extra "
 	 * "frame for smid=0
 	 */
-- 
1.8.3.1

