Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DCAEE498F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352283AbjHRTqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379883AbjHRTqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F13A3C3F;
        Fri, 18 Aug 2023 12:46:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf092a16c9so10949595ad.0;
        Fri, 18 Aug 2023 12:46:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387846; x=1692992646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HldWEGBvoxP6ozgprpbRkTLOv311yhKIPJB3nLy/L8=;
        b=CjU0WVo2d3oQb/JH+8g0iC4fHI77Ot1oNibliRgudmOwXt3FvJuyBkdsBthji89WXt
         0E8pbb1IQwiTFa83PMQ43SXgVg/w71RMjuvbkRqyJ17gIjwXkXHfPh2XSyxZNa3U2+y/
         6Rwjy73VcjQqatCwYWEi20vaAnAm0J0fdAW0Y/m2BZbchd16xkt+qLsEdKIVruDLXAOU
         gnGAVhySZSF6m8/2NBZ+q2x/wOOH9IZQ93UJ/BJbCZJAK959xJBYiX10cVdSNWd+1U2v
         WVhiwyX8GjLAI1NPmwV/Pbb3HKXRHs3nGui+95FihGJyTknpI76mXEPCOalw/c/vSvIn
         rkSQ==
X-Gm-Message-State: AOJu0YzBPSYw5Jx7fUNQ4fGkDePKURnkpIlO0yDnWW4QhxjVR1iDl6r/
        7xLayzuLSc16SNZgwvyuohKubOjOIQs=
X-Google-Smtp-Source: AGHT+IH9MXj6cLK3F5+CQkJSxomRMN7h17MmalCOsl7SNgC/rZXl4UjZU+m9MjJpzW0DqAKzoM6ycQ==
X-Received: by 2002:a17:903:24f:b0:1bf:4833:9c25 with SMTP id j15-20020a170903024f00b001bf48339c25mr248127plh.36.1692387846421;
        Fri, 18 Aug 2023 12:44:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v10 12/18] scsi: ufs: hisi: Rework the code that disables auto-hibernation
Date:   Fri, 18 Aug 2023 12:34:15 -0700
Message-ID: <20230818193546.2014874-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
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
