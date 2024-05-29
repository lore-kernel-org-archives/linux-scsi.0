Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB416A367;
	Wed, 29 May 2024 08:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970421; cv=none; b=mS0kSCKXqEGV05z0PMoYL+vAR0374QxtK9zIeCWWxcQmHz5SKj2Qy24gjtkjpFxzI9mbL48XNTH12JhKz5JqP0/pdOcJfEnwlhpyDHyz/4yB5RRH+N6FZLs+QLwdCqCv7IoFXN0AyF7Gii25qdSSqjM4uD/FSjGy5KM9Lx65MeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970421; c=relaxed/simple;
	bh=QIo4uCV5OL7C/0lr7uj7aSJrY6ALOm2KSU2WDuE+n9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2rp32EoAe8RkPM4hcByHGex41dbnHBQYrG4DS2n6YckfacWswSu3FQne3+8vDnoigWu2YFwJLNzb7qDV9MXTOO8dmMHIYe+CprRXHcPtTmuBydT+aviNKkqJFitEh+f+Keu7Rh/G1YvRisiM1COWO1Y9hoNVx5+FVI+qJE6RH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vs/JsUar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vs/JsUar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D31C2BD10;
	Wed, 29 May 2024 08:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970420;
	bh=QIo4uCV5OL7C/0lr7uj7aSJrY6ALOm2KSU2WDuE+n9Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vs/JsUarWt+IojFVJmO8nf1xEFuiF80vD56DlthacWxH/uEfpxVkJo1Nrcs6QZxxq
	 Pmn0gMPmiWSbKF+Fz7knbH+rHcLuGSe7ESzyXmY7MGFw0ToZ2p3ayTMoQggCPIYWWr
	 MbIzeTTCJHYhB2LGdxbLZD0TC+R1ByZ434lytDh+Xyz5Ge0KqL5crvujQZtunoVYKi
	 Ams3qK54YyXYWj2unBULezBx87cSmwZtQ1w7qW3/AqQIfpG9VhjpHgpg/JcGjxTlgB
	 qC8UPDqbQ6kQNgqB5asVxdm9rrmo7slKA3lDydzmgHK3fffKyb9ERgIY/7/ky4cbSE
	 bwm1JTmXJj9Eg==
Message-ID: <5248688e-4832-4243-b0d3-04ef6f459aa4@kernel.org>
Date: Wed, 29 May 2024 17:13:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] sd: simplify the disable case in sd_config_discard
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
 <20240529050507.1392041-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Fall through to the main call to blk_queue_max_discard_sectors given that
> max_blocks has been initialized to zero above instead of duplicating the
> call.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

