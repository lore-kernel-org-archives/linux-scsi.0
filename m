Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568E2C41535
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349170AbiDFBH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458175AbiDERNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 13:13:10 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9C60CDB
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 10:11:10 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id b17-20020a0568301df100b005ce0456a9efso9797938otj.9
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 10:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2aY58p3Eu08i1zvroIKdthxIFG+lHzOcPDP1Vod5UdQ=;
        b=BJlLixmapZXG3Z12MRft8f1o+ERnrNsMEOuO+htxHtOkkXNoC4g+Fj1hvUrrz2eiR4
         bbLh9uCYeNiIVW87oZB/Hf2zirGPhRhZs4MZFYQKP0lT5uFogrweIdBUU638/F+vk8MM
         1XdUXhdAsAizdg4UAkuu6oeBzHDIdwhMxz+vGg+2NqOPoCUyUnwMUPKELdYC0y2EEVnx
         l302qabGpKEelNd6fdET2izAcrhjx6ZXdty+FKfxGQhRT1RWJZTm6vZ6qscVeEq76dyX
         QL55dLz7mFEFaoJpPbnuJnPj9hVDedGHH2VDGUnoO0snxp7Lh/xCE0QEunJnYaWLh0gi
         0wsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2aY58p3Eu08i1zvroIKdthxIFG+lHzOcPDP1Vod5UdQ=;
        b=tgUo/pytHx/RSmY5l7+3OHCkgaN1QgNXn9r5tXNN0f3pSuv+S2SwSO1t0sUD3yE/VZ
         CH0FvKTP38R4x0ajkb0k32LuKT/AZnWY1NmUGvoU8kIA1aMPc3uWj/paM342Vkfk4PAZ
         u+ealZBuvp/Uzf+98jL+c8He9X0UWq3i/hM47tSbVfEQZaX8nF9M3brs4MM+A9RUfirB
         EKpg8Q1PoTznmbulnnILJDd+GM8jIEf/rcfbPh6EE7A8aXwj4+RuoOTAazq6BuXcmssi
         /eXyus6kBZHuDQh6e7WiqsSyPPcXa3hQox2MF6z8BLbKmiA0Jm0qwojtgyC1YfoIX3Mc
         FDkw==
X-Gm-Message-State: AOAM5322pyW1m+WccUun3m/UyoAKBl7y6X61STjsEKXcfvREwSdFioBy
        12HelD49c4baEn+dTTVvxhh6PQ==
X-Google-Smtp-Source: ABdhPJw3Dog+Ye6joupCF1nJ1gu6mLF/8uu2LULDI3pj1f67IYGzNXfMwLJXsBStJIdXMshXWyQ+wg==
X-Received: by 2002:a9d:6442:0:b0:5b2:3851:597 with SMTP id m2-20020a9d6442000000b005b238510597mr1566869otl.247.1649178669314;
        Tue, 05 Apr 2022 10:11:09 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id e4-20020a056808148400b002d9be41b179sm5680214oiw.50.2022.04.05.10.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 10:11:08 -0700 (PDT)
Date:   Tue, 5 Apr 2022 10:13:31 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Taniya Das <tdas@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] arm64: dts: qcom: sdm845: control RPMHPD
 performance states with UFS
Message-ID: <Ykx4u+E/vDNrQRUg@ripper>
References: <20220401145820.1003826-1-krzysztof.kozlowski@linaro.org>
 <20220401145820.1003826-4-krzysztof.kozlowski@linaro.org>
 <0da0b229-3493-967d-c14d-60d3246b07b2@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0da0b229-3493-967d-c14d-60d3246b07b2@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun 03 Apr 17:02 PDT 2022, Dmitry Baryshkov wrote:

> On 01/04/2022 17:58, Krzysztof Kozlowski wrote:
> > UFS, when scaling gears, should choose appropriate performance state of
> > RPMHPD power domain controller.  Since UFS belongs to UFS_PHY_GDSC power
> > domain, add necessary parent power domain to GCC.
> 
> This will cause all gcc GDSCs to be rooted in the CX. Are we sure that this
> is an expected (and correct) change?
> 

Per the last part of Rajendra's reply in [1], this should be fine.
Naturally we might have to come up with some way to bind gdscs to one of
multiple power-domains if that changes.

[1] https://lore.kernel.org/all/5e572c50-d6fe-5a21-d09f-f11a072538c5@codeaurora.org/

Regards,
Bjorn

> > 
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > ---
> >   arch/arm64/boot/dts/qcom/sdm845.dtsi | 17 ++++++++++++++++-
> >   1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > index b31bf62e8680..c999b41c2605 100644
> > --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> > @@ -1078,6 +1078,7 @@ gcc: clock-controller@100000 {
> >   			#clock-cells = <1>;
> >   			#reset-cells = <1>;
> >   			#power-domain-cells = <1>;
> > +			power-domains = <&rpmhpd SDM845_CX>;
> >   		};
> >   		qfprom@784000 {
> > @@ -2336,8 +2337,22 @@ ufs_mem_hc: ufshc@1d84000 {
> >   				<0 0>,
> >   				<0 0>,
> >   				<0 300000000>;
> > -
> > +			operating-points-v2 = <&ufs_opp_table>;
> >   			status = "disabled";
> > +
> > +			ufs_opp_table: opp-table {
> > +				compatible = "operating-points-v2";
> > +
> > +				opp-50000000 {
> > +					opp-hz = /bits/ 64 <50000000>;
> > +					required-opps = <&rpmhpd_opp_svs>;
> > +				};
> > +
> > +				opp-200000000 {
> > +					opp-hz = /bits/ 64 <200000000>;
> > +					required-opps = <&rpmhpd_opp_nom>;
> > +				};
> > +			};
> >   		};
> >   		ufs_mem_phy: phy@1d87000 {
> 
> 
> -- 
> With best wishes
> Dmitry
