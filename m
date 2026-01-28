Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6D238166;
	Wed, 28 Jan 2026 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598060; cv=none; b=scoRiHI8OydvDSbmDV42bcFBNcFj4quZe5ry7vrng07sgRihXkB7LPUgUEs1jK8FLMYUihcu0SUL+yDIZMCadbQOQXQgmo0BIcj4xbisIknv2dpzn9VLHH4+kKg0bQaYk4fjNI6R6Tll38NJ+bR21xJRQEQyKjQV++Vpk4jLUL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598060; c=relaxed/simple;
	bh=0CgB7cfLz+0wS6lVplaCaIvYpdBGSv37uE2NLQ2NHCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCo8cfd95sFsy1C0AQuTRaLeGsG7F0Fr6Zi3zluv8Cy/jAoB876+X5wT682Gozhh9FFSGOmRcpFx793bNwfgcsjDBZcSUHrlo8y0RBfHXSVx/mfv6UwN9A2LIrbdm4rAJm7gLQ/d31u48y/CXLkAzbkMY+ysusPUmI7K/JLEDis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fki8nXiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fki8nXiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EA2C4CEF1;
	Wed, 28 Jan 2026 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598060;
	bh=0CgB7cfLz+0wS6lVplaCaIvYpdBGSv37uE2NLQ2NHCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fki8nXiNuJ3FQ+FzIqTsI4OL08eaWsMyoqxSVHb9+mX1cwHU/2yB9HFlt9Nb9sT2F
	 X0O12LT/HFBR/8zQkTMca9GQYfpflOIhSqUr3hJqpuyTNKnmcv7xAVfhpLfjk3zwod
	 m6afNHeim+1Id4F0EaRg8BIP832FOyUwxqeLmRogHt2Vq1YJ1BUu1FQcKsoIK0xTmC
	 Bu31EB5z1fILFs5xrXxe6vQfgA7EKNFKXMMS1IiRa3cS1xlnoosaFYtAq1SyldqpJc
	 nVA4ZFOIbVCXd21NeanvshIW2U45a32RYp5X0/LKnqtwAx8lVJaCDkYsRSHDGo6SPz
	 NdqgrXvWVnPrw==
Date: Wed, 28 Jan 2026 12:00:57 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Message-ID: <20260128-amigurumi-viper-of-gallantry-69ab8a@quoll>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-1-260141e8fce6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-1-260141e8fce6@oss.qualcomm.com>

On Wed, Jan 28, 2026 at 02:16:40PM +0530, Abhinaba Rakshit wrote:
> Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
> by allowing the use of the standard "operating-points-v2" property in
> the ICE device node. OPP-tabel is kept as an optional property.

Last two lines are redundant. Instead explain the hardware - why it did
not support clock scaling before?

> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index c3408dcf5d2057270a732fe0e6744f4aa6496e06..1e849def1e0078feb45874a436411188d26cf37f 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -30,6 +30,14 @@ properties:
>    clocks:
>      maxItems: 1
>  
> +  operating-points-v2:
> +    description:
> +      Each OPP entry contains the frequency configuration for the ICE device
> +      clock(s).

Drop description, please look how other bindings define this.

Best regards,
Krzysztof

