Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38109EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 10:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjF0KKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 06:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjF0KJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 06:09:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC16359E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 03:07:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so6160421a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 03:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687860447; x=1690452447;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/bshRujrEsiLO7ti1ugHaJ7JTv6arLWxo0bLpM2w8E=;
        b=BesOb6HZEjpAtSY1iORrnvTv/Y2oCzoYf/xvnZdD/YRTXO9z4DC9m3fy44+aMAYaze
         f7L8eGLl6wQuJqL3v64fOn/s9VoB6Riq/c3kFZkjI7SBcnXUrL1IlaLriO93ICllvcfn
         xZN0KowdyjE/vPHCANP/4susBvzYrUgomBomRxDOl+EqrpgNiOe2z6Al4va9fYFSYcGk
         RFqkNYP2cezOjdfhsYMQlhv77w+/w6WZ5409y8mbUr1t/MEisNM4/oxYgX8DTZHRSVyf
         gnuzt1Id17pqV/Q1wJPvczJ/Kf3muZWaCQsiUzwH4sQcTcxkTD3bSVqCpjrhTxAYnZC8
         X5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687860447; x=1690452447;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H/bshRujrEsiLO7ti1ugHaJ7JTv6arLWxo0bLpM2w8E=;
        b=TvoGPqxWcSircdZvAosQDfXoZuQ4m10Gspc6osghk/TYwRo8jwjDc5gBNf7/Is9kpF
         hD+JTfj+QZ+KQtJRIGfYcbLeqpkDLesnmtpwq7SIGrGvChnJHEesLPqHKFBsTbnU9uYl
         Us6BNB4/sLuXqPUQwCgSBFisg3XyZ5L6A7JZpe9gc5AScw3Ih1kuSC8vIqx0aV0fJsHh
         jCd6NE+qX19vKXgMTTDGDBfP2TTbHIL9BfQ+twCb0oZ44KRGJqXpkXx1WCLkd5ZNC/+V
         WTRz4qcAzWloQjwwwH3J/j1hlgXZWFl/IagWGh0TJGOjg0Y+CprvFgYQl7ewgD1XfzAF
         cSyQ==
X-Gm-Message-State: AC+VfDzonluy4FEBIQBKlRSuvnt28Joyur++tBJcgjeUFLFZX4Lku/LS
        t/CiNMW8VOGexolnETHFC6d3Kg==
X-Google-Smtp-Source: ACHHUZ61byw/tAEZGzgU9K68oQmUy/igsn/JcYD9BHF10QFWuqe3r1Hj/ux1ur8aNyR90b7K3QfcJw==
X-Received: by 2002:a05:6402:2547:b0:51b:cd0f:562 with SMTP id l7-20020a056402254700b0051bcd0f0562mr19659710edb.4.1687860447612;
        Tue, 27 Jun 2023 03:07:27 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id s5-20020aa7d785000000b0051da1258377sm1321182edq.68.2023.06.27.03.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 03:07:27 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 27 Jun 2023 12:07:26 +0200
Message-Id: <CTNCLCWEUWJO.19I1NW2GL7QMZ@otso>
Cc:     "Conor Dooley" <conor+dt@kernel.org>,
        "Andy Gross" <agross@kernel.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        <devicetree@vger.kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Iskren Chernev" <me@iskren.info>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Avri Altman" <avri.altman@wdc.com>, <linux-scsi@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <linux-arm-msm@vger.kernel.org>, <phone-devel@vger.kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Bart Van Assche" <bvanassche@acm.org>
Subject: Re: [PATCH v5 3/5] dt-bindings: ufs: qcom: Add ICE to sm8450
 example
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Rob Herring" <robh@kernel.org>
X-Mailer: aerc 0.15.1
References: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
 <20221209-dt-binding-ufs-v5-3-c9a58c0a53f5@fairphone.com>
 <168785971145.1233664.7985274899454909326.robh@kernel.org>
In-Reply-To: <168785971145.1233664.7985274899454909326.robh@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue Jun 27, 2023 at 11:55 AM CEST, Rob Herring wrote:
>
> On Tue, 27 Jun 2023 10:28:03 +0200, Luca Weiss wrote:
> > SM8450 actually supports ICE (Inline Crypto Engine) so adjust the
> > example to match.
> >=20
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
>
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>
> yamllint warnings/errors:
>
> dtschema/dtc warnings/errors:
> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/u=
fs/qcom,ufs.example.dtb: ufs@1d84000: Unevaluated properties are not allowe=
d ('qcom,ice' was unexpected)
> 	from schema $id: http://devicetree.org/schemas/ufs/qcom,ufs.yaml#

qcom,ice should land with v5.4

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/=
?id=3D29a6d1215b7cd5fdff9c3c31ea26076a694ee0a3

And as mentioned in the cover letter, validation will still fail with
without the extra patch linked there (which is not in -next yet).

Regards
Luca

>
> doc reference errors (make refcheckdocs):
>
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/202212=
09-dt-binding-ufs-v5-3-c9a58c0a53f5@fairphone.com
>
> The base for the series is generally the latest rc1. A different dependen=
cy
> should be noted in *this* patch.
>
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>
> pip3 install dtschema --upgrade
>
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your sch=
ema.

