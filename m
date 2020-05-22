Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BD3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 10:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7816204EA
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 10:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TI6qrINx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgEVKgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 06:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgEVKgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 06:36:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD3CC061A0E
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2020 03:36:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w64so9314126wmg.4
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2020 03:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=IvYd5IGFvqlYeq7XsQzsVXg/xWFw1hytqQS5q0XQBmQ=;
        b=TI6qrINxXM1+VOg6AjQt+WD1UMKn5pfK/wAQZ8iZJwDyu6K2NUbtO59zXkf8F35cMM
         IIEbgp8402k+hHQB8h5LwYO5RIkIoucW5Njf14V9v9pqlf6hJ1MWY1LeMC7g7qqX9jgO
         wBYSyORo9LyXnFbAj4SkdcX5SjoyxZ4R5P8Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IvYd5IGFvqlYeq7XsQzsVXg/xWFw1hytqQS5q0XQBmQ=;
        b=Vz9bKm7vTgJ6GgALnUgYsumxadoEybiyTZBStiMAJamAldiBB7fm/ugNipD7HKTgu8
         CDD7ZD9Lp/qImateF9JqAd9fVUk7lwV0ypmCA7b1os8CGd+eKbWuyas3d2MTEgui9ocv
         MvsmYHljzykA/HTrJ8lN0xrd7T173aqLNKRYITs9HgsFIZMxjMigRSSncOfNN+GZPpaj
         ousgS8wBdpr2Q4bhtsQiyzFf7xx7jGOSoFLFEl2fbOWV4+vycJ2WbMb3pcYhIyPJBLnO
         W+5a7p4cwb/RotI5BtMD+8/3lUXO9Q0a6fvH5YC/Fy3Xs/zDP35hVhFVdthRdaxDx+C6
         gAXQ==
X-Gm-Message-State: AOAM530/QpyWIcMGLpuB5kL1rO6x0fDllO3BuedINbACcMse7KF6L290
        zVDHaLt4+ClKXt3ZZZefs7R7GUWViIUodt9sp55RRAXDwYoxJxGLVQOdOmJt6CXi0OoNqCknepK
        nUhqwl5HpSuYrcE+5d4ZD9hXayj5WyN7Wch51VM6pUDJkv5p8a4LjANb1OkD3PR045RN39xt2qK
        q/w3ix3fLBThfIHnuF2HEo
X-Google-Smtp-Source: ABdhPJzsQJ/7EZ5ay9ZsACBMgvXSS7nhE9w8498/bKwAs9uOD9mcyt0gJfdeTCase3holAgumegbgA==
X-Received: by 2002:a1c:2e41:: with SMTP id u62mr13490113wmu.91.1590143774475;
        Fri, 22 May 2020 03:36:14 -0700 (PDT)
Received: from dhcp-10-123-20-28.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z10sm9188648wmi.2.2020.05.22.03.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 03:36:13 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, thenzl@redhat.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Fix reply queue count in non RDPQ mode.
Date:   Fri, 22 May 2020 06:35:58 -0400
Message-Id: <20200522103558.5710-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For non RDPQ mode, Driver allocates a single contiguous block of
memory pool for all reply descriptor post queues and passes down a
single address in the ReplyDescriptorPostQueueAddress field of the IOC
Init Request Message to the firmware. So reply_post queue will have
only one entry which holds the address of this single contiguous block
of memory pool.

So while allocating the reply descriptor post queue pool driver should
loop for only one time in non-RDPQ mode. But due to a bug in below
patch driver is looping for ioc->reply_queue_count number of times
even though reply_post queue's queue depth is only one in non-RDPQ
mode. This leads to 'BUG: KASAN: use-after-free in
base_alloc_rdpq_dma_pool'.

commit 8012209eb26b7819385a6ec6eae4b1d0a0dbe585 ("scsi: mpt3sas:
Handle RDPQ DMA allocation in same 4G region")

Fix is to loop over only one time while allocating the memory for the
reply descriptor post queue in non-RDPQ mode

Reported-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index dc260fe..beaea19 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4809,6 +4809,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	int j = 0;
 	int dma_alloc_count = 0;
 	struct chain_tracker *ct;
+	int count = ioc->rdpq_array_enable ? ioc->reply_queue_count : 1;
 
 	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -4850,9 +4851,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	if (ioc->reply_post) {
-		dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
+		dma_alloc_count = DIV_ROUND_UP(count,
 				RDPQ_MAX_INDEX_IN_ONE_CHUNK);
-		for (i = 0; i < ioc->reply_queue_count; i++) {
+		for (i = 0; i < count; i++) {
 			if (i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0
 			    && dma_alloc_count) {
 				if (ioc->reply_post[i].reply_post_free) {
@@ -4973,14 +4974,14 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 	 *  Driver uses limitation of
 	 *  VENTURA_SERIES to manage INVADER_SERIES as well.
 	 */
-	dma_alloc_count = DIV_ROUND_UP(ioc->reply_queue_count,
+	dma_alloc_count = DIV_ROUND_UP(count,
 				RDPQ_MAX_INDEX_IN_ONE_CHUNK);
 	ioc->reply_post_free_dma_pool =
 		dma_pool_create("reply_post_free pool",
 		    &ioc->pdev->dev, sz, 16, 0);
 	if (!ioc->reply_post_free_dma_pool)
 		return -ENOMEM;
-	for (i = 0; i < ioc->reply_queue_count; i++) {
+	for (i = 0; i < count; i++) {
 		if ((i % RDPQ_MAX_INDEX_IN_ONE_CHUNK == 0) && dma_alloc_count) {
 			ioc->reply_post[i].reply_post_free =
 			    dma_pool_alloc(ioc->reply_post_free_dma_pool,
-- 
1.8.3.1

