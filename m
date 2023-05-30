Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8EBC77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 09:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjE3JrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 05:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjE3JrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 05:47:20 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA43AD
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 02:47:19 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-439367c12ceso2823230137.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 02:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1685440038; x=1688032038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIzhChYUNLfm+XWki27JvZkO7NGgI4DFHIFwo2T7aS0=;
        b=bBkPAO2St5nJS4Kko98Tl60g8CTrz4Nn54qpkMWme+FATa5T6sx8k0544Cm0V518eu
         PguWspaNIRycRueuC4UxrB5+FuCj+dXJQqiidL/e4ukbPdlKmQtSaGNAfbrJvaJRHaKR
         2GJssxV+7AtQZya8RptndBvMoSMt7hR55I+NR4/oqy6yMh9VJS+UExy+y/n1QvpRDogx
         OojCNQDKPQsRIJ7R/ysgwyw8V1Y/E/p1Z3nPl0T6EAo/5BJcFHdoqkDfEqjtdzCBaQZc
         rFPDmyI0qCr74+oj8ETtfvkADEXaovqDyxO2vPxHX0Y33RjKrc5GqBu6mo2fSdn17Ir5
         e+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685440038; x=1688032038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIzhChYUNLfm+XWki27JvZkO7NGgI4DFHIFwo2T7aS0=;
        b=jewD2l40YGuFJc0y6n7Gj3sqVr3Hg/yvDDNlIJvMuRD6kppVe3Bmw5IPko+6o83KzI
         bJG7tJw+yQ/LjnFaVbWLzNzIBEC6c57C/+JdjEha4ehZ6RikuRbUkcCOBqDOLuO3FkJL
         bEQiu009hJ34m79kzIYjSdaKvPr65Wjq1SM8lomnGkAnrZv6WSdTSKDE4v+Z5QISRrdp
         +NkJYxBD1JnDqKhlzLEB7J8tvl8r5vL5Mz0eccu1OFKnRxhJg98O81lwSvePKdk8iARY
         TIfehpiOulI9qBtnwOq8K8ZRzi5DyjTlKV3RYRACvwe0nMDmmXu1usYxu8Pa0hO955Hz
         H/MQ==
X-Gm-Message-State: AC+VfDyz/s5rAM8clMsSiZwhS6tWAG3xXMmj6uKZCf7h22SUwUuiAx3e
        Rw/vEDKLLIiWEE8ErEoyTbrwJY8gBDfv73ghCVhilw==
X-Google-Smtp-Source: ACHHUZ6YElDOMjsnjuiqQPgxgQ7QloYBoa4ZvDWgRo3oSyyufZR6kZTSCoJ6Bf8lfwaaT/BrhKvzzzC/ep67kdjyrlU=
X-Received: by 2002:a67:f24a:0:b0:430:acc:a150 with SMTP id
 y10-20020a67f24a000000b004300acca150mr502826vsm.3.1685440038182; Tue, 30 May
 2023 02:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230411130446.401440-1-brgl@bgdev.pl> <20230411130446.401440-2-brgl@bgdev.pl>
 <CAMRc=MdDct0UzJPpOTuKHmm23Jc529NwkBWJJmXfeevpkQaSxQ@mail.gmail.com> <CAMRc=Me4EQ_7ArCeJASzKTimuSH=yNkrwm9DgE93s7kjdS5Nrw@mail.gmail.com>
In-Reply-To: <CAMRc=Me4EQ_7ArCeJASzKTimuSH=yNkrwm9DgE93s7kjdS5Nrw@mail.gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 30 May 2023 11:47:07 +0200
Message-ID: <CAMRc=MfhYu6sxhFABjyQUT5NGwNu1oJuRjMBqPvQ0Z8MhjoSRg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: ufs: qcom: add compatible for sa8775p
To:     Kishon Vijay Abraham I <kishon@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 25, 2023 at 11:37=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> On Tue, May 16, 2023 at 12:06=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> >
> > On Tue, Apr 11, 2023 at 3:04=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev=
.pl> wrote:
> > >
> > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > >
> > > Add the compatible string for the UFS on sa8775p platforms.
> > >
> > > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > > ---
> > >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > index c5a06c048389..b1c00424c2b0 100644
> > > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > > @@ -26,6 +26,7 @@ properties:
> > >            - qcom,msm8994-ufshc
> > >            - qcom,msm8996-ufshc
> > >            - qcom,msm8998-ufshc
> > > +          - qcom,sa8775p-ufshc
> > >            - qcom,sc8280xp-ufshc
> > >            - qcom,sdm845-ufshc
> > >            - qcom,sm6350-ufshc
> > > @@ -105,6 +106,7 @@ allOf:
> > >            contains:
> > >              enum:
> > >                - qcom,msm8998-ufshc
> > > +              - qcom,sa8775p-ufshc
> > >                - qcom,sc8280xp-ufshc
> > >                - qcom,sm8250-ufshc
> > >                - qcom,sm8350-ufshc
> > > --
> > > 2.37.2
> > >
> >
> > Bjorn,
> >
> > Are you picking this one up as well or should it go through Rob's tree?
> >
> > Bart
>
> Gentle ping.
>
> Bart

Hey UFS maintainers, could you please pick this one up for the next
merge window?

Thanks in advance,
Bartosz
