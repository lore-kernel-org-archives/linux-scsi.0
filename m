Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53755CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 03:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjJPD7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 23:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjJPD7i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 23:59:38 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CBBDC
        for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2023 20:59:32 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-774141bb415so244985785a.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2023 20:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697428772; x=1698033572; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7Fy2uXPSp00n0L9agixVGjkKRi+BAuNJikDZecg3kJc=;
        b=ibHRZaM+573wshnrKRlSglHzlFVf3SIfxhaFEg2Pk/4CVfrHQq7GNpPKO7A3hv68eV
         FxkcXewXz/L30qN+BEio7VYsTNUXJ50LUkuFBpMAskHrXLE1abXnMYUx4j0DuS8kvpGT
         5QByUyDsUSdeeiOIEcKw3Ms9k/xaCEwiurB6mqz50zulWZUvgLEDI8/jA+gaqc0zPgfp
         Zlmg4CAf3XkW6GhTqiPAPZ1MWgGuEiRlPhjVsFOMhy1wcAGuCI4oq3WSergoxaK5wFuO
         URlCX8a5S7TyzJ4l6c6S+9w16EE1X3ck/0+xOFqnIrk4e7qTskqlDSqzkM7VsVBi5oJb
         OsjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697428772; x=1698033572;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Fy2uXPSp00n0L9agixVGjkKRi+BAuNJikDZecg3kJc=;
        b=aoGfrXDP/+AnZCAIW2CC+QGIWzZpCLp46NHb3MRddmIUKZNkop1bqQm6NPFSHOEgyG
         erZMHkHVw83nKUsmshQguSfye1bq/i8Zt7UM+6XB48YvQpt6EO7J+fS0gEF0Yw1gW+al
         pU1k+vSxuzIIUlYXuvzpTlnoXSNDIqgJsUrp1O6O5tLdgvTVJOxgybDP9KpBkpNYeapv
         GeJPsylEMfezuEeav01fLFBvFlxUnEfXuDPaIP/whar1xtDo/qFVpQ9UqUNvfWmVPOto
         z/P45Gb0ZQ/uILxoXP9fdkhV8fG/+IuE4u0kdtjGn7gVoepbgS3NLTB0YpdnkSD7Mn7u
         D2/w==
X-Gm-Message-State: AOJu0YyOZ5qLuhoAMvK0oWzmRKdA6Hxn2KIV1UnbyWDfuM3vZCqQS2PH
        f4PxgmGiKqRJzdJu7hHiUEpY
X-Google-Smtp-Source: AGHT+IGmaiHTpzlc1miv3/HBvOix8MsEgsaBm40HudFTD6vONeU9BVRe9umhScM/ElUfwEJHgYYTLQ==
X-Received: by 2002:a05:620a:b5c:b0:775:7e16:2cdf with SMTP id x28-20020a05620a0b5c00b007757e162cdfmr29126942qkg.39.1697428771855;
        Sun, 15 Oct 2023 20:59:31 -0700 (PDT)
Received: from thinkpad ([59.92.103.190])
        by smtp.gmail.com with ESMTPSA id w10-20020a0cc24a000000b0065b229ecb8dsm3101936qvh.3.2023.10.15.20.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Oct 2023 20:59:31 -0700 (PDT)
Date:   Mon, 16 Oct 2023 09:29:17 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH v7 0/5] UFS: Add OPP support
Message-ID: <20231016035917.GA39962@thinkpad>
References: <20231012172129.65172-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231012172129.65172-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2023 at 10:51:24PM +0530, Manivannan Sadhasivam wrote:
> Hi,
> 
> This series adds OPP (Operating Points) support to UFSHCD driver.
> 
> Motivation behind adding OPP support is to scale both clocks as well as
> regulators/performance state dynamically. Currently, UFSHCD just scales
> clock frequency during runtime with the help of "freq-table-hz" property
> defined in devicetree. With the addition of OPP tables in devicetree (as
> done for Qcom SDM845 and SM8250 SoCs in this series) UFSHCD can now scale
> both clocks and performance state of power domain which helps in power
> saving.
> 
> For the addition of OPP support to UFSHCD, there are changes required to
> the OPP framework and devfreq drivers. The OPP framework changes are already
> merged and the devfreq change is added in this series.
> 
> Credits
> =======
> 
> This series is a continuation of previous work by Krzysztof Kozlowski [1].
> 
> Testing
> =======
> 
> This series is tested on 96Boards RB3 (SDM845 SoC) and RB5 (SM8250 SoC)
> development boards.
> 
> Merging Strategy
> ================
> 
> Since the devfreq patch got an Ack from the maintainer, either it can be merged
> to scsi tree with rest of the patches or merged separately through devfreq tree.
> 

Martin, can you please merge the ufs patches (drivers,bindings) for v6.7? Note
that the devfreq patch already got merged and the above text is outdated (my
bad).

- Mani

> Thanks,
> Mani
> 
> [1] https://lore.kernel.org/all/20220513061347.46480-1-krzysztof.kozlowski@linaro.org/
> 
> Changes in v7:
> 
> * Added missing EXPORT_SYMBOL_GPL() for ufshcd_opp_config_clks() API as reported
>   by Alessandro Carminati
> 
> Changes in v6:
> 
> * Collected tags from Dmitry
> * Fixed bindings issues reported by Krzysztof
> 
> Changes in v5:
> 
> * Dropped the devfreq patch since it got applied
> * Fixed the bindings issue reported by DT bot
> * Rebased on top of mkp/scsi/for-next
> 
> Changes in v4:
> 
> * Rebased on top of v6.6-rc3
> 
> Changes in v3:
> 
> * Rebased on top of linux-next/master tag: next-20230731
> * Dropped the already applied patches (dts, opp binding and framework)
> * Moved the interconnect patches to a separate series:
>   https://lore.kernel.org/linux-scsi/20230731145020.41262-1-manivannan.sadhasivam@linaro.org/
> * Moved ufshcd_opp_config_clks() API to ufshcd.c to fix the build failure
>   reported by Kbuild bot: https://lore.kernel.org/all/202307210542.KoLHRbU6-lkp@intel.com/
> * Collected Acks
> * v2: https://lore.kernel.org/all/20230720054100.9940-1-manivannan.sadhasivam@linaro.org/
> 
> Changes in v2:
> 
> * Added more description to the bindings patch 2/15
> * Fixed dev_pm_opp_put() usage in patch 10/15
> * Added a new patch for adding enums for UFS lanes 14/15
> * Changed the icc variables to mem_bw and cfg_bw and used
>   the enums for gears and lanes in bw_table
> * Collected review tags
> * Added SCSI list and folks
> * Removed duplicate patches
> 
> Krzysztof Kozlowski (2):
>   dt-bindings: ufs: common: add OPP table
>   arm64: dts: qcom: sdm845: Add OPP table support to UFSHC
> 
> Manivannan Sadhasivam (3):
>   scsi: ufs: core: Add OPP support for scaling clocks and regulators
>   scsi: ufs: host: Add support for parsing OPP
>   arm64: dts: qcom: sm8250: Add OPP table support to UFSHC
> 
>  .../devicetree/bindings/ufs/ufs-common.yaml   |  35 +++-
>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |  42 +++-
>  arch/arm64/boot/dts/qcom/sm8250.dtsi          |  39 +++-
>  drivers/ufs/core/ufshcd.c                     | 180 ++++++++++++++----
>  drivers/ufs/host/ufshcd-pltfrm.c              |  78 ++++++++
>  include/ufs/ufshcd.h                          |   7 +
>  6 files changed, 326 insertions(+), 55 deletions(-)
> 
> -- 
> 2.25.1
> 

-- 
மணிவண்ணன் சதாசிவம்
