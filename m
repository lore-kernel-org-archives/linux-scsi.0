Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C924C4167B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 09:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiL3JRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 04:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiL3JRO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 04:17:14 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE651A396
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2022 01:17:13 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u9so50317913ejo.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2022 01:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUxMUm4HUy6Yckpe/AvN8V7dp0DoIgBNaECuK4JNG4g=;
        b=XZuGepdH0HvyeQp6+qogQgniYIwMd2yrV2MoB259RLtxcl+LaQrDk57NudMcv3S+oe
         1tjhN/A6WYcgR53N/A/4wC7GrmuD4xLvefxGXVloCno6dUuS8SOj+zQ6QGNI+lSdR1dp
         VK65cSs6ZcQ42Rz4bWn1/hLf2mBDnJmRushv6eJW+7cxUqJIzBd34LFqYQ38BGw5ZCD4
         2/naZU4jr4IxTLIDPveNllMDoqiy9RwuyccbfthasdCT5K8tm2ffF2xyx8mNGStKxYP0
         4wCV53zE+kmtd+vTjxDOnc9qdRfjnWdaq0mHPV3+rtO/FFrTXzgaBIDrB8h8BmbGRyTE
         M43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rUxMUm4HUy6Yckpe/AvN8V7dp0DoIgBNaECuK4JNG4g=;
        b=q6IaQg4Ev7OA5ciB+ezxPqsc/CX55JI+libJWkCAAnzve4b729T4Nn5ZW5yPQRnY4w
         to629Mom7sLtK9RhzBk6IVi4JA1NeySw85b2MscK0yXLCIArtnQcb8ma8dHBTIXlLqEg
         JEgWbfdKqpYxnpcOzCee7KO/ElV6NBJx6tdt4nY6a8/VEVAOi6xbLLQjW4QWBH7QDZPr
         ZwHP/VGWRk1hWDqTfDDKgh5dOUJTclO55Oqb6Kk52PxytwqCmWSePy5EBfu8b9E7FlIA
         hw1X3+VzFyPcvhyTidiODIK9uEoRNAGk0JQn9wrPorn4/TokmGgD8L4dStdOBi4Al9ce
         5d4A==
X-Gm-Message-State: AFqh2kpFHlupoUtQ5Ml6pjmaQBzV0kzqaWkwVZUagMIddKYn5PQjDsq3
        P7sYSgrsBMzngyT9kTAAJ08UkQ==
X-Google-Smtp-Source: AMrXdXsp62WNiKFzlGd4UGKMueL3KaZQLeoEbTjQJh6tTgDO4GAXYtGLBEIbpGWgbqjQzPqLhYkPJw==
X-Received: by 2002:a17:906:4483:b0:7fd:f028:50ff with SMTP id y3-20020a170906448300b007fdf02850ffmr25321524ejo.49.1672391832036;
        Fri, 30 Dec 2022 01:17:12 -0800 (PST)
Received: from localhost (2a02-8388-6582-fe80-0000-0000-0000-0007.cable.dynamic.v6.surfer.at. [2a02:8388:6582:fe80::7])
        by smtp.gmail.com with ESMTPSA id ky14-20020a170907778e00b007c4f8bc322asm9417498ejc.196.2022.12.30.01.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 01:17:11 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Dec 2022 10:17:11 +0100
Message-Id: <CPF1FCV59AIY.6YVGAUIENHA2@otso>
Subject: Re: [PATCH v2 1/3] arm64: dts: qcom: sm6115: Add missing reg-names
 property for UFS
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Iskren Chernev" <me@iskren.info>
Cc:     <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>,
        <phone-devel@vger.kernel.org>
X-Mailer: aerc 0.13.0
References: <20221209-dt-binding-ufs-v2-0-dc7a04699579@fairphone.com>
 <20221209-dt-binding-ufs-v2-1-dc7a04699579@fairphone.com>
 <61cb9bab-aefb-cd45-acb0-ef846a411d76@linaro.org>
In-Reply-To: <61cb9bab-aefb-cd45-acb0-ef846a411d76@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri Dec 30, 2022 at 10:12 AM CET, Konrad Dybcio wrote:
>
>
> On 30.12.2022 08:42, Luca Weiss wrote:
> > The UFS driver expects the second reg to be named "ice" otherwise the
> > Inline Crypto Engine won't get enabled.
> >=20
> > Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
> > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > ---
>
> https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=
=3Dfor-next&id=3D01b6041454e8bc4f5feb76e6bcdc83a48cea21f2

Oh, thanks!

Disregard this patch then please.

>
> Konrad
> >  arch/arm64/boot/dts/qcom/sm6115.dtsi | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts=
/qcom/sm6115.dtsi
> > index 572bf04adf90..85673d562723 100644
> > --- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
> > @@ -704,6 +704,7 @@ opp-202000000 {
> >  		ufs_mem_hc: ufs@4804000 {
> >  			compatible =3D "qcom,sm6115-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
> >  			reg =3D <0x04804000 0x3000>, <0x04810000 0x8000>;
> > +			reg-names =3D "std", "ice";
> >  			interrupts =3D <GIC_SPI 356 IRQ_TYPE_LEVEL_HIGH>;
> >  			phys =3D <&ufs_mem_phy_lanes>;
> >  			phy-names =3D "ufsphy";
> >=20

