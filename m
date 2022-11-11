Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78827C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 10:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiKKKcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbiKKKbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 05:31:13 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8805D9;
        Fri, 11 Nov 2022 02:30:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n12so11548097eja.11;
        Fri, 11 Nov 2022 02:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/MLaZuJc8g+AT4gB5E2V8JlD6AZPsEIIWsJYtNaRZo=;
        b=kk9z8kZmME4Z7wPSusouaXVtJgIOWe+yUyyzVaM/XbJ/k9VMJquwChaS74L/IfAnM2
         nj3mu+qSnZKJtBKluAS35XGsmQmpIRm52WfDJFfxTCRrIdLQ80DC7iIkrL9tu6qayCOY
         QqbEA2P46R4O6q7D8oaajyWe4k/3YqPI9NNje01AZDlT+uiXvE4zT42ZzCjr7LwhJxUz
         UlIc7KkPk8zUehpznKcWBFCD0iudiA3XGQA/iMJvp5gf+mDVBvkOtL4YSfgeR9C1Sc8U
         71oB5g+ZAq4IX73OqxmJNuc+uIOzODwfUQs4XFh1u7byIn+2LKfbQhLeX9OZga5i1osX
         TkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/MLaZuJc8g+AT4gB5E2V8JlD6AZPsEIIWsJYtNaRZo=;
        b=heJ22CYHnI/mv/Nxg1/Kg5fRQu7mLIIyp7vMMTBQa7Q5v7b+tzg+WiVkfdc2SDYNCz
         XgXQChEw4WoFRvP1VtLIC8nizQgN4EPp+5sJl+cCMOXtl+B0wAFxGzgVqFBmvuZXktVJ
         pfLYL8twrRszMBiMCBPr/4mARJ/UHMQXFtHlDpCugHfAZHOnnR56UTHZLhCvXiaVF1Ju
         ygZZMN59sYISVOp/qd+QOHFlvgLNmmowEcVw5428juSYwlz0Pat6+hAt4piow6NEVxxb
         NEA6JCFSsQ0gsc8wufclroDDG6LS/l1sgHhVc043VjIww/rfg1lxjn0eJO5FE1/QnN1/
         Ja6Q==
X-Gm-Message-State: ANoB5pmKL6RNkyREgGdVQi6clVII+/1CuDzt0lhOcGl4EGNTU2nUQIcx
        75FrY6eBKEQWaDGClveGl/yA6LmQLgE6eECNh0dh7XF4ey4=
X-Google-Smtp-Source: AA0mqf5QKx/OfYD6GDE1ldzATKe073cIe4ClKLKpvP61eI25cZ5+uumqPk8KO8C0wkO/4KvUWvwopSoHmG54SZbuAP0=
X-Received: by 2002:a17:906:35d7:b0:7ad:eb81:c6c7 with SMTP id
 p23-20020a17090635d700b007adeb81c6c7mr1290890ejb.91.1668162646376; Fri, 11
 Nov 2022 02:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20221110133640.30522-1-zhewang116@gmail.com> <20221110133640.30522-2-zhewang116@gmail.com>
 <4bee5178-b34c-ec4b-9773-07f368064c48@linaro.org> <CAJxzgGpAPs5+HFdq=GxR4bd_27XGLdJeTqAairCOhAf-wvj_CQ@mail.gmail.com>
 <be044e4c-b9dc-1214-5f7d-4a4d1c2669fe@linaro.org> <CAJxzgGpKATsfjnD7ksc_UXdzwW76trkONDzRR2UpKHW1Buxxew@mail.gmail.com>
 <af83da3a-11e1-f53d-6b69-5c3387b61cf8@linaro.org>
In-Reply-To: <af83da3a-11e1-f53d-6b69-5c3387b61cf8@linaro.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Fri, 11 Nov 2022 18:30:35 +0800
Message-ID: <CAJxzgGodv1MsgtGB2WS3NgKiWVxBEf1VWp2vbPOrkPmi6VTVFA@mail.gmail.com>
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

On Fri, Nov 11, 2022 at 5:51 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 11/11/2022 10:34, Zhe Wang wrote:
> > Hi Krzysztof,
> >
> > On Fri, Nov 11, 2022 at 3:48 PM Krzysztof Kozlowski
> > <krzysztof.kozlowski@linaro.org> wrote:
> >>
> >> On 11/11/2022 06:34, Zhe Wang wrote:
> >>>>
> >>>
> >>> I'll fix it.
> >>>
> >>>>> +        clocks =3D <&apahb_gate CLK_UFS_EB>, <&apahb_gate CLK_UFS_=
CFG_EB>,
> >>>>> +            <&onapb_clk CLK_UFS_AON>, <&g51_pll CLK_TGPLL_256M>;
> >>>>> +        freq-table-hz =3D <0 0>, <0 0>, <0 0>, <0 0>;
> >>>>
> >>>> Why this is empty? What's the use of empty table?
> >>>>
> >>>
> >>> freq-table-hz is used to configure the maximum frequency and minimum
> >>> frequency of clk, and an empty table means that no scaling up\down
> >>> operation is requiredfor the frequency of these clks.
> >>
> >> No, to indicate lack of scaling you skip freq-table-hz entirely, not
> >> provide empty one.
> >>
> >>
> >
> > In the ufshcd-pltfrm.c file, the clock information is parsed by
> > executing the function ufshcd_parse_clock_info, if the number of
> > "freq-table-hz" is zero or if the number of "clock-names" and
> > "freq-table-hz" does not match, the UFS CLK information in dts will
> > not be obtained. Although we don't need to scaling freq, we also need
> > the CLK information for the CLK GATE operations. So we cannot delete
> > this freq-table here.
>
> I did not check the driver implementation, but if that's the case it
> does not match bindings. Before adding empty useless tables, please
> either fix bindings or driver. I think the latter - the driver - becasue
> clocks are not depending logically on freq-table-hz.
>

OK, I will think about how to solve this problem.

> >
> >> Best regards,
> >> Krzysztof
> >>
> >
> > According to the local test results just now, I would like to ask a
> > question about the previous revisions.
> >>> +
> >>> +  sprd,ufs-anly-reg-syscon:
> >>> +    $ref: /schemas/types.yaml#/definitions/phandle
> >>> +    description: phandle of syscon used to control ufs analog reg.
> >>
> >> It's a reg? Then such syntax is expected:
> >> https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/device=
tree/bindings/soc/samsung/exynos-usi.yaml#L42
> >>
> >
> > In the syntax of this example, reg is represented by phandle and
> > offset, but I only need the information of phandle in this place=EF=BC=
=8C
>
> No. You wrote "analog reg". So one reg. Not regs.
>
> > So in
> > this scenario, whether my original syntax is fine=EF=BC=9F just describ=
e the
> > pandlle.
>
> No, because your description said one reg.
>

This is my mistake, the description is wrong, it's regs.
Thank you for your review!

Best regards,
Zhe Wang

> Best regards,
> Krzysztof
>
