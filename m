Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9CDC433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61DC2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeEViz+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgF3VuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgF3VuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578E2C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so21608698wrs.11
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ysgs5bsJN9inpx5kdO0t8Nt9sp2AOD+EjZnVp499QBk=;
        b=ZeEViz+zpJqh6Kl1dgTdSW94ew7UAQ7G6Kq8vSA47IY6gKjdz499QU//MohcmP3fmC
         I0lGROHzzvS4gNhB7nNahO8lUgAbRg68+ymVYoVmYe0bKeS7EIJndFvIw1gGGvB//3FR
         /S0Vi6+O/GZcniwfYmt9f/x+AS/hlA0OzoQHMDwF0nJesSOys//EkCB906rmP300lMmt
         ACtCGv7ejGBZ4wekafO4bp/M6QqlN6904nFIqwX/XJ/1pR3O+S3HguwoMGBGlxkE4Vd4
         7VfXvsLM5e0VYjR/FUn3wAnX/668pGMr25m0uUYR1VktAhqC8fhyXzIndjWtVvT7MNCr
         yEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ysgs5bsJN9inpx5kdO0t8Nt9sp2AOD+EjZnVp499QBk=;
        b=ugaxyEcJVJQSwohNF0VlYhGJ4IZdmL2nFdPhx6MbtPDo/azof5Qm7CcEqO0xfO9/3W
         S+dImmC3cCaXUhsBA9RIweKB3BjEaCJx8I/qaTyA+R4b96X6WnU6MeKxRdugIMj5zl/s
         rFNgiWIj4NlbxIRGx1srUaNVrEPFAy9zcC5vaGABnNP9j+oPPk9/zRatfqKRColaNtc8
         iRFFgCOVNT9EmUnfIDBLOyV9HNXfH7sNM7SLBhsQOxK7l+MvGzyxf/hdHi0hDzKzSPEp
         Fmw4Fz/GGYtY0z6rW3D1dsSUHMNOQmjvyXDMXuX/61/NEsmerKVLi5t0EXloKh3KUHdO
         GKDg==
X-Gm-Message-State: AOAM530JdafCfdXZ79aKWvuSrhu3KRahTWAjLVCSVXUwo4IPAtP2YssO
        Ymwgk1fenEm7+wT66ctDwTfvKDEn
X-Google-Smtp-Source: ABdhPJyIk70c9+tUvsHUaFKH9FfSd6Lq08QenZbJvA7V2V8WT80mWs/FPWvUXwinbVa7trMKKNibTQ==
X-Received: by 2002:adf:f608:: with SMTP id t8mr23974578wrp.308.1593553821225;
        Tue, 30 Jun 2020 14:50:21 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/14] lpfc: Fix stack trace seen while setting rrq active
Date:   Tue, 30 Jun 2020 14:49:53 -0700
Message-Id: <20200630215001.70793-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call traces have been observed running different tests that involve aborts
and setting the rrq active flag.  The lpfc_set_rrq_active routine is doing
a mempool_alloc under the soft_irq processing level. When the mempool needs
to get a new buffer from the free pool and has to wait for memory to become
free it will check the flags passed in on the alloc and dump the stack if
the thread is running in interrupt context.

Replace the GFP_KERNEL flag with GFP_ATOMIC so that the memory allocation
will not attempt to sleep if there is no mem available.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_mem.c | 3 ++-
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 726f6619230f..e8c0066eb4aa 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -45,6 +45,7 @@
 #define LPFC_MBUF_POOL_SIZE     64      /* max elements in MBUF safety pool */
 #define LPFC_MEM_POOL_SIZE      64      /* max elem in non-DMA safety pool */
 #define LPFC_DEVICE_DATA_POOL_SIZE 64   /* max elements in device data pool */
+#define LPFC_RRQ_POOL_SIZE	256	/* max elements in non-DMA  pool */
 
 int
 lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
@@ -121,7 +122,7 @@ lpfc_mem_alloc(struct lpfc_hba *phba, int align)
 
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		phba->rrq_pool =
-			mempool_create_kmalloc_pool(LPFC_MEM_POOL_SIZE,
+			mempool_create_kmalloc_pool(LPFC_RRQ_POOL_SIZE,
 						sizeof(struct lpfc_node_rrq));
 		if (!phba->rrq_pool)
 			goto fail_free_nlp_mem_pool;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c598bef5cad4..c439cf9a82c7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1079,7 +1079,7 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		goto out;
 
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
+	rrq = mempool_alloc(phba->rrq_pool, GFP_ATOMIC);
 	if (!rrq) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"3155 Unable to allocate RRQ xri:0x%x rxid:0x%x"
-- 
2.25.0

