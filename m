Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1C4C00A8F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjJWV5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjJWV5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:30 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2457E10D1;
        Mon, 23 Oct 2023 14:57:28 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-27d113508bfso3269233a91.3;
        Mon, 23 Oct 2023 14:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098247; x=1698703047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeTP9UxMC9xuYvRY29/KP6o+hE37UxPqFnd4pYMhYhI=;
        b=aztYl985tFqX3IBVkb3PPhcy0t7ZUVT1Z5dy67UHptdp5Qz0hxzrRSR89gqmnWixdD
         32Ik7wUcBTBogjtw9EgZexjsGD+l4gX5c69MJ3p69TjSrm7ptJpAoIuZIBT0Dfs7WZQC
         XaS6mpTnVd27RaNxqR1/5za9PiFkygUMKTjBhUpgtb9EavABZPHDFwB86ENtfswEbpgy
         /XUncnZm5qi2AoNn5T9Nc0bGSLESEyTFiO264Dlu/L36XEmEZgh9KLQP7oN+uBooVEAB
         CiE1NXyo3cKo6MZOErKeXnJL3qh+fwBI3a4iI0Qy0/i1PDgUpz0CT3Xp7VxRft1ZbcNM
         4IpA==
X-Gm-Message-State: AOJu0YycoSwFBtMJBfLb3VLt5WR6alRAU88CWapbjcvBmEx6P8JTlHp9
        FK1Sv4d8qYC9nkSdqc2UIec=
X-Google-Smtp-Source: AGHT+IFvMjCQL618I1hkh8Ykghqvr+SDilKYxgGyqq/Ja6+VI8YMobiB/rXNeOOGBMIqDTKn8jYTaw==
X-Received: by 2002:a17:90a:dd44:b0:27d:916a:23ec with SMTP id u4-20020a17090add4400b0027d916a23ecmr11691856pjv.37.1698098247439;
        Mon, 23 Oct 2023 14:57:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v14 14/19] scsi: ufs: hisi: Rework the code that disables auto-hibernation
Date:   Mon, 23 Oct 2023 14:54:05 -0700
Message-ID: <20231023215638.3405959-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The host driver link startup callback is called indirectly by
ufshcd_probe_hba(). That function applies the auto-hibernation
settings by writing hba->ahit into the auto-hibernation control
register. Simplify the code for disabling auto-hibernation by
setting hba->ahit instead of writing into the auto-hibernation
control register. This patch is part of an effort to move all
auto-hibernation register changes into the UFSHCI driver core.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-hisi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 5b3060cd0ab8..f2ec687121bb 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -142,7 +142,6 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
 	int err;
 	uint32_t value;
-	uint32_t reg;
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x1);
@@ -232,9 +231,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
 
 	/* disable auto H8 */
-	reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
-	reg = reg & (~UFS_AHIT_AH8ITV_MASK);
-	ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	hba->ahit = 0;
 
 	/* Unipro PA_Local_TX_LCC_Enable */
 	ufshcd_disable_host_tx_lcc(hba);
