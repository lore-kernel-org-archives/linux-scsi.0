Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0616936E;
	Wed, 29 May 2024 08:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970077; cv=none; b=kp/RzFlHHuq/U61DPu2BYgMbY+N3Ksf8EhoWOCmkfGGB7BwwHOYqHPwCNxAAw4ExwcdrsaTcrPNObiGMzpYUJ7DjbM1zWxQm7JjywOTedPfI4Drsk4ADUSQch2ZHn64cleP6A54lAzvq6pK9lBhXt9+0pcmLsifFpPJRvSYob1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970077; c=relaxed/simple;
	bh=03smAZVJ+ZngbkLzugn+0eqk3vVwA0F29enlttGAPng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b+UY9j8Mm7WZU0IMhvTiR4LD6+duTxYUQuk0cY0K3JBBVql2j37vUExlRsourdkN8+x5RMQ5/OTDh/zd3dGcbRg8WK76bWWC+OG6jdVsw1S9bs+YBuNAURZbhC8GhEpk98+7boHZ4oWV2GmbhLFOypRHisNlg4YjjNbji1ULJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpShr1It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpShr1It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775ACC2BD10;
	Wed, 29 May 2024 08:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970076;
	bh=03smAZVJ+ZngbkLzugn+0eqk3vVwA0F29enlttGAPng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bpShr1IttagkOMnjhsCdo/g2zCZdY/J9hEgnQoOTkwd/TZHIkKASoDSf8+3m+pnEU
	 5dgEnznMnW+pmlqrkv7jTaUFTY8kya1x2kUeM5RGbZFNTb0NPcdTvktgyScpIfQiJz
	 9SYMygauOoY+shIGTFDnwWQBHpng4+D37VR3bFWoOFjpfjsD6ALyH7jGpvSUfQiild
	 6MYzCPhcHg2QsVviU+udRgGt0N3LKskHM5NeZnp90eaxAQpCTzBcjNqXPPgoNsWukV
	 tC4NqjBN6Q6n3ZjWDlVJ+cmaEz8hv6lMBRlGWijOn043mJOWWcO86EQJdQiEIrkwsT
	 sU1UkJ18oQYDg==
Message-ID: <24cad983-a1a0-4983-989d-79bcc9fd8a0a@kernel.org>
Date: Wed, 29 May 2024 17:07:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] sd: simplify the ZBC case in
 provisioning_mode_store
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Don't reset the discard settings to no-op over and over when a user
> writes to the provisioning attribute as that is already the default
> mode for ZBC devices.  In hindsight we should have made writing to
> the attribute fail for ZBC devices, but the code has probably been
> around for far too long to change this now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3dff9150ce11e2..15d0035048d902 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -461,14 +461,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
>  
> -	if (sd_is_zoned(sdkp)) {
> -		sd_config_discard(sdkp, SD_LBP_DISABLE);
> -		return count;
> -	}
> -
>  	if (sdp->type != TYPE_DISK)
>  		return -EINVAL;
>  
> +	/* ignore the proivisioning mode for ZBB devices */

s/proivisioning/provisioning
s/ZBB/ZBC

With that fixed,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +	if (sd_is_zoned(sdkp))
> +		return count;
> +
>  	mode = sysfs_match_string(lbp_mode, buf);
>  	if (mode < 0)
>  		return -EINVAL;

-- 
Damien Le Moal
Western Digital Research

