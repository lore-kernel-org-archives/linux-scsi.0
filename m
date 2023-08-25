Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B2AEE49A6
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 06:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241996AbjHYGjJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 02:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242264AbjHYGiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 02:38:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBCD1FED
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:38:45 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-977e0fbd742so62502866b.2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 23:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1692945524; x=1693550324;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SSRgsqWGE/RACDHj1qc7eoiU1kp65t711DUZ8q0Mxk=;
        b=EoSOllFIEBw85fBVae2XuxA9YZCxndm5zMLl/wqeYioP+1+19xOWCLJglOyz+w/krA
         I27be0wi+BoWh19f/mogs6yGFshx3OjRm5z2LUxDpPtPwjpSuzj1iLmkv+ijhZ1sFCUO
         UnctSiLmJvpTW4DA1/PjLLNff7aKd19zpVFH2jE5xvPKiQ1a1uMfRp/7dKTesao2zhk/
         jHCnKbia4wPcJXTK92FPZNK0W7EQ29bvWzAIW3d4E6VoewulfEjU9Igasu6Hx73UJhM7
         xecUcuxlAiquFMhKwVlO1DGOzrbIOrC3v1B1mMIEelGwRYnglxTxdFwxT6OkAMkfe/mp
         d2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692945524; x=1693550324;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1SSRgsqWGE/RACDHj1qc7eoiU1kp65t711DUZ8q0Mxk=;
        b=EG1FeKQs/eFsGsd3hjoGARUZFjEJOh4ohfsuAOY8kkSEr7ziUL9LdNIUDGicB2Uhdd
         zCFlOxwp7bzhzCfXRTR+5pWm9Srr5c6IDXjcAguxtOaAmJgfLVNPAaprDAB+gnuc4MNI
         6DcLPrLuTohuROCv2BmkT7z5CGyNOMzmymA9S/qxb4uzyHCUkrToFa556azP52yYIHX6
         w8exl7BizJp7vzGguDR8oXVA5IPFO3cqsTymf9E1T3JDqohKTPjNPkAIMJbBKJgZpIVo
         sqOrmhFvtt95svCABnshBPGALhNi/8p4i/8wAY7dhDTO/nOkj5uXIP75rk6Nl3VZUNk4
         E0yg==
X-Gm-Message-State: AOJu0YzvqKnli4F/fIaUZzbJPOk8iOGpG7L47ArXU0UXFTr0AXcGRJYK
        NurTyglLPeFsQjPzsR8esBs88Q==
X-Google-Smtp-Source: AGHT+IGIN+a9Tsuplje7An/26N8i6OFoKx8k6Zzw0oy9lXO91uIOWqYbG5+7wH8oDVAfS7RB4mk50Q==
X-Received: by 2002:a17:907:78d8:b0:9a1:e941:6f48 with SMTP id kv24-20020a17090778d800b009a1e9416f48mr4943404ejc.13.1692945524404;
        Thu, 24 Aug 2023 23:38:44 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906805200b0097073f1ed84sm603963ejw.4.2023.08.24.23.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 23:38:44 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 25 Aug 2023 08:38:43 +0200
Message-Id: <CV1F3OVNEFMI.1DO4SX08EW23S@otso>
Cc:     "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Iskren Chernev" <me@iskren.info>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        "Conor Dooley" <conor+dt@kernel.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <phone-devel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Bhupesh Sharma" <bhupesh.sharma@linaro.org>,
        "Eric Biggers" <ebiggers@google.com>
Subject: Re: [PATCH v6 0/4] Fix some issues in QCOM UFS bindings
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Rob Herring" <robh@kernel.org>
X-Mailer: aerc 0.15.2
References: <20230814-dt-binding-ufs-v6-0-fd94845adeda@fairphone.com>
 <20230824171052.GA1037612-robh@kernel.org>
In-Reply-To: <20230824171052.GA1037612-robh@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu Aug 24, 2023 at 7:10 PM CEST, Rob Herring wrote:
> On Mon, Aug 14, 2023 at 12:14:12PM +0200, Luca Weiss wrote:
> > This series aims to solve the dtbs_check errors from the qcom ufs
> > bindings. It has changed in scope a bit since v1, so it may be a bit al=
l
> > over the place.
> >=20
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
> > Changes in v6:
> > - Rebase on linux-next
> > - Drop applied dts patch
> > - Pick up tags
> > - Link to v5: https://lore.kernel.org/r/20221209-dt-binding-ufs-v5-0-c9=
a58c0a53f5@fairphone.com
> >=20
> > Changes in v5:
> > - Convert sm8450.dtsi to use qcom,ice property, so stop modifying schem=
a
> >   for sm8450 and only add qcom,ice property.
> > - Move reg-names names to top-level with only minItems/maxItems in the
> >   'if'
> > - Link to v4: https://lore.kernel.org/r/20221209-dt-binding-ufs-v4-0-14=
ced60f3d1b@fairphone.com
> >=20
> > Changes in v4:
> > - Pick up tags
> > - Rebase on linux-next (again)
> > - Link to v3: https://lore.kernel.org/r/20221209-dt-binding-ufs-v3-0-49=
9dff23a03c@fairphone.com
> >=20
> > Changes in v3:
> > - Drop applied patch
> > - Pick up sm6115 patch from v5 https://lore.kernel.org/all/202210300942=
58.486428-2-iskren.chernev@gmail.com/
> > - Rebase on linux-next
> > - Link to v2: https://lore.kernel.org/r/20221209-dt-binding-ufs-v2-0-dc=
7a04699579@fairphone.com
> >=20
> > Changes in v2:
> > - Add new patch adding reg-names to sm6115 & rebase series on top of sm=
6115
> >   addition
> > - Fix binding example after sm8450 move, split this patch from original=
 patch
> >   since it became too big
> > - Move reg-names definition to top-level
> > - Link to v1: https://lore.kernel.org/r/20221209-dt-binding-ufs-v1-0-8d=
502f0e18d5@fairphone.com
> >=20
> > ---
> > Iskren Chernev (1):
> >       dt-bindings: ufs: qcom: Add sm6115 binding
> >=20
> > Luca Weiss (3):
> >       dt-bindings: ufs: qcom: Add reg-names property for ICE
> >       dt-bindings: ufs: qcom: Add ICE to sm8450 example
> >       dt-bindings: crypto: ice: Document sm8450 inline crypto engine
> >=20
> >  .../bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
> >  .../devicetree/bindings/ufs/qcom,ufs.yaml          | 44 ++++++++++++++=
++++++++
> >  2 files changed, 45 insertions(+)
>
> I guess the subsystem maintainers aren't going to pick this up, so I've=
=20
> applied it.

Thanks Rob, appreciate it!

>
> Rob

