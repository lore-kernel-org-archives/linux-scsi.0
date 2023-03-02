Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5F8C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCBPt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBPtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E3318A87
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQbqdaO/4bDhXPAFxAmf049njxajg0t9dJfXlVbH1HA=;
        b=Fx/qIaOl+EBuKu8qgP9+QFS9Dao9vS4UmaXQIxthOpPOIITApK4fVKAsxXOXWp2vhtp1t4
        mhf8GlYiEIqxLGOo1/uwaxwb48pNcFPaTVQdBofn0TgUyRbs6LSaQ6XD5NwRLAPTdDf6PU
        iXJ8KjfYtgXugVv/qmeJfBFwletu2PM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-rV2jo-06PNWFHmAADO66uA-1; Thu, 02 Mar 2023 10:48:30 -0500
X-MC-Unique: rV2jo-06PNWFHmAADO66uA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D26C10AF805;
        Thu,  2 Mar 2023 15:48:29 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA7F492C3E;
        Thu,  2 Mar 2023 15:48:28 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 2/6] scsi: mpi3mr: fix a dma memory leak
Date:   Thu,  2 Mar 2023 16:48:22 +0100
Message-Id: <20230302154826.5862-3-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
References: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A fix for:
DMA-API: pci 0000:83:00.0: device driver has pending DMA allocations while released from device

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

