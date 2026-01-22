Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D115F258CD9
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769103019; cv=none; b=RM+LAgOvFfxbGERkrUn9tRisOBQ9l7ABLzvvveH45j93ugqLF/TP5ys7//z+yQUTM+/8vsxhMJKPi3wpH/dmM4eGlZMHYfqt8um3PIbHPK5K9Nji+l+Rzm0/x9lk91oKWkOG0i9X9oXl5Mt7bkIUQzO0tFYuxH1ZMuIY5LD4iHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769103019; c=relaxed/simple;
	bh=8QNBzMPghCOM7ZYUHPaPh/rur2a5RCd1YipM1oEp4NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBz2v5fGLl4yyUAAlImqmjTdTITmA6x1QchDMEePZ3y0Enu2bBO+G5LcGEkfed3WYLZt+hl62F5iULaUwmica7LWj2ZAXNr41lBcT3LuQNnZ62XSeRl6AMKdpO6oGSv45+T7+PlsuxcuTDJFQnQVMSAtlF81/eZyIGWA8/rhOzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F38KOQLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F38KOQLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AFFC116C6;
	Thu, 22 Jan 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769103018;
	bh=8QNBzMPghCOM7ZYUHPaPh/rur2a5RCd1YipM1oEp4NY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F38KOQLmd8FUJO3draQHdnfJlcR5LUiDQyO8P6YVyaheYyGA6j2vmYC4lmfXA3npN
	 PX5EVXtBRltI0CYfd0xKxH/iIVYZ0cmJj0Uw1zDhWdDlue4kTVih8SqNfyphwyLxqu
	 v+u+mWpqBfPjY/jfBsbgqi5839OZLS1NXhuRkwhyI2UO0GkZtsJtw/qwB2YmzlxfYE
	 W7hhmRoY93PNrveWvZK+cNOc8H1yc0IEpJnpHLuGlwYexbzos24b+hSixnsUJ4ZPES
	 D770d7PyjggVZh9ad61yFQLMN1cnMOG9k24w5JMTSSSVPZwouqV5ZwdUJKpeV2mh4I
	 ECBA2L2PfV11w==
Date: Thu, 22 Jan 2026 23:00:12 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Nitin Rawat <nitin.rawat@oss.qualcomm.com>, 
	peter.wang@mediatek.com, alim.akhtar@samsung.com
Subject: Re: [PATCH 0/7] ufs: Remove the clock gating code
Message-ID: <r3upegmcqg5fxo22u63dwtwrlc7qpwi57drlvujtw4jkbinx7f@xluie2klyr55>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>

+ Nitin, Peter, Alim

On Fri, Jan 16, 2026 at 10:26:02AM -0800, Bart Van Assche wrote:
> Hi Martin,
> 
> There is some duplicate code in the UFS driver: both the runtime power
> management (RPM) code and the clock gating code switch between the same
> low-power and fully-powered state. Since the RPM code is more efficient,
> this patch series remove the clock gating code. This change has been
> realized without modifying the driver behavior and without breaking the UFS
> driver sysfs interface.
> 
> Please consider this patch series for the next merge window.
> 

Hi Bart,

Thanks for the work! I did try to get rid of the clock gating feature a couple
of years ago as I also thought that it duplicates the behavior of the runtime PM
framework.

But when I discussed this change with Qcom UFS folks, I was told that getting
rid of clock gating will have a negative impact on the runtime power consumption
on Qcom platforms as most of the power hungry resources are gated by the clock
and there will be added latency with going through the runtime PM framework.

Nitin is working on measuring the power impact of this series on Qcom
platforms to verify whether the above concern is really valid or not. So I'd
request to hold off this series until he gets back with the analysis, since this
series is very critical for us.

It'd be good if other vendors like Mediatek and Samsung also carry out the power
impact analysis on their platforms.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
