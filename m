Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB34C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Apr 2022 14:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiDWOGA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Apr 2022 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiDWOF6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2022 10:05:58 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BC2E9D6
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:03:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j17so10612540pfi.9
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LRqPM8Zvp3lwETnXLMwqMk3HESblR2v/mANOyDUtzYE=;
        b=ClZ7lL4jeueQ6LPS+MkvP4LYpFx6QKXAKMQ/nWGrH/BPWN1U7B+5Zy2+YToXH/+sXu
         xoXP6ICn0kxxG0/g6Em25EVWmqU5oBJthhv27LoLFBo6mwVdEkZSt0OlgwYsAldpIl+l
         vudxxk+nlPU7IgnzRM5FBqNHaw+C552c00wPPvINlzBf/613TlyMyo+1lZeP6o6Ovjie
         rQo9IqHLnUAoGLxWrkgJaUTuvzNbLvQFXYEdLChcELNDg/IyCsYOGeqm61AcBfba8vXJ
         9TloAtSNg2aa03NscUlzwlP9yviINQdp9AJe/Il7CIn6BcRLrCprBZxj2A0Z3zEtdIQk
         cwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LRqPM8Zvp3lwETnXLMwqMk3HESblR2v/mANOyDUtzYE=;
        b=n5BVNhPkmcc8LlejglS/wTSl8e7jf0Le2EMAWX24+Z5EgO2SunXq6ootaqo88NKnAz
         DlW/iTatsq/oRQeGU8ThWYa1KPQOVYCmb9O3Ii7ael+cv1YwvFF3eJx1sfIy47Raw8Ni
         6WKYBH87eA7ey/8PFsjvu14O/zWofctkgtF2MTzLvEE4WIVVmhOokM0f7H9beGY6sntn
         gzVRxXynKvqNK85o9TuDg0y3ys3C7LWr6ahxeAoDH3qT1B5HvtRdZRZaRDChPPd2w9Uk
         d9GK1tA+Ft3Es5SxEDq1SiuaHVmePCVY9U0ULRqakd5Ruy7VTDU2cS5ohkD8oF8yQZX6
         IJaA==
X-Gm-Message-State: AOAM532i6ngcWYG+vBx2ASo1YvslyaTyOX0QDln6ai17mBFa+Ghw/ZRY
        2SZ7Lt4cn074YJKwapjVDiio
X-Google-Smtp-Source: ABdhPJxHEooxiAMgCN+mdGbrtkZj+De/PaSn1cJauQes/0iCd1DlY0VSWrBwC7oI3Qap/3/hakrEeQ==
X-Received: by 2002:a65:5286:0:b0:398:dad:c3d8 with SMTP id y6-20020a655286000000b003980dadc3d8mr8175325pgp.228.1650722580237;
        Sat, 23 Apr 2022 07:03:00 -0700 (PDT)
Received: from localhost.localdomain ([117.207.28.196])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090a390500b001cd4989ff50sm9452728pjb.23.2022.04.23.07.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:02:59 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 1/5] scsi: ufs: qcom: Fix acquiring the optional reset control line
Date:   Sat, 23 Apr 2022 19:32:41 +0530
Message-Id: <20220423140245.394092-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
References: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
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

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 0d2e950d0865..bee81b45299e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1002,13 +1002,13 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
-	/* Setup the reset control of HCI */
-	host->core_reset = devm_reset_control_get(hba->dev, "rst");
+	/* Setup the optional reset control of HCI */
+	host->core_reset = devm_reset_control_get_optional(hba->dev, "rst");
 	if (IS_ERR(host->core_reset)) {
 		err = PTR_ERR(host->core_reset);
-		dev_warn(dev, "Failed to get reset control %d\n", err);
-		host->core_reset = NULL;
-		err = 0;
+		if (err != -EPROBE_DEFER)
+			dev_err_probe(dev, err, "Failed to get reset control\n");
+		goto out_variant_clear;
 	}
 
 	/* Fire up the reset controller. Failure here is non-fatal. */
-- 
2.25.1

