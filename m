Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA82421EFB;
	Fri, 11 Sep 2026 23:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789169128; cv=none; b=EfdejMDjJ2wsbPdb3Sf8yWkQWFFnBKcKQITgdWc6qpXzk8Fc6FJl0fHTFBdB3fj0Hce7zTAPsfB8J0dW1uvjz2rzsnHRc6Y3chbxxWi8S9yfmbsH6jHXSb3u4fOEK2G9RhFmrZFQ0deecJ0a6BPJLcGPw0AaX8fqJ5DMXDWP+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789169128; c=relaxed/simple;
	bh=Vsyosqm+buGtP/cKjZ529iSg2fX2OQXp5eoBGqG9okU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QoDaHRi9bBbdoOlucyoh82LjnJhqqlu7xRGgTJ5k2GEyz/cssPagdC5B0xfs/YUDAWtdGlxr480h2CHLST/hsLQ+uMYz19MkckLHombH2OyxL1epLOaIdNNlPlG8np85WVkmyTG8b8uD8S3KhAV9IiobJFOxz8YN2QjfGRdE8+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fo3lnwE3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fo3lnwE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF251F000FF;
	Fri, 11 Sep 2026 23:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789169126;
	bh=lO2njALp57zuhYptuau2ps9JTH8zf1hVo0qsylxGuZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fo3lnwE3kK11gD7CsH28wdzdsz8aBc/TN/ItO/LPnrf1dUaughFZvoACLfTVOnMyZ
	 kvOUaM1latGz6waQP79XsScB2q0wQ7rRZNEsH+xVxj+/rdWZCYrNXjXQXDHzmH6m64
	 9fqgCE4wsYifADWG+vM5i0yW/pNmpe+hvQO90KmJfHrvSkYmnW1F/kJeaDuhdaBStV
	 plUGhXpnsVpUJRPWqQ+alzTfhqjJNwW0kmBzDD0qWkJTMFw/yrgvC9XA3Q+8ae22DM
	 HU1620H+EWTVw+AV1W7q6GK9RvnydIShWWrwfPWvP8w3G/irbjWYLYKLBoQf9uY/zq
	 HcEzbP1DovpGA==
Message-ID: <540d0904-0e9a-4b34-bc6f-b4f31f3cb3fa@kernel.org>
Date: Sat, 12 Sep 2026 08:25:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: sd_zbc: reject disks with too many zones
To: ZHOU Jiaxiang <26066541r@connect.polyu.hk>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
References: <20260911144614.39553-1-26066541r@connect.polyu.hk>
 <20260911144614.39553-3-26066541r@connect.polyu.hk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260911144614.39553-3-26066541r@connect.polyu.hk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 23:46, ZHOU Jiaxiang wrote:
> sd_zbc_read_zones() computes the number of zones with 64-bit
> arithmetic and stores the result in the unsigned int nr_zones field
> of struct zoned_disk_info, silently truncating counts that exceed 32
> bits. The truncated count is later used to size per-zone resources,
> while the device may still report more zones than fit.
> 
> Reject such devices at scan time: more than 4 billion zones is not
> realistic for any medium that exists today, and accepting the
> truncated count produces inconsistent zone bookkeeping.
> 
> Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>

This needs a Fixes tag.
With that added, please feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
