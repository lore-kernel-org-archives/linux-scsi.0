Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA925C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 08:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiEDIqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 04:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbiEDIqB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 04:46:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E321E2494C
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 01:42:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p6so641594pjm.1
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2022 01:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jvFCRlCjBMgPf5hAFpHc9zQbLQ5BVzGLk4EI13vVODg=;
        b=v5tFf9EmJW+BrMhN/JlKVvAfBKyWpOSBIbSY9r9fkCwwlm2R5gwNOT5uiDPmDfVuxw
         9wstU7IGub4N0PtC5aCVVVY74FotQ8nLobC3j4IRLF4qkkHx9aUiI2awBMETGsmYKHID
         7uv/LJn0rbpAzMsZBTruyZ7IW+SzPoy4YaBpvKEaV9TshS8VP8A2Lvilf0tsGwgp1upH
         fqFH0iHZh0bWzeB/Kpw3teXCZVhGrzH9b4yMriL7wbkh7+erpasN8QPEBMPsUDVKwglw
         m1l55qepuB+sPRmUPr5/01eRkobWdbnhV6tQ8wpoTm0SvWq/2VqWoaUxuAdSCTGGzX18
         3Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jvFCRlCjBMgPf5hAFpHc9zQbLQ5BVzGLk4EI13vVODg=;
        b=yYYSrsY+CVLVs2nRL2ZEpddRfGty69ZRUUwULrAB3NfjCJZW6vwtctGJB55Z+mtpP7
         npXVyzO4or0olYMWG4uCtsnPLNcm7IwG2QSePEBx3DsREmagYraZXc/zq+9pZ1/G4/oO
         aSDTtnxbgmLKFPWf/XUy7OW7mDOg/5T6Q8oEwoiRRXlJx+bqqkw3n7RsoRKTgZyRhKcr
         M+zXaZiBDgsFxBMQ/jcLjSuNM480pU+wNMSL3vuAgokOG5Cijdc6h7mglkcJ3hVi/KTH
         r0qUJ1skHHwMzpF6mydGYpCHYII5H2spcjun6etdhYav6lT+hIqPd0xcz0oErHP9z5Ql
         NiVA==
X-Gm-Message-State: AOAM53186Wc980vMyjeWF/MngisD3rUuCCBmVF+DmARK5niqG4xFYtb1
        89lgYqbDg2W/PmQOR1zBTb/i
X-Google-Smtp-Source: ABdhPJwzte6tnj3o4ehJEi8t+m4u0RNbwDA5S+HTA91nT4VQQl9sjL7VYTPkdMV+BHeugSqr8mvsJA==
X-Received: by 2002:a17:902:a613:b0:156:b53d:c137 with SMTP id u19-20020a170902a61300b00156b53dc137mr20444445plq.73.1651653745422;
        Wed, 04 May 2022 01:42:25 -0700 (PDT)
Received: from localhost.localdomain ([27.111.75.248])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b0015e8d4eb278sm1386561pla.194.2022.05.04.01.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 01:42:25 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 1/5] scsi: ufs: qcom: Fix acquiring the optional reset control line
Date:   Wed,  4 May 2022 14:12:08 +0530
Message-Id: <20220504084212.11605-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504084212.11605-1-manivannan.sadhasivam@linaro.org>
References: <20220504084212.11605-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Qcom UFS platforms, the reset control line seems to be optional
(for SoCs like MSM8996 and probably for others too). The current logic
tries to mimic the `devm_reset_control_get_optional()` API but it also
continues the probe if there is an error with the declared reset line in
DT/ACPI.

In an ideal case, if the reset line is not declared in DT/ACPI, the probe
should continue. But if there is problem in acquiring the declared reset
line (like EPROBE_DEFER) it should fail and return the appropriate error
code.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 0d2e950d0865..9e69b9ac58f9 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1002,13 +1002,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
-	/* Setup the reset control of HCI */
-	host->core_reset = devm_reset_control_get(hba->dev, "rst");
+	/* Setup the optional reset control of HCI */
+	host->core_reset = devm_reset_control_get_optional(hba->dev, "rst");
 	if (IS_ERR(host->core_reset)) {
-		err = PTR_ERR(host->core_reset);
-		dev_warn(dev, "Failed to get reset control %d\n", err);
-		host->core_reset = NULL;
-		err = 0;
+		err = dev_err_probe(dev, PTR_ERR(host->core_reset),
+				    "Failed to get reset control\n");
+		goto out_variant_clear;
 	}
 
 	/* Fire up the reset controller. Failure here is non-fatal. */
-- 
2.25.1

