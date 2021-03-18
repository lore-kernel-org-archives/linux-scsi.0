Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C837C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 22:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A2664F1B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 22:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhCRW47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhCRW4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 18:56:43 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2BFC06175F
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 15:56:43 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h21so32773569qkl.12
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 15:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9QoP9965eN6KfleHPxoTcP8X4PcKzAfBQoWsgVWtjyk=;
        b=KdN9vnUgMhpYZGkGDJfe6+gOWXOb4Zp/3ue54E8kyK8AJz89TEGYEm/SSlKjv7WXNd
         PXuceVBB+DnIS5CHWd01BmfyhjfAjiG9gvbujZGa+4s8Oow/Z4Ne0sAueUe0XaGU39FS
         WqHzJOnytd6QR88SSJ48VewDwof1506Y/QBP8gOr/DFL88QmfCmHL7ovPzbqD3DEl5kK
         rNKcEt4bOsCWI/MbeTvpzap3oi8LP8oiY0bm98b+pn32u7o1/KUxa8u3NNKqJTB2d+Tq
         J6fCOVhG47pd8BnSefa2nAtGWE6Ls/wDGvjSG9Hz6zzRvjT1QJGKCeJEFUMRwondd+WU
         gDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9QoP9965eN6KfleHPxoTcP8X4PcKzAfBQoWsgVWtjyk=;
        b=fmhhFU1QfpGzhZaG0s70TGFc/56N9dFRL2VXjjQgzG9pMB3DH6C+H3eI4xORTsfsoB
         cTpOOz9DgvQQU8ZMCwwM1ISXgmFZfI4Ah81hwJqplI3OQmMspWaLq9Rdu7CELlQ+mgqD
         GjV0u9nzq9ra7CiYiPwdDaJ0CfBlR1BMyn3lNH2J/aPVqWFWTvigCzRDseeYXMdWribi
         XO65b30H2PV9N8+J2wuZqsCKyYde+oQ2wWEXj0UEh3RjrS/IGl2iP2Y8j73Et+OeCTFZ
         DGuKNowtLaFk4cFyRpU5h8g04g2SlVFsSLnsBdo/e6mVZzL72hapmf5t3s+tlXAPdQup
         KAUw==
X-Gm-Message-State: AOAM533j1tI22Ba8hV/3+EckzMPN5Ml1lc4SO84GmWKTL5l2F45Pt/ef
        JZJ/xYYxcKBfug5ym+Oj+RAktTobtlA=
X-Google-Smtp-Source: ABdhPJzomk8qAhSEpE6QXe3u36oZYsNOLbz+iAPniGwSM2nX6SdAByOD3zjAaIS3kVhG6uLdnTDidcPBpRw=
X-Received: from jollys.svl.corp.google.com ([2620:15c:2c5:13:84f3:414f:d94c:e1e1])
 (user=jollys job=sendgmr) by 2002:a0c:8f09:: with SMTP id z9mr6481323qvd.25.1616108202527;
 Thu, 18 Mar 2021 15:56:42 -0700 (PDT)
Date:   Thu, 18 Mar 2021 15:56:32 -0700
Message-Id: <20210318225632.2481291-1-jollys@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
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

This patch updates code to handle ata non data commands separately so
num_scatter and total_xfer_len remain 0.

Fixes: 53de092f47ff ("scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA")
Signed-off-by: Jolly Shah <jollys@google.com>
---
v2:
- reorganized code to avoid setting num_scatter twice

 drivers/scsi/libsas/sas_ata.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 024e5a550759..8b9a39077dba 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -201,18 +201,17 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
+		task->data_dir = qc->dma_dir;
+	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
 			xfer += sg_dma_len(sg);
 
 		task->total_xfer_len = xfer;
 		task->num_scatter = si;
-	}
-
-	if (qc->tf.protocol == ATA_PROT_NODATA)
-		task->data_dir = DMA_NONE;
-	else
 		task->data_dir = qc->dma_dir;
+	}
 	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
-- 
2.31.0.rc2.261.g7f71774620-goog

