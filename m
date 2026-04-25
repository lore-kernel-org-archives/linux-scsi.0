Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BD38E12B;
	Sat, 25 Apr 2026 22:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777157628; cv=none; b=Liz7alvNxPLjGrN9r5a85BEeYSrU02imJRz3/GJ8lceGw1Hxo6+YFytOA7Ky4LrzCGvUQufvGfzfJSa+pgMlDvd4Pp/iG/Aw5DbYvqFR8GuUnl9FwmBZmDiv1HzWkb4QQ0A623jynb2qM5pAcdYQ3epytb0b/oaBeH/GmY4rRHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777157628; c=relaxed/simple;
	bh=ZZMakw+7RV0e/1eo3Ip6oN2ri0j16KMh87YL5yJz3+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GP9/li+bhbRN5G/hc2SIJa/YCp5lyJOeJYgGrneWzvbkufxfsU/ughv0WOfXf8ce2yP8l6Chy091z5Uk5vIAi7m26l1TmqBdtG/j6zojPN+vTLKZQg4ksaOBgWINX/KgObpkOPDXHzxAgnscEn/w/9p0nMDdRHG2cI1DkugrxRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MO9IIW86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MO9IIW86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4442C2BCB6;
	Sat, 25 Apr 2026 22:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777157627;
	bh=ZZMakw+7RV0e/1eo3Ip6oN2ri0j16KMh87YL5yJz3+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MO9IIW86r0DNrb3OrOVPv6Vy82R7i641RrJFF66zHBfpkT/M4MpT+uNzZsnm5F5kN
	 UeAVREmiklTrXiQLYAELQQQhI6Mb53eAkqLzA4uzoMLjIRsUbdQgM1nmF+8BaN7i9n
	 cgSFzC07pMykJdYZvFdAE9MFqyISpOyVIUZso8q8MeROQ4sv5EcbK3ec9rtGGn+11W
	 XoN1nT1T1kfg9FkGeWVwg8vsLsa+WcigvFxA10F4RLrhashQ+CBfrqg0NWUeyWFAs3
	 81gAzOcjcV+MNLsyOaqcnNS30qywAYHdefIYRe2uuar97V0cXWd0uFB6w4M0UndfUi
	 CK1Un2JGC/x0Q==
Message-ID: <e8d237bc-7191-4881-924b-86a34ff0f3b9@kernel.org>
Date: Sun, 26 Apr 2026 07:53:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata: libata-sata: retry hardreset when device detected
 but PHY not established
To: Xingui Yang <yangxingui@huawei.com>, cassel@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260425060447.1312763-1-yangxingui@huawei.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260425060447.1312763-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/26 15:04, Xingui Yang wrote:
> When sata_link_hardreset() detects that the link is offline, it currently
> returns immediately without distinguishing the reason. According to SATA
> specification, the SStatus register's det filed (bits 0-3) indicates:
>   - 0x0: No device detected, PHY not communicating
>   - 0x1: Device detected but PHY communication not established
>   - 0x3: Device detected and PHY communication established
> 
> This patch helps improve device detection reliability and adds a check
> when the link is offline but det filed shows 0x1, return -EAGAIN to
> trigger retry, rather than giving up immediately.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>

This is a pure ATA patch so please CC the linux-ide list, not the linux-scsi list.

Also, please check your mail setup: your email was in my Junk folder.

> ---
>  drivers/ata/libata-sata.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index b9d635088f5f..e5bb92c38e38 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -667,8 +667,18 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
>  	if (rc)
>  		goto out;
>  	/* if link is offline nothing more to do */
> -	if (ata_phys_link_offline(link))
> +	if (ata_phys_link_offline(link)) {

This is preceeded by a call to sata_link_resume(), which calls
sata_link_debounce() and that function makes sure that DET is stable. So if
after that DET still shows that their is no PHY, there is likely a big problem
with it and it is super slow to be established.

In this case, I do not think that doing another hardreset is the right thing to
do. Have you tried increasing the deadline for hardreset ? That deadline is used
as the limit for the link debounce too.

Do you have a specific controller/device where you see this issue ? What exactly
is the hardware setup where you see this issue ?



> +		u32 sstatus;
> +
> +		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
> +		    (sstatus & 0xf) == 0x1) {
> +			ata_link_warn(link, "device detected but PHY not ready (SStatus %X), retrying\n",
> +				      sstatus);
> +			rc = -EAGAIN;
> +		}
> +
>  		goto out;
> +	}
>  
>  	/* Link is online.  From this point, -ENODEV too is an error. */
>  	if (online)


-- 
Damien Le Moal
Western Digital Research
