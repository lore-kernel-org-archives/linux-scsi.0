Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F7CC6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 09:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjCJJn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCJJm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 04:42:56 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062B91C7C0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:42:21 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e13so4432033wro.10
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2023 01:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678441337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LPInLZOYzoIRoYx9Oo6+KDA8Q8BwRlCDWnK6VRoNQtY=;
        b=VksT2yUtiBhAGeXiIMD5vubmOwq8Z+1ZDssMnKiobsfS7Pa4KkKezwLm1LP53Qsbpx
         bqhSoOGTWnasgW5MYrdFS0LiG9+8F1RXqkc8bCBg9+rVlq3Wnq0lXTA/ZeKwKcCPHaJS
         7OmpFCM3pigjrmMrKTNpXw+5mO6xr82fTzpAVnIAtx/cUTHESxBK77usRf9RD+b1HoyE
         Q+/JnQ+iCNdAY4Vyx9X9Q/uRIQ9pmuwjzXXF/G7Ceh375fO3BxUEjqR6GNQwpyoLA6x1
         noS1yhDL3BTa9W+wwwyUS+g31jas1IFYIJtkIaLzttgWOSuI4gE4ZHeMSepncJfLezsh
         hV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678441337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPInLZOYzoIRoYx9Oo6+KDA8Q8BwRlCDWnK6VRoNQtY=;
        b=4W6RWSgJy1A15//umrzFsSPGs4YQnBeVteNRa1RqB3phwi9WknsK101wV52mXaTXKK
         uoi2mvILohERmUP7SN6MFiJv7C/dnvPs223K7qaRiFfYofJ3RioBk4DwB1ec69B6Q3R0
         R+KcXaHM6bSYdfWoNP0fCPv0eyf+u70SPItUi/cvSxNwPRHtLJ0/iGVeBo1SXlfEgsFM
         XduYA4znY745CR3DWdmmJJd2IWuYOCBSKP3TsuS9NIlZM+iq09L94WC0HYn6ZruvJijb
         CpKx0RGI/vM7nM2MEMslXLiUHV/k+1YKX9QYw/Etu+oq/3FTkJ80+hnf9BKu5NkYi6vV
         25ww==
X-Gm-Message-State: AO0yUKWn0waSkUi9xPQQpSFTWwG0Y2QEQLDO1HOqzXRDFWXDa5k9ZQaQ
        nUv1JRymGkhBibZOXyKuY+EOvw==
X-Google-Smtp-Source: AK7set9RTGOc68ELXC0tenT4FKlqCU3FXruN/fg2t3uOkYxqzGZ8byBrnmngtpQdc6EUT36OJxzkRA==
X-Received: by 2002:a5d:5386:0:b0:2c3:e20b:82aa with SMTP id d6-20020a5d5386000000b002c3e20b82aamr16264290wrv.22.1678441336747;
        Fri, 10 Mar 2023 01:42:16 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id t15-20020adfe10f000000b002c5526234d2sm1671789wrz.8.2023.03.10.01.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:42:14 -0800 (PST)
Date:   Fri, 10 Mar 2023 11:42:12 +0200
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
Message-ID: <ZAr7dIFHzd71n5L5@linaro.org>
References: <20230308155838.1094920-1-abel.vesa@linaro.org>
 <20230308155838.1094920-8-abel.vesa@linaro.org>
 <4eab53fc-2d26-dc93-3ae6-c0b2546ad3e0@linaro.org>
 <ZAol5o5a6HZYgRaG@sol.localdomain>
 <b5c9aa6e-69d1-165a-4ff9-b5a9f33688e6@linaro.org>
 <ZAr2nlFSKkBBQgcY@linaro.org>
 <4ea944dd-8a42-e83f-607c-1a36124d19bb@linaro.org>
 <ZAr5v/jbd18K5Lug@linaro.org>
 <e9413338-7f33-8fd7-11cf-17a9b31aba57@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9413338-7f33-8fd7-11cf-17a9b31aba57@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23-03-10 10:37:42, Krzysztof Kozlowski wrote:
> On 10/03/2023 10:34, Abel Vesa wrote:
> >>> I assume you mean it breaks if someone is using old approach DTS with a
> >>> kernel that would have ICE driver merged. Yes, that it does. And for
> >>> that, in the v3, I'll make of_qcom_ice_get check if there is a reg entry
> >>> with name "ice" and create an ICE instance but for the same dev as the
> >>> consumer driver. OTOH, if there is no reg entry called "ice", it will
> >>> look up a device based on phande of qcom,ice property. This will allow
> >>> legacy style DTS to work fine, while using the unified driver as a
> >>> library, in that case. For newer platforms, the recommended approach
> >>> will be to add a new ICE node and use qcom,ice property.
> >>
> >> For the driver this sounds good. I still think that existing (older) DTS
> >> should not have regs removed, because this affects other users of kernel
> >> DTS.
> > 
> > Yes, that's what I meant, the already supported platforms will remain
> > with ice reg in the consumer node.
> 
> ... unless you plan to add to them UFS ICE, which would be nice feature
> thus justifying DTS re-shuffle :)

By supported I meant the ones that have ICE support already :)

> 
> Best regards,
> Krzysztof
> 
