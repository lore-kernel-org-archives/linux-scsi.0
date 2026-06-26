Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9403BD643
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 22:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782511630; cv=none; b=OBry86VE1zCumcHaT52OHE0nASDbCOKy5S3CLursXwXdczYL/u5SQnZUIaW+bW0c0jPfiH40XhPKxs0L+tNAC3mhfkCZOOTo0cu/uTOyigqZ5XYeASKfBJloszgM5+163i0GeiMWhFeP89CZTzphqjN8w/oDRR+62VEBQBPguxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782511630; c=relaxed/simple;
	bh=7M/NDl/bYGHcD5fs5mrHGhm0bWlPXTC/frP3h81JXmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r9DK3IJWVN+VyYz4zdX/N7nBVxJobSHTaFVSAl2SbuI2jdgMVOhlDgKkhnhp9BMOaiq61pg9S+3hvXusuitObKYXo3T71nLDxqlyBs6kkbxldtjosLfdMy23TEHqvYX7M2Y/oN4dFTeMitBb6zsbXoXdICP3EQtvEeMoDuwWUT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KE+ZbkVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KE+ZbkVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4357D1F000E9;
	Fri, 26 Jun 2026 22:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782511629;
	bh=rQOZ2R74TLdmVhvBfM1X5CWLNIOL9RHf60CLVXzli7Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KE+ZbkVt+sKLZAuGNWKmIf1JDOepkeZpUto7RMyELJ6blOEAViHtWD8HmJeLa+ii5
	 jfK1J15bnJv2Nnf/mMOg+agW7gy4DA7Jnp+LWGR/j8XML6aLomIeZBNFt5Wa+aLgZ0
	 XjXnLCLu+wIgNa4tXf4FKppb8fbE9YcxIMKLEhBOHHTWzD001bNkMBDlTMtpCftrer
	 xTw2vTwpwX3fgvXvd/bIHlCeyQVDE/8y0GGx7eHbXMlpQtfhCeGChcVb+ZsbXgRTrI
	 s9ykFX1tfW2j6OBqFuCADjjIXKOtFjz+Z0qG3gZ0h/ANZ7NUZdSK2gnvpQrJnFN0rd
	 Lvj4+6vxIC0IQ==
Message-ID: <e0b5579a-8626-4178-a838-4dd7ab875ce3@kernel.org>
Date: Sat, 27 Jun 2026 07:07:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] scsi: sd: fix sd_done() sense handling condition
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, tom.leiming@gmail.com, p.raghav@samsung.com,
 sw.prabhu6@gmail.com, linux-scsi@vger.kernel.org
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-5-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260623100159.4018066-5-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 19:01, Yang Xiuwei wrote:
> Commit 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE") replaced
> driver_byte(result) != DRIVER_SENSE with
> !scsi_status_is_check_condition(result) but kept the old OR-shaped
> gate.  That lets CHECK CONDITION with invalid or deferred sense enter
> the sense_key switch with an uninitialized or stale sshdr.
> 
> Only handle sshdr when CHECK CONDITION is indicated and the sense
> data is valid and not deferred.
> 
> Fixes: 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

I think the fixes tag may be wrong, since the driver_byte(result) !=
DRIVER_SENSE test was actually equivalent to
!scsi_status_is_check_condition(result). So it looks like the problem actually
is even older than 464a00c9e0ad.

But I think this is fine.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
