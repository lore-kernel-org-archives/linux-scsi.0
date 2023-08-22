Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCC3EE49AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjHVTTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjHVTTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:19:20 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8926ECFE;
        Tue, 22 Aug 2023 12:19:10 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-26d2b3860daso3348460a91.1;
        Tue, 22 Aug 2023 12:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731950; x=1693336750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeTP9UxMC9xuYvRY29/KP6o+hE37UxPqFnd4pYMhYhI=;
        b=Mpcf4lqlgCU9aYHOTcO17zf/IQXdFAcWgZszKBgCHmTehu/G+vwaf9l9A0+f6R7YL2
         sj4MnuwKcW3sToRCZv8G8YEtmK9vtGTF5Vghcof192JYhZ4GieehN4jd3q45FaRLJqzY
         ds4onFusKIQGFOcTLgHmtsU3VqDkHLRGlqKmE3YbIA3N6sVDLT+QqYXT4IPsA98GT+Mq
         yM2gHjTdJccnT5lGZWmWX7mcxngG2Luz9jU/WzoHCN9wW63aQYwPTKFV6jg/wmq07HcU
         R3aDeHD0i8CUOPpSYtJOxahYd36dfO0j9nZ621BCD+G0VC0/N+zxMxkEu6Vqz9nUpRYb
         TPWw==
X-Gm-Message-State: AOJu0YyR/h3APchnOywJO2n2ui006D+yhUMVBQS9VqkVHcntwaAPM/tj
        lLz7mRMAUMpkoYJhABmntkI=
X-Google-Smtp-Source: AGHT+IG/1WjbbniTpurPyqjHXV0CtS3tugahKa/qvwvkJNfmrNGsvTZ/2OnGeSANHLZyNfp7RR2FLQ==
X-Received: by 2002:a17:90b:11cd:b0:26b:4e59:57e7 with SMTP id gv13-20020a17090b11cd00b0026b4e5957e7mr9530138pjb.43.1692731949971;
        Tue, 22 Aug 2023 12:19:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:19:09 -0700 (PDT)
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v11 11/16] scsi: ufs: hisi: Rework the code that disables auto-hibernation
Date:   Tue, 22 Aug 2023 12:17:06 -0700
Message-ID: <20230822191822.337080-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
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
