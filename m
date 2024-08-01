Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317D1581E9;
	Thu,  1 Aug 2024 07:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722496186; cv=none; b=hYPhfCIKcTV5PNa0mNqX2QR0zZWYNo3p7idcjgzSNTl8lQlNRu9YpzWBi0lMnPD74KlBHCeA3gDGaRqQ4DCk7Bnpw5+StmlLgLabS8+NCCuLd7IVkU/TnYnA1e4DzT4MvO7dq3MGQw86DUEZxEHy62xC7N97VW5Ph5ZcAIxYRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722496186; c=relaxed/simple;
	bh=CkeH46sqIKR73LoK1u2b/fhfFNqwIMZ3lX38+S/HMGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQWkvT/4AYoDfYUitsFWRlLEnrDKA0A6SSJHZUPkouKFFei/KhYkW2ZUo1DhuI/5oQrAsExMlCN9cZVnwhnkAqRWXdw5S4i3obQlSdNVziUx7mazVYDQMKfPaiOr4TOKwMBFNLmpFxpRapmGzgHIrsqxMtfnr9GP7ETio/qGtFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1YEm/D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1YEm/D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7353AC4AF0A;
	Thu,  1 Aug 2024 07:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722496186;
	bh=CkeH46sqIKR73LoK1u2b/fhfFNqwIMZ3lX38+S/HMGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L1YEm/D+840D2WuQnhle3Jy46AUholRS3uGuC1IDg3rYMr0qA41oAzyYKU1E9lxw0
	 9WrFHUTp1CjIu07mW52y5pmL4a0Umg4wCPPA7vUfW2e9Z2Zz6ZvXLKQmPJPjlGCxTm
	 uu9Kq3TQyFi3P+E0FgUv9M4EMhJRk6fG3ZDCoty2luvGl0MtFyRHDKJIqqmK5Nume/
	 jnwupZsXX2RjW9Irg28C6u2ivhgpkpeqz8AtVna5LvTv1tXaTV2VdmsZYI5KqFSduo
	 c3r6K+wCPY9zxq1ACtnOxzp+Ocv6t2+Rk+KVKwUnV1n5Lz0mggJWNzKRebT/tc/ZFf
	 uFYobLqQi847g==
Message-ID: <c4ab8a9e-aca5-43c5-a49b-6bb4307d8757@kernel.org>
Date: Thu, 1 Aug 2024 16:09:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Move sd_read_cpr() out of the q->limits_lock
 region
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Coelho@web.codeaurora.org,
 Luciano <luciano.coelho@intel.com>, Saarinen@web.codeaurora.org,
 Jani <jani.saarinen@intel.com>
References: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240801054234.540532-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/24 2:42 PM, Shin'ichiro Kawasaki wrote:
> Commit 804e498e0496 ("sd: convert to the atomic queue limits API")
> introduced pairs of function calls to queue_limits_start_update() and
> queue_limits_commit_update(). These two functions lock and unlock
> q->limits_lock. In sd_revalidate_disk(), sd_read_cpr() is called after
> queue_limits_start_update() call and before
> queue_limits_commit_update() call. sd_read_cpr() locks q->sysfs_dir_lock
> and &q->sysfs_lock. Then new lock dependencies were created between
> q->limits_lock, q->sysfs_dir_lock and q->sysfs_lock, as follows:
> 
> sd_revalidate_disk
>   queue_limits_start_update
>     mutex_lock(&q->limits_lock)
>   sd_read_cpr
>     disk_set_independent_access_ranges
>       mutex_lock(&q->sysfs_dir_lock)
>       mutex_lock(&q->sysfs_lock)
>       mutex_unlock(&q->sysfs_lock)
>       mutex_unlock(&q->sysfs_dir_lock)
>   queue_limits_commit_update
>     mutex_unlock(&q->limits_lock)
> 
> However, the three locks already had reversed dependencies in other
> places. Then the new dependencies triggered the lockdep WARN "possible
> circular locking dependency detected" [1]. This WARN was observed by
> running the blktests test case srp/002.
> 
> To avoid the WARN, move the sd_read_cpr() call in sd_revalidate_disk()
> after the queue_limits_commit_update() call. In other words, move the
> sd_read_cpr() call out of the q->limits_lock region.
> 
> [1] https://lore.kernel.org/linux-scsi/vlmv53ni3ltwxplig5qnw4xsl2h6ccxijfbqzekx76vxoim5a5@dekv7q3es3tx/
> 
> Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Given that sd_read_cpr() does not change any limit, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

