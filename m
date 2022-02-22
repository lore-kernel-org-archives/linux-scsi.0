Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE641C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiBVPBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiBVPAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:49 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF510EC46
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:03 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 05BA9405CE
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645542002;
        bh=4OhXJxblf34wMx5+uRUs16cf2JFWMcvDQKlBG/4EIbg=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=p+wnGLCvsbOb87QeTLqlZB/v/Ve2mBRK/rWPGaMxid57TPQTwUXU52BihKhfeUu8l
         wRysbcIKNQjk1AcRKjsLPVLZywKZ+y3istht4WZThF2H1ClKQzECZAue9SZJpaIIir
         62am/OgW3f8Cwg+UGJk7U4QkAHn20cumLmSCXZaBuoRznCZEcCqqaL6ZUa8zrYDTVh
         fDxZlH0O6TJAWexitvJ3fKDJXZPgS1rovZLHLBAgmP4ZXeDrPfzBds+VlKRlyLpU7w
         7oiMspBZogpqf2vMz7TX7Chz8sy7sSTTLeYo4aZPGOEGesn0kzXjmaDr4PoPU6JPLh
         NpcHGp37ul2IQ==
Received: by mail-ed1-f71.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso12134879edh.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4OhXJxblf34wMx5+uRUs16cf2JFWMcvDQKlBG/4EIbg=;
        b=RfccyY3rZP/r0yUAsY4mxCz25+f0muyAvzDr1+N8VB8JKU0+mCcZLM3KifZYnEQuoe
         b0qL22Z5Ooulatst9rOqVBYiZKcJrQ20Ivab5/Y/gor7pCGpz3GSh8TOVjPe1ugrCQja
         iws6GyyuOkULKssao7JVk7vDb6sLUaIwHWr6vkI1j3/gIQum2EX4JzfjCxyy/cZSMVSY
         p0TGCR4lskcmnp/x8snm+61I91MbuMgP10HHnhW6bXl/NlP4nCJE/c2j1zZiy/4pAPQO
         4Ex9fDkKLmjGPnLIFfXfh5Lghg5qWKlRQLXDvUWB7fkxia6NuGNjQ8yyz9fxxHXi36Lo
         QWgg==
X-Gm-Message-State: AOAM530rGAa/kOMNaZkRMIqZp2gx2EAU3vS17cU3afKoYUgdhG7ApaWA
        HG/IcZ4t8Xgep2VL20/oojoURdqdYw3BBIPwJ8BCCp5fB/IO0RiWmb0WNKFN/6Dphi/uEkeghda
        K7F7n+7osQnmupt35I0oDtw5hlhhsYodD1V2FCN0=
X-Received: by 2002:aa7:cd81:0:b0:410:d64e:aa31 with SMTP id x1-20020aa7cd81000000b00410d64eaa31mr26939002edv.167.1645541995664;
        Tue, 22 Feb 2022 06:59:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaJdWHb8xk+e2xSEaK1p8tjIOgBKlnOjh9riknUovYkgJh1fsrFc3SbrR3EFVhnzBs85hG8A==
X-Received: by 2002:aa7:cd81:0:b0:410:d64e:aa31 with SMTP id x1-20020aa7cd81000000b00410d64eaa31mr26938989edv.167.1645541995521;
        Tue, 22 Feb 2022 06:59:55 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:55 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 10/15] arm64: dts: hi3670: use 'freq-table' in UFS node
Date:   Tue, 22 Feb 2022 15:58:49 +0100
Message-Id: <20220222145854.358646-11-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
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
index 636c8817df7e..754b3a66ec0d 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
@@ -671,8 +671,8 @@ ufs: ufs@ff3c0000 {
 			clocks = <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
 				 <&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
 			clock-names = "ref_clk", "phy_clk";
-			freq-table-hz = <0 0
-					 0 0>;
+			freq-table = <0 0>,
+				     <0 0>;
 			/* offset: 0x84; bit: 12 */
 			resets = <&crg_rst 0x84 12>;
 			reset-names = "rst";
-- 
2.32.0

