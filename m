Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561F9C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiBVPBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiBVPAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:55 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBC10E578
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:06 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9C66840296
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645542005;
        bh=LfKEooVWXSt0X9amI75MXA0ImuzcwyjqGr8txR6hCCo=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=vc3RucsustSnI9z6fj1AZ3faXkw/uB81BLhjsfHz9uRvUq0axAi6FjprYifCaTms2
         G/jZ5OzN3Fsjqjp3rsoU3oDbFNiRJX2kApHmhH+rnhTqdDTx5nOGGuQIQ6z5ypInDT
         XQZhR0GMrPt225HGhVjquKJrxdjFIkraKhNTHqmrvpXeZ8puofX0OhzAWd4CK4s/vq
         9GzlJ8XZX/v1ep8CVwanxcr1kJpqdvVbDSGMOKMMO8rOrzUgh3NRPONnqXvUrres2E
         cQUpSxkQE6or1M4U3Lv7nrjl8vQ/IdP5JnUWZeNc5MxtirhxkAKnBLLSweT95TmM/D
         k/vJQLd/Zafog==
Received: by mail-ed1-f70.google.com with SMTP id eq13-20020a056402298d00b00412cfa4bb0eso7279622edb.7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LfKEooVWXSt0X9amI75MXA0ImuzcwyjqGr8txR6hCCo=;
        b=bo8ydJKTP3gfBJy5qsjFFoZLxBR3qety1rsTUZ6BviLTWRzCZPnM8DMBlwiCTW4KDu
         WA8l02MXfk+e/iuUs/4UGEpB6PUUd19I6YC3RhUs525JxL0/gf1fHoa8F+OzdfIoRfvO
         Vku7MKRR34r1kXvD47exkVe1mDY8Bn6ipiwQ4SO8skAB4ZBGPNa7LH9dAXodVnQEcOvR
         TA4fxppk/HT5epy1oU15VHPPVnMgNXcc13BG0IsDmDDtjhdGFVSPx4jgBY9G/KpFxX2M
         vvJA37XjjWgh0I8j+LK360uWkpR9dfkYdKv28lE98DLAapUMSWyP10MLGk7HzXG2ijQY
         9SJw==
X-Gm-Message-State: AOAM5336DL89Zpo3KK+B5C9zpEOCoY6eHGk0vPfKBzUERDzUul5kp1b1
        B2hZJsbh1B1bM7Cu28rUaeae3yvB2sAxPj1tpI7o/21zb0Ai1IUKttsTokLw941rkKcaCSwlo8f
        KYL49sVQHWvU8XY/o2t5QavNC7/Yye1/6uHo6X7I=
X-Received: by 2002:a17:906:70c2:b0:6cf:e1cc:4d8c with SMTP id g2-20020a17090670c200b006cfe1cc4d8cmr20090150ejk.696.1645542004850;
        Tue, 22 Feb 2022 07:00:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyR3qbd+Iftv6XGp15bvvgUICPOPWMYZg+AzIuOxdejdmzbh/iz1wm8C/0MI15ezn8MGt0S6w==
X-Received: by 2002:a17:906:70c2:b0:6cf:e1cc:4d8c with SMTP id g2-20020a17090670c200b006cfe1cc4d8cmr20090120ejk.696.1645542004625;
        Tue, 22 Feb 2022 07:00:04 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.07.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:00:04 -0800 (PST)
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
Subject: [PATCH v2 15/15] arm64: dts: qcom: sm8350: drop duplicated ref_clk in UFS
Date:   Tue, 22 Feb 2022 15:58:54 +0100
Message-Id: <20220222145854.358646-16-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ref_clk clock in UFS node is already there with a <0 0> frequency, which
matches other DTSI files.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index a26bd3f13d4a..cb6442c9e761 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1916,7 +1916,6 @@ ufs_mem_hc: ufshc@1d84000 {
 			iommus = <&apps_smmu 0xe0 0x0>;
 
 			clock-names =
-				"ref_clk",
 				"core_clk",
 				"bus_aggr_clk",
 				"iface_clk",
@@ -1926,7 +1925,6 @@ ufs_mem_hc: ufshc@1d84000 {
 				"rx_lane0_sync_clk",
 				"rx_lane1_sync_clk";
 			clocks =
-				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_UFS_PHY_AHB_CLK>,
@@ -1936,7 +1934,6 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
 			freq-table =
-				<75000000 300000000>,
 				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
-- 
2.32.0

