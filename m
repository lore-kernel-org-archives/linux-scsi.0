Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0AC11CA1;
	Wed, 17 Jul 2024 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721217923; cv=none; b=LMO8ml8XGeXC4qs/b7UeVYmoIb6O5N1JFXLkUzU63+o+4HV7wXFX7yFO9R5Uj265V99DXF/FIEHicz+rg951OZFxL9eN14x86qm8NUJjVbu4hiwFC4Ej0RkyMKBjly4M/PEPCtZeaObCTZFFcES5nuRkdzBqRx/2cpkBTA8ca7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721217923; c=relaxed/simple;
	bh=sVI4fR38SQDvsyIf2h0jFKNxER8xVabHLmTsacru0pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G30rA0qf9C9F7pySlcbNczPC99qFeG9eL1hWBjymaNLUCvfH5zzG1Zo0jQwLwpdvxO+3LpYy7KKFopQPFhodow8xDhqe5jOhyzFf//bxb1omBOdWx5TDLxDt82pxqhCZOTgFfEJXchtY95EYYNuuShH2mXFTaEXcQjSS4UvoXRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JF115C7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JF115C7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA00C32782;
	Wed, 17 Jul 2024 12:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721217923;
	bh=sVI4fR38SQDvsyIf2h0jFKNxER8xVabHLmTsacru0pw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JF115C7Ovr1n4UIbJhCELCffi+TsMEuAMX7Yz4QjjldakDI+MGTHCOxRc1Tp5DP6S
	 PxRGV74yMtltdWXkUhYhBs3wPmdyYJDqUcBIGIhsi4L8pOHyaz9Q8t4NxxowVgaoSL
	 a7oJYZLnKMpLgME0eiKPfiXq0cKKy1zW/7Z68RWBKzqkcxJSgyElQ7x/64WezJ+nLI
	 xhuOrV9O5i/eqBezDXYR1t0Y/X2x5R6CoWqP8KAe22ObIxVrZUZMKhO+FdBxXFpUZ+
	 AOrrN4Am78xNMj8XI9ecErt79xTmX+cn2rbhwdyjLrBJCbJjYipIkL9t4/suXhNRUh
	 25yfuUawdR7Qw==
Message-ID: <95e9ad8b-7d3f-4516-a603-488cb229a2c9@kernel.org>
Date: Wed, 17 Jul 2024 21:05:21 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
To: Johan Hovold <johan+linaro@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20240716161101.30692-1-johan+linaro@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240716161101.30692-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/24 01:11, Johan Hovold wrote:
> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.
> 
> The offending commit tried to suppress a double "Starting disk" message
> for some drivers, but instead started spamming the log with bogus
> messages every five seconds:
> 
> 	[  311.798956] sd 0:0:0:0: [sda] Starting disk
> 	[  316.919103] sd 0:0:0:0: [sda] Starting disk
> 	[  322.040775] sd 0:0:0:0: [sda] Starting disk
> 	[  327.161140] sd 0:0:0:0: [sda] Starting disk
> 	[  332.281352] sd 0:0:0:0: [sda] Starting disk
> 	[  337.401878] sd 0:0:0:0: [sda] Starting disk
> 	[  342.521527] sd 0:0:0:0: [sda] Starting disk
> 	[  345.850401] sd 0:0:0:0: [sda] Starting disk
> 	[  350.967132] sd 0:0:0:0: [sda] Starting disk
> 	[  356.090454] sd 0:0:0:0: [sda] Starting disk
> 	...
> 
> on machines that do not actually stop the disk on runtime suspend (e.g.
> the Qualcomm sc8280xp CRD with UFS).
> 
> Let's just revert for now to address the regression.
> 
> Fixes: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

