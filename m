Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134A6C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF4B2075F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JvfARzm7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403894AbgE1O4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 10:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403888AbgE1O4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 10:56:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69621C08C5C6
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 07:56:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so3535479wmd.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 07:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=11trXhx1ObAnPnsXr5JbbH9wIHK+6CYsXvqavtjqzHE=;
        b=JvfARzm7r9CnWCjTS3YG+RjLrKTyXepDJUATKUtCNGQ1I7V8F/A//xk0nuEbqL4NM5
         bx8VVTk7fWPsRkaS8u/GRUEeE8lNlStkvW7mBJRl4L0pfyIXwiEh+mAuCbjVdieJbt8M
         0YelSC4y6nK5qu9bdkBEHZ1p1Af7PRgEo2mZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=11trXhx1ObAnPnsXr5JbbH9wIHK+6CYsXvqavtjqzHE=;
        b=EuiIjsnAg+jqwxcR97tV9cNre/J7EM7/+uj3snJYeefxdpayhzByPFh9fTKNJ4+pLZ
         uNoHST+x4AI5KDG7HzKaEBbc5yyaRaHgrew8CqRlLA1mCogRnB2f6FXjzkTp3AR16wCJ
         XJD9RRvS9j0bLNQRhGzJbqH+7fElQ+EAXTFOD0TiAeWZqD7IOCKv7lwpDZ5QkTqxmRt8
         MrK6kHstRPmE9unfZJMcknQYyg3CeZauk4cOkKA1HtLKAOIbvq5g8Y6+lRV/dnLRwXvF
         uSsWpIsVLWTQ1I9TRedaCjzbO/qls4YwbAojFFwLgBF7ZV+gC+9SJAd+McfTOjLoVc6r
         2hlw==
X-Gm-Message-State: AOAM5303YSM+7WK/OicoNcKSN83vKCru66Zg0NdQVBk0hpeJnKG4pqFY
        +Mzet+sQFsubtFXvRhfRMmjNEbZsqrFo8DYc721BqsJxH3wfQlDH5OO86jFrvXOlaQd83tSCY9I
        GvLFAZU4NqlMbgwqOe3CN4eXZJBUP9HLKCPYvvGk2P5wcSrlsBnZOwh/oH4Z5G+hyQL6+quayQB
        v4hsBDBXAYExXYJDtFF9g3Cdo=
X-Google-Smtp-Source: ABdhPJyW4nvQ4lowppyvtA7VOQkjn9ce8/B7+AfPvX8/VxXYNt7nFC0YD5BF9nDOQRsvRrUtbzdSWQ==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr3561819wmk.96.1590677805623;
        Thu, 28 May 2020 07:56:45 -0700 (PDT)
Received: from dhcp-10-123-20-28.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v2sm6264926wrn.21.2020.05.28.07.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:56:44 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, thenzl@redhat.com,
        martin.petersen@oracle.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Fix memset in non-rdpq mode.
Date:   Thu, 28 May 2020 10:56:17 -0400
Message-Id: <20200528145617.27252-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace dma_pool_alloc and memset with dma_pool_zalloc.
This fixes memset accessing out of range address when reply_queue
count is less than RDPQ_MAX_INDEX_IN_ONE_CHUNK (i.e. 16) in non-RDPQ
mode.

In non-RDPQ mode, the driver allocates a single contiguous pool of
size reply_queue's count * reqly_post_free_sz. But here the driver is
always memsetting this pool with size 16 *  reqly_post_free_sz. so if
reply queue count is less then 16 (i.e. when msix vectors enabled is
less then 16) then the driver is accessing out of range address and
this results in 'BUG: unable to handle kernel paging request at
fff0x...x' bug.

This bug got introduced from below commit id,
commit 8012209eb26b7819385a6ec6eae4b1d0a0dbe585 ("scsi: mpt3sas:
Handle RDPQ DMA allocation in same 4G region")

To fix this out of range access, the driver uses dma_pool_zalloc API
to allocate the pool. so that this pool will be initialized with zeros
of actual pool size by this API itself

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index beaea19..96b78fd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4984,7 +4984,7 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 	for (i = 0; i < count; i++) {
 		if ((i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0) && dma_alloc_count) {
 			ioc->reply_post[i].reply_post_free =
-			    dma_pool_alloc(ioc->reply_post_free_dma_pool,
+			    dma_pool_zalloc(ioc->reply_post_free_dma_pool,
 				GFP_KERNEL,
 				&ioc->reply_post[i].reply_post_free_dma);
 			if (!ioc->reply_post[i].reply_post_free)
@@ -5008,9 +5008,6 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 				    ioc->reply_post[i].reply_post_free_dma));
 				return -EAGAIN;
 			}
-			memset(ioc->reply_post[i].reply_post_free, 0,
-						RDPQ_MAX_INDEX_IN_ONE_CHUNK *
-						reply_post_free_sz);
 			dma_alloc_count--;
 
 		} else {
-- 
1.8.3.1

