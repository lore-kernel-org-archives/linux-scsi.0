Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4A2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 04:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiGHERT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 00:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHERT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 00:17:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7995C2655C
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 21:17:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d10so8760067pfd.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2022 21:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MNbzz6HqiT+aecUMfuE4HCVdk2tTR9rWqUJn0foYaOs=;
        b=oY7JqxN2PctvkKLjoYKFZyyXgicFmSo0BLEeEtO+de9X5TF3XFOdIHs2BRhVNO0+0e
         Wl+au6rKUin2DCSdQVaGmM605EOjQ38w7auKF7EAXjqgG6eZXyVfk6jJZXgH5hGOKIoA
         Iu20bdc2ZsNp7n0PZje8YFi2fCYvRVXOiKkiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MNbzz6HqiT+aecUMfuE4HCVdk2tTR9rWqUJn0foYaOs=;
        b=M2gCCAMbZ8tNUtQYXKOSTE54lfUBpfP95Pt5BGLcpRiCB+XzP/vIoL3r4ORjmMSpGV
         N7LVFQ05ARWl8kN0SUoQ0IUJBZBk7NlrKS+ItWwGCE+oivheItNPSvIQLni+IgfFF0Dq
         3mFPEir3v+C1rOO9EBQG6mTv8C6d6pKWCGb0Nrq8aKCLT/VQpQsuYNXdTOJbJFNPmeWs
         WU00RnpGdtQnE1POojOtFgbvfN/u0rXdkLpdQSfQPeMTzKqReJw9ONZfxu+69JWscGzK
         ly3G7yHcFn7Y9z30TKpgGMGCZmzqooeHJvmvZSWn9ZcjBU653IB6+jcdCT/Vi0vXGw7E
         eWTw==
X-Gm-Message-State: AJIora/wbtahVItnuwsFq4euMmtKx4SFqDBK+K8jDRS52TRXOv6/Y4N5
        H7KV2MgfbjbHJHVSOMDt+x2tPw==
X-Google-Smtp-Source: AGRyM1u3YRxbpHHoAR2gLio3os223bzxP+inwrZHFd21UtN01SzXjzuwNuJq0VZUjYZDjiasTgFdLQ==
X-Received: by 2002:a63:1759:0:b0:40d:5aba:4bb0 with SMTP id 25-20020a631759000000b0040d5aba4bb0mr1512690pgx.496.1657253836714;
        Thu, 07 Jul 2022 21:17:16 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id kk8-20020a17090b4a0800b001ef899eb51fsm435629pjb.29.2022.07.07.21.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 21:17:16 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: default clock frequency for Intel's UFS controller
Date:   Fri,  8 Jul 2022 14:17:07 +1000
Message-Id: <20220708141612.1.Ice2e8173bd0937c7c4898b112350120063572269@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ARM platforms rely on 'ref_clk' of a UFS controller's node in DTS to set
up the proper bRefClkFreq for the UFS storage device. The facility is
not available on x86. To circumvene that, default the parameter,
responsible for carrying the value to the UFS storage device
initialization, to the one that Intel's controllers support. This is
required to support provisioning of UFS storage devices from userspace,
without relying on FW and/or bootloader to make the necessary
preparations.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>
---

 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 04166bda41daa..a6f9222cbea74 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -336,6 +336,7 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 	struct intel_host *host;
 
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+	hba->dev_ref_clk_freq = REF_CLK_FREQ_19_2_MHZ;
 
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
-- 
2.31.0

