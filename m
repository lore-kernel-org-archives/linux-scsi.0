Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB11C43AD7
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062933; cv=none; b=JLOxgJmw4NplPkQRuFb43/JXcJBZD5zz9a3/CcFTi9qEEuVnhAmvvTCAYp2jPbuBDOgQu2lDIAn2fZ66GNkPh1baOJC9FeT+dta2EXLnBz9YFin0RwdvheLyp8MsBrno8z5GSvTTkegQzBUvRWGHmX6wfYHzpPfxTm2MlX3uoFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062933; c=relaxed/simple;
	bh=j9WGUFY71ps6OSCWciRhDzFj4uK9mlFz0tqR2rg0Q4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r05qQoBTa4Y+j5O2s+NJlldLHyKGtS40RlWMRKKcQx9q4mmxZobkHxM0HJhCKnW4zrRmPpiBmvYQj8O5TmmDn8sjBhcnN3Byw30HhX/ODSOl22IcZHVrT+JWPHV26paBvOWzGjGjWiJGuM8aMDNoSJ2OaDMIqtmnT4wSvruw8gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U6T6Pr+P; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U6T6Pr+P"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5af702072a9so184790eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 09:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714062931; x=1714667731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8D10nkcOa5R+uHy2/Q7XxV4zDHaJ6w0gsH2wqoomVXQ=;
        b=U6T6Pr+PFC5DKgi3aIKsKkSrPsanqBFS5/OHvEcc9EkNwJuboB4yPzS9B1cYFY2my5
         Ven3lsSYywpkatU72jcZ6HXqGPmPDFums3SmmZz9WHDBBfcyFduxF8kJXrXP0VAAsuae
         aulHTdAbGkZZe/HwAxOQfrNxkP4szowDdlzUUI1EkBumawc4TRa+BMGGDvofPZNOgmy5
         noJDkddsbc5cBqFkzbmMo5js/77K6f7l6404Kzr2RwZ1mKgefcwUSPesl3gJMyYDOh2B
         AcKn0Uw8jwoCo2v8n1poJ8Kd9XkisE29wrq0ylFPIeUplX9uYLh/R06Cl9QgDcxttnb1
         37XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714062931; x=1714667731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8D10nkcOa5R+uHy2/Q7XxV4zDHaJ6w0gsH2wqoomVXQ=;
        b=D2SkTMF5OeM3vfGLWD30DpSenopGiytOwMSjv3yZ/XuSgabH2xcS4MwZnSNDCpZWOj
         1fmZYhjn4v3RM776Q/U76XlqUW1dQ3atcEg1Eop7nDJ1Q5cflkI+lWS1M+2MHDNf3mnN
         IIMpxvGzUZ30/UXfP5ep5nASoxR2iz5u37VgCQo00g2+mbg8P+55w2IQwEDBO+jyzGK2
         BnyjhzTJI8yML9O7Hklmw4gdCZ8XgQwqZVrp+oN1E7lmGV7DsCfNeW6MsPe/bMPwz/AA
         Ox0I1udCnww5VbjFhmr2O1o2y41mqOXEDcrsyY+S4vo6DbE30rUCJhlJPXUyiKGIcbch
         L5wA==
X-Forwarded-Encrypted: i=1; AJvYcCVDgPtIFBuzbvDK99il9iTKgy8HsYpW/DAwC7Um5C0MbAsxyrUctCS1rJAsGvo7AmCHP1aNyRNI7Dj1nrR6S+AfnzeckjvBaLigPw==
X-Gm-Message-State: AOJu0YwSMN87zJdl/AtRX5ryhMgCoYtZiURwFfXkZFzsOd0kMlbq62EF
	sUPtNRno+Z2nHtSEM5HffcpydXa16/IkTePColvOMOj9HChBgPHC0RKxVVhWIMh2/NIpOytZub3
	2Xvc59HWY51sjRccW1O4yc09xxri5mAIPW79eSw==
X-Google-Smtp-Source: AGHT+IHjcgDl2gtVr/nZRGKGuh2NquqDXaKs02m0Ke3hafEhPZVueDe1BLxI7k0uWnYn7WyPx11zD8Zk9f2sSWyLcbo=
X-Received: by 2002:a4a:d46:0:b0:5ac:9e7d:576e with SMTP id
 67-20020a4a0d46000000b005ac9e7d576emr185709oob.1.1714062931017; Thu, 25 Apr
 2024 09:35:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
 <20240423205006.1785138-7-peter.griffin@linaro.org> <52403f522a4f7513c5ee5dae48856988f7141825.camel@linaro.org>
In-Reply-To: <52403f522a4f7513c5ee5dae48856988f7141825.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Thu, 25 Apr 2024 17:35:19 +0100
Message-ID: <CADrjBPrpsTFns8o+H=SvqdgmKFrkuGEJ2QphL7BpRfy9kifxJQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/14] arm64: dts: exynos: gs101: Add ufs, ufs-phy and
 ufs regulator dt nodes
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: mturquette@baylibre.com, sboyd@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, kishon@kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	s.nawrocki@samsung.com, cw00.choi@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, 
	ebiggers@kernel.org, linux-scsi@vger.kernel.org, 
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-clk@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	tudor.ambarus@linaro.org, saravanak@google.com, willmcvicker@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andr=C3=A9,

On Thu, 25 Apr 2024 at 13:02, Andr=C3=A9 Draszik <andre.draszik@linaro.org>=
 wrote:
>
> On Tue, 2024-04-23 at 21:49 +0100, Peter Griffin wrote:
> > Enable the ufs controller, ufs phy and ufs regulator in device tree.
> >
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  .../boot/dts/exynos/google/gs101-oriole.dts   | 18 ++++++++++
> >  arch/arm64/boot/dts/exynos/google/gs101.dtsi  | 36 +++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> >
>
> [...]
>
> > +
> > +             ufs_0: ufs@14700000 {
> > +                     compatible =3D "google,gs101-ufs";
> > +                     reg =3D <0x14700000 0x200>,
> > +                           <0x14701100 0x200>,
> > +                           <0x14780000 0xa000>,
> > +                           <0x14600000 0x100>;
> > +                     reg-names =3D "hci", "vs_hci", "unipro", "ufsp";
> > +                     interrupts =3D <GIC_SPI 532 IRQ_TYPE_LEVEL_HIGH 0=
>;
> > +                     clocks =3D <&cmu_hsi2 CLK_GOUT_HSI2_UFS_EMBD_I_AC=
LK>,
> > +                              <&cmu_hsi2 CLK_GOUT_HSI2_UFS_EMBD_I_CLK_=
UNIPRO>,
> > +                              <&cmu_hsi2 CLK_GOUT_HSI2_UFS_EMBD_I_FMP_=
CLK>,
> > +                              <&cmu_hsi2 CLK_GOUT_HSI2_QE_UFS_EMBD_HSI=
2_ACLK>,
> > +                              <&cmu_hsi2 CLK_GOUT_HSI2_QE_UFS_EMBD_HSI=
2_PCLK>,
> > +                              <&cmu_hsi2 CLK_GOUT_HSI2_SYSREG_HSI2_PCL=
K>;
> > +                     clock-names =3D "core_clk", "sclk_unipro_main", "=
fmp",
> > +                                   "ufs_aclk", "ufs_pclk", "sysreg";
> > +                     freq-table-hz =3D <0 0>, <0 0>, <0 0>, <0 0>, <0 =
0>, <0 0>;
> > +                     pinctrl-names =3D "default";
> > +                     pinctrl-0 =3D <&ufs_rst_n &ufs_refclk_out>;
>
> The preferred order is pinctrl-0 before pinctrl-names (similar to clock-n=
ames and reg-names).

Will fix
>
> Other than that,
>
> Acked-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>

thanks,

Peter
