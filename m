Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A62495053;
	Wed, 30 Sep 2026 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790765019; cv=none; b=mDEgZ4VboZ4+L67g6N1FToMGnlh+XfzvmdhZb6uyJ556HN1WOn+xKYZMH9BlBMZJI5wTBBJh1gsXuuw4PJakgi+HN5NJdTujbnKq45YNDxTZ9PeKJ18wukW2u1/xtUdL6CHlGHoIcRohmonTlovOTRtkYUqdSmLwpb4oLCSDB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790765019; c=relaxed/simple;
	bh=KypAfSkK5BPNc0SQvHY51D9K6dH/91sZIh2l5oE1Yps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkpJo2Sel6+MZDqp9pX1VPKJjf4/DJTGsc/7IGQCy6brcXEGY+MpRhOfIeR3rmGjZ65jOyc5vHaHiOOdqgyZT9DjIHuUS3lpDfnZ2IwmS9R0ogPKSzj2WuWE/mknk0aXRvaUI6qXqA1b80fvoRdNbxkV6mmsdBOwo5kANiFz0SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhdjDth0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhdjDth0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1D11F000FF;
	Wed, 30 Sep 2026 10:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790765005;
	bh=2CcZrOPTiCuVQgzPeyWPgbcli8oYwkOTwjzeDcYF/E0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nhdjDth0mzr7QWhMFksXyISNw53E9mrT+UZnzst7nzcu9H9e9VtZpLRtZ4Igy6amv
	 u8ztHCeDN1cxVsUJfLahzebQnU9oMDLrQDZX6dplkZsgT8LU3YeJ24wQct8lRiD7zw
	 L91ItOdsSEvMfrWGJWaYOsMESP3VpXqEDqPChvxWyCyHA0Dq3VX9dUU4OOO7H9QZmB
	 wXWuGaxqcv6b8wvaDzGGPizbIkXBNJwM+HneEJsdqQoDs2DOjXPO8BLQDuBog65hPp
	 7ReWVNUz4/k8eSXxQWypGZpcx5Zi1vDItsSiCpD1KXHV4+5wUdeek5Mel/Wf9gp6DQ
	 JX/9ONnsFOUmw==
Date: Wed, 30 Sep 2026 12:43:21 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Thierry Reding <treding@nvidia.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
Message-ID: <20260930-hopeful-hasty-eagle-052982@quoll>
References: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
 <20260929-tegra264-ufs-v2-1-f0467b9c503e@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929-tegra264-ufs-v2-1-f0467b9c503e@nvidia.com>

On Tue, Sep 29, 2026 at 03:15:07PM +0530, Kartik Rajput wrote:
> Add binding for the UFS host controller on NVIDIA Tegra264 SoCs. The
> controller supports UFS 3.1 up to HS-G4B on two data lanes.
> 
> Signed-off-by: Kartik Rajput <kkartik@nvidia.com>

I do not understand why you added dependency on the phy in this
patchset. Looks like fake/not real dependency, so you only stall your
work and raise questions.

Cover letter mentions "the binding references
the M-PHY provider" but this is simply NOT TRUE.

Patch itself is correct but I suggest to be careful what you send, to
avoid questions on trivial stuff.

Best regards,
Krzysztof

