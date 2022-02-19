Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693BBC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 18:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbiBSSnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 13:43:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242898AbiBSSnB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 13:43:01 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D3926AF6
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:41 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 390464081F
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645296156;
        bh=Y7Xw1XgTgBcNzaNUmOMUZUT9huc94W2fdxwywnagsik=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=F2l9Ect/VtfoDtcWDd7/bx/elTweTQ4enXQZBhTXzPQucHkT1HnpCVpk+gmFobngW
         MKrAyB6loiPR7mPlw/DeXIhHo14kDidAmb9GfSw2ZffqfWiWdseKAg/DsNtokNm3kM
         nne6qeC+Ix3wJ1qEvAsQMojC6mXRZthA2JJeizSdfVaFD1p4+UkcRhDbe8/1YlLUZT
         lAmrNqT6lFj7zhcwxk4kd2iSYU/IrVl4mxSFXpuTPw+pDRiky2vf2lUVOWTosnEplJ
         8MIhBDwojYCUn5degXBNNIPAUwCULB6XlXevrA+whMI0DHit0l32PDffU/cBWegxbc
         wGiOL6GY/dRkA==
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso7567846edt.20
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7Xw1XgTgBcNzaNUmOMUZUT9huc94W2fdxwywnagsik=;
        b=Oyo/cFqUyifqqFwrsT/vmk8fiXYOpQ46Nn4DqMTvVYNDJFtmS2sXOSRzz2HQt30hgP
         nUusYjRv2CIAQIb3RCYMEuML1awYW3oewr0zYDW1a7/p6UeHhbE/USOVMVN20aGBJFH0
         IzCuqKyz4WbMykevrfhHhPTJCvR66G6uFjIzk7tqn6ZP6lrboSJpHuJv5j9r3jQmIpWA
         def5l31vo+Wwb1+jh0gUQmFja12LuDPLysnutpTk3mB2qNEm9/RlXHibycx9U9C2AXSZ
         DgaXlSKTWHOcLIA68X4eaDwgRcY5YUWs2tSHZVo/7BTy4uEFAMkJcEPGr/T5jghqtI6D
         51rA==
X-Gm-Message-State: AOAM533rKIPZ5WVCpJBA91PzCCuTve9N3rZaNUByTQxsZGYbPIaIgY05
        7OsBHfGMCuVnFCUxdcm2Zzf/MH/dFHVbHc4zPVsIyI1+rX9iDe6kGtFOAjw58e84KRCSG1inGvE
        Ssg9jh9bOATNlbikHTlxKnqD7CCItCQHsp6AOQbo=
X-Received: by 2002:a05:6402:3553:b0:412:d0aa:e7b0 with SMTP id f19-20020a056402355300b00412d0aae7b0mr7276043edd.309.1645296154951;
        Sat, 19 Feb 2022 10:42:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyC5IJLy48tlyYE+yZgcpQSi4MoxWiFd33GYjBfsDjODqOvCAdkALPMOFjD1ZZijcqanmOmFQ==
X-Received: by 2002:a05:6402:3553:b0:412:d0aa:e7b0 with SMTP id f19-20020a056402355300b00412d0aae7b0mr7276030edd.309.1645296154800;
        Sat, 19 Feb 2022 10:42:34 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id j8sm6680745edw.40.2022.02.19.10.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 10:42:34 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Xu <xuwei5@hisilicon.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [RFC PATCH 5/8] arm64: dts: hi3670: use 'freq-table' in UFS node
Date:   Sat, 19 Feb 2022 19:42:21 +0100
Message-Id: <20220219184224.44339-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
References: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'freq-table-hz' property is deprecated by UFS bindings.
The uint32-array requires also element to be passed within one <> block.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
index 636c8817df7e..0860c5688977 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
@@ -671,8 +671,8 @@ ufs: ufs@ff3c0000 {
 			clocks = <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
 				 <&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
 			clock-names = "ref_clk", "phy_clk";
-			freq-table-hz = <0 0
-					 0 0>;
+			freq-table = <0 0
+				      0 0>;
 			/* offset: 0x84; bit: 12 */
 			resets = <&crg_rst 0x84 12>;
 			reset-names = "rst";
-- 
2.32.0

