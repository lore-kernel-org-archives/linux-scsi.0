Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AE63803D9;
	Fri, 13 Mar 2026 08:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773390176; cv=none; b=mhMyPvvzQO5BDIrJJ2ZcYG+xXiiJm5Xf91JTLGK+aouvyebjt6fhtIdXVzRaXslyx0ofcIobGDMdhUJ3PLI6nA/7sh0u5ka3ChQhLAuWLKZZn/GTzUaHUrjnVIRGSrVsBWlMwcHcSpDl/BwisYIzpjnK9QKQBo30d5Vn5i12Dq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773390176; c=relaxed/simple;
	bh=FFMDDxaT855Ix/TDP2Ll6xNFFN2aEjqsgnS1fdXsQlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YojwKw3ckrZTdL4HqeAxfjDmxorNoKGaXTYeWeVsVDiq0GUn2Vllvh/xHCmjgPJjfV/U/Hc9yj8teYcr82IQL5xcA2/ot1gGGYYudIQYmNq8UR1kHDHXrS6QzN+Y/fFQDa5AVbwAmCBH319Z7oigd2cJMLg7AW0QU5BDabrKvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EemAqlKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EemAqlKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28B0C19421;
	Fri, 13 Mar 2026 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773390175;
	bh=FFMDDxaT855Ix/TDP2Ll6xNFFN2aEjqsgnS1fdXsQlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EemAqlKNrWIu3cLWwARNCP8JU0mlyJ+/4OimrZmunnnXZU9DTGUyniyNQWd+le20d
	 A+zJplE8kdsvz/uM6G8FqChKyjrwk+Ypamo4/Fxh2bt6TUaXRRuUBG6fdh+y4r7HSh
	 9J2sYNTDh2+1RynrsCs9Ugp1lX9ZhY7MSaa7sIJEQS2VKnsRhde/yN1DCH9j/6cTGU
	 7gVcDrmEmOvPCKRGzLEOe0UGF0GjLucfPY+bQ/5kWRPPggGQbn9Lz3NfRfULP831er
	 ++Q5b7Ctz+c7op+wm58J/zCNxxqsDscF4zqjAyaMcpYh1QT8pKAVTpEJRwlQIhWQbn
	 YBEKdMeoih8xg==
Date: Fri, 13 Mar 2026 09:22:52 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Heiko Stuebner <heiko@sntech.de>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3] scsi: ufs: rockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
Message-ID: <20260313-attentive-gharial-of-opportunity-b4b254@quoll>
References: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1773368467-109650-1-git-send-email-shawn.lin@rock-chips.com>

On Fri, Mar 13, 2026 at 10:21:07AM +0800, Shawn Lin wrote:
> Add the mphy reset property to the devicetree bindings for the Rockchip
> RK3576 UFS host controller. The mphy reset signal is used to reset the
> physical adapter. Resetting other components while leaving the mphy
> unreset may occasionally prevent the UFS controller from successfully
> linking up with the device.
> 
> This addresses an intermittent hardware bug where the UFS link fails to
> establish under specific timing conditions with certain chips. While
> difficult to reproduce initially, this issue was consistently observed in
> downstream testing and requires explicit mphy reset control for full
> stability.
> 
> Although this change increases the maxItems for resets and adds a new
> entry (which technically alters the binding ABI), it does not break
> compatibility for existing Linux systems. The driver uses
> devm_reset_control_array_get_exclusive() to manage resets, allowing it
> to function correctly with both older Device Trees (without the mphy
> entry) and newer ones.
> 
> Fixes: d90e92023771 ("scsi: ufs: dt-bindings: Document Rockchip UFS host controller")
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

