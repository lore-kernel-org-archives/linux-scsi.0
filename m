Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AE627EC7D
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749644979; cv=none; b=kmUetIFMrWfsQA3dxjVdbh5e1s5YrqvGRpIIq+T3kWMo1k/jK5LGzZ1b742buU1FkFs9VFWx13FQ9NE4bJlm2Xr8zFBi8piNZJi4eJTcRtMBUT2cIqWTNnBcNTQE+IECbXPYQZk5e2N41DO1HVQeOENbR5Q0ZJecMPgDUlfzKY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749644979; c=relaxed/simple;
	bh=GFDUIs0G7InWN6hSXxayNcp4cF+MBsQGgbz08nb+GZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C/Yjp9Uj/ZwY7M1NRSgBOoG8Gc+ak0AZwU5BGTJgvp4AKmKJE3t8J44DnyHgzkMfxnPXf87jRJsLhq/5HA+Og3dZgKOeB9YnfYeOT6rhxifCMJWZoitWqigN5wGd+UqOIWa9jfDbeeqm0iKPp5U22hR1bJV12zH/CdxKH7rEuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZtdR8iN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZtdR8iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D6DC4CEEE;
	Wed, 11 Jun 2025 12:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749644978;
	bh=GFDUIs0G7InWN6hSXxayNcp4cF+MBsQGgbz08nb+GZk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=gZtdR8iNfP61CM/VL4B9EiaqpSAt+d2885jprubAunSuBxqNzHkpkwrOSz9nHTavR
	 kQ1LUWnygFYrLR3QV5LVAj372kUGtFZ6g7voVZ6uVjiBg1p1kCae1KT6fbtyoNWT2k
	 mOMDQS/aIl0WeCXTVc9Sr9UaxU2S5VMOwL7IlI9IO5w33aL4GYaNtNtkFgCbGt+2ww
	 um4RtSTyk4/o94EUcQvKqC0EJZzRt132e0wgUOgEHNQrvyGykPAiuhkPYohYRJGx0x
	 JPGoHAb/SoIPlSXgpxJD3lLk4ZCmscI0Mk5iVdQx8coAC1nc0QxxuTZS6sTpJZ1Ot9
	 mR0WCzPnuIGfw==
Message-ID: <b4688690-2b56-4053-acaa-e9e491564889@kernel.org>
Date: Wed, 11 Jun 2025 21:29:33 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Set a default optimal IO size if one is not
 defined
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20250611073905.2173785-1-dlemoal@kernel.org>
 <cac8143b-f321-46e3-b164-7ee6f5b1c88b@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cac8143b-f321-46e3-b164-7ee6f5b1c88b@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 19:23, Johannes Thumshirn wrote:
> On 11.06.25 09:43, Damien Le Moal wrote:
>> +	if (!lim->io_opt) {
>> +		lim->io_opt = ALIGN_DOWN(lim->max_sectors << SECTOR_SHIFT,
>> +					 sdkp->physical_block_size - 1);
>> +		sd_first_printk(KERN_WARNING, sdkp,
>> +			"Using default optimal transfer size of %u bytes\n",
>> +			lim->io_opt);
> 
> Is warning really a good logging level here? There now will be a warning 
> for every ATA device in the system.
> 
> I'd lower it to info.

You are absolutely right. Sending v2.

> 
> Otherwise,
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


-- 
Damien Le Moal
Western Digital Research
