Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38C6C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbiCFLNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiCFLMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:12:49 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B138660AB3
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:11:57 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 85AA13F63A
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565109;
        bh=vMFnkOH1WJAajK2DqdRDAa0cLEGNFmbkS8Gtp9GKvtI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=O7d8uV8Okv/XTDEpawGXsUnPR8krCNI95rrLTe3BVb0+arTPy1hE14MXy5kPymz7T
         G7mKBZ1uIURbgSZTI1WF7k4LoW10chNyM8fc32dVxxg2Oq8VnbzdBZISAA2WH+4tCU
         MoZnlrNbZ5+01swEphN9IipYOpud4r1UxuRAm+1cOnmhCquuxTxprPNQ/x6MH+sZz6
         oHo2SJ6JuRZnEtL6OEcNMv8/EBsMfXyINSxArHyN5Lrdg+m/K66Sz1+pf16i21aPg5
         tBMczHYqg1cTjHxa7+l6SvDKQkpBytrkoL6/URbWNz3UXLgCjELeCbvyl2JwT2i3Py
         EvE0JmJvIik6A==
Received: by mail-ed1-f70.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso6731816edt.20
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:11:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMFnkOH1WJAajK2DqdRDAa0cLEGNFmbkS8Gtp9GKvtI=;
        b=UOUURGS+6o17lddCzjZuuJ1JmOkbpxRzkHXK9GbP6pidsjys0II61HTPZAd6lv3cZt
         f8AjlJ7fVByj4qg5I3ZnyF+Zm94mqAeQPozyFNGN942CFVIcc23gTBE4i0yc4GP+08gz
         wR7ncMMVxnaOL8VTPmurLXnH9mTcFe249SQrp6oWJ2MVie2UeWmKvyvKf7CTHC+6Tkzc
         ly1tMkhTNiGaf3FVWsXaUfvPcbioZU3VD317biHMKBAjymtIzVOjmYLrIvueaEqdJ4ZJ
         SSePZs/NpLr+gyqXmqA+DF1RDvX+7GMghtnfR4Qc+/xYs41WH3uko4xJ2nllQNjcefSZ
         hTLw==
X-Gm-Message-State: AOAM532JQonkg/L3YCMB1eusxzGZ6+6B2fRJwY0ABEQI/q+x2ody9Ruu
        wn+ib1kPMoNrmYHZsqjCGOeyvASgPrPjqtYQRtRWOUAB0lTdqrygbDct8rkIIirfXuqS9CLYNfl
        bMHKXIuCeNl2zTn7zlvB23ArQVEZqJlw00irGQnA=
X-Received: by 2002:a05:6402:2d8:b0:416:34b0:5d5c with SMTP id b24-20020a05640202d800b0041634b05d5cmr2294041edx.6.1646565107741;
        Sun, 06 Mar 2022 03:11:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTQ1jrVfZZl3Nu0dKHXWLrV//RroIxSgPbz2wvMOZz/2cmoQu/ylE+3YUml5SvnaWO1iXePw==
X-Received: by 2002:a05:6402:2d8:b0:416:34b0:5d5c with SMTP id b24-20020a05640202d800b0041634b05d5cmr2294031edx.6.1646565107595;
        Sun, 06 Mar 2022 03:11:47 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:47 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 11/12] arm64: dts: qcom: msm8996: correct UFS compatible
Date:   Sun,  6 Mar 2022 12:11:24 +0100
Message-Id: <20220306111125.116455-12-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Qualcomm UFS bindings require to use specific (qcom,msm8996-ufshc)
and generic (jedec,ufs-2.0) compatibles.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index f0f81c23c16f..fa491f2271ff 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1730,7 +1730,8 @@ pcie2: pcie@610000 {
 		};
 
 		ufshc: ufshc@624000 {
-			compatible = "qcom,ufshc";
+			compatible = "qcom,msm8996-ufshc", "qcom,ufshc",
+				     "jedec,ufs-2.0";
 			reg = <0x00624000 0x2500>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 
-- 
2.32.0

