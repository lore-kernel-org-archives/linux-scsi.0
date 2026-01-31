Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E014A60F;
	Sat, 31 Jan 2026 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827872; cv=none; b=PzWz7gASktKCPizKq5TcPjfl7Q4pFx6WISzp5CyHh123tNLiHuekI1uTBhEXQq2b2Muj2osmTTGIgoQKzCMNaAplgQ1pMQOu5QJN2Eb4t1gJcmvH1J3j8v7FuCsh4/CerAilq/ypoQ8jPL+OMwPHlOFAQjo/LtRwZxHWALag5eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827872; c=relaxed/simple;
	bh=z2IUnKDxCffO/oajqBFwUfRPGVi7JlF9z6BsZ+0SCVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7WxjgSEnXVqQ6qDJBsIy9Fjf36vOLgVzNJJF83qvT9u/22prkJWqhUqsbr5+2L9HNJz6SWUGXLiUNFD5d9RMX2iualtYvG8KfJ9f9E78pArvmQHdMj9tilQmMp1dVdLqRFtvuL4XJA+hDfOKEg8EPvf870eYcxEsy9S5O8WHXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bS7F/nbd; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bS7F/nbd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zHrmQwFLqA3OLiwbqOe/h4SuxVGBdkNc6DkN33Q2rhs=; 
	b=bS7F/nbdMYLt3Bs8D0c9yg4djWYLv7cpXsdW3jahmAHVbcm9vR/EYuWY6+cjmYKKO7L7IevJO5c
	uSwhPL7dPgEEXO3hyshrJuzl4H+RLnxZrM/nW8hNfdwlvbLHvZu6EtzBpDEcxOSn8ZfSYCzEBQ3Fc
	IqWGqSgRkQjoj6wf3MxFIhAW2dJSrkhud0GHa4NLx0zB4+lSLaTHOXsG5MdyBnlsx9mijQomzW4d9
	nTH9yyU0c4SzDra0tftXwTNEE8HCOs7a1yTC3vvYhyWz6k9pNu0IXyGeZJ+aY6NUbLV4z93YFcG28
	nfoHo0XAM147lFuM6SLWYzDHEMx1/JE0sdRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm14N-003Rv5-15;
	Sat, 31 Jan 2026 10:50:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:50:43 +0800
Date: Sat, 31 Jan 2026 10:50:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 document the Milos ICE
Message-ID: <aX1uAxZmO0ZR8c9e@gondor.apana.org.au>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-1-d3ce4f61f030@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-milos-ufs-v2-1-d3ce4f61f030@fairphone.com>

On Mon, Jan 12, 2026 at 02:53:14PM +0100, Luca Weiss wrote:
> Document the Inline Crypto Engine (ICE) on the Milos SoC.
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
