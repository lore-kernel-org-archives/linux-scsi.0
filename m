Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FF8C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 09:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbiKKJec (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 04:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiKKJeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 04:34:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57156327;
        Fri, 11 Nov 2022 01:34:30 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id y14so11303876ejd.9;
        Fri, 11 Nov 2022 01:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1O3bjY9wxlNEQJspWtcqXuaUIVH313lCfswZjOyFmo=;
        b=D91gVRv5exPZsksiOEYOMFtgEfz1NyipCKYsdyceerwR/yXY9cBUgnmyouUsIwkEQD
         DabMAHBFaR+EqiHrORdmQAlnza7bi6tJnK4Q7z42yVs5kZdP5Uo/DOJyAFUpqMTNwBrz
         Gl47UZurBbQmZgTVvXm51bIRcgpkI6HPiD3VzGW3tPMKTkBFS28/ZkrNSFsEiQ1XcsxQ
         wTgkjlmN9HL4nhpjT8wd3JJWaTOvegvPGGu+S8KYT9kzwGS1L35DFDPaQ7dD9T0XM93s
         QVqkuzGL6R2Nc8QyzHSBZB+rKTD3S86AVQdjTzXu2zw9BXZ6Sc1v2ZuIi6A46CvWRrK9
         bt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1O3bjY9wxlNEQJspWtcqXuaUIVH313lCfswZjOyFmo=;
        b=zssD7MegXoWN0+2wyriun++vDnlMWCa58BKIKbaW7KDDFox23mF+qVDjGUUQTq4xqe
         mBLBwWp6YME0zSSMljrY7QJSvEXJheREA3fatblkVK+lCQ6tsbIGB9T/V5xejiz408Dc
         xzvIbJnOjCyOVo3RgsscSEtZM3eqqdF9Iy2ldWTn5mEVkQ6yhvvgCeByeiHeK3edWfT5
         lGptvTglXkZYUvbANxA0Ztxo+2TZkQlwzllP0nbtDkKy2RA5ccGxvfO3PLk8arKu8hTi
         +dR9x9KFrY9ETWTgLQmcyNXuO2dbEWKZKaQT2tJlpeAEsz37xKAKA8IGAChAlk9bWQCP
         +8Gw==
X-Gm-Message-State: ANoB5plkjszCCERNVsBNX/X6JQ30Es4YCFflfSz9DjAPAS+qdFXFHkft
        jDvCIwXsnZI4cfFKGwGDi4rP1hg8FkWx8DLD+MU=
X-Google-Smtp-Source: AA0mqf5CBblMANBc8SQhkX+jNWhqxIdyXunf3jIQpJ9nbjPPlFLNQocbX8s018JvNDdPkmeuo49lsPGxVIXjM+ajIcc=
X-Received: by 2002:a17:906:1d08:b0:7a9:ecc1:2bd2 with SMTP id
 n8-20020a1709061d0800b007a9ecc12bd2mr1176222ejh.545.1668159269254; Fri, 11
 Nov 2022 01:34:29 -0800 (PST)
MIME-Version: 1.0
References: <20221110133640.30522-1-zhewang116@gmail.com> <20221110133640.30522-2-zhewang116@gmail.com>
 <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org> <CAJxzgGpAPs5+HFdq=GxR4bd_27XGLdJeTqAairCOhAf-wvj_CQ@mail.gmail.com>
 <be044e4c-b9dc-1214-5f7d-4a4d1c2669fe@linaro.org>
In-Reply-To: <be044e4c-b9dc-1214-5f7d-4a4d1c2669fe@linaro.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Fri, 11 Nov 2022 17:34:17 +0800
Message-ID: <CAJxzgGpKATsfjnD7ksc_UXdzwW76trkONDzRR2UpKHW1Buxxew@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Krzysztof,

On Fri, Nov 11, 2022 at 3:48 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 11/11/2022 06:34, Zhe Wang wrote:
> >>
> >
> > I'll fix it.
> >
> >>> +        clocks =3D <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_CF=
G_EB>,
> >>> +            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
> >>> +        freq-table-hz =3D <0 0>, <0 0>, <0 0>, <0 0>;
> >>
> >> Why this is empty? What's the use of empty table?
> >>
> >
> > freq-table-hz is used to configure the maximum frequency and minimum
> > frequency of clk, and an empty table means that no scaling up\down
> > operation is requiredfor the frequency of these clks.
>
> No, to indicate lack of scaling you skip freq-table-hz entirely, not
> provide empty one.
>
>

In the ufshcd-pltfrm.c file, the clock information is parsed by
executing the function ufshcd_parse_clock_info, if the number of
"freq-table-hz" is zero or if the number of "clock-names" and
"freq-table-hz" does not match, the UFS CLK information in dts will
not be obtained. Although we don't need to scaling freq, we also need
the CLK information for the CLK GATE operations. So we cannot delete
this freq-table here.

> Best regards,
> Krzysztof
>

According to the local test results just now, I would like to ask a
question about the previous revisions.
> > +
> > +  sprd,ufs-anly-reg-syscon:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: phandle of syscon used to control ufs analog reg.
>
> It's a reg? Then such syntax is expected:
> https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetre=
e/bindings/soc/samsung/exynos-usi.yaml#L42
>

In the syntax of this example, reg is represented by phandle and
offset, but I only need the information of phandle in this place=EF=BC=8CSo=
 in
this scenario, whether my original syntax is fine=EF=BC=9F just describe th=
e
pandlle.

Best regards,
Zhe Wang
