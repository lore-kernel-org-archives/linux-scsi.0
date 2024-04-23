Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236D13CA97
	for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713894366; cv=none; b=i13EW7R00QU5VztaYBiiE2//zZ7AZX24fJuQpg8HxiVr2AQraRQeGyrgkbYVSlamJYaM9miuG0Sebv4IleBeNsy2Yp3t0ikKH9Ze+bQycNrLotyTzg9oEsf5hgaS3Y/wfAy521rLzpGaQ7cWD/mENZvWoD0nG1SuJOMTr5EorBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713894366; c=relaxed/simple;
	bh=jnAd/2sSEJ0WMtjOyYGX1bWKZAuyDHWJ/L9RphxwCAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ty5JCMZA6aBhdM/KQGxaRmUU1T9RZL7jDeFQpulEPTLJWBPW2v0NjqCiEceiraDXNgTkihx7UNRqoXWejKFinl19JDoWb2aQEMYrkvM2OIId/1hwtuxv6JDat82OqJ7l3OmGslnYGUnWb9Ouv8oMm3KGGMN+NYbBPA0gl8XGR38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q5fQyOLn; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q5fQyOLn"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5ad0f58c74eso40355eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Apr 2024 10:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713894363; x=1714499163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3mo6Mk3SX0kmzv/thEaB5W9SO6Cld9rTNEVyk3LNv4=;
        b=q5fQyOLnyClGY2zV+51CCMidc5Ja2V25hkdC2ccWaMDTk450rOyzBHvFrrPCT5ASp0
         bQrIzDRziKJYDhO/7KC6GZLKXJdBDTODasPF89JRY3saYOAXNkTyektOj/eWznqiuGeb
         RDS7N8vRvkCkQvKOvNE1tXH0mkSP7Qmj3zeIllvYSHe9dSGk4gLY37tOKDWXJUcf1V6x
         y7f56cKVLkr/rvi3xg4DslYDSRgfxlAOBKfLTy54ZWFKpMbh3kcq0MWUCyDb3FWVLaXo
         cnTt+6SG7pItUFcR2cNIzslSUABRRzs6SZtxbOmNEVISLUuv6dLbbn//ribnPRFr112T
         yKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713894363; x=1714499163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3mo6Mk3SX0kmzv/thEaB5W9SO6Cld9rTNEVyk3LNv4=;
        b=X6+O+I1BhyegxYlvUKrZj2GQPpP859rX5nvksNLbMrjx7SlIT6SOGXdp/nt8oLunCu
         glkfXymwUL/l6kgLwriJ/ur+0Ix3TmRuodLaG1tnbmqW2ionfS1bNpU+pUp1QseQItRc
         LrsCIlyj7nNBL7g1l+h5+1WBDYOAcDYRO+QCNA5Pa5Kn6uwm1gaObxoDgLPARsnbr52V
         Jwcjzb08TNdWWSgfIcKyZu/boseAYvI2DYdjtQU5quXmCpYJd7wTeYpOLG2p2qZDiMz2
         zajK5IU8Vm5103NqGq2aZ6fXslDi4TA8el9y5w7BNlsf/deiF6v5YwETMYSFNtOTQsm5
         7VhA==
X-Forwarded-Encrypted: i=1; AJvYcCWIZ680H0peefUrLq11vxxuympP/0GUTUEN6pmzQ3+yedN/Y6aho+vfFlWCrPyE9YilXyHCCWhWFmNKMRhkcDbF6CIDDdoAOpo3Nw==
X-Gm-Message-State: AOJu0YwTihKtuWGQibRPO9WVY4QQoCdvMd1IfwBun7EH+UcYZm9SAe9f
	3oN9IxWH3PCHdiQ72Ue1n+sSgEg17NGypik+g/5Ni+Boq2a4TpN99LlrENLQW1UdaWSlnx1wtKU
	Z6yL+uvWmvMqB+SDIP9jICrc8GUlgK9ai2mv6Gg==
X-Google-Smtp-Source: AGHT+IFjQt3mfbwBR44wWtiV52Fvs+JYmX+pN7lhEf2mhrvRbg8R0D5V2WdJQGT9SPtHiTXEX5fgYqJFaSu9KML7oR8=
X-Received: by 2002:a4a:8554:0:b0:5aa:22f5:a908 with SMTP id
 l20-20020a4a8554000000b005aa22f5a908mr1685739ooh.1.1713894362907; Tue, 23 Apr
 2024 10:46:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404122559.898930-1-peter.griffin@linaro.org>
 <20240404122559.898930-9-peter.griffin@linaro.org> <6c2b060b3b32b2da46bafbdc33236c319b6cec62.camel@linaro.org>
In-Reply-To: <6c2b060b3b32b2da46bafbdc33236c319b6cec62.camel@linaro.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 23 Apr 2024 18:45:50 +0100
Message-ID: <CADrjBPrNqJ6FNKZTgVxST1en-hRdyZFmJe42uwerSnDSmgifbg@mail.gmail.com>
Subject: Re: [PATCH 08/17] clk: samsung: gs101: add support for cmu_hsi2
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

On Mon, 8 Apr 2024 at 15:49, Andr=C3=A9 Draszik <andre.draszik@linaro.org> =
wrote:
>
> Hi Pete,
>
> On Thu, 2024-04-04 at 13:25 +0100, Peter Griffin wrote:
> > CMU_HSI2 is the clock management unit used for the hsi2 block.
> > HSI stands for High Speed Interface and as such it generates
> > clocks for PCIe, UFS and MMC card.
> >
> > This patch adds support for the muxes, dividers, and gates in
> > cmu_hsi2.
> >
> > CLK_GOUT_HSI2_HSI2_CMU_HSI2_PCLK is marked as CLK_IS_CRITICAL
> > as disabling it leads to an immediate system hang.
> >
> > CLK_GOUT_HSI2_SYSREG_HSI2_PCLK is also marked CLK_IS_CRITICAL.
> > A hang is not observed with fine grained clock control, but
> > UFS IP does not function with syscon controlling this clock
> > just around hsi2_sysreg register accesses.
>
> Would it make sense to add this clock to the &ufs_0 node in the DTS
> instead? Seems more natural than a clock that's constantly enabled?

Will add this to ufs node in v2.

>
> > [...]
> >
> > Updated regex for clock name mangling
> >     sed \
> >         -e 's|^PLL_LOCKTIME_PLL_\([^_]\+\)|fout_\L\1_pll|' \
> >         \
> >         -e 's|^PLL_CON0_MUX_CLKCMU_\([^_]\+\)_\(.*\)|mout_\L\1_\2|' \
> >         -e 's|^PLL_CON0_PLL_\(.*\)|mout_pll_\L\1|' \
> >         -e 's|^CLK_CON_MUX_MUX_CLK_\(.*\)|mout_\L\1|' \
> >         -e '/^PLL_CON[1-4]_[^_]\+_/d' \
> >         -e '/^[^_]\+_CMU_[^_]\+_CONTROLLER_OPTION/d' \
> >         -e '/^CLKOUT_CON_BLK_[^_]\+_CMU_[^_]\+_CLKOUT0/d' \
> >         \
> >         -e 's|_IPCLKPORT||' \
> >         -e 's|_RSTNSYNC||' \
> >         -e 's|_G4X2_DWC_PCIE_CTL||' \
> >         -e 's|_G4X1_DWC_PCIE_CTL||' \
> >         -e 's|_PCIE_SUB_CTRL||' \
> >         -e 's|_INST_0||g' \
> >         -e 's|_LN05LPE||' \
> >         -e 's|_TM_WRAPPER||' \
> >         -e 's|_SF||' \
> >         \
> >         -e 's|^CLK_CON_DIV_DIV_CLK_\([^_]\+\)_\(.*\)|dout_\L\1_\2|' \
> >         \
> >         -e 's|^CLK_CON_BUF_CLKBUF_\([^_]\+\)_\(.*\)|gout_\L\1_\2|' \
> >         -e 's|^CLK_CON_GAT_CLK_BLK_\([^_]\+\)_UID_\(.*\)|gout_\L\1_\2|'=
 \
> >         -e 's|^gout_[^_]\+_[^_]\+_cmu_\([^_]\+\)_pclk$|gout_\1_\1_pclk|=
' \
> >         -e 's|^CLK_CON_GAT_GOUT_BLK_\([^_]\+\)_UID_\(.*\)|gout_\L\1_\2|=
' \
> >         -e 's|^CLK_CON_GAT_CLK_\([^_]\+\)_\(.*\)|gout_\L\1_clk_\L\1_\2|=
' \
> >         \
> >         -e '/^\(DMYQCH\|PCH\|QCH\|QUEUE\)_/d'
>
> Thank you for the updated regex.
>
> > ---
> >  drivers/clk/samsung/clk-gs101.c          | 558 +++++++++++++++++++++++
> >  include/dt-bindings/clock/google,gs101.h |  63 +++
> >  2 files changed, 621 insertions(+)
> >
> > diff --git a/drivers/clk/samsung/clk-gs101.c b/drivers/clk/samsung/clk-=
gs101.c
> > index d065e343a85d..b9f84c7d5c22 100644
> > --- a/drivers/clk/samsung/clk-gs101.c
> > +++ b/drivers/clk/samsung/clk-gs101.c
> > @@ -22,6 +22,7 @@
> >  #define CLKS_NR_MISC (CLK_GOUT_MISC_XIU_D_MISC_ACLK + 1)
> >  #define CLKS_NR_PERIC0       (CLK_GOUT_PERIC0_SYSREG_PERIC0_PCLK + 1)
> >  #define CLKS_NR_PERIC1       (CLK_GOUT_PERIC1_SYSREG_PERIC1_PCLK + 1)
> > +#define CLKS_NR_HSI2 (CLK_GOUT_HSI2_XIU_P_HSI2_ACLK + 1)
> >
> >  /* ---- CMU_TOP ------------------------------------------------------=
------- */
> >
> > @@ -3409,6 +3410,560 @@ static const struct samsung_cmu_info peric1_cmu=
_info __initconst =3D {
> >       .clk_name               =3D "bus",
> >  };
> >
> > +/* ---- CMU_HSI2 -----------------------------------------------------=
----- */
>
> This comment is shorter that all the other similar comments in this file.

Will fix
>
> > [...]
> > +
> > +PNAME(mout_hsi2_bus_user_p)  =3D { "oscclk", "dout_cmu_hsi2_bus" };
> > +PNAME(mout_hsi2_pcie_user_p) =3D { "oscclk", "dout_cmu_hsi2_pcie" };
> > +PNAME(mout_hsi2_ufs_embd_user_p) =3D { "oscclk", "dout_cmu_hsi2_ufs_em=
bd" };
> > +PNAME(mout_hsi2_mmc_card_user_p) =3D { "oscclk", "dout_cmu_hsi2_mmc_ca=
rd" };
>
> Can you make these alphabetical, too, please, which would also match thei=
r usage
> below:

Will fix
>
> > +
> > +static const struct samsung_mux_clock hsi2_mux_clks[] __initconst =3D =
{
> > +     MUX(CLK_MOUT_HSI2_BUS_USER, "mout_hsi2_bus_user", mout_hsi2_bus_u=
ser_p,
> > +         PLL_CON0_MUX_CLKCMU_HSI2_BUS_USER, 4, 1),
> > +     MUX(CLK_MOUT_HSI2_MMC_CARD_USER, "mout_hsi2_mmc_card_user",
> > +         mout_hsi2_mmc_card_user_p, PLL_CON0_MUX_CLKCMU_HSI2_MMC_CARD_=
USER,
> > +         4, 1),
> > +     MUX(CLK_MOUT_HSI2_PCIE_USER, "mout_hsi2_pcie_user",
> > +         mout_hsi2_pcie_user_p, PLL_CON0_MUX_CLKCMU_HSI2_PCIE_USER,
> > +         4, 1),
> > +     MUX(CLK_MOUT_HSI2_UFS_EMBD_USER, "mout_hsi2_ufs_embd_user",
> > +         mout_hsi2_ufs_embd_user_p, PLL_CON0_MUX_CLKCMU_HSI2_UFS_EMBD_=
USER,
> > +         4, 1),
> > +};
> > +
> > +static const struct samsung_gate_clock hsi2_gate_clks[] __initconst =
=3D {
> > +
>
> Here and below: all these extra empty lines are not needed.

Will fix
>
> > +     GATE(CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_003_PHY_REFCLK_IN,
> > +          "gout_hsi2_pcie_gen4_1_pcie_003_phy_refclk_in",
> > +          "mout_hsi2_pcie_user",
> > +          CLK_CON_GAT_CLK_BLK_HSI2_UID_PCIE_GEN4_1_IPCLKPORT_PCIE_003_=
PCIE_SUB_CTRL_INST_0_PHY_REFCLK_IN,
> > +          21, 0, 0),
> > +
> > +     GATE(CLK_GOUT_HSI2_PCIE_GEN4_1_PCIE_004_PHY_REFCLK_IN,
> > +          "gout_hsi2_pcie_gen4_1_pcie_004_phy_refclk_in",
> > +          "mout_hsi2_pcie_user",
> > +          CLK_CON_GAT_CLK_BLK_HSI2_UID_PCIE_GEN4_1_IPCLKPORT_PCIE_004_=
PCIE_SUB_CTRL_INST_0_PHY_REFCLK_IN,
> > +          21, 0, 0),
> > +
> > +     GATE(CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4A_1_ACLK,
> > +          "gout_hsi2_ssmt_pcie_ia_gen4a_1_aclk",
> > +          "mout_hsi2_bus_user",
>
> The two strings fit on the same line.

Will fix
>
> > +          CLK_CON_GAT_CLK_BLK_HSI2_UID_SSMT_PCIE_IA_GEN4A_1_IPCLKPORT_=
ACLK,
> > +          21, 0, 0),
> > +
> > +     GATE(CLK_GOUT_HSI2_SSMT_PCIE_IA_GEN4A_1_PCLK,
> > +          "gout_hsi2_ssmt_pcie_ia_gen4a_1_pclk",
> > +          "mout_hsi2_bus_user",
>
> dito.

Will fix

regards,

Peter


>
> > [...]
> > +     /* Disabling this clock makes the system hang. Mark the clock as =
critical. */
> > +     GATE(CLK_GOUT_HSI2_HSI2_CMU_HSI2_PCLK,
> > +          "gout_hsi2_hsi2_cmu_hsi2_pclk", "mout_hsi2_bus_user",
> > +          CLK_CON_GAT_GOUT_BLK_HSI2_UID_HSI2_CMU_HSI2_IPCLKPORT_PCLK,
> > +          21, CLK_IS_CRITICAL, 0),
>
> I have a similar clock in USB, which also causes a hang if off, I wonder =
what we
> could do better here.
>
>
> Cheers,
> Andre'
>
