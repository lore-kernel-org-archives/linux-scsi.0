Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE114C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 08:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346513AbiEDIp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 04:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346502AbiEDIp5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 04:45:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06EF2495F
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 01:42:21 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j6so599439pfe.13
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2022 01:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etgYlkH3k2xXRU0EPxeVLwk/8dv8OjRMpkT84HZHGoM=;
        b=z1AO52bLTWmTJ8A7Q6s3QcGmTgAdj0o7TNsqfNXXAmUq8DvJHiILWvfwru19sfhbJ5
         5cAdlKhpx7fcCGwB0UveWcFIV1wnkIm5wd1h75Lri4h6nIcwvKxR5YmE4oUuImB1M6ZV
         uoV39+ELAre9YhW4MTrmF4DrOHcTwBC+vKeDBcJHhXexd4MbifLsrKBESSl9ebyZhmWV
         +7b8O/Iv/k+g4Mlmkk896ZNWqK3g40oPPpy2yJ5DoRbYOC7+bpga7xskzruUIaojD/bv
         lLWVeTTOXZIsQCGNmQQ+6OrZAH9kkYCeRUz2kAKtKGljvKRAEvC/RFNUldjTFV/dI2mr
         lg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etgYlkH3k2xXRU0EPxeVLwk/8dv8OjRMpkT84HZHGoM=;
        b=7tr2JrHaLFt09HEIdN+UuSeRpe4DKxvCKvx0mxWJpba69SC5mNxAIKIj9kI6kK+RjN
         ijEXlJGhRq6crg33ROJI2CqAIJiaSU65CJmucbPGwIvCaYCSWNOTSvhW4NDaCEsGwJb/
         aLmFOdJFFt7IixVwQka1xxtlH2lKNWxxnTBu2t043QbcX76nG0Vyyr5NQx4Dk0F5HiY3
         VEVuwHua4zd63pKZhLd32kd2q4P6hOGUTALpYDOyc4i8sD6HYwO2L77A1/HoYxmXkztS
         LpAJFWX3vd49SrdmJCSBf8Jcrq/F8PsHpolvcxeipOBWOa9G5z8eeBGTtwwzkJ4Cowtt
         Tq+w==
X-Gm-Message-State: AOAM531jQw4EyapfvGdHfZ5RDiLQXPxeBXAiriCZuMHxWUXPaRl7IZWK
        q4ngX1I+11oZrC1a3px7gP6q
X-Google-Smtp-Source: ABdhPJx49Z+kce5s/YOsUZbN8QNh0gOcYuyEbYmWwzEjaux7d1kzE1ne3dcS8k+Pyq/HTyfRJ9WQCg==
X-Received: by 2002:a05:6a00:298a:b0:50e:8e3:b673 with SMTP id cj10-20020a056a00298a00b0050e08e3b673mr7996582pfb.28.1651653741451;
        Wed, 04 May 2022 01:42:21 -0700 (PDT)
Received: from localhost.localdomain ([27.111.75.248])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b0015e8d4eb278sm1386561pla.194.2022.05.04.01.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 01:42:20 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, ahalaney@redhat.com,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v3 0/5] Qcom UFS driver updates
Date:   Wed,  4 May 2022 14:12:07 +0530
Message-Id: <20220504084212.11605-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series has some cleanups and updates to the Qcom UFS driver. There
is also a patch that removes the redundant wmb() from
ufshcd_send_command() in ufshcd driver.

All these patches are tested on Qualcomm Robotics RB3 platform.

Thanks,
Mani

Changes in v3:

* Removed check for EPROBE_DEFER and used the return value from dev_err_probe
* Collected Reviewed-by and Acked-by tags

Changes in v2:

* Used dev_err_probe() instead of dev_err().
* Removed the wmb() from ufs_qcom_dev_ref_clk_ctrl() as that is not required.
* Added Reviewed-by tag from Bart for patch 4/5.

Manivannan Sadhasivam (5):
  scsi: ufs: qcom: Fix acquiring the optional reset control line
  scsi: ufs: qcom: Simplify handling of devm_phy_get()
  scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled
  scsi: ufs: core: Remove redundant wmb() in ufshcd_send_command()
  scsi: ufs: qcom: Enable RPM_AUTOSUSPEND for runtime PM

 drivers/scsi/ufs/ufs-qcom.c | 45 +++++++++++++------------------------
 drivers/scsi/ufs/ufshcd.c   |  3 ---
 2 files changed, 15 insertions(+), 33 deletions(-)

-- 
2.25.1

