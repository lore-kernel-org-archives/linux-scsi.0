Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E18EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 09:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjGUJnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjGUJmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 05:42:54 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6740A35B5
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 02:42:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-666e3b15370so1245110b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 02:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689932529; x=1690537329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFcU7/ffJj4GpqTDJrXsJdgjnuOhtBeWbIDJjevNDPU=;
        b=hiqCACW2e6ToVhtF/uGbndLMELQTUVszaKBSFRTyxHpLpZWPVTlffOehyOxsrk91e/
         zp2RgL/2DLad18tMqmIMWvSSwonUi5XvydaEaGjZA7GuFnusqAphYfg9qVnjYuR+AR9w
         Y2bTY/rACSniqAgu2PwGuAtmYeeusYUwnyxcaimdcRhux+6Y2ce8u4ai83/TEod5z0v5
         m/esqcISu4CTa64qDKf90ooAXLrz+22Njc3B3AZlINViptNVeGBwJQgRoxfdV1lX4EmL
         W5/MYUQP+m5KHhCHguV5BEPdG/N/1oL+HG/l2fzkwVcbiBFZLa9b31YA46HmosANomkQ
         GwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689932529; x=1690537329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFcU7/ffJj4GpqTDJrXsJdgjnuOhtBeWbIDJjevNDPU=;
        b=R67S0oCC5WfbVRN/Ms0n/i81K5IZLL0yETLx54RMJVAf0wM+sMPKpV8x7BceI8DR6J
         GdViIVtALQZkGJZDA29tACF8S/V89k8XO/pMamYJe5PVFSDXrkR45ttHcJvrCmh/5sJA
         y33u5gVgoBXerqVPr7/6PZevfln7LbFEB+M8YY/XlM7BoI8BZa1srXhcXiEP2wlDQOsP
         gr6hthTrJRO7SJjv8u5D4XZUNxNMKB4GNyuDGVRj8X+yOgIuszMfTZPL2mNhrXY4gIUh
         TsP0iPV8/ndpbKph4UbxEMKJ58jh3yCTXSPNNDUZt1QT0fvTi5CtBxutBMnJYQC7pI3t
         LzLQ==
X-Gm-Message-State: ABy/qLb4tHrcpAsRhK0bJdGeQF2Gk9LgYU98w6SoPMbkLz93GTw+OXZC
        I0/S+t0Ad5EO8WCGFszGmhsxtA==
X-Google-Smtp-Source: APBJJlHkH7Uv7pWn/MP4FMrAIT/Cc7VTogZMZvc6nxyeSZL/vi3Feh7E3jJubjRUzodKuGKTOER0ag==
X-Received: by 2002:a05:6a20:841e:b0:11f:6dc:4f38 with SMTP id c30-20020a056a20841e00b0011f06dc4f38mr1573730pzd.55.1689932529270;
        Fri, 21 Jul 2023 02:42:09 -0700 (PDT)
Received: from localhost ([122.172.87.195])
        by smtp.gmail.com with ESMTPSA id e3-20020a170902b78300b001b88af04175sm2997093pls.41.2023.07.21.02.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 02:42:08 -0700 (PDT)
Date:   Fri, 21 Jul 2023 15:12:06 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
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
Subject: Re: [PATCH v2 00/15] UFS: Add OPP and interconnect support
Message-ID: <20230721094206.dfgnn73kmzzj6rtw@vireshk-i7>
References: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20-07-23, 11:10, Manivannan Sadhasivam wrote:
> Hi,
> 
> This series adds OPP (Operating Points) support to UFSHCD driver and
> interconnect support to Qcom UFS driver.
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
> the OPP framework and devfreq drivers which are also added in this series.
> 
> Finally, interconnect support is added to Qcom UFS driver for scaling the
> interconnect path dynamically. This is required to avoid boot crash in
> recent SoCs and also to save power during runtime. More information is
> available in patch 13/13.

Hi Mani,

I have picked the OPP related patches from here (apart from DT one)
and sent them separately in a series, along with few changes from me.
Also pushed them in my linux-next branch.

Thanks.

-- 
viresh
