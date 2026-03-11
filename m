Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34811234984;
	Wed, 11 Mar 2026 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773234648; cv=none; b=DF4fYK6tQZppJS99NZwAggIEjpmslf62fqsS4Bv8Jwtj5bu4ObstWfJku8Gzo06RVic2muVu2/frNfe4V09VMg2I2wX5ULPq5iKS6DcvqIwLAWsaIUWVLjVHljeNrdjlqfTaesPpPnAgxxPYNFd9p28Tu0ZelHwTmxuosczHBYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773234648; c=relaxed/simple;
	bh=I1WbPQA5NEIo1AGI5Oi8bYm76YQx+F1VeHq/ntSHCZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwQOcKpwjyVO3l6xcE2lXFgD8pQcUvXrv+TmpeRrtuGe/ivcEjEqWOYP8F35voQur+BtuLwmvNPoXR2LZ5ELk4zJIVoiJqIXpyISAcRkoH2sxpq49t+1h3kl/ZVp2xhbhXqo7YIB62G7GvUeIyy2q+ND/xCYmTHgUHp/GB12ES4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXrDLokL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXrDLokL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA1FC4CEF7;
	Wed, 11 Mar 2026 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773234647;
	bh=I1WbPQA5NEIo1AGI5Oi8bYm76YQx+F1VeHq/ntSHCZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gXrDLokLmDYfK9g+e3VHMWaQdVmejzQpJg5uErLMgOSalsrGXf9T7mbaRXkwXrJjL
	 2O9SoczvAdFdUA6tJ0Fbi8BL4/KI+y4Pg7daOEb4X60iUw8yUMLHCpUzigu69mnPBQ
	 UBCqCWvQqtsu6m8BOwpT53MnLbFI3lAN4s4oG43unJnFL2BWdxyz5M7nCaHJYD0Pkr
	 yufuUq72l0UBqiGt8eU2/JpnPeCnT4Gvr8fdNgWNDwGZQX7dOvdw4PrDim0OepWkoX
	 C3DJ+QTs9VxiPiPmJHDkkaaOU4joVE21dvMHYjg+pB6NaDNzUShxiM4rHR+N8iPYY+
	 B0981YH066GgA==
Date: Wed, 11 Mar 2026 14:10:45 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 1/2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
Message-ID: <20260311-ultraviolet-shrew-of-management-ca536b@quoll>
References: <1773193218-215988-1-git-send-email-shawn.lin@rock-chips.com>
 <1773193218-215988-2-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1773193218-215988-2-git-send-email-shawn.lin@rock-chips.com>

On Wed, Mar 11, 2026 at 09:40:17AM +0800, Shawn Lin wrote:
> Add the mphy reset property to the devicetree bindings for the Rockchip
> RK3576 UFS host controller. The mphy reset signal is used to reset the
> physical adapter. Resetting other components while leaving the mphy
> unreset may occasionally prevent the UFS controller from successfully
> linking up with the device.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
> 
>  Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
> index c7d17cf4..e738153 100644
> --- a/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufshc.yaml
> @@ -41,7 +41,7 @@ properties:
>      maxItems: 1
>  
>    resets:
> -    maxItems: 4
> +    maxItems: 5
>  
>    reset-names:
>      items:
> @@ -49,6 +49,7 @@ properties:
>        - const: sys
>        - const: ufs
>        - const: grf
> +      - const: mphy

ABI break here and in the driver. Considering this was merged year ago,
so for sure it was tested and was working. Otherwise commit msg would
explain the actual bug affecting users.

Best regards,
Krzysztof

