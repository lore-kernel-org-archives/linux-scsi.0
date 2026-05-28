Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1112A31F996;
	Thu, 28 May 2026 06:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779949115; cv=none; b=NVBne+LbrO04pAxVrNi5xDzCP2aw8fXzMXQpYysoBRM5QxlkDrqrOna6hH6Eg2cg2ZVY6Koj/hJvuPx66ovdJWaazI02vTIaQzvsUWIdO7qtPacKZC6a9zh7RXa5OOv2Z+iSUaqSJZx6xfBTrO8NxE5RhDFgiwTedafkQZL2rFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779949115; c=relaxed/simple;
	bh=7ciCZN5IfMz5aQGJlfd42F0W3rK6Cp+4phe5xibEMtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YscHhQV6YIJN8BcaNh2hjcTYz2nKBk324ErxzjG4A0mOjYsLqyHL59ISWADvsxDcXS5a6lKPgQ2a+6oXwwylyj4hd5W9061xw5H9NCugHKCT7FkpYgcCyZbYJeYU/SeJ+imKDXl72Q2Ltp0gRPcX0GgL0IlolHnmdM1pZsdGdlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqw8pJoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqw8pJoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1EF1F000E9;
	Thu, 28 May 2026 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779949113;
	bh=MZ7pZ/2XKPOWhii6SzPPYF1kcQIPQDSqyREzR7kB8AI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lqw8pJoC5Ibe1xcEM0S7QyF8NZqXDC22RZqzGS2kh1bIkzMnQ2o02ZtKqSXTtMIog
	 wyE/fgs5v+Bf4XspGBHQuYFRgGar9i7xyTKfVdB9us+a05ffqQMC0qkpeRNE6U8Wzv
	 bhTn88gAqBxnaBn473TlHepC+VVfz75xIgHDn6ZFIb0WboInnBu79NSCFpzDMFfgGS
	 qfO1LKJcDHqEwJd5cJmUM3uNxUDN8uY4oA3J1vtLxj1fQqpaJIxNKFvG+KASOWZEtQ
	 4CVq1wnPiR54+NIvS76Ack65yWQPwY7fQsmJHWq6B/d+W5S/T77L/jdIWGKRnu4D/Y
	 FzYUIv38EmQlA==
Date: Thu, 28 May 2026 08:18:27 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Zhaoming Luo <zhml@posteo.com>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Message-ID: <oq27n7qkpj2kzyacy7puk5jii76pyjt6fjbugxzs2mu3h64uzq@vwdtejgevm2z>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260527144055.2758170-2-can.guo@oss.qualcomm.com>

On Wed, May 27, 2026 at 07:40:54AM -0700, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
> integrity at high speed operation.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
> required depending on channel characteristics.
> 
> Add vendor-neutral DT properties:
> 
> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
> - fixed property tx-precode-enable-g6
> 
> Each property is a uint32 array of per-lane tuples:
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
> 
> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> index ed97f5682509..d90cf25adfa5 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -105,6 +105,51 @@ properties:
>        Restricts the UFS controller to rate-a or rate-b for both TX and
>        RX directions.
>  
> +  tx-precode-enable-g6:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    oneOf:
> +      - minItems: 2
> +        maxItems: 2
> +      - minItems: 4
> +        maxItems: 4
> +    items:
> +      enum: [0, 1]
> +    description: |
> +      Static TX Precode enable values for HS-G6 only.
> +      Values are specified as per-lane tuples:
> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
> +
> +patternProperties:
> +  "^txeq-preshoot-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    oneOf:
> +      - minItems: 2
> +        maxItems: 2
> +      - minItems: 4
> +        maxItems: 4
> +    items:
> +      minimum: 0
> +      maximum: 7
> +    description: |
> +      Static TX Equalization PreShoot values for High Speed Gears.
> +      Values are specified as per-lane tuples:
> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
> +
> +  "^txeq-deemphasis-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    oneOf:
> +      - minItems: 2
> +        maxItems: 2
> +      - minItems: 4
> +        maxItems: 4
> +    items:
> +      minimum: 0
> +      maximum: 7
> +    description: |
> +      Static TX Equalization DeEmphasis values for High Speed Gears.
> +      Values are specified as per-lane tuples:
> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
> +
>  dependencies:
>    freq-table-hz: [ clocks ]
>    operating-points-v2: [ clocks, clock-names ]
> -- 
> 2.34.1

-- 
மணிவண்ணன் சதாசிவம்
