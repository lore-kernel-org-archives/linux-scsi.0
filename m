Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091D8C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 15:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCBPtV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBPtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 10:49:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C855419F1B
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 07:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHtArPIYbL6vHuwojETOPM4nYL0ibPeRfxcvRp7/dN8=;
        b=fsQLd8So/29Z3HLKzt+ZAD3AHBzOO+5TKpvYlQNHLlFEepaAup4wxuoY1eR3skiucvELnY
        /Ck9JGz+yjBifqbSYRfQRUkxB0jvzvGFoymTu99LfM7674sdBpU1IdoT4Gv5+K7b3Zx0P5
        vkrKJaYxWX5nr5uP5g2sNYVn2jV0in0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-cGgCns-APJyO5F1pk90qTQ-1; Thu, 02 Mar 2023 10:48:32 -0500
X-MC-Unique: cGgCns-APJyO5F1pk90qTQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52D363C16EA2;
        Thu,  2 Mar 2023 15:48:32 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1A34492C3E;
        Thu,  2 Mar 2023 15:48:31 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: [PATCH 5/6] scsi: mpi3mr: fix a memory leak
Date:   Thu,  2 Mar 2023 16:48:25 +0100
Message-Id: <20230302154826.5862-6-thenzl@redhat.com>
In-Reply-To: <20230302154826.5862-1-thenzl@redhat.com>
References: <20230302154826.5862-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't allocate memory again in next loop(s).

Fixes: fe6db6151565 ("scsi: mpi3mr: Handle offline FW activation in graceful manner")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 53 +++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index fa62991f5aee..99edc0160c59 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3852,29 +3852,34 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
 	mpi3mr_print_ioc_info(mrioc);
 
-	dprint_init(mrioc, "allocating config page buffers\n");
-	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
 	if (!mrioc->cfg_page) {
-		retval = -1;
-		goto out_failed_noretry;
+		dprint_init(mrioc, "allocating config page buffers\n");
+		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
+		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
+		if (!mrioc->cfg_page) {
+			retval = -1;
+			goto out_failed_noretry;
+		}
 	}
 
-	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-
-	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc,
-		    "%s :Failed to allocated reply sense buffers %d\n",
-		    __func__, retval);
-		goto out_failed_noretry;
+	if (!mrioc->init_cmds.reply) {
+		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc,
+			    "%s :Failed to allocated reply sense buffers %d\n",
+			    __func__, retval);
+			goto out_failed_noretry;
+		}
 	}
 
-	retval = mpi3mr_alloc_chain_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-		    retval);
-		goto out_failed_noretry;
+	if (!mrioc->chain_sgl_list) {
+		retval = mpi3mr_alloc_chain_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+			    retval);
+			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_issue_iocinit(mrioc);
@@ -3897,11 +3902,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		goto out_failed_noretry;
 	}
 
-	retval = mpi3mr_create_op_queues(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to create OpQueues error %d\n",
-		    retval);
-		goto out_failed;
+	if (!mrioc->req_qinfo) {
+		retval = mpi3mr_create_op_queues(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to create OpQueues error %d\n",
+			    retval);
+			goto out_failed;
+		}
 	}
 
 	if (!mrioc->pel_seqnum_virt) {
-- 
2.39.1

