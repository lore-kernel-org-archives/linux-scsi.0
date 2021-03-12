Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03165C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C898364FDC
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbhCLJsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhCLJsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:01 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C363C061764
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:00 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v11so1399569wro.7
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulNuxr60llkoiFafxIlb+CHi87OxQ5J+B08tO2koRaI=;
        b=wLD8PaXskYr/2V4CFDzAJ3PEojmrvZ1xIEyZ6Jhnt/KibWadsZT5+wQ/2YL0HVLrSk
         SE96kMx96abgp4/G5W8rQz0jlm0YMfEybvT/Wvd1nuaqgqNUxWaajR6VtM8xV4HvEvfw
         Bbx/W03Tvi2yKmyrV05s6Shlf+u2jp06Wbta0PiNCk7RXTBoeDFbMKw3ABOxPrg1RTzM
         T1iy7YPjiO9Sul+uLBawusQd+njEVUYUYKbgz4CEruL8pCRdPbXNWz/SlhNBzM9y4aW1
         NKM36rCUGigDmnm2gkR+X96I/sgHwDReXna0h9TREBV+DYvMT5HKBU4gGoAfnSeSmrMX
         jhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulNuxr60llkoiFafxIlb+CHi87OxQ5J+B08tO2koRaI=;
        b=t39Oe5vJUI4WWnslm9rXrge1I00X3ZI346hEiF2RmQs1OFlKAgY0PHHEe94g5eU6em
         l0wDnc9BIrj8T0ExOmz2xplFeS18FumqGt7ihcQFf57K0cIZFQmrVOeFqZ4prImzFOBK
         TvEl4ASz4oDzcW4Iiy3x3DK14EzPv7yOD6d4fSa8boN015axXqw61DYqCuIgnLW+7W7O
         eK6NSUYsxyHvzw4gZY5JFsiTfhAJqZ2KjC0oZdNMR00HMwVZCPrlt0p91AdkZH5CjxFd
         LBDoAt07BPWqRTBnpS51/kG9uKMGxRx7FBl23n/gnFTKHbeniTO6+kDsEm6HQIrotyje
         xP2w==
X-Gm-Message-State: AOAM532gu6VEbkPk1YHZa4IjtoOgYfp8iPCC2p5H+fEvAPkTiguIjtoR
        lvwsBRbXBXgDXCIci+i9PlDALg==
X-Google-Smtp-Source: ABdhPJxo8uCvmvswyteyIJyt3Ic0kUyiaOa1EnkhnWi0vvcbV05Oc/wdTagCI2PErKTC3uAktABG5Q==
X-Received: by 2002:adf:f144:: with SMTP id y4mr13185758wro.408.1615542479341;
        Fri, 12 Mar 2021 01:47:59 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/30] scsi: qla2xxx: qla_nx2: Fix incorrectly named function qla8044_check_temp()
Date:   Fri, 12 Mar 2021 09:47:18 +0000
Message-Id: <20210312094738.2207817-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla2xxx/qla_nx2.c:2038: warning: expecting prototype for qla4_8xxx_check_temp(). Prototype was for qla8044_check_temp() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 68a16c95dcb77..7c413f93d53ee 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2028,7 +2028,7 @@ qla8044_device_state_handler(struct scsi_qla_host *vha)
 }
 
 /**
- * qla4_8xxx_check_temp - Check the ISP82XX temperature.
+ * qla8044_check_temp - Check the ISP82XX temperature.
  * @vha: adapter block pointer.
  *
  * Note: The caller should not hold the idc lock.
-- 
2.27.0

