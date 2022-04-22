Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E69DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 13:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447935AbiDVNZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447924AbiDVNZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 09:25:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6858390
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d15so10806449pll.10
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UmOApO6ixe70PdHEViIKrF0MVsQtQSBHzDTAzdr8K48=;
        b=RDUmUjJOVCU9Gom6PIQB7Om6auvTkQ8MtrvaaFjuQWx+PPVuYsNATY7Sju+1neEH4U
         zuFcEHYhQSKPIvjiLdEmRY0wLcoJFpbvpSP+g1JkKek1hjbpsbmDGVm0gDdYMIRC3g1f
         1fCIld1KjTLpEtyAbXDrx6KjokXhKep17zeHKLgD27bUW1QjWt7vsEKykUWh9s7eTWdk
         FcTliAuQJ2Y+lX72APhDhiGKToK1D+rn0M8ipUbEhli2dcC8O5j1jKru2wIJD6GjF50D
         FyYVhTr+q88S6lNC2I0JyJqZb9LoQ+lsepMfJLddTgYSfS6WbrwyaputeM38AcVtYI7l
         5z+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmOApO6ixe70PdHEViIKrF0MVsQtQSBHzDTAzdr8K48=;
        b=gQ9Rj3rz9/73jXqMe4XhJt21DHmu5PsKHhs3oW65Ec0HpVSnCJuU/N050iZmvzzhzQ
         Qs9xQ8foQM1+ph2EBS/Nq9Ux2DuLI4twablpDFZz4XMbsoe5UszEg80NtMCnJJqXn5SV
         tpZQeuxqXFungTkPk4429umS+RGEyIdXbqSqmOS3MN/9MCHtAbpqi7L40gq0xyYjpw/9
         YEwZ59AkhtR6V5Y+0/dI+Z8eS8/M00TPtTIxAr2jMbBFekuH5cuzQZAtKn+UN62sNsEH
         ciOu7Srf9rz0lf1MT0DkVxiPrtuQbT+tH1cGIuph64b7DNiD08SXx8mH8LcKIT7chmT2
         YIDA==
X-Gm-Message-State: AOAM530XS89PXqAQ64zNbuam+gVNdEO+46aAWEdLBMfw7FQRBzGegoKP
        QhsEvaGC59tP1N3x7P1RGSZy
X-Google-Smtp-Source: ABdhPJyjSvRzPdzCjO9rxGq3kz927rM2kTVx3GjigPQ8cqLCXqTCHKS1iZuURIg4z6JcfYUsv5Hjuw==
X-Received: by 2002:a17:90b:3b4b:b0:1d2:e3fe:e1a0 with SMTP id ot11-20020a17090b3b4b00b001d2e3fee1a0mr5427666pjb.78.1650633738937;
        Fri, 22 Apr 2022 06:22:18 -0700 (PDT)
Received: from localhost.localdomain ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id g13-20020a62520d000000b0050a923a7754sm2586840pfb.119.2022.04.22.06.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 06:22:18 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 4/5] scsi: ufs: core: Remove redundant wmb() in ufshcd_send_command()
Date:   Fri, 22 Apr 2022 18:51:39 +0530
Message-Id: <20220422132140.313390-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
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

