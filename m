Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE76522AE74;
	Thu, 17 Apr 2025 11:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744888082; cv=none; b=E/0es7LNKFXtPjUb7L1WpKVplGGw/3F3Mu4h7aaJYSSHK9BhJ0tgQyfeBcg62DNcs7WsPGSrmGBJ4RxK6LB1TQjSDN2zGl71D/AIKSlLcAKZf7b91qOt3ivinPzbmhnwBfd+cGyBnllasAvOqcvh/faq4qesqDmzsZVyFvOSyeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744888082; c=relaxed/simple;
	bh=h+LICXNjhfHu8TPfolUm9aYwe1HOqw1+PcyivLYj/sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3VxHZqz5+u2aKLzPnxeHFZwJ7AsbyETFIQIbdSZxAwmb3RFgvILY6VVHlFYLis5Y6IuYV+0axZ/lJ8OSBTGa/nx+uu3HjjIbPjfgFNGouMy1J7MUUXI8dgE5yje2n2cdfx+J+tBU755J6OSfKpFha/7lijoBKkJCbWGErMhGX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDihi8ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDihi8ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA98C4CEE4;
	Thu, 17 Apr 2025 11:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744888082;
	bh=h+LICXNjhfHu8TPfolUm9aYwe1HOqw1+PcyivLYj/sg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dDihi8ZNuMMnfksC+qUjiqTmg2KmN56SFkcm2+4CSW1Bu1cTR6W+XWujissLEcUmK
	 w6J0fijn3TjrRxRHxxlNTdEjS8jiRisqDdY3X+NmvzqhvhT1nzR7rRLllhILsywd7u
	 5P3gdVE6j9TdWxnhnL9yWWEl/EctAk9H1Md2uQRMWKZClEV3icPRUMyM5SZcBjGqJz
	 4NohO//9iD53Ydw61pdpgDUTa1/WBV9/nrn2KFThfD2jkRvJYtbvSXn681p9jOGc4X
	 B3YGFRkZYBNHOGvGd+Or8iKCmxEq3KWTbqNClCG7wnRoOflEQGQv+xckag6zPqAaBs
	 Khg2j/KqdbiBA==
Message-ID: <3c8f7e2a-ba73-4943-8372-0f322aaa3935@kernel.org>
Date: Thu, 17 Apr 2025 20:08:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: Improve CDL control
To: Igor Pylypiv <ipylypiv@google.com>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-4-dlemoal@kernel.org> <aAB3iU7ZuQo5cH9z@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aAB3iU7ZuQo5cH9z@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 12:37, Igor Pylypiv wrote:
> On Wed, Apr 16, 2025 at 05:42:38PM +0900, Damien Le Moal wrote:
>> With ATA devices supporting the CDL feature, using CDL requires that the
>> feature be enabled with a SET FEATURES command. This command is issued
>> as the translated command for the MODE SELECT command issued by
>> scsi_cdl_enable() when the user enables CDL through the device
>> cdl_enable sysfs attribute.
>>
>> However, the implementation of scsi_cdl_enable() always issues a MODE
>> SELECT command for ATA devices when the enable argument is true, even if
>> CDL is already enabled on the device. While this does not cause any
>> issue with using CDL descriptors with read/write commands (the CDL
>> feature will be enabled on the drive), issuing the MODE SELECT command
>> even when the device CDL feature is already enabled will cause a reset
>> of the ATA device CDL statistics log page (as defined in ACS, any CDL
>> enable action must reset the device statistics).
>>
>> Avoid this needless actions (and the implied statistics log page reset)
>> by modifying scsi_cdl_enable() to issue the MODE SELECT command to
>> enable CDL if and only if CDL is not reported as already enabled on the
>> device.
> 
> Hi Damien,
> 
> What happens when a drive spins up with CDL enabled? Last year you sent
> a patch to make sure that CDL gets disabled by default. Is that still
> the case?

Yes, that is unchanged so that we keep being consistent with the fact that the
scsi layer starts with the sysfs cdl_enabled attribute set to false. So if an
ATA device starts with CDL enabled, it will be disabled.

That does not cause any issue with the CDL statistics log page because that page
is not persistent and cleared) on power-on-reset events and this change has no
effect on that. The CDL statistics log page will always be cleared on boot/reboot.


-- 
Damien Le Moal
Western Digital Research
