Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60927C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 23:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCBXoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCBXoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 18:44:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6645317147
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 15:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677800623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H93esuvA4JaKC7HBC5maYBDA3al7sKvyeix+fTRm7DQ=;
        b=MXgliXUqGLGUEmdes0FYWnjq9YfFRkllyAN0Sw8R0KzIgyrs5oOrd4smF0sfwaffzAV4dU
        JEhhEwUaJbGE3wZc8MiowT56PYuR9DFQVYWEcU5ZFYx2KkgPxtVKJ8RVnVcyBMcRFOaAbo
        +/CR9SRsogHG84eft414vBgNnFv6Fy8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-y92H4oRJN02sY6Nxcy9a0w-1; Thu, 02 Mar 2023 18:43:40 -0500
X-MC-Unique: y92H4oRJN02sY6Nxcy9a0w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F022F100F908;
        Thu,  2 Mar 2023 23:43:39 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AA81140EBF6;
        Thu,  2 Mar 2023 23:43:39 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH v2 2/6] scsi: mpi3mr: fix a dma memory leak
Date:   Fri,  3 Mar 2023 00:43:32 +0100
Message-Id: <20230302234336.25456-3-thenzl@redhat.com>
In-Reply-To: <20230302234336.25456-1-thenzl@redhat.com>
References: <20230302234336.25456-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A fix for:
DMA-API: pci 0000:83:00.0: device driver has pending DMA allocations while released from device [count=1]

Fixes: 32d457d5a2af ("scsi: mpi3mr: Add framework to issue config requests")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b632e1bb1007..fa62991f5aee 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4396,7 +4396,11 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-
+	if (mrioc->cfg_page) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
+		    mrioc->cfg_page, mrioc->cfg_page_dma);
+		mrioc->cfg_page = NULL;
+	}
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
-- 
2.39.1

