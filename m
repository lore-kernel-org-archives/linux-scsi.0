Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE77139BFF8;
	Wed,  7 Oct 2026 07:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791357249; cv=none; b=UFkMl5xJHbDeEYFbqqe4ssS3EiCIUgJR+WTfQe1GI1C/AvYtLQM6qeC0CWXi7Thjpq4I6dXbiJO1wECqOagDyaUbyIldY/fchrWg3Fkl6AjdEWROepdK7OK45SM1ohnecdP1XblOZwm02IRYe8OP/ZgyxqwwG0PxMEEAuZVv6T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791357249; c=relaxed/simple;
	bh=V1ficGGjgz3RthnSCBL7ZnnHJc6lQghRZE7SRk1Amys=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TRUinEyQkx08/QcKjj11iF7SwbzSJiJ362LWQ+JNuFnSOy2Kz114y8kpMQ/KLvYr60i/LMaj5CjXd5OBFlJTpRj21dVGcclNetpB2AZZN4a7EyRrcNLlskcvGNjk0GMROwHjqDsrJNJ52V7KHhvh0W/dzL/c5rgrVMr8yYOQvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEGqcNjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEGqcNjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638E61F0089B;
	Wed,  7 Oct 2026 07:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791357248;
	bh=u4OF5mYDuuJt5WUqy86drZ3H8npS7yvXrrms+cfWPIs=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=QEGqcNjgaV74kRyN7AHz+BDQjxYvXYN7T2WVl8r08OOT9nfuTGde/P4l1f+PYIfVK
	 VjN4coc+JNzJUsqquRxRYfpdEYhjAYADIA55DXZzsnZXCZN1MniyFgema2leuIt6wG
	 4ORKPJMtn13qRtoggtHq3gtAyqLFlfg6r3Hntd6opC6TynTgMTlJy8zdmFTfFaWYBU
	 q6i1YFdiSIIrkzf+avF1e8AujvbbK3LhzA+Ui8SMnKVf9ItOqO4J7aDczVDT2goASS
	 ivTEpEIILIf5IP3vPbYke7qfNjjo6YQqyzDxym+qwmq465LzndRmtIO/hNiuilya9L
	 oPvTDYZlgQUWw==
Message-ID: <5cbdd6be-017b-4d41-88b8-5cbb2a6e8517@kernel.org>
Date: Wed, 7 Oct 2026 09:14:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Add support for storage element depopulation
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <8be158cd-2199-4538-a05f-7c37ef9f622d@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <8be158cd-2199-4538-a05f-7c37ef9f622d@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/05 13:13, Hannes Reinecke wrote:
> On 10/5/26 11:46 AM, Damien Le Moal wrote:
>> Jens,
>>
>> These patches define a new set of block device operations for generically
>> using from the block layer the storage element depopulation feature of
>> zoned block devices. Support for this feature is added to the SCSI disk
>> driver and an emulation of this feature added to the zloop driver.
>>
>> The management operations can be accessed using block layer API, which is
>> intended for file systems (e.g. zonefs and XFS), as well as using ioctls
>> for users using zoned disks directly from user space.
>>
>> Damien Le Moal (7):
>>    block: fail reads to offline zones early
>>    block: introduce storage element management
>>    block: add storage element management ioctls
>>    zloop: add storage element emulation
>>    zloop: add degrade_element control command
>>    scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
>>    scsi: sd_zbc: define storage element management operations
>>
> I wonder: shouldn't we send a uevent after either operation?
> I guess that this would be helpful for admins, and not forgetting
> udev which might want to re-run any rules the admin might have
> configured.

Maybe. But given that head depop is a user/sysadmin initiated operation, at
least for now, udev/revalidation is something that the user/sysadmin can trigger
too for now.

In the next round, once we get file systems (zonefs and xfs) to initiate depop,
we can add such event notification.



-- 
Damien Le Moal
Western Digital Research
