Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4C6C7EE31
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 09:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbjEYJjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 05:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240682AbjEYJjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 05:39:10 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6FE19D
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 02:38:02 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a1e0cc1a2514c-783e5c64d29so521066241.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 May 2023 02:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1685007481; x=1687599481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEJFrZVH1rjo4B3+YvFZtJFJ+STMe28dWj3W1cbfjMs=;
        b=iM2dxEBGMSs2nJR2qB95J2e/i2Np/iJRynzb0xvTDnfd99o52WnVpmlrE+ekNrdP21
         lmFU512dtt04r3jw/y9ly4KvHRST8MXGu3XVTnkxtP2RE8qSEVcn/9w+WecabUewP9Qe
         7p6w13DuBGgg24cRZDnYPAuAxqwd1pV2GkP+S4nF1+W6faHxDtCV++fg2FCzaO02oR7W
         kFuXYFtxORG0kp7v+Zl4VA1/yWISCnBOirroGOPOYjymNrIS/3EV5QG1CoBjwVbpjhBk
         XaAt9wRu05Uk1DFMHcz0qrvKmDo2lyFbQaSjmscE8ujrledQgK8tDBHsodiZuP0YgJkw
         I8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685007481; x=1687599481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEJFrZVH1rjo4B3+YvFZtJFJ+STMe28dWj3W1cbfjMs=;
        b=lSzx3zPcCbZJa4qYe5PGqLzzBg3chazPDR81TQb018z7Nqq8IY1LCl8DmRUJ9XnfYb
         4KCN40vk7+Bx4VZRohe47U6DdJubLe5IgLeQESBmH5Wof0xD4r74kwshZibmjbtKZuwZ
         p2IRZI8blUqW41g1/bwB1XvH2Vk0wM1ImycKRF4sKjqLGjUsk9HMEA0JDhegjAVU8Ued
         0WESP2x2lUtuToUkI/0QyQZk5C2zVkA68wHNJ+0dVnTGOGNy5uRxi8d+bVrGgNKJEQ8U
         3pPaDwoxMNeZXFptt1RNa1pzQDwAaeL1XozD6ad7hx6fiUUNDmvalATnqsk2ayJJYo6/
         jqgA==
X-Gm-Message-State: AC+VfDzTUEfjx0INh2z1neHGFmw/dtUFX9IrkLgzVolZ/9gJ7yuZy5Ty
        9ohYBqKpf49CB4MNfqHuuhFjNR65ruSvT+MDB/+wkA==
X-Google-Smtp-Source: ACHHUZ7WpOy3wCLD5AtzEtx27Y4bEWHrtU9zN+2rZF5BNaH1IbmVOHvB1XOktMAjYDfHAtlHwjS6fZtVO9liQY+ETCk=
X-Received: by 2002:a67:dc8c:0:b0:439:6c06:606e with SMTP id
 g12-20020a67dc8c000000b004396c06606emr795944vsk.0.1685007481350; Thu, 25 May
 2023 02:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230411130446.401440-1-brgl@bgdev.pl> <20230411130446.401440-2-brgl@bgdev.pl>
 <CAMRc=MdDct0UzJPpOTuKHmm23Jc529NwkBWJJmXfeevpkQaSxQ@mail.gmail.com>
In-Reply-To: <CAMRc=MdDct0UzJPpOTuKHmm23Jc529NwkBWJJmXfeevpkQaSxQ@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 25 May 2023 11:37:50 +0200
Message-ID: <CAMRc=Me4EQ_7ArCeJASzKTimuSH=yNkrwm9DgE93s7kjdS5Nrw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: ufs: qcom: add compatible for sa8775p
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 16, 2023 at 12:06=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> On Tue, Apr 11, 2023 at 3:04=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.p=
l> wrote:
> >
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > Add the compatible string for the UFS on sa8775p platforms.
> >
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Docu=
mentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > index c5a06c048389..b1c00424c2b0 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > @@ -26,6 +26,7 @@ properties:
> >            - qcom,msm8994-ufshc
> >            - qcom,msm8996-ufshc
> >            - qcom,msm8998-ufshc
> > +          - qcom,sa8775p-ufshc
> >            - qcom,sc8280xp-ufshc
> >            - qcom,sdm845-ufshc
> >            - qcom,sm6350-ufshc
> > @@ -105,6 +106,7 @@ allOf:
> >            contains:
> >              enum:
> >                - qcom,msm8998-ufshc
> > +              - qcom,sa8775p-ufshc
> >                - qcom,sc8280xp-ufshc
> >                - qcom,sm8250-ufshc
> >                - qcom,sm8350-ufshc
> > --
> > 2.37.2
> >
>
> Bjorn,
>
> Are you picking this one up as well or should it go through Rob's tree?
>
> Bart

Gentle ping.

Bart
