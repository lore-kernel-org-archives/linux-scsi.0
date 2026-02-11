Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A323161AB;
	Wed, 11 Feb 2026 22:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770847732; cv=none; b=W3gPo0yeuSqM0ntjhLuxwzoNGxF9BIs0yLhlUSCbahH1nFdSdi26NTXN13H1Pl1Yr3ioQFg23QEqrNyv621wdQGbwoLRX1deJGR9D5joTSFcY3uHcYiPKI3kTpxaCp9ZgHkozZZ8ssBWx9a8/zbMwmB0vnBEUwIY6m8+5R3nKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770847732; c=relaxed/simple;
	bh=/SIaAPBIuPMwbUuxhO/Sg0/HwCxN1y8RGt/Emg0k7V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OH7tmuL+5FERmS51Nh/8HDaVIs4eXS/4xB5/z3ELt+wlJSCl1KFj32f3MsHGe2ZzImGvr5zBLW/B9PkPVLCwMKdl/Z1kSXA7rIfr0oUJEXnEbjcpLMlRx59v3jBOPY5kYzh00mbcALF/BDOWtmJMQofk+WHkBERl1eGgYOMNgxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xb/gjgVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xb/gjgVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F54C4CEF7;
	Wed, 11 Feb 2026 22:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770847732;
	bh=/SIaAPBIuPMwbUuxhO/Sg0/HwCxN1y8RGt/Emg0k7V0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xb/gjgVxv1pFZtyDlEMQWHskUq1nTRX0tJIIkbFDEj8hoczEw5LbUdAIqVinYrTAz
	 OQNQL6coRjDNzRI0JYC6hj67y1gfR8l48DeEB61MlyNGxv1AkUj00LRkAFTSITTGI+
	 1He6u8KvjO9L/4YDBKv7JFOIkY3TKbXL+S/lpCF740XsTvSDkV6Wun1kagoc0Zpgd/
	 UCYSuEYV7wAcnlOhur7NKLwkzB6VMP6Pd/fe+gFuBVluLnLMUtA3Jz8gjpefssPh7N
	 a5imFETgDV5qve91M0Neue5zagE5r2+ikvfDX1BUb2y051mDYGKe+dUYgG1P7+I9E+
	 Fb5jWqC34W4Yg==
Date: Wed, 11 Feb 2026 16:08:51 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, linux-scsi@vger.kernel.org,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Message-ID: <177084773073.3975957.7006950267237342921.robh@kernel.org>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-1-221c520a1f2e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-1-221c520a1f2e@oss.qualcomm.com>


On Wed, 11 Feb 2026 15:17:44 +0530, Abhinaba Rakshit wrote:
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
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

Acked-by: Rob Herring (Arm) <robh@kernel.org>

