Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325F8C4321E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 12:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiKUMiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 07:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiKUMiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 07:38:01 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A423B54F2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 04:37:58 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 84-20020a1c0257000000b003cfe48519a6so6401038wmc.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 04:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OfJ6ReGcbvudqGx5aWnlLmh808mEmKwe4YM900G8GoU=;
        b=bhLvzu/iY7Mjd1xlH9twYzc2DCTHHIuR6cmeB16W+qrctjI2VgehKZyGjhsb0y/s9Q
         rb5YPfiHqcjgLHbMXVp1UA7FFBV5n7zmRJIowCr2t4gxPwYHqilNJKTuooB3QAcZFDKk
         fZPBYxMNpqfIMW4A5i2NiTps5MXN74532w65v0P6trMHqwWrfavqhd07zEWt36odoyfn
         4ZHkqB9bGKS91KyjTFGnfRiCUkjx9qVv3VGl8kFEL6Oy+w8gJ+FQWT1UgfYoNk4Wjtj3
         +WY+DtEaJYy5UC5YzyvXglazmcTU9wPC4nUtmeIyCSRMxit9IPjY7hrBVMj9Kwo3Wn3C
         1kKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfJ6ReGcbvudqGx5aWnlLmh808mEmKwe4YM900G8GoU=;
        b=HAhJZlx9EZv3zsW8oqOjF+8RuSwKj/JScGmK3Xf4fBzAYINEq9MQVRfEa+rn03NbOQ
         Uv44SHahYaqqjZjal9CNb++cAW52czcbXdm2Xiga7Jn4f6ng27lgzv4/jDofMsNMKnmp
         RCuIJb0Bvuc0SF8VR1gQ4ERQn6of0UMU8JlUQhA3wXxmhRgoENvASVkKihV7I84pxLOh
         Cn7YSyVPR6sPEUdegGtjjrN50Mq1z9FHpariLIAYTFx9v825AmxEI6s2hCqUCXwWzFZ0
         cJztJKZWt0iQ6rjmp06k7qbSBL7Ou/9iz4V41VTwwVifTz1SZEn0hIDThmQ2y231nNDE
         jotw==
X-Gm-Message-State: ANoB5pn6Sm9gMiwdzIyLV84BEqdCROxYY0iL8ESfKS5g4VwH3cVT2KgU
        PAP+xPTrtKuIIOGDxBL5W8JHYQ==
X-Google-Smtp-Source: AA0mqf5JngN/dT4Kr7SbrPWvWx3miCH34ldho+VQ75xmRL5193rxCxFZa4xfx0c7V+FzhXpY/pFlwQ==
X-Received: by 2002:a1c:7401:0:b0:3cf:934b:b7ad with SMTP id p1-20020a1c7401000000b003cf934bb7admr1734188wmc.22.1669034276591;
        Mon, 21 Nov 2022 04:37:56 -0800 (PST)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id e21-20020a05600c219500b003cf894dbc4fsm13496353wme.25.2022.11.21.04.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 04:37:56 -0800 (PST)
Date:   Mon, 21 Nov 2022 14:37:54 +0200
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] ufs: host: ufs-qcom: Clear qunipro_g4_sel for HW
 version major 5
Message-ID: <Y3txIoDn3hFBXt0Y@linaro.org>
References: <20221116121732.2731448-1-abel.vesa@linaro.org>
 <20221116121732.2731448-2-abel.vesa@linaro.org>
 <57b0669c-3826-dc33-36a4-2d8220da768a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57b0669c-3826-dc33-36a4-2d8220da768a@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22-11-16 13:28:53, Konrad Dybcio wrote:
> 
> 
> On 16/11/2022 13:17, Abel Vesa wrote:
> > On SM8550, depending on the Qunipro, we can run with G5 or G4.
> > For now, when the major version is 5 or above, we go with G5.
> > Therefore, we need to specifically tell UFS HC that.
> > 
> > Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> > ---
> >   drivers/ufs/host/ufs-qcom.c | 4 ++++
> >   drivers/ufs/host/ufs-qcom.h | 2 ++
> >   2 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index ca60a5b0292b..72334aefe81c 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -227,6 +227,10 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
> >   	ufshcd_rmwl(host->hba, QUNIPRO_SEL,
> >   		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
> >   		   REG_UFS_CFG1);
> > +
> > +	if (host->hw_ver.major == 0x05)
> > +		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
> > +
> >   	/* make sure above configuration is applied before we return */
> >   	mb();
> >   }
> > diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> > index 751ded3e3531..10621055bf7f 100644
> > --- a/drivers/ufs/host/ufs-qcom.h
> > +++ b/drivers/ufs/host/ufs-qcom.h
> > @@ -36,6 +36,7 @@ enum {
> >   	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
> >   	REG_UFS_PARAM0                      = 0xD0,
> >   	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
> > +	REG_UFS_CFG0                        = 0xD8,
> Are you sure these two should point to the same register? Maybe it deserves
> some kind of a comment?

The REG_UFS_PA_LINK_STARTUP_TIMER is used by non qunipro variants. (UFS
versions below 2.x)

The REG_UFS_CFG0 is used by qunipro variants. (UFS versions above 2.x).

Will add a comment to the later one that would look like this:
"/* Found on UFS versions above 2.x only */"

Thanks,
Abel

> 
> Konrad
> >   	REG_UFS_CFG1                        = 0xDC,
> >   	REG_UFS_CFG2                        = 0xE0,
> >   	REG_UFS_HW_VERSION                  = 0xE4,
> > @@ -75,6 +76,7 @@ enum {
> >   /* bit definitions for REG_UFS_CFG1 register */
> >   #define QUNIPRO_SEL		BIT(0)
> > +#define QUNIPRO_G4_SEL		BIT(5)
> >   #define UFS_PHY_SOFT_RESET	BIT(1)
> >   #define UTP_DBG_RAMS_EN		BIT(17)
> >   #define TEST_BUS_EN		BIT(18)
