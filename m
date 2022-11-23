Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A70C46467
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiKWHua (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 02:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiKWHtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 02:49:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F18FBAB8
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so1151489pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 23:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgfrCdEhXykVwBp3nVTN7WEjo711kZc0QKngTjXB/aU=;
        b=AtlYAIpauMotfnGl9jZIW/bs4OXPXsjqMu/t5z9waPiXFr+ZLGRbncdtrZ+xccgL4+
         ZmWoyRIerO0JwGuCWf/VI+7gQqE+MUj6zBip/uqsxxDyg1qsczhyP3aMIAMszq6wr1uT
         bvFGr/B3cXBhK3TwmA+4nva6/xx/GXYIuAotU4KTZD+L1N7ZnEmkpTwSY5Jn06EOxKzb
         P4q0Zq5/Poxrkm9YwDjFn6nmkNumTkGb4plFjP2kDx/4Yfk2B7wD59uFzzwxettvuGnU
         SYP7ZrQWuuFm/kC+Wpxd02pJmDrp07ZWFVYLe5Qo3gZUy2xUNnZcqj4WWJFO6OSX5TJZ
         M8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RgfrCdEhXykVwBp3nVTN7WEjo711kZc0QKngTjXB/aU=;
        b=Is0dy68lfHrsq7bmuvEjY/HAdOYjtPV6spwKQp3o2dLa6I0n9vu78p3wNOTJzKIsm2
         zUVFMApoNBgc+nHu5JN75dCIKuS285RaOTQDBwOv0cUkgg5mfxLbTquBnHSXVtHHxet1
         3OshI3bwueJzTzNZO6zRL+V2JX2MBabq2Tv9Znvkm9z6QXaPFU27bF6fLW82TE64TJlY
         g+pnzpUpAcD91rlDhvzJL1nszb38HlhDEEC93o5Y5W7yQej3VIOS8dXzYumYCczI47UH
         eyms/x7eXCXF1Oua302Y/Rr8OrXtiP5B1wkCMQFWsspevkPTl2oi+xgClYT9LRsFtDPx
         Iatw==
X-Gm-Message-State: ANoB5pmglAFbhs8Im3OSmQxUhqz/i9YSCAa6j3X0VKg1SY1UUjT7CaRe
        auklGkBvAiSIxXyoUvraEITU
X-Google-Smtp-Source: AA0mqf7MKZeCvXf5M5XLWkX+Fqjhqr3Su01CfEQgrc8qo0XLX61I+9/B/AjkA+tkBnMTRD/m+311Tg==
X-Received: by 2002:a17:90a:e2c2:b0:218:825e:17f8 with SMTP id fr2-20020a17090ae2c200b00218825e17f8mr25546559pjb.129.1669189780946;
        Tue, 22 Nov 2022 23:49:40 -0800 (PST)
Received: from localhost.localdomain ([117.202.191.0])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902a51000b001869f2120a5sm13334059plq.34.2022.11.22.23.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 23:49:40 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 11/20] scsi: ufs: ufs-qcom: Remove un-necessary WARN_ON()
Date:   Wed, 23 Nov 2022 13:18:17 +0530
Message-Id: <20221123074826.95369-12-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
References: <20221123074826.95369-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the reset assert and deassert callbacks, the supplied "id" is not used
at all and only the hba reset is performed all the time. So there is no
reason to use a WARN_ON on the "id".

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 7cd996ac180b..8bb0f4415f1a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -895,8 +895,6 @@ ufs_qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
 {
 	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
 
-	/* Currently this code only knows about a single reset. */
-	WARN_ON(id);
 	ufs_qcom_assert_reset(host->hba);
 	/* provide 1ms delay to let the reset pulse propagate. */
 	usleep_range(1000, 1100);
@@ -908,8 +906,6 @@ ufs_qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
 {
 	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
 
-	/* Currently this code only knows about a single reset. */
-	WARN_ON(id);
 	ufs_qcom_deassert_reset(host->hba);
 
 	/*
-- 
2.25.1

