Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D20C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855DD22CEA
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 20:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EwHFoY3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfH2UAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 16:00:10 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:37490 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfH2UAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 16:00:08 -0400
Received: by mail-pf1-f171.google.com with SMTP id y9so2804127pfl.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2019 13:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=leAjuo9QrYfGsQp+lWwGPaf44FJzdIsTdXXe6kBTcvQ=;
        b=EwHFoY3nn78Ablhc+fvFTk63+ihmkRvuN2b9otTYYBLJ/20wMokgUtop/hP29hf8Ss
         JdtCG3A2s67swE9FFPf0Jn+PmiCySXAL8wwZW4h1dWPNwTUU0OJvimlv7euDgKnQOI0H
         dGcfTjNrOk+RUaAs/nmRNL6f5930YGwO+xPmerXZ3YLIx3T4GB15/JNvn/WKFJkiPNSh
         JSGhphPYJfykXMMRch+fpjVH5JYudf5o7RljVoXQc8rIl3R5Wt9ClH9N90i/eEYtQIfH
         U7UKjZIIr6lociKHiO8DTHScDkrVxuqSHtCT0pJuou4Ml1+ekF7rLvtgaf+1OlCmupbW
         YbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=leAjuo9QrYfGsQp+lWwGPaf44FJzdIsTdXXe6kBTcvQ=;
        b=Ue3zDMrPIePkJ090cxW8eA+k+91/G/+csTWMhrEgKNT92flWdyf2dKzlQ6cABXaf9T
         ozo26EpP+KgazVHHN07nFSBkk9EJRS6Fy5DWdKTosUpWh/TwqHVL4brITOLnmBo6KOHB
         UzhvygGl/pX/0PB1A3dosWLbzN3iZL3MPoOiIRFVr6H0wKMrxtzhd4FEocsttqF1e5sW
         5K5uy6nz/sgp0B7A2+02VW8Z2UqwXyyOwiKaw2ljL9e7/regrQ5yl3pdUfL6eLhIBTyD
         XycZ1d1HG4s6NoEAQj2IgzFWXgEylXcdLr5whT/2LAQgBkJU4mnHsqY7OP3ooGT3yF34
         Jjrg==
X-Gm-Message-State: APjAAAVh9qfp2mCBeTSNqMvZMV2JWufSmh88Ri5rHWlpruRNxe5L29jt
        dEv2TG1a02Bd9uv7hk/iWc/k93cIXqY=
X-Google-Smtp-Source: APXvYqxmRtZml8EdnZ16J1Jmfc6FgL+TVFfQC+dCMCvoM/+VMjg+z1xJm3jSCGVPmaKApRCFQG6kdw==
X-Received: by 2002:a63:1f1b:: with SMTP id f27mr9740387pgf.233.1567108807182;
        Thu, 29 Aug 2019 13:00:07 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u7sm3053766pgr.94.2019.08.29.13.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 13:00:06 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie, jsarha@ti.com,
        tomi.valkeinen@ti.com, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [BACKPORT 4.19.y 2/3] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
Date:   Thu, 29 Aug 2019 14:00:00 -0600
Message-Id: <20190829200001.17092-3-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829200001.17092-1-mathieu.poirier@linaro.org>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Pedro Sousa <sousa@synopsys.com>

commit ebcb8f8508c5edf428f52525cec74d28edea7bcb upstream

Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
according to MIPI Alliance MPHY specification.

Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
Signed-off-by: Pedro Sousa <sousa@synopsys.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/ufs/unipro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 23129d7b2678..c77e36526447 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -52,7 +52,7 @@
 #define RX_HS_UNTERMINATED_ENABLE		0x00A6
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
-#define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_TERMINATION_FORCE_ENABLE		0x00A9
 #define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
 #define RX_HIBERN8TIME_CAPABILITY		0x0092
 #define RX_REFCLKFREQ				0x00EB
-- 
2.17.1

