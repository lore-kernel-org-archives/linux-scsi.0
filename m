Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC119129A93
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713268625; cv=none; b=QtyfzPkfvAhtbZ0GmlXb4GsxxlYSpvnaEr4DrHqWyW2mTS4J7kohi1TPwcFFbiIF8ycvXA2MbmGQHmZITsVvuFK7OqrijGL/0DBudRsQZEbWuOfhalLDB4bU+bsh5f4XRsAXQGrqCYU7Z9QxwSBjd6/JnlBduFo0nle6oWs6M7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713268625; c=relaxed/simple;
	bh=vIl3v//FVA36XrKiforyh9hY0/yXzSMuW90U1Lzldf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EyFwSfqa+eEKAgarOzTiMEvT6oreEhLRNLcOXumy/FG1nxP+Hihd0fTNIwjiUEFdRX1meVkyV81kwqgfS5opxHNqoDg3l8VriduGKYMjWO/sr+/W0naug5U6zMBrAEji0MM/6C/YYwCGP6Woot2fBLu2b2XQ5Gh4u4J6yVrOCa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qAWrIJSB; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qAWrIJSB"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5aa1e9527d1so3060240eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 04:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713268623; x=1713873423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ophtYrF9IpPwZurMvgYV2hp9I3BGj1tkL8j63ZRtc2I=;
        b=qAWrIJSBaImnX5AI81q+IaPhDKBY5xYc6kTf40ixeVO8Vn8qqUOGKLZNpdiyguEcD8
         osusODQ1FeE3OolyPUzXBkJE5b6qYdrRFT1i4fBvgC3SuI/JWDWh8RajZkmP5f8+rhnw
         aaILeP6Aunaf8nFMdBvn1gp/IE12Kp2Nl5SYLhcpDt51Tu7y7qYQdcigN91BrCrpAKtu
         EqqhQXRBoa7Z/Z4N3fJKss6XN93vDpG9jLh4XUi4GgGdo3iyFuW1qbVK/ESFRwJ6O75r
         OeWWLX8AHiWzM6QmHV2B4lNH/sNEEEv8G/9ltoIAwNgOxtZLTO7f12qmS2QXTDadUhlP
         qP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713268623; x=1713873423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ophtYrF9IpPwZurMvgYV2hp9I3BGj1tkL8j63ZRtc2I=;
        b=oSyE2uS+9D77Xoc5pl0vPHexIb44nv2EGirysLsdUYwNCU3TmV1+CywcSSTc1QRhJm
         ujTnfSjvp9taZePJyq7m1k8LyMt20HDBellz7afu8k2r4JLY02GGwrDMxeg+kn6CQp7W
         FrPeK/QocpYE5BhcKcb062nsvGtDNaxnlGkyNpQWgLcYul2QRmg3F40Ltn4tCMh2rHwM
         /Xxnv58xf2g3ituepy/32wfUuAe+3QgXDZW3Zfo/Hy/72q5v2QCEfxI6zQr2V3iPqPF+
         sGo2XzXlDQ+eOKEFzTFr8RySOILWUWPIcfo+ELPeU6F0tRdvQbwgk2R4g5tZGAt97nUL
         Ce0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtjiKwhJlZKWL8H1fW3piFkxQZJ5fVkHaMFQMIrHqvmEg8HWP4ZZPo3aWrRNTWt/ACuWEssZAViCv3u56Zu9ea6ohg8VRexaYV5w==
X-Gm-Message-State: AOJu0YwQpY7gYFHuai2bNQl4aYaQaIN61J/xzZ10Fkv5u6rKrEQ7v8xz
	R7rlJJh8wwK1zmKybOg1Dld/ODaVg9A9HvwQGSaJj3x7gFOkkhTRVSnkmg32xjTZ7kCWx1zBRLa
	Wx4Egf9VLaiaJbrsyZb/f61tj8NZXrIGYIJ3M+Q==
X-Google-Smtp-Source: AGHT+IGdAJXHt7mAsVZuzt9JgE7vdWoLagtGQT3T15A+kBPHpQZl6zuXKVT8ycszrHB5VvpVeZdYSex6pwkAq/Bp7sg=
X-Received: by 2002:a4a:aecb:0:b0:5ac:9efc:3b02 with SMTP id
 v11-20020a4aaecb000000b005ac9efc3b02mr5501112oon.8.1713268621486; Tue, 16 Apr
 2024 04:57:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-6-peter.griffin@linaro.org> <391a874522a4141b4bc7f0314a9e50d27142123a.camel@linaro.org>
In-Reply-To: <391a874522a4141b4bc7f0314a9e50d27142123a.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 16 Apr 2024 12:56:50 +0100
Message-ID: <CADrjBPqwLt6gzwMpkZvxp5sC-owdDYUN91F0-nV2NvEzek_v9g@mail.gmail.com>
Subject: Re: [PATCH 05/17] arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, kishon@kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	s.nawrocki@samsung.com, cw00.choi@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, chanho61.park@samsung.com, ebiggers@kernel.org, 
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org, 
	saravanak@google.com, willmcvicker@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andr=C3=A9,

Thanks for the review.

On Fri, 5 Apr 2024 at 08:38, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> On Thu, 2024-04-04 at 13:25 +0100, Peter Griffin wrote:
> > Enable the cmu_hsi2 clock management unit. It feeds some of
> > the high speed interfaces such as PCIe and UFS.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  arch/arm64/boot/dts/exynos/google/gs101.dtsi | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/=
boot/dts/exynos/google/gs101.dtsi
> > index eddb6b326fde..38ac4fb1397e 100644
> > --- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
> > +++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
> > @@ -1253,6 +1253,18 @@ pinctrl_hsi1: pinctrl@11840000 {
> >                       interrupts =3D <GIC_SPI 471 IRQ_TYPE_LEVEL_HIGH 0=
>;
> >               };
> >
> > +             cmu_hsi2: clock-controller@14400000 {
> > +                     compatible =3D "google,gs101-cmu-hsi2";
> > +                     reg =3D <0x14400000 0x4000>;
> > +                     #clock-cells =3D <1>;
> > +                     clocks =3D <&ext_24_5m>,
> > +                              <&cmu_top CLK_DOUT_CMU_HSI2_BUS>,
> > +                              <&cmu_top CLK_DOUT_CMU_HSI2_PCIE>,
> > +                              <&cmu_top CLK_DOUT_CMU_HSI2_UFS_EMBD>,
> > +                              <&cmu_top CLK_DOUT_CMU_HSI2_MMC_CARD>;
> > +                     clock-names =3D "oscclk", "bus", "pcie", "ufs_emb=
d", "mmc_card";
> > +             };
>
> This doesn't build because you didn't add the clock ids in the binding pa=
tch.

These clock IDs are for cmu_top, not cmu_hsi2. They were added as part
of the initial gs101/Oriole upstream support series in the following
commit

commit 0a910f1606384a5886a045e36b1fc80a7fa6706b
Author: Peter Griffin <peter.griffin@linaro.org>
Date:   Sat Dec 9 23:30:48 2023 +0000

    dt-bindings: clock: Add Google gs101 clock management unit bindings

    Provide dt-schema documentation for Google gs101 SoC clock controller.
    Currently this adds support for cmu_top, cmu_misc and cmu_apm.

    Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
    Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
    Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    Link: https://lore.kernel.org/r/20231209233106.147416-3-peter.griffin@l=
inaro.org
    Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

regards,

Peter
