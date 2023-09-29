Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC23DE743FE
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 09:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjI2JBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjI2JBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 05:01:10 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948DE11F
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 02:01:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99bdcade7fbso1772173266b.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 02:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1695978061; x=1696582861; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCib+YEJ6+7KaH85hc8Nb8MnFh17rpSkk5Oe5+3Arrc=;
        b=AUTSRteTyo95zFGGVfWFGl3v8vYxH4Nrnn738GzkQogs6CJJyrteC1PupHgsY9Yb62
         7WnGA8wfXdvUL6Xa/D1MStfhsB17K/BU32odY0TQvY4q5pEqjqPyOocyoQYrLoDtaakv
         yHkDccJ6GM1zsAmBEHQ1s9wzyWCXisEvcs4+DGFL1Le9WEV6nix+rcvQEd1UlpBzcdlp
         auPSSM+j9hXKvMPVt9WiY6sgN20r3qn6fVj3m9HTLLxo3aXH1FOpSCfy1QkyRGgiS+PA
         or9zXUg/RNB2j/hiI3YgQd+e0SnoEkRRoITO0KzhuUkBQ5VR3OE48tOop7QCujYpYBJN
         0DQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695978061; x=1696582861;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jCib+YEJ6+7KaH85hc8Nb8MnFh17rpSkk5Oe5+3Arrc=;
        b=VVtDvz397fXU1YkK/iq4263ZbjUljuEQORWBuP+SKRB49QDEokVKRdkLM6pENK79/v
         zzckvSJ38cil0mw7FDiIC92/8Zc77pF3snsG/TbSm0+YgT1ooM1KQhykhZW67V3H2PJr
         pF6H6JcQmwR3WiLOsKg9fJDyI297KNPc6OKyGztIk+3rEo2xYtwkjtjfmDNK0tC31jAM
         UQrYLuKz9EbYUqj16AXuKWoOTXlWQzmnsjrwrsNE7UtK2XyFxp8QdC6bJeBtK+caeUKe
         mdwHB6KE8eW5Izd9c0QWwcAC+SeON8iDioc0zBoSt4tuBHVLUF3b37Le6rq4QuIAthy3
         RNHQ==
X-Gm-Message-State: AOJu0Yw8Pcg5YkLc+hqTMLpQjNGxYHMdTV0SZ+pxhN9JCsnljVwrEN2X
        KRwGu1p9J6LNMU8FyyMHAWufrQ==
X-Google-Smtp-Source: AGHT+IF8LpBwznH+qjY6BeKJwXeYUOfJ8dYEkZ+qseK8NDxlpDW8TzadUKBD4uecOioziiIYg5ZmsA==
X-Received: by 2002:a17:906:3050:b0:9ae:65a5:b6f4 with SMTP id d16-20020a170906305000b009ae65a5b6f4mr3370291ejd.20.1695978060936;
        Fri, 29 Sep 2023 02:01:00 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id bl19-20020a170906c25300b0099bc8db97bcsm12087256ejb.131.2023.09.29.02.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 02:01:00 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 29 Sep 2023 11:01:00 +0200
Message-Id: <CVVA1OVF4W9E.380D6QC1K9GD6@otso>
Cc:     <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] arm64: dts: qcom: sc7280: Add UFS nodes for
 sc7280 soc
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Nitin Rawat" <quic_nitirawa@quicinc.com>, <agross@kernel.org>,
        <andersson@kernel.org>, <konrad.dybcio@linaro.org>,
        <mani@kernel.org>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
        <cros-qcom-dts-watchers@chromium.org>
X-Mailer: aerc 0.15.2
References: <20230927081858.15961-1-quic_nitirawa@quicinc.com>
 <20230927081858.15961-3-quic_nitirawa@quicinc.com>
In-Reply-To: <20230927081858.15961-3-quic_nitirawa@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Nitin,

On Wed Sep 27, 2023 at 10:18 AM CEST, Nitin Rawat wrote:
> Add UFS host controller and PHY nodes for sc7280 soc.
>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sc7280.dtsi | 63 ++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/q=
com/sc7280.dtsi
> index 66f1eb83cca7..0b50b8557311 100644
> --- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
> @@ -3353,6 +3353,69 @@
>  			};
>  		};

I think above you should also have this diff:

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -868,11 +868,11 @@ gcc: clock-controller@100000 {
 			compatible =3D "qcom,gcc-sc7280";
 			reg =3D <0 0x00100000 0 0x1f0000>;
 			clocks =3D <&rpmhcc RPMH_CXO_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK_A>, <&sleep_clk>,
 				 <0>, <&pcie1_lane>,
-				 <0>, <0>, <0>, <0>;
+				 <&ufs_mem_phy 0>, <&ufs_mem_phy 1>, <&ufs_mem_phy 2>, <0>;
 			clock-names =3D "bi_tcxo", "bi_tcxo_ao", "sleep_clk",
 				      "pcie_0_pipe_clk", "pcie_1_pipe_clk",
 				      "ufs_phy_rx_symbol_0_clk", "ufs_phy_rx_symbol_1_clk",
 				      "ufs_phy_tx_symbol_0_clk",
 				      "usb3_phy_wrapper_gcc_usb30_pipe_clk";

>
> +		ufs_mem_hc: ufs@1d84000 {
> +			compatible =3D "qcom,sc7280-ufshc", "qcom,ufshc",
> +				     "jedec,ufs-2.0";
> +			reg =3D <0x0 0x01d84000 0x0 0x3000>;
> +			interrupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> +			phys =3D <&ufs_mem_phy>;
> +			phy-names =3D "ufsphy";
> +			lanes-per-direction =3D <2>;
> +			#reset-cells =3D <1>;
> +			resets =3D <&gcc GCC_UFS_PHY_BCR>;
> +			reset-names =3D "rst";
> +
> +			power-domains =3D <&gcc GCC_UFS_PHY_GDSC>;
> +			required-opps =3D <&rpmhpd_opp_nom>;
> +
> +			iommus =3D <&apps_smmu 0x80 0x0>;
> +			dma-coherent;
> +
> +			clocks =3D <&gcc GCC_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> +				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> +				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
> +				 <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
> +				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
> +			clock-names =3D "core_clk",
> +				      "bus_aggr_clk",
> +				      "iface_clk",
> +				      "core_clk_unipro",
> +				      "ref_clk",
> +				      "tx_lane0_sync_clk",
> +				      "rx_lane0_sync_clk",
> +				      "rx_lane1_sync_clk";
> +			freq-table-hz =3D
> +				<75000000 300000000>,
> +				<0 0>,
> +				<0 0>,
> +				<75000000 300000000>,
> +				<0 0>,
> +				<0 0>,
> +				<0 0>,
> +				<0 0>;
> +			status =3D "disabled";
> +		};
> +
> +		ufs_mem_phy: phy@1d87000 {
> +			compatible =3D "qcom,sc7280-qmp-ufs-phy";
> +			reg =3D <0x0 0x01d87000 0x0 0xe00>;
> +			clocks =3D <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 <&gcc GCC_UFS_1_CLKREF_EN>;
> +			clock-names =3D "ref", "ref_aux", "qref";
> +
> +			resets =3D <&ufs_mem_hc 0>;
> +			reset-names =3D "ufsphy";
> +
> +			#clock-cells =3D <1>;
> +			#phy-cells =3D <0>;
> +
> +			status =3D "disabled";
> +		};

Would you mind adding something like the following at the same time?

+		ice: crypto@1d88000 {
+			compatible =3D "qcom,sc7280-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg =3D <0 0x01d88000 0 0x8000>;
+			clocks =3D <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};


And then link it to the ufs_mem_hc node with qcom,ice =3D <&ice>; ?

Or add it in a followup patch, also fine with me.

Other than that, looks pretty similar to the nodes that I have in my own
tree which work fine for the most part.

Regards
Luca

> +
>  		usb_1_hsphy: phy@88e3000 {
>  			compatible =3D "qcom,sc7280-usb-hs-phy",
>  				     "qcom,usb-snps-hs-7nm-phy";
> --
> 2.17.1

