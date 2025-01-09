Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB61891A8;
	Thu,  9 Jan 2025 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449358; cv=none; b=ci/LzkD39dMKt3rAJtUiP0aNYhhSs2E1vY/TVGTySIjfhrYSgorPFAeDrDqQj7UiqI/GH3Npj26IhkuY2778sw9eCU/0KaOA3Msm6XDV/4cyxWDM7yJ5upPG3bp0HdmGgduVFBjB83kQokhqocFvEj0eRBfDzUJucvpmWkE3A/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449358; c=relaxed/simple;
	bh=CCTGoJOWnc/MYwMRcCojhftwdXqRVCYgBzd8FQggOUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9OpGso5hA5Ow++pTsBufgvxrsfWCVnYsEiYgeX6dvapsB9FHSjN2l3+1XO3HV4urA8mElQa3KOMjy5ADxsPvlH/mgFQzapGVTadqHMpfo/I4RBkvslpsTGO8zGY/dg0eM71NUrRmcnsp/H1YqMDWg6WJiLyQCqcoIGujE19gDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3OLkC9l+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3OLkC9l+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YTZ0k12rwzlgTWR;
	Thu,  9 Jan 2025 19:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736449346; x=1739041347; bh=5Jcz49J9an/fkTsGSmQ0+OC4
	cTU9w8k9nv1b/GaBWVg=; b=3OLkC9l+aLWnkNCKOk3otN8lOFQMV+Oe18aE00Jk
	+8rkCmuYdmkccBwiQH05KoeBI3g/9G/Mwur0fofieCH0xhrNtTKLku3v7KbLzAyy
	tjQaeVxGxWeO9W+WTXIEBS/hQatA15MBd+LWzf6VZv1GkUkUbRHkcCFn12F3WPCW
	suXUlLQvJDq0SZZGk1zi8IyGUY491WxOzcueMLOFjxWE+KwmiE9/ys4zX/9jwnGv
	VoSXRd2xSrEERDkGlqjeIeq/BZN9EcyD0LdVpbdD6rkfyjXALgc+dC9Al5BchhAw
	Kr3eH96rwjNAF9NRQdNS1AKzU5W3d6FroOWEGDK9VgCsHQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vMVc0zKKvcFV; Thu,  9 Jan 2025 19:02:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YTZ0c4JrSzlgTWM;
	Thu,  9 Jan 2025 19:02:23 +0000 (UTC)
Message-ID: <cbbcd4b5-0134-4b8b-bd06-d0a2091118f5@acm.org>
Date: Thu, 9 Jan 2025 11:02:22 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 12:01 AM, Damien Le Moal wrote:
> On 11/19/24 09:27, Bart Van Assche wrote:
>> This patch series improves small write IOPS by a factor of four (+300%) for
>> zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Although
>> you are probably busy because the merge window is open, please take a look
>> at this patch series when you have the time. This patch series is organized
>> as follows:
>>   - Bug fixes for existing code at the start of the series.
>>   - The write pipelining support implementation comes after the bug fixes.
> 
> Impressive improvements but the changes are rather invasive. Have you tried
> simpler solution like forcing unplugging a zone write plug from the driver once
> a command is passed to the driver and the driver did not reject it ? It seems
> like this would make everything simpler on the block layer side. But I am not
> sure if the performance gains would be the same.

(replying to an email from two months ago)

Hi Damien,

Here is a strong reason why the simpler solution mentioned above is not
sufficient: if anything goes wrong with the communication between UFS
host controller and UFS device (e.g. a command timeout or a power mode
transition fails) then the SCSI error handler is activated. This results
in ufshcd_err_handler() being called. That function resets both the host
controller and the UFS device (ufshcd_reset_and_restore()). At that time
multiple commands may be outstanding.

In other words, submitting UFS commands in order is not sufficient. An
approach is needed that is compatible with the SCSI error handler and
also that ensures that commands are resubmitted in LBA order per zone
after the SCSI error handler has completed.

The statistics I have access to show that the UFS error handler is
activated infrequently or never on any single device but also that it is
activated a nontrivial number of times across the entire device
population.

Thanks,

Bart.

