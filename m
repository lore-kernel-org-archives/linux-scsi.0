Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7E0C54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C3A121569
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BiuKwomK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgDWHXy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:23:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F87C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so5563207wrx.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lG2q/QVtnvqMp4mcm6tsbyphrWNYMrYVz4nqzr6vz2Q=;
        b=BiuKwomKvsPSS6HeRgk3ySQ52wPr04Tnon/4ypUoMNISXYbNXZb0yghNPbGsXA4Kcd
         FaQ5XAyrbzYX1v6mKZfQdpfsnlVaS3gHnIB8qaJr48Mnl3wQ+eKY3ai0wvV418KODdO0
         x5lTW6gn4VAnsUWGLsfCj67sNV2IOe7/rJDfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lG2q/QVtnvqMp4mcm6tsbyphrWNYMrYVz4nqzr6vz2Q=;
        b=MSMX/YtcwVMFcsYmi7JTSQztBU8MGZ41KdXRxOxQppFl10EdCqR9O2RSIwrRtfOEiE
         A/WWRneUtfJ+/ayuMk+PWdfwf264Z7nPTx+hpe1zARcXYRjVAVv1PktzCg56qaHH2Zkj
         HsfYhBbll4yz+luTlYwWj4S9BFQ5RFpAGB/gtnsZMT+tkkqpBiV025DiN28CDXdxdNAg
         w57ehUAncPP/62GKlXTQJT9c9Gsq4edHG0I3hZvHRK6tbR4S5CJM0kYuLXNKE9i3T7o2
         akrJqq1pQZe2iagFx5O16NXSi64V1DUALXipOdZEPK2xQ8dj59Ic7EkIbw7NYqcfB8nT
         qfng==
X-Gm-Message-State: AGi0PuZDYdIC1DdmCmNJG7QXjtbIBn+AXzo2pr4MZNOL5rF9XXQEisPY
        8TTYauAvKZKBdlEzh0utoDfDuuTXc61mcBs7nARqhgbQCZhVLUFEtoQXeuFLaGmHa9xxOo4KWdD
        O1LMAcaJf8L5CNOo9Sqa0EqR6OC4TfP5hDmuCIFUIpduOj+6/+qYiqWjMg/xq2jSY3Q0O6xKSZu
        bD5AXdg5YAoSyKYnsmzzL6
X-Google-Smtp-Source: APiQypLTmWyElN7lS8w4J0cja8/fZ1pGtjEwabDJX0/Toalf92yqIOYr13QXzbf1FMLHJ8h2206Rbg==
X-Received: by 2002:adf:f0cb:: with SMTP id x11mr3330874wro.266.1587626631908;
        Thu, 23 Apr 2020 00:23:51 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l4sm2336130wrw.25.2020.04.23.00.23.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 00:23:51 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v2 3/5] mpt3sas: Separate out RDPQ allocation to new function.
Date:   Thu, 23 Apr 2020 03:23:14 -0400
Message-Id: <1587626596-1044-4-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For readability separate out RDPQ allocations to new function
base_alloc_rdpq_dma_pool().

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 79 +++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f98c7f6..0588941 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4939,6 +4939,49 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
 }
 
 /**
+ * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
+ *                     for reply queues.
+ * @ioc: per adapter object
+ * @sz: DMA Pool size
+ * Return: 0 for success, non-zero for failure.
+ */
+static int
+base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
+{
+	int i;
+	int count = ioc->rdpq_array_enable ? ioc->reply_queue_count : 1;
+
+	ioc->reply_post = kcalloc(count, sizeof(struct reply_post_struct),
+			GFP_KERNEL);
+	if (!ioc->reply_post)
+		return -ENOMEM;
+	ioc->reply_post_free_dma_pool =
+	    dma_pool_create("reply_post_free pool",
+	    &ioc->pdev->dev, sz, 16, 0);
+	if (!ioc->reply_post_free_dma_pool)
+		return -ENOMEM;
+	i = 0;
+	do {
+		ioc->reply_post[i].reply_post_free =
+		    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
+		    GFP_KERNEL,
+		    &ioc->reply_post[i].reply_post_free_dma);
+		if (!ioc->reply_post[i].reply_post_free)
+			return -ENOMEM;
+		dinitprintk(ioc,
+			ioc_info(ioc, "reply post free pool (0x%p): depth(%d),"
+			    "element_size(%d), pool_size(%d kB)\n",
+			    ioc->reply_post[i].reply_post_free,
+			    ioc->reply_post_queue_depth, 8, sz / 1024));
+		dinitprintk(ioc,
+			ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
+			    (u64)ioc->reply_post[i].reply_post_free_dma));
+
+	} while (ioc->rdpq_array_enable && ++i < ioc->reply_queue_count);
+	return 0;
+}
+
+/**
  * _base_allocate_memory_pools - allocate start of day memory pools
  * @ioc: per adapter object
  *
@@ -5113,41 +5156,9 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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
+	if (base_alloc_rdpq_dma_pool(ioc, sz))
 		goto out;
-	}
-	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
-	    &ioc->pdev->dev, sz, 16, 0);
-	if (!ioc->reply_post_free_dma_pool) {
-		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
-		goto out;
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
+	total_sz += sz * (!ioc->rdpq_array_enable ? 1 : ioc->reply_queue_count);
 
 	ioc->scsiio_depth = ioc->hba_queue_depth -
 	    ioc->hi_priority_depth - ioc->internal_depth;
-- 
1.8.3.1

