Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D5CFA3743
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJaSFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJaSEP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:04:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2968713DD6
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f9so11370755pgj.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n09A1w395FEb8CFGE5mj23N+JsxXbyTWGm1Z2TTn0mM=;
        b=GS8oQJDD8gziLB3T6WUk5TbqFCYkzq8n49LYkyJ+Eq+mA1nyAmGsKjbf6xVjwj8bdy
         XocrDFfUr1eGr0a31uzd20iFSjCtGOZjOYqAPw8501lWH9xTFfJEg1NFkOStwrEoLsSV
         iCKPKf5st2Bjc6Aj1BGkVvaHCPyIHVT67bl0HLtbbrZfj4Q6Wy/PKDCbXDx2nX4JQ1y+
         o/XkuII+bdxqrvmv9aXP+yIqqKiesoZeR2Z/sci8gJltFT09BT7MS0IAlG9NHcRgNXP9
         6POsfU70sxDcG5QvrkFmDTvKpeVBuP6kbg4GQVGAOnJ7+IGUj66m2+o5ePi6C5yJ+h5k
         dJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n09A1w395FEb8CFGE5mj23N+JsxXbyTWGm1Z2TTn0mM=;
        b=b/rpfC6vHKSmYFJMMGZhHWcEq2FO8+RtGKsqCttVzwqHqoM2vXxAgANd0VGOmSrBzR
         0OnVABQ0h2toGB9JjUX7dd/vdNjoXcDP1r1o838/0xq5rPUbxvIwE8wUBHsrZO4agMT6
         keoxm45qJLVh7nhtiHBsgslK4T3i6F/0wQSuj4mVJJmlYVpMF50/j6cVYCpQyDnLo3k1
         488lSgeh7UFGQxWw1WLtAnWZ5c2YThPO6iLdE49FanNKOpUgvE0unMBeZytFF8FQ31c1
         fAJ3+QsriDQg/NXIJwdl2v8NjJ7KAw9PZNVk8+i62V/WPa8jd9/ji6uASGjO5yIVdjrW
         B0aA==
X-Gm-Message-State: ACrzQf2tjjGSlXKuQa1Sh4MjFxZSsY0SLhghOTaSopoSv43YKrNTYK0I
        G551o70fX5Ib0X1idae6plXr
X-Google-Smtp-Source: AMsMyM7iPUdZa99KX1tAK/e56i8Nrgz82UzEeY//bWaCEa59H4AXLhQqaUBJo+M0tlSC0DVJaN4vNQ==
X-Received: by 2002:a63:de46:0:b0:46e:c3bd:e47d with SMTP id y6-20020a63de46000000b0046ec3bde47dmr13398495pgi.609.1667239451578;
        Mon, 31 Oct 2022 11:04:11 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.221])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b00186c6d2e7e3sm4742224plb.26.2022.10.31.11.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:04:10 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 13/15] scsi: ufs: ufs-qcom: Factor out the logic finding the HS Gear
Date:   Mon, 31 Oct 2022 23:32:15 +0530
Message-Id: <20221031180217.32512-14-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the preparation of adding support for new gears, let's move the
logic that finds the gear for each platform to a new function. This helps
with code readability and also allows the logic to be used in other places
of the driver in future.

While at it, let's make it clear that this driver only supports symmetric
gear setting (hs_tx_gear == hs_rx_gear).

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 38e2ed749d75..c93d2d38b43e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -278,6 +278,26 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 	return 0;
 }
 
+static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba, u32 hs_gear)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	if (host->hw_ver.major == 0x1) {
+		/*
+		 * HS-G3 operations may not reliably work on legacy QCOM
+		 * UFS host controller hardware even though capability
+		 * exchange during link startup phase may end up
+		 * negotiating maximum supported gear as G3.
+		 * Hence downgrade the maximum supported gear to HS-G2.
+		 */
+		if (hs_gear > UFS_HS_G2)
+			return UFS_HS_G2;
+	}
+
+	/* Default is HS-G3 */
+	return UFS_HS_G3;
+}
+
 static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
@@ -692,19 +712,9 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		ufshcd_init_pwr_dev_param(&ufs_qcom_cap);
 		ufs_qcom_cap.hs_rate = UFS_QCOM_LIMIT_HS_RATE;
 
-		if (host->hw_ver.major == 0x1) {
-			/*
-			 * HS-G3 operations may not reliably work on legacy QCOM
-			 * UFS host controller hardware even though capability
-			 * exchange during link startup phase may end up
-			 * negotiating maximum supported gear as G3.
-			 * Hence downgrade the maximum supported gear to HS-G2.
-			 */
-			if (ufs_qcom_cap.hs_tx_gear > UFS_HS_G2)
-				ufs_qcom_cap.hs_tx_gear = UFS_HS_G2;
-			if (ufs_qcom_cap.hs_rx_gear > UFS_HS_G2)
-				ufs_qcom_cap.hs_rx_gear = UFS_HS_G2;
-		}
+		/* This driver only supports symmetic gear setting i.e., hs_tx_gear == hs_rx_gear */
+		ufs_qcom_cap.hs_tx_gear = ufs_qcom_cap.hs_rx_gear = ufs_qcom_get_hs_gear(hba,
+									ufs_qcom_cap.hs_tx_gear);
 
 		ret = ufshcd_get_pwr_dev_param(&ufs_qcom_cap,
 					       dev_max_params,
-- 
2.25.1

