Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0095EC41513
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 04:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjHBECJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 00:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHBECI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 00:02:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C66119
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 21:02:06 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bb84194bf3so39779655ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 21:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690948926; x=1691553726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vG5UMw6bFZ2XuN8CCsSVN9Y60w1sWvQGrsbmsXSfDCg=;
        b=l0OlMBx+GytmlHiryoJm4BsFsflyHSrNEeowcnna3sb2VRaFNPQCkpXkOpIbypjAXi
         P1qKRrhuGKhoouanf6XjGT8QqcWaAklLPjPvz19Kt2vdqd3OfaeH5CWRXMVwkP/VIDaI
         Q3ejhBU1HEbl40qJvIQI/P8DnE1TQmXaQB3Uv8XKF4jtXj+Pe40hkHTfBPuKKORRfwmF
         BZ25EDRGgRABT1sRKMrBqDNiqT1VzNPpdNkkSZGk3Fekj+Ud8ayt5KJmp2/loDq0+hEt
         UcOqeSdiYu+eUPiLzYwNkJ8bpFcuoKXcmpj+UU+pUCs2uedvZa6tz2CG/p3gCUflrPaF
         z5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690948926; x=1691553726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vG5UMw6bFZ2XuN8CCsSVN9Y60w1sWvQGrsbmsXSfDCg=;
        b=kHcTSopeYBy+qyVMgoFTskoZVNG82XZusFpN6LFxedjpocdMh18kd4dL0O08R76AsJ
         KxJnASuF09n/EsQTNZmf9kIdrMJuma+G7vQ1xRsG62kxYr6epRwtQbP/G5GJ7sUmoH0L
         NR3vMUcQ4d0sedd5hMb1kUtT4ELtYXGlNG4ySFPH3dqKKX9pu2N6QTzaJUAWjnLBd3LX
         Xn3Jdrc6jNgHrDl/ORDgDM3yF/eM1g6tTrPyhj600JDBeyathFXsjtu3FPY4d4LyK/oL
         c0SktEObujIjRzCGzAUjuOKQd5NSX0Go9lOEExqspd1wBk0EuZEd63r/KLWuPwTIlo/V
         781w==
X-Gm-Message-State: ABy/qLbJDBNINoj74yaaLW9IWPe12fB7p9wKiVVbUYUlSBjmgraAD0Tj
        6J4n8PF9cq7g2xnc2332hhzC
X-Google-Smtp-Source: APBJJlFdwviOBoJsVp3olVv/BcGe+WEfRsc/zCYIAaAGRExJh38BwE9IFhqgUoI63zUxsukJQ701Aw==
X-Received: by 2002:a17:902:e551:b0:1bb:a125:f831 with SMTP id n17-20020a170902e55100b001bba125f831mr17474097plf.58.1690948926150;
        Tue, 01 Aug 2023 21:02:06 -0700 (PDT)
Received: from localhost.localdomain ([117.193.209.129])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d50c00b001bb8be10a84sm11202710plg.304.2023.08.01.21.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 21:02:05 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, konrad.dybcio@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: ufs: qcom: Make struct ufs_qcom_bw_table static const
Date:   Wed,  2 Aug 2023 09:31:54 +0530
Message-Id: <20230802040154.10652-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufs_qcom_bw_table is not modified anywhere. So make it static const so that
it can be placed in read-only memory.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Closes: https://lore.kernel.org/linux-scsi/43cd0057-c6d8-bc92-08f4-d767336d2cfe@acm.org/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 75a1fd295f34..0341c025e818 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -58,7 +58,7 @@ enum {
 	MODE_MAX,
 };
 
-struct __ufs_qcom_bw_table {
+static const struct __ufs_qcom_bw_table {
 	u32 mem_bw;
 	u32 cfg_bw;
 } ufs_qcom_bw_table[MODE_MAX + 1][QCOM_UFS_MAX_GEAR + 1][QCOM_UFS_MAX_LANE + 1] = {
-- 
2.25.1

