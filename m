Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A79C38A02
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJ2OUA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJ2OTQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:19:16 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FF60E8F
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:18:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso12380697pjc.0
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=P9QFigTKmYtXKlmPOyJw0TGo06Tb3Vb+k5qYkdlVCW/AyKvzamq42wfKefeXNp8vTX
         t8Fy6GtKiWkdk7UQtO7yhBq/bxE8aQAnEHGRw+q7SK/Entnh4l1ai+RRLFxZgUR533wk
         mrpMQ3xuCLjTX0413gdP49H31P59t69NAS9mSIIG9gptSKBZ785R7nYiul1r4iai/cqj
         naIbeXg9xPGb8szMaLu2FlAcc679ouDlGCcBx9JBeAXT3pPKn/Xnpw+1FjoLNXmut2xB
         DRXU0blzEd4S/X6IOA29bRpOh6iDohpbxDloosWvSY1aawirkCGQAxiFk+U0/gD7WovW
         7StQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pljquG0hkdcBPdXIDtkq1v6aN8iyQB1w4S/2qg/cek=;
        b=1QKjEewFHKcuhj7ZmWW6dI1zna+KZO8sL7F4LIfAt+N6cKxEFGUeF9F4Nc7sqvm56L
         2/nZqW9BA2e8f3K/ev1TYGQcUHoeongvBdcirqWokEjpGYoAFDh652/vSorHtKTWnEeg
         tdPN1Q9rwF6JxP95aiNPx87CPF2Do+pBOReFeICcYdk8AT2f7iIJiO17eeoZLCKFv4zf
         2ZLQI1XRumDOxQeirkKO0ROGYUa2I3kWYNetqT04g2wsYhKyTdzhdDRCShAzKlsP3bhA
         b2POdlNzwpydSce0DXVN4eB/fLYfCFWatx2ewmm9xex4DA7LTkuDcRFq7MmRGXuz8g/U
         Nmdg==
X-Gm-Message-State: ACrzQf1s9VwKmB8yuxQ7KRuXdMubXEZ80maZPRpPM0GmVzJPrQp0jXKY
        mah51RLBHoPBQglMmhTA3+4q
X-Google-Smtp-Source: AMsMyM6h+EpF5gb0tIAdqaTv7FkdeBbxEQ/ZkmRZ/8pETHgHQk0mrdRh9x5VlwJ2FSKMsETzSTQWDg==
X-Received: by 2002:a17:902:ce09:b0:178:bb78:49a5 with SMTP id k9-20020a170902ce0900b00178bb7849a5mr4674804plg.100.1667053083512;
        Sat, 29 Oct 2022 07:18:03 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:18:02 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 15/15] MAINTAINERS: Add myself as the maintainer for Qcom UFS driver
Date:   Sat, 29 Oct 2022 19:46:33 +0530
Message-Id: <20221029141633.295650-16-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Qcom UFS driver has been left un-maintained till now. I'd like to step
up to maintain the driver and its binding.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf0f18502372..149fd6daf52b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21097,6 +21097,14 @@ L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/ufs/host/ufs-mediatek*
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER QUALCOMM HOOKS
+M:	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+F:	drivers/ufs/host/ufs-qcom.c
+
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER RENESAS HOOKS
 M:	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
 L:	linux-renesas-soc@vger.kernel.org
-- 
2.25.1

