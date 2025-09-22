Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1EF1C1ADB;
	Mon, 22 Sep 2025 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570390; cv=none; b=bNQ2w8VS2XA8iXZBDt/aaRzxgzfKMl7BK8i11aZMlux2mKBmcb3DNO1u0jQYhrAljWw0wHaZH5VrOq15sEi5P7HdrEUkAaGggIthmTj9bbuJwNcInB61G0mM2OHOs6XEbIcdkkDF1mqVHWMDPoIeGkxkG6DpXyU9SHc47mU5uPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570390; c=relaxed/simple;
	bh=9mwBHQlyy1lyCqbjaRGhEhTY0naii4PSOmHAewQhrjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9MbBkBK8Uj8k+EjXvuN/eNRnq3TOM5umOW403WnQlDiNi8MJRfePzA/tg8+2Kbfud9Dg0BO8t+SB2FsW1TEnaguUVDW+9R3uVK83C7vmbLGx7sb2Ogi4dlwrhLjZHeqYBw8Yq++kA6iLXxeiDrJ0ayOePyFAX0AhUi+tgosBBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uvw2dSO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uvw2dSO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACFFC4CEF7;
	Mon, 22 Sep 2025 19:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758570390;
	bh=9mwBHQlyy1lyCqbjaRGhEhTY0naii4PSOmHAewQhrjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uvw2dSO+0QkBvqFTP4T6g8s7hpi4WyIjvBkAZRHVIRSrFJ4394ah6Pn10JFGaf7J7
	 PWx21DYg74+ax0MwrsKREwS3ZtT5wS2+TqmcWdrP3cyhT+PomjPU52PEJrudHDB/hH
	 +/QMC5CqUJw6o/H9vZGUCooXtjXz402woUFtuNtoOdUHpJ0dFg7OQ4CDI/wwwDXPu+
	 OowIsoq2M+V3SD4NqX7TEI272+RiUB2cwRVnlEh9g8eGL56v4lcJYxJNxnmsM2H6A9
	 TKcIWe4d3foqCtzelYSShwIHeBcirJuw4nhYiYvwpwmAHS0Gfyod3Inp7kQrcFBnJF
	 IxkN4IUiJS1gw==
Date: Mon, 22 Sep 2025 14:46:29 -0500
From: Rob Herring <robh@kernel.org>
To: Ajay Neeli <ajay.neeli@amd.com>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	krzk+dt@kernel.org, conor+dt@kernel.org, pedrom.sousa@synopsys.com,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, git@amd.com,
	michal.simek@amd.com, srinivas.goud@amd.com,
	radhey.shyam.pandey@amd.com,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Subject: Re: [PATCH 1/5] dt-bindings: ufs: amd-versal2: Add support for AMD
 Versal Gen 2 UFS Host Controller
Message-ID: <20250922194629.GA905336-robh@kernel.org>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
 <20250919123835.17899-2-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919123835.17899-2-ajay.neeli@amd.com>

On Fri, Sep 19, 2025 at 06:08:31PM +0530, Ajay Neeli wrote:
> From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> 
> Add devicetree document for AMD Versal Gen 2 UFS Host Controller.
> This includes clocks and clock-names as mandated by UFS common bindings.
> 
> Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> Co-developed-by: Ajay Neeli <ajay.neeli@amd.com>
> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> ---
>  .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   | 61 ++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> new file mode 100644
> index 0000000..9f55949
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/amd,versal2-ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: AMD Versal Gen 2 UFS Host Controller
> +
> +maintainers:
> +  - Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +properties:
> +  compatible:
> +    const: amd,versal2-ufs

2 is versal2 or gen 2? I read it as the former, but everything else in 
this patchset says the latter. compatibles should be based on SoC names, 
not versions. Or does "gen 2" mean Gen 2 UFS specification (if there is 
such a thing)?

> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: core
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: ufshc
> +      - const: ufsphy

"ufs" part is redundant. Drop.

> +
> +required:
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    ufs@f10b0000 {
> +        compatible = "amd,versal2-ufs";
> +        reg = <0xf10b0000 0x1000>;
> +        clocks = <&ufs_core_clk>;
> +        clock-names = "core";
> +        resets = <&scmi_reset 4>, <&scmi_reset 35>;
> +        reset-names = "ufshc", "ufsphy";
> +        interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
> +        freq-table-hz = <0 0>;
> +    };
> -- 
> 1.8.3.1
> 
