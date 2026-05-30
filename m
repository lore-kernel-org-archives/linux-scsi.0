Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E903AB5BB;
	Sat, 30 May 2026 11:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780141000; cv=none; b=PDIo9W8+ZNnAgtkMcisyJJ/FWkxxOU6k3yUZm8ohJC+AvwipO2LvqvA4REKhf5vUFhuwyS+qZ4g1YM/f4m0oTqWzG0wm8cW2aldjU0/Ackhdpp/GAK/sTm//Rfk6PZpAf3I5Kd1FbJY8T4/GcHh+JjXn+R6/O6VNNve7WuTB45c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780141000; c=relaxed/simple;
	bh=P8IY2LzuNiHoz9ZVBGoltK/59OemqKVU2k36y/+JBik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=am+ZVZUatnjShkARNJ0C7gcb/9LkMc60KG9RaQUoMyYSjW4wswCmEviYQLMPhsGh1FdNqeq87c0he2kngGNmvNtol7i/FPKdRSBD4jElz9ryT7/TbH4mKUYeZtSHNxXEeVbesBj2DmQhOSM9o1/x+LHDMLhQU/eFJRylISL4r44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MTeQhB4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MTeQhB4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37581F00893;
	Sat, 30 May 2026 11:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780140998;
	bh=ASVwj8JSQW3qm8JAF74jGWlBWdyvnyVyn90w48T3iIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MTeQhB4mmeI+sPjpKNnyb5J5CrvVt9iMSgTu2WAQAg/8Z1MMQlALunlWy+BRfBpwP
	 t8Br2f7NLSE1YsM8EYhCmQezVQ3UKbxgGzB+6vY8C29HpC7wTOfppLp5lF+E9YU7xL
	 iKwmOqTmUGJ4ypBwIeZmEOu+qJH92mg55RdglkHBRigDsM30yZLkI986Qf+vnvD8aN
	 itMhxE2z+1F1ha896jae28t5koh3m7KbwfFzqBcvbzasXPnRFU3cZFigY3nVhXxLAt
	 8B99i2UrPGCeUtPfw6czH0V9ZxcaftSJ5imY1m14wbE4skzNliQPPT4OkRjNP/CvJn
	 m4u1uEZLP48aw==
Date: Sat, 30 May 2026 13:36:35 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, mani@kernel.org, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Zhaoming Luo <zhml@posteo.com>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Message-ID: <20260530-invisible-pygmy-beetle-57e659@quoll>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260527144055.2758170-2-can.guo@oss.qualcomm.com>

On Wed, May 27, 2026 at 07:40:54AM -0700, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
> integrity at high speed operation.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
> required depending on channel characteristics.
> 
> Add vendor-neutral DT properties:
> 
> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
> - fixed property tx-precode-enable-g6
> 
> Each property is a uint32 array of per-lane tuples:
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
> 
> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
> 

Why are they SIX versions within three days? I see this for the third
time in Patchwork already.


Best regards,
Krzysztof

