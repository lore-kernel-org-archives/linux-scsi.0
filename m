Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13982C001DD
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjF0Ib5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjF0IbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:31:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E5E30F4
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:30:07 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-988a076a7d3so627905666b.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687854603; x=1690446603;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mThrgyARyedryNmjWfnH4cpZ5pepRN8cVLn3M8pGEJY=;
        b=2nvDVQEZUxNnVZ2cn0fsA8A0oh1DdvDZvaBPZYQEH+YcsDB8ssrVIV4GaFC60NcHhL
         HyGKYzgOy/ChvDJU+qRDmPAgfLXtAMJWk37ekLsrOfHfO36JecHazPE4cHDos+XezL4G
         Fy8eZTTAkpKGGau29aB6cbehqHFr7rNwf+6MyrO4rmqZdU/giXS8d2s0WLUoqitCvUSu
         DpliyDGaJOMx+LdhtiIc2N+4rG1CgvTcyJEN2wDDgR7Cl9cWFIY+y0pYkotcO8aNExEd
         k6KYtDvWR1u/zrNFAc1Ox7aEw99qxLqlBszPwVD9Ye8s/8fZSRxcxHPgjnrw+nF9ctLW
         6rjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687854603; x=1690446603;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mThrgyARyedryNmjWfnH4cpZ5pepRN8cVLn3M8pGEJY=;
        b=RleM47fw8nVc2WN2FmRviRVtPmGB48gd0YCGHRf3r2ABCDG6q2jj2te8rnTnl79b7V
         dhLPNel8S+SBNruBTT2RHe1eQ+GX/ooODOWd50F80+/68C7VZiyRl6LZgob0ave291cp
         pek30EddZxekclBy82KDy4E7JH/Za6s7qJPTGVfIudsUAxwAUBycUwGvEPWBAg9YyDfI
         M5dBf8MYWytfvLNv9Paq2Ucy19QDKpXAm2SvT79xF2jCxo+elcCc7PblM3LvGAmi7mi2
         HAvMocFh51cIzD2Lgn+GlkpiHT0Q6Mn+9AYSklLH4JgtF77C9VHPv8msCNKmMZhK0nzu
         UI7w==
X-Gm-Message-State: AC+VfDwRFRoZhVO3Chq0ahatDKF94psdcDbsk+5BwkYUpItOAy7MEuJo
        f66hsiWPpAh1f/XQJqQLZGg3rQ==
X-Google-Smtp-Source: ACHHUZ5Gd8wXkVemQElq8PbfvR+hM+lFW1Yl6baf3RwARcEPbCvXGdlVnJBe7lQN8mKIJavn5lW7aw==
X-Received: by 2002:a17:907:983:b0:94e:2db:533e with SMTP id bf3-20020a170907098300b0094e02db533emr30833010ejc.49.1687854602813;
        Tue, 27 Jun 2023 01:30:02 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id pv18-20020a170907209200b0098dc18c1429sm4246134ejb.209.2023.06.27.01.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 01:30:02 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 27 Jun 2023 10:30:01 +0200
Message-Id: <CTNAIROO2XIU.3FFYTSQL4OIM7@otso>
Subject: Re: [PATCH v4 2/3] dt-bindings: ufs: qcom: Add reg-names property
 for ICE
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Iskren Chernev" <me@iskren.info>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Conor Dooley" <conor+dt@kernel.org>
Cc:     <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <phone-devel@vger.kernel.org>, "Eric Biggers" <ebiggers@google.com>
X-Mailer: aerc 0.15.1
References: <20221209-dt-binding-ufs-v4-0-14ced60f3d1b@fairphone.com>
 <20221209-dt-binding-ufs-v4-2-14ced60f3d1b@fairphone.com>
 <c0ce5ce7-d18f-15b9-176e-822d99c638e2@linaro.org>
In-Reply-To: <c0ce5ce7-d18f-15b9-176e-822d99c638e2@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon Jun 26, 2023 at 10:26 AM CEST, Krzysztof Kozlowski wrote:
> On 26/06/2023 10:15, Luca Weiss wrote:
> > The code in ufs-qcom-ice.c needs the ICE reg to be named "ice". Add thi=
s
> > in the bindings so the existing dts can validate successfully.
> >=20
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > Reviewed-by: Iskren Chernev <me@iskren.info>
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 20 +++++++++++++=
+++++++
> >  1 file changed, 20 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Docu=
mentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > index eb3de2fde6b0..b5fc686cb3a1 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > @@ -80,6 +80,10 @@ properties:
> >      minItems: 1
> >      maxItems: 2
> > =20
> > +  reg-names:
> > +    minItems: 1
> > +    maxItems: 2
> > +
> >    required-opps:
> >      maxItems: 1
> > =20
> > @@ -135,6 +139,8 @@ allOf:
> >          reg:
> >            minItems: 1
> >            maxItems: 1
> > +        reg-names:
> > +          maxItems: 1
>
> I see I reviewed, but I don't think the patch is correct. It allows any
> reg-names. I think my advice from v1 was not understood. The names
> should be defined in top-level.

Thanks for your review, I hope it's resolved in v5 of this series.
Please check :)

Regards
Luca

>
> Best regards,
> Krzysztof

