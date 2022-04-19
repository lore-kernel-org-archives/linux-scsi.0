Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9412C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 10:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350558AbiDSKPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 06:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350545AbiDSKPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 06:15:15 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AD3255AC
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 03:12:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z12so20608690edl.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 03:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4fzcJSI4oOEyvvnWtTfDgElotLoa5ZRCyODN9ZoDFYc=;
        b=FG2yAAJmlE+e+JJGNL8YIpRAVvDoS5XUHDS3v5TQv4Rpdhr16E7ZVqU+GzX9yQIA5n
         pIRsy6MUX6vZEcwe6QA/1RygGMWK/8PGY4obKR2gvNl7DVSevzthr7FEvcW7q6eXcRU9
         PCjLA5tc+sjbgh0aUwnz5mwZo3UogarS7z0U/sJzjW/xvuwqkrIUuvTOfoXKSJDjERCo
         lunMI6LAuEplt2QvPPEVMlK8UWAZ18wZ/S+ev0mJrX1ghAL2P1AFKl0LwUipaJOe6UeH
         rWCDV6QIV+QMDi6Xc1D4FuHVhDcVhlCQCHDYYKK6DyRC6kfmErIsA5/Twx4TRir4NeF6
         YY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4fzcJSI4oOEyvvnWtTfDgElotLoa5ZRCyODN9ZoDFYc=;
        b=pQriumvFTCJ2IuiO4+kUKBs+8QubTYCvOr+0eZkKFaM0Z6qGDBAPyTLOOcjffHiXPn
         Gl3tTb0H+B2842BMszVcQK7+cf+dcpHBMuPhLaaKTjaJNaY8gjvK0+cIEBTGo4hQGIae
         w8E7ddpzBtjJZwtTLbtjMm5eIYqt4saW/DboXpBav6I3Tg0cSIJMUd+Rl8gCgff3rj1c
         shXBsk/U39wZCJE8DS4+03D/qJzd92n3ZmvExYO20Fananc9V6mS2sI+C9cgfW2FLnY4
         NzRaJHUMnEj9mZF1v3G29jTbnaUG8s1XcM9hiE6CjvKJITzSXQ/EXgOjw6uK976KPvzC
         POpw==
X-Gm-Message-State: AOAM533eEEnrDZDvwOPG3Ek94dCwTpTykSFod5nZHK7BR9MJdKSNGftp
        6VGzw8XeRzj3A3DwdvH/263uiw==
X-Google-Smtp-Source: ABdhPJwHU6aPLpAzrjz5Zh03plssXITh4QZGe1lmzwZykI8LaTdTDd22ZXc7Gpd2lL1bn4JHn4Wiug==
X-Received: by 2002:aa7:d049:0:b0:41d:8c82:1a61 with SMTP id n9-20020aa7d049000000b0041d8c821a61mr16354944edo.323.1650363151285;
        Tue, 19 Apr 2022 03:12:31 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id v21-20020a1709064e9500b006e8973a14d0sm5581177eju.174.2022.04.19.03.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 03:12:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Jan Kotas <jank@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wei Xu <xuwei5@hisilicon.com>, Li Wei <liwei213@huawei.com>,
        Avri Altman <avri.altman@wdc.com>, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: (subset) [PATCH v3 09/12] arm64: dts: hisilicon: align 'freq-table-hz' with dtschema in UFS
Date:   Tue, 19 Apr 2022 12:12:26 +0200
Message-Id: <165036314214.180327.9388318751451146287.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-10-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com> <20220306111125.116455-10-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Mar 2022 12:11:22 +0100, Krzysztof Kozlowski wrote:
> The DT schema expects 'freq-table-hz' property to be an uint32-matrix,
> which is also easier to read.
> 
> 

Applied, thanks!

[09/12] arm64: dts: hisilicon: align 'freq-table-hz' with dtschema in UFS
        commit: 65b96377bf9130617ced41f317f3ec387d3e0dc3

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
