Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8309EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 19:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573A364F75
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 19:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbhCPTjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 15:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbhCPTjJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 15:39:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34289C061756
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 12:39:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a63so42981802yba.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 12:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DyT2hoANWswY1My2edJBxlO9DN0LrYQonEua2weCt84=;
        b=fBhUY4KnMhJq9CyPuR22abSB5bODhZt9LZOsPXAPaVrKZVpkZvLsEdwqELYErXRVX8
         D4F6ayBWlArXiqvIbhhBbG7R2TsPQFIxC3HOmLnLNll7P1Vm5V0jkC5UP/oLTPuUsBHt
         TyjMMi9zWIfl8uBac3LUFP2iLxmg0VN0ZZ6SotUcD6jGVtXqfLku/XFknVu1IDikm1N/
         /J11qoZE3p32jpTgXVvQ0VHCVwezqgfNKepiHhE/uWRFCUHkLX3CsYO+YlWIf9y/v1zq
         2V7GqwPyGvCRZXTxBW1m/3Y8o6sFtiZ2DyW1lDhTQnwNdPzE4dv/eGN9Xt5ZjaMkAu/P
         JiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DyT2hoANWswY1My2edJBxlO9DN0LrYQonEua2weCt84=;
        b=MK9pkMrVUtFDdmFNsDERfhzlmNHvf2ASx0kIvcjFCdkOG6Z7ejbDE2Ws3QOHgWLJBm
         1gsYLQE5AZvRFes9PJt06slTZF1mQkec5ieNGeiBKIwKKcU1i3XmR2A8pzo7xg3YjA+d
         SvSvlOImB85XZbjgjz3FmxbTBePm/c7FkDfb1DEZeqK/VGIaqRlEx77oSyGIidXg5F27
         HWISGdfONpwlo0MvRLV4fMihtMoMj1OL62Dld9mRPbfp0mcxd61gbDKhy0SZ5uHX6NuQ
         2WMh+tnWeXXQTczsJPC1i0/UV31LIFEi9Aug+4y9F7jH+RpkKlauUK9lpNqZrkzrn/yx
         ct1w==
X-Gm-Message-State: AOAM532icjvhTePfY+lLfg5+kSQHXcU01E0VW0IF+dkyFpnudHLt9PmS
        ygaCyEFROpjNWmdNQBxHBpTO9FvqYrk=
X-Google-Smtp-Source: ABdhPJzRB9OdmVfPBpo9VDbQbkeTJSWjg7KRmAXhc4AiGHtJsgtwJUvlBoFiZExzwossrj59KdlljR34x/4=
X-Received: from jollys.svl.corp.google.com ([2620:15c:2c5:13:b0b6:1464:754e:83cb])
 (user=jollys job=sendgmr) by 2002:a25:595:: with SMTP id 143mr663212ybf.177.1615923548383;
 Tue, 16 Mar 2021 12:39:08 -0700 (PDT)
Date:   Tue, 16 Mar 2021 12:39:05 -0700
Message-Id: <20210316193905.1673600-1-jollys@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
From:   Jolly Shah <jollys@google.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        john.garry@huawei.com, a.darwish@linutronix.de,
        yanaijie@huawei.com, luojiaxing@huawei.com,
        dan.carpenter@oracle.com, b.zolnierkie@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jolly Shah <jollys@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the cache_type for the scsi device is changed, the scsi layer
issues a MODE_SELECT command. The caching mode details are communicated
via a request buffer associated with the scsi command with data
direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
reaches the libata layer, as a part of generic initial setup, libata
layer sets up the scatterlist for the command using the scsi command
(ata_scsi_qc_new). This command is then translated by the libata layer
into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
treats this as a non data command (ata_mselect_caching), since it only
needs an ata taskfile to pass the caching on/off information to the
device. It does not need the scatterlist that has been setup, so it does
not perform dma_map_sg on the scatterlist (ata_qc_issue). Unfortunately,
when this command reaches the libsas layer(sas_ata_qc_issue), libsas
layer sees it as a non data command with a scatterlist. It cannot
extract the correct dma length, since the scatterlist has not been
mapped with dma_map_sg for a DMA operation. When this partially
constructed SAS task reaches pm80xx LLDD, it results in below warning.

"pm80xx_chip_sata_req 6058: The sg list address
start_addr=0x0000000000000000 data_len=0x0end_addr_high=0xffffffff
end_addr_low=0xffffffff has crossed 4G boundary"

This patch assigns appropriate value to  num_sectors for ata non data 
commands.

Signed-off-by: Jolly Shah <jollys@google.com>
---
 drivers/scsi/libsas/sas_ata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 024e5a550759..94ec08cebbaa 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -209,10 +209,12 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->num_scatter = si;
 	}
 
-	if (qc->tf.protocol == ATA_PROT_NODATA)
+	if (qc->tf.protocol == ATA_PROT_NODATA) {
 		task->data_dir = DMA_NONE;
-	else
+		task->num_scatter = 0;
+	} else {
 		task->data_dir = qc->dma_dir;
+	}
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
-- 
2.31.0.rc2.261.g7f71774620-goog

