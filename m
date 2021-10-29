Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA67FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 20:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADE676101E
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ2U1L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2U1L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 16:27:11 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789C4C061570;
        Fri, 29 Oct 2021 13:24:42 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id h14so9466141qtb.3;
        Fri, 29 Oct 2021 13:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RJ/TZBmAjtBZEQ7SF9pt737iGPmZZZE1EbwprVB6+B8=;
        b=V7zUdGU5OyPHKOSW+97qNFQxF978EXAixxGqEZ/Y94ga83e7oOSPzqKe+u2JVmW7Jm
         Bodlq8QjoBnsQpOQNr800FHsezKSLgcnEYmVL8K6cy5nfykrtBWhdaHwV+f5nSyE3E7l
         9NgumIDsGN6PIXx77Igm39kZUDxzmIBRIxdQNHDdHPNEgIJkEy1shiABtP8DPqzikX/u
         k8/vJlbeJkVTaTjFm4T2IqglG2X+PfAYU5FyTXTFV4RiUxfhbcSlsWDtdZZANarSvAZu
         00A0UjgGdy6pvLHlfiJKOFii5OmfW9Fywp8C6h5AL5dlP59Ha6Xf4x/VPJsD/KDYK4U4
         LgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RJ/TZBmAjtBZEQ7SF9pt737iGPmZZZE1EbwprVB6+B8=;
        b=A56jMOOPy+kNRXRd+9j8QDtSPp64s9wH/F6XMUHciCSbq9GWRmc3q3l4P48UqkTOfn
         Mr855zgbJh4I+uB360Zls819KuLGluyvXAdnehDkRtxKWK4TZtuEllFRNp3LEbDybVwO
         YAhun7bgCryHuxHCJ3mpoErAdlw/0xpmzqdb58jQJ6lA+/n07G2mAks8+/8xag8p5/RT
         VVtziIq3dF08grJlecW9PKh2V9n4Fu9/WCkJkqdy31lt26BksZtT5YuYZhsIjIHC8GfY
         YjJDeqpUODJt4xfojSiWMEdyOplCchactk++TQZ8FUccS8frvLa981OkMbVs74UxWbdJ
         jVwg==
X-Gm-Message-State: AOAM53079wf7iGz/mI5mWLfdldQr6rOklUIOIsHG66gGXy02jZhCeAGa
        p6XZWGO4GAQBCKczWcDt+PE=
X-Google-Smtp-Source: ABdhPJya7bmi6pDdo/iMNTHJWIU4eYbxNXYFcRILq42pUwlmuwMZjKIoei7zADYgavD0zqajD5BSBw==
X-Received: by 2002:a05:622a:18a6:: with SMTP id v38mr13999725qtc.208.1635539081677;
        Fri, 29 Oct 2021 13:24:41 -0700 (PDT)
Received: from ubuntu-mate-laptop.eecs.ucf.edu ([132.170.15.255])
        by smtp.gmail.com with ESMTPSA id x6sm4851479qko.83.2021.10.29.13.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:24:41 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
From:   Julian Braha <julianbraha@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        rdunlap@infradead.org, daejun7.park@samsung.com
Cc:     fazilyildiran@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: fix unmet dependency on RESET_CONTROLLER for RESET_TI_SYSCON
Date:   Fri, 29 Oct 2021 16:24:40 -0400
Message-Id: <20211029202440.7852-1-julianbraha@gmail.com>
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
+	select RESET_CONTROLLER
 	select RESET_TI_SYSCON
 	help
 	  This selects the Mediatek specific additions to UFSHCD platform driver.
--
2.30.2
