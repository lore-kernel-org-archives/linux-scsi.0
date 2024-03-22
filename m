Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF4A18E12
	for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 07:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711094358; cv=none; b=lviV1/KqxgaJCF4P2HrxGZJNy0Wy5z2ypDezOkQ41mGJC0coPYSMEUDqcRZy2SW0o6dr/f5g4MTNSkM8SHce5oo6EktqFN6nHXyH7aY8nmzv6ikRQasgnRIiMSYJryrsKsTruTPHYBi4DJoRMvN+ooPSBl/i9/F6s/W+18X7sME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711094358; c=relaxed/simple;
	bh=8oNeA1R+uaPm6qmNmNCiQoHzDfg9lMR1N0jwijC+qtM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kGnW356JInP5IzGCxtdBOPQ/l5OWgKol9Wv2xo/B1VXlHZJ9+MJ0FyHTaIrIJfpr5NdTVEBMkKWXyWZAXn5txqxPflMMQ+s6+lPc97bmpQDV6VQYR09Z49njoaSf4105Sbe6jgbZX3kDoweHkw7dcdeYfxpjK8sxscOyxDTWOcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=DpqNeicN; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="DpqNeicN"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a4734ae95b3so18151966b.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 00:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1711094355; x=1711699155; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS7w40gQLpj4JwebvWp26JX7Uxo13WZZkGHnC6K49Ow=;
        b=DpqNeicN6x0yz0BWdbxBsr27s38PDKt92ZWdfruIg5sdJ+jYtiWJSzx9mDcmSuZqj4
         HH66YTl5FiEyuu+ay/nr1X+dFe4NPlCnqUhCrezmrsG968m+Vrs9NcNCQvsAuyhi2+La
         4quvFAZoifWwlJ5cWOjPuOHCU0rckcUg4OlSuK1TwOSX9qvcuXwO4dpWVTXhIGMisQYj
         xVwBIUrMWSwqvmaUm35EVvrSlvTzMjYp+wBEAS4q1USANa2u8+l8XWAB90h2A1Aggv1M
         +NrUEcMExrtGRLJ6GOaSIWaaVHhNGN2PEdEiukYkFWbPIpnX5PBrhi1PA4Vi4kJyEKZD
         JICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711094355; x=1711699155;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KS7w40gQLpj4JwebvWp26JX7Uxo13WZZkGHnC6K49Ow=;
        b=OAEK/0TuLGIC1yc6yIVz14czjLraRjdrt3UCLWHSzd3y4U6hRnQkssRH2WmLQFrZEl
         RF9l47nj04RD7fDlEPBCxKzZPjuXp0r4mmyy4Un5rLt78uquknBui0SAwO+PmZoqcIFq
         7hXijUjLF9sDcQVnAt+E1MaadhUwfA71UnYwRl0+bqytkE7Wef+f3AVp/adpN8m7314X
         enUcNx+wM7UKfoIVMgTgLt3otV52a25CJFar+abt/8tbx6UzDN3LlRkQSPq3f2a6++AM
         rj6GsqzsFMIVXqsP2hxxHGaRu7Ntf7c4pFGnc1N22hvg3mS1fJTKoOEMt1GTclWxDI4q
         8Vzw==
X-Forwarded-Encrypted: i=1; AJvYcCVzrtm80usGad/n8B6s0dKPUeSt7wfy4kqYBK7EIUC4eg5KrCkRNsjc/+qbvI5eElGeaw+w88pG3FtezUTUmBujlTiLoH0xLySD8A==
X-Gm-Message-State: AOJu0YxQmOQnECIBbUHHmSlcV8EmUZEIKI6bhW9miPL7IaTBZq0ClETO
	3298pJoumeEZ6/Ho6FKyKDXuo4aMwFkEnWzOvcKMo3BkgSsOhYe3zG85g3o0/DU=
X-Google-Smtp-Source: AGHT+IFscmFzR59tvnQPVG1KyfSwq3bup2AKubi8RDQJUccob6bzs5EDHOm1AZDCss3DP/15OGmO1Q==
X-Received: by 2002:a17:907:a4e:b0:a46:ac55:8e69 with SMTP id be14-20020a1709070a4e00b00a46ac558e69mr1453125ejc.14.1711094354759;
        Fri, 22 Mar 2024 00:59:14 -0700 (PDT)
Received: from localhost (046125249120.public.t-mobile.at. [46.125.249.120])
        by smtp.gmail.com with ESMTPSA id f13-20020a1709067f8d00b00a46a4a14555sm737912ejr.86.2024.03.22.00.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 00:59:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Mar 2024 08:59:12 +0100
Message-Id: <D004BPW9N0FS.376F67CINO459@fairphone.com>
Cc: "Nitin Rawat" <quic_nitirawa@quicinc.com>, "Andy Gross"
 <agross@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konrad.dybcio@linaro.org>, "Alim Akhtar"
 <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>, "Bart Van
 Assche" <bvanassche@acm.org>, "Rob Herring" <robh+dt@kernel.org>,
 "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>, "Conor Dooley"
 <conor+dt@kernel.org>, <cros-qcom-dts-watchers@chromium.org>,
 <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] arm64: dts: qcom: sc7280: Add UFS nodes for
 sc7280 soc
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Manivannan Sadhasivam" <mani@kernel.org>
X-Mailer: aerc 0.15.2
References: <20231204-sc7280-ufs-v5-0-926ceed550da@fairphone.com>
 <20231204-sc7280-ufs-v5-2-926ceed550da@fairphone.com>
 <621388b9-dcee-4af2-9763-e5d623d722b7@quicinc.com>
 <CXFJNBNKTRHH.2CS6TO2MEGJWL@fairphone.com>
 <20231204172829.GA69580@thinkpad>
In-Reply-To: <20231204172829.GA69580@thinkpad>

On Mon Dec 4, 2023 at 6:28 PM CET, Manivannan Sadhasivam wrote:
> On Mon, Dec 04, 2023 at 01:21:42PM +0100, Luca Weiss wrote:
> > On Mon Dec 4, 2023 at 1:15 PM CET, Nitin Rawat wrote:
> > >
> > >
> > > On 12/4/2023 3:54 PM, Luca Weiss wrote:
> > > > From: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > >=20
> > > > Add UFS host controller and PHY nodes for sc7280 soc.
> > > >=20
> > > > Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > > Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> > > > Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org> # QCM6490 FP5
> > > > [luca: various cleanups and additions as written in the cover lette=
r]
> > > > Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> > > > ---
> > > >   arch/arm64/boot/dts/qcom/sc7280.dtsi | 74 +++++++++++++++++++++++=
++++++++++++-
> > > >   1 file changed, 73 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot=
/dts/qcom/sc7280.dtsi
> > > > index 04bf85b0399a..8b08569f2191 100644
> > > > --- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
> > > > +++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> > > > @@ -15,6 +15,7 @@
> > > >   #include <dt-bindings/dma/qcom-gpi.h>
> > > >   #include <dt-bindings/firmware/qcom,scm.h>
> > > >   #include <dt-bindings/gpio/gpio.h>
> > > > +#include <dt-bindings/interconnect/qcom,icc.h>
> > > >   #include <dt-bindings/interconnect/qcom,osm-l3.h>
> > > >   #include <dt-bindings/interconnect/qcom,sc7280.h>
> > > >   #include <dt-bindings/interrupt-controller/arm-gic.h>
> > > > @@ -906,7 +907,7 @@ gcc: clock-controller@100000 {
> > > >   			clocks =3D <&rpmhcc RPMH_CXO_CLK>,
> > > >   				 <&rpmhcc RPMH_CXO_CLK_A>, <&sleep_clk>,
> > > >   				 <0>, <&pcie1_phy>,
> > > > -				 <0>, <0>, <0>,
> > > > +				 <&ufs_mem_phy 0>, <&ufs_mem_phy 1>, <&ufs_mem_phy 2>,
> > > >   				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>;
> > > >   			clock-names =3D "bi_tcxo", "bi_tcxo_ao", "sleep_clk",
> > > >   				      "pcie_0_pipe_clk", "pcie_1_pipe_clk",
> > > > @@ -2238,6 +2239,77 @@ pcie1_phy: phy@1c0e000 {
> > > >   			status =3D "disabled";
> > > >   		};
> > > >  =20
> > > > +		ufs_mem_hc: ufs@1d84000 {
> > > > +			compatible =3D "qcom,sc7280-ufshc", "qcom,ufshc",
> > > > +				     "jedec,ufs-2.0";
> > > > +			reg =3D <0x0 0x01d84000 0x0 0x3000>;
> > > > +			interrupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> > > > +			phys =3D <&ufs_mem_phy>;
> > > > +			phy-names =3D "ufsphy";
> > > > +			lanes-per-direction =3D <2>;
> > > > +			#reset-cells =3D <1>;
> > > > +			resets =3D <&gcc GCC_UFS_PHY_BCR>;
> > > > +			reset-names =3D "rst";
> > > > +
> > > > +			power-domains =3D <&gcc GCC_UFS_PHY_GDSC>;
> > > > +			required-opps =3D <&rpmhpd_opp_nom>;
> > > > +
> > > > +			iommus =3D <&apps_smmu 0x80 0x0>;
> > > > +			dma-coherent;
> > > > +
> > > > +			interconnects =3D <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWA=
YS
> > > > +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> > > > +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> > > > +					 &cnoc2 SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
> > > > +			interconnect-names =3D "ufs-ddr", "cpu-ufs";
> > > > +
> > > > +			clocks =3D <&gcc GCC_UFS_PHY_AXI_CLK>,
> > > > +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> > > > +				 <&rpmhcc RPMH_CXO_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
> > > > +			clock-names =3D "core_clk",
> > > > +				      "bus_aggr_clk",
> > > > +				      "iface_clk",
> > > > +				      "core_clk_unipro",
> > > > +				      "ref_clk",
> > > > +				      "tx_lane0_sync_clk",
> > > > +				      "rx_lane0_sync_clk",
> > > > +				      "rx_lane1_sync_clk";
> > > > +			freq-table-hz =3D
> > > > +				<75000000 300000000>,
> > > > +				<0 0>,
> > > > +				<0 0>,
> > > > +				<75000000 300000000>,
> > > > +				<0 0>,
> > > > +				<0 0>,
> > > > +				<0 0>,
> > > > +				<0 0>;
> > > > +			status =3D "disabled";
> > > > +		};
> > > > +
> > > > +		ufs_mem_phy: phy@1d87000 {
> > > > +			compatible =3D "qcom,sc7280-qmp-ufs-phy";
> > > > +			reg =3D <0x0 0x01d87000 0x0 0xe00>;
> > > > +			clocks =3D <&rpmhcc RPMH_CXO_CLK>,
> > > > +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> > > > +				 <&gcc GCC_UFS_1_CLKREF_EN>;
> > > > +			clock-names =3D "ref", "ref_aux", "qref";
> > > > +
> > > > +			power-domains =3D <&gcc GCC_UFS_PHY_GDSC>;
> >=20
> > Hi Nitin,
> >=20
> > >
> > > GCC_UFS_PHY_GDSC is UFS controller GDSC. For sc7280 Phy we don't need=
 this.
> >=20
> > In the current dt-bindings the power-domains property is required.
> >=20
> > Is there another power-domain for the PHY to use, or do we need to
> > adjust the bindings to not require power-domains property for ufs phy o=
n
> > sc7280?
> >=20
>
> PHYs are backed by MX power domain. So you should use that.
>
> > Also, with "PHY" in the name, it's interesting that this is not for the
> > phy ;)
> >=20
>
> Yes, confusing indeed. But the controllers (PCIe, UFS, USB etc...) are ba=
cked by
> GDSCs and all the analog components (PHYs) belong to MX domain since it i=
s kind
> of always ON.
>
> I'll submit a series to fix this for the rest of the SoCs.

Hi Mani,

Did you get around to sending such series?

This would also fix some binding warnings, e.g. on SM6350.

  arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dtb: phy@1d87000: 'power-do=
mains' is a required property
          from schema $id: http://devicetree.org/schemas/phy/qcom,sc8280xp-=
qmp-ufs-phy.yaml#

Regards
Luca


>
> - Mani
>
> > Regards
> > Luca
> >=20
> > >
> > > > +
> > > > +			resets =3D <&ufs_mem_hc 0>;
> > > > +			reset-names =3D "ufsphy";
> > > > +
> > > > +			#clock-cells =3D <1>;
> > > > +			#phy-cells =3D <0>;
> > > > +
> > > > +			status =3D "disabled";
> > > > +		};
> > > > +
> > > >   		ipa: ipa@1e40000 {
> > > >   			compatible =3D "qcom,sc7280-ipa";
> > > >  =20
> > > >=20
> >=20

