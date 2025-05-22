Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBABE268FC8
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2025 08:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904006; cv=none; b=oqhVez2US0zaYqQuYrfWwkCjWAJ3ef38Vrflc1FiSD/3qRDSd0JQByrcbscileknFzkhAvtboebb6f8aCMXx/eADA/3pOWV/nH2Kq8Xybl5T2aL31Gt12oJfLxb7LxRFTXtghHREzPTxqwoLH5nPfsQByiZqVLgb+fQbceDvrjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904006; c=relaxed/simple;
	bh=zU/z3bLOlzuSQkcMtTCVJsX995ruiIR5eHpPKYALmb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMGC2AhkKQLniWyMRf2YDAtK0A7f6ucv6iIAk5QQpb+0bqAe2sgFQLZEitA9veCGFvo9hOocJ8hgMEavcYe0Y3yUB8aqByaL3HlmD/O3qxq+EXp445OWTmcRLjXsLZoEXW+GSH+lMqFx5vns+CiVM06aU8YjxW6oyLlpM9FsLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RnuX/zGR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RnuX/zGR"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-73712952e1cso7172552b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 May 2025 01:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747904003; x=1748508803; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wE/Nk3n7Qj543anMoi03EY1HELsp/mGZ1M/Gx4pgSIs=;
        b=RnuX/zGRB42yAzoOnJoC9hdHdh+bsle5+JSaKcpc2ibo+JJMx9xPSbBjo7nrpIzpQc
         U/4wrr29Xqbb/Eh5aIfwAIR4+CKP8YeWRVbx+SNaqvBoSRkPaZZ+XhmJ76Z1HY9vohx8
         etjvMKtG6Pzrou0QopWMHprnOih2psTbhlWbnaE1O6jUfOchpt+WikIFQDJHhH1Wwdqj
         qkIM1cfDz2WMVl2B8LduEdfOpsmlaf0kmAzVjYtpBRyl7QfIpmDDuTu2aT2w8aJUtemD
         Iln4cfv8nqW2DHJcdbnEwX/wgqgPmHkhFdzRGbETKIpzKZAlbzI2fLhFqSM4plgjCKos
         +BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747904003; x=1748508803;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wE/Nk3n7Qj543anMoi03EY1HELsp/mGZ1M/Gx4pgSIs=;
        b=lhsILg5ghKhlDSX/PkUMoeJ16kR3NPDWjbwF/wQlZ1+egBqIn4DyyMLNsYqRie+QZW
         VMfF6HtTdfHToU//cX+lVOtazTUJbVywsVq8qlycbavG9sjVVB4VMd8hM+6bKbIXFopp
         bgPuFoi0D1XKNRlCuGuFefOI9Yg8PxV/CUSd05V5bSAu2wQLUwfBRCqWsrw7UsgNw/AQ
         yq23HLGfMsPkTMFG+IxqHqGqKSl/zw6B2tb/W9Ao94/Yly3SsPFOfRBgAVatw6V4YRbD
         xzZbCCZoGouVx4yMXO/vFXtEEPPWYKCkbIyT5mfvaMEqVaE9MpeT1CRVZdhwBi1/qb5D
         E5Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVKdKGH+m57ISFvZPA3Mu0L1BxZPZD4R3fm90TiglUvYQrJi7BKNjW3805E3FUFcZgY5RZXG0ns+TgY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5slQq5TJIadIOdb0p3OMLoM7HHUn6ybndQbZCuFBevcxTTLpE
	ZBJcZAOWZemDiRRVyZwiJd6rkEkiRV1lXQgFVF52B1sz13i2JUtajIJ5aulrrJq65g==
X-Gm-Gg: ASbGncvQbKNn+G6dJLtrqb7VtDRIUILWKRzPE+zTiRhIF+7vPUtBjKMau+kSb042ORp
	WG1Fdsj0oK6KRzGkx6NuNtyeKpNz+soUYI1oBo5Rxf/rdOoIiK2y8ys7Ik8o4IE+Nd9Ps1Z/OfS
	XvslJLAtx2UsCoGKjuLpnAXl+ixtmq1FzLLtO129ldemnf+JsCp2XH6MUvM8p4QlYk6dfohfM9Y
	Uk0C+nHQRPzujvwIpHjFzaE1UjTGYbYuA7F5BrUlp+A0xFNGz8n3Pbompouv4j9M+FyNRCX38Dx
	ABQ9xK4ImakQ6BOxcWZNuHt2G3fYlBivx1hOLmT9rlU14d6vQOoZYHe8R5BzAQ==
X-Google-Smtp-Source: AGHT+IF5uWmk4PnvIThnJSvV0zNx6s2lAIFa7Qq/vftR90Qhtr6lQ7tpJ/xet55CCmVXUt9jRfsojQ==
X-Received: by 2002:a05:6a21:3385:b0:20d:df67:4921 with SMTP id adf61e73a8af0-2170cafa33dmr33994739637.4.1747904003020;
        Thu, 22 May 2025 01:53:23 -0700 (PDT)
Received: from thinkpad ([120.60.130.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a96e589esm10810267b3a.9.2025.05.22.01.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:53:22 -0700 (PDT)
Date: Thu, 22 May 2025 14:23:16 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 07/11] phy: qcom-qmp-ufs: Remove qmp_ufs_exit() and
 Inline qmp_ufs_com_exit()
Message-ID: <qrope222shpeqvhe2dnh4p4jmznuu7tr3jh2zujwbbd3khg4yo@wm2epj5ydefc>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-8-quic_nitirawa@quicinc.com>
 <untqxy76skl53c55bdjz5usk4seuypjqbxkfub2qeqz42mewqr@r4cutmkvy235>
 <79d2f373-ee53-4cd2-b228-171daf3adcb7@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79d2f373-ee53-4cd2-b228-171daf3adcb7@quicinc.com>

On Thu, May 22, 2025 at 03:49:12AM +0530, Nitin Rawat wrote:
> 
> 
> On 5/21/2025 7:19 PM, Manivannan Sadhasivam wrote:
> > On Thu, May 15, 2025 at 09:57:18PM +0530, Nitin Rawat wrote:
> > > qmp_ufs_exit() is a wrapper function. It only calls qmp_ufs_com_exit().
> > > Remove it to simplify the ufs phy driver.
> > > 
> > 
> > Okay, so you are doing it now...
> 
> Yes
> 
> > 
> > > Additonally partial Inline(dropping the reset assert) qmp_ufs_com_exit
> > > into qmp_ufs_power_off function to avoid unnecessary function call.
> > > 
> > 
> > Why are you dropping the reset_assert()?
> 
> This was not aligning to Phy programming guide .
> 

You should mention it in the description.

> 
> > 
> > > Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > > ---
> > >   drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 19 +++++--------------
> > >   1 file changed, 5 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > index a5974a1fb5bb..fca47e5e8bf0 100644
> > > --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> > > @@ -1758,19 +1758,6 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
> > >   		qmp_ufs_init_all(qmp, &cfg->tbls_hs_b);
> > >   }
> > > -static int qmp_ufs_com_exit(struct qmp_ufs *qmp)
> > > -{
> > > -	const struct qmp_phy_cfg *cfg = qmp->cfg;
> > > -
> > > -	reset_control_assert(qmp->ufs_reset);
> > > -
> > > -	clk_bulk_disable_unprepare(qmp->num_clks, qmp->clks);
> > > -
> > > -	regulator_bulk_disable(cfg->num_vregs, qmp->vregs);
> > > -
> > > -	return 0;
> > > -}
> > > -
> > >   static int qmp_ufs_power_on(struct phy *phy)
> > >   {
> > >   	struct qmp_ufs *qmp = phy_get_drvdata(phy);
> > > @@ -1851,7 +1838,11 @@ static int qmp_ufs_power_off(struct phy *phy)
> > >   	qphy_clrbits(qmp->pcs, cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
> > >   			SW_PWRDN);
> > > -	qmp_ufs_com_exit(qmp);
> > > +	/* Turn off all the phy clocks */
> > 
> > You should drop this and below comment. They add no value.
> 
> Comments are actually provided for each operation within qmp_ufs_power_off
> which actually facilitate understanding of all actions performed by the
> function which may not be fully clear by code. Hence
> I thought to keep the comments. But If you insist i'll remove.
> 

For complex code, comment should be added indeed. But for
clk_bulk_disable_unprepare() and regulator_bulk_disable(), NO. It is obvious
that they turn off clock and regulators.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
