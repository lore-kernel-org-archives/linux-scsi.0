Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28F23AB288;
	Tue, 28 Jul 2026 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245257; cv=none; b=m8pIC/wOZu2f8u35eX+dYkfVBww29v2HG/9QvUeLhybP+o3a5LEWmlN3K0JKoLMZN67iGJRWqLXf8L0Wa/ho77Q++YrcnIQ3K9pzi1uAx3JKpRE+uccMA+8AgSfPNDtK+5v8MAdWWWzMhae6jW4uus8yIXxlTJLqBoX6aFV4wiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245257; c=relaxed/simple;
	bh=hzIXSiOLw+/mgI67+G0ajdAH36oPo7JWiwpk2IFH3K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usSvSMo76+pGePy9cwddCMADCwLLCSrIApjQIm4MEM8kXwDaWKLCt8qisD6VY4FaubbvhiAQDZBQjsGZ3yDZG4DYQezblyQWcbXK1QKgvT1XeoEBVi0VbVOhg8N4NNaRGZ3+B1LgZQbo3mk5dzPYDipb6mSYsQFvFQi/8XQBSN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lx6YOG/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lx6YOG/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65A81F000E9;
	Tue, 28 Jul 2026 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245255;
	bh=zWIgPZ44q+pV3uugOSPIbIA0Di3E6uK2vMPuJMDykpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lx6YOG/27NdgLJ6xyZgPjaTY+qyWPyqifnDlIyGlrnD1HPRdqN6w6LVmWbWLMr15B
	 +Uf8ApENwf2YXEr3p4+QWcjk3dNidB432hd6Pt/Azl9TFSvmAqOr5IGFRfg5sYqyud
	 8lGRRmp2BYq3yo0X3TdtHuTpe2B2OnrU8KOKWv3rYr8QjD3hRSaG7NNL3IrOubKBf9
	 6cw31ORUVwzFxT75T7kG1vk3Bq8dn5miwLYpnbyXh9sbTC+5phwhG3YA0tz4di0kkG
	 i17+d6A5WSlRIPwJYg0JNVX+JGp++rO0fSR2IOnnmkEG80iUhakSPM4bq3uzZ7zJh/
	 EF1D8jbiTDQLw==
Date: Tue, 28 Jul 2026 15:27:26 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, Anjana Hari <anjana.hari@oss.qualcomm.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for
 qcom,sa8255p-ufshc
Message-ID: <asybgutzvupx6jfbaqsc27ikvqu2h2ycuq4aulh7tbrrzhp2y2@rfzp4salwhuq>
References: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>

On Mon, Jul 20, 2026 at 10:35:52AM +0800, Shawn Guo wrote:
> Qualcomm UFS controller found on SoCs SA8255P/SA8797P has a MCQ I/O
> address space. It should be defined in the bindings even though Linux
> driver currently doesn't utilize it. Fix the binding before it gets
> adopted by DTS.
> 
> Fixes: e2725ed2a7fb ("scsi: ufs: dt-bindings: Document bindings for SA8255P UFS Host Controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
> Changes for v2:
> - Recover the newline which got dropped by accident
> - Link to v1: https://lore.kernel.org/r/20260716083313.2367249-1-shengchao.guo@oss.qualcomm.com
> 
>  .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml      | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> index db165a235cb6..66d73e9025d6 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> @@ -18,7 +18,14 @@ properties:
>            - const: qcom,sa8255p-ufshc
>  
>    reg:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 2
> +
> +  reg-names:
> +    minItems: 1
> +    items:
> +      - const: std
> +      - const: mcq
>  
>    interrupts:
>      maxItems: 1
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
