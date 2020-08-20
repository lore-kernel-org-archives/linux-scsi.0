Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3A7C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 23:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D8320702
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 23:56:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQ+o/6YY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHTX4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 19:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgHTX4Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 19:56:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5129FC061348;
        Thu, 20 Aug 2020 16:49:59 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so309001wrs.11;
        Thu, 20 Aug 2020 16:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=swVS7wXP2zSlH4DoWRDX+ErkfgIT7hxKvOrIIG5V9Vk=;
        b=NQ+o/6YYmM9TXrGVrcg8/ZHwO5GG82G5FVoY5ua24eyWXbWxqKgW2VvNzvKQeKtM6k
         KcFCJZIgRmw1qlKSlm7yJGGyjcLACcGzEIFA1Co5yl9nzo3dbEF6KMAHYles+gq8/jaS
         r/RmGx5TQdGB0bcaZdnIeDGbwZNQLONYoG0a3llzAl4+ZduZrDrM+jewmBLW+jgh5BE+
         JiJHnqAekLukPw0kXueA0O1+MO3BSU+nLeBR+qmhRjV92kebat2XjMXhL5AQ/8rX9Wls
         5vGMUSXXDsrFxaIT2puCVzbmj59VF/Q5gfx9n48bqj/ITaBdbeaHLJAmpVh/yMgnLUCm
         KUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=swVS7wXP2zSlH4DoWRDX+ErkfgIT7hxKvOrIIG5V9Vk=;
        b=BXJxcpsn/hqa7BAmdKoUB+pZWZ/+vlUMQCKy1wrf6InQgOYdd7oX0iTLzLvl7Sw26C
         oBFE6RuM1Vw3DC/21baHZWE1BvPBvDJkA9VUh3ek1Ni8NQcI0Pkez1b5UNpIc8Sl7oeb
         QTgTG8qnnkOYDlY1JzF6e7ozEallNiZvlzr7S4UYvxkST/GPOJ6P74ARBfKPI5JtyUbJ
         oE1MrX1AkWsLOQApBDUD1FIZX+flgy8nMxIWIQNZTcIr2NZNqp0FVxF1lLfboQMe7dOX
         Q+FJH1N1vgqkkFy7wLj0EPEehnQ4rF+KYBVIOqpSf/76mc74EC4Fp3pCJ2kOiuTy3SBH
         hK3A==
X-Gm-Message-State: AOAM533s361R/wKI0qNPscR8qZNH2/DfVVzLatlRid7JeXBejf6OEVzv
        QeBVUqrRRQgPYmSC7acYXB4=
X-Google-Smtp-Source: ABdhPJwx5z14sg4nUnZDq7QLNLI/SpqBrc49XGsvnUnuqEdQPtptex17XQq05rJTUaJ7q05LzK2X3g==
X-Received: by 2002:adf:82d5:: with SMTP id 79mr150654wrc.282.1597967397538;
        Thu, 20 Aug 2020 16:49:57 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 32sm707449wrh.18.2020.08.20.16.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 16:49:56 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     alex.dewar90@gmail.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, njavali@marvell.com
Subject: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
Date:   Fri, 21 Aug 2020 00:49:52 +0100
Message-Id: <20200820234952.317313-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820185149.932178-1-alex.dewar90@gmail.com>
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dma_alloc_coherent() already zeroes memory, so the extra call to
memset() is unnecessary.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
v2: I've noticed a few other places in the scsi subsystem with this
pattern, so lets fix them all with one patch.
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 -
 drivers/scsi/mvsas/mv_init.c        | 4 ----
 drivers/scsi/pmcraid.c              | 1 -
 drivers/scsi/qla2xxx/qla_mbx.c      | 2 --
 4 files changed, 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b66d3f9b717f..36b6c0d67353 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5259,7 +5259,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		_base_release_memory_pools(ioc);
 		goto retry_allocation;
 	}
-	memset(ioc->request, 0, sz);
 
 	if (retry_sz)
 		ioc_err(ioc, "request pool: dma_alloc_coherent succeed: hba_depth(%d), chains_per_io(%d), frame_sz(%d), total(%d kb)\n",
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 978f5283c883..6aa2697c4a15 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -246,19 +246,16 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				     &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
 	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
 					 &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
 	mvi->rx = dma_alloc_coherent(mvi->dev,
 				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
 				     &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
@@ -267,7 +264,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 				       &mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..d99568fdf4af 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4716,7 +4716,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
 			return -ENOMEM;
 		}
 
-		memset(pinstance->hrrq_start[i], 0, buffer_size);
 		pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
 		pinstance->hrrq_end[i] =
 			pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 226f1428d3e5..e00f604bbf7a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4925,8 +4925,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	/* List of Purex ELS */
 	cmd_opcode[0] = ELS_FPIN;
 	cmd_opcode[1] = ELS_RDP;
-- 
2.28.0

