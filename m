Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEB9C74A44
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 09:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCJJiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCJJhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 04:37:45 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F299105F00
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:35:01 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k37so2971934wms.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678440899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C0r7q8PKLUopjVNWQN9Mv/I1U7v5pNMj66Y277WKY0Y=;
        b=bKcXa2asLlQbqrS0wBckEeIrXU3SVoSbXWoMxkK0YCn1FZP19GHuhSkNiSECl5h1t3
         3RXEttjUiPKf/bGs3nHD76rfrdmsKr0mBIIggBlXtMfFRKlcXODD2m5/HCJO+TH+1cIv
         Xmk0JO+/9HHRwqBuUA1Za8P+Rw6jvLO0e/2P70YLTFhp7CD5CpK6jur3/s+kQGcqCXLQ
         IRdLFhEdLxTxu8nJiztQCi22AfJtio6MlJIZ87r+5OFUUsjWaz0AhBi3kgaSq6t6R2gW
         N0k2ag3/3L5+VsDp1KG7wA+Y3iHfrlc1j6xDVeMPRffEG9qngtkccEetLRtDGpUlQmNp
         u9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678440899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0r7q8PKLUopjVNWQN9Mv/I1U7v5pNMj66Y277WKY0Y=;
        b=GzzVTfKsH9819MUJeUSpSi7JIJ0ZGNTkmx5xmPJY+Wi8mhzuQOBcY4Yq6W6D7TMC/e
         j1s1ESV6EEbXPOno0eIpLatmxsekDGYiPQ/aVdSv2/OM3Yr8KF/ELUiKrnjnqjpYu6+I
         CH4jQD0P1+fusqCRDKvUNaiuD9nAZEto7Zmza2zsqCyBHNn7X2dlh/SMlshGzPe6BsHv
         Giy5O+OtwfYm/0Ptp1kOZKea8XXKm92x8xyHJyIkKQqzIrpbYemElW20nAknmWBVOzG+
         zawYRYSjHoOhxxplz45DSMs50iHhAjlMpW6R3lbKh0x86/r5YzvBsSJeMVCZiWOHODT/
         49Kw==
X-Gm-Message-State: AO0yUKWy11iHJaQ9roKDKJhaj+VDqX8au6NKPPGnTXU9fKN4Sn6oyOJO
        35rysTdt4QxF+nYGReTRuu87aA==
X-Google-Smtp-Source: AK7set9Bg0cPa53e6HWS1OMZokrhjnTPJtXg3ZUoXie6Nl4BNrA1J8JcwmvfpXYE97Ci3RCMOZlLog==
X-Received: by 2002:a05:600c:3109:b0:3eb:3104:efef with SMTP id g9-20020a05600c310900b003eb3104efefmr1977373wmo.31.1678440898732;
        Fri, 10 Mar 2023 01:34:58 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id a19-20020a05600c225300b003dc522dd25esm1555749wmm.30.2023.03.10.01.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:34:57 -0800 (PST)
Date:   Fri, 10 Mar 2023 11:34:55 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: Re: [RFC PATCH v2 7/7] arm64: dts: qcom: Add the Inline Crypto
 Engine nodes
Message-ID: <ZAr5v/jbd18K5Lug@linaro.org>
References: <20230308155838.1094920-1-abel.vesa@linaro.org>
 <20230308155838.1094920-8-abel.vesa@linaro.org>
 <4eab53fc-2d26-dc93-3ae6-c0b2546ad3e0@linaro.org>
 <ZAol5o5a6HZYgRaG@sol.localdomain>
 <b5c9aa6e-69d1-165a-4ff9-b5a9f33688e6@linaro.org>
 <ZAr2nlFSKkBBQgcY@linaro.org>
 <4ea944dd-8a42-e83f-607c-1a36124d19bb@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ea944dd-8a42-e83f-607c-1a36124d19bb@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23-03-10 10:27:12, Krzysztof Kozlowski wrote:
> On 10/03/2023 10:21, Abel Vesa wrote:
> >>>>>  			compatible = "qcom,sdm630-sdhci", "qcom,sdhci-msm-v5";
> >>>>>  			reg = <0x0c0c4000 0x1000>,
> >>>>> -			      <0x0c0c5000 0x1000>,
> >>>>> -			      <0x0c0c8000 0x8000>;
> >>>>> -			reg-names = "hc", "cqhci", "ice";
> >>>>> +			      <0x0c0c5000 0x1000>;
> >>>>> +			reg-names = "hc", "cqhci";
> >>>>
> >>>> I believe this will break the ICE on these platforms without valid
> >>>> reason. The commit msg does not explain why you do it or why this is
> >>>> necessary.
> >>>>
> >>>> We already we received comment that we keep breaking Qualcomm platforms
> >>>> all the time and need to keep them in some shape.
> >>>>
> >>>> Also, patchset is non-applicable in current set (breaks users) and
> >>>> neither commit nor cover letter mentions it.
> >>>>
> >>>
> >>> FWIW, I tested this patchset on SDA845, and ICE continues to work fine.
> >>
> >> Really? I clearly see of_find_device_by_node -> "return NULL" and all
> >> old code gone, so ABI is broken. Are you sure you applied patch 1-6 and
> >> ICE was working?
> > 
> > of_qcom_ice_get will return the ICE instance if the consumer node has a
> > qcom,ice property with a phandle for the ICE devicetree node.
> 
> When patches 1-6 are applied, there is no qcom,ice property in DTS. Thus
> I don't consider the test as correct... Even if we skip entire ABI
> discussion the patchset is non-bisectable thus the test was failing to
> detect even that.

Yeah, but that could've been solved easily like I explained yesterday on
irc. But that's not worth getting into anymore as I'll keep legacy working as
I explained.

> 
> > It will
> > return NULL otherwise. SDA845 has such ICE node added by this patch,
> > therefore, it will work. All platforms that have such node will work
> > functionally like before. But I'll take care of the legacy approach as
> > well in v3 (see below).
> 
> At point of patch 6 none of nodes have it. That's the entire point of
> bisectability.
> 
> What's more, if you reverse code and makes DTS patches before driver
> hoping to fix bisectability - do you see ICE working on existing
> platforms? I don't think it so...
> 
> > 
> >>
> >>>
> >>> (Though if I understand the patchset correctly, the ICE clock is no longer
> >>> turned off when the UFS host controller is suspended.  That isn't ideal as it
> >>> wastes power.  I would like that to be fixed.)
> >>>
> >>> Anyway, when you say "break the ICE", do you really mean "make an incompatible
> >>> change to the device-tree bindings"?
> >>
> >> It breaks existing users of DTS and kernel.
> > 
> > I assume you mean it breaks if someone is using old approach DTS with a
> > kernel that would have ICE driver merged. Yes, that it does. And for
> > that, in the v3, I'll make of_qcom_ice_get check if there is a reg entry
> > with name "ice" and create an ICE instance but for the same dev as the
> > consumer driver. OTOH, if there is no reg entry called "ice", it will
> > look up a device based on phande of qcom,ice property. This will allow
> > legacy style DTS to work fine, while using the unified driver as a
> > library, in that case. For newer platforms, the recommended approach
> > will be to add a new ICE node and use qcom,ice property.
> 
> For the driver this sounds good. I still think that existing (older) DTS
> should not have regs removed, because this affects other users of kernel
> DTS.

Yes, that's what I meant, the already supported platforms will remain
with ice reg in the consumer node.

> 
> 
> Best regards,
> Krzysztof
> 
