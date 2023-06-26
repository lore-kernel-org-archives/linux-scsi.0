Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BBBEB64DA
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 06:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFZGia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjFZGi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 02:38:29 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269921A2
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2023 23:38:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b5c2433134so19849321fa.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2023 23:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687761504; x=1690353504;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nf4BHdk3/Hzvwb2/Bxs/dfd2REs7lRTG5cGpmWwvjSA=;
        b=ZY6fFLGKxdjHbM+qOnkA6NjJyc8kadQsyUVJAH3bVhZdiuz5z+QZdeVktBlpeBNYY6
         Zs5SmHY1ZFpL1yoyu6DngeYJHs8tw8MtgpRouxeHMMN4BFDHql1CpuvduHRinV4vFOQo
         6dOvRMpNfMjDdMouvNECbEBMPYMjcN8jPTZmHoQFq6eAmXYoFJALxBCj9pJyu0JhuRvu
         yF4wfeQ+MA3t4Ztkh8VCXQP9RVlYDjqJJQE2fYKPN8u7UrVFo4uOXmBpRjkmGy8yarQP
         f9u3fTGujEYgyilJ/PYvNjADsVhFpRZ1j86GYZNLNuS8CZKNyhboDJFanBljS4XUsxeR
         WAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687761504; x=1690353504;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nf4BHdk3/Hzvwb2/Bxs/dfd2REs7lRTG5cGpmWwvjSA=;
        b=FXYchAlzyc0Y0bWIzOFvjq7Qb+yIH/ftDB9tR9f86kIHmoMD3yMp7X2mHOymG6bJzr
         +AVeRQ3ZD3LdnUwSNDBVs1LJjTfWg6a8ZReca50knPJCkvDvrL/TnwCw9Jhg8sd1SOmv
         i5ktSLy4eM0Old7i9kbxfiAXsljrduTG8vzIP0qVu+Lmg10/kas3BbIyPciDFVCXqGlE
         BfYipWdLBJOTRpG0nzGXPoXs8+8E364SbdC7CwOR6Ey+/PvLNx5erD8gWkS6jeSSqb5c
         YF/KGb2nU/1uxrYAscmq4FNv4vg61qVqzPIw1iv4JQx7nK1VH+IPeyAQsV//fkw+3Oqj
         qhpw==
X-Gm-Message-State: AC+VfDwzVCtOaBgua4tdkpGwNtqipsGz3pbZTr5DSH/C5zhr7E5/k0Ck
        mTv/EWxlVDQfGY8nKCep8tzXFg==
X-Google-Smtp-Source: ACHHUZ73aYv7VuW3xyb7s9+hnkLmNwBNkF0tFLW5aRKP46KN0Aa1iOGxgtPOLXON8SJV0gfN4JvlvA==
X-Received: by 2002:a2e:a4a8:0:b0:2b6:9dcf:bcb6 with SMTP id g8-20020a2ea4a8000000b002b69dcfbcb6mr987463ljm.19.1687761504261;
        Sun, 25 Jun 2023 23:38:24 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id i21-20020a2e9415000000b002b44bcdf809sm1050527ljh.87.2023.06.25.23.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jun 2023 23:38:24 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 26 Jun 2023 08:38:22 +0200
Message-Id: <CTMDIQGOYMKD.1BP88GSB03U54@otso>
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Rob Herring" <robh@kernel.org>
Cc:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Abel Vesa" <abel.vesa@linaro.org>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Conor Dooley" <conor+dt@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] scsi: dt-bindings: ufs: qcom: Fix warning for
 sdm845 by adding reg-names
X-Mailer: aerc 0.15.1
References: <20230623113009.2512206-1-abel.vesa@linaro.org>
 <20230623113009.2512206-6-abel.vesa@linaro.org>
 <cd84b8c6-fac7-ecef-26be-792a1b04a102@linaro.org>
 <CTK1AI4TVYRZ.F77OZB62YYC0@otso> <20230623211746.GA1128583-robh@kernel.org>
In-Reply-To: <20230623211746.GA1128583-robh@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob,

On Fri Jun 23, 2023 at 11:17 PM CEST, Rob Herring wrote:
> On Fri, Jun 23, 2023 at 02:38:04PM +0200, Luca Weiss wrote:
> > On Fri Jun 23, 2023 at 2:31 PM CEST, Krzysztof Kozlowski wrote:
> > > On 23/06/2023 13:30, Abel Vesa wrote:
> > > > There is a warning on dtbs check for sdm845, amongst other platform=
s,
> > > > about the reg-names being unevaluated. Fix that by adding reg-names=
 to
> > > > the clocks and reg properties check for such platforms.
> > > >=20
> > > > Fixes: 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtsche=
ma")
> > > > Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> > > > ---
> > > >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >=20
> > > > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/=
Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > > index 0209713d1f88..894b57117314 100644
> > > > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > > @@ -166,6 +166,10 @@ allOf:
> > > >          reg:
> > > >            minItems: 2
> > > >            maxItems: 2
> > > > +        reg-names:
> > > > +          items:
> > > > +            - const: std
> > > > +            - const: ice
> > >
> > > reg-names looks like a new property, so it should be defined in
> > > top-level and just constrained per-variant.
> > >
> > > Also there was similar approach:
> > > https://lore.kernel.org/all/20221209-dt-binding-ufs-v2-2-dc7a04699579=
@fairphone.com/
> > >
> > > but I guess no resends and it can be superseded.
> >=20
> > Right, the patches got reviews but was never applied... I really need t=
o
> > find a strategy to keep track of sent patches until they're applied wit=
h
> > my work mailbox, it's not the first time that a patch has gotten
> > forgotten.
>
> There was an error reported on the above series. Why would it be=20
> applied?

The error report at [0] complains about reg-names but I'm quite sure
that patch 2/3 resolves this error. Does your bot only apply one patch
at a time and run the check or apply all of them and then run it? It's
been a while but I'm fairly sure I ran all of the checks before sending
since I also documented some other patches in the cover letter there.

[0] https://lore.kernel.org/all/167241769341.1925758.17856681634949446114.r=
obh@kernel.org/

>
> That said, I'm not sure SCSI maintainers consistently apply DT only=20
> patch series.
>
> > With my private mailbox I just have a different folder for patches that
> > have been sent which I archive once they're applied, but with work GMai=
l
> > I don't see how I can easily replicate this since it's also not groupin=
g
> > threads properly.
>
> Yeah, GMail sucks for that. I use 'lei' to get all my patches and=20
> replies to them (though its caching will miss replies). Then I delete=20
> them from the mbox when they are applied or otherwise finished. lei=20
> updates won't re-add them to the mbox.

I'll try to figure something out with GMail.. Perhaps just adding a
label "not yet applied" which I manually remove once it's applied would
be sufficient.

Regards
Luca

>
> Rob

