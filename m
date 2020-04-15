Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A32C2BB55
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D1720575
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 13:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BXqV4ofF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636105AbgDON0A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636100AbgDONZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 09:25:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7665CC061A0C
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 201so31741pfv.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 06:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a2Gcyt2zwERLVsg6RPGuiJE6CP/cWE63hYsQKWCW1ao=;
        b=BXqV4ofFVhVJFUKww4RTson2lu9JKdQpqNdKOgG+JxrqMHkVqt84lQNuXMYErT7jaL
         /vSaVL7amxOxvU90H7FHqZiMpqOb05l3M7obyRYR3t8Mvp1Pm9KHSYmXlibu0SmqkR82
         5N2D7J5qruSc8pvx7vZvlDqRW8LFt4hmpz3mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a2Gcyt2zwERLVsg6RPGuiJE6CP/cWE63hYsQKWCW1ao=;
        b=LTQM4X6NvhIyVI5GzP5Pigy1xP7TjKOWYXsdkV5hrrNO9Wm6ScmN9Je5OohKDAOC9J
         SO/XB8xREqjyHu/Tn2yidNhyxxyz9Q0b3Oi7Fxfhv62FvjiFFP0FKni7l3rRDUCTt62n
         vggQmgkA5S8PCadRB7myX5BRjq1v6NxvZcqxpAcPS4a65fLJ78weaHusOztfzwTJAWL1
         4xVy9IbSPRd5y+bSI+jemY73oQsQO+JDnFy/Ovf9cXiz0ct6SZKXLK9DMJtdBAjtdZWG
         d5TZbomTh5DB2qFPvWUyrSLeKS6KTsuw2ALxnHgdlBVDr9+St9SuvxRdxhzxc+hT1bO2
         RcQw==
X-Gm-Message-State: AGi0Pubgik4YpPsq+V73QSp0R8d3LgKZ4MbF/LXjSDgnz3jtUxYbxFFS
        b3a+wYFgRTLWPmJQ+fx9fkXRdcGXXAw4/Tk27HgQoiTXyTS4sxidbJ5zLCkHNan/UTXVbw3/IDS
        qPp1/PELMdVnwEgNKUE/FrAESJtsB5Rckey1BDCn1P52yqtnW5kHPkVuT+xmZJKD31orakb0wkO
        ILOqTMi9J3m9/pqBZVuccj
X-Google-Smtp-Source: APiQypIbw5tkFAwp9HaabXM/ZwhpwSHFdAJVF4XwiZ5WZI8UgF1UzzjNOi3hcgGrPBN0abxQOXZC+A==
X-Received: by 2002:a65:4b8d:: with SMTP id t13mr7522927pgq.388.1586957148529;
        Wed, 15 Apr 2020 06:25:48 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x186sm13715556pfb.151.2020.04.15.06.25.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 06:25:47 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1 3/5] mpt3sas: Separate out RDPQ allocation to new function.
Date:   Wed, 15 Apr 2020 09:25:23 -0400
Message-Id: <1586957125-19460-4-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

For readability separate out RDPQ allocations to new function
base_alloc_rdpq_dma_pool().

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 85 ++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7f7b5af..27c829e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4944,6 +4944,55 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
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
+			&ioc->pdev->dev, sz, 16, 0);
+	if (!ioc->reply_post_free_dma_pool) {
+		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
+		return -ENOMEM;
+	}
+	i = 0;
+	do {
+		ioc->reply_post[i].reply_post_free =
+			dma_pool_zalloc(ioc->reply_post_free_dma_pool,
+				GFP_KERNEL,
+				&ioc->reply_post[i].reply_post_free_dma);
+		if (!ioc->reply_post[i].reply_post_free) {
+			ioc_err(ioc, "reply_post_free pool: dma_pool_alloc failed\n");
+			return -ENOMEM;
+		}
+		dinitprintk(ioc,
+			ioc_info(ioc, "reply post free pool (0x%p): depth(%d),"
+			    "element_size(%d), pool_size(%d kB)\n",
+			    ioc->reply_post[i].reply_post_free,
+			    ioc->reply_post_queue_depth, 8, sz / 1024));
+		dinitprintk(ioc,
+			ioc_info(ioc, "reply_post_free_dma = (0x%llx)\n",
+			    (u64)ioc->reply_post[i].reply_post_free_dma));
+
+	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));
+	return 0;
+}
+
+/**
  * _base_allocate_memory_pools - allocate start of day memory pools
  * @ioc: per adapter object
  *
@@ -5118,41 +5167,9 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
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

