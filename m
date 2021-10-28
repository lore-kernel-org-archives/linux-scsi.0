Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F650C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385D260F0F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhJ1UiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhJ1UiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 16:38:05 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01A9C061570;
        Thu, 28 Oct 2021 13:35:37 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id ay10so2036758qkb.12;
        Thu, 28 Oct 2021 13:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJ/TZBmAjtBZEQ7SF9pt737iGPmZZZE1EbwprVB6+B8=;
        b=cuXtA5t15HjnPp7OPl35fJNotIP9gC4nBC9TPE9YctYbO5ObFZHbko0xoAiamkVypR
         fb3HPJxSC26+7bEhYxyhm4pk5v9Wb/X3mMz46/h6lc7Q6l5Nq7vTunKQHC6FqQu1jhE0
         jKkbX9xeWuS+72ePM+SNTfgCTMialYZ8nDqW5UgN3E5dHX6uQjvHvoPHGAQAnIsV2Q+Y
         6gcXwignr0+ziJuuiyiSwJhrOoWheNNlCDpMvEj51dMoK8gjnJwBVPGJpefRMfwzLawW
         IGdMQh+udMfdMxl1SJSSIiB6gltmAd46fNUTwxeichW9LFCCoXGevcfXtZFVNwr3Nl7V
         H55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RJ/TZBmAjtBZEQ7SF9pt737iGPmZZZE1EbwprVB6+B8=;
        b=f5IPjMXUd8tPkhtN+tAPdCs06LIAbjN24w8H2Hom2f2s5jkneUkozRQ21/00Jk+Qc3
         7b81AD910t4d+PzFH6w3BZ3zwR6LbKTqcfj99zp7zWCgOBmNkNjDf10LYMTKtpkwNdRZ
         udmyJOcwjfvVLWLzxgptJiDTnBZRlXif18HTk3Kmf9e8MjgvQzhiAeH3F7zNwys9bJED
         x4UmGZIlMqzHvenIV47VG/LkNi9xuIBYDC8D17j9gM/jb1NDuisHDGAENsx6TgVgFRQR
         VhZDolVYxj7uAohg3nGSdQeFqfhDX0q/661hFM0u4HaruvUd6Oitm+PPUQQZiNsjviJM
         Hjwg==
X-Gm-Message-State: AOAM533MfiHj2McP+XEHhkHjuqFJsb5r7Bwu69Zw0pg73UGaoNFw8TBQ
        LD7Vl9IOZcZeuyUkUJQjFR0=
X-Google-Smtp-Source: ABdhPJxTlzO10r5Nzl9pSYnQeYSG2R240FixGykJH96yXDFciOwLRHsZhD7PRGO41qpFtjBEeih1YQ==
X-Received: by 2002:a05:620a:d85:: with SMTP id q5mr5502693qkl.64.1635453336806;
        Thu, 28 Oct 2021 13:35:36 -0700 (PDT)
Received: from localhost.localdomain ([67.8.38.84])
        by smtp.gmail.com with ESMTPSA id 9sm2593575qkn.84.2021.10.28.13.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 13:35:36 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
From:   Julian Braha <julianbraha@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        rdunlap@infradead.org, daejun7.park@samsung.com
Cc:     fazilyildiran@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: fix unmet dependency on RESET_CONTROLLER for RESET_TI_SYSCON
Date:   Thu, 28 Oct 2021 16:35:35 -0400
Message-Id: <20211028203535.7771-1-julianbraha@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When RESET_TI_SYSCON is selected, and RESET_CONTROLLER
is not selected, Kbuild gives the following warning:

WARNING: unmet direct dependencies detected for RESET_TI_SYSCON
  Depends on [n]: RESET_CONTROLLER [=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - SCSI_UFS_MEDIATEK [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_UFSHCD_PLATFORM [=y] && ARCH_MEDIATEK [=y]

This is because RESET_TI_SYSCON is selected by
SCSI_UFS_MEDIATEK, but SCSI_UFS_MEDIATEK does
not select or depend on RESET_CONTROLLER, despite
RESET_TI_SYSCON depending on RESET_CONTROLLER.

These unmet dependency bugs were detected by Kismet,
a static analysis tool for Kconfig. Please advise if this
is not the appropriate solution.

Signed-off-by: Julian Braha <julianbraha@gmail.com>
---
 drivers/scsi/ufs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index b2521b830be7..0427f8277a5d 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -115,6 +115,7 @@ config SCSI_UFS_MEDIATEK
 	tristate "Mediatek specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
 	select PHY_MTK_UFS
+  select RESET_CONTROLLER
 	select RESET_TI_SYSCON
 	help
 	  This selects the Mediatek specific additions to UFSHCD platform driver.
-- 
2.30.2

