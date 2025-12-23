Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2152D34D4EF;
	Tue, 23 Dec 2025 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766511601; cv=none; b=DXmXgGrMS1MfW1E4RT44s+9KmjU/qP2CDaMifVOMPEQKjEQ86iE5YlO6sHcECi5BXz8p99seMmg40HqrDD1sGPf65kHq/+rkX/pEp0ltm40m5hCBIPLQyZ11cXJYaG/JTEnO3cBYCZNUT6DPMwp3bfTWgwXuHAhm5yiEmvZW0mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766511601; c=relaxed/simple;
	bh=mg+xr84GsG3acMHvsNiCgu+mhovC0ULkrlsg5Zc0wB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHrJVu965qLpg//SZkwveQ8ShIt3kK9GPpLp+JeIhZHytIzKDcOBWMFgyaxGJZ0CKOO95SFZ0z4gsEJS7sGgaStLM22ahKQh6VUdcnVpWBDdhZ2ulZGOtl+lepsLfZznaU97j5lHtdzAegZtu1ccAUM3MIxsSR14hhuos5C8eao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnjDSgeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnjDSgeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F96C113D0;
	Tue, 23 Dec 2025 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766511601;
	bh=mg+xr84GsG3acMHvsNiCgu+mhovC0ULkrlsg5Zc0wB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gnjDSgeDpiEOWDb0Q/UicZgdmWitjgbpqA77fEs4NCvPTov7e9DMj7XG3yTGE/oRD
	 CZzhhz3V2RlTMW7+G6ML23B0q0Zz4CV1MfDhzyhV8ncLMHn+ys3+V1xMjbgB6YUZvF
	 PIHBoR9SeHN0oBp1Ej7yv9uswRlcwNWAvT/Q4M9s2axotPD5dRzW5e3bgxAQJFgYq/
	 8OMFVId6FsiNJWamlE8wMRlnBmw0JTDQJ2Mszs4dShfOyJQr015/v/DcZemF64bwTK
	 1AgoFL1SPYlDQ7sR62eMK0ZNoiDMuJVwSoEABjDjUXWXMVYZWO0OlQAU7BDeTtAgVk
	 RnezgJuAWnqOQ==
Date: Tue, 23 Dec 2025 23:09:57 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v4 05/25] phy: mediatek: ufs: Add support for resets
Message-ID: <aUrT7R41XJk07Esf@vaman>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-5-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-5-ddec7a369dd2@collabora.com>

On 18-12-25, 13:54, Nicolas Frattaroli wrote:
> The MediaTek UFS PHY supports PHY resets. Until now, they've been
> implemented in the UFS host driver. Since they were never documented in
> the UFS HCI node's DT bindings, and no mainline DT uses it, it's fine if
> it's moved to the correct location, which is the PHY driver.
> 
> Implement the MPHY reset logic in this driver and expose it through the
> phy subsystem's reset op. The reset itself is optional, as judging by
> other mainline devices that use this hardware, it's not required for the
> device to function.
> 
> If no reset is present, the reset op returns -EOPNOTSUPP, which means
> that the ufshci driver can detect it's present and not double sleep in
> its own reset function, where it will call the phy reset.

Acked-by: Vinod Koul <vkoul@kernel.org>


-- 
~Vinod
