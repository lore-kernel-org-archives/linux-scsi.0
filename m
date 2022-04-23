Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B326EC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Apr 2022 14:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbiDWOG3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Apr 2022 10:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbiDWOGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2022 10:06:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C456970C
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:03:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so17024671plh.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HOUTFPbu22ppgcVB4V3XnLLhY4JA+8560SHGB8wOxqY=;
        b=B00Aj1G+387EpKefln4HxPxr1NRUaFu0sbV7qLEWg+i9TZLPp8f+0LmHsaWKgINx1J
         kUmuO+z1n2iK9fbEy1SC11B0PtdDBIYqPphNaQZQ1SDKkzW3UjZ77s5YdLoD+tf4FZCQ
         +BjMQYGfp22+VpQqb6JuHB6/BRnaytFbGndVMzR0YlWGxvLkPYdhUAC7iBv4wSjaiq3I
         kk1vAWgCA2/YOQlix65cEpCo2hwEYOc5aTfGWPM6mJvfbB7asXA68Sod+rAqaer+6yME
         RUfo/f9ibIAnugf9RM9me1kE/THio3yI5e8hJlGlD0NAQY39nkQpsYP2LqrQ6Vn88a2s
         1I5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HOUTFPbu22ppgcVB4V3XnLLhY4JA+8560SHGB8wOxqY=;
        b=sNqLVW5bbPE6b1D2aa/jQbbm83wjHAf1iY+e0iTAshNTKepq5WoeVhveJtZuUWi5Oo
         G4xAzI3SDwLXIefXY9v3dCtt2OBul27X9v4IY1xpRzyHrLwF6PzJ23EHeXEJTBJCM4J8
         A1hxexzofMt2Yn8lWbzocyIgQ4wW0MywJ2uB4sfH1608gbiUAdD3tmOk/FVf6SGRr5V4
         wXPyPSsbF2OSnUOVfcyr6lePR7THnj2uPKPxuM+RXMfznOL5Sq1GFlaPFqKhWZG2lXAD
         i9fX7HX3K+lqHnv2kvw8kd366yhl+PfROx91vBKMDCz8V9JHS56ZFNGq//VdxTOg2PhD
         p71g==
X-Gm-Message-State: AOAM531ijOm7gmS+sogzdMgVOrBW2WUAMwaKg1qiklONh+wi7WtwmnhA
        kYMA53EGECFN48Yb8FRKu+SZ
X-Google-Smtp-Source: ABdhPJwcDOs+2VCZw0GWS59MHpK8L9fcQQPTAPVWbEKGNXUoMmAze1qm6/W/wYzNHHgg3PPwzB9LOA==
X-Received: by 2002:a17:90a:dd46:b0:1b8:8:7303 with SMTP id u6-20020a17090add4600b001b800087303mr21790716pjv.197.1650722595861;
        Sat, 23 Apr 2022 07:03:15 -0700 (PDT)
Received: from localhost.localdomain ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090a390500b001cd4989ff50sm9452728pjb.23.2022.04.23.07.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:03:15 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 4/5] scsi: ufs: core: Remove redundant wmb() in ufshcd_send_command()
Date:   Sat, 23 Apr 2022 19:32:44 +0530
Message-Id: <20220423140245.394092-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
References: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wmb() inside ufshcd_send_command() is added to make sure that the
doorbell is committed immediately. This leads to couple of expectations:

1. The doorbell write should complete before the function return.
2. The doorbell write should not cross the function boundary.

2nd expectation is fullfilled by the Linux memory model as there is a
guarantee that the critical section won't cross the unlock (release)
operation.

1st expectation is not really needed here as there is no following read/
write that depends on the doorbell to be complete implicitly. Even if the
doorbell write is in a CPUs Write Buffer (WB), wmb() won't flush it. And
there is no real need of a WB flush here as well.

So let's get rid of the wmb() that seems redundant.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9349557b8a01..ec514a6c5393 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2116,9 +2116,6 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-
-	/* Make sure that doorbell is committed immediately */
-	wmb();
 }
 
 /**
-- 
2.25.1

