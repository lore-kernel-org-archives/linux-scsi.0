Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146DAC41513
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbjHPTzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345948AbjHPTz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:27 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7C8198E;
        Wed, 16 Aug 2023 12:55:26 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6889078ee66so799240b3a.0;
        Wed, 16 Aug 2023 12:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215726; x=1692820526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVQD0WbqqvycXZAf7qyOpSGFUndWIL1qRVpGPKP4Vtc=;
        b=gXMQyUreHONEHAywrSPgbtry6b+28MGXdEOAIi01ZoJP8ilDD7JdcZ81ul04hb0lWK
         DU+gWtbf6TypP50N23XIo7xuOR5Zil0riI8zM19xQv63cbny8FnmDbPNw4/K6+WKsm+i
         1MN4KdLmbhlh2dbcbhe69M89VhuI5V3JU+aSij5saM/s4lCpYprkZg9MAAuDrFrtcY0I
         /r2CJ7xYj84ykrNpBE5nsAwwNaMjMhiWfj7gdEqbWIowvChpEV034YUzNb4CgPNWF8Uf
         TnTlw5kyuOpDY12GtinOq/vnb4DTalf7NNkt9TlQAQ5Li6QEzbaniLNsOS/vg6vqfo8D
         Ifzg==
X-Gm-Message-State: AOJu0YyF9A/jnN1DH9I8UkylimVSDKGYnJeyrIy595CeDTWvvXzhGiTW
        ZJqEtZWjGQBcymKubscYSew=
X-Google-Smtp-Source: AGHT+IHDh+zVS1dLun5267dYF1CvXgHrofHBqKfTvTdBVcoTitcd3YtENXj2/CGcIBNF2olanM8YBA==
X-Received: by 2002:a05:6a00:240a:b0:668:6eed:7c0f with SMTP id z10-20020a056a00240a00b006686eed7c0fmr3180512pfh.12.1692215726177;
        Wed, 16 Aug 2023 12:55:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v9 11/17] scsi: ufs: hisi: Rework the code that disables auto-hibernation
Date:   Wed, 16 Aug 2023 12:53:23 -0700
Message-ID: <20230816195447.3703954-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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

Cc: Martin K. Petersen <martin.petersen@oracle.com>
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
