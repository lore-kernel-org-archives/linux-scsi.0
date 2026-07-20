Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2503B4EAA;
	Mon, 20 Jul 2026 07:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531533; cv=none; b=CtWMS9HEGg0/Cpn3bHPEUlp5xnN8SoHYcb05cfZx9fmxXtojOcNTPRmqw9U+Hd8MQwnBKmonJJ6P5nAAETbFdowCzbX+aTJoLZ1FZ8C3/Gxz5N0GtH3rzjAbYjElR2KEaZRF8H6p9NnrSeZ9KdSwN1Qrnhd4a63L9JhgNl1rV7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531533; c=relaxed/simple;
	bh=8zDPsDvfyhuuAAoi4F6JuZmZjhvSj+fGgJX046Fqhm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBgwbgowD757i6EuqOIpuWROtK/jf81+n6l8OzBe5CEXFLNHsRhvAyWCmdhgtMxFEamztBf7bKOtJAS+GqhT9EVf163rYh1jl5FJze956muVyW4Q78z5Nh74kpP9ULD5s7wJWdFFo5KhxckJeQl7szWU9vPkAh8Pf8YzE1IEQcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMA4h+HR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMA4h+HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1443F1F000E9;
	Mon, 20 Jul 2026 07:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531532;
	bh=w1BFQ9LbdJc3XcfTzDoZ6Fl6XHGumWf+IU7L/ndlLgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PMA4h+HREE7lawFrn+i+B7u30a7KUZeh92WTzB4wxFGwAienK/Qmw/0zwoyg3kucW
	 zR35jKdFvPF0FvWuPS/qBUwDGulw6f7aN3ezYPAlfUK9E5hCTKiW4273H2+MtG6HAY
	 yHQvY0brxZAPpXhrLEiZ/mqJNaXi3y9q24fu/kuZ0c37d6hmrnBdJw18bd6V2wpv21
	 wmjSKHRO8v/sermQgRtdgB9uRizwni5DrFuGv5wnmCAuveg6iisPyFFhoFgc43mepx
	 Fi7UGFayoTIuq8Jjf/Knk0Vu37pwX0tVY5P7lHGAkYrBGy+ajDSyhCByqmSrTnNC17
	 9L6tpT4XhcOIg==
Date: Mon, 20 Jul 2026 09:12:07 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, 
	Anjana Hari <anjana.hari@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: dt-bindings: Add missing mcq reg for
 qcom,sa8255p-ufshc
Message-ID: <20260720-belligerent-sceptical-owl-962e7d@quoll>
References: <20260720023552.2667237-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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
> ---
> Changes for v2:
> - Recover the newline which got dropped by accident
> - Link to v1: https://lore.kernel.org/r/20260716083313.2367249-1-shengchao.guo@oss.qualcomm.com
> 
>  .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml      | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

qcom,sa8797p-ufshc should require it, but nevertheless:

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

