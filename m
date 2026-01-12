Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF73343D6F
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768207508; cv=none; b=S6je47GEgEDazeWwruPrfl2hjoiMI3lqw4MSNl27wJzno4X5qkggwlSUvtjJBLfuwG5f+YtM6KBhpV0R61g5rc6kNubZel5dWBg3JhSWfDElJ6sSMgj/2Wu6LcM9GL2+FYl04vw4x/w3yTvsPbfajIo+rqoD1itSsgtC4Atlh0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768207508; c=relaxed/simple;
	bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=pLPqRTRnTAuJn4m4223/W6DTuCsVhiH9VcCIWf7dUDd84JuASMsGSuLBqu/ScZFAZA7h3RXDW50ZmyAP6T5aiSqtFEZxq8hhrm8IAGsRPfO6xHPqtUhiDUGRF/EWvN4qKVf52+kP2SaqDz1HHkReyhX1BruCtjRxR5/Ph2belVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=IVDV/ohy; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="IVDV/ohy"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b870cbd1e52so141813366b.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768207502; x=1768812302; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
        b=IVDV/ohytU0ay9yHJck6OOYUe8a5wpddekOQJo+U5YWT2V7t/wB/w1wM+T359sNeAS
         /erSG0qpj9K6RgDKVMgo+wIkKDGzISr5/G5/A1XAIS0n5zVJNFSkEhdMlSm5jwr0G23T
         Z/3ndWqyQF3fF6xiTHEUIF9zY3+b8hCEWF2Z7FUzH4GE7XXao6fOeF5bfbW8f4rb2oNr
         9hfFfRB44rZHT7HPM9Kh+dbt6P2gRJh3Vta9wqwutcA+LKnkqhGClFiP0oK5Vo/st/WC
         S0qaDsP4HZja8WEof5/2gfZz3eR6KLMF+kNBsJts+8HlHPEA0rg+4ZiXwHqFbfu0hZCC
         S2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207502; x=1768812302;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zG33qFZy8JznR/XKQTux3df5oiRWiq1GjUuErjUR0fA=;
        b=UBFJSFJoq2yOxHzzMpJbdGSFzQPSL9XMrng9tKJVkf8slHLIjTEZ4rH+1ZuZja2zug
         e7aB4x1Q+fHpyh2z5piEMONTvdamWWmJwOAs5i11MelcGWRCJQY3dUdjXoc2yoLTl9KW
         ey8oPZmngr0li8Vaix8+ubpbQGlOYa4VflTOUQf/BMPa7E0yE+DUtkW1tG4fQrHvMbVR
         NymXp3etDtIW4DCV7KM6q4n8YcSbEQtIitc4BI2QtHHTxhuKsJynji9HJbxh3wlWbM93
         nXGDHFnLzQAj411AUwQh+AYpAGy4ifRnBmwK7A8mPwL33cu8AKnp6DVKYwXMuGdx3tkQ
         hbnA==
X-Forwarded-Encrypted: i=1; AJvYcCUjKhIf9Aicmwxl0352i5jBPc0+/VWQFVy8KSiN1xZeZXrBCbSEZefCNK4vntQCV3Y3wnoigZMFohQV@vger.kernel.org
X-Gm-Message-State: AOJu0YzA9l0/W9JOcLR0U8H2+faIs3uVvOi6/jcQvxb/9W/pe4NCAq2k
	c2ArZnxDybWjFT9/JX1VyFI3jtjRL2gxyBtF9ymoIaJz/hHkryvA1gMUhvt2pmZtU6Y=
X-Gm-Gg: AY/fxX7oqVC0No3s5hqiN9RcdfKqtGrBEJroD6fC8fukZAMtOsx5m+Hnk6VT5SQqAK/
	mJaxd8EetkUe23zQBWfVQnjUtmq1I/mmbHWfgdI4QSCatyJSQ417qDOD55w/1Z5zZD3apr28KaH
	7VGzRsUP/pUDkjY4dDpCaXDZ1dzCo7qqcvDeE5LwvgGumCQ63gMqGRBK5H69AE+eSc09cWlSoOI
	dp99VLdl2gqP07p0BfL8FHUjOShQqjD2FMBp0KVjOq/2FAicIoPUTiOsQYkZBDuJRF+aQK4DWdx
	5cLkjEg/XBSu1Gspa87kz6YdRsN9qNKYLQwRUSr4AEG0FFZ0weW6j2WW1eGFE/WI/GhF3EFL9+4
	ARSGDl37O8AkrDdXzFQwPpVX3+dQ/elaYgTaqvyBdmiLG3JVsSX8KbLzzZ4hoVChxmVvo9Zi4Bu
	g+ag2Cbp54rKev3KTQ7LDdUblQd38v37a9AMNUO4QJ70dV/05y8hPmTjLQ
X-Google-Smtp-Source: AGHT+IGkp8lDjqeILjtMZ5LR+GI7r23/qVs+xlIeG79Zdksfi1ggdUWAo2X+W6SgmX5SlFgujBUWTQ==
X-Received: by 2002:a17:907:1c25:b0:b7b:e754:b5ba with SMTP id a640c23a62f3a-b8445033422mr1833442366b.56.1768207502041;
        Mon, 12 Jan 2026 00:45:02 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a5187afsm1834263166b.58.2026.01.12.00.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:45:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Jan 2026 09:45:01 +0100
Message-Id: <DFMH8W40TCJ0.XCTHNRJFJE4T@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Neil Armstrong" <neil.armstrong@linaro.org>, "Luca Weiss"
 <luca.weiss@fairphone.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley"
 <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>,
 "Bart Van Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <2486dc4b-71f3-4cd9-8139-b397407d7e4d@linaro.org>
 <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>
In-Reply-To: <543d9e55-c858-40f9-8785-c9f636850120@linaro.org>

Hi Neil,

On Mon Jan 12, 2026 at 9:26 AM CET, Neil Armstrong wrote:
> On 1/7/26 14:53, Neil Armstrong wrote:
>> Hi,
>>=20
>> On 1/7/26 09:05, Luca Weiss wrote:
>>> Add the nodes for the UFS PHY and UFS host controller, along with the
>>> ICE used for UFS.
>>>
>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>> ---
>>> =C2=A0 arch/arm64/boot/dts/qcom/milos.dtsi | 127 ++++++++++++++++++++++=
+++++++++++++-
>>> =C2=A0 1 file changed, 124 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/milos.dtsi b/arch/arm64/boot/dts/=
qcom/milos.dtsi
>>> index e1a51d43943f..0f69deabb60c 100644
>>> --- a/arch/arm64/boot/dts/qcom/milos.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/milos.dtsi
>>> @@ -797,9 +797,9 @@ gcc: clock-controller@100000 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&sleep_clk>,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* pcie_0_pipe_clk */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* pcie_1_pipe_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_rx_symbol_0_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_rx_symbol_1_clk */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>, /* ufs_phy_tx_symbol_0_clk */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 0>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 1>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&ufs_mem_phy 2>,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <0>; /* usb3_phy_wrapper_gcc_usb30_=
pipe_clk */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 #clock-cells =3D <1>;
>>> @@ -1151,6 +1151,127 @@ aggre2_noc: interconnect@1700000 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 qcom,bcm-voters =3D <&apps_bcm_voter>;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_mem_phy: phy@1d80000 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 com=
patible =3D "qcom,milos-qmp-ufs-phy";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg=
 =3D <0x0 0x01d80000 0x0 0x2000>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
cks =3D <&rpmhcc RPMH_CXO_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&tcsr TCSR_UFS_CLKREF_EN>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
ck-names =3D "ref",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "ref_aux",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "qref";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
ets =3D <&ufs_mem_hc 0>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
et-names =3D "ufsphy";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pow=
er-domains =3D <&gcc UFS_MEM_PHY_GDSC>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #cl=
ock-cells =3D <1>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 #ph=
y-cells =3D <0>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sta=
tus =3D "disabled";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 };
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_mem_hc: ufshc@1d84000 {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 com=
patible =3D "qcom,milos-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reg=
 =3D <0x0 0x01d84000 0x0 0x3000>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
errupts =3D <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH 0>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
cks =3D <&gcc GCC_UFS_PHY_AXI_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_AHB_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&tcsr TCSR_UFS_PAD_CLKREF_EN>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clo=
ck-names =3D "core_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "bus_aggr_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "iface_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "core_clk_unipro"=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "ref_clk",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tx_lane0_sync_cl=
k",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "rx_lane0_sync_cl=
k",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "rx_lane1_sync_cl=
k";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
ets =3D <&gcc GCC_UFS_PHY_BCR>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res=
et-names =3D "rst";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
erconnects =3D <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &mc_virt SLAVE_EBI1 QCO=
M_ICC_TAG_ALWAYS>,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <&gem_noc MASTER_APPSS_PROC Q=
COM_ICC_TAG_ACTIVE_ONLY
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cnoc_cfg SLAVE_UFS_MEM=
_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=
erconnect-names =3D "ufs-ddr",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 "cpu-ufs";
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pow=
er-domains =3D <&gcc UFS_PHY_GDSC>;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req=
uired-opps =3D <&rpmhpd_opp_nom>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ope=
rating-points-v2 =3D <&ufs_opp_table>;
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iom=
mus =3D <&apps_smmu 0x60 0>;
>>=20
>> dma-coherent ?


Given that downstream volcano.dtsi has dma-coherent in the ufshc@1d84000
node, looks like this is missing in my patch.

>>=20
>> and no MCQ support ?

Not sure, I could only find one reference to MCQ on createpoint for
milos, but given there's no mcq_sqd/mcq_vs reg defined downstream, and I
couldn't find anything for the same register values in the .FLAT file, I
don't think Milos has MCQ? Feel free to prove me wrong though.

>
> So, people just ignore my comment ?
>
> Milos is based on SM8550, so it should have dma-coherent, for the MCQ
> I hope they used the fixed added to the SM8650 UFS controller for MCQ.

Not sure what this should mean regarding MCQ...

Regards
Luca

>
> Neil
>
>>=20
>> <snip>
>>=20
>> Thanks,
>> Neil

