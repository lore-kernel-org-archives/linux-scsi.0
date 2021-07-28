Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF0BC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D70E860F9E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 01:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhG1B2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 21:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhG1B2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 21:28:54 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7A3C061757
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 18:28:53 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w11-20020ac857cb0000b029024e7e455d67so164709qta.16
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 18:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u18JPqezBuNnCoS9PFQiyHRGpr77MWfIAMC88dhsA70=;
        b=XA/bMzmpJv1aZioF0UgFDElW1oenUyZKbOW5vPa//F0t987N3CN0EOvslHkvH5FptR
         OrUq5E7+2w5riexOS3CMUjCTO8JInrsl5XUxShn623JPAawQJ8OX9AUNve/BLGvBShOR
         9Gw3wJBCutVoSTIx9VZmc49vPfi9bNm3F390QGEwNPhrDCIZaYZ+rCZusATkmhh1PJI5
         fyeE65N4hAS5cJO/O0BPOtDp/7UTO6496KJCQnSQ5gS+Nvv5pcFsejlWZe4ueZhjtLs/
         tvm4Cgs5XW2RnsbiRNFB5tksSGjeXERjV5crXXxsoPfbw2yXIKICB6TVAynhLltCpmEh
         /CjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u18JPqezBuNnCoS9PFQiyHRGpr77MWfIAMC88dhsA70=;
        b=j3nivHA7mNopdBqDP6IJPiGwvoopTY6nJ+bLeFPofQjsz79DMvOF+b9MwZZ+WMcSRO
         /D0zVif9guk03aJeTpv83AFi8sRmPcLqpV55ok8MOIz7CdGejkmjaaSlGEu5hGJcp3Ic
         UfOsAkjvXuKRTzs3LZ8tF/C8qJoBGGOjXZ+L23DwpciK0FqpbDSYapncmyZZa5Gix8A4
         3f9qzi74BWxuoVUvwFboViIbfpIUlC/+sEv3M1AtwhSPZ9q8+HRhTQS32Cj6jBnnY25S
         CFGDjAEsVk8Hc5gkcaoouctEqqttPQXYapSTdIuy8wvOOszjsXlUvwMpCkHdMFaLRb/J
         zC8w==
X-Gm-Message-State: AOAM531lzvBVYWhHRf5YehMpaxfOxzp7j0jb8jEJFT9settGpaTF7boW
        ZPFh1p1DSpICcgj0elvbQoEI6PGNqFqM
X-Google-Smtp-Source: ABdhPJzqYH4lNsgQEofBqfJiBYrF4Z233J0dQBMPyZniOgW1YuRo0hZY0OzAqBLU5MovcbytOjsdXCBof3oB
X-Received: from lighttop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2fcb])
 (user=paillon job=sendgmr) by 2002:a05:6214:529e:: with SMTP id
 kj30mr25896914qvb.32.1627435732820; Tue, 27 Jul 2021 18:28:52 -0700 (PDT)
Date:   Tue, 27 Jul 2021 18:27:43 -0700
Message-Id: <20210728012743.1063928-1-paillon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH] scsi: ufs: Allow async suspend/resume callbacks
From:   Vincent Palomares <paillon@google.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Vincent Palomares <paillon@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow UFS suspend/resume callbacks to run in parallel with other
suspend/resume callbacks. This can recoup dozens of milliseconds on the
resume path if UFS hardware needs to be powered back on.

Suspending and resuming asynchronously is safe to do so long as the driver
callbacks only depend on resources made available by either a) parent
devices or b) devices explicitly marked as suppliers with device_link_add.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Vincent Palomares <paillon@google.com>
---

Are there any suspend/resume dependencies for UFS drivers not tracked by
the device parent relationship?

drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b87ff68aa9aa..9ec5c308a0ea 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9625,6 +9625,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
+	device_enable_async_suspend(dev);
 	return 0;
 
 free_tmf_queue:
-- 
2.32.0.432.gabb21c7263-goog

