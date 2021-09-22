Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6524C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E382610A0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhIVT66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 15:58:58 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:34647 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhIVT65 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 15:58:57 -0400
Received: by mail-oo1-f46.google.com with SMTP id g4-20020a4ab044000000b002900bf3b03fso1349453oon.1;
        Wed, 22 Sep 2021 12:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xft0saWjNw8nsQUuw1gHXg9mUcTNl9llqFY3UzXKk8g=;
        b=majYIghlRzo5rHZniNormKUEZf94lncCEWVCC0KMzRyq5mozyaJo7FqnFajrpKihJm
         Iuj6bfgzyUn3Pd6N+Nnps8jgQSw+uoKPAquvSfaRzZo5YF+uEINSRKYP6Pms10J7CjNg
         uo+hqMJrXVXk+LUt7+Tt5zOzGlgY9LjgwZy4AlNQD3EMM0RMkW8oyzEn1BjUdwGojXjw
         PICvRzglc0e1WTiO4cZx9WnQn9rUo54CBbhildu30qDHEVYdAGDoCpXOK6DzkGBxUXUV
         WOxbK0lhXj3o1CzMzafbGyZeWQOJXT/Qtaqwrd0AycHRKBe4Q5bH/7GVjjk6IUh55cHB
         Taag==
X-Gm-Message-State: AOAM5329hiShoppp4UF3sVr/asbv0b+11xfMkhdjNHswUxaBDqs2/2y9
        GD79l4Vhwp7Lh9+batoEdA==
X-Google-Smtp-Source: ABdhPJzis4qCxnYCRpy8rJW5UXLy9i0EOkptzpuVPk6fLIbuh8UtHe1adN037ZvedAQRbpNfYq//gQ==
X-Received: by 2002:a4a:ded2:: with SMTP id w18mr582209oou.77.1632340646845;
        Wed, 22 Sep 2021 12:57:26 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r18sm750612ooc.27.2021.09.22.12.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 12:57:26 -0700 (PDT)
Received: (nullmailer pid 1190943 invoked by uid 1000);
        Wed, 22 Sep 2021 19:57:25 -0000
Date:   Wed, 22 Sep 2021 14:57:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 05/17] dt-bindings: ufs: exynos-ufs: add sysreg regmap
 property
Message-ID: <YUuKpSPgdKl2CiSy@robh.at.kernel.org>
References: <20210917065436.145629-1-chanho61.park@samsung.com>
 <CGME20210917065523epcas2p3ff66daa15c8c782f839422756c388d93@epcas2p3.samsung.com>
 <20210917065436.145629-6-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917065436.145629-6-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 03:54:24PM +0900, Chanho Park wrote:
> Add "sysreg" regmap phandle property to control io coherency setting.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml          | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> index b9ca8ef4f2be..c3f14f81d4b7 100644
> --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -54,6 +54,11 @@ properties:
>    phy-names:
>      const: ufs-phy
>  
> +  sysreg:

Needs a vendor prefix.

> +    $ref: '/schemas/types.yaml#/definitions/phandle'
> +    description: phandle for FSYS sysreg interface, used to control
> +                 sysreg register bit for UFS IO Coherency

Is there more than 1 FSYS? If not, you can just get the node by its 
compatible. 

Also, what about 'dma-coherent' property? The driver core needs to know.

> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.33.0
> 
> 
