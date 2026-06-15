Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045163D3D01;
	Mon, 15 Jun 2026 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514076; cv=none; b=EzfVTAlwiQ1mFtfNJ9OYwttqQOgu8AVq+c8KGRnAejKt9Bp+WU0KirZhnPwGMo59w/t36NGfJhtUHsnwusdVgax5226qtKz7sZENFdKgGTY81RRhyMtOJtJZfwMSHsRQgqw1SLQxu30MG78koIYxhCzggOBg3twhzFJMX5ycDbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514076; c=relaxed/simple;
	bh=XE9M36zNF8kPCNxXJKa86cWurWQ8krjEUdLSKIVGsW8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ofmoC1AbVf/GB0Dd/ftCjbm92UDtU6A75+rUC1+uE+WtmCbCu5qwr/1enBqyBtsIgEuLRMw1dM41UVsRjV4B+DvVaeeTwq7oklxZiNbO9apBAXr5KUCa51wzsi5KCn3rp/DICzMM/VT0EWmdbWZ74BEwpveEBDIMZX5QXSyatDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkOxRoUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkOxRoUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216E51F00A3D;
	Mon, 15 Jun 2026 09:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781514069;
	bh=Mq1SIg3/yOrXOOVlNbiynONcMl1Q3uonnyq8ql4w2m8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EkOxRoUTR3lvDuN13GaAJrDmSoRY8bzZRDENFnc0rH/0N8n+0r0S4NYhtgVr5Iqgw
	 GqPYnmwxUe1g9kusuq9VbONUt2jLs2ZWr1BeHbmmaUc7mz7z8Y8aZFV0McLUfj5bQi
	 v3awhVrb0WSrPsS0lMw+PSqVIPVrZV0pRJBj+UdKzX47zMsRBiFg9OUgx5VYQXed6a
	 Fxo8AWqXLrTwaVNK9FMrgQBYTCJI1hKpHNPOj3s0pdGWBx5ADqJadK9YU5y9sX+uMf
	 yIkmXR1ily/92j+z4iDc8TPcZziSeqclZzVr31jVBg+h/EJazTpBIC1HxzRO3sQYv8
	 zYGEC5x+km4vQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/2] dt-bindings: ufs: Document static TX
 Equalization settings properties
Reply-To: sashiko-reviews@lists.linux.dev
To: "Can Guo" <can.guo@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
References: <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 09:01:08 +0000
Message-Id: <20260615090109.216E51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The new TX Equalization properties incorrectly use `uint32-matri=
x` instead of `uint32-array`, causing `dt_binding_check` validation to fail=
 unconditionally on all valid device trees.
--

commit 3028e214ba5cd87e73e5059697a94d86be2b33c8
Author: Can Guo <can.guo@oss.qualcomm.com>
Date:   Mon Jun 15 08:50:25 2026 +0000

dt-bindings: ufs: Document static TX Equalization settings properties

This commit documents vendor-neutral properties for UFS static TX
Equalization settings in UFS v5.0/UFSHCI v5.0. It defines properties
for tx-precode-enable-g6, txeq-preshoot-g[1-6], and txeq-deemphasis-g[1-6]
to compensate for channel loss and improve high-speed signal integrity.

> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Docu=
mentation/devicetree/bindings/ufs/ufs-common.yaml
> index ed97f56825093..145a6416e1dff 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -105,6 +105,61 @@ properties:
>        Restricts the UFS controller to rate-a or rate-b for both TX and
>        RX directions.
> =20
> +  tx-precode-enable-g6:
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix

[Severity: Medium]
Should this reference /schemas/types.yaml#/definitions/uint32-array instead
of uint32-matrix?

Because uint32-matrix evaluates as an array of inner arrays, applying flat
scalar constraints like the enum sequence below makes the constraints
structurally impossible to satisfy. Will this cause make dtbs_check
validation to fail unconditionally on any device tree implementing this
property?

> +    oneOf:
> +      - items:
> +          - description: Host_Lane0 precode
> +          - description: Device_Lane0 precode

[ ... ]

> +patternProperties:
> +  "^txeq-preshoot-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix

[Severity: Medium]
Does this pattern property also require uint32-array instead of
uint32-matrix for the scalar enum constraints to apply correctly?

> +    oneOf:
> +      - items:
> +          - description: Host_Lane0 Preshoot value
> +          - description: Device_Lane0 Preshoot value

[ ... ]

> +  "^txeq-deemphasis-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix

[Severity: Medium]
Would changing uint32-matrix to uint32-array here as well resolve the
schema validation failures for these flat arrays?

> +    oneOf:
> +      - items:
> +          - description: Host_Lane0 DeEmphasis value
> +          - description: Device_Lane0 DeEmphasis value

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615085027.2102=
882-1-can.guo@oss.qualcomm.com?part=3D1
