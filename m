Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B73DCD6E68
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Oct 2023 13:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbjJKNJd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbjJKNJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2023 09:09:31 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2ED7
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2023 06:09:30 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-59e88a28b98so8375547b3.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Oct 2023 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697029769; x=1697634569; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PfPqdxr3xTk/B3lsOeG+GMaOaJ7iVKD4Sx4SQuaCBgM=;
        b=I5YSYZ4qO3uCQgEmMo0XJ6rtG3qFWzYQcT+hCNNjEqE+cn23u8d1kEQMI2TmzV3mEm
         W/TBvTQsDfa0Q6zpM6FiMkPm8CbHzp0Shkc7am5iwlE06UfBw13rHZYMQKXPwIECXfk/
         RE8upz9zflT6piqzhLKENG9xp7VFO6b7Ri6NwkPoQroeUTbrobJfXaCw6A8spd8VPJjb
         NOSXTdDXsyIGd8zbqbP9ujSkt2Pqj2k8CnvpvPBKXsZBawRJif2+yXjfZQvCjFDRrlxc
         h7zddrVbxMPPNxBn5yzk154LQha7yjo/1Q0/dboQTvkpvvqF1vTHDbG6eB7qesQkMQ8c
         a1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697029769; x=1697634569;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfPqdxr3xTk/B3lsOeG+GMaOaJ7iVKD4Sx4SQuaCBgM=;
        b=vpkQgRuZFWoqgw/X8KaFLeLSRzLFsHBXJ6TTlzeQnafkpF0FYYNXJAmscOQgxpGA94
         a3Ax5hN6FrgAjL9Ym65Ys9TiKOLTXXBxcRDSHtEy6tYDuk3Gouzbb78y1k54DG9iNE44
         xGivViFJL6jwILDjc6cWKhKHepNROfXlSX7zOlbRQ6DDiSbrv3DZnp0SCvYRM4I5fOjs
         9p5bOiVhAinn2an7qIiGo4Z6ROhmncYkUkNTobOXkh94R/m4qlU9eO5ilAWcZ6Nq5Glk
         twrcrWcyhEWSurgHL+EQ7ZOKvcC7TB9Qdvj2tRXXjMOK70cL+7abJU3oWiw5AL669SeJ
         a13g==
X-Gm-Message-State: AOJu0YyBGtBRsMvx6+CxBskPsIIVTDDNlxxUSqX2dT5p+8OkVPI6jvwx
        ntDvGrpwpAu5gD9vEl5Bwya0qgnKP8nq1Joj6l+DpA==
X-Google-Smtp-Source: AGHT+IFswPBlcYNQL1CYPz5KfOjXULTHd35mYz4MleTy/lNTPkJMrGknvU2d1TxHVQUHvUKz9z2FzCKG+mqt/P0zb+0=
X-Received: by 2002:a81:6c92:0:b0:5a7:ba3e:d1d1 with SMTP id
 h140-20020a816c92000000b005a7ba3ed1d1mr3190162ywc.25.1697029769307; Wed, 11
 Oct 2023 06:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20231011122543.11922-1-manivannan.sadhasivam@linaro.org> <20231011122543.11922-5-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20231011122543.11922-5-manivannan.sadhasivam@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Wed, 11 Oct 2023 16:09:18 +0300
Message-ID: <CAA8EJprQvw3B_jyHLgB0GyJi_DKrhyq8gVGfcXraShD4tVCO5w@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] arm64: dts: qcom: sdm845: Add OPP table support to UFSHC
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 11 Oct 2023 at 15:27, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> UFS host controller, when scaling gears, should choose appropriate
> performance state of RPMh power domain controller along with clock
> frequency. So let's add the OPP table support to specify both clock
> frequency and RPMh performance states replacing the old "freq-table-hz"
> property.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> [mani: Splitted pd change and used rpmhpd_opp_low_svs]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 42 +++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 10 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
