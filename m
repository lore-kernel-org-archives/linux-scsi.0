Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AF1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 12:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiGOMsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 08:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiGOMsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 08:48:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F897479E
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 05:48:15 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p9so5558584pjd.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 05:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WobHjGnXEstvgY9WdzvQAd+zN5fEdHbmcar/6NVFvmg=;
        b=CGnX2SotKISaTXX/p06h0MAF5ZCZ0iIvMuo3YLy6PMGAeaRm1xyMHrMbWOZkn+nUbN
         4PA7evUzpLDzIavz/6M9ygc79bzabOHCcBrKX9YhW2vY0DL7w3aTBj1vWESoeR8rk5nC
         Yk3WFs3hBq4LTpMWms8ZQOAtuLwtWKL4g5skI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WobHjGnXEstvgY9WdzvQAd+zN5fEdHbmcar/6NVFvmg=;
        b=l5sWSjTQ2gWTVsRPtbW2/hezNXm2+kNsYSd982V8o6m4nEGIJC11nOnrxjJWSVdLzQ
         pJM2/c8eh9nzTyMEGkjXjMCE/ZZeZNnZ6cQqoZVAxQr26gRZUZKb+HnMsDs8Y2pDR/Ga
         c1w+tL0yXZ2lXFUsJ/hvB6FB/Vaa1RGOjnW0DsbxjIwsHedT7dGxZc3lz1uhW54/U0pM
         Qk5Ca2OZXNUJpiWqiTa+DUkDHK/T+5uhU/Klr/TT3E6gMfxw+lEC9WUvhvojUQ+8pcl0
         hKTi9j7BNJyYQcg56au1n+zweKF07roezW2fn09G5CfMdsnexQg2m2t+RWsm7dqv6Omg
         Pn+g==
X-Gm-Message-State: AJIora9m1DKQYwQI1BJwc+HFAOi+Uber+Inivy3TNheYOiDJja40p6VM
        8DUaarpvTcD3cFf6ubfbhruH6Q==
X-Google-Smtp-Source: AGRyM1uujm85L0CQUZcgqAYRbsZtc+sjUu6h8mrLFguMbPMHGLQstpqScMdP7AHPirNmcMiLV/A7zQ==
X-Received: by 2002:a17:902:988b:b0:16b:fae3:fcd5 with SMTP id s11-20020a170902988b00b0016bfae3fcd5mr14026480plp.109.1657889294789;
        Fri, 15 Jul 2022 05:48:14 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001690d398401sm3530730plh.88.2022.07.15.05.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 05:48:14 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-pci: Correct check for RESET DSM
Date:   Fri, 15 Jul 2022 22:48:07 +1000
Message-Id: <20220715224722.1.I22460c4f4a9ccf2c96c3f9bb392b409926d80b2f@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dsm_fns is a bitmap, and it is 0-indexed according to the check in
__intel_dsm funciton. But common initialization was checking it as if it
was 1-indexed. The CL corrects the discrepancy. This change won't break
any existing calls to the function, since before the change both bits 0
and 1 were checked and needed to be set.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

 drivers/ufs/host/ufshcd-pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 04166bda41daa..e54a49e64acad 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -20,6 +20,12 @@
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
 
+#define __INTEL_DSM_SUPPORTED(host, fn) \
+	((fn) < 32 && (fn) >= 0 && ((host)->dsm_fns & (1 << (fn))))
+
+#define INTEL_DSM_SUPPORTED(host, name) \
+	__INTEL_DSM_SUPPORTED(host, INTEL_DSM_##name)
+
 struct ufs_host {
 	void (*late_init)(struct ufs_hba *hba);
 };
@@ -71,7 +77,7 @@ static int __intel_dsm(struct intel_host *intel_host, struct device *dev,
 static int intel_dsm(struct intel_host *intel_host, struct device *dev,
 		     unsigned int fn, u32 *result)
 {
-	if (fn > 31 || !(intel_host->dsm_fns & (1 << fn)))
+	if (!__INTEL_DSM_SUPPORTED(intel_host, fn))
 		return -EOPNOTSUPP;
 
 	return __intel_dsm(intel_host, dev, fn, result);
@@ -300,7 +306,7 @@ static int ufs_intel_device_reset(struct ufs_hba *hba)
 {
 	struct intel_host *host = ufshcd_get_variant(hba);
 
-	if (host->dsm_fns & INTEL_DSM_RESET) {
+	if (INTEL_DSM_SUPPORTED(host, RESET)) {
 		u32 result = 0;
 		int err;
 
@@ -342,7 +348,7 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, host);
 	intel_dsm_init(host, hba->dev);
-	if (host->dsm_fns & INTEL_DSM_RESET) {
+	if (INTEL_DSM_SUPPORTED(host, RESET)) {
 		if (hba->vops->device_reset)
 			hba->caps |= UFSHCD_CAP_DEEPSLEEP;
 	} else {
-- 
2.31.0

