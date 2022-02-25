Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10388C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 19:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiBYTeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 14:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiBYTeT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 14:34:19 -0500
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A3B1986F0;
        Fri, 25 Feb 2022 11:33:47 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id g6-20020a9d6486000000b005acf9a0b644so4308820otl.12;
        Fri, 25 Feb 2022 11:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXWgeu8+968e0Kmo1u41wpbvPdau1hEHUCnnzvatggs=;
        b=fKOWqXIo2ZTw5ILsrdzx/IpT63kph4r3+5H8szQe/vQ8Bb8EY39rZvz4jGDCJk3iAC
         XmpkrwwmhyRQTaOQZX+24nf4whMPV+/qUN/twmORXeE01OrbtPeKO7zM4FYouDaUKa/E
         UGebIKNnWHob1rx7nODdrs0POHNXuhpR+Y59dC0FB26Oi3gAQJmPQ/bU2mG1yGiYX4Xi
         jotQBgaTajwkYLOA5F0t6vXovgYjrdWu18ZmQ4SXblWxfJ4AGRBxsgzdiALCmuZ9VIaA
         Fm36MkN4FD8m07F0PEnrAYg8nR9519jlp9qPTtDZRxo/qPqc5sxevcmWWuLw9IwFztPN
         RDDw==
X-Gm-Message-State: AOAM533J5YKOaL2LVuluAWz12X7ZbNKXa5xUb0tVrwAhCaSqWnDGuMlB
        X9df49KL8i3AB+W8TxgKQw==
X-Google-Smtp-Source: ABdhPJzWS5GZdRiTixomm/Zw4NMpp3+A1z1Lq0uTL92KKpb/O56qwbzhuIIrXP/F+SlhamPdwaRolA==
X-Received: by 2002:a9d:b93:0:b0:5af:82ec:574e with SMTP id 19-20020a9d0b93000000b005af82ec574emr3573389oth.209.1645817626861;
        Fri, 25 Feb 2022 11:33:46 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a27-20020a4ae93b000000b0031be7c7d2d3sm1524442ooe.0.2022.02.25.11.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 11:33:46 -0800 (PST)
Received: (nullmailer pid 1299041 invoked by uid 1000);
        Fri, 25 Feb 2022 19:33:45 -0000
Date:   Fri, 25 Feb 2022 13:33:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Li Wei <liwei213@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Jan Kotas <jank@cadence.com>, Wei Xu <xuwei5@hisilicon.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tero Kristo <kristo@kernel.org>, linux-kernel@vger.kernel.org,
        Nishanth Menon <nm@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>
Subject: Re: [PATCH v2 05/15] dt-bindings: ufs: qcom,ufs: convert to dtschema
Message-ID: <YhkvGS8dSA0Sh0nR@robh.at.kernel.org>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
 <20220222145854.358646-6-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222145854.358646-6-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Feb 2022 15:58:44 +0100, Krzysztof Kozlowski wrote:
> Convert the Qualcomm Universal Flash Storage (UFS) Controller to DT
> schema format.
> 
> Except the conversion, add also properties already present in DTS:
> iommus, interconnects and power-domains.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../devicetree/bindings/ufs/qcom,ufs.yaml     | 241 ++++++++++++++++++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  90 -------
>  2 files changed, 241 insertions(+), 90 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
>  delete mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
