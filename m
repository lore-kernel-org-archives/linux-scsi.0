Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADCAC6FD19
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 21:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjCHVz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 16:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCHVzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 16:55:21 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01752D3300
        for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2023 13:55:04 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h11so41649wrm.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2023 13:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678312503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNobrJtyVxKais+5xCBZIp/sku4QQfBasurHEecIWAE=;
        b=Xx0Z7goD6qsCry/gPmvS47RqLg7qVg1rsqP0/ivv6dVLBUn5MS10EP/EdHwYpbDGEU
         amc1TtUHaLR9QISTSc4s13jqYliAxZotYqA5v7ma1xa+nruXOjRgMn4SyBj9LF172nlI
         3fEfyk1sCkU4sqemUmyXLsZGL+g8BQpqebMUMA8JFX9RDGsUbWTlFLEzacTlewE643L2
         wpcwC/tuVbqFrGu44C0xcZkIvml71vXIU76g5z+CreInh1uzWrMmwRrdhqNJLnuAf9gP
         rXTuvAevUDQi1yyT0CRPjN2A+odDaicPcBsSP3ZUKufVU118R2TdNE2okzHMM37ZLwaL
         wnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678312503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNobrJtyVxKais+5xCBZIp/sku4QQfBasurHEecIWAE=;
        b=0NVo1D65r7Puvigp+1D8LTsXo1HjZ7j0y+4n6Czg9E0Hmq4yRPvZlSJ87Sb1jC4qYM
         S73MjIq+WZbxT1DuRwdTQhHUNegNin0u4LJsIM8YxX02TJAgmp59TK8j2jNf6IJUY5rh
         3r1u9w4EMwlAI7URaqYh8F6Wd9RekOSxljFT8YXy8h/cH8gxNIBAnCsfTBegFU2IyXjy
         M4uDA9wiws0H5H1KcRxEX15Z++F6/FW2VpG3vMAsWbaSZYg5JFoH3dh/Eyj0VtKm0293
         I8XcSZNG/7S9eMRK+5Uj+9QhLdY0EdeZJb8EmYTPxPULHM/PPiZchsQK8n8qXi+dh7Pg
         1iSg==
X-Gm-Message-State: AO0yUKWy01GcrqZkO2OWzI+30JIAjonNx87MqOddm4HUVZAF/ki1/btg
        8keHY9nnynglfC87JHfMc1nn1Q==
X-Google-Smtp-Source: AK7set8/BDV1TRoYFJRl+Ho21B1yvco18zhN9eA6Vxb9VJyRxA2mql6ty9uvzWGEDOdDdPzgRii47w==
X-Received: by 2002:adf:f44a:0:b0:2c9:ee50:b295 with SMTP id f10-20020adff44a000000b002c9ee50b295mr13070782wrp.28.1678312503333;
        Wed, 08 Mar 2023 13:55:03 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d6802000000b002c7163660a9sm16132508wru.105.2023.03.08.13.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:55:02 -0800 (PST)
Date:   Wed, 8 Mar 2023 23:55:01 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] Add dedicated Qcom ICE driver
Message-ID: <ZAkENY2DWTqIr86m@linaro.org>
References: <20230308155838.1094920-1-abel.vesa@linaro.org>
 <ZAjqBemusfSKEWgF@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAjqBemusfSKEWgF@sol.localdomain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23-03-08 12:03:17, Eric Biggers wrote:
> Hi Abel,
> 
> On Wed, Mar 08, 2023 at 05:58:31PM +0200, Abel Vesa wrote:
> > As both SDCC and UFS drivers use the ICE with duplicated implementation,
> > while none of the currently supported platforms make use concomitantly
> > of the same ICE IP block instance, the new SM8550 allows both UFS and
> > SDCC to do so. In order to support such scenario, there is a need for
> > a unified implementation and a devicetree node to be shared between
> > both types of storage devices. So lets drop the duplicate implementation
> > of the ICE from both SDCC and UFS and make it a dedicated (soc) driver.
> > Also, switch all UFS and SDCC devicetree nodes to use the new ICE
> > approach.
> > 
> > See each individual patch for changelogs.
> > 
> > The v1 is here:
> > https://lore.kernel.org/all/20230214120253.1098426-1-abel.vesa@linaro.org/
> > 
> > Abel Vesa (7):
> >   dt-bindings: soc: qcom: Add schema for Inline Crypto Engine
> >   dt-bindings: ufs: qcom: Add ICE phandle and drop core clock
> >   dt-bindings: mmc: sdhci-msm: Add ICE phandle and drop core clock
> >   soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver
> >   scsi: ufs: ufs-qcom: Switch to the new ICE API
> >   mmc: sdhci-msm: Switch to the new ICE API
> >   arm64: dts: qcom: Add the Inline Crypto Engine nodes
> 
> Does this address all the comments on v1?  I had also asked some questions on
> v1.  It would be helpful if you would respond.

Sorry about not doing that earlier. Did that now.

> 
> - Eric
