Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57041C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3002D206C3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hYKEptt2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgFDGg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgFDGg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2020 02:36:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33498C03E96E
        for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2020 23:36:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id bh7so1801293plb.11
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2020 23:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3OTdeVCvSUjOBcj6MS4hXMUrhdRM9CDvX4e1/CfV3A4=;
        b=hYKEptt2qyz/b32b0YAtEha20e0sYfLCeLpb93ZQit9FI0v559hjC6QoUSoCMHMQ80
         FyuIzbyMI9wpBSN0A+N4TmGbIr9/2WEMfeWQddlbcLfBgrIr9wxMDhyOz2MHaB2iLUaF
         /dug2Tp5tbHXmSmHZ98Kk5UkOGLDij/L9G6vJX76bdfX6cwDM7pnb/+GxQMCDzu7tMjC
         rCzhLJPGVZZWuXJcsPYBhISx7F5m0v9LV99iQpG15f+jLdRQLs6nvMqQ2zT8OevOehWi
         fZlEtafJVXEn9qzHeN+ajzCewsWfUR4aVAXkIr2GIUoI/poUsT8rjdoVXQL0nm3H91ye
         l/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3OTdeVCvSUjOBcj6MS4hXMUrhdRM9CDvX4e1/CfV3A4=;
        b=HUIL8YXXyUd+MaqNCtG00GEDyI9Tnul2RMJhBIMxQpcapU6uDKXfOApuaTWtpBqxeH
         OlAIEMuB4HAJtrcPsRIrrbJ1qAAX6h63GrBZK4QKzyvFcZ8pw96tkA3qnemFRyyxqBZh
         sNcwguSFPcUYv9X6ADm4gYH94BD8l/NZ6z55GU53cjho/wCs28ARqWWeCU0/QdCnf1Ro
         8vtKOSFpjmAHGmZjjkYdhLNuHqOreILnqmv1rxPl5UcMPpzAjVC3Rkpe8f1BtlD8kbaE
         dmb058FvdqjIYDwtZEng9wlEmlMyQnMv9Dr0nkwG+vUzuXYjBw64NZqPPnNMskl3WpN9
         Nm5Q==
X-Gm-Message-State: AOAM532B3FJaKBcfVghroVP3erSDLAsE0A42krZNyMTbSAaYzdmvdq3R
        lRcL6jS7H8+DBp9RsEomeI3w
X-Google-Smtp-Source: ABdhPJxZFyD9ApfGTaosPM9xnsxT2eLocjXpwskWZ/m7MbjMnO6O7YogS3uzJgd4BXSlU/GvAToGAg==
X-Received: by 2002:a17:90a:6584:: with SMTP id k4mr4332997pjj.171.1591252587482;
        Wed, 03 Jun 2020 23:36:27 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6e90:f3d4:c404:4d38:8396:d1ee])
        by smtp.gmail.com with ESMTPSA id r205sm2040767pfr.112.2020.06.03.23.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 23:36:26 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, amit.kucheria@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH] scsi: ufs: Bump supported UFS HCI version to 3.0
Date:   Thu,  4 Jun 2020 12:05:59 +0530
Message-Id: <20200604063559.18080-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS HCI 3.0 versions are being used in Qcom SM8250 based boards. Hence,
adding it to the list of supported versions.

I don't have the exact information of the additional registers supported
in version 3.0. Hence the change just adds 0x300 to the list of supported
versions to remove the below warning:

"ufshcd-qcom 1d84000.ufshc: invalid UFS version 0x300"

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufshci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d37cc1c..f2ee81669b00 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -104,6 +104,7 @@ enum {
 	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
 	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
 	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
+	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
 };
 
 /*
-- 
2.17.1

