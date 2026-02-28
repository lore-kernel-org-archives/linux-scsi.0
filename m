Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFFD1F2B88;
	Sat, 28 Feb 2026 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772269058; cv=none; b=a8LMpZZdOrdmnUZggEQb9DxZyBxmYqSNMNKjyfxkfv4/9FooHfW0CifNr+RmzmdYqrU3R3X3aApur6qKIjV9N0Yphd955Im4yQE1mu9bFZmSQUCHnDFs+b3TyuJlmqRTiR3qOqGWGNohVjZ9QUhZb4z3WqOV9uVk2QsDBv2X4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772269058; c=relaxed/simple;
	bh=wHkGGRKT1DvJCaDIVkIqM68dxQAF3VVQWH1ZOfqNdPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suuOISQh3vqV0eyk/f3QfzRQP103ZHwqj8Gea15rRvFnYH9EmrwE3yDMRp9v9clP9eFk5j5VCbXvOtT2YDIWdXt7kpSgEnxprNZBxNygs+Hme8Iv6xTavIRCwr02V255VOFvVehYCgrYF5MZUWtFbFHVXDgzB7S0zOoiOQDcI8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WYi5Fj19; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WYi5Fj19"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bCU2ngREEoQR8r3kCCgKGjlvPXvc1aTerf/ElVfvglA=; 
	b=WYi5Fj19FNknyzhCUAfQ3fQakDIB1433kp1RWcCoHYhc40gVlSXxyISsqRp50vmSPg/uKVLZzQL
	88FF2L9mhmeExvYbEqubnbdptCP77894jUt4ISlH1/FlU05Y75ixt68dqTKOaiFJPB2RAorgOJfv8
	bjD0s98zq3tJhDWQQe4gIXcu1xggHWEcjGuSz73ZUPjvTHY0mC+vjrZIeAid5G+0YEliCpuChKnE6
	Ar0ZHjbhc2fzDWdcKqtWEh8BLYqLMFrezwHHsDY3nZEHQlQepdylTIujqS/Yr6VtWrIFiIDqy2L6Q
	v79TiKvhH5jZhFDENgsKRUa4zuTxh0SgDVqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwG8a-00ADzc-0S;
	Sat, 28 Feb 2026 16:57:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:57:24 +0900
Date: Sat, 28 Feb 2026 17:57:24 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Message-ID: <aaKt9PET6lVkBcif@gondor.apana.org.au>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-1-0c5245117d45@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-1-0c5245117d45@oss.qualcomm.com>

On Thu, Feb 19, 2026 at 03:09:13PM +0530, Abhinaba Rakshit wrote:
> Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
> by allowing the use of the standard "operating-points-v2" property in
> the ICE device node.
> 
> ICE clock management was handled by the storage drivers in legacy
> bindings, so the ICE driver itself had no mechanism for clock scaling.
> With the introduction of the new standalone ICE device node, clock
> control must now be performed directly by the ICE driver. Enabling
> operating-points-v2 allows the driver to describe and manage the
> frequency and voltage requirements for proper DVFS operation.
> 
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
