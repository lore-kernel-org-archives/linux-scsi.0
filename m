Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8FD29AAEE
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225362; cv=none; b=sP2OBIbVdplJh9Avd3RENDOY0vgkv0BPA8Kqvr0RPnvRpQ7YOo0/7Qq1Ptsf+7579O/VJm8XAbroemUrGYKdkOzUvGPtfxZOEsNAmMwuf7djrpobOnpdRiwSkzU/81yHT1v3wu2LsG1lMxGgHFaNczXiphUyar+CeKYsLOQBX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225362; c=relaxed/simple;
	bh=hRZkE93/EZrModhMWizbKIdtSs5NxN3kHlgE0FN3U1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdtlmgv5VNj5cMpsScHsrI/C6oF6zkonCxUnNemcFqBt652j/O/7MWpWPY4K7N5NcNV+kRX7mfqQS/VLNlSkEpb21EEviKxPlh1CnavWeel2zdgH8CRogF/2wYtwj1Ge46Gm11B82/ts7Ol/ehBxMFqT8oH2YBAU+sEtRZ6njlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMjHmxoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMjHmxoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75491C4CEED;
	Fri, 15 Aug 2025 02:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225362;
	bh=hRZkE93/EZrModhMWizbKIdtSs5NxN3kHlgE0FN3U1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gMjHmxoNvwDGWEeX2Hes8Xs/QkKvGMCzFz+fjZiljJx3SKMEcz5xIyVhpIyeYKjdS
	 6fw2RUIfGyf0q/iedqqV6HESU/sTqxTpNKvm50HAnV9yC4vSBdwbW2f8hiP351rCwg
	 8FpvYWCp4AXGyffjSUgRxmsLjlBlzCu8YHziUT1ehtnDJtBoZWR9lujlAyn2lK4dVS
	 nU4tukfp9HmdN/8nuNIyTcjpwQka5Y7OhtcusiNUdSO4CAk3iLiebP6uie2cTrinn9
	 CVGs9PhJRk6ddx/qZAhctdZQyk2J0fgv9Bb5uUimieIXsJ2PxLweui3tMFafn95ENv
	 PLGwub2/S49/Q==
Message-ID: <2d9dca28-1718-4799-99ca-ac1e6b4e35f4@kernel.org>
Date: Fri, 15 Aug 2025 11:36:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] scsi: pm80xx: Use pm80xx_get_local_phy_id() to
 access phy array
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-22-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> While the current code is perfectly fine (because we verify that the
> device is directly attached before using attached_phy to index the
> pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
> anyway, to reduce the chance that someone will copy paste this pattern to
> other parts of the driver.
> 
> Note that in this specific case, we still need to keep the check that the
> device is not behind an expander, because we do not want to clear
> attached_phy of the expander if a device behind the expander disappears
> (as that would disable all the other devices behind the expander).
> 
> However, if it is the expander itself that disappears, attached_phy will
> be cleared, just like it would for any other directly attached device.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
