Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7750C517BD8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650886; cv=none; b=UMOy6j4o6yKusSSVIRx6GVmmOKtnSthDRZsqCGUoGpbZ9sjZqqKNyCygqfUpTlBYhTEvig2jSp0Z/ll7t/C74VkYqlSdWZRe+Pzs3uwFBkjXQheDuUtR38HZ4MIbz+7jDrTnCzaKNXiiwhGfWSz6m7ENjDRkSzDPt9VaGHw62+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650886; c=relaxed/simple;
	bh=wdWNHPbWrLazUlI/vE9bNaTVEAHcJzaXEBER4ELgUh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7TYR6wuXJDiQu6ALVw2J0kMm0H7+9pTZYxNdOExNkMO1eZVVQN+xiA2xvhVkHCSRR09Ey1tlycSkdwl5WCef2krTJKWxlBTXcyNIbzVkzpdGBy3Z0fHryfW1TKR6u57qHWWFSoo+93Reb5zECCAVPenkIfKApGUckNHJgjCq3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kunMZDcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kunMZDcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8C51F000FF;
	Thu, 17 Sep 2026 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650884;
	bh=1yVc76zkv619eI9PJEhy3JMSRuZLlujiS5tUkikuNaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kunMZDcf0hyNlLveC0LleKAwwH48aRKanIMh3uAV+RMWtPNiiUOrdhN7yqHvY6N44
	 BP5w4NecnNPhLTbrz+h/tkx6RUxl66ozLWmt0N5JwaYqJPy/KtNPuyejZ8Gv3Ie81+
	 OoQhGKB7B54iQf+HvEvBpJ9UReWjg/xfF2MUJKp+mNP/oqJ/P9Of7nxDpPsBD7Bg+3
	 hIxnH31DR/5X1J3fQGf3eRjtKv52lq8ANgOneR4Hyfm8N7rd97ti63+O04ZYu8ExXj
	 wfBSyjil1FjjaDW9+GNa014JVWsPiJodkT8AVKzE0iY+vJQNxDz50uBeM364/RpJdD
	 F2bqg0G9IM4PA==
Message-ID: <12d01f4b-4d9f-4079-908d-ede50f7a28b4@kernel.org>
Date: Thu, 17 Sep 2026 20:14:41 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] scsi: scsi_debug: Map the region written by WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-13-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-13-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> When logical block provisioning is enabled, a command that writes user
> data marks the region that it wrote in the provisioning map, so that
> GET LBA STATUS reports the region as mapped. resp_write_dt0(),
> resp_write_scat() and resp_write_same() all call map_region() for that.
> 
> resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
> provisioning map untouched, and GET LBA STATUS keeps reporting the
> region as deallocated after it has been written. map_state(), which
> GET LBA STATUS uses, is the only reader of the map, so that is the whole
> of the effect.
> 
> Call map_region() the way resp_write_dt0() does, and take the zone
> metadata write lock across the access as it does when logical block
> provisioning is enabled. That lock is what serialises the provisioning
> map against resp_unmap(), which holds it while unmap_region() clears map
> bits and zeroes the data that they cover. resp_unmap() does nothing
> unless logical block provisioning is enabled, so the lock is only needed
> in that case.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
